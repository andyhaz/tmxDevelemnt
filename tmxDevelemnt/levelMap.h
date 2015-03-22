//
//  levelMap.h
//  gamePlayInterface
//
//  Created by andy hazlett on 8/11/14.
//  Copyright (c) 2014 andy hazlett. All rights reserved.
//
/*
 Sample Code
 in interface 
    levelMap *mapNode;
 .m
 //load map
 mapNode = [[levelMap alloc]init];
 [mapNode loadMap:@"myfile.tmx"];
 [self addChild:mapNode];

//move map
 [mapNode runAction:[mapNode moveMap:locX :locY]];
*/
#import <SpriteKit/SpriteKit.h>
#import "SKTUtils.h"
#import "JSTileMap.h"

@interface levelMap : SKNode {

}

-(SKSpriteNode*)loadMap:(NSString*)levelName;
-(NSDictionary*) loadMapObject;
-(void)setMapLocation :(float)locX :(float)locY;
-(int) mapHeight;
-(int) mapWidth;

@property (nonatomic,strong) JSTileMap *map;
@property (weak, nonatomic) SKSpriteNode* worldNode;
@property(strong) SKTextureAtlas *atlas;



@end
