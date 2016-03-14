//
//  Pagination.h
//  EasyEtsy
//
//  Created by Artem on 3/14/16.
//  Copyright © 2016 Artem Kalinovsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pagination : NSObject

@property (assign, nonatomic, readonly) NSInteger limit;
@property (assign, nonatomic, readonly) NSInteger offset;

- (instancetype)initWithLimit:(NSInteger)limit andOffset:(NSInteger)offset;

- (void)prepareForPageRefreshing;
- (void)prepareForNextPageLoading;
- (void)handleNextPageLoadingResults;

@end
