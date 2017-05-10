//
//  LESearchTableViewController.m
//  smartBus
//
//  Created by Eda on 2017/4/14.
//  Copyright © 2017年 Eda. All rights reserved.
//
#import "AppDelegate.h"
#import "LETransferSearchController.h"
#import "LEStopTableViewCell.h"
#import "HCSortString.h"
#import "ZYPinYinSearch.h"
#import <objc/runtime.h>
#import "LEStopMapController.h"
#import "MBProgressHUD+MJ.h"

#define kColor          [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];


@implementation SearchBusStop

+ (NSMutableArray *)getModelData {
    
    
    NSString *home = NSHomeDirectory();
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
    NSString *filepath = [docPath stringByAppendingPathComponent:@"stop.plist"];
    //从沙盒读取
    NSArray *arrayDict = [NSArray arrayWithContentsOfFile:filepath];
    
    if(arrayDict.count == 0)
    {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"stop" ofType:@"plist"];
        arrayDict = [NSArray arrayWithContentsOfFile:plistPath];
    }
    
    NSMutableArray *ary = [NSMutableArray new];
    
    for (NSInteger index = 0; index < arrayDict.count;index++){
        SearchBusStop *stop = [SearchBusStop new];
        stop.searchImg = [UIImage imageNamed:@"stop_site"];
        stop.searchTitle = arrayDict[index][@"stop_name"];
        stop.searchId = arrayDict[index][@"stop_id"];
        [ary addObject:stop];
    }
    return ary;
}

@end

@interface LETransferSearchController ()<UISearchResultsUpdating>

@property (strong, nonatomic) SearchBusStop *stop;

@property (strong, nonatomic) NSArray *ary;
@property (strong, nonatomic) NSMutableArray *dataSource;/**<排序前的整个数据源*/
@property (strong, nonatomic) NSDictionary *allDataSource;/**<排序后的整个数据源*/
@property (strong, nonatomic) NSMutableArray *searchDataSource;/**<搜索结果数据源*/
@property (strong, nonatomic) NSArray *indexDataSource;/**<索引数据源*/
@property (nonatomic, strong) NSArray *arrayStop;

@end

@implementation LETransferSearchController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
    self.tabBarController.tabBar.hidden=NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadStop];
    [self getData];
    self.navigationItem.title = @"站点搜索";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];//导航栏字体颜色
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.delegate = self;
    self.tableView.showsVerticalScrollIndicator = FALSE;
    self.tableView.backgroundColor = kColor;
    [self.tableView setTableHeaderView:self.searchController.searchBar];
}


#pragma mark - -------
- (void)getData {
    _dataSource = [SearchBusStop getModelData];
    
    _allDataSource = [HCSortString sortAndGroupForArray:_dataSource PropertyName:@"searchTitle"];
    _indexDataSource = [HCSortString sortForStringAry:[_allDataSource allKeys]];
    _searchDataSource = [NSMutableArray new];
}

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = YES;
        _searchController.searchBar.placeholder = @"输入公交站名称";
        [_searchController.searchBar sizeToFit];
    }
    return _searchController;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.searchController.active) {
        return _indexDataSource.count;
    }else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.searchController.active) {
        NSArray *value = [_allDataSource objectForKey:_indexDataSource[section]];
        return value.count;
    }else {
        return _searchDataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LEStopTableViewCell  *cell = [LEStopTableViewCell stopTableViewCellWithTableView:tableView];
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    
    if (!self.searchController.active) {
        NSArray *value = [_allDataSource objectForKey:_indexDataSource[indexPath.section]];
        _stop = value[indexPath.row];
    }else{
        _stop = _searchDataSource[indexPath.row];
    }
    [cell configCellWithModel:_stop];
    [self loadStopDetail:_stop.searchId];
    return cell;
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.searchController.active) {
        NSArray *value = [_allDataSource objectForKey:_indexDataSource[indexPath.section]];
        _stop = value[indexPath.row];
    }else{
        _stop = _searchDataSource[indexPath.row];
    }
    //    self.block(_student.searchTitle);
    
