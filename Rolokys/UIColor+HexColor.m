//
//  UIColor+HexColor.m
//  pfrf
//
//  Created by Alexander Drovnyashin on 28.11.16.
//  Copyright © 2016 Alx. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)

+ (UIColor *)colorFromHex:(uint32_t)hexLiteral
{
    return [self colorFromHex:hexLiteral alpha:1.0];
}

+ (UIColor *)colorFromHex:(uint32_t)hexLiteral alpha:(CGFloat)a
{
    uint8_t r = (uint8_t)(hexLiteral >> 16);
    uint8_t g = (uint8_t)(hexLiteral >> 8);
    uint8_t b = (uint8_t)hexLiteral;
    
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

+ (UIColor *)colorFromHexString:(NSString *)string
{
    return [self colorFromHexString:string alpha:1.0];
}

+ (UIColor *)colorFromHexString:(NSString *)string alpha:(CGFloat)a
{
    NSParameterAssert(string);
    if ( string == nil ) {
        return nil;
    }
    
    unsigned int hexInteger = 0;
    NSScanner *scanner = [NSScanner scannerWithString:string];
    
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"x#"]];
    [scanner scanHexInt:&hexInteger];
    
    return [self colorFromHex:hexInteger alpha:a];
}

@end
