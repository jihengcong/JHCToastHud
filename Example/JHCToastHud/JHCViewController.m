//
//  JHCViewController.m
//  JHCToastHud
//
//  Created by jihengcong on 01/13/2022.
//  Copyright (c) 2022 jihengcong. All rights reserved.
//

#import "JHCViewController.h"
#import "JHCToastHud.h"


@interface JHCViewController ()

@end

@implementation JHCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [JHCToastHud showLoadingWithMsg:@"加载中..." inView:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
