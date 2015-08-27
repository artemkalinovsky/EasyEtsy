//
//  EtsyWebServiceAPI.h
//  EasyEtsy
//
//  Created by Artem Kalinovsky on 26/08/2015.
//  Copyright (c) 2015 Artem Kalinovsky. All rights reserved.
//

@import Foundation;

@class Listing;

typedef void (^EtsyWebServiceAPIResponse)(NSArray *, NSError *);

@interface EtsyWebServiceAPI : NSObject

+ (instancetype)sharedManager;

- (void)fetchListingCategoriesWithCompletion:(EtsyWebServiceAPIResponse)completionBlock;

- (void)fetchActiveListingsWithParameters:(NSDictionary *)parameters
                               completion:(EtsyWebServiceAPIResponse)completionBlock;

- (void)fetchImageURLForListing:(Listing *)listing
                     completion:(void (^)(NSString *imageURLString, NSError *error))completionBlock;

- (void)cancelRequest;

@end
