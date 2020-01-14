//
//  ViewController.m
//  XCDropdownMenuExample
//
//  Created by 樊小聪 on 2017/3/2.
//  Copyright © 2017年 樊小聪. All rights reserved.
//


#import "ViewController.h"

#import "XCDropdownMenu.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (IBAction)didClickAction:(UIButton *)sender
{
    XCDropdownModel *retweetM = [XCDropdownModel dropdownModelWithImageName:@"nav_icon_forwarding" title:@"转发" didClickHandle:^{
        NSLog(@"点击了转发");
    }];
    
    XCDropdownModel *reportM = [XCDropdownModel dropdownModelWithImageName:@"nav_icon_inform" title:@"举报" didClickHandle:^{
        NSLog(@"点击了举报");
    }];
    
    XCDropdownModel *deleteM = [XCDropdownModel dropdownModelWithImageName:@"icon_delete" title:@"删除" didClickHandle:^{
        NSLog(@"点击了删除");
    }];
    
    [XCDropdownMenu showInView:sender models:@[retweetM, reportM, deleteM] options:NULL];
}

@end
