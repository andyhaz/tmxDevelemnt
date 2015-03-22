//
//  levelMap.m
//  gamePlayInterface
//
//  Created by andy hazlett on 8/11/14.
//  Copyright (c) 2014 andy hazlett. All rights reserved.
//

//844-887-1284 call sprint

#import "levelMap.h"

@implementation levelMap

typedef enum : uint8_t {
    playerCategory     = 1,
    wallCategory       = 2,
    circleCategory     = 3,
} APAColliderType;

-(SKSpriteNode*)loadMap:(NSString*)levelName{
  //  NSLog(@"lavelName:%@",levelName);
    SKSpriteNode *worldNode = [[SKSpriteNode alloc] init];
    
  //  worldNode.name = @"levelMap";
    
    [self addChild:worldNode];
    
    self.worldNode = worldNode;
    
    self.map = [JSTileMap mapNamed:levelName];
    
    [self.worldNode addChild:self.map];
    
    [self addMapBlocks];
    
    NSLog(@"map data:%@",self.map.gidData);
    
    //self.worldNode.size = CGSizeMake([self mapWidth], [self mapHeight]);
    
    //self.worldNode.position = CGPointMake(-[self mapWidth]/2, -[self mapHeight]/2);
    
   // NSLog(@"self map:%@ worldNod:%@",self.map,self.worldNode);
    
    return self.worldNode;
}

-(void)setMapLocation :(float)locX :(float)locY{
    self.worldNode.anchorPoint = CGPointMake(-locX, -locY);
}

// JSTileMap *tileMap = [JSTileMap mapNamed:levelName];del
//[self addChild:tileMap];del

- (void)addMapBlocks {
    for (int i = 0; i < self.map.layers.count; i ++) {
        if ([self.map.layers objectAtIndex:i] == [NSNull null]) {
            NSLog(@"object at index %i has no data", i);
        } else {
//NSLog(@"render this data at:%d",i);
            if (i == 0) {
//render backgound layer
                for (int a = 0; a < self.map.mapSize.width; a++) {
                    for (int b = 0; b < self.map.mapSize.height; b++) {
                        TMXLayerInfo* wallLayerInfo = [self.map.layers objectAtIndex:0];//add wall object 1
                        CGPoint pt = CGPointMake(a, b);
                        NSInteger gid = [wallLayerInfo.layer tileGidAt:[wallLayerInfo.layer pointForCoord:pt]];
                        if (gid != 0) {
                            SKSpriteNode *bgNode = [wallLayerInfo.layer tileAtCoord:pt];
                            bgNode.blendMode = SKBlendModeAlpha;
                            bgNode.alpha = 1.0;
                            bgNode.lightingBitMask = 1;
                            bgNode.shadowCastBitMask = 0;
                            bgNode.shadowedBitMask = 0;
                            bgNode.zPosition  = 0;
                        }//gid
                    }
                } //end backgound layer
            }//end if 1
            if (i == 1) {
                //wall layer
                for (int a = 0; a < self.map.mapSize.width; a++) {
                    for (int b = 0; b < self.map.mapSize.height; b++) {
                        TMXLayerInfo* wallLayerInfo = [self.map.layers objectAtIndex:1];//add wall object 1
                        CGPoint pt = CGPointMake(a, b);
                        NSInteger gid = [wallLayerInfo.layer tileGidAt:[wallLayerInfo.layer pointForCoord:pt]];
                        if (gid != 0) {
                            SKSpriteNode *wallNode = [wallLayerInfo.layer tileAtCoord:pt];
                            wallNode.zPosition = 1;
                            wallNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:wallNode.frame.size];
                            wallNode.physicsBody.dynamic = NO;
                            wallNode.physicsBody.categoryBitMask = wallCategory;
                        }//gid
                    }
                 } //wall layer
            }//if 2
        }
    }//end for loop
}

