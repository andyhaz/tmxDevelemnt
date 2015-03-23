//
//  GameScene.m
//  tmxDevelemnt
//
//  Created by andrew hazlett on 3/12/15.
//  Copyright (c) 2015 andrew hazlett. All rights reserved.
//
#import "GameScene.h"
#import "game_utils.h"
#import "levelMap.h"
#import "JSTileMap.h"

@interface GameScene (){
    SKSpriteNode *sprite,*circleTraget;
    SKShapeNode *mapBox;
    int mapSizeHightMax,mapSizeWidthMax;
    BOOL moveMap;
    
 //   float mapSizeWidth;
 //   float mapSizeHeight;
    float distanceTraveld;
    levelMap *mapLevelNode;
 //   JSTileMap *tileMap;
}

@end

@implementation GameScene


typedef enum : uint8_t {
    playerCategory     = 1,
    wallCategory       = 2,
    circleCategory     = 3,
} APAColliderType;

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.backgroundColor = [SKColor blackColor];
    
    //add map
    mapLevelNode = [[levelMap alloc]init];
    [mapLevelNode loadMap:@"level1.tmx"];
    mapLevelNode.name = @"levelMap";
    //
    mapSizeHightMax = [mapLevelNode mapHeight];
    mapSizeWidthMax = [mapLevelNode mapWidth];
    //
    mapLevelNode.xScale = 1.0;
    mapLevelNode.yScale = 1.0;
  //  mapLevelNode.position = CGPointMake((self.size.width/2)-(mapSizeHightMax/2) ,(self.size.height/2)-(mapSizeWidthMax/2));
    //
    mapBox = [[SKShapeNode alloc]init];
    mapBox.name = @"mapBox";
    mapBox.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, mapSizeWidthMax, mapSizeHightMax) cornerRadius:4].CGPath;
    mapBox.position = CGPointMake((self.size.width/2)-(mapSizeHightMax/2) ,(self.size.height/2)-(mapSizeWidthMax/2));
    mapBox.strokeColor = [SKColor redColor];
 //   mapBox.fillColor = [SKColor blueColor];
    [self addChild:mapBox];
    
    [mapBox addChild:mapLevelNode];
    NSLog(@"mapNode:%@",mapLevelNode);
//end
    sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    sprite.name = @"ship";
    sprite.xScale = 0.5;
    sprite.yScale = 0.5;
    sprite.position = CGPointMake(self.size.width/2, self.size.height/2);
   // sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.frame.size.width / 3.0f];
    sprite.physicsBody.dynamic = YES;
    sprite.physicsBody.categoryBitMask = playerCategory;
    sprite.physicsBody.contactTestBitMask = wallCategory | circleCategory;
    [self addChild:sprite];
 // NSLog(@"sprit:%@",sprite);
    
    circleTraget = [SKSpriteNode spriteNodeWithImageNamed:@"cirImage"];
    circleTraget.name = @"target";
    circleTraget.xScale = 1.0;
    circleTraget.yScale = 1.0;
    circleTraget.position = CGPointMake(self.size.width/2, self.size.height/2);
  //  circleTraget.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:circleTraget.frame.size.width / 3.0f];
 //   circleTraget.physicsBody.dynamic = YES;
 //   circleTraget.physicsBody.categoryBitMask = circleCategory;
 //   circleTraget.physicsBody.contactTestBitMask = playerCategory;
    [self addChild:circleTraget];
    //set up physics
    self.physicsWorld.gravity = CGVectorMake(0,0);
    self.physicsWorld.contactDelegate = self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
  //  float touchX = 0.0,touchY = 0.0;
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    //SKNode *node = [self nodeAtPoint:location];
    [circleTraget removeAllActions];
    circleTraget.position = location;
    circleTraget.alpha = 1.0;
    //NSLog(@"circleTrget x:%f y:%f",circleTraget.position.x,circleTraget.position.y);
    
    float moveDistance = [self DistanceBetweenTwoPoints:location :mapLevelNode.position];
    NSLog(@"Distance:%f",moveDistance);
    distanceTraveld = moveDistance+distanceTraveld;
    
    [sprite runAction:[self rotImage]];
    [circleTraget runAction:[self moveAction:self.size.width/2 :self.size.height/2 :@"target" :0.0060]];
    
  //  mapBox.position = location;
    [mapBox runAction:[self moveAction:-distanceTraveld :-distanceTraveld :@"mapBox" :0.0030]];

   // [mapNode setMapLocation:touchX :touchY];
   //caluclate
   //NSLog(@"map postion X:%f map Y:%f",tiledMap.position.x,tileMap.position.y);
    
 //  float moveH = SKNodeMap.position.x+location.x;
 //  float moveV = SKNodeMap.position.y+location.y;
 //  NSLog(@"cal: moveH:%f moveV:%f",moveH,moveV);

  //  [mapLevelNode runAction:[self moveMap:0 :-100 :@"levelMap"]];
