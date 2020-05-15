//
//  KG_SecondFloorViewController.m
//  Frame
//
//  Created by zhangran on 2020/4/1.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_SecondFloorViewController.h"

@interface KG_SecondFloorViewController ()

@property (retain, nonatomic) IBOutlet UILabel *statusNumLabel;
//台站名
@property (retain, nonatomic) IBOutlet UILabel *stationName;
//左边 的坐标
@property (retain, nonatomic) IBOutlet UILabel *leftLocTitle;
//右边的坐标
@property (retain, nonatomic) IBOutlet UILabel *rightLocTitle;
//中间的背景图
@property (retain, nonatomic) IBOutlet UIImageView *centerBgImag;
//台站状态
@property (retain, nonatomic) IBOutlet UILabel *stationStatusLabel;
//状态图片
@property (retain, nonatomic) IBOutlet UIImageView *statusImage;
//健康指数
@property (retain, nonatomic) IBOutlet UILabel *healthLabel;
//星星
@property (retain, nonatomic) IBOutlet UIImageView *healthStarImage;
//健康分数
@property (retain, nonatomic) IBOutlet UILabel *healthNumLabel;
//台站背景图
@property (retain, nonatomic) IBOutlet UIImageView *StationBgImage;
//底部图片
@property (retain, nonatomic) IBOutlet UIImageView *bottomImage;

@property (retain, nonatomic) IBOutlet UILabel *bottomLeftTitle;
@property (retain, nonatomic) IBOutlet UILabel *bottomCenterTitle;
@property (retain, nonatomic) IBOutlet UILabel *bottomRightTitle;

//底部左边
@property (retain, nonatomic) IBOutlet UIImageView *fangcangImage;
@property (retain, nonatomic) IBOutlet UILabel *fangcangTitle;
//底部中间
@property (retain, nonatomic) IBOutlet UIImageView *yuanchangImage;
@property (retain, nonatomic) IBOutlet UILabel *yuanchangTitle;
//底部右下
@property (retain, nonatomic) IBOutlet UIImageView *bjiImage;
@property (retain, nonatomic) IBOutlet UILabel *bjiTitle;
//loc
@property (retain, nonatomic) IBOutlet UIImageView *locImage;
@property (retain, nonatomic) IBOutlet UILabel *locTitle;

@property (strong, nonatomic)  NSDictionary *stationDic;

@property (strong, nonatomic)  NSDictionary *healthDic;

@property (strong, nonatomic)  NSDictionary *statusDic;
@end

@implementation KG_SecondFloorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.statusNumLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.statusNumLabel.layer.cornerRadius = 5.f;
    self.statusNumLabel.layer.masksToBounds = YES;
    [self layout];
    [self getStationData];
    [self getStationHealthData];
    [self getStationStatusData];
     
    UISwipeGestureRecognizer * recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [self.view addGestureRecognizer:recognizer];
    
}
- (void)handleSwipeFrom:(UISwipeGestureRecognizer*)recognizer{
    if(recognizer.direction ==UISwipeGestureRecognizerDirectionDown)
    {
        NSLog(@"swipe down");
       
    }if(recognizer.direction ==UISwipeGestureRecognizerDirectionUp)
    {
         [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"swipe up");
    }
    if(recognizer.direction ==UISwipeGestureRecognizerDirectionLeft)
    {
        NSLog(@"swipe left");
    }
    if(recognizer.direction ==UISwipeGestureRecognizerDirectionRight)
    {
        NSLog(@"swipe right");
    }
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)layout {
    
    [self.stationName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.StationBgImage.mas_top).offset(54);
    }];
    
    [self.StationBgImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(NAVIGATIONBAR_HEIGHT-64+30);
    }];
    
    [self.bottomImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.StationBgImage.mas_bottom).offset(-35);
        make.width.equalTo(@321);
        make.height.equalTo(@169);
    }];
    
    [self.bottomLeftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomImage.mas_top).offset(22);
        make.right.equalTo(self.statusImage.mas_left).offset(-5);
        make.width.equalTo(@100);
        make.height.equalTo(@17);
    }];
    
    [self.bottomCenterTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomImage.mas_top).offset(21);
        make.centerX.equalTo(self.bottomImage.mas_centerX);
        make.width.equalTo(@75);
        make.height.equalTo(@20);
    }];
    
    [self.bottomRightTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomImage.mas_top).offset(22);
        make.right.equalTo(self.bottomImage.mas_right).offset(-32);
        make.width.equalTo(@60);
        make.height.equalTo(@17);
    }];
    
    
    [self.fangcangImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLeftTitle.mas_bottom).offset(36);
        make.left.equalTo(self.bottomImage.mas_left).offset(40);
        make.width.equalTo(@14);
        make.height.equalTo(@10);
    }];
    [self.fangcangTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fangcangImage.mas_centerY);
        make.left.equalTo(self.fangcangImage.mas_right).offset(8);
        make.width.equalTo(@50);
        make.height.equalTo(@17);
    }];
    
    
    [self.yuanchangImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fangcangImage.mas_centerY);
        make.right.equalTo(self.bottomImage.mas_centerX).offset(-10);
        make.width.equalTo(@14);
        make.height.equalTo(@10);
    }];
    [self.yuanchangTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fangcangImage.mas_centerY);
        make.left.equalTo(self.bottomImage.mas_centerX).offset(1);
        make.width.equalTo(@50);
        make.height.equalTo(@17);
    }];
    
    [self.bjiTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fangcangImage.mas_centerY);
        make.right.equalTo(self.bottomImage.mas_right).offset(-42);
        make.width.equalTo(@30);
        make.height.equalTo(@17);
    }];
    
    
    [self.bjiImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fangcangImage.mas_centerY);
        make.right.equalTo(self.bjiTitle.mas_left).offset(-10);
        make.width.equalTo(@14);
        make.height.equalTo(@10);
    }];
    
    [self.locImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomImage.mas_left).offset(82);
        make.top.equalTo(self.fangcangImage.mas_bottom).offset(39);
        make.width.equalTo(@12);
        make.height.equalTo(@16);
    }];
    
    [self.locTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.locImage.mas_right).offset(10);
        make.centerY.equalTo(self.locImage.mas_centerY);
        make.width.equalTo(@200);
        make.height.equalTo(@17);
    }];
}

