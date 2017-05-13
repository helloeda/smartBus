//
//  LEBusStopTableViewCell.m
//  smartBus
//
//  Created by Eda on 2017/4/16.
//  Copyright © 2017年 Eda. All rights reserved.
//

#import "LEBusStopTableViewCell.h"
#import "LEBusStop.h"
@interface LEBusStopTableViewCell()


@end


@implementation LEBusStopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




- (void)setStop:(LEBusStop *)stop
{
    _stop = stop;
    self.isHereView.hidden = YES;
    self.seatLbl.hidden = YES;
    self.stopNameLbl.text = stop.stop_name;

}




+(instancetype)busStopTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"bus_stop_cell";
    LEBusStopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LEBusStopTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
    
}

@end
