//
//  ListingCollectionViewCell.m
//  EasyEtsy
//
//  Created by  Artem Kalinovsky on 8/27/15.
//  Copyright (c) 2015 Artem Kalinovsky. All rights reserved.
//

#import "ListingCollectionViewCell.h"
#import "Listing+Extensions.h"
#import "EtsyWebServiceAPI.h"

@interface ListingCollectionViewCell ()

@property(weak, nonatomic) IBOutlet UIImageView *listingImageView;
@property(weak, nonatomic) IBOutlet UILabel *listingNameLabel;

@end

@implementation ListingCollectionViewCell

+ (NSString *)reuseIdentifier {
    return @"listingCollectionViewCell";
}

- (void)configureWithListing:(Listing *)listing {
    self.listingNameLabel.text = listing.name;

    __weak typeof(self) weakSelf = self;
    [listing fetchListingImageWithCompletion:^(UIImage *image) {
        weakSelf.listingImageView.image = image;
    }];
}

@end