- (void)dealloc {
    [_stationName release];
    [_leftLocTitle release];
    [_rightLocTitle release];
    [_centerBgImag release];
    [_stationStatusLabel release];
    [_statusImage release];
    [_healthLabel release];
    [_healthNumLabel release];
    [_healthStarImage release];
    [_StationBgImage release];
    [_bottomImage release];
    [_bottomLeftTitle release];
    [_bottomCenterTitle release];
    [_bottomRightTitle release];
    [_fangcangImage release];
    [_fangcangTitle release];
    [_yuanchangImage release];
    [_yuanchangTitle release];
    [_bjiImage release];
    [_bjiTitle release];
    [_locImage release];
    [_locTitle release];
    [super dealloc];
}

//获取大下拉台站档案接口：
//请求地址：/intelligent/atcStation/{id}
//      其中，id是台站的id字段
//       如：/intelligent/atcStation/355b1f15d75e49c7863eb5f422851e3c
//请求方式：GET

- (void)getStationData {
//    NSString *  FrameRequestURL = @"http://10.33.33.147:8089/intelligent/atcStation/355b1f15d75e49c7863eb5f422851e3c";
     NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcStation/355b1f15d75e49c7863eb5f422851e3c"]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        self.stationDic = result[@"value"];
        [self refreshStationData];
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
       
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            
            return;
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
    
}
//获取大下拉台站状态接口：
//请求地址：/intelligent/atcAlarmInfo/status
//请求方式：POST
//请求Body体:
//[{
//      "name": "stationCode",
//      "type": "eq",
//      "content": "XXX"   //台站编码
//}]

- (void)getStationStatusData {
//    NSString *  FrameRequestURL = @"http://10.33.33.147:8089/intelligent/atcAlarmInfo/status";
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcAlarmInfo/status"]];
    NSMutableArray *paramsArr = [NSMutableArray array];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = @"stationCode";
    params[@"type"] = @"eq";
    params[@"content"] = @"HCDHT";
    [paramsArr addObject:params];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:paramsArr success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            [FrameBaseRequest showMessage:[result objectForKey:@"errMsg"]];
            return ;
        }
        self.statusDic = result[@"value"];
        [self refreshStatusData];
        NSLog(@"请求成功");
    } failure:^(NSError *error) {
        //        [FrameBaseRequest showMessage:@"网络链接失败"];
        
        return ;
    }];
    /** 离开当前任务组 **/
    
}


//获取大下拉台站健康度接口：
//请求地址：/intelligent/atcStationHealth/health/{stationCode}/{type}
//     其中，stationCode是台站编码
//           type是健康度计算类型：
//                     comprehensiveScoringMethod：综合评分法
//                     syntheticalIndexMethod：综合指数法
//greyCorrelativeAnalysis：灰色关联分析法
//请求方式：GET
//请求返回：
//如: /intelligent/atcStationHealth/health/HCDHT/comprehensiveScoringMethod
- (void)getStationHealthData {
    
//    NSString *  FrameRequestURL = @"http://10.33.33.147:8089/intelligent/atcStationHealth/health/HCDHT/comprehensiveScoringMethod";
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcStationHealth/health/HCDHT/comprehensiveScoringMethod"]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        
       self.healthDic = result[@"value"];
       [self refreshHealthData];
        
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
       
        return ;
        
    }];
    
}
- (void) getData {
    
    
    /** 创建新的队列组 **/
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        
        
    });
    
    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
      
        
    });
    
    
    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
