//
//  LESearchTableViewController.m
//  smartBus
//
//  Created by Eda on 2017/4/14.
//  Copyright © 2017年 Eda. All rights reserved.
//
#import "AppDelegate.h"
#import "LEStopTableViewController.h"
#import "LEStopTableViewCell.h"
#import "HCSortString.h"
#import "ZYPinYinSearch.h"
#import <objc/runtime.h>
#import "LEStopMapController.h"
#import "MBProgressHUD+MJ.h"
#define kColor          [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];


@implementation BusStop

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
        BusStop *stop = [BusStop new];
        stop.searchImg = [UIImage imageNamed:@"stop_site"];
        stop.searchTitle = arrayDict[index][@"stop_name"];
        stop.searchId = arrayDict[index][@"stop_id"];
        [ary addObject:stop];
    }
    return ary;
}

@end

@interface LEStopTableViewController ()<UISearchResultsUpdating>

@property (strong, nonatomic) BusStop *stop;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSArray *ary;
@property (strong, nonatomic) NSMutableArray *dataSource;/**<排序前的整个数据源*/
@property (strong, nonatomic) NSDictionary *allDataSource;/**<排序后的整个数据源*/
@property (strong, nonatomic) NSMutableArray *searchDataSource;/**<搜索结果数据源*/
@property (strong, nonatomic) NSArray *indexDataSource;/**<索引数据源*/
@property (nonatomic, strong) NSArray *arrayStop;

@end

@implementation LEStopTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadStop];
    [self getData];
    
    self.searchController.delegate = self;
    self.tableView.showsVerticalScrollIndicator = FALSE;
    self.tableView.backgroundColor = kColor;
    [self.tableView setTableHeaderView:self.searchController.searchBar];
}

#pragma mark - -------
- (void)getData {
    _dataSource = [BusStop getModelData];
    
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
    
    UIStoryboard *story=[UIStoryboard  storyboardWithName:@"Main" bundle:nil];
    LEStopMapController *stopMapVC = [story instantiateViewControllerWithIdentifier:@"stopMap"];
    stopMapVC.stopId = _stop.searchId;
    [self.navigationController pushViewController:stopMapVC  animated:YES];
    
    self.searchController.active = NO;
    
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
