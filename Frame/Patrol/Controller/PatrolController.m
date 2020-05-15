//
//  PatrolController.m
//  Frame
//
//  Created by hibayWill on 2018/3/23.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "PatrolController.h"
#import "FrameBaseRequest.h"
#import "StationItems.h"
#import "ChooseStationCell.h"
#import "PatrolSetController.h"
#import "LoginViewController.h"
#import "UIColor+Extension.h"
#import "PatrolHistoryController.h"
#import "PatrolSpecialController.h"

#import <UIImageView+WebCache.h>
#import <AFNetworking.h>
#import <MJExtension.h>

@interface PatrolController ()<UITableViewDelegate,UITableViewDataSource>{
    int timeCont;
    NSTimer *timer;
}

/** 存放数据模型的数组 */
@property (strong, nonatomic) NSMutableArray<StationItems *> * StationItem;
@property(strong,nonatomic)UITableView *stationTabView;
@property(copy,nonatomic) NSString * type_code;

@end

@implementation PatrolController

- (void)viewDidLoad {
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FontSize(20),NSForegroundColorAttributeName:[UIColor whiteColor]}] ;
    [super viewDidLoad];
    //[self backBtn];
    [self loadBgView];
    
    
}





-(void)loadBgView{
    self.title = @"巡查管理";
    // int thisViewwidth = getScreen.size.width/2;
    //背景色
    self.view.backgroundColor =  [UIColor  colorWithPatternImage:[UIImage imageNamed:@"personal_gray_bg"]] ;
    //例行巡查
    UIView *PatrolView = [[UIView alloc] initWithFrame:CGRectMake(FrameWidth(20),FrameWidth(20), FrameWidth(600), FrameWidth(160))];
    PatrolView.backgroundColor = [UIColor whiteColor];
    PatrolView.layer.cornerRadius = 3;
    PatrolView.layer.masksToBounds = YES;
    [self.view addSubview:PatrolView];
    UIButton *patrolViewButton = [[UIButton alloc] initWithFrame:PatrolView.bounds];
    [patrolViewButton addTarget:self action:@selector(routinePatrol) forControlEvents:UIControlEventTouchUpInside];
    [patrolViewButton setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [patrolViewButton setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:kCellHighlightColor]] forState:UIControlStateHighlighted];
    [PatrolView addSubview:patrolViewButton];
    
    UIImageView *PatrolImg = [[UIImageView alloc] initWithFrame:CGRectMake(FrameWidth(15), FrameWidth(10), FrameWidth(138), FrameWidth(138))];
    PatrolImg.layer.cornerRadius = 2;
    PatrolImg.image = [UIImage imageNamed:@"Patrol_now"];
    [PatrolView addSubview:PatrolImg];
    
    UILabel *PatrolTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(170), FrameWidth(12), FrameWidth(400), FrameWidth(30))];
    PatrolTitleLabel.text = @"例行巡查";
    PatrolTitleLabel.font = FontSize(17);
    [PatrolView addSubview:PatrolTitleLabel];
    
    UILabel *PatrolDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(170), FrameWidth(45), FrameWidth(410), FrameWidth(100))];
    PatrolDescLabel.numberOfLines = 3;
    PatrolDescLabel.lineBreakMode = NSLineBreakByCharWrapping;
    PatrolDescLabel.textColor = [UIColor grayColor];
    PatrolDescLabel.font =FontSize(12);
    PatrolDescLabel.text = @"常规性台站巡查\n近场A/B/C级、远场A级不少于1次/周，远场B/C级不少于1次/月";
    [PatrolDescLabel sizeToFit];
    [PatrolView addSubview:PatrolDescLabel];
    
    
    //全面巡查
    UIView *AllPatrolView = [[UIView alloc] initWithFrame:CGRectMake(FrameWidth(20), FrameWidth(200), FrameWidth(600), FrameWidth(160))];
    AllPatrolView.layer.cornerRadius = 3;
    AllPatrolView.layer.masksToBounds = YES;
    AllPatrolView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:AllPatrolView];
    
    UIButton *AllPatrolViewButton = [[UIButton alloc] initWithFrame:AllPatrolView.bounds];
    [AllPatrolViewButton addTarget:self action:@selector(AllPatrol) forControlEvents:UIControlEventTouchUpInside];
    [AllPatrolViewButton setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [AllPatrolViewButton setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:kCellHighlightColor]] forState:UIControlStateHighlighted];
    [AllPatrolView addSubview:AllPatrolViewButton];
    
    
    UIImageView *AllPatrolImg = [[UIImageView alloc] initWithFrame:CGRectMake(FrameWidth(15), FrameWidth(10), FrameWidth(138), FrameWidth(138))];
    AllPatrolImg.layer.cornerRadius = 2;
    AllPatrolImg.image = [UIImage imageNamed:@"Patrol_all"];
    [AllPatrolView addSubview:AllPatrolImg];
    
    UILabel *AllPatrolTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(170), FrameWidth(12), FrameWidth(400), FrameWidth(30))];
    AllPatrolTitleLabel.text = @"全面巡查";
    AllPatrolTitleLabel.font = FontSize(17);
    [AllPatrolView addSubview:AllPatrolTitleLabel];
    
    UILabel *AllPatrolDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(170), FrameWidth(45), FrameWidth(410), FrameWidth(100))];
    AllPatrolDescLabel.numberOfLines = 3;
    AllPatrolDescLabel.lineBreakMode = NSLineBreakByCharWrapping;
    AllPatrolDescLabel.textColor = [UIColor grayColor];
    AllPatrolDescLabel.font =FontSize(12);
    AllPatrolDescLabel.text = @"可结合设备季/半年/年维护执行\nA级不少于1次/季度，B级不少于1次/半年，C级不少于1次/年";
    [AllPatrolDescLabel sizeToFit];
    [AllPatrolView addSubview:AllPatrolDescLabel];
    
    //特殊巡查
    float otherHeight = 0;
    if(is5S){
        otherHeight = FrameWidth(20);
    }
    
    UIView *SpecialPatrolView = [[UIView alloc] initWithFrame:CGRectMake(FrameWidth(20), FrameWidth(380), FrameWidth(600), FrameWidth(160)+otherHeight)];
    SpecialPatrolView.layer.cornerRadius = 3;
    SpecialPatrolView.layer.masksToBounds = YES;
    SpecialPatrolView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SpecialPatrolView];
    
    UIButton *SpecialPatrolViewButton = [[UIButton alloc] initWithFrame:SpecialPatrolView.bounds];
    [SpecialPatrolViewButton addTarget:self action:@selector(SpecialPatrol) forControlEvents:UIControlEventTouchUpInside];
    [SpecialPatrolViewButton setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [SpecialPatrolViewButton setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:kCellHighlightColor]] forState:UIControlStateHighlighted];
    [SpecialPatrolView addSubview:SpecialPatrolViewButton];
    
    UIImageView *SpecialPatrolImg = [[UIImageView alloc] initWithFrame:CGRectMake(FrameWidth(15),FrameWidth(10), FrameWidth(138),FrameWidth(138))];
    SpecialPatrolImg.layer.cornerRadius = 2;
    SpecialPatrolImg.image = [UIImage imageNamed:@"Patrol_special"];
    [SpecialPatrolView addSubview:SpecialPatrolImg];
    
    UILabel *SpecialPatrolTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(170), FrameWidth(12), FrameWidth(400), FrameWidth(30))];
    SpecialPatrolTitleLabel.text = @"特殊巡查";
    SpecialPatrolTitleLabel.font = FontSize(17);
    [SpecialPatrolView addSubview:SpecialPatrolTitleLabel];
    
    UILabel *SpecialPatrolDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(170), FrameWidth(45), FrameWidth(410), FrameWidth(120))];
    SpecialPatrolDescLabel.numberOfLines = 4;
    SpecialPatrolDescLabel.lineBreakMode = NSLineBreakByCharWrapping;
    SpecialPatrolDescLabel.textColor = [UIColor grayColor];
    SpecialPatrolDescLabel.font =FontSize(12);
    SpecialPatrolDescLabel.text = @"针对性现场巡查\n适用灾害性天气、设备故障、新增设备、设备重新启用、重大保障任务、飞行校验等";
    [SpecialPatrolDescLabel sizeToFit];
    [SpecialPatrolView addSubview:SpecialPatrolDescLabel];
    
    //历史巡查
    UIView *HistoryPatrolView = [[UIView alloc] initWithFrame:CGRectMake(FrameWidth(20), FrameWidth(560)+otherHeight, FrameWidth(600), FrameWidth(160))];
    HistoryPatrolView.layer.cornerRadius = 3;
    HistoryPatrolView.layer.masksToBounds = YES;
    HistoryPatrolView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:HistoryPatrolView];
    
    UIButton *HistoryPatrolViewButton = [[UIButton alloc] initWithFrame:HistoryPatrolView.bounds];
    [HistoryPatrolViewButton addTarget:self action:@selector(HistoryPatrol) forControlEvents:UIControlEventTouchUpInside];
    [HistoryPatrolViewButton setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [HistoryPatrolViewButton setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:kCellHighlightColor]] forState:UIControlStateHighlighted];
    [HistoryPatrolView addSubview:HistoryPatrolViewButton];
    
    UIImageView *HistoryPatrolImg = [[UIImageView alloc] initWithFrame:CGRectMake(FrameWidth(15), FrameWidth(10), FrameWidth(138),FrameWidth(138))];
    HistoryPatrolImg.layer.cornerRadius = 2;
    HistoryPatrolImg.image = [UIImage imageNamed:@"Patrol_history"];
    [HistoryPatrolView addSubview:HistoryPatrolImg];
    
    UILabel *HistoryPatrolTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(170), FrameWidth(12), FrameWidth(400), FrameWidth(30))];
    HistoryPatrolTitleLabel.text = @"历史巡查";
    HistoryPatrolTitleLabel.font = FontSize(17);
    [HistoryPatrolView addSubview:HistoryPatrolTitleLabel];
    
    UILabel *HistoryPatrolDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(170), FrameWidth(45), FrameWidth(410), FrameWidth(100))];
    HistoryPatrolDescLabel.numberOfLines = 3;
    HistoryPatrolDescLabel.lineBreakMode = NSLineBreakByCharWrapping;
    HistoryPatrolDescLabel.textColor = [UIColor grayColor];
    HistoryPatrolDescLabel.font =FontSize(12);
    HistoryPatrolDescLabel.text = @"台(站)巡视历史纪录";
    [HistoryPatrolDescLabel sizeToFit];
    [HistoryPatrolView addSubview:HistoryPatrolDescLabel];
    
    //[submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    //[submitButton.layer setCornerRadius:FrameWidth(15)]; //设置矩形四个圆角半径
    return ;
}


