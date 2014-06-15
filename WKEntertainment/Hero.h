//
//  Heros.h
//  WKEntertainment
//
//  Created by Nguyen Binh on 6/15/14.
//  Copyright (c) 2014 ninjacoderz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enemy.h"
@import SpriteKit;

@interface Hero : NSObject

@property (assign, nonatomic) NSInteger column;
@property (assign, nonatomic) NSInteger row;

@property (assign, nonatomic) NSInteger speed;
@property (assign, nonatomic) CGPoint velocity;

@property (assign, nonatomic) SKSpriteNode *sprite;

@property (assign, nonatomic) Enemy *enemy;

@end
