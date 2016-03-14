//
// Created by Artem on 3/11/16.
// Copyright (c) 2016 Artem Kalinovsky. All rights reserved.
//

#import "ListingsCollectionBaseViewController.h"
#import "ListingCollectionViewCell.h"
#import "Constants.h"
#import "SingleListingDetailsViewController.h"

@interface ListingsCollectionBaseViewController ()

@property (strong, nonatomic) Listing *selectedListing;

@end

@implementation ListingsCollectionBaseViewController

- (NSArray *)listingsArray {
    if (!_listingsArray) {
        _listingsArray = [[NSArray alloc] init];
    }
    return _listingsArray;
}

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedListing = self.listingsArray[indexPath.row];
    [self performSegueWithIdentifier:toSingleListingDetailsSegue sender:self];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listingsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ListingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ListingCollectionViewCell reuseIdentifier]
                                                                                forIndexPath:indexPath];
    Listing *listing = self.listingsArray[(NSUInteger) indexPath.row];
    [cell configureWithListing:listing];
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:toSingleListingDetailsSegue]) {
        SingleListingDetailsViewController *destinationVC = segue.destinationViewController;
        destinationVC.detailedListing = self.selectedListing;
    }
}

@end