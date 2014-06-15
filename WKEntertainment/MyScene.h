//
//  MyScene.h
//  WKEntertainment
//

//  Copyright (c) 2014 ninjacoderz. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Level.h"
@interface MyScene : SKScene

@property (strong, nonatomic) Level *level;

-(void)createTileLayer;
- (void)createEnemiesLayer:(NSSet *)enemies;
- (void)createHerosLayer:(NSSet *)heros;
@end
