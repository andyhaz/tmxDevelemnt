//
//  game_utils.m
//  puffer
//
//  Created by andy hazlett on 11/18/14.
//  Copyright (c) 2014 andy hazlett. All rights reserved.
//

#import "game_utils.h"

@implementation game_utils

- (float)pointPairToBearingDegrees :(CGPoint)startingPoint secondPoint :(CGPoint) endingPoint {
    
    float angleVal = atan2((endingPoint.x - startingPoint.x) , (endingPoint.y - startingPoint.y));
    return angleVal;
}

//end
-(int)convertInt :(NSString*)strNumber{
    return [strNumber intValue];
}

-(NSString*)converStr :(int)number{
    return [NSString stringWithFormat:@"%d",number];
}
@end