//    [mapLevelNode runAction:[self moveAction:0 :0 :@"levelMap" :0.0030]];
}
//make big map to move


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    [self didBeginContact:NULL];
    if (circleTraget.position.x == self.size.width/2 && circleTraget.position.y == self.size.height/2) {
      //  [tiledMap removeAllActions];
        [sprite runAction:[self moveAction:self.size.width/2:self.size.height/2 :@"ship" :0.0060]];
    }
}//end update

-(SKAction*)moveMap :(float)x :(float)y :(NSString*)sprintName{
    //the node you want to move
    SKNode *node = [self childNodeWithName:sprintName];
    //   NSLog(@"moveAction:%@",node);
    
    //get the distance between the destination position and the node's position
    double distance = sqrt(pow((x - node.position.x), 2.0) + pow((y - node.position.y), 2.0));
    
    //calculate your new duration based on the distance
    float moveDuration = 0.0030*distance;
    
    //move the node
    SKAction *move = [SKAction moveBy:CGVectorMake(x, y) duration:moveDuration];
    
    return move;
}//end move action

-(SKAction*)moveAction :(float)x :(float)y :(NSString*)sprintName :(float)speed{
    //the node you want to move
    SKNode *node = [self childNodeWithName:sprintName];
    //   NSLog(@"moveAction:%@",node);
    
    //get the distance between the destination position and the node's position
    double distance = sqrt(pow((x - node.position.x), 2.0) + pow((y - node.position.y), 2.0));
    
    //calculate your new duration based on the distance
    float moveDuration = speed*distance;
    
    //move the node
    SKAction *move = [SKAction moveTo:CGPointMake(x,y) duration: moveDuration];
    
    return move;
}//end move action

-(SKAction*)rotImage{
    game_utils *gu  = [[game_utils alloc]init];
    CGPoint p1 = CGPointMake(sprite.position.x,sprite.position.y);
    CGPoint p2 = CGPointMake(circleTraget.position.x,circleTraget.position.y);
    
    float angle = [gu pointPairToBearingDegrees:p1 secondPoint:p2];
    SKAction *rotPuffer = [SKAction rotateToAngle:-angle duration:0.2];
    return rotPuffer;
}//end rotimage

-(CGFloat)DistanceBetweenTwoPoints :(CGPoint) point1 :(CGPoint) point2 {
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy );
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody, *secondBody;
  //  NSString *bodyStr = contact.bodyB.node.name;
  //  NSString *bodyStrA = contact.bodyA.node.name;
   // NSLog(@" bodyStr:%@ boodStrA:%@",bodyStr,bodyStrA);
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
//walls
    if (firstBody.categoryBitMask == playerCategory  && secondBody.categoryBitMask == wallCategory) {
       // NSLog(@"wall bodyStr:%@ boodStrA:%@",bodyStr,bodyStrA);
      //  [tileMap removeAllActions];
    }
    
    if (firstBody.categoryBitMask == playerCategory  && secondBody.categoryBitMask == circleCategory) {
       // NSLog(@"target bodyStr:%@ boodStrA:%@",bodyStr,bodyStrA);
      //  [tileMap removeAllActions];
        circleTraget.alpha = 0.0;
    }
}
@end
