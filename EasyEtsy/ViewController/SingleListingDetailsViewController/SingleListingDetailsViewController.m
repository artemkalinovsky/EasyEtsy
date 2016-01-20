//
//  SingleListingDetailsViewController.m
//  EasyEtsy
//
//  Created by Artem Kalinovsky on 28/08/2015.
//  Copyright (c) 2015 Artem Kalinovsky. All rights reserved.
//

#import <MagicalRecord/MagicalRecord/MagicalRecord+Actions.h>
#import "SingleListingDetailsViewController.h"
#import "Listing+Extensions.h"
#import "NSManagedObject+MagicalRecord.h"
#import "NSManagedObject+MagicalFinders.h"
#import "NSManagedObjectContext+MagicalRecord.h"

@interface SingleListingDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *listingImageView;
@property (weak, nonatomic) IBOutlet UILabel *listingNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *listingPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listingDetailedDescriptionLabel;

@end

@implementation SingleListingDetailsViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"listingId == %@", self.detailedListing.listingId];
    NSArray *savedListings = [Listing MR_findAllInContext:[NSManagedObjectContext MR_rootSavingContext]];
    if ([savedListings filteredArrayUsingPredicate:predicate].count == 0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                               target:self
                                                                                               action:@selector(tapOnSaveBarButton:)];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                                               target:self
                                                                                               action:@selector(tapOnTrashBarButton:)];
    }

    self.listingImageView.image = self.detailedListingImage;
    self.listingNameLabel.text = self.detailedListing.name;
    self.listingPriceLabel.text = [NSString stringWithFormat:@"%@ %@", self.detailedListing.price, self.detailedListing.priceCurrency];
    self.listingDetailedDescriptionLabel.text = self.detailedListing.detailedDescription;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - IBActions

- (IBAction)tapOnSaveBarButton:(UIBarButtonItem *)sender {

    [self.detailedListing saveToBookmarks];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                                           target:self
                                                                                           action:@selector(tapOnTrashBarButton:)];
}

- (IBAction)tapOnTrashBarButton:(UIBarButtonItem *)sender {
    [self.detailedListing removeFromBookmarks];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
