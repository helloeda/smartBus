//
//  LESearchTableViewCell.m
//  smartBus
//
//  Created by Eda on 2017/4/14.
//  Copyright © 2017年 Eda. All rights reserved.
//

#import "LESearchTableViewCell.h"

@implementation LESearchTableViewCell

- (void)configCellWithModel:(BusRoute *)model {
    BusRoute *route = model;
    self.searchImg.image = route.searchImg;
//    self.searchImg.backgroundColor = [UIColor redColor];
    self.searchTitle.text = [NSString stringWithFormat:@"%@",route.searchTitle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

+(instancetype)searchTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cart_cell";
    LESearchTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LESearchTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



@end