-(NSDictionary*) loadMapObject {
   // NSLog(@"loadMapObjects");
    NSMutableArray *objectMap = [[NSMutableArray alloc]init];
    NSMutableDictionary *mapData = [[NSMutableDictionary alloc]init];
    TMXObjectGroup* objectLayerInfo = [self.map.objectGroups lastObject];//add wall object 1

    if (objectLayerInfo) {
        for (int i = 0; i <= objectLayerInfo.objects.count-1; i++) {
            [objectMap addObject:objectLayerInfo.objects[i]];
        }
    }//end if objectLayerInfo
  //  NSLog(@"objectMap Info:%@",objectMap);
    //creat diretory to use based on type
    if (objectMap) {
        int layerNum = 1;
        for (int i = 0; i <= objectMap.count-1; i++) {
            NSMutableDictionary *tempAry = [[NSMutableDictionary alloc]init];
            NSString *objType = [objectMap[i] valueForKey:@"type"];
           // NSLog(@"object map %@",objType);
                if ([objType isEqualToString:@"start"]) {
                   //  NSLog(@"start");
                    NSString *objName = [objectMap[i] valueForKey:@"name"];
                    [tempAry setObject:objName forKey:@"name"];
                    
                    NSInteger objHeight = [[objectMap[i] valueForKey:@"height"] integerValue];
                    [tempAry setObject:[NSNumber numberWithInteger:objHeight] forKey:@"heighs"];
                    
                    NSInteger objWidth =  [[objectMap[i] valueForKey:@"width"] integerValue];
                    [tempAry setObject:[NSNumber numberWithInteger:objWidth] forKey:@"width"];
                    
                    NSInteger objx = [[objectMap[i] valueForKey:@"x"] integerValue];
                    [tempAry setObject:[NSNumber numberWithInteger:objx] forKey:@"x"];
                    
                    NSInteger objy = [[objectMap[i] valueForKey:@"y"] integerValue];
                    [tempAry setObject:[NSNumber numberWithInteger:objy] forKey:@"y"];
                    
                    [mapData setObject:tempAry forKey:objType];
                }
                
                if ([objType isEqualToString:@"door"]) {
                    // NSLog(@"door");
                    NSString *objName = [objectMap[i] valueForKey:@"name"];
                    [tempAry setObject:objName forKey:@"name"];
                    
                    NSInteger objHeight = [[objectMap[i] valueForKey:@"height"] integerValue];
                    [tempAry setObject:[NSNumber numberWithInteger:objHeight] forKey:@"heighs"];
                    
                    NSInteger objWidth =  [[objectMap[i] valueForKey:@"width"] integerValue];
                    [tempAry setObject:[NSNumber numberWithInteger:objWidth] forKey:@"width"];
                    
                    NSInteger objx = [[objectMap[i] valueForKey:@"x"] integerValue];
                    [tempAry setObject:[NSNumber numberWithInteger:objx] forKey:@"x"];
                    
                    NSInteger objy = [[objectMap[i] valueForKey:@"y"] integerValue];
                    [tempAry setObject:[NSNumber numberWithInteger:objy] forKey:@"y"];
                    
                    [mapData setObject:tempAry forKey:objType];
                    
                //  [self goldBag:objy :objy];
                }
        
            if ([objType isEqualToString:@"gem"]) {
               // NSLog(@"gem");
                NSString *objName = [objectMap[i] valueForKey:@"name"];
                [tempAry setObject:objName forKey:@"name"];
                
                NSInteger objHeight = [[objectMap[i] valueForKey:@"height"] integerValue];
                [tempAry setObject:[NSNumber numberWithInteger:objHeight] forKey:@"heighs"];
                
                NSInteger objWidth =  [[objectMap[i] valueForKey:@"width"] integerValue];
                [tempAry setObject:[NSNumber numberWithInteger:objWidth] forKey:@"width"];
                
                NSInteger objx = [[objectMap[i] valueForKey:@"x"] integerValue];
                [tempAry setObject:[NSNumber numberWithInteger:objx] forKey:@"x"];
                
                NSInteger objy = [[objectMap[i] valueForKey:@"y"] integerValue];
                [tempAry setObject:[NSNumber numberWithInteger:objy] forKey:@"y"];
                //center
                NSInteger centerX = objx - objWidth;
                NSInteger centerY = objy - objHeight;
                
                [mapData setObject:[NSNumber numberWithInteger:centerX] forKey:@"centerX"];
                [mapData setObject:[NSNumber numberWithInteger:centerY] forKey:@"centerY"];
                
                [mapData setObject:tempAry forKey:objType];
                // [self dropGoldBag:objy :objy];
            }

            if ([objType isEqualToString:@"gold"]) {
                   // NSLog(@"gold");
                    NSString *objName = [objectMap[i] valueForKey:@"name"];
                    [tempAry setObject:objName forKey:@"name"];
                    
                    NSInteger objHeight = [[objectMap[i] valueForKey:@"height"] integerValue];
                    [tempAry setObject:[NSNumber numberWithInteger:objHeight] forKey:@"heighs"];
                    
                    NSInteger objWidth =  [[objectMap[i] valueForKey:@"width"] integerValue];
                    [tempAry setObject:[NSNumber numberWithInteger:objWidth] forKey:@"width"];
                    
                    NSInteger objx = [[objectMap[i] valueForKey:@"x"] integerValue];
                    [tempAry setObject:[NSNumber numberWithInteger:objx] forKey:@"x"];
                    
                    NSInteger objy = [[objectMap[i] valueForKey:@"y"] integerValue];
                    [tempAry setObject:[NSNumber numberWithInteger:objy] forKey:@"y"];
                    //center
                    NSInteger centerX = objx - objWidth;
                    NSInteger centerY = objy - objHeight;
                    
                    [mapData setObject:[NSNumber numberWithInteger:centerX] forKey:@"centerX"];
                    [mapData setObject:[NSNumber numberWithInteger:centerY] forKey:@"centerY"];
                    
                    [mapData setObject:tempAry forKey:objType];
                    
                   // [self dropGoldBag:objy :objy];
                }
                
                if ([objType isEqualToString:@"path"]) {
                  
                    NSString *objName = [objectMap[i] valueForKey:@"name"];
                    [tempAry setObject:objName forKey:@"name"];
                    
                  //  NSInteger objSeq = [[objectMap[i] valueForKey:@"name"] integerValue];
                  //  [tempAry setObject:[NSNumber numberWithInt:objSeq] forKey:@"seq"];

                    NSInteger objHeight = [[objectMap[i] valueForKey:@"height"] integerValue];
                    [tempAry setObject:[NSNumber numberWithInteger:objHeight] forKey:@"heighs"];
                    
                    NSInteger objWidth =  [[objectMap[i] valueForKey:@"width"] integerValue];
                    [tempAry setObject:[NSNumber numberWithInteger:objWidth] forKey:@"width"];
                    
                    NSInteger objx = [[objectMap[i] valueForKey:@"x"] integerValue];
                    [tempAry setObject:[NSNumber numberWithInteger:objx] forKey:@"pathx"];
                    
                    NSInteger objy = [[objectMap[i] valueForKey:@"y"] integerValue];
                    [tempAry setObject:[NSNumber numberWithInteger:objy] forKey:@"pathy"];
                    
                    NSArray *pathData = [objectMap[i] valueForKey:@"polylinePoints"];
                    [tempAry setObject:pathData forKey:@"path"];
                  //  NSLog(@"path:%@",pathData);
                    [mapData setObject:tempAry forKey:@"pathData"];
                  //  [self goldBag:objy :objy];
                }
            
            NSString *wallLayer = [NSString stringWithFormat:@"layer%d",layerNum];
            //use this for testing
          //  NSLog(@"wallLayer:%@ objectType:%@",wallLayer,objType);
            if ([objType isEqualToString:wallLayer]) {
              //  NSLog(@"wall Layers:%@",wallLayer);
                SKSpriteNode *wallNodeLayer = [[SKSpriteNode alloc]init];
                
                NSString *objName = [objectMap[i] valueForKey:@"name"];
                [tempAry setObject:objName forKey:@"name"];
                
                NSInteger objHeight = [[objectMap[i] valueForKey:@"height"] integerValue];
                [tempAry setObject:[NSNumber numberWithInteger:objHeight] forKey:@"heighs"];
                
                NSInteger objWidth =  [[objectMap[i] valueForKey:@"width"] integerValue];
                [tempAry setObject:[NSNumber numberWithInteger:objWidth] forKey:@"width"];
                
                NSInteger objx = [[objectMap[i] valueForKey:@"x"] integerValue];
                [tempAry setObject:[NSNumber numberWithInteger:objx] forKey:@"x"];
                
                NSInteger objy = [[objectMap[i] valueForKey:@"y"] integerValue];
                [tempAry setObject:[NSNumber numberWithInteger:objy] forKey:@"y"];
                //walldata
                NSString *wallDataStr = [objectMap[i] valueForKey:@"polylinePoints"];
              //  NSLog(@"polylinePoint:%@",wallDataStr);
                //create the wall line array
                NSArray *wallLineArray = [wallDataStr componentsSeparatedByString:@" "];
                //
                SKShapeNode *line = [SKShapeNode node];
                CGMutablePathRef path = CGPathCreateMutable();
                
                for (int i = 0; i < wallLineArray.count; i++) {
                    NSArray *XYLocations = [wallLineArray[i] componentsSeparatedByString:@","];
                    float x = [XYLocations[0] floatValue];
                    float y = -[XYLocations[1] floatValue];
                    //NSLog(@"\nx:%f\n y:%f\n",x,y);
                    if (i == 0) {
                        CGPathMoveToPoint(path, NULL, x, y);//start
                    } else {
                        CGPathAddLineToPoint(path, NULL, x, y);//add lines
                    }//end if
                }//end for loop
                line.path = path;
                line.lineWidth = 1;
                [line setStrokeColor:[UIColor blackColor]];
                line.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:path];
                line.physicsBody.dynamic = NO;
                line.physicsBody.categoryBitMask = wallCategory;
                
                //wallNode.shadowCastBitMask = 1;
                [wallNodeLayer addChild:line];
                
                [self addChild:wallNodeLayer];
                wallNodeLayer.position = CGPointMake(objx,objy);
                [tempAry setObject:line forKey:@"wallData1"];
                [mapData setObject:tempAry forKey:objType];
                
                //    NSLog(@"walls:%d objectName:%@ %@",layerNum,objName);
                //  NSLog(@"tempAry:%@",tempAry);
                layerNum ++;
            }//end if maplayers
            
                if ([objType isEqualToString:@"wall"]) {
                    SKSpriteNode *wallNode = [[SKSpriteNode alloc]init];
                //NSLog(@"tempAry Wall:%@",tempAry);
                    NSString *objName = [objectMap[i] valueForKey:@"name"];
                    [tempAry setObject:objName forKey:@"name"];
                    
                    NSInteger objHeight = [[objectMap[i] valueForKey:@"height"] integerValue];
                    [tempAry setObject:[NSNumber numberWithInteger:objHeight] forKey:@"heighs"];
                    
                    NSInteger objWidth =  [[objectMap[i] valueForKey:@"width"] integerValue];
                    [tempAry setObject:[NSNumber numberWithInteger:objWidth] forKey:@"width"];
                    
                    NSInteger objx = [[objectMap[i] valueForKey:@"x"] integerValue];
                    [tempAry setObject:[NSNumber numberWithInteger:objx] forKey:@"x"];
                    
                    NSInteger objy = [[objectMap[i] valueForKey:@"y"] integerValue];
                    [tempAry setObject:[NSNumber numberWithInteger:objy] forKey:@"y"];
                //walldata
                    NSArray *wallDataStr = [objectMap valueForKey:@"polylinePoints"];
                 //NSLog(@"polylinePoint:%@",wallDataStr[0]);
                    //create the wall line array

                    NSArray *wallLineArray = [wallDataStr[0] componentsSeparatedByString:@" "];
                 //NSLog(@"wallLineArray:%@",wallLineArray);
                    //
                    SKShapeNode *line = [SKShapeNode node];
                    CGMutablePathRef path = CGPathCreateMutable();

                    for (int i = 0; i < wallLineArray.count; i++) {
                        NSArray *XYLocations = [wallLineArray[i] componentsSeparatedByString:@","];
                        float x = [XYLocations[0] floatValue];
                        float y = -[XYLocations[1] floatValue];
                       // NSLog(@"\nx:%f\n y:%f\n",x,y);
                        if (i == 0) {
                            CGPathMoveToPoint(path, NULL, x, y);//start
                        } else {
                            CGPathAddLineToPoint(path, NULL, x, y);//add lines
                        }//end if
                    }//end for loop

                    line.path = path;
                    [line setStrokeColor:[UIColor blackColor]];
                    line.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:path];
                    line.physicsBody.dynamic = NO;
                    line.physicsBody.categoryBitMask = wallCategory;
                    [wallNode addChild:line];
                    
                    [self addChild:wallNode];
                    wallNode.position = CGPointMake(objx,objy);
                    [tempAry setObject:line forKey:@"wallData"];
                    [mapData setObject:tempAry forKey:objType];
              }//end if wall
        }//end loop
    }//end if
   //NSLog(@"return mapdata %@",mapData);
   //NSLog(@"show one entry %@",[[mapData valueForKey:@"path"] valueForKey:@"polylinePoints"]);
    return mapData;
}
-(int) mapHeight {
    //NSLog(@"map layers:%@",[self.map.layers objectAtIndex:0]);
    return self.map.mapSize.height*150;
}
-(int) mapWidth {
    return  self.map.mapSize.width*150;
}

@end
