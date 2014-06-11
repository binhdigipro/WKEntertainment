//
//  MyScene.m
//  WKEntertainment
//
//  Created by Nguyen Binh on 6/8/14.
//  Copyright (c) 2014 ninjacoderz. All rights reserved.
//

#import "MyScene.h"
#import "Level.h"
#import "Enemy.h"

static const float MOVE_POINTS_PER_SEC = 30.0;
static const CGFloat TileWidth = 32.0;
static const CGFloat TileHeight = 36.0;

static const NSInteger NumColumns = 9;
static const NSInteger NumRows = 9;


@interface MyScene()

@property (strong, nonatomic) SKNode *gameLayer;
@property (strong, nonatomic) SKNode *enemyLayer;
@property (strong, nonatomic) SKNode *tileLayer;

@end

@implementation MyScene{
    NSTimeInterval _dt;
    NSTimeInterval _lastUpdateTime;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        // Set up background
        self.anchorPoint = CGPointMake(0.5, 0.5);
        
        self.backgroundColor = [SKColor whiteColor];
        //SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
        //[self addChild:bg];
        
        // Start manage game by layer
        self.gameLayer = [SKNode node];
        [self addChild:self.gameLayer];
        
        // Position for all layer in game
        CGPoint layerPosition = CGPointMake(-TileWidth*NumColumns/2, -TileHeight*NumRows/2);
        
        // Add Tile Layer
        self.tileLayer = [SKNode node];
        self.tileLayer.position = layerPosition;
        [self.gameLayer addChild:self.tileLayer];
        
        // Add Enermy Layer
        self.enemyLayer = [SKNode node];
        self.enemyLayer.position = layerPosition;
        [self.gameLayer addChild:self.enemyLayer];
    }
    return self;
}



-(void)createTileLayer{
    for (NSInteger row = 0; row <NumRows; row++) {
        for (NSInteger column = 0; column < NumColumns; column++) {
            if ([self.level tileAtColumn:column row:row]!=nil) {
                SKSpriteNode *tileNode = [SKSpriteNode spriteNodeWithImageNamed:@"Tile"];
                tileNode.position = [self pointForColumn:column row:row];
                [self.tileLayer addChild:tileNode];
            }
        }
    }
}

- (void)createEnemiesLayer:(NSSet *)enemies {
    for (Enemy *enemy in enemies) {
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"cat"];
        sprite.position = [self pointForColumn:enemy.column row:enemy.row];
        [self.enemyLayer addChild:sprite];
        enemy.sprite = sprite;
    }
}



-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (_lastUpdateTime) {
        _dt = currentTime - _lastUpdateTime;
    }
    else{
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
    
    NSSet * enemies = self.level._enemies ;
    CGPoint _velocity = CGPointMake(0, 20);
    //caluate velocity
    for (Enemy *enemy in  enemies) {
        if (enemy.velocity == 0) {
            // Up
            _velocity = CGPointMake(0, enemy.speed * MOVE_POINTS_PER_SEC);
        }
        
        if (enemy.velocity == 1) {
            // right
            _velocity = CGPointMake(enemy.speed * MOVE_POINTS_PER_SEC, 0);
        }
        
        if (enemy.velocity == 2) {
            // down
            _velocity = CGPointMake(0, -enemy.speed * MOVE_POINTS_PER_SEC);
        }
        
        if (enemy.velocity == 3) {
            // left
            _velocity = CGPointMake(-enemy.speed * MOVE_POINTS_PER_SEC, 0);
        }
        
        [self moveSprite:enemy.sprite velocity:_velocity];
        [self boundsCheckPlayer:enemy];
    }
    
    NSLog(@"%0.2f millisecond since last update", _dt*1000);
    
    
}


- (void)moveSprite:(SKSpriteNode*)sprite velocity:(CGPoint)velocity
{
    CGPoint amountToMove = CGPointMake(velocity.x *_dt, velocity.y*_dt);
    NSLog(@"Amount to move: %@", NSStringFromCGPoint(amountToMove));
    sprite.position = CGPointMake(sprite.position.x + amountToMove.x, sprite.position.y + amountToMove.y);
}
// Helper function go here

- (CGPoint)pointForColumn:(NSInteger)column row:(NSInteger)row {
    return CGPointMake(column*TileWidth + TileWidth/2, row*TileHeight + TileHeight/2);
}

- (void) boundsCheckPlayer:(Enemy*)sprite
{
    CGPoint newPosition = sprite.sprite.position;
    CGPoint deltaPosition = newPosition;
    NSInteger newVelocity = sprite.velocity;
    // Re fine position depend on velocity
    if (newVelocity == 0) {
        // Upping
        deltaPosition.y = newPosition.y + sprite.sprite.size.height/2;
    }
    if (newVelocity == 1) {
        // Right
        deltaPosition.x = newPosition.x + sprite.sprite.size.width/2;
    }
    if (newVelocity == 2) {
        // Downing
        deltaPosition.y = newPosition.y - sprite.sprite.size.height/2;
    }
    if (newVelocity == 3) {
        // Left
        deltaPosition.x = newPosition.x - sprite.sprite.size.width/2;
    }
    
    CGPoint bottomLeft = CGPointZero;
    
    CGPoint topRight = CGPointMake(TileWidth*NumColumns, TileHeight*NumRows);
    
    if (deltaPosition.x<= bottomLeft.x) {
        newPosition.x = bottomLeft.x + sprite.sprite.size.width/2;
        newVelocity += (sprite.velocity<=1)?2:-2;
    }
    
    if (deltaPosition.x >= topRight.x) {
        newPosition.x = topRight.x - sprite.sprite.size.width/2;
        newVelocity += (sprite.velocity<=1)?2:-2;
    }
    
    if (deltaPosition.y <= bottomLeft.y) {
        newPosition.y = bottomLeft.y + sprite.sprite.size.height/2;
        newVelocity += (sprite.velocity<=1)?2:-2;
    }
    if (deltaPosition.y >= topRight.y) {
        newPosition.y = topRight.y - sprite.sprite.size.width/2;
        newVelocity += (sprite.velocity<=1)?2:-2;
    }
    
    // also check
    NSInteger column;
    NSInteger row;
    [self convertPoint:deltaPosition toColumn:&column row:&row];
    if (column< NumColumns &&column >=0 && row < NumRows && row >= 0) {
        if ([self.level tileAtColumn:column row:row] == nil) {
            newVelocity += (sprite.velocity<=1)?2:-2;
        }
    }

    
    sprite.sprite.position = newPosition;
    sprite.velocity = newVelocity;
}


- (BOOL)convertPoint:(CGPoint)point toColumn:(NSInteger*)column row:(NSInteger*)row {
    NSParameterAssert(column);
    NSParameterAssert(row);
    if (point.x >= 0 && point.x < NumColumns*TileWidth &&
        point.y >= 0 && point.y < NumRows*TileHeight) {
        
        *column = point.x / TileWidth;
        *row = point.y / TileHeight;
        return YES;
        
    } else {
        *column = NSNotFound;  // invalid location
        *row = NSNotFound;
        return NO;
    }
    
}

@end