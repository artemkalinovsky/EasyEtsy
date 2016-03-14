//
//  UILabel+UILabelDynamicHeight.m
//  EasyEtsy
//
//  Created by Artem Kalinovsky on 21/01/2016.
//  Copyright © 2016 Artem Kalinovsky. All rights reserved.
//

#import "UILabel+UILabelDynamicHeight.h"

@implementation UILabel (UILabelDynamicHeight)

/**
 *  Returns the size of the Label
 *
 *  @param aLabel To be used to calculte the height
 *
 *  @return size of the Label
 */
- (CGSize)sizeOfMultiLineLabel{
    
    NSString *aLabelTextString = [self text];
    UIFont *aLabelFont = [self font];
    CGFloat aLabelSizeWidth = self.frame.size.width;
    
    return [aLabelTextString boundingRectWithSize:CGSizeMake(aLabelSizeWidth, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{
                                                    NSFontAttributeName : aLabelFont
                                                    }
                                          context:nil].size;
    
}

@end