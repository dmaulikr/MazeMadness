//
//  MMViewController.m
//  MazeMadness
//
//  Created by David Xiang on 3/20/14.
//  Copyright (c) 2014 David Xiang. All rights reserved.
//

#import "MMViewController.h"
#import "MMMyScene.h"
#import "MMWelcomeScreen.h"
#import <iAd/iAd.h>

@implementation MMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // self.canDisplayBannerAds = YES;
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    SKView  *view = (SKView*)self.view;
    if(!view.scene){
        // Configure the view.
        SKView * skView = (SKView *)self.originalContentView;
        // skView.showsFPS = YES;
        //skView.showsNodeCount = YES;
        
        // Create and configure the scene.
        SKScene * scene = [MMWelcomeScreen sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Banner
        ADBannerView *adView = [[ADBannerView alloc] initWithFrame: CGRectZero];
        adView.delegate = self;
        [adView setFrame:CGRectMake(0, skView.bounds.size.height - 50, 320, 50)]; // set to your screen dimensions
        [skView addSubview:adView];
        
       
        // Present the scene.
        [skView presentScene:scene];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
