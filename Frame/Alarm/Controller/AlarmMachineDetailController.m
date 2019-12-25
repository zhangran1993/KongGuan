//
//  AlarmMachineDetailController.m
//  Frame
//
//  Created by hibayWill on 2018/4/8.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "AlarmMachineDetailController.h"
#import "StationRoomController.h"
#import "StationVideoListController.h"
#import "FrameBaseRequest.h"
#import <UIImageView+WebCache.h>
#import "AlarmMachineTypeListController.h"
#import "AtcAttachmentRecordsModel.h"
#import <MJExtension.h>

@interface AlarmMachineDetailController ()<UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) NSMutableArray<AtcAttachmentRecordsModel *> *MachineDetailArray;
@property NSArray * objects;
@property NSUInteger newHeight;
/** 请求管理者 */
//@property (nonatomic,weak) AFHTTPSessionManager * manager;
/** 用于加载下一页的参数(页码) */
@property   int viewnum;

@property(nonatomic) UIView* bottomView;
@property(nonatomic) UITableView *tableview;
@end

@implementation AlarmMachineDetailController

#pragma mark - 全局常量



#pragma mark - life cycle 生命周期方法

- (void)viewDidLoad {
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, getScreen.size.width, getScreen.size.height-ZNAVViewH)];
    self.tableview.backgroundColor = BGColor;
    //[self.tableview registerClass:[UITableViewCell class]forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.tableview];
    
    self.tableview.delegate =self;
    self.tableview.dataSource =self;
    self.tableview.separatorStyle = NO;
    [super viewDidLoad];
    self.navigationItem.title = @"备件详情";//详情
    
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"setupTable setupTable");
    countnum = 0;
    [self backBtn];
    [self setupTable];
}
#pragma mark - private methods 私有方法

- (void)setupTable{
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    NSString *  FrameRequestURL = [NSString stringWithFormat:@"%@%@%@",WebHost,@"/api/atcAttachment/",_id];
    
    NSLog(@"FrameRequestURL %@   %@",FrameRequestURL,self.status);
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (NSDictionary *dict in result[@"value"][@"atcAttachmentRecords"]) {
            AtcAttachmentRecordsModel *atcModel = [AtcAttachmentRecordsModel mj_objectWithKeyValues:dict];
            atcModel.textHeight = [CommonExtension heightForString:atcModel.content fontSize:FontSize(15) andWidth:FrameWidth(500)]+10;
            
            [mutableArray addObject:atcModel];
        }
        
        
        self.MachineDetailArray = [mutableArray mutableCopy];
        
        
        
        
        self.status = result[@"value"][@"status"];
        self.objects = [@[
                          @{@"name":@"备件名称",@"val":[CommonExtension returnWithString:result[@"value"][@"name"]]},
                          @{@"name":@"备件等级",@"val":[CommonExtension returnWithString:result[@"value"][@"grade"]]},
                          @{@"name":@"存放地点",@"val":[CommonExtension returnWithString:result[@"value"][@"storageLocation"]]},
                          @{@"name":@"入库时间",@"val":[FrameBaseRequest getDateByTimesp:[result[@"value"][@"time"] doubleValue] dateType:@"YYYY-MM-dd"]},
                          @{@"name":@"设备编号",@"val":[CommonExtension returnWithString:result[@"value"][@"code"]]},
                          @{@"name":@"设备型号",@"val":[CommonExtension returnWithString:result[@"value"][@"model"]]},
                          @{@"name":@"设备状态",@"val":self.status},
                          @{@"name":@"台站",@"val":[CommonExtension returnWithString:result[@"value"][@"stationCode"]]},
                          @{@"name":@"备件分类",@"val":[CommonExtension returnWithString:result[@"value"][@"category"]]}
                     ] copy];
        
        
        
        NSLog(@"/aaaaaaaaaa%@",self.objects);
        
        
        //@"设备设施",@"设备状态",@"入库时间",@"设备编号",@"设备型号"
        [self.tableview reloadData];
        
        
        return ;
        
        
        //[self getStationList];
        
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            [FrameBaseRequest logout];
            UIViewController *viewCtl = self.navigationController.viewControllers[0];
            [self.navigationController popToViewController:viewCtl animated:YES];
            return;
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
    
    
    
    //去除分割线
    self.tableview.separatorStyle =NO;
    [self.view addSubview:self.tableview];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    // NSLog(@"viewDidAppear");
}
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"viewDidDisappear");
    
}
-(void)viewWillLayoutSubviews{
    // NSLog(@"viewWillLayoutSubviews");
}

#pragma mark - 请求数据方法
/**
 *  发送请求并获取数据方法
 */



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //if(self.detail[indexPath.row].typeid==1){
    if(indexPath.row==0){
        if(getScreen.size.height > allHeight){
            return getScreen.size.height;
        }
        return  allHeight;//+
    }
    return 0;
}

