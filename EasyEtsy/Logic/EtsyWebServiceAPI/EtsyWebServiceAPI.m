//
//  EtsyWebServiceAPI.m
//  EasyEtsy
//
//  Created by Artem Kalinovsky on 26/08/2015.
//  Copyright (c) 2015 Artem Kalinovsky. All rights reserved.
//

#import "EtsyWebServiceAPI.h"
#import "SVProgressHUD.h"
#import "ListingCategory.h"
#import "Listing.h"
#import "AFURLResponseSerialization.h"
#import "AFHTTPSessionManager.h"

@implementation EtsyWebServiceAPI

#pragma mark - Singleton Methods

+ (instancetype)sharedManager {
    static EtsyWebServiceAPI *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

#pragma mark - Public API Methods

- (void)fetchDataForAPIModelName:(APIModelName)apiModelName
                      parameters:(NSDictionary *)parameters
                      completion:(EtsyWebServiceAPIResponse)completion {

    NSMutableDictionary *params = [@{@"api_key" : EtsyAPISecurity.APIKey} mutableCopy];
    NSString *urlString;

    if (apiModelName == APIModelNameListing && parameters) {
        urlString = [EtsyAPIURL.base stringByAppendingString:EtsyAPIURL.activeListings];
        [params addEntriesFromDictionary:parameters];
    } else if (apiModelName == APIModelNameCategory) {
        urlString = [EtsyAPIURL.base stringByAppendingString:EtsyAPIURL.categories];
    }

    NSURL *URL = [NSURL URLWithString:urlString];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    __weak typeof(self) weakSelf = self;
    [SVProgressHUD show];
    [manager GET:URL.absoluteString
      parameters:params
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             NSArray *fetchedResults = responseObject[@"results"];
             NSArray *parsedModels = [weakSelf parseFetchedJSONModels:fetchedResults
                                                      forAPIModelName:apiModelName];
             dispatch_async(dispatch_get_main_queue(), ^{
                 completion(parsedModels, nil);
                 [SVProgressHUD dismiss];
             });
         } failure:^(NSURLSessionTask *operation, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, error);
                    [SVProgressHUD dismiss];
                });
            }];
}

#pragma mark - Private Methods

- (NSArray *)parseFetchedJSONModels:(NSArray *)jsonSerializedModels
                    forAPIModelName:(APIModelName)fetchedModelName {

    NSMutableArray *parsedModels = [[NSMutableArray alloc] init];

    for (NSDictionary *jsonSerializedModel in jsonSerializedModels) {
        @try {
            switch (fetchedModelName) {
                case APIModelNameCategory: {
                    ListingCategory *listingCategory = [[ListingCategory alloc] initWithJSON:jsonSerializedModel];
                    [parsedModels addObject:listingCategory];
                    break;
                }
                case APIModelNameListing: {
                    Listing *listing = [[Listing alloc] initWithJSON:jsonSerializedModel];
                    [parsedModels addObject:listing];
                    break;
                }
                default:
                    NSLog(@"Trying to parse unknown model.");
                    break;
            }
        }
        @catch (NSException *e) {

        }
    }
    return parsedModels;
}

@end
