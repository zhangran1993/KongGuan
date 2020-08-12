//
//  KG_KongTiaoControlView.m
//  Frame
//
//  Created by zhangran on 2020/5/21.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_KongTiaoControlView.h"
#import "SegmentTapView.h"
#import "KG_KongTiaoCeDianViewController.h"
#import "KG_KongTiaoControlViewController.h"
#import "KG_CommonGaojingView.h"
#import "KG_GaojingView.h"
#import "KG_MachineDetailModel.h"
#import "StationMachineDetailMoreController.h"
#define nvbH 40
@interface KG_KongTiaoControlView ()<SegmentTapViewDelegate> {
    
}
@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) UIImageView *topIcon ;

@property (nonatomic ,strong) UIImageView *greenDot ;//绿点

@property (nonatomic ,strong) UILabel *titleLabel; //空调

@property (nonatomic ,strong) UILabel *gaojingStatusLabel; //告警状态

@property (nonatomic ,strong) UILabel *runStatusLabel; //运行状态

@property (nonatomic ,strong) UILabel *runStatusDetailLabel; //运行状态

@property (nonatomic ,strong) UILabel *tempLabel; //温度

@property (nonatomic ,strong) UIImageView *statusImage;

@property (nonatomic ,strong) UIImageView *fengshanImage;


@property (nonatomic ,strong) UILabel *tempNumLabel;

@property (nonatomic ,strong) SegmentTapView *segment;

@property(nonatomic,assign)  CGFloat angle;

@property(nonatomic,assign) NSInteger currIndex;



@property (nonatomic, strong) UIView         *centerView;
@property (nonatomic, strong) KG_CommonGaojingView *centerGaoJingView;
@property (nonatomic, strong) UIImageView *centerImageView;


@property (nonatomic, strong) UIView         *topView;

@property (nonatomic, strong) UIImageView    *bgImage;

@property (nonatomic, strong) UIImageView    *equipImage;

@property (nonatomic, strong) UIImageView    *iconImage;
@property (nonatomic, strong) UILabel        *roomLabel;

@property (nonatomic, strong) UILabel        *gaojingLabel;
@property (nonatomic, strong) UIImageView    *gaojingImage;
@property (nonatomic, strong) UILabel        *statusNumLabel;
@property (nonatomic, strong) KG_GaojingView *gaojingView;


@property (nonatomic, strong) UIImageView    *leftImage;
@property (nonatomic, strong) UILabel        *leftTitle;

@property (nonatomic, strong) UISegmentedControl *segmentedControl;


@property (nonatomic, strong) KG_KongTiaoCeDianViewController *cedianView;
@property (nonatomic, strong) KG_KongTiaoControlViewController *controlView;
@end

@implementation KG_KongTiaoControlView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshControlLogSegment) name:@"refreshControlLogSegment" object:nil];
        
        self.frame = frame;
        [self initData];
        [self createTopView];
        [self setupDataSubviews];
        
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
    //第一种方法.这里可以移除该控制器下的所有通知
    //移除当前所有通知
    NSLog(@"移除了所有的通知");
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)refreshControlLogSegment {
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH *self.currIndex, 0)];
}
//初始化数据
- (void)initData {
    self.currIndex = 0;
}

