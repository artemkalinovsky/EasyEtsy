//
//  Listing+Extensions.m
//  EasyEtsy
//
//  Created by  Artem Kalinovsky on 8/27/15.
//  Copyright (c) 2015 Artem Kalinovsky. All rights reserved.
//

#import <AFNetworking/AFURLRequestSerialization.h>
#import "Listing+Extensions.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "EtsyWebServiceAPI.h"
#import "AFURLResponseSerialization.h"
#import "AFHTTPSessionManager.h"

@implementation Listing (Extensions)

- (void)fetchListingImageWithCompletion:(void (^)(UIImage *image))completion {
    __weak typeof(self) weakSelf = self;
    if (!self.imageURLString) {
        [self fetchImageURLWithCompletion:^(NSString *imageURL, NSError *error) {
                                                            if (!error && imageURL) {
                                                                weakSelf.imageURLString = imageURL;
                                                                [weakSelf downloadListingImageWithCompletion:completion];
                                                            };
                                                        }];
    } else {
        [self downloadListingImageWithCompletion:completion];
    }
}

- (void)fetchImageURLWithCompletion:(void (^)(NSString *imageURLString, NSError *error))completionBlock {

    NSDictionary *params = @{@"api_key" : EtsyAPISecurity.APIKey};

    NSString *urlString = [[EtsyAPIURL.base stringByAppendingString:EtsyAPIURL.listingImages] stringByReplacingOccurrencesOfString:@":listing_id"
                                                                                                                        withString:self.listingId.stringValue];
    NSURL *URL = [NSURL URLWithString:urlString];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    __weak typeof(self) weakSelf = self;
    [manager GET:URL.absoluteString
      parameters:params
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
                NSArray *listingImagesResponse = responseObject[@"results"];
                NSString *fullImageURLString = [weakSelf fetchFullSizedImageURLFromImagesResponse:listingImagesResponse];
                completionBlock(fullImageURLString, nil);
         } failure:^(NSURLSessionTask *operation, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(nil, error);
                });
            }];
}

- (void)downloadListingImageWithCompletion:(void (^)(UIImage *image))completion {
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.imageURLString]
                                                    options:0
                                                   progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                   }
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                      if (image) {
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              completion(image);
                                                          });
                                                      }
                                                  }];
}

- (NSString *)fetchFullSizedImageURLFromImagesResponse:(NSArray *)imagesResponse {
    NSString *url = nil;
    for (NSDictionary *listingImageDict in imagesResponse) {
        if ([listingImageDict[@"rank"] isEqual:@1]) {
            url = listingImageDict[@"url_fullxfull"];
            return url;
        }
    }
    return url;
}

@end
