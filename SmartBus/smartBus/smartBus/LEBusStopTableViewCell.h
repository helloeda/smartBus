//
//  LEBusStopTableViewCell.h
//  smartBus
//
//  Created by Eda on 2017/4/16.
//  Copyright © 2017年 Eda. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LEBusStop;
@interface LEBusStopTableViewCell : UITableViewCell
@property (nonatomic, strong) LEBusStop *stop;

@property (weak, nonatomic) IBOutlet UIImageView *isHereView;
@property (weak, nonatomic) IBOutlet UILabel *stopNoLbl;
@property (weak, nonatomic) IBOutlet UILabel *stopNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *seatLbl;
+(instancetype)busStopTableViewCellWithTableView:(UITableView *)tableView;

@end
