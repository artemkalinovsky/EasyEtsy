//
//  UILabel+UILabelDynamicHeight.h
//  EasyEtsy
//
//  Created by Artem Kalinovsky on 21/01/2016.
//  Copyright © 2016 Artem Kalinovsky. All rights reserved.
//

@import UIKit;

@interface UILabel (UILabelDynamicHeight)
/**
 *  Returns the size of the Label
 *
 *  @param aLabel To be used to calculte the height
 *
 *  @return size of the Label
 */
- (CGSize)sizeOfMultiLineLabel;
@end
