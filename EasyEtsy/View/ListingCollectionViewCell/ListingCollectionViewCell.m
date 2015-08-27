//
//  ListingCollectionViewCell.m
//  EasyEtsy
//
//  Created by  Artem Kalinovsky on 8/27/15.
//  Copyright (c) 2015 Artem Kalinovsky. All rights reserved.
//

#import "ListingCollectionViewCell.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "Listing.h"

NSString* const listingCellReuseIdentifier = @"listingCollectionViewCell";

@interface ListingCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *listingImageView;
@property (weak, nonatomic) IBOutlet UILabel *listingNameLabel;
@end

@implementation ListingCollectionViewCell

- (void)configureWithListing:(Listing *)listing {

    self.listingNameLabel.text = listing.name;

    [self.listingImageView sd_setImageWithURL:[NSURL URLWithString:listing.imageURLString]
                             placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    }];
}

@end
