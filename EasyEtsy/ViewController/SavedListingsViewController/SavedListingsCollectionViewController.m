//
//  SavedListingsCollectionViewController.m
//  EasyEtsy
//
//  Created by Artem Kalinovsky on 29/08/2015.
//  Copyright (c) 2015 Artem Kalinovsky. All rights reserved.
//

#import "SavedListingsCollectionViewController.h"
#import "NSManagedObjectContext+MagicalRecord.h"
#import "Listing+Extensions.h"
#import "NSManagedObject+MagicalFinders.h"

@interface SavedListingsCollectionViewController ()

@end

@implementation SavedListingsCollectionViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    super.listingsArray = [Listing MR_findAllInContext:[NSManagedObjectContext MR_rootSavingContext]];
    [super.collectionView reloadData];
}

@end
