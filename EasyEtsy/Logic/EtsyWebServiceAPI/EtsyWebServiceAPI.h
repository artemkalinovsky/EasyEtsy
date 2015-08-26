//
//  EtsyWebServiceAPI.h
//  EasyEtsy
//
//  Created by Artem Kalinovsky on 26/08/2015.
//  Copyright (c) 2015 Artem Kalinovsky. All rights reserved.
//

@import Foundation;

typedef void (^EtsyWebServiceAPIResponse)(NSArray *, NSError *);

@interface EtsyWebServiceAPI : NSObject

+ (instancetype)sharedManager;

- (void)fetchListingCategoriesWithCompletion:(EtsyWebServiceAPIResponse)completionBlock;
- (void)cancelRequest;

@end
