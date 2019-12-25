//
//  StationMachinePictureController.m
//  Frame
//
//  Created by hibayWill on 2018/5/18.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "StationMachinePictureController.h"

#import <UIImageView+WebCache.h>
#import <MJExtension.h>

@interface StationMachinePictureController ()<UITableViewDataSource,UITableViewDelegate>

/** 请求管理者 */
//@property (nonatomic,weak) AFHTTPSessionManager * manager;
/** 用于加载下一页的参数(页码) */
@property(nonatomic) UITableView *tableview;
@end

@implementation StationMachinePictureController

#pragma mark - 全局常量



#pragma mark - life cycle 生命周期方法

- (void)viewDidLoad {
    self.tableview.delegate =self;
    self.tableview.dataSource =self;
    self.tableview.separatorStyle = NO;
    self.title = _thisTitle;
    [super viewDidLoad];
    [self backBtn];
   
    
}
-(void)viewWillAppear:(BOOL)animated{
   
  
}
#pragma mark - private methods 私有方法


-(void)viewWillDisappear:(BOOL)animated{
    //NSLog(@"StationMachinePictureController viewWillDisappear");
}

-(void)viewDidAppear:(BOOL)animated{
    // NSLog(@"viewDidAppear");
}
-(void)viewDidDisappear:(BOOL)animated{
    //NSLog(@"viewDidDisappear");
}
-(void)viewWillLayoutSubviews{
    // NSLog(@"viewWillLayoutSubviews");
}

#pragma mark - 请求数据方法
/**
 *  发送请求并获取数据方法
 */


- (UITableView *)tableview{
    [_tableview setContentOffset:CGPointMake(0,0)animated:NO];
    if (_tableview ==nil)
    {
        self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN- ZNAVViewH)];
        self.tableview.delegate =self;
        self.tableview.dataSource =self;
        //[self.tableview registerClass:[UITableViewCell class]forCellReuseIdentifier:cellIdentifier];
        [self.view addSubview:self.tableview];
        
    }
    return _tableview;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return HEIGHT_SCREEN;
    
}

#pragma mark - UITableviewDatasource 数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *thiscell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, View_Height)];
    thiscell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
    thiscell.backgroundColor = [UIColor lightGrayColor];
    
    
    UIImageView * pictureView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, View_Height)];
    //pictureView.image = [UIImage imageNamed:@""];
    [pictureView sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",WebHost,_picture]] ];//placeholderImage:[UIImage imageNamed:@"station_indexbg"]
    
    [pictureView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    pictureView.contentMode =  UIViewContentModeScaleAspectFit;
   // pictureView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    pictureView.clipsToBounds  = YES;
    [thiscell addSubview:pictureView];
    return thiscell;
    
}


#pragma mark - UITableviewDelegate 代理方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 点击了第indexPath.row行Cell所做的操作
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了第%ld行Cell所做的操作",(long)indexPath.row);
    
}



-(void)backBtn{
    UIButton *leftButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButon.frame = CGRectMake(0,0,FrameWidth(60),FrameWidth(60));
    [leftButon setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [leftButon setContentEdgeInsets:UIEdgeInsetsMake(0, - FrameWidth(20), 0, FrameWidth(20))];
    //button.alignmentRectInsetsOverride = UIEdgeInsetsMake(0, offset, 0, -(offset));
    [leftButon addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc]initWithCustomView:leftButon];
    self.navigationItem.leftBarButtonItem = fixedButton;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}
-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}



@end


