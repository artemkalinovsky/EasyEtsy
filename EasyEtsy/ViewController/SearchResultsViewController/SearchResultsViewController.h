//
//  SearchResultsViewController.h
//  EasyEtsy
//
//  Created by  Artem Kalinovsky on 8/27/15.
//  Copyright (c) 2015 Artem Kalinovsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListingsCollectionBaseViewController.h"

@interface SearchResultsViewController : ListingsCollectionBaseViewController

@property (strong, nonatomic) NSDictionary *searchParams;

@end
