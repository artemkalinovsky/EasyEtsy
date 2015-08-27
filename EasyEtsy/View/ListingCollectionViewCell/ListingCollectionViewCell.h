//
//  ListingCollectionViewCell.h
//  EasyEtsy
//
//  Created by  Artem Kalinovsky on 8/27/15.
//  Copyright (c) 2015 Artem Kalinovsky. All rights reserved.
//

@import UIKit;

@class Listing;

extern NSString* const listingCellReuseIdentifier;

@interface ListingCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic, readonly) UIImage *listingImage;

- (void)configureWithListing:(Listing *)listing;

@end