#pragma mark - UITableviewDatasource 数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *thiscell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN - 114)];
    thiscell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
    thiscell.backgroundColor = BGColor;
    //基本信息
    UIView *BasicInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, FrameWidth(88))];
    BasicInfoView.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:BasicInfoView];
    
    UIImageView *BasicImgbg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(30), FrameWidth(30), FrameWidth(30),FrameWidth(30))];
    BasicImgbg.image = [UIImage imageNamed:@"Patrol_icon_jbxx"];
    [BasicInfoView addSubview:BasicImgbg];
    
    UILabel *levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(30), FrameWidth(150),FrameWidth(30))];
    levelLabel.text = @"基本信息";
    levelLabel.font = FontSize(18);
    [BasicInfoView addSubview:levelLabel];
    
    self.newHeight = BasicInfoView.frame.size.height;
    
    
    for (int i =0 ; i < self.objects.count; i++) {
        UIView *basicView = [[UIView alloc]initWithFrame:CGRectMake(0, self.newHeight+1, WIDTH_SCREEN,FrameWidth(90))];
        basicView.backgroundColor = [UIColor whiteColor];
        self.newHeight = basicView.frame.origin.y + basicView.frame.size.height;
        [thiscell addSubview:basicView];
        
        UILabel *basicTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(25), FrameWidth(25), FrameWidth(175),FrameWidth(30))] ;
        basicTitleLabel.text = self.objects[i][@"name"];
        basicTitleLabel.font = FontSize(16);
        basicTitleLabel.textColor = listGrayColor;
        [basicView addSubview:basicTitleLabel];
        
        UILabel *basicLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(200), FrameWidth(1), FrameWidth(400),FrameWidth(90))] ;
        basicLabel.text = self.objects[i][@"val"];
        basicLabel.numberOfLines = 0;
        basicLabel.lineBreakMode = NSLineBreakByWordWrapping;
        basicLabel.font = FontSize(16);
        basicLabel.textAlignment = NSTextAlignmentRight;
        basicLabel.textColor = listGrayColor;
        [basicView addSubview:basicLabel];
        
        
    }
    //备件履历
    UIView *recordView = [[UIView alloc]initWithFrame:CGRectMake(0, self.newHeight+FrameWidth(10), WIDTH_SCREEN, FrameWidth(88))];
    recordView.backgroundColor = [UIColor whiteColor];
    
    [thiscell addSubview:recordView];
    
    UIImageView *recordImgbg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(30), FrameWidth(30), FrameWidth(30),FrameWidth(30))];
    recordImgbg.image = [UIImage imageNamed:@"alarm_clms"];
    [recordView addSubview:recordImgbg];
    
    UILabel *recordLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(70), FrameWidth(30), FrameWidth(150),FrameWidth(30))];
    recordLabel.text = @"备件履历";
    recordLabel.font = FontSize(18);
    [recordView addSubview:recordLabel];
    
    UIView *recordDetailView = [[UIView alloc]initWithFrame:CGRectMake(0, recordView.frame.origin.y + recordView.frame.size.height +1, WIDTH_SCREEN, FrameWidth(450))];
    recordDetailView.backgroundColor = [UIColor whiteColor];
   
    UIView *recordDetail = [[UIView alloc]initWithFrame:CGRectMake(FrameWidth(23),FrameWidth(27), FrameWidth(593), FrameWidth(30))];
    recordDetail.layer.borderWidth = 1;
    recordDetail.layer.borderColor = BGColor.CGColor;
    recordDetail.layer.cornerRadius = 3;
    
    //dictArray
    for (NSInteger i=0; i<self.MachineDetailArray.count; i++) {
        UIImageView *dianImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(16), FrameWidth(10)+recordDetail.frameHeight, FrameWidth(13), FrameWidth(13))];
        dianImg.image = [UIImage imageNamed:@"alarm_dangqian"];
        [recordDetail addSubview:dianImg];
        
        UILabel *dateLabel =  [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(50),  recordDetail.frameHeight, FrameWidth(500), FrameWidth(30))];
        dateLabel.font = FontSize(17);
        dateLabel.text = [[FrameBaseRequest getDateByTimesp:[self.MachineDetailArray[i].createTime doubleValue] dateType:@"YYYY-MM-dd"]stringByAppendingFormat:@"    %@", self.MachineDetailArray[i].participants];
        [recordDetail addSubview:dateLabel];
        
        
        UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(50), dateLabel.originY +FrameWidth(50) ,  FrameWidth(500), self.MachineDetailArray[i].textHeight)];
        descLabel.textColor = listGrayColor;
        descLabel.font = FontSize(15);
        descLabel.numberOfLines = 0;
        descLabel.lineBreakMode = NSLineBreakByWordWrapping;
        descLabel.text = [NSString stringWithFormat:@"%@",self.MachineDetailArray[i].content];
        [recordDetail addSubview:descLabel];
        
        [recordDetail setFrameHeight:descLabel.originY + descLabel.frameHeight +FrameWidth(20) ];
        
        
    }
    
    [recordDetailView setFrameHeight:recordDetail.originY + recordDetail.frameHeight+FrameWidth(20) ];
    [recordDetailView addSubview:recordDetail];
    [thiscell addSubview:recordDetailView];
    
    
    
    
    allHeight = recordDetailView.frame.origin.y + recordDetailView.frame.size.height;
    return thiscell;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if(htmlHeight <= 36&&countnum < 10){
        NSLog(@"shopdetail webViewDidFinishLoad");
        htmlHeight = [webView.scrollView contentSize].height;
        countnum++;
        //[self.tableview reloadData];
    }
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
-(void)beijianAction {
    AlarmMachineTypeListController  *MachineTypeList = [[AlarmMachineTypeListController alloc] init];
    [self.navigationController pushViewController:MachineTypeList animated:YES];
}


@end
