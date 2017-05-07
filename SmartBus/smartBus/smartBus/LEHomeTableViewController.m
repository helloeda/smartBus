//
//  LESearchTableViewController.m
//  smartBus
//
//  Created by Eda on 2017/4/14.
//  Copyright © 2017年 Eda. All rights reserved.
//
#import "AppDelegate.h"
#import "LEHomeTableViewController.h"
#import "LESearchTableViewCell.h"
#import "HCSortString.h"
#import "ZYPinYinSearch.h"
#import <objc/runtime.h>
#import "LEBusViewController.h"
#import "MBProgressHUD+MJ.h"
#define kColor          [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];


@implementation BusRoute

+ (NSMutableArray *)getModelData {
 
    
    NSString *home = NSHomeDirectory();
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
    NSString *filepath = [docPath stringByAppendingPathComponent:@"route.plist"];
    //从沙盒读取
    NSArray *arrayDict = [NSArray arrayWithContentsOfFile:filepath];
   
    if(arrayDict.count == 0)
    {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"route" ofType:@"plist"];
        arrayDict = [NSArray arrayWithContentsOfFile:plistPath];
    }
    
    NSMutableArray *ary = [NSMutableArray new];
 
    for (NSInteger index = 0; index < arrayDict.count;index++){
        BusRoute *route = [BusRoute new];
        route.searchImg = [UIImage imageNamed:@"home_bus"];
        route.searchTitle = arrayDict[index][@"route_name"];
        route.searchId = arrayDict[index][@"route_id"];
        [ary addObject:route];
    }
    return ary;
}

@end

@interface LEHomeTableViewController ()<UISearchResultsUpdating>

@property (strong, nonatomic) BusRoute *route;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSArray *ary;
@property (strong, nonatomic) NSMutableArray *dataSource;/**<排序前的整个数据源*/
@property (strong, nonatomic) NSDictionary *allDataSource;/**<排序后的整个数据源*/
@property (strong, nonatomic) NSMutableArray *searchDataSource;/**<搜索结果数据源*/
@property (strong, nonatomic) NSArray *indexDataSource;/**<索引数据源*/
@property (nonatomic, strong) NSArray *arrayRoute;

@end

@implementation LEHomeTableViewController 


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadRoute];
    [self getData];
    self.tableView.backgroundColor = kColor;
    [self.tableView setTableHeaderView:self.searchController.searchBar];
}

#pragma mark - -------
- (void)getData {
    _dataSource = [BusRoute getModelData];
  
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
        _searchController.searchBar.placeholder = @"输入公交线路";
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
//头部索引标题
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (!self.searchController.active) {
//        return _indexDataSource[section];
//    }else {
//        return nil;
//    }
//}
//右侧索引列表
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    if (!self.searchController.active) {
//        return _indexDataSource;
//    }else {
//        return nil;
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     LESearchTableViewCell *cell = [LESearchTableViewCell searchTableViewCellWithTableView:tableView];
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    
    if (!self.searchController.active) {
        NSArray *value = [_allDataSource objectForKey:_indexDataSource[indexPath.section]];
        _route = value[indexPath.row];
    }else{
        _route = _searchDataSource[indexPath.row];
    }
    [cell configCellWithModel:_route];
    [self loadRouteDetail:_route.searchId];
    return cell;
}
//索引点击事件
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
////    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
////    return index;
//    
//
//
//
//        UIStoryboard *story=[UIStoryboard  storyboardWithName:@"Main" bundle:nil];
//        LEBusViewController *homeDetailVC = [story instantiateViewControllerWithIdentifier:@"busDetail"];
//    
//        [self.navigationController pushViewController:homeDetailVC animated:YES];
//    return 1;
//    
//
//
//}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.searchController.active) {
        NSArray *value = [_allDataSource objectForKey:_indexDataSource[indexPath.section]];
        _route = value[indexPath.row];
    }else{
        _route = _searchDataSource[indexPath.row];
    }
//    self.block(_student.searchTitle);
  
    UIStoryboard *story=[UIStoryboard  storyboardWithName:@"Main" bundle:nil];
    LEBusViewController *busDetailVC = [story instantiateViewControllerWithIdentifier:@"busDetail"];
    busDetailVC.routeId = _route.searchId;
    [self.navigationController pushViewController:busDetailVC animated:YES];
    
    self.searchController.active = NO;
    //[self.navigationController popViewControllerAnimated:YES];
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


-(void) loadRoute{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    // 1.设置请求路径
    NSURL *URL=[NSURL URLWithString:@"http://smartbus.eda.im/get/route/list"];
    
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
    NSString *filepath = [docPath stringByAppendingPathComponent:@"route.plist"];
    
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
        
        NSArray *arrayDict = [[NSArray alloc] init];
        
        if (connectionError || data == nil)
        {
            //从沙盒读取
            arrayDict = [NSArray arrayWithContentsOfFile:filepath];
            self.arrayRoute = arrayDict;
            
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
            self.arrayRoute = arrayDict;
        }
        
    }];
    [dataTask resume];

}


-(void) loadRouteDetail: (NSNumber*)routeid{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    // 1.设置请求路径
    
    NSString *originUrl = [NSString stringWithFormat:@"http://smartbus.eda.im/get/route/detail/%@",routeid];
    NSURL *URL=[NSURL URLWithString:originUrl];
    
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
    NSString *fileName = [NSString stringWithFormat:@"route_detail_%@.plist", routeid];
    NSString *filepath = [docPath stringByAppendingPathComponent:fileName];
    
    
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

@end
