//
//  Heros.m
//  WKEntertainment
//
//  Created by Nguyen Binh on 6/15/14.
//  Copyright (c) 2014 ninjacoderz. All rights reserved.
//

#import "Hero.h"

@implementation Hero

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[Hero class]]) return NO;
    
    
    Hero *other = (Hero *)object;
    // Just check position
    return (other.column == self.column && other.row == self.row);
    
}

@end
