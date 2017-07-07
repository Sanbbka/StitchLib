//
//  ViewController.h
//  Diplom
//
//  Created by Alexander Drovnyashin on 27.11.16.
//  Copyright © 2016 Alx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import <CTAssetsPickerController/CTAssetsPickerController.h>

@interface ViewController : BaseVC

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@end

