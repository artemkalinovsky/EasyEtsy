//
//  SingleListingDetailsViewController.m
//  EasyEtsy
//
//  Created by Artem Kalinovsky on 28/08/2015.
//  Copyright (c) 2015 Artem Kalinovsky. All rights reserved.
//

#import "SingleListingDetailsViewController.h"
#import "Listing+Extensions.h"

@interface SingleListingDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *listingImageView;
@property (weak, nonatomic) IBOutlet UILabel *listingNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *listingPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listingDetailedDescriptionLabel;

@end

@implementation SingleListingDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.listingImageView.image = self.detailedListingImage;
    self.listingNameLabel.text = self.detailedListing.name;
    self.listingPriceLabel.text = [NSString stringWithFormat:@"%@ %@", self.detailedListing.price, self.detailedListing.priceCurrency];
    self.listingDetailedDescriptionLabel.text = self.detailedListing.detailedDescription;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
