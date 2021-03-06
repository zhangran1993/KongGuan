//
//  PersonalMsgController.m
//  Frame
//
//  Created by hibayWill on 2018/3/31.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "PersonalMsgController.h"
#import "FrameBaseRequest.h"
#import "PersonalMsgListController.h"


#import <UIImageView+WebCache.h>
#import <AFNetworking.h>
#import <MJExtension.h>

@interface PersonalMsgController (){
    int timeCont;
    NSTimer *timer;
}

/** 存放数据模型的数组 */
//@property (strong, nonatomic) NSMutableArray<StationItems *> * StationItem;
//@property(strong,nonatomic)UITableView *stationTabView;
@property(strong,nonatomic)UILabel *newsNumLabel;
@property(strong,nonatomic)UILabel *yujingNumLabel;
@property(strong,nonatomic)UILabel *gonggaoNumLabel;

@end

@implementation PersonalMsgController
//static NSString * const FrameCellID = @"ChooseStationCell";
//static NSString * const reuseIdentifier = @"Cell";


- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBtn];
    [self loadBgView];
    
}
-(void)loadBgView{
    self.title = @"消息通知";
    //背景色
    self.view.backgroundColor =  BGColor ;
    
    
    
    //告警消息
    UIView *WarnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,WIDTH_SCREEN, FrameWidth(143))];
    WarnView.backgroundColor = [UIColor whiteColor];
    WarnView.layer.cornerRadius = 3;
    
    //点击效果
    UIButton *patrolViewButton = [[UIButton alloc] initWithFrame:WarnView.bounds];
    [patrolViewButton addTarget:self action:@selector(WarnView) forControlEvents:UIControlEventTouchUpInside];
    [patrolViewButton setBackgroundImage:[CommonExtension createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [patrolViewButton setBackgroundImage:[CommonExtension createImageWithColor:[UIColor colorWithHexString:kCellHighlightColor]] forState:UIControlStateHighlighted];
    [WarnView addSubview:patrolViewButton];
    
    [self.view addSubview:WarnView];
    
    UIImageView *WarnImg = [[UIImageView alloc] initWithFrame:CGRectMake(FrameWidth(20), FrameWidth(20), FrameWidth(95), FrameWidth(95))];
    WarnImg.layer.cornerRadius = 2;
    WarnImg.image = [UIImage imageNamed:@"personal_warn_msg"];
    [WarnView addSubview:WarnImg];
    
    UILabel *WarnTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(144), FrameWidth(35), FrameWidth(480), FrameWidth(30))];
    WarnTitleLabel.text = @"告警消息";
    WarnTitleLabel.font = FontSize(17);
    [WarnView addSubview:WarnTitleLabel];
    
    _newsNumLabel = [[UILabel alloc]init];
    CGSize size = [@"告警消息" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontSize(16),NSFontAttributeName,nil]];
    _newsNumLabel.frame = CGRectMake(FrameWidth(180)+size.width, FrameWidth(35), FrameWidth(25), FrameWidth(25));
    //_newsNumLabel.frame = CGRectMake(FrameWidth(260), FrameWidth(30), FrameWidth(25), FrameWidth(25));
    _newsNumLabel.font = FontSize(10);
    _newsNumLabel.layer.cornerRadius = FrameWidth(13);
    _newsNumLabel.clipsToBounds = YES;
    _newsNumLabel.textColor = [UIColor whiteColor];
    _newsNumLabel.textAlignment = NSTextAlignmentCenter;
    _newsNumLabel.backgroundColor = [UIColor redColor];
    [_newsNumLabel setHidden:YES];
    [WarnView addSubview:_newsNumLabel];
    
    UILabel *WarnDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(144), FrameWidth(65), FrameWidth(480), FrameWidth(60))];
    WarnDescLabel.numberOfLines = 3;
    WarnDescLabel.lineBreakMode = NSLineBreakByCharWrapping;
    WarnDescLabel.textColor = [UIColor grayColor];
    WarnDescLabel.font =FontSize(15);
    WarnDescLabel.text = @"告警消息列表在此处显示";
    [WarnView addSubview:WarnDescLabel];
    
    //预警消息
    UIView *yujingView = [[UIView alloc] initWithFrame:CGRectMake(0, FrameWidth(144),WIDTH_SCREEN, FrameWidth(143))];
    yujingView.backgroundColor = [UIColor whiteColor];
    yujingView.layer.cornerRadius = 3;
    
    //点击效果
    UIButton *yujinglViewButton = [[UIButton alloc] initWithFrame:WarnView.bounds];
    [yujinglViewButton addTarget:self action:@selector(AlarmView) forControlEvents:UIControlEventTouchUpInside];
    [yujinglViewButton setBackgroundImage:[CommonExtension createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [yujinglViewButton setBackgroundImage:[CommonExtension createImageWithColor:[UIColor colorWithHexString:kCellHighlightColor]] forState:UIControlStateHighlighted];
    [yujingView addSubview:yujinglViewButton];
    
    [yujingView setUserInteractionEnabled:YES];
    [yujingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AlarmView)]];
    [self.view addSubview:yujingView];
    
    UIImageView *yujingImg = [[UIImageView alloc] initWithFrame:CGRectMake(FrameWidth(20), FrameWidth(20), FrameWidth(95), FrameWidth(95))];
    yujingImg.layer.cornerRadius = 2;
    yujingImg.image = [UIImage imageNamed:@"personal_alarm_msg"];
    [yujingView addSubview:yujingImg];
    
    UILabel *yujingTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(144), FrameWidth(35), FrameWidth(480), FrameWidth(30))];
    yujingTitleLabel.text = @"预警消息";
    yujingTitleLabel.font = FontSize(17);
    [yujingView addSubview:yujingTitleLabel];
    
    _yujingNumLabel = [[UILabel alloc]init];
   // CGSize size = [@"告警消息" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontSize(16),NSFontAttributeName,nil]];
    _yujingNumLabel.frame = CGRectMake(FrameWidth(180)+size.width, FrameWidth(35), FrameWidth(25), FrameWidth(25));
    //_yujingNumLabel.frame = CGRectMake(FrameWidth(260), FrameWidth(30), FrameWidth(25), FrameWidth(25));
    _yujingNumLabel.font = FontSize(10);
    _yujingNumLabel.layer.cornerRadius = FrameWidth(13);
    _yujingNumLabel.clipsToBounds = YES;
    _yujingNumLabel.textColor = [UIColor whiteColor];
    _yujingNumLabel.textAlignment = NSTextAlignmentCenter;
    _yujingNumLabel.backgroundColor = [UIColor redColor];
    [_yujingNumLabel setHidden:YES];
    [yujingView addSubview:_yujingNumLabel];
    
    UILabel *yujingDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(144), FrameWidth(65), FrameWidth(480), FrameWidth(60))];
    yujingDescLabel.numberOfLines = 3;
    yujingDescLabel.lineBreakMode = NSLineBreakByCharWrapping;
    yujingDescLabel.textColor = [UIColor grayColor];
    yujingDescLabel.font =FontSize(15);
    yujingDescLabel.text = @"预警消息列表在此处显示";
    [yujingView addSubview:yujingDescLabel];
    
    //公告消息
    UIView *RadioView = [[UIView alloc] initWithFrame:CGRectMake(0, FrameWidth(288),WIDTH_SCREEN, FrameWidth(143))];
    RadioView.layer.cornerRadius = 3;
    RadioView.backgroundColor = [UIColor whiteColor];
    
    //点击效果
    UIButton *RadioViewButton = [[UIButton alloc] initWithFrame:WarnView.bounds];
    [RadioViewButton addTarget:self action:@selector(Radio) forControlEvents:UIControlEventTouchUpInside];
    [RadioViewButton setBackgroundImage:[CommonExtension createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [RadioViewButton setBackgroundImage:[CommonExtension createImageWithColor:[UIColor colorWithHexString:kCellHighlightColor]] forState:UIControlStateHighlighted];
    [RadioView addSubview:RadioViewButton];
    
    [self.view addSubview:RadioView];
    
    UIImageView *RadioImg = [[UIImageView alloc] initWithFrame:CGRectMake(FrameWidth(20), FrameWidth(20), FrameWidth(95), FrameWidth(95))];
    RadioImg.layer.cornerRadius = 2;
    RadioImg.image = [UIImage imageNamed:@"personal_radio_msg"];
    [RadioView addSubview:RadioImg];
    
    UILabel *RadioTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(144), FrameWidth(35), FrameWidth(480), FrameWidth(30))];
    RadioTitleLabel.text = @"公告消息";
    RadioTitleLabel.font = FontSize(17);
    [RadioView addSubview:RadioTitleLabel];
    
    _gonggaoNumLabel = [[UILabel alloc]init];
    // CGSize size = [@"告警消息" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontSize(16),NSFontAttributeName,nil]];
    _gonggaoNumLabel.frame = CGRectMake(FrameWidth(180)+size.width, FrameWidth(35), FrameWidth(25), FrameWidth(25));
    //_gonggaoNumLabel.frame = CGRectMake(FrameWidth(260), FrameWidth(30), FrameWidth(25), FrameWidth(25));
    _gonggaoNumLabel.font = FontSize(10);
    _gonggaoNumLabel.layer.cornerRadius = FrameWidth(13);
    _gonggaoNumLabel.clipsToBounds = YES;
    _gonggaoNumLabel.textColor = [UIColor whiteColor];
    _gonggaoNumLabel.textAlignment = NSTextAlignmentCenter;
    _gonggaoNumLabel.backgroundColor = [UIColor redColor];
    [_gonggaoNumLabel setHidden:YES];
    [RadioView addSubview:_gonggaoNumLabel];
    
    UILabel *RadioDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(144), FrameWidth(65), FrameWidth(480), FrameWidth(60))];
    RadioDescLabel.numberOfLines = 3;
    RadioDescLabel.lineBreakMode = NSLineBreakByCharWrapping;
    RadioDescLabel.textColor = [UIColor grayColor];
    RadioDescLabel.font =FontSize(15);
    RadioDescLabel.text = @"公告消息列表在此处显示";
    [RadioView addSubview:RadioDescLabel];
    
    return ;
}

