//
//  LEStopTableViewCell.m
//  smartBus
//
//  Created by Eda on 2017/4/14.
//  Copyright © 2017年 Eda. All rights reserved.
//

#import "LEStopTableViewCell.h"

@implementation LEStopTableViewCell

- (void)configCellWithModel:(BusStop *)model {
    BusStop *stop = model;
    self.searchImg.image = stop.searchImg;
    //    self.searchImg.backgroundColor = [UIColor redColor];
    self.searchTitle.text = [NSString stringWithFormat:@"%@",stop.searchTitle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

+(instancetype)stopTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cart_cell";
    LEStopTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LEStopTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



@end
