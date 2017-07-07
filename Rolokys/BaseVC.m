//
//  BaseVC.m
//  Diplom
//
//  Created by Alexander Drovnyashin on 28.11.16.
//  Copyright © 2016 Alx. All rights reserved.
//

#import "BaseVC.h"

#import <MBProgressHUD.h>

@interface BaseVC ()

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)showAlertWithText:(NSString *)text {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:text preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)startRefreshAnimation {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading";
}

- (void)stopRefreshAnimation {
     [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (UIBarButtonItem*)addNavBarButtonLeft:(BOOL)left systemItem:(UIBarButtonSystemItem)systemItem action:(SEL)action
{
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:self action:action];
    [self addNavBarButtonLeft:left btn:btn];
    return btn;
}

- (UIBarButtonItem*)addNavBarButtonLeft:(BOOL)left title:(NSString*)strTitle action:(SEL)action
{
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:strTitle style:UIBarButtonItemStylePlain target:self action:action];
    [self addNavBarButtonLeft:left btn:btn];
    return btn;
}
- (void)addNavBarButtonLeft:(BOOL)left btn:(UIBarButtonItem*)btn
{
    if (self.navigationItem == nil)
        return;
    
    if (left)
    {
        NSMutableArray *arr = self.navigationItem.leftBarButtonItems ? [self.navigationItem.leftBarButtonItems mutableCopy] : [NSMutableArray new];
        [arr addObject:btn];
        self.navigationItem.leftBarButtonItems = arr;
    }
    else
    {
        NSMutableArray *arr = self.navigationItem.rightBarButtonItems ? [self.navigationItem.rightBarButtonItems mutableCopy] : [NSMutableArray new];
        [arr addObject:btn];
        self.navigationItem.rightBarButtonItems = arr;
    }
}

- (UIBarButtonItem*)addNavBarButtonLeft:(BOOL)left iconName:(NSString*)iconName action:(SEL)action
{
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:iconName] style:UIBarButtonItemStylePlain target:self action:action];
    [self addNavBarButtonLeft:left btn:btn];
    return btn;
}


@end