//    UIStoryboard *story=[UIStoryboard  storyboardWithName:@"Main" bundle:nil];
//    LEStopMapController *stopMapVC = [story instantiateViewControllerWithIdentifier:@"stopMap"];
//    stopMapVC.stopId = _stop.searchId;
//    [self.navigationController pushViewController:stopMapVC  animated:YES];
    
    //此页面已经存在于self.navigationController.viewControllers中,并且是当前页面的前一页面
    LETransferViewController *transferVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
  
    
    // 1.获得沙盒根路径
    NSString *home = NSHomeDirectory();
    // 2.document路径
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
    // 3.文件路径
    NSString *fileName = [NSString stringWithFormat:@"stop_detail_%@.plist", _stop.searchId];
    NSString *filepath = [docPath stringByAppendingPathComponent:fileName];
    
    
    NSDictionary *stopDetail= [[NSDictionary alloc] initWithContentsOfFile:filepath];
    if(self.originOrTerminal) {
        //初始化其属性
        transferVC.origin.titleLabel.text = [NSString stringWithFormat:@"   从   %@",_stop.searchTitle];
        transferVC.origin.latitude = stopDetail[@"stop_latitude"];
        transferVC.origin.longitude = stopDetail[@"stop_longitude"];
    }
    else{
        //初始化其属性
        transferVC.terminal.titleLabel.text = [NSString stringWithFormat:@"   到   %@",_stop.searchTitle];
        transferVC.terminal.latitude = stopDetail[@"stop_latitude"];
        transferVC.terminal.longitude = stopDetail[@"stop_longitude"];
    }
         //使用popToViewController返回并传值到上一页面
    [self.navigationController popToViewController:transferVC animated:true];
    
  
   }

#pragma mark - UISearchDelegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [_searchDataSource removeAllObjects];
    NSArray *ary = [NSArray new];
    //对排序好的数据进行搜索
    ary = [HCSortString getAllValuesFromDict:_allDataSource];
    
    if (searchController.searchBar.text.length == 0) {
        [_searchDataSource addObjectsFromArray:ary];
    }else {
        ary = [ZYPinYinSearch searchWithOriginalArray:ary andSearchText:searchController.searchBar.text andSearchByPropertyName:@"searchTitle"];
        [_searchDataSource addObjectsFromArray:ary];
    }
    [self.tableView reloadData];
}

#pragma mark - block
- (void)didSelectedItem:(SelectedItem)block {
    self.block = block;
}


-(void) loadStop{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    // 1.设置请求路径
    NSURL *URL=[NSURL URLWithString:@"http://smartbus.eda.im/get/stop/list"];
    
    // 2.创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
    request.timeoutInterval=5.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
    // 3.设置请求体
    
    // 4.设置请求头信息
    [request setValue:@"ios+android" forHTTPHeaderField:@"User-Agent"];
    
    //沙盒路径
    NSString *home = NSHomeDirectory();
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
    NSString *filepath = [docPath stringByAppendingPathComponent:@"stop.plist"];
    
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
        
        NSArray *arrayDict = [[NSArray alloc] init];
        
        if (connectionError || data == nil)
        {
            //从沙盒读取
            arrayDict = [NSArray arrayWithContentsOfFile:filepath];
            self.arrayStop = arrayDict;
            
        }
        else {
            id dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            NSNumber *status = dict[@"status"];
            id dictMessage = dict[@"message"];
            
            if([status  isEqual: @1])
            {
                //暂时存储到沙盒
                [dictMessage writeToFile:filepath atomically:YES];
            }
            //从沙盒读取
            arrayDict = [NSArray arrayWithContentsOfFile:filepath];
            self.arrayStop = arrayDict;
        }
        
    }];
    [dataTask resume];
    
}


-(void) loadStopDetail: (NSNumber*)stopId{
    //沙盒路径
    NSString *home = NSHomeDirectory();
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
    NSString *fileName = [NSString stringWithFormat:@"stop_detail_%@.plist", stopId];
    NSString *filepath = [docPath stringByAppendingPathComponent:fileName];
    
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:filepath];
    
    if(!exist){
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
        // 1.设置请求路径
        
        NSString *originUrl = [NSString stringWithFormat:@"http://smartbus.eda.im/get/stop/detail/%@",stopId];
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
                //暂时存储到沙盒
                [dictMessage writeToFile:filepath atomically:YES];
            }
            
        }];
        [dataTask resume];
        
    }
    
}



- (void)didPresentSearchController:(UISearchController *)searchController{
    self.tabBarController.tabBar.hidden=YES;
    
}

- (void)didDismissSearchController:(UISearchController *)searchController{
    self.tabBarController.tabBar.hidden=NO;
}


@end
