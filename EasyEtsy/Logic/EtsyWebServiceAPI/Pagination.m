//
//  Pagination.m
//  EasyEtsy
//
//  Created by Artem on 3/14/16.
//  Copyright © 2016 Artem Kalinovsky. All rights reserved.
//

#import "Pagination.h"

@interface Pagination()

@property (assign, nonatomic, readwrite) NSInteger initializedWithLimit;
@property (assign, nonatomic, readwrite) NSInteger limit;
@property (assign, nonatomic, readwrite) NSInteger offset;

@end

@implementation Pagination

- (instancetype)initWithLimit:(NSInteger)limit andOffset:(NSInteger)offset {
    if (self = [super init]) {
        self.initializedWithLimit = self.limit = limit;
        self.offset = offset;
    }
    return self;
}

- (void)prepareForPageRefreshing {
    NSInteger numberOfWatchedPages = (self.limit + self.offset) / self.limit - 1;
    if (numberOfWatchedPages > 0) {
        self.limit = self.limit * numberOfWatchedPages;
    }
    self.offset = 0;
}

- (void)prepareForNextPageLoading {
    self.offset = self.limit;
    self.limit = self.initializedWithLimit;
}

- (void)handleNextPageLoadingResults {
    self.offset += self.limit;
}

@end
