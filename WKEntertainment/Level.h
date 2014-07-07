//
//  Level.h
//  WKEntertainment
//
//  Created by Nguyen Binh on 6/8/14.
//  Copyright (c) 2014 ninjacoderz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tile.h"
#import "Enemy.h"
#import "Hero.h"
@interface Level : NSObject

-(instancetype)initWithFile:(NSString*)filename;
- (Tile *)tileAtColumn:(NSInteger)column row:(NSInteger)row;
- (void)generateEnemies;
- (void)generateHeros;
- (void) findingNearestEnemyForHero;
- (void) findingNearestEnemyForAHero:(Hero*)hero;

@property (strong,nonatomic) NSSet *_enemies;

@property (strong,nonatomic) NSSet *_heros;
@end
