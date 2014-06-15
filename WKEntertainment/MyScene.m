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
#import "Hero.h"
static const float MOVE_POINTS_PER_SEC = 30.0;
static const CGFloat TileWidth =  32.0;
static const CGFloat TileHeight = 32.0;

static const NSInteger NumColumns = 9;
static const NSInteger NumRows = 9;

static const float ROTATE_RADIAN_PER_SEC = 4 * M_PI;

// Start vector helper
static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x+b.x, a.y+b.y);
}

static inline CGPoint CGPointSubtract (const CGPoint a, const CGPoint b){
    return CGPointMake(a.x - b.x, a.y - b.y);
}

static inline CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat b){
    return CGPointMake(a.x*b, a.y*b);
}

static inline CGFloat CGPointLength(const CGPoint  a)
{
    return sqrtf(a.x*a.x + a.y*a.y);
}

static inline CGPoint CGPointNormalize(const CGPoint a){
    CGFloat length = CGPointLength(a);
    return CGPointMake(a.x/length, a.y/length);
}

static inline CGFloat CGPointToAngle(const CGPoint a)
{
    return atan2f(a.y, a.x);
}


static inline CGFloat ScalarSign(CGFloat a)
{
    return a >= 0?1:-1;
}
// End vector helper

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
                // For tiles odd
                if((row+column)%2 == 0){
                    SKSpriteNode *tileNode = [SKSpriteNode spriteNodeWithImageNamed:@"OddTile"];
                    tileNode.position = [self pointForColumn:column row:row];
                    [self.tileLayer addChild:tileNode];
                }
                else{
                    SKSpriteNode *tileNode = [SKSpriteNode spriteNodeWithImageNamed:@"EvenTile"];
                    tileNode.position = [self pointForColumn:column row:row];
                    [self.tileLayer addChild:tileNode];
                }
                // For tiles even
                
            }
            else{
                SKSpriteNode *tileNode = [SKSpriteNode spriteNodeWithImageNamed:@"Obstacle"];
                tileNode.position = [self pointForColumn:column row:row];
                [self.tileLayer addChild:tileNode];
            }
            //obstacle
        }
    }
}

- (void)createEnemiesLayer:(NSSet *)enemies {
    for (Enemy *enemy in enemies) {
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Mouse"];
        sprite.position = [self pointForColumn:enemy.column row:enemy.row];
        [self.enemyLayer addChild:sprite];
        enemy.sprite = sprite;
    }
}


- (void)createHerosLayer:(NSSet *)heros {
    for (Hero *hero in heros) {
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Cat"];
        sprite.position = [self pointForColumn:hero.column row:hero.row];
        [self.enemyLayer addChild:sprite];
        hero.sprite = sprite;
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
    CGPoint _velocity = CGPointMake(0, 0);
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
        [self boundsCheckEnemy:enemy];
        [self rotateSprite:enemy.sprite toFace:CGPointNormalize(_velocity) rotateRadiansPerSec:ROTATE_RADIAN_PER_SEC];
    }
    
    //NSLog(@"%0.2f millisecond since last update", _dt*1000);
    
    // Solve Heros problems here
    
    NSSet *heros = self.level._heros;
    for (Hero *hero in  heros) {
        hero.velocity = CGPointMultiplyScalar(CGPointNormalize(CGPointSubtract(hero.enemy.sprite.position, hero.sprite.position)),MOVE_POINTS_PER_SEC/2*hero.speed);
        [self moveSprite:hero.sprite velocity:hero.velocity];
        //[self boundsCheckHero:hero];
        [self rotateSprite:hero.sprite toFace:CGPointNormalize(hero.velocity) rotateRadiansPerSec:ROTATE_RADIAN_PER_SEC];
    }
}

// Need a function here boundsCheckHero:hero


- (void)moveSprite:(SKSpriteNode*)sprite velocity:(CGPoint)velocity
{
    CGPoint amountToMove = CGPointMake(velocity.x *_dt, velocity.y*_dt);
    //NSLog(@"Amount to move: %@", NSStringFromCGPoint(amountToMove));
    sprite.position = CGPointMake(sprite.position.x + amountToMove.x, sprite.position.y + amountToMove.y);
}

// Helper function go here

- (CGPoint)pointForColumn:(NSInteger)column row:(NSInteger)row {
    return CGPointMake(column*TileWidth + TileWidth/2, row*TileHeight + TileHeight/2);
}

- (void) boundsCheckEnemy:(Enemy*)sprite
{
    CGPoint newPosition = sprite.sprite.position;
    
    //deltaPosition is the edge of enemy base on velocity
    CGPoint deltaPosition = newPosition;
    NSInteger newVelocity = sprite.velocity;
    // Re fine position depend on velocity
    
    // Need switch case here. Need some i-ot here please
    if (newVelocity == 0) {
        // Đang đi lên
        deltaPosition.y += sprite.sprite.size.height/2;
    }
    if (newVelocity == 1) {
        // Right
        deltaPosition.x +=  sprite.sprite.size.width/2;
    }
    if (newVelocity == 2) {
        // Downing
        deltaPosition.y -= sprite.sprite.size.height/2;
    }
    if (newVelocity == 3) {
        // Left
        deltaPosition.x -= sprite.sprite.size.width/2;
    }
    
    // Limit of scence
    CGPoint bottomLeft = CGPointZero;
    CGPoint topRight = CGPointMake(TileWidth*NumColumns, TileHeight*NumRows);
    
    // Detect bound of screen
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
    
    // also detect obtacle
    NSInteger column;
    NSInteger row;
    [self convertPoint:deltaPosition toColumn:&column row:&row];
    if (column< NumColumns &&column >=0 && row < NumRows && row >= 0) {
        if ([self.level tileAtColumn:column row:row] == nil) {
            newVelocity += (sprite.velocity<=1)?2:-2;
            // We not save here, need to detect position
            switch (sprite.velocity) {
                case 0:
                    newPosition.y = TileHeight*row - sprite.sprite.size.height/2;
                    break;
                case 1:
                    newPosition.x = TileWidth*column - sprite.sprite.size.width/2;
                    break;
                case 2:
                    newPosition.y = TileHeight*(row+1) + sprite.sprite.size.height/2;
                    break;
                case 3:
                    newPosition.x = TileWidth*(column+1) + sprite.sprite.size.width/2;
                    break;
                default:
                    break;
            }
        }
    }

    
    sprite.sprite.position = newPosition;
    sprite.velocity = newVelocity;
}


- (void)rotateSprite:(SKSpriteNode *)sprite
              toFace:(CGPoint)velocity
 rotateRadiansPerSec:(CGFloat)rotateRadiansPerSec
{
    float targetAngle = CGPointToAngle(velocity);
    float shortest = ScalarShortestAngleBetween(sprite.zRotation, targetAngle);
    float amtToRotate = rotateRadiansPerSec * _dt;
    if (ABS(shortest) < amtToRotate) {
        amtToRotate = ABS(shortest);
    }
    sprite.zRotation += ScalarSign(shortest) * amtToRotate;
}

static inline CGFloat ScalarShortestAngleBetween(
                                                 const CGFloat a, const CGFloat b)
{
    CGFloat difference = b - a;
    CGFloat angle = fmodf(difference, M_PI * 2);
    if (angle >= M_PI) {
        angle -= M_PI * 2;
    }
    return angle;
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