- (void)createTopView{
    self.topView = [[UIView alloc]init];
    [self addSubview:self.topView];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(@202);
        make.top.equalTo(self.mas_top);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    [self.topView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.topView.mas_left).offset(17);
        make.right.equalTo(self.topView.mas_right).offset(-14);
        make.height.equalTo(@2);
    }];
    
    self.bgImage = [[UIImageView alloc]init];
    [self.topView addSubview:self.bgImage];
    self.bgImage.backgroundColor =  [UIColor colorWithRed:243/255.0 green:245/255.0 blue:249/255.0 alpha:1.0];
    self.bgImage.layer.cornerRadius = 10;
    self.bgImage.layer.masksToBounds = YES;
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(16);
        make.top.equalTo(self.topView.mas_top).offset(20);
        make.width.equalTo(@145);
        make.height.equalTo(@106);
    }];
    self.equipImage = [[UIImageView alloc]init];
    [self.topView addSubview:self.equipImage];
    self.equipImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.equipImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(16);
        make.top.equalTo(self.topView.mas_top).offset(29);
        make.width.equalTo(@145);
        make.height.equalTo(@89);
    }];
    
    self.iconImage = [[UIImageView alloc]init];
    [self.topView addSubview:self.iconImage];
    self.iconImage.backgroundColor =  [UIColor colorWithHexString:@"#03C3B6"];
    self.iconImage.layer.cornerRadius = 4.f;
    self.iconImage.layer.masksToBounds = YES;
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.equipImage.mas_right).offset(10);
        make.top.equalTo(self.topView.mas_top).offset(31);
        make.width.equalTo(@8);
        make.height.equalTo(@8);
    }];
    
    
    self.roomLabel = [[UILabel alloc]init];
    self.roomLabel.font = [UIFont systemFontOfSize:14];
    self.roomLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.roomLabel.numberOfLines = 2;
    [self.roomLabel sizeToFit];
    [self.topView addSubview:self.roomLabel];
    [self.roomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(6);
        make.top.equalTo(self.topView.mas_top).offset(24);
        make.right.equalTo(self.topView.mas_right).offset(0);
    }];
    
    self.gaojingLabel = [[UILabel alloc]init];
    self.gaojingLabel.font = [UIFont systemFontOfSize:14];
    self.gaojingLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
    self.gaojingLabel.numberOfLines = 1;
    self.gaojingLabel.text = @"告警状态";
    [self.topView addSubview:self.gaojingLabel];
    [self.gaojingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.roomLabel.mas_left);
        make.top.equalTo(self.roomLabel.mas_bottom).offset(5);
        make.width.equalTo(@120);
        make.height.equalTo(@21);
    }];
    
    self.gaojingImage = [[UIImageView alloc]init];
    [self.topView addSubview:self.gaojingImage];
    self.gaojingImage.image = [UIImage imageNamed:@"level_normal"];
    [self.gaojingImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.gaojingLabel.mas_centerY);
        make.height.equalTo(@17);
        make.width.equalTo(@32);
        make.right.equalTo(self.mas_right).offset(-16);
    }];
    self.statusNumLabel = [[UILabel alloc]init];
    [self.topView addSubview:self.statusNumLabel];
    self.statusNumLabel.layer.cornerRadius = 5.f;
    self.statusNumLabel.layer.masksToBounds = YES;
    self.statusNumLabel.text = @"1";
    self.statusNumLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.statusNumLabel.font = [UIFont systemFontOfSize:10];
    self.statusNumLabel.numberOfLines = 1;
    
    self.statusNumLabel.textAlignment = NSTextAlignmentCenter;
    [self.statusNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gaojingImage.mas_right).offset(-5);
        make.bottom.equalTo(self.gaojingImage.mas_top).offset(5);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
    NSArray *array = @[@"设备测点",@"反向控制"];
    
    self.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    
    
    self.segmentedControl  = [[UISegmentedControl alloc]initWithItems:array];
    self.segmentedControl.frame = CGRectMake(17,142+5, SCREEN_WIDTH - 34,30);
    [self.segmentedControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    
    
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF"]}forState:UIControlStateSelected];
    
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#2F5ED1"],NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f]}forState:UIControlStateNormal];
    [self addSubview:self.segmentedControl];
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.tintColor = [UIColor whiteColor];
    self.segmentedControl.layer.borderWidth = 1;                   //    边框宽度，重新画边框，若不重新画，可能会出现圆角处无边框的情况
    self.segmentedControl.layer.borderColor = [UIColor colorWithHexString:@"#2F5ED1"].CGColor; //     边框颜色
    [self.segmentedControl setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]]
                                forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [self.segmentedControl setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#2F5ED1"]]
                                forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.mas_left).offset(17);
        make.right.equalTo(self.mas_right).offset(-17);
        make.height.equalTo(@30);
        make.top.equalTo(self.bgImage.mas_bottom).offset(16);
    }];
    
