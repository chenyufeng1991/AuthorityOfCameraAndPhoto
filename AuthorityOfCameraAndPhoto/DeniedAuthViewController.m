//
//  DeniedAuthViewController.m
//  AuthorityOfCameraAndPhoto
//
//  Created by chenyufeng on 6/20/16.
//  Copyright © 2016 chenyufengweb. All rights reserved.
//

#import "DeniedAuthViewController.h"

@interface DeniedAuthViewController ()

@end

@implementation DeniedAuthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
