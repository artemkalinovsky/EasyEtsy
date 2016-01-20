//
//  SavedListingsCollectionViewController.m
//  EasyEtsy
//
//  Created by Artem Kalinovsky on 29/08/2015.
//  Copyright (c) 2015 Artem Kalinovsky. All rights reserved.
//

#import "SavedListingsCollectionViewController.h"
#import "Constants.h"
#import "ListingCollectionViewCell.h"
#import "SingleListingDetailsViewController.h"
#import "NSManagedObjectContext+MagicalRecord.h"
#import "Listing+Extensions.h"
#import "NSManagedObject+MagicalFinders.h"

@interface SavedListingsCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property(strong, nonatomic) NSArray *fetchedActiveListings;
@property(strong, nonatomic) UIImage *selectedListingImage;
@property(assign, nonatomic) NSUInteger selectedListingIndex;

@end

@implementation SavedListingsCollectionViewController

- (NSArray *)fetchedActiveListings {
    if (!_fetchedActiveListings) {
        _fetchedActiveListings = [[NSArray alloc] init];
    }
    return _fetchedActiveListings;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.fetchedActiveListings = [Listing MR_findAllInContext:[NSManagedObjectContext MR_rootSavingContext]];
    [self.collectionView reloadData];
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

@end