-(void)getNewsNum{
    //获取预警消息数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *FrameRequestURL = [WebHost stringByAppendingString:@"/api/getNotReadNum/warning"];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        if(code == 0){
            _yujingNumLabel.text = [NSString stringWithFormat:@"%@",result[@"value"][@"num"]];//;
            [[NSUserDefaults standardUserDefaults] setInteger:[_yujingNumLabel.text integerValue] forKey:@"unReadNum"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if(![[NSString stringWithFormat:@"%@",result[@"value"][@"num"]] isEqualToString:@"0"]){
                [_yujingNumLabel setHidden:NO];
                return ;
            }
        }
        [_yujingNumLabel setHidden:YES];
        
        
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [_yujingNumLabel setHidden:YES];
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            [FrameBaseRequest logout];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
    
    //获取公告消息数
    NSString *FrameRequestURL1 = [WebHost stringByAppendingString:@"/api/getNotReadNum/notice"];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL1 param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        if(code == 0){
            _gonggaoNumLabel.text = [NSString stringWithFormat:@"%@",result[@"value"][@"num"]];//;
            [[NSUserDefaults standardUserDefaults] setInteger:[_gonggaoNumLabel.text integerValue] forKey:@"unReadNum"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if(![[NSString stringWithFormat:@"%@",result[@"value"][@"num"]] isEqualToString:@"0"]){
                [_gonggaoNumLabel setHidden:NO];
                return ;
            }
        }
        [_gonggaoNumLabel setHidden:YES];
        
        
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [_gonggaoNumLabel setHidden:YES];
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            [FrameBaseRequest logout];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
    
    //获取告警消息数
    NSString *FrameRequestURL2 = [WebHost stringByAppendingString:@"/api/getNotReadNum/alarm"];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL2 param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        if(code == 0){
            _newsNumLabel.text = [NSString stringWithFormat:@"%@",result[@"value"][@"num"]];//;
            [[NSUserDefaults standardUserDefaults] setInteger:[_newsNumLabel.text integerValue] forKey:@"unReadNum"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if(![[NSString stringWithFormat:@"%@",result[@"value"][@"num"]] isEqualToString:@"0"]){
                [_newsNumLabel setHidden:NO];
                return ;
            }
        }
        [_newsNumLabel setHidden:YES];
        
        
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [_newsNumLabel setHidden:YES];
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            [FrameBaseRequest logout];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}
-(void)Radio{
    PersonalMsgListController  * PersonalMsg = [[PersonalMsgListController alloc] init];
    PersonalMsg.thistitle = @"公告消息";
    [self.navigationController pushViewController: PersonalMsg animated:YES];
    
}
-(void)WarnView{
    //PersonalMsgListController
    PersonalMsgListController  * PersonalMsg = [[PersonalMsgListController alloc] init];
    PersonalMsg.thistitle = @"告警消息";
    [self.navigationController pushViewController: PersonalMsg animated:YES];
}
-(void)AlarmView{
    //PersonalMsgListController
    PersonalMsgListController  * PersonalMsg = [[PersonalMsgListController alloc] init];
    PersonalMsg.thistitle = @"预警消息";
    [self.navigationController pushViewController: PersonalMsg animated:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    [self getNewsNum];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*返回*/
-(void)backBtn{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation2"] forBarMetrics:UIBarMetricsDefault];
    
    
    [self.navigationController popViewControllerAnimated:YES];
   
}


@end


