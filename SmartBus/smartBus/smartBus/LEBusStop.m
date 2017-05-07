//
//  LEBusStop.m
//  smartBus
//
//  Created by Eda on 2017/4/16.
//  Copyright © 2017年 Eda. All rights reserved.
//

#import "LEBusStop.h"

@implementation LEBusStop

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)stopWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
    
}


@end