//    self.leftImage  = [[UIImageView alloc]init];
//    [self.topView addSubview:self.leftImage];
//    self.leftImage.image = [UIImage imageNamed:@""];
//    [self.leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.segmentedControl.mas_bottom).offset(21);
//        make.height.equalTo(@16.5);
//        make.width.equalTo(@11);
//        make.left.equalTo(self.topView.mas_left).offset(21);
//    }];
//    self.leftTitle = [[UILabel alloc]init];
//    [self.topView addSubview:self.leftTitle];
//    self.leftTitle.layer.cornerRadius = 5.f;
//    self.leftTitle.layer.masksToBounds = YES;
//    self.leftTitle.text = @"1";
//    self.leftTitle.textColor = [UIColor colorWithHexString:@"#24252A"];
//    self.leftTitle.font = [UIFont systemFontOfSize:14];
//    self.leftTitle.numberOfLines = 1;
//
//    self.leftTitle.textAlignment = NSTextAlignmentLeft;
//    [self.leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.leftImage.mas_right).offset(7);
//        make.top.equalTo(self.segmentedControl.mas_bottom).offset(16);
//        make.width.equalTo(@150);
//        make.height.equalTo(@21);
//    }];
    
   
    
    
    
}

//创建视图
-(void)setupDataSubviews
{
    [self createSegmentView];
    
}

- (void)createSegmentView{
   
    //scroView
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,self.segmentedControl.frame.origin.y +self.segmentedControl.frame.size.height,SCREEN_WIDTH,self.frame.size.height )];
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, 0);
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentedControl.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    //把页面添加到scroView的三个页面
    self.cedianView = [[KG_KongTiaoCeDianViewController alloc]init];

    self.cedianView.view.frame = CGRectMake(0, 0,SCREEN_WIDTH , self.scrollView.frame.size.height);
    self.cedianView.moreAction = ^(NSDictionary * _Nonnull dataDic) {
        
        NSDictionary * Detail = @{ @"tagList":dataDic[@"measureTagList"],
                                   @"station_name":dataDic[@"stationName"],
                                   @"machine_name":dataDic[@"name"],
                                   @"name":dataDic[@"name"],
                                    @"category":dataDic[@"category"],

                                   
        };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"moreCanshu" object:Detail];

    };
    [self.scrollView addSubview:self.cedianView.view];
    self.controlView = [[KG_KongTiaoControlViewController alloc]init];
    self.controlView.controlLog = ^{
        
       
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH *self.currIndex, 0)];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"controlLog" object:self.dataDic];
         
    };
    self.controlView.view.frame = CGRectMake(self.scrollView.frame.size.width * 1, 0, SCREEN_WIDTH , self.scrollView.frame.size.height );
    [self.scrollView addSubview:self.controlView.view];
 
}
- (void)change:(UISegmentedControl *)sender {
    NSLog(@"测试");
    if (sender.selectedSegmentIndex == 0) {
        NSLog(@"1");
    }else if (sender.selectedSegmentIndex == 1){
        NSLog(@"2");
    }else if (sender.selectedSegmentIndex == 2){
        NSLog(@"3");
    }else if (sender.selectedSegmentIndex == 3){
        NSLog(@"4");
    }
    self.currIndex = sender.selectedSegmentIndex;
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self.scrollView setContentSize:CGSizeMake(self.frame.size.width*2  , 0)];
            [self.scrollView setContentOffset:CGPointMake(0, 0)];
            break;
        case 1:
            [self.scrollView setContentSize:CGSizeMake(self.frame.size.width*2, 0)];
            [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
            break;
        
        default:
            break;
    }
}
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


