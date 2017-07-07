//
//  UIColor+HexColor.h
//  pfrf
//
//  Created by Alexander Drovnyashin on 28.11.16.
//  Copyright © 2016 Alx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)

+ (UIColor *)colorFromHex:(uint32_t)hexLiteral;
+ (UIColor *)colorFromHex:(uint32_t)hexLiteral alpha:(CGFloat)a;
+ (UIColor *)colorFromHexString:(NSString *)string;
+ (UIColor *)colorFromHexString:(NSString *)string alpha:(CGFloat)a;

@end
