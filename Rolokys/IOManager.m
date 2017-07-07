//
//  IOManager.m
//  Rolokys
//
//  Created by Alexander Drovnyashin on 04.06.17.
//  Copyright © 2017 Alexandr Drovnyashin. All rights reserved.
//

#import "IOManager.h"
#import "PhotoManager.h"

@implementation IOManager

+ (void)stitchImgs:(NSArray <UIImage *>*)arrImgs andBlockComplete:(PanoStitch)complete {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *img = [PhotoManager processWithArray:arrImgs];
        
        BOOL succes = img != nil;
        NSString *errStr = succes ? nil : @"Error!";
        
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(succes,  errStr, img);
        });
    });
}

+ (void)stitchPhotoOfLibraryWithComplete:(PanoStitch)complete {
    
}


@end
