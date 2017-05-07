//
//  LESearchTableViewCell.h
//  smartBus
//
//  Created by Eda on 2017/4/14.
//  Copyright © 2017年 Eda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEHomeTableViewController.h"

@interface LESearchTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *searchImg;
@property (strong, nonatomic) IBOutlet UILabel *searchTitle;


+(instancetype)searchTableViewCellWithTableView:(UITableView *)tableView;
- (void)configCellWithModel:(BusRoute *)model;

@end