/**
 颜色转图片

 @param color 颜色
 @return 图片
 */
- (UIImage*)createImageWithColor: (UIColor*) color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


/*
 *判断巡查是否存在
 */


-(void)routinePatrol{
    _type_code = @"routine";
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:[NSString stringWithFormat:@"/api/getAtcPatrolRecode/%@",_type_code]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        if([result[@"value"][@"status"] isEqualToString:@"0"]){
            PatrolSetController  *PatrolSet = [[PatrolSetController alloc] init];
            PatrolSet.stationCode = result[@"value"][@"station_code"];
            PatrolSet.id = result[@"value"][@"id"];
            PatrolSet.patrolRecordId = result[@"value"][@"id"];
            PatrolSet.status = result[@"value"][@"status"];
            PatrolSet.type_code = _type_code;//comprehensive//special
            
            [self.navigationController pushViewController:PatrolSet animated:YES];
        }else{
            self.StationItem = [[StationItems class] mj_objectArrayWithKeyValuesArray:result[@"value"][@"stationList"] ];
            [self selectStation];
        }
        
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
//        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
//            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
//            [FrameBaseRequest logout];
//            
//            LoginViewController *login = [[LoginViewController alloc] init];
//            [self.navigationController pushViewController:login animated:YES];
//            return;
//        }else if(responses.statusCode == 502){
//            
//        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
}
-(void)AllPatrol{
    _type_code = @"comprehensive";
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:[NSString stringWithFormat:@"/api/getAtcPatrolRecode/%@",_type_code]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        if([result[@"value"][@"status"] isEqualToString:@"0"]){
            PatrolSetController  *PatrolSet = [[PatrolSetController alloc] init];
            PatrolSet.stationCode = result[@"value"][@"station_code"];
            PatrolSet.id = result[@"value"][@"id"];
            PatrolSet.patrolRecordId = result[@"value"][@"id"];
            PatrolSet.status = result[@"value"][@"status"];
            PatrolSet.type_code = _type_code;//comprehensive//special
            
            [self.navigationController pushViewController:PatrolSet animated:YES];
        }else{
            self.StationItem = [[StationItems class] mj_objectArrayWithKeyValuesArray:result[@"value"][@"stationList"] ];
            [self selectStation];
        }
        
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
//        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
//            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
//            [FrameBaseRequest logout];
//
//            LoginViewController *login = [[LoginViewController alloc] init];
//            [self.navigationController pushViewController:login animated:YES];
//            return;
//        }else if(responses.statusCode == 502){
//
//        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
}
-(void)SpecialPatrol{
    _type_code = @"special";
    
    PatrolSpecialController  *PatrolSet = [[PatrolSpecialController alloc] init];
    PatrolSet.type_code = _type_code;//comprehensive//special
    
    [self.navigationController pushViewController:PatrolSet animated:YES];
    
}
-(void)HistoryPatrol{
    PatrolHistoryController  *PatrolHistory = [[PatrolHistoryController alloc] init];
    [self.navigationController pushViewController:PatrolHistory animated:YES];
}

