//
//  IOManager.h
//  Rolokys
//
//  Created by Alexander Drovnyashin on 04.06.17.
//  Copyright © 2017 Alexandr Drovnyashin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

typedef void(^PanoStitch)(BOOL isSucces, NSString *errStr, UIImage *pano);

@interface IOManager : NSObject

+ (void)stitchImgs:(NSArray <UIImage *>*)arrImgs andBlockComplete:(PanoStitch)complete;
+ (void)stitchPhotoOfLibraryWithComplete:(PanoStitch)complete;

@end
