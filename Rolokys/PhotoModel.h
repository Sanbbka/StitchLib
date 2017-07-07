//
//  PhotoModel.h
//  Rolokys
//
//  Created by Alexander Drovnyashin on 18.01.17.
//  Copyright © 2017 Alexandr Drovnyashin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoModel : NSObject

@property BOOL isButton;
@property (nonatomic, strong) id mAsset;
@property (nonatomic, strong) UIImage *mPhoto;

@end