//        NSString *  FrameRequestURL = @"http://10.33.33.147:8089/intelligent/atcStation/355b1f15d75e49c7863eb5f422851e3c";
        NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcStation/355b1f15d75e49c7863eb5f422851e3c"]];
        [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
            NSInteger code = [[result objectForKey:@"errCode"] intValue];
            if(code  <= -1){
                [FrameBaseRequest showMessage:result[@"errMsg"]];
                return ;
            }
            dispatch_group_leave(group);
            
        } failure:^(NSURLSessionDataTask *error)  {
            FrameLog(@"请求失败，返回数据 : %@",error);
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
              /** 离开当前任务组 **/
            dispatch_group_leave(group);
            if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
                
                return;
            }else if(responses.statusCode == 502){
                
            }
            [FrameBaseRequest showMessage:@"网络链接失败"];
            return ;
            
        }];
      
        
    });
    
    
    
    
    /** 队列组所有任务都结束以后，通知队列组在主线程进行其他操作 **/
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //界面刷新
        NSLog(@"请求完成");
    });
    
}

- (void)refreshStatusData {
    self.statusImage.image = [UIImage imageNamed:[self getLevelImage:self.statusDic[@"status"]]];
    
    self.statusNumLabel.text = [NSString stringWithFormat:@"%@",safeString(self.statusDic[@"alarmNum"])] ;
    self.statusNumLabel.backgroundColor = [self getTextColor:self.statusDic[@"status"]];
}

- (void)refreshHealthData {
   
    self.healthNumLabel.text = [NSString stringWithFormat:@"%.1f分",[self.healthDic[@"value"] floatValue]];
    NSLog(@"grade");
}

- (void)refreshStationData {
    self.stationName.text = safeString(self.stationDic[@"alias"]) ;
    self.locTitle.text = safeString(self.stationDic[@"address"]);
    
    self.leftLocTitle.text = [NSString stringWithFormat:@"E %@", safeString(self.stationDic[@"latitude"])];
    self.rightLocTitle.text =  [NSString stringWithFormat:@"N %@", safeString(self.stationDic[@"longitude"])];
    self.bjiTitle.text = [NSString stringWithFormat:@"%@级",safeString(self.stationDic[@"level"])];
    self.bottomRightTitle.text = [NSString stringWithFormat:@"%@",safeString(self.stationDic[@"useStatus"])];
    self.bottomRightTitle.textColor = [UIColor colorWithHexString:@"#2FFFE2"];
    
    self.bottomCenterTitle.text = [NSString stringWithFormat:@"%@",safeString(self.stationDic[@"competentUnit"])];
    NSString *timeStr = [self timestampToTimeStr:self.stationDic[@"lastUpdateTime"]];
    self.bottomLeftTitle.text = [NSString stringWithFormat:@"%@年投产",timeStr];
    

    self.fangcangTitle.text = [NSString stringWithFormat:@"%@",safeString(self.stationDic[@"clearanceRequirement"])];
    self.yuanchangTitle.text = [NSString stringWithFormat:@"%@",safeString(self.stationDic[@"environmentInformation"])];

    [self.centerBgImag sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",WebHost,self.stationDic[@"picture"]]] placeholderImage:[UIImage imageNamed:@"Second_StationImage"] ];
}

//将时间戳转换为时间字符串
- (NSString *)timestampToTimeStr:(NSString *)timestamp {
   
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:timestamp.integerValue/1000];
    NSString *timeStr=[[self dateFormatWith:@"YYYY-MM"] stringFromDate:date];
    //    NSString *timeStr=[[self dateFormatWith:@"YYYY-MM-dd"] stringFromDate:date];
    return timeStr;
    
}
- (NSDateFormatter *)dateFormatWith:(NSString *)formatStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatStr];//@"YYYY-MM-dd HH:mm:ss"
    //设置时区
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    return formatter;
}
- (NSString *)getLevelImage:(NSString *)level {
    NSString *levelString = @"正常";
    
    if ([level isEqualToString:@"正常"]) {
        levelString = @"level_normal";
    }else if ([level isEqualToString:@"提示"]) {
        levelString = @"level_prompt";
    }else if ([level isEqualToString:@"次要"]) {
        levelString = @"level_ciyao";
    }else if ([level isEqualToString:@"重要"]) {
        levelString = @"level_important";
    }else if ([level isEqualToString:@"紧急"]) {
        levelString = @"level_jinji";
    }
    
    //紧急
    return levelString;
}
- (UIColor *)getTextColor:(NSString *)level {
    UIColor *textColor = [UIColor colorWithHexString:@"FFFFFF"];
    
    if ([level isEqualToString:@"正常"]) {
        textColor = [UIColor colorWithHexString:@"FFFFFF"];
    }else if ([level isEqualToString:@"提示"]) {
        textColor = [UIColor colorWithHexString:@"2986F1"];
    }else if ([level isEqualToString:@"次要"]) {
        textColor = [UIColor colorWithHexString:@"FFA800"];
    }else if ([level isEqualToString:@"重要"]) {
        textColor = [UIColor colorWithHexString:@"FC7D0E"];
    }else if ([level isEqualToString:@"紧急"]) {
        textColor = [UIColor colorWithHexString:@"F62546"];
    }
    
    //紧急
    return textColor;
}


@end
