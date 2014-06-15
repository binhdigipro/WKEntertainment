//
//  ViewController.m
//  WKEntertainment
//
//  Created by Nguyen Binh on 6/8/14.
//  Copyright (c) 2014 ninjacoderz. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "Level.h"
@interface ViewController()

@property (strong, nonatomic) Level *level;
@property (strong, nonatomic) MyScene *scene;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the view.
    self.scene = [MyScene sceneWithSize:skView.bounds.size];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    
    
    // Create and configure the Model
    self.level = [[Level alloc] initWithFile:@"Level_0"];
    
    self.scene.level = self.level;
    [self.scene createTileLayer];
    
    [self.level generateEnemies];
    [self.scene  createEnemiesLayer:self.level._enemies];
    
    // Generate Heros
    [self.level generateHeros];
    
    [self.scene  createHerosLayer:self.level._heros];
    [self.level findingNearestEnemyForHero];
    
    // Present the scene.
    [skView presentScene:self.scene];
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
