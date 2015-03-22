//
//  game_utils.h
//  puffer
//
//  Created by andy hazlett on 11/18/14.
//  Copyright (c) 2014 andy hazlett. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKTUtils.h"

@interface game_utils : NSObject
- (float)pointPairToBearingDegrees :(CGPoint)startingPoint secondPoint :(CGPoint) endingPoint;
-(int)convertInt :(NSString*)strNumber;
-(NSString*)converStr :(int)number;

@end
