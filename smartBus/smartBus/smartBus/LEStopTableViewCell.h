//
//  LEStopTableViewCell.h
//  smartBus
//
//  Created by Eda on 2017/4/14.
//  Copyright © 2017年 Eda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEStopTableViewController.h"

@interface LEStopTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *searchImg;
@property (strong, nonatomic) IBOutlet UILabel *searchTitle;


+(instancetype)stopTableViewCellWithTableView:(UITableView *)tableView;
- (void)configCellWithModel:(BusStop *)model;

@end
