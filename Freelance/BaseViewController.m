//
//  BaseViewController.m
//  Freelance
//
//  Created by Javier Soto on 6/23/12.
//  Copyright (c) 2012 MindSnacks. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"whitey.png"]];    
}

#pragma mark - Reachability

- (BOOL)connectedToNetwork {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    return appDelegate.connectedToNetwork;
}
@end
