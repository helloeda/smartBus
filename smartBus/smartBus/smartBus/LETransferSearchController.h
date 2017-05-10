
//  LESearchTableViewController.h
//  smartBus
//
//  Created by Eda on 2017/4/14.
//  Copyright © 2017年 Eda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETransferViewController.h"
typedef void(^SelectedItem)(NSString *item);

@interface SearchBusStop : NSObject

@property (strong, nonatomic) UIImage *searchImg;
@property (strong, nonatomic) NSString *searchTitle;
@property (strong, nonatomic) NSNumber *searchId;
+ (NSMutableArray *)getModelData;



@end


@interface LETransferSearchController : UITableViewController
@property (assign) BOOL originOrTerminal;
@property (strong, nonatomic) SelectedItem block;
@property (strong, nonatomic) UISearchController *searchController;

- (void)didSelectedItem:(SelectedItem)block;

@end
