//
//  LEBusViewController.m
//  smartBus
//
//  Created by Eda on 2017/4/16.
//  Copyright © 2017年 Eda. All rights reserved.
//
#import "LEBusStop.h"
#import "LEBusViewController.h"
#import "LEBusStopTableViewCell.h"
@interface LEBusViewController ()
@property (weak, nonatomic) IBOutlet UILabel *startStopLbl;
@property (weak, nonatomic) IBOutlet UILabel *endStopLbl;
@property (weak, nonatomic) IBOutlet UILabel *operateTimeLbl;

- (IBAction)refreshBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lengthLbl;

@property (weak, nonatomic) IBOutlet UITableView *busTableView;
- (IBAction)changeBtn:(id)sender;
@property (nonatomic, strong) NSDictionary *routeData;
@property (nonatomic, strong) NSMutableArray *stops;
@end


@implementation LEBusViewController

#pragma mark - 懒加载数据

- (NSMutableArray *)stops
{
    if(_stops == nil)
    {
        NSMutableArray *arrayModel = [NSMutableArray array];
        for (NSDictionary *dict in self.routeData[@"route_stop_list"]) {
            LEBusStop *model = [LEBusStop stopWithDict:dict];
            [arrayModel addObject:model];
        }
        _stops = arrayModel;
    }
    return _stops;
    
}


- (void)viewDidLoad {
    
    
 
    [super viewDidLoad];
    [self loadRouteDetail];
    
  
  
    self.startStopLbl.text = [NSString stringWithFormat:@"%@",[[self.stops firstObject] stop_name]];
    self.endStopLbl.text = [NSString stringWithFormat:@"%@", [[self.stops lastObject] stop_name]];
    
    
    self.lengthLbl.text = [NSString stringWithFormat:@"全程 %@ 公里", self.routeData[@"route_price"]];
    self.operateTimeLbl.text = [NSString stringWithFormat:@"时间%@ - %@ 票价 %@元", self.routeData[@"route_start_time"], self.routeData[@"route_end_time"], self.routeData[@"route_price"]];

    

    self.busTableView.showsVerticalScrollIndicator = FALSE;
    self.busTableView.rowHeight = 75;
    
    self.busTableView.separatorStyle = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.stops.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1. 获取数据模型
    LEBusStop *model = self.stops[indexPath.row];
    //2. 通过xib方式创建单元格
    LEBusStopTableViewCell *cell = [LEBusStopTableViewCell busStopTableViewCellWithTableView:tableView];
    //3. 把模型数据设置给单元格
    cell.stop = model;
    cell.stopNoLbl.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    //4. 返回cell
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) loadRouteDetail{
    
    // 1.获得沙盒根路径
    NSString *home = NSHomeDirectory();
    // 2.document路径
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
    // 3.文件路径
    NSString *fileName = [NSString stringWithFormat:@"route_detail_%@.plist", self.routeId];
    NSString *filepath = [docPath stringByAppendingPathComponent:fileName];

    
    NSDictionary *routeDetail= [[NSDictionary alloc] initWithContentsOfFile:filepath];
    
    self.routeData = routeDetail;
  
   
}

- (IBAction)changeBtn:(id)sender {
}
- (IBAction)refreshBtn:(id)sender {
}
@end
