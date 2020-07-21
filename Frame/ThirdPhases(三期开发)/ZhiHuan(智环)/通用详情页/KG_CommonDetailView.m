//
//  KG_CommonDetailView.m
//  Frame
//
//  Created by zhangran on 2020/4/29.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_CommonDetailView.h"
#import "KG_CommonDetailCell.h"
#import "KG_GaojingView.h"
#import "KG_CommonGaojingView.h"
@interface KG_CommonDetailView ()<UITableViewDelegate,UITableViewDataSource>{
    
}


@property (nonatomic, strong) UITableView    *tableView;

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
@property (nonatomic, strong) UIButton       *moreBtn;

@property (nonatomic, strong) UILabel        *runStatusLabel;//运行状态
@property(nonatomic, strong) UIImageView *fengshanImage;
@property(nonatomic,assign)  CGFloat angle;



@property (nonatomic, strong) UIView         *centerView;
@property (nonatomic, strong) KG_CommonGaojingView *centerGaoJingView;
@property (nonatomic, strong) UIImageView *centerImageView;
@end

@implementation KG_CommonDetailView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
        
        [self createTopView];
        
        [self setupDataSubviews];
        
    }
    return self;
}
//初始化数据
- (void)initData {
    
}

- (void)createTopView{
    self.topView = [[UIView alloc]init];
    [self addSubview:self.topView];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@181);
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
    self.roomLabel.numberOfLines = 1;
    [self.topView addSubview:self.roomLabel];
    [self.roomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(6);
        make.top.equalTo(self.topView.mas_top).offset(24);
        make.right.equalTo(self.topView.mas_right).offset(-20);
        make.height.equalTo(@21);
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
    
    
    self.leftImage  = [[UIImageView alloc]init];
    [self.topView addSubview:self.leftImage];
    self.leftImage.image = [UIImage imageNamed:@""];
    self.leftImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topView.mas_bottom).offset(-12);
        make.height.equalTo(@21);
        make.width.equalTo(@21);
        make.left.equalTo(self.topView.mas_left).offset(21);
    }];
    self.leftTitle = [[UILabel alloc]init];
    [self.topView addSubview:self.leftTitle];
    self.leftTitle.layer.cornerRadius = 5.f;
    self.leftTitle.layer.masksToBounds = YES;
    self.leftTitle.text = @"1";
    self.leftTitle.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.leftTitle.font = [UIFont systemFontOfSize:14];
    self.leftTitle.numberOfLines = 1;
    
    self.leftTitle.textAlignment = NSTextAlignmentLeft;
    [self.leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImage.mas_right).offset(7);
        make.bottom.equalTo(self.topView.mas_bottom).offset(-12);
        make.width.equalTo(@150);
        make.height.equalTo(@21);
    }];
    
    self.moreBtn = [[UIButton alloc]init];
    [self.topView addSubview:self.moreBtn];
    [self.moreBtn addTarget:self action:@selector(moreMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBtn setTitleColor:[UIColor colorWithHexString:@"#1860B0"] forState:UIControlStateNormal];
    self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.moreBtn setImage:[UIImage imageNamed:@"blue_jiantou"] forState:UIControlStateNormal];
    [self.moreBtn setTitle:@"更多参数" forState:UIControlStateNormal];
    [self.moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 75, 0, 0)];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView.mas_right).offset(-16);
        make.height.equalTo(@20);
        make.centerY.equalTo(self.leftTitle.mas_centerY);
        make.width.equalTo(@80);
    }];
    
    
    
}

- (void)moreMethod:(UIButton *)button {
    if (self.moreAction) {
        self.moreAction();
    }
    
}

//创建视图
-(void)setupDataSubviews
{
    
    
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}

// 背景按钮点击视图消失
- (void)buttonClickMethod :(UIButton *)btn {
    self.hidden = YES;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        
    }
    return _tableView;
}
-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_CommonDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_CommonDetailCell"];
    if (cell == nil) {
        cell = [[KG_CommonDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_CommonDetailCell"];
    }
    
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    cell.titleLabel.text = safeString(dic[@"name"]);
  
    cell.rightLabel.text = [NSString stringWithFormat:@"%@%@",safeString(dic[@"valueAlias"]),safeString(dic[@"unit"])];
    if (safeString(dic[@"valueAlias"]).length==0) {
        cell.rightLabel.text = @"--";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (NSDictionary *arDic in self.alarmArray) {
        if ([safeString(arDic[@"name"]) containsString:safeString(dic[@"name"])]) {
            cell.titleLabel.textColor = [UIColor colorWithHexString:@"#FB394C"];
            cell.rightLabel.textColor = [UIColor colorWithHexString:@"#FB394C"];
            cell.iconImage.backgroundColor = [UIColor colorWithHexString:@"#FB394C"];
            break;
        }else {
            
            cell.titleLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
            cell.rightLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
            cell.iconImage.backgroundColor = [UIColor colorWithHexString:@"#95A8D7"];
        }
    }
    return cell;
}
- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in dataDic[@"measureTagList"]) {
        if ([dic[@"emphasis"] boolValue]) {
            [arr addObject:dic];
        }
    }
     
    self.dataArray = arr;
    self.gaojingImage.image =[UIImage imageNamed:[self getLevelImage:[NSString stringWithFormat:@"%@",self.level]]];

    self.statusNumLabel.backgroundColor = [self getTextColor:[NSString stringWithFormat:@"%@",self.level]];
    self.statusNumLabel.text = [NSString stringWithFormat:@"%@",self.num];
    if([self.num intValue] == 0) {
        self.statusNumLabel.hidden = YES;
    }else {
        self.statusNumLabel.hidden = NO;
    }
    [self refreshData];
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
    
    NSString *code = safeString(_dataDic[@"name"]);
    self.leftImage.image =  [UIImage imageNamed:[NSString stringWithFormat:@"%@",[CommonExtension getDeviceIcon:safeString(_dataDic[@"category"])]]];
    if([safeString(_dataDic[@"category"]) isEqualToString:@"navigation"]){
        if ([safeString(_dataDic[@"type"]) isEqualToString:@"dme"]) {
            self.leftImage.image =  [UIImage imageNamed:@"导航DME"];
        }else if ([safeString(_dataDic[@"type"]) isEqualToString:@"dvor"]) {
            self.leftImage.image =  [UIImage imageNamed:@"导航DVOR"];
        }
    }
      
   
    self.leftTitle.text = [NSString stringWithFormat:@"%@",safeString(_dataDic[@"name"])];
    
    
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
        
        [self startAnimation];
        if ([self.dataDic[@"measureTagList"] count] ) {
            
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
    if(![safeString(self.dataDic[@"alarmStatus"])  isEqualToString:@"0"] && safeString(self.dataDic[@"alarmStatus"]).length >0){
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
      
    }
    
    if(self.dataArray.count >6) {
        self.tableView.scrollEnabled = YES;
    }else {
        self.tableView.scrollEnabled = NO;
    }
    [self.tableView reloadData];
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
            make.left.equalTo(_centerView.mas_left);
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
