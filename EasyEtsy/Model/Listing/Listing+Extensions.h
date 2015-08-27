//
//  Listing+Extensions.h
//  EasyEtsy
//
//  Created by  Artem Kalinovsky on 8/27/15.
//  Copyright (c) 2015 Artem Kalinovsky. All rights reserved.
//

#import "Listing.h"

@interface Listing (Extensions)

- (void)fetchImagePathFromURLString:(NSString *)url
                    completionBlock:(void (^)(NSString *imageURLString, NSError *error))completion;

@end
