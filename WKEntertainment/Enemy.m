//
//  Enermy.m
//  WKEntertainment
//
//  Created by Nguyen Binh on 6/9/14.
//  Copyright (c) 2014 ninjacoderz. All rights reserved.
//

#import "Enemy.h"

@implementation Enemy
// Overide isEqual
- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[Enemy class]]) return NO;
    

    Enemy *other = (Enemy *)object;
    // Just check position
    return (other.column == self.column && other.row == self.row);
     NSLog(@"Check equal");
}

@end
