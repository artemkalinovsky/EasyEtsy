//
//  SearchResultsViewController.m
//  EasyEtsy
//
//  Created by  Artem Kalinovsky on 8/27/15.
//  Copyright (c) 2015 Artem Kalinovsky. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "Constants.h"
#import "ListingCollectionViewCell.h"
#import "EtsyWebServiceAPI.h"
#import "SingleListingDetailsViewController.h"
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>

typedef NS_ENUM(NSInteger, UIRefreshControlTag) {
    UIRefreshControlTagTop,
    UIRefreshControlTagBottom
};

struct Pagination
{
    NSInteger limit;
    NSInteger offset;
};

@interface SearchResultsViewController () <UICollectionViewDelegate, UICollectionViewDataSource> {
    struct Pagination pagination;
}

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray *fetchedActiveListings;
@property (strong, nonatomic) UIImage *selectedListingImage;
@property (assign, nonatomic) NSUInteger selectedListingIndex;

@end

@implementation SearchResultsViewController

- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        _refreshControl.tintColor = [UIColor grayColor];
        _refreshControl.tag = UIRefreshControlTagTop;
    }
    return _refreshControl;
}

- (NSArray *)fetchedActiveListings {
    if (!_fetchedActiveListings) {
        _fetchedActiveListings = [[NSArray alloc] init];
    }
    return _fetchedActiveListings;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pagination.limit = 50;
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

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedListingIndex = (NSUInteger) indexPath.row;
    [self performSegueWithIdentifier:toSingleListingDetailsSegue sender:self];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.fetchedActiveListings.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ListingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:listingCellReuseIdentifier
                                                                                forIndexPath:indexPath];
    Listing *listing = self.fetchedActiveListings[(NSUInteger) indexPath.row];
    [cell configureWithListing:listing];
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:toSingleListingDetailsSegue]) {
        Listing *selectedListing = self.fetchedActiveListings[self.selectedListingIndex];
        SingleListingDetailsViewController *destinationVC = segue.destinationViewController;
        destinationVC.detailedListing = selectedListing;
    }
}

#pragma mark - IBActions

- (void)refreshActionWithSender:(UIRefreshControl *)sender {
    [self.refreshControl endRefreshing];
    [self.collectionView.bottomRefreshControl endRefreshing];

    if (sender.tag == UIRefreshControlTagTop) {
        NSInteger numberOfWatchedPages = (pagination.limit + pagination.offset) / pagination.limit -1;
        if (numberOfWatchedPages > 0) {
            pagination.limit = pagination.limit * numberOfWatchedPages;
        }
        pagination.offset = 0;
    } else if (sender.tag == UIRefreshControlTagBottom) {
        pagination.offset = pagination.limit;
        pagination.limit = 50;
    }

    NSMutableDictionary *searchParamsWithPagination = [@{@"limit" : @(pagination.limit),
            @"offset" : @(pagination.offset)} mutableCopy];
    [searchParamsWithPagination addEntriesFromDictionary:self.searchParams];
    __weak typeof(self) weakSelf = self;
    [[EtsyWebServiceAPI sharedManager] fetchDataForAPIModelName:APIModelNameListing
                                                     parameters:searchParamsWithPagination
                                                     completion:^(NSArray *listings, NSError *error) {
                                                         if (!error && listings) {
                                                             if (sender.tag == UIRefreshControlTagBottom) {
                                                                 NSMutableArray *mutableListings = [weakSelf.fetchedActiveListings mutableCopy];
                                                                 [mutableListings addObjectsFromArray:listings];
                                                                 weakSelf.fetchedActiveListings = [mutableListings copy];
                                                                 pagination.offset += pagination.limit;
                                                             } else if (sender.tag == UIRefreshControlTagTop) {
                                                                 weakSelf.fetchedActiveListings = listings;
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
