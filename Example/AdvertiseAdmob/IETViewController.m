//
//  IETViewController.m
//  AdvertiseAdmob
//
//  Created by gaoyang on 10/22/2015.
//  Copyright (c) 2015 gaoyang. All rights reserved.
//

#import "IETViewController.h"
#import "AMAdvertiseHelper.h"

@interface IETViewController ()

@end

@implementation IETViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showSpot:(id)sender {
    BOOL result = [[AMAdvertiseHelper getInstance] showSpotAd:^(BOOL result) {
        NSLog(@"SpotAd Click: %@", result?@"YES":@"NO");
    }];
    NSLog(@"SpotAd Show: %@", result?@"YES":@"NO");
}

- (IBAction)isVedioReady:(id)sender {
    BOOL result = [[AMAdvertiseHelper getInstance] isVedioAdReady];
    NSLog(@"VedioAd Ready: %@", result?@"YES":@"NO");
}

- (IBAction)showVedio:(id)sender {
    BOOL result = [[AMAdvertiseHelper getInstance] showVedioAd:^(BOOL result) {
        NSLog(@"VedioAd Valid: %@", result?@"YES":@"NO");
    } :^(BOOL result) {
        NSLog(@"VedioAd Click: %@", result?@"YES":@"NO");
    }];
    NSLog(@"VedioAd Show: %@", result?@"YES":@"NO");
}

- (IBAction)showName:(id)sender {
    NSLog(@"Ad Name: %@", [[AMAdvertiseHelper getInstance] getName]);
}

@end