- (void)selectedIndex:(NSInteger)index{
    NSLog(@"测试");
    
    if (index == 0) {
        NSLog(@"1");
        
    }else if (index == 1){
        NSLog(@"2");
        
    }else if (index == 2){
        NSLog(@"3");
        
    }else if (index == 3){
        NSLog(@"4");
        
    }
    
}
- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.gaojingImage.image =[UIImage imageNamed:[self getLevelImage:[NSString stringWithFormat:@"%@",self.level]]];
    
    self.statusNumLabel.backgroundColor = [self getTextColor:[NSString stringWithFormat:@"%@",self.level]];
    self.statusNumLabel.text = [NSString stringWithFormat:@"%@",self.num];
    if([self.level intValue] == 0) {
        self.statusNumLabel.hidden = YES;
    }else {
        self.statusNumLabel.hidden = NO;
    }
    if (dataDic.count) {
        self.dataArray = dataDic[@"measureTagList"];
        self.cedianView.alarmArray = self.alarmArray;
        self.cedianView.dataDic = dataDic;
        self.cedianView.dataArray = self.dataArray;
        self.controlView.dataDic = dataDic;
        self.controlView.dataArray = self.dataArray;
        [self refreshData];
    }
  
}

- (void)refreshData {
    
    for (NSDictionary *dic in self.dataArray) {
           if([safeString(dic[@"name"]) isEqualToString:@"通信状态"]) {
               if([safeString(dic[@"valueAlias"]) isEqualToString:@"断线"]) {
                   
                   self.iconImage.backgroundColor  = [UIColor colorWithHexString:@"#FB394C"];
                   break;
               }else {
                   self.iconImage.backgroundColor =  [UIColor colorWithHexString:@"#03C3B6"];
               }
           }
       }
       
    [self.equipImage sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",WebNewHost,_dataDic[@"picture"]]] placeholderImage:[UIImage imageNamed:@"station_indexbg"] ];
    self.roomLabel.text = [NSString stringWithFormat:@"%@-%@",safeString(_dataDic[@"roomName"]),safeString(_dataDic[@"name"])];
    self.cedianView.leftStr = safeString(_dataDic[@"name"]);
    self.cedianView.leftIconStr = safeString(_dataDic[@"name"]);
    self.controlView.leftStr = safeString(_dataDic[@"name"]);
    self.controlView.leftIconStr = safeString(_dataDic[@"name"]);
    
//
//    NSString *code = safeString(_dataDic[@"name"]);
//    self.leftImage.image = [UIImage imageNamed:@"UPS"];
//    if([code isEqualToString:@"UPS"]){
//        self.leftImage.image = [UIImage imageNamed:@"device_UPS"];
//    }else if([code isEqualToString:@"水浸"]){
//        self.leftImage.image = [UIImage imageNamed:@"device_shuijin"];
//    }else if([code isEqualToString:@"烟感"]){
//        self.leftImage.image = [UIImage imageNamed:@"device_yangan"];
//    }else if([code isEqualToString:@"空调"]){
//        self.leftImage.image = [UIImage imageNamed:@"device_kongtiao"];
//    }else if([code isEqualToString:@"蓄电池"]){
//        self.leftImage.image = [UIImage imageNamed:@"device_xudianchi"];
//    }else if([code isEqualToString:@"柴油发电机"]){
//        self.leftImage.image = [UIImage imageNamed:@"device_chaiyou"];
//    }else if([code isEqualToString:@"电量仪"]){
//        self.leftImage.image = [UIImage imageNamed:@"device_dianliangyi"];
//    }else if([code isEqualToString:@"空开"]){
//        self.leftImage.image = [UIImage imageNamed:@"device_kongtiao"];
//    }else if([code isEqualToString:@"电子围栏"]){
//        self.leftImage.image = [UIImage imageNamed:@"device_zhalan"];
//    }else if([code isEqualToString:@"门禁"]){
//        self.leftImage.image = [UIImage imageNamed:@"device_menjin"];
//    }else if([code isEqualToString:@"视频监测"]){
//        self.leftImage.image = [UIImage imageNamed:@"device_video"];
//    }else if([code isEqualToString:@"温湿度"]){
//        self.leftImage.image = [UIImage imageNamed:@"device_wenshidu"];
//    }else {
//        self.leftImage.image = [UIImage imageNamed:@"device_UPS"];
//    }
//    self.leftTitle.text = safeString(_dataDic[@"name"]);
//
    if([self.dataDic[@"alias"] containsString:@"空调"]){
        
        self.runStatusLabel  = [[UILabel alloc]init];
        [self.topView addSubview:self.runStatusLabel];
        
        self.runStatusLabel.text = @"运行状态";
        self.runStatusLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
        self.runStatusLabel.font = [UIFont systemFontOfSize:14];
        self.runStatusLabel.numberOfLines = 1;
        
        self.runStatusLabel.textAlignment = NSTextAlignmentLeft;
        [self.runStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.gaojingLabel.mas_left);
            make.top.equalTo(self.gaojingLabel.mas_bottom).offset(4);
            make.width.equalTo(@100);
            make.height.equalTo(@21);
        }];
        NSArray *runStatusArray = self.dataDic[@"measureTagList"];
        if (runStatusArray.count) {
            for (NSDictionary *runStatsuDic in runStatusArray) {
                if ([runStatsuDic[@"name"] containsString:@"运行状态"]) {
                    NSString *value = safeString(runStatsuDic[@"valueAlias"]);
                    if (value.length == 0) {
                        
                        self.runStatusDetailLabel = [[UILabel alloc]init];
                        [self.topView addSubview:self.runStatusDetailLabel];
                        
                        self.runStatusDetailLabel.text = @"--";
                        self.runStatusDetailLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
                        self.runStatusDetailLabel.font = [UIFont systemFontOfSize:14];
                        self.runStatusDetailLabel.numberOfLines = 1;
                        
                        self.runStatusDetailLabel.textAlignment = NSTextAlignmentRight;
                        [self.runStatusDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                            
                            make.right.equalTo(self.topView.mas_right).offset(-30);
                            make.centerY.equalTo(self.runStatusLabel.mas_centerY);
                            make.width.equalTo(@30);
                            make.height.equalTo(@21);
                        }];
                        self.runStatusDetailLabel.hidden = NO;
                        self.fengshanImage.hidden = YES;
                    }else {
                        
                        self.fengshanImage = [[UIImageView alloc]init];
                        self.fengshanImage.image = [UIImage imageNamed:@"fengshan"];
                        [self.topView addSubview:self.fengshanImage];
                        
                        [self.fengshanImage mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.width.equalTo(@16);
                            make.height.equalTo(@16);
                            make.right.equalTo(self.topView.mas_right).offset(-30);
                            make.centerY.equalTo(self.runStatusLabel.mas_centerY);
                        }];
                        self.angle = 0;
                        
                        
                   
                        if ([value isEqualToString:@"关闭"]) {
//                            [self endAnimation];
                        }else if ([value isEqualToString:@"运行"]) {
                            [self startAnimation];
                            
                        }
                        
                        self.runStatusDetailLabel.hidden = YES;
                        self.fengshanImage.hidden = NO;
                    }
                    
                    break;
                }
            }
        }
        
        if ([self.dataDic[@"measureTagList"] count]) {
            
            self.gaojingView = [[KG_GaojingView alloc]init];
            [self.topView addSubview:self.gaojingView];
            [self.gaojingView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@42);
                make.left.equalTo(self.roomLabel.mas_left);
                make.right.equalTo(self.topView.mas_right).offset(-16);
                make.top.equalTo(self.runStatusLabel.mas_bottom).offset(5);
            }];
            self.gaojingView.powArray = self.dataDic[@"measureTagList"];
            
            
        }
        
        
    }else {
        if (self.dataArray.count) {
            self.gaojingView = [[KG_GaojingView alloc]init];
            [self.topView addSubview:self.gaojingView];
            [self.gaojingView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@42);
                make.left.equalTo(self.roomLabel.mas_left);
                make.right.equalTo(self.topView.mas_right).offset(-16);
                make.top.equalTo(self.gaojingLabel.mas_bottom).offset(5);
            }];
            self.gaojingView.powArray = self.dataArray;
        }
    }
   
    if([safeString(self.dataDic[@"alarmStatus"])  isEqualToString:@"1"] && safeString(self.dataDic[@"alarmStatus"]).length >0){
           [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
               make.height.equalTo(@261);
           }];
           [self.topView addSubview: self.centerView];
           [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.equalTo(self.topView.mas_left).offset(16);
               make.right.equalTo(self.topView.mas_right).offset(-16);
               make.height.equalTo(@80);
               make.top.equalTo(self.bgImage.mas_bottom).offset(10);
           }];