-(void)selectStation{
    UIViewController *vc = [UIViewController new];
    vc.view.backgroundColor = [UIColor whiteColor];
    
    vc.view.frame = CGRectMake(FrameWidth(100), FrameWidth(210), FrameWidth(440), FrameWidth(550));
    vc.view.layer.cornerRadius = 9.0;
    vc.view.layer.masksToBounds = YES;
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, FrameWidth(20),  vc.view.frameWidth, FrameWidth(40))];
    titleLabel.textColor =[UIColor grayColor];
    titleLabel.text = @"请选择台站";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = FontSize(18);
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, FrameWidth(70), WIDTH_SCREEN, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [vc.view addSubview:line];
    [vc.view addSubview:titleLabel];
    
    
    _stationTabView = [[UITableView alloc] initWithFrame:CGRectMake(2, FrameWidth(70)+1, vc.view.frame.size.width -4 , vc.view.frame.size.height - FrameWidth(60))];
    _stationTabView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [vc.view addSubview:_stationTabView];
    _stationTabView.dataSource = self;
    _stationTabView.delegate = self;
    _stationTabView.separatorStyle = NO;
    
    [self cb_presentPopupViewController:vc animationType:CBPopupViewAnimationSlideFromTop aligment:CBPopupViewAligmentCenter overlayDismissed:nil];
}


-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    [self showNavigation];
}

//展示navigation背景色
-(void)showNavigation{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.StationItem.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc]init];
    
    StationItems *item = self.StationItem[indexPath.row];
    cell.textLabel.text = item.alias;
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font =  FontSize(17);
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, FrameWidth(80), WIDTH_SCREEN, 1)];
    line.backgroundColor = BGColor;
    [cell addSubview:line];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return FrameWidth(80);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了第%ld行Cell所做的操作",(long)indexPath.row);
    [self cb_dismissPopupViewControllerAnimated:YES completion:nil];
    

    PatrolSetController  *PatrolSet = [[PatrolSetController alloc] init];
    PatrolSet.stationCode = self.StationItem[indexPath.row].code;
    PatrolSet.stationName = self.StationItem[indexPath.row].alias;
    PatrolSet.patrolRecordId = @"";//self.StationItem[indexPath.row].id;
    PatrolSet.status = @"1";
    PatrolSet.type_code = _type_code;//comprehensive//special
    [self.navigationController pushViewController:PatrolSet animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

