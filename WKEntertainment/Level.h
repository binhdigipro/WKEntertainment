//
//  Level.h
//  WKEntertainment
//
//  Created by Nguyen Binh on 6/8/14.
//  Copyright (c) 2014 ninjacoderz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tile.h"
@interface Level : NSObject

-(instancetype)initWithFile:(NSString*)filename;
- (Tile *)tileAtColumn:(NSInteger)column row:(NSInteger)row;
- (void)generateEnemies;
@property (strong,nonatomic) NSSet *_enemies;

@end