//         self.segmentedControl.frame = CGRectMake(17,142+5 +261-202, SCREEN_WIDTH - 34,30);
        [self.segmentedControl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo (self.mas_left).offset(17);
            make.right.equalTo(self.mas_right).offset(-17);
            make.height.equalTo(@30);
            make.top.equalTo(self.bgImage.mas_bottom).offset(16+80);
        }];
    }
  
}
-(void )startAnimation

{
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.01];
    
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    
    self.fengshanImage.transform = CGAffineTransformMakeRotation(self.angle * (M_PI / 180.0f));
    
    [UIView commitAnimations];
    
}

-(void)endAnimation

{
    
    self.angle += 10;
    
    [self startAnimation];
    
}
- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc]initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH -32, 80)];
        _centerView.backgroundColor = [UIColor colorWithHexString:@"#F9FAFC"];
        _centerView.layer.cornerRadius = 10;
        _centerView.layer.masksToBounds = YES;
        
        self.centerImageView = [[UIImageView alloc]init];
        [_centerView addSubview:self.centerImageView];
        self.centerImageView.image = [UIImage imageNamed:@"alert_urgent"];
        [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@44);
            make.height.equalTo(@44);
            make.left.equalTo(_centerView.mas_left).offset(10);
            make.centerY.equalTo(_centerView.mas_centerY);
        }];
        self.centerGaoJingView = [[KG_CommonGaojingView alloc]init];
        self.centerGaoJingView.dataArray = self.alarmArray;
        [_centerView addSubview:self.centerGaoJingView];
        [self.centerGaoJingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.centerImageView.mas_right).offset(5);
            make.height.equalTo(_centerView.mas_height);
            make.top.equalTo(_centerView.mas_top);
            make.right.equalTo(_centerView.mas_right);
        }];
        UIButton *btn = [[UIButton alloc]init];
        [_centerView addSubview:btn];
        [btn addTarget:self action:@selector(buttonGotoDetail) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitle:@"" forState:UIControlStateNormal];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@80);
            make.height.equalTo(_centerView.mas_height);
            make.top.equalTo(_centerView.mas_top);
            make.right.equalTo(_centerView.mas_right);
        }];
       
        
    }
    return _centerView;
}

