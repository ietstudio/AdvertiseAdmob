//
//  IETViewController.m
//  AdvertiseAdmob
//
//  Created by gaoyang on 06/11/2016.
//  Copyright (c) 2016 gaoyang. All rights reserved.
//

#import "IETViewController.h"
#import "AMAdvertiseHelper.h"
#import <AdSupport/ASIdentifierManager.h>

@interface IETViewController ()

@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@end

@implementation IETViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	NSString *idfaString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    self.msgLabel.text = idfaString;
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
    self.msgLabel.text = [NSString stringWithFormat:@"VedioAd Ready: %@", result?@"YES":@"NO"];
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

- (IBAction)showBanner:(id)sender {
    int height = [[AMAdvertiseHelper getInstance] showBannerAd:YES :YES];
    NSLog(@"%d", height);
}

- (IBAction)hideBanner:(id)sender {
    [[AMAdvertiseHelper getInstance] hideBannerAd];
}

@end
