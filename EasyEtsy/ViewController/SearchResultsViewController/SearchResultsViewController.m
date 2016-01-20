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

@interface SearchResultsViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

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

    [self.refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    __weak typeof(self) weakSelf = self;
    [[EtsyWebServiceAPI sharedManager] fetchActiveListingsWithParameters:self.searchParams
                                                              completion:^(NSArray *listings, NSError *error) {
                                                                  if (!error && listings) {
                                                                      weakSelf.fetchedActiveListings = listings;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedListingIndex = (NSUInteger) indexPath.row;
    ListingCollectionViewCell *cell = (ListingCollectionViewCell *) [self.collectionView cellForItemAtIndexPath:indexPath];
    self.selectedListingImage = cell.listingImage;
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
        destinationVC.detailedListingImage = self.selectedListingImage;
    }
}

#pragma mark - IBActions

- (void)refreshAction {
    [self.refreshControl endRefreshing];
    __weak typeof(self) weakSelf = self;
    [[EtsyWebServiceAPI sharedManager] fetchActiveListingsWithParameters:self.searchParams
                                                              completion:^(NSArray *listings, NSError *error) {
                                                                  if (!error && listings) {
                                                                      weakSelf.fetchedActiveListings = listings;
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
