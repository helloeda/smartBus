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
@property (nonatomic, strong) NSDictionary *current;
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
    [self loadCurrent];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(loadCurrent) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    self.startStopLbl.text = [NSString stringWithFormat:@"%@",[[self.stops firstObject] stop_name]];
    self.endStopLbl.text = [NSString stringWithFormat:@"%@", [[self.stops lastObject] stop_name]];
    
    
    self.lengthLbl.text = [NSString stringWithFormat:@"全程 %@ 公里", self.routeData[@"route_length"]];
    self.operateTimeLbl.text = [NSString stringWithFormat:@"时间%@ - %@ 票价 %@元", self.routeData[@"route_start_time"], self.routeData[@"route_end_time"], self.routeData[@"route_price"]];

    self.title = [NSString stringWithFormat:@"%@", self.routeData[@"route_name"]];

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
    
    if(_current) {
        for (NSDictionary *tmp in _current) {
            if(tmp[@"current_stop"] == model.stop_id){
                cell.isHereView.hidden = NO;
                cell.seatLbl.hidden = NO;
                cell.seatLbl.text = [NSString stringWithFormat:@"%@/%@ 💺",tmp[@"current_passenger"],tmp[@"bus_capacity"]];
            }
        }
        
         }
    
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


-(void) loadCurrent{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    // 1.设置请求路径
    
    NSString *originUrl = [NSString stringWithFormat:@"http://smartbus.eda.im/get/current/%@",_routeId];
    NSURL *URL=[NSURL URLWithString:originUrl];
    
    // 2.创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
    request.timeoutInterval=5.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
    // 3.设置请求体
    
    // 4.设置请求头信息
    [request setValue:@"ios+android" forHTTPHeaderField:@"User-Agent"];
    
    //沙盒路径
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
        
        id dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSNumber *status = dict[@"status"];
        id dictMessage = dict[@"message"];
        
        if([status  isEqual: @1])
        {
            self.current = dictMessage;
            [self.busTableView reloadData];
        }
        
    }];
    [dataTask resume];
    


}

- (IBAction)changeBtn:(id)sender {
    NSArray* reversedArray = [[self.stops reverseObjectEnumerator] allObjects];
    self.stops = (NSMutableArray *)reversedArray;
    self.startStopLbl.text = [NSString stringWithFormat:@"%@",[[self.stops firstObject] stop_name]];
    self.endStopLbl.text = [NSString stringWithFormat:@"%@", [[self.stops lastObject] stop_name]];

    [self.busTableView reloadData];

}
- (IBAction)refreshBtn:(id)sender {
    [self loadCurrent];
 

}
@end
