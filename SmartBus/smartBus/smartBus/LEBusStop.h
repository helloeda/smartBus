//
//  LEBusStop.h
//  smartBus
//
//  Created by Eda on 2017/4/16.
//  Copyright © 2017年 Eda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEBusStop : NSObject
@property (nonatomic, copy) NSNumber *stop_id;
@property (nonatomic, copy) NSString *stop_name;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)stopWithDict:(NSDictionary *)dict;

@end