- (void)buttonGotoDetail {
    if (self.gotoDetail) {
        self.gotoDetail();
    }
}
- (void)setAlarmArray:(NSArray *)alarmArray {
    _alarmArray = alarmArray;
    
}

- (UIColor *)getTextColor:(NSString *)level {
    UIColor *textColor = [UIColor colorWithHexString:@"FFFFFF"];
    
    if ([level isEqualToString:@"0"]) {
        textColor = [UIColor colorWithHexString:@"FFFFFF"];
    }else if ([level isEqualToString:@"4"]) {
        textColor = [UIColor colorWithHexString:@"2986F1"];
    }else if ([level isEqualToString:@"3"]) {
        textColor = [UIColor colorWithHexString:@"FFA800"];
    }else if ([level isEqualToString:@"2"]) {
        textColor = [UIColor colorWithHexString:@"FC7D0E"];
    }else if ([level isEqualToString:@"1"]) {
        textColor = [UIColor colorWithHexString:@"F62546"];
    }
    
    //紧急
    return textColor;
}


- (NSString *)getLevelImage:(NSString *)level {
    NSString *levelString = @"level_normal";
    
    if ([level isEqualToString:@"0"]) {
        levelString = @"level_normal";
    }else if ([level isEqualToString:@"4"]) {
        levelString = @"level_prompt";
    }else if ([level isEqualToString:@"3"]) {
        levelString = @"level_ciyao";
    }else if ([level isEqualToString:@"2"]) {
        levelString = @"level_important";
    }else if ([level isEqualToString:@"1"]) {
        levelString = @"level_jinji";
    }
    
    //紧急
    return levelString;
}
@end
