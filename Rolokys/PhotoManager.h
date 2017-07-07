//
//  PhotoManager.h
//  Rolokys
//
//  Created by Alexander Drovnyashin on 04.06.17.
//  Copyright © 2017 Alexandr Drovnyashin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOManager.h"

@class UIImage;

@interface PhotoManager : NSObject

+ (UIImage*) processWithArray:(NSArray<UIImage*>*)imageArray;


@end
