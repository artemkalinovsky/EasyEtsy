//
//  Listing+Extensions.m
//  EasyEtsy
//
//  Created by  Artem Kalinovsky on 8/27/15.
//  Copyright (c) 2015 Artem Kalinovsky. All rights reserved.
//

#import <AFNetworking/AFURLRequestSerialization.h>
#import <AFNetworking/AFHTTPRequestOperation.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "Listing+Extensions.h"
#import "TFHpple.h"

@implementation Listing (Extensions)

- (void)fetchImagePathFromURLString:(NSString *)url
                    completionBlock:(void (^)(NSString *imageURLString, NSError *error))completion {


    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET"
                                                                          URLString:url
                                                                         parameters:nil
                                                                              error:nil];

    AFHTTPRequestOperation *afhttpRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    afhttpRequestOperation.responseSerializer = [AFHTTPResponseSerializer serializer];

    [afhttpRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                TFHpple *doc = [[TFHpple alloc] initWithHTMLData:responseObject];
                NSArray *elements = [doc searchWithXPathQuery:@"//meta[@property='og:image']"];
                TFHppleElement * element = [elements firstObject];
                NSString *photoURLString = element.attributes[@"content"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(photoURLString, nil);
                    [SVProgressHUD dismiss];
                });
            }
                                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               [SVProgressHUD dismiss];
                                                               completion(nil, error);
                                                           });
                                                       }];

    [[NSOperationQueue mainQueue] addOperation:afhttpRequestOperation];
    [SVProgressHUD show];
    [afhttpRequestOperation resume];
}

@end
