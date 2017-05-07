//
//  LESearchTableViewController.h
//  smartBus
//
//  Created by Eda on 2017/4/14.
//  Copyright © 2017年 Eda. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedItem)(NSString *item);

@interface BusRoute : NSObject

@property (strong, nonatomic) UIImage *searchImg;
@property (strong, nonatomic) NSString *searchTitle;
@property (strong, nonatomic) NSNumber *searchId;
+ (NSMutableArray *)getModelData;



@end


@interface LEHomeTableViewController : UITableViewController

@property (strong, nonatomic) SelectedItem block;

- (void)didSelectedItem:(SelectedItem)block;

@end
