//
//  SingleListingDetailsViewController.h
//  EasyEtsy
//
//  Created by Artem Kalinovsky on 28/08/2015.
//  Copyright (c) 2015 Artem Kalinovsky. All rights reserved.
//

@import UIKit;

@class Listing;

@interface SingleListingDetailsViewController : UITableViewController

@property (strong, nonatomic) Listing *detailedListing;
@property (strong, nonatomic) UIImage *detailedListingImage;

@end
