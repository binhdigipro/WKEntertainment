//
//  Enermy.h
//  WKEntertainment
//
//  Created by Nguyen Binh on 6/9/14.
//  Copyright (c) 2014 ninjacoderz. All rights reserved.
//

#import <Foundation/Foundation.h>
@import SpriteKit;

@interface Enemy : NSObject

@property (assign, nonatomic) NSInteger column;
@property (assign, nonatomic) NSInteger row;

@property (assign, nonatomic) NSInteger speed;
@property (assign, nonatomic) int velocity;

@property (assign, nonatomic) SKSpriteNode *sprite;
@end
