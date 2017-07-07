//
//  PhotoManager.m
//  Rolokys
//
//  Created by Alexander Drovnyashin on 04.06.17.
//  Copyright © 2017 Alexandr Drovnyashin. All rights reserved.
//

#import "PhotoManager.h"
#import "UIImage+OpenCV.h"
#import "stitching.h"
#import "UIImage+Rotate.h"


@implementation PhotoManager


+ (UIImage*) processWithArray:(NSArray*)imageArray {
    if ([imageArray count]==0) {
        NSLog (@"imageArray is empty");
        return 0;
    }
    std::vector<cv::Mat> matImages;
    
    //TODO:
//    [self processWithArray:imageArray];
    
    for (id image in imageArray) {
        if ([image isKindOfClass: [UIImage class]]) {
            /*
             All images taken with the iPhone/iPa cameras are LANDSCAPE LEFT orientation. The  UIImage imageOrientation flag is an instruction to the OS to transform the image during display only. When we feed images into openCV, they need to be the actual orientation that we expect them to be for stitching. So we rotate the actual pixel matrix here if required.
             */
            UIImage* rotatedImage = [image rotateToImageOrientation];
            cv::Mat matImage = [rotatedImage CVMat3];
            NSLog (@"matImage: %@",image);
            matImages.push_back(matImage);
        }
    }
    NSLog (@"stitching...");
    cv::Mat stitchedMat = stitch (matImages);
    UIImage* result =  [UIImage imageWithCVMat:stitchedMat];
    NSLog (@"stitch!!!");
    return result;
}

//TODO: Обработать изображения
+ (NSArray *)proccessingImgs:(NSArray *)imageArray {
    
    NSMutableArray *arrProccesed = [NSMutableArray new];
    
    return arrProccesed;
}


@end
