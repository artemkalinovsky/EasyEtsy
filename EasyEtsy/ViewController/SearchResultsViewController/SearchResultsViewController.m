//
//  SearchResultsViewController.m
//  EasyEtsy
//
//  Created by  Artem Kalinovsky on 8/27/15.
//  Copyright (c) 2015 Artem Kalinovsky. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "ListingCollectionViewCell.h"
#import "EtsyWebServiceAPI.h"

@interface SearchResultsViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property(strong, nonatomic) NSArray *fetchedActiveListings;
@end

@implementation SearchResultsViewController

- (NSArray *)fetchedActiveListings {
    if (!_fetchedActiveListings) {
        _fetchedActiveListings = [[NSArray alloc] init];
    }
    return _fetchedActiveListings;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;

    // Register cell classes
//    [self.collectionView registerClass:[ListingCollectionViewCell class]
//            forCellWithReuseIdentifier:listingCellReuseIdentifier];
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

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {

}
*/

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

}

@end
