//
//  EasyEtsyTests.m
//  EasyEtsyTests
//
//  Created by Artem Kalinovsky on 26/08/2015.
//  Copyright (c) 2015 Artem Kalinovsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <KIF/KIF.h>

@interface EasyEtsyTests : KIFTestCase

@end

@implementation EasyEtsyTests

- (void)testSearchListings
{
    [tester enterText:@"The Beatles" intoViewWithAccessibilityLabel:@"Search"];
    [tester tapViewWithAccessibilityLabel:@"Submit"];
    [tester waitForTappableViewWithAccessibilityLabel:@"Search Results"];
}

@end
