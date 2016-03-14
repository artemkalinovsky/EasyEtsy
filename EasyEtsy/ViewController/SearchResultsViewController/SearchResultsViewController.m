//
//  SearchResultsViewController.m
//  EasyEtsy
//
//  Created by  Artem Kalinovsky on 8/27/15.
//  Copyright (c) 2015 Artem Kalinovsky. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "EtsyWebServiceAPI.h"
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>
#import "Pagination.h"

typedef NS_ENUM(NSInteger, UIRefreshControlTag) {
    UIRefreshControlTagTop,
    UIRefreshControlTagBottom
};

@interface SearchResultsViewController ()

@property (strong, nonatomic) Pagination *pagination;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation SearchResultsViewController

- (Pagination *)pagination {
    if (!_pagination) {
        _pagination = [[Pagination alloc] initWithLimit:50 andOffset:0];
    }
    return _pagination;
}

- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        _refreshControl.tintColor = [UIColor grayColor];
        _refreshControl.tag = UIRefreshControlTagTop;
    }
    return _refreshControl;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.refreshControl addTarget:self action:@selector(refreshActionWithSender:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIRefreshControl *bottomRefreshControl = [UIRefreshControl new];
    bottomRefreshControl.tag = UIRefreshControlTagBottom;
    [bottomRefreshControl addTarget:self action:@selector(refreshActionWithSender:) forControlEvents:UIControlEventValueChanged];
    self.collectionView.bottomRefreshControl = bottomRefreshControl;
    [self refreshActionWithSender:self.refreshControl];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.collectionView.bottomRefreshControl removeTarget:self
                                                    action:@selector(refreshActionWithSender:)
                                          forControlEvents:UIControlEventValueChanged];
    [super viewDidDisappear:animated];
}

#pragma mark - IBActions

- (void)refreshActionWithSender:(UIRefreshControl *)sender {
    [self.refreshControl endRefreshing];
    [self.collectionView.bottomRefreshControl endRefreshing];

    if (sender.tag == UIRefreshControlTagTop) {
        [self.pagination prepareForPageRefreshing];
    } else if (sender.tag == UIRefreshControlTagBottom) {
        [self.pagination prepareForNextPageLoading];
    }

    NSMutableDictionary *searchParamsWithPagination = [@{@"limit" : @(self.pagination.limit),
                                                         @"offset" : @(self.pagination.offset)} mutableCopy];

    [searchParamsWithPagination addEntriesFromDictionary:self.searchParams];
    __weak typeof(self) weakSelf = self;
    [[EtsyWebServiceAPI sharedManager] fetchDataForAPIModelName:APIModelNameListing
                                                     parameters:searchParamsWithPagination
                                                     completion:^(NSArray *listings, NSError *error) {
                                                         if (!error && listings) {
                                                             if (sender.tag == UIRefreshControlTagBottom) {
                                                                 NSMutableArray *mutableListings = [weakSelf.listingsArray mutableCopy];
                                                                 [mutableListings addObjectsFromArray:listings];
                                                                 weakSelf.listingsArray = [mutableListings copy];
                                                                 [weakSelf.pagination handleNextPageLoadingResults];
                                                             } else if (sender.tag == UIRefreshControlTagTop) {
                                                                 weakSelf.listingsArray = listings;
                                                             }
                                                             [weakSelf.collectionView reloadData];
                                                         } else {
                                                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                             message:error.localizedDescription
                                                                                                            delegate:self
                                                                                                   cancelButtonTitle:@"OK"
                                                                                                   otherButtonTitles:nil];
                                                             [alert show];
                                                         }
                                                     }];
}

@end
