//
//  BaseVC.h
//  Diplom
//
//  Created by Alexander Drovnyashin on 28.11.16.
//  Copyright © 2016 Alx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface BaseVC : UIViewController

- (void)showAlertWithText:(NSString *)text;

- (void)startRefreshAnimation;
- (void)stopRefreshAnimation;

- (UIBarButtonItem*)addNavBarButtonLeft:(BOOL)left title:(NSString*)strTitle action:(SEL)action;
- (UIBarButtonItem*)addNavBarButtonLeft:(BOOL)left systemItem:(UIBarButtonSystemItem)systemItem action:(SEL)action;
- (UIBarButtonItem*)addNavBarButtonLeft:(BOOL)left iconName:(NSString*)iconName action:(SEL)action;

@end
