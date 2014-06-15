//
//  Level.m
//  WKEntertainment
//
//  Created by Nguyen Binh on 6/8/14.
//  Copyright (c) 2014 ninjacoderz. All rights reserved.
//

#import "Level.h"
static const NSInteger NumColumns = 9;
static const NSInteger NumRows = 9;
static const NSInteger NumEnemies = 6;

static const NSInteger NumHeros = 6;

static inline CGFloat CGPointLength(const CGPoint  a)
{
    return sqrtf(a.x*a.x + a.y*a.y);
}

static inline CGPoint CGPointSubtract (const CGPoint a, const CGPoint b){
    return CGPointMake(a.x - b.x, a.y - b.y);
}

@implementation Level{
    Tile *_tiles[NumColumns][NumRows];
}

-(instancetype)initWithFile:(NSString*)filename{
    self = [super init];
    if (self!=nil) {
        // Init tiles
        NSDictionary *dictionary = [self loadJSON:filename];
        [dictionary[@"tiles"] enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger row, BOOL *stop) {
            [array enumerateObjectsUsingBlock:^(NSNumber *value, NSUInteger column, BOOL *stop){
                NSInteger tileRow = NumRows - row - 1;
                if ([value integerValue]==1) {
                    _tiles[column][tileRow] = [[Tile alloc] init];
                }
            }];
        }];
        
        // Init Enemies
        [self generateEnemies];
    }
    return self;
}

- (NSDictionary *) loadJSON:(NSString*)filename{
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
    if (path==nil) {
        NSLog(@"Could not find level file %@", filename);
        return nil;
    }
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:path options:0 error:&error];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (dictionary == nil || ![dictionary isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Level file '%@' is not valid JSON: %@", filename, error);
        return nil;
    }
    
    return dictionary;
}

- (Tile *)tileAtColumn:(NSInteger)column row:(NSInteger)row{
    NSAssert1(column >= 0 && column < NumColumns, @"Invalid column: %ld", (long)column);
    NSAssert1(row >= 0 && row < NumRows, @"Invalid row: %ld", (long)row);
    return _tiles[column][row];
}

- (void)generateEnemies{
    NSMutableSet *set = [NSMutableSet set];
    
    for (int i = 0; i<NumEnemies; i++) {
        Enemy *enemy = [[Enemy alloc] init];
        // Make sure no generate same enemy that not generated and so on not on the blank
        do{
            enemy.column = arc4random_uniform(NumColumns);
            enemy.row = arc4random_uniform(NumRows);
            enemy.speed = arc4random_uniform(4)+1; //
            enemy.velocity = arc4random_uniform(4); // 0 up 1 right 2 down 3 left
        }
        while ([set containsObject:enemy]||([self tileAtColumn:enemy.column row:enemy.row]== nil));
        [set addObject:enemy];
    }
    self._enemies = set;
    //NSLog(@"%")
}

- (void)generateHeros{
    
    // Just generate heros after have enemies
    if (self._enemies.count == 0) {
        return;
    }
    
    NSMutableSet *set = [NSMutableSet set];
    
    for (int i = 0; i< NumHeros; i++) {
        Hero *ahero = [[Hero alloc] init];
        // Make sure no generate same enemy that not generated and so on not on the blank
        do{
            ahero.column = arc4random_uniform(NumColumns);
            ahero.row = arc4random_uniform(NumRows);
            //ahero.speed = arc4random_uniform(4)+1; // Generate speed after
            //ahero.velocity = arc4random_uniform(4); // 0 up 1 right 2 down 3 left // Generate velocity after
        }
        while ([set containsObject:ahero]||([self tileAtColumn:ahero.column row:ahero.row]== nil));
        //ahero.enemy = [self findingNearestEnemyForHero:ahero];
        //ahero.speed = ahero.enemy.speed;
        [set addObject:ahero];
    }
    self._heros = set;
    //NSLog(@"%")
}


- (void) findingNearestEnemyForHero{
    for (Hero *hero in self._heros) {
        Enemy *findingEnemy = [self._enemies anyObject];
        CGFloat shorest = CGPointLength(CGPointSubtract(hero.sprite.position, findingEnemy.sprite.position));
    
        for(Enemy *enemy in self._enemies){
            if (CGPointLength(CGPointSubtract(hero.sprite.position, enemy.sprite.position)) < shorest) {
                findingEnemy = enemy;
            }
        }
        hero.enemy = findingEnemy;
        hero.speed = findingEnemy.speed;
    }
}


@end
