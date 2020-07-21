//
//  KG_KongTiaoControlViewController.m
//  Frame
//
//  Created by zhangran on 2020/5/21.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_KongTiaoControlViewController.h"
#import "DoubleSliderView.h"
#import "UIView+Extension.h"
#import "Masonry.h"
#import "BAUISlider.h"
#import "KG_PowerOnView.h"
#import "CircleView.h"
#import "KG_NiControlView.h"
@interface KG_KongTiaoControlViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic ,strong) UIButton *moreBtn ;

@property(nonatomic, strong)BAUISlider *umberSlider;//买入数量百分比
@property(nonatomic, strong)UILabel *sliderValueLabel;//滑块下面的值
@property (nonatomic ,strong) UIImageView *leftIcon;
@property (nonatomic ,strong) CircleView *circleView;
@property (nonatomic ,strong) UILabel *leftTitle;
@property (nonatomic ,strong) UIButton *powBtn;
@property (nonatomic ,strong) UILabel *tempTitle;
@property (nonatomic ,strong) UILabel *tempTextTitle;

@property (nonatomic ,strong) UILabel *modelTitle;
@property (nonatomic ,assign) NSInteger currIndex;

@property (nonatomic ,strong)  DoubleSliderView *doubleSliderView;
@property (nonatomic, assign) NSInteger minAge;
@property (nonatomic, assign) NSInteger maxAge;
@property (nonatomic, assign) NSInteger curMinAge;
@property (nonatomic, assign) NSInteger curMaxAge;

@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *ageTipsLabel;

@property (nonatomic, strong) UILabel *tempSelLabel;
@property (nonatomic, strong) KG_PowerOnView *powOnView;
@property (nonatomic, strong) KG_NiControlView *niControlView;
@property (nonatomic, strong) UIView *sliderBgView;
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) UIButton *btn4;
@property (nonatomic, strong) UIImageView *weatherImage;

@property (nonatomic, copy) NSString *textString;

@property (nonatomic, copy) NSString *modelString;
@property (nonatomic, assign)int  temValue;
@property (nonatomic, copy)NSString  *switchStatus;
@property (nonatomic, copy) NSString *textFieldString;

@property (nonatomic, strong) UIButton *confirmBtn ;

@end

@implementation KG_KongTiaoControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currIndex = 0;
    self.modelString = @"hot";
    self.temValue = 16;
    self.switchStatus = @"off";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self createScrollView];
    [self createView];
    [self createSliderView];
}

- (void)createScrollView {
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    

}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        
    }
    return _tableView;
}
- ( void)createSliderView{
//    self.minAge = 16;
//    self.maxAge = 24;
//    self.curMinAge = 16;
//    self.curMaxAge = 24;
//
//    self.view.backgroundColor = [UIColor whiteColor];
//
//
//
//    [self.view addSubview:self.ageLabel];
//    [self.view addSubview:self.ageTipsLabel];
//    [self.view addSubview:self.doubleSliderView];
////    [self.doubleSliderView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.left.equalTo(self.tempSelLabel.mas_right).offset(5);
////        make.height.equalTo(@55);
////        make.centerY.equalTo(self.tempSelLabel.mas_centerY);
////        make.right.equalTo(self.view.mas_right).offset(-31);
////    }];
//
//    self.ageLabel.centerY = 156+120+45;
//    self.ageLabel.x = 80;
//
//    self.ageTipsLabel.centerY = self.ageLabel.centerY;
//    self.ageTipsLabel.x = self.ageLabel.right + 7;
//
//    self.doubleSliderView.x = 80;
//    self.doubleSliderView.y = 185 - 10+120+45;
    
    
}
-(UIImage *)OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage *scaleImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;
}
#pragma mark - action
//根据值获取整数

- (CGFloat)fetchIntFromValue:(CGFloat)value {
    CGFloat newValue = floorf(value);
    CGFloat changeValue = value - newValue;
    if (changeValue >= 0.5) {
        newValue = newValue + 1;
    }
    return newValue;
}

- (void)sliderValueChangeActionIsLeft: (BOOL)isLeft finish: (BOOL)finish {
    if (isLeft) {
        CGFloat age = (self.maxAge - self.minAge) * self.doubleSliderView.curMinValue;
        CGFloat tmpAge = [self fetchIntFromValue:age];
        self.curMinAge = (NSInteger)tmpAge + self.minAge;
        [self changeAgeTipsText];
    }else {
        CGFloat age = (self.maxAge - self.minAge) * self.doubleSliderView.curMaxValue;
        CGFloat tmpAge = [self fetchIntFromValue:age];
        self.curMaxAge = (NSInteger)tmpAge + self.minAge;
        [self changeAgeTipsText];
    }
    if (finish) {
        [self changeSliderValue];
    }
}

//值取整后可能改变了原始的大小，所以需要重新改变滑块的位置
- (void)changeSliderValue {
    CGFloat finishMinValue = (CGFloat)(self.curMinAge - self.minAge)/(CGFloat)(self.maxAge - self.minAge);
    CGFloat finishMaxValue = (CGFloat)(self.curMaxAge - self.minAge)/(CGFloat)(self.maxAge - self.minAge);
    self.doubleSliderView.curMinValue = finishMinValue;
    self.doubleSliderView.curMaxValue = finishMaxValue;
    [self.doubleSliderView changeLocationFromValue];
}

- (void)changeAgeTipsText {
    if (self.curMinAge == self.curMaxAge) {
        self.ageTipsLabel.text = [NSString stringWithFormat:@"%li岁", self.curMinAge];
    }else {
        self.ageTipsLabel.text = [NSString stringWithFormat:@"%li~%li岁", self.curMinAge, self.curMaxAge];
    }
    [self.ageTipsLabel sizeToFit];
    self.ageTipsLabel.centerY = self.ageLabel.centerY;
    self.ageTipsLabel.x = self.ageLabel.right + 7;
}

#pragma mark - setter & getter

- (UILabel *)ageLabel {
    if (!_ageLabel) {
        _ageLabel = [[UILabel alloc] init];
        _ageLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _ageLabel.textColor = [UIColor blackColor];
        _ageLabel.text = @"年龄 age";
        [_ageLabel sizeToFit];
    }
    return _ageLabel;
}

- (UILabel *)ageTipsLabel {
    if (!_ageTipsLabel) {
        _ageTipsLabel = [[UILabel alloc] init];
        _ageTipsLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _ageTipsLabel.textColor = [UIColor blackColor];
        _ageTipsLabel.text = [NSString stringWithFormat:@"%li~%li岁",self.minAge, self.maxAge];
        [_ageTipsLabel sizeToFit];
    }
    return _ageTipsLabel;
}

- (void)createView {
   
    
    
}
//
- (void)btn1Method {
    self.modelString = @"hot";//制热
    self.weatherImage.image = [UIImage imageNamed:@"制热 icon"];
    self.tempTextTitle.text = [NSString stringWithFormat:@"制热"];
    [self.btn1 setImage:[UIImage imageNamed:@"制热可选选中"] forState:UIControlStateNormal];
    [self.btn2 setImage:[UIImage imageNamed:@"制冷可选未选中"] forState:UIControlStateNormal];
    [self.btn3 setImage:[UIImage imageNamed:@"除湿可选未选中"] forState:UIControlStateNormal];
    [self.btn4 setImage:[UIImage imageNamed:@"送风可选未选中"] forState:UIControlStateNormal];
}
- (void)btn2Method {
    self.modelString = @"temperature";//制冷
    self.weatherImage.image = [UIImage imageNamed:@"制冷icon"];
    self.tempTextTitle.text = [NSString stringWithFormat:@"制冷"];
    [self.btn1 setImage:[UIImage imageNamed:@"制热可选未选中"] forState:UIControlStateNormal];
    [self.btn2 setImage:[UIImage imageNamed:@"制冷可选选中"] forState:UIControlStateNormal];
    [self.btn3 setImage:[UIImage imageNamed:@"除湿可选未选中"] forState:UIControlStateNormal];
    [self.btn4 setImage:[UIImage imageNamed:@"送风可选未选中"] forState:UIControlStateNormal];
    
}
- (void)btn3Method {
    self.modelString = @"damp";//除湿
    self.weatherImage.image = [UIImage imageNamed:@"除湿"];
    self.tempTextTitle.text = [NSString stringWithFormat:@"除湿"];
    [self.btn1 setImage:[UIImage imageNamed:@"制热可选未选中"] forState:UIControlStateNormal];
    [self.btn2 setImage:[UIImage imageNamed:@"制冷可选未选中"] forState:UIControlStateNormal];
    [self.btn3 setImage:[UIImage imageNamed:@"除湿可选选中"] forState:UIControlStateNormal];
    [self.btn4 setImage:[UIImage imageNamed:@"送风可选未选中"] forState:UIControlStateNormal];
    
}
- (void)btn4Method {
    self.modelString = @"wind ";//送风
    self.weatherImage.image = [UIImage imageNamed:@"送风"];
    self.tempTextTitle.text = [NSString stringWithFormat:@"送风"];
    [self.btn1 setImage:[UIImage imageNamed:@"制热可选未选中"] forState:UIControlStateNormal];
    [self.btn2 setImage:[UIImage imageNamed:@"制冷可选未选中"] forState:UIControlStateNormal];
    [self.btn3 setImage:[UIImage imageNamed:@"除湿可选未选中"] forState:UIControlStateNormal];
    [self.btn4 setImage:[UIImage imageNamed:@"送风可选选中"] forState:UIControlStateNormal];
    
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

- (void)moreMethod:(UIButton *)button {
    
    if (self.controlLog) {
        self.controlLog();
    }
    
}

- (void)confirmMethod:(UIButton *)button {
    [self.niControlView  removeFromSuperview];
    _niControlView = nil;
    self.niControlView.hidden = NO;
    self.niControlView.textString = ^(NSString * _Nonnull textStr) {
        self.textString = textStr;
    };
    self.niControlView.textFieldString = ^(NSString * _Nonnull textFieldStr) {
        self.textFieldString = textFieldStr;
    };
    self.niControlView.confirmMethod = ^{
        [self confirmMethod];
    };
    
    
}
- (void)confirmMethod {
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/atcEquipment/sendCmd",WebNewHost];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    paramDic[@"operatorId"] = safeString(self.dataDic[@"operatorId"]);
    
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if ([userdefaults objectForKey:@"name"]) {
        NSString *userName = [userdefaults objectForKey:@"name"];
        paramDic[@"operatorName"] = userName;//操作人名称
        
    }
    paramDic[@"password"] = safeString(self.textFieldString);//密码
    paramDic[@"stationCode"] = safeString(self.dataDic[@"stationCode"]);//台站编码
    paramDic[@"description"] = safeString(self.textString); //操作备注
    paramDic[@"equipmentCode"] = safeString(self.dataDic[@"code"]);//设备编码
    
    if ([self.modelString isEqualToString:@"switch"]) {
        paramDic[@"value"] = [NSString stringWithFormat:@"%@",self.switchStatus];//设备设置数值
        paramDic[@"mode"] = safeString(self.modelString);//设备设置模式
        
    }else {
        paramDic[@"value"] = [NSString stringWithFormat:@"%d",self.temValue];//设备设置数值
        paramDic[@"mode"] = safeString(self.modelString);//设备设置模式
    }
    [FrameBaseRequest postWithUrl:FrameRequestURL param:paramDic success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        self.textFieldString = nil;//清空密码
        NSString *str =safeString(result[@"value"][@"result"]);
        if ([str isEqualToString:@"Password Error"]) {
            NSLog(@"密码错误");
            [FrameBaseRequest showMessage:@"密码错误"];
        }else if ([str isEqualToString:@"Success Send"]) {
            NSLog(@"设置成功");
            [FrameBaseRequest showMessage:@"设置成功"];
        }
        if ([self.switchStatus isEqualToString:@"off"]) {
            self.switchStatus = @"on";
            [self.powBtn setImage:[UIImage imageNamed:@"kongtiao_powOn"] forState:UIControlStateNormal];
        }else {
            self.switchStatus = @"off";
            [self.powBtn setImage:[UIImage imageNamed:@"kongtiao_powOff"] forState:UIControlStateNormal];
            
        }
        
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}

- (void)powMethod:(UIButton *)button {
    self.modelString = @"switch";
  
    [self.powOnView removeFromSuperview];
    _powOnView = nil;
    self.powOnView.hidden = NO;
    self.powOnView.textString = ^(NSString * _Nonnull textStr) {
        self.textString = textStr;
    };
    
    self.powOnView.confirmBlockMethod = ^{
        [self confirmMethod];
    };
    self.powOnView.textFieldString = ^(NSString * _Nonnull textFieldStr) {
        self.textFieldString = textFieldStr;
    };
   
   
}


- (DoubleSliderView *)doubleSliderView {
    if (!_doubleSliderView) {
        _doubleSliderView = [[DoubleSliderView alloc] initWithFrame:CGRectMake(80, 0, SCREEN_WIDTH -32-100-5, 35 + 20)];
        _doubleSliderView.needAnimation = true;
        //        CGFloat offset = self.maxAge - self.minAge;
        //        if (offset > 4.0) {
        //            _doubleSliderView.minInterval = 4.0/(offset);
        //        }
        __weak typeof(self) weakSelf = self;
        _doubleSliderView.sliderBtnLocationChangeBlock = ^(BOOL isLeft, BOOL finish) {
            [weakSelf sliderValueChangeActionIsLeft:isLeft finish:finish];
        };
    }
    return _doubleSliderView;
}

- (KG_PowerOnView *)powOnView {
    
    if (!_powOnView) {
        _powOnView = [[KG_PowerOnView alloc]init];
        [JSHmainWindow addSubview:self.powOnView];
        [self.powOnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo([UIApplication sharedApplication].keyWindow.mas_left);
            make.right.equalTo([UIApplication sharedApplication].keyWindow.mas_right);
            make.top.equalTo([UIApplication sharedApplication].keyWindow.mas_top);
            make.bottom.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom);
        }];
        
    }
    return _powOnView;
    
}

- (KG_NiControlView *)niControlView {
    
    if (!_niControlView) {
        _niControlView = [[KG_NiControlView alloc]init];
        [JSHmainWindow addSubview:self.niControlView];
        [self.niControlView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo([UIApplication sharedApplication].keyWindow.mas_left);
            make.right.equalTo([UIApplication sharedApplication].keyWindow.mas_right);
            make.top.equalTo([UIApplication sharedApplication].keyWindow.mas_top);
            make.bottom.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom);
        }];
        
    }
    return _niControlView;
    
}


- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    
  
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    NSString *code = safeString(_dataDic[@"category"]);
    NSString *name = safeString(_dataDic[@"name"]);
    self.leftIcon.image = [UIImage imageNamed:[CommonExtension getDeviceIcon:safeString(_dataDic[@"category"])]];
    
    if([safeString(_dataDic[@"category"]) isEqualToString:@"navigation"]){
        if ([safeString(_dataDic[@"type"]) isEqualToString:@"dme"]) {
            self.leftIcon.image =  [UIImage imageNamed:@"导航DME"];
        }else if ([safeString(_dataDic[@"type"]) isEqualToString:@"dvor"]) {
            self.leftIcon.image =  [UIImage imageNamed:@"导航DVOR"];
        }
    }
    if (safeString(dataDic[@"reverseControl"])) {
        [self.confirmBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
        self.confirmBtn.userInteractionEnabled = YES;
    }else {
         [self.confirmBtn setTitleColor:[UIColor colorWithHexString:@"#C2CDDE"] forState:UIControlStateNormal];
        self.confirmBtn.userInteractionEnabled = NO;
    }

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return   1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 500;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
    self.leftIcon = [[UIImageView alloc]init];
    [cell addSubview:self.leftIcon];
    
    [self.leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.mas_left).offset(18);
        make.width.equalTo(@15);
        make.top.equalTo(cell.mas_top).offset(21);
        make.height.equalTo(@12);
    }];
    
    self.leftTitle = [[UILabel alloc]init];
    [cell addSubview:self.leftTitle];
    self.leftTitle.text = @"空调";
    self.leftTitle.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.leftTitle.font = [UIFont boldSystemFontOfSize:14];
    self.leftTitle.textAlignment = NSTextAlignmentLeft;
    [self.leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftIcon.mas_right).offset(5);
        make.centerY.equalTo(self.leftIcon.mas_centerY);
        make.height.equalTo(@21);
        make.width.equalTo(@100);
    }];
    
    self.moreBtn = [[UIButton alloc]init];
    [cell addSubview:self.moreBtn];
    [self.moreBtn addTarget:self action:@selector(moreMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBtn setTitleColor:[UIColor colorWithHexString:@"#1860B0"] forState:UIControlStateNormal];
    self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [self.moreBtn setImage:[UIImage imageNamed:@"blue_jiantou"] forState:UIControlStateNormal];
    [self.moreBtn setTitle:@"操作日志" forState:UIControlStateNormal];
    [self.moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 75, 0, 0)];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.mas_right).offset(-16);
        make.height.equalTo(@20);
        make.centerY.equalTo(self.leftTitle.mas_centerY);
        make.width.equalTo(@80);
    }];
    
    
    UIView *lineView = [[UIView alloc]init];
    [cell addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.mas_left).offset(19);
        make.right.equalTo(cell.mas_right).offset(-12);
        make.top.equalTo(self.leftTitle.mas_bottom).offset(15);
        make.height.equalTo(@0.5);
    }];
    
    self.powBtn = [[UIButton alloc]init];
    [cell addSubview:self.powBtn];
    [self.powBtn setImage:[UIImage imageNamed:@"kongtiao_powOff"] forState:UIControlStateNormal];
    [self.powBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@60);
        make.top.equalTo(lineView.mas_bottom).offset(7);
        make.right.equalTo(cell.mas_right).offset(-13);
    }];
    [self.powBtn addTarget:self action:@selector(powMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *bgImage = [[UIImageView alloc]init];
    [cell addSubview:bgImage];
    bgImage.image = [UIImage imageNamed:@"kongtiao_bgImage"];
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@194);
        make.top.equalTo(lineView.mas_bottom).offset(22);
        make.left.equalTo(cell.mas_left).offset((SCREEN_WIDTH -32 -194)/2);
    }];
    
    
    
    self.circleView = [[CircleView alloc] initWithFrame:CGRectMake(200, 100, 200, 200)];
    //进度条宽度
    self.circleView.strokelineWidth = 5;
    [cell addSubview:_circleView];
    
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@100);
        make.centerX.equalTo(bgImage.mas_centerX);
        make.centerY.equalTo(bgImage.mas_centerY);
    }];
    
    self.weatherImage  = [[UIImageView alloc]init];
    [cell addSubview:self.weatherImage];
    self.weatherImage.image = [UIImage imageNamed:@"制热icon"];
    [self.weatherImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@12);
        make.top.equalTo(bgImage.mas_top).offset(60);
        make.centerX.equalTo(bgImage.mas_centerX);
    }];
    self.tempTitle = [[UILabel alloc]init];
    self.tempTitle.text = [NSString stringWithFormat:@"%@",@"16"];
    self.tempTitle.textColor = [UIColor colorWithHexString:@"#939CB4"];
    self.tempTitle.textAlignment = NSTextAlignmentCenter;
    self.tempTitle.font = [UIFont systemFontOfSize:30 weight:UIFontWeightMedium];
    self.tempTitle.numberOfLines = 1;
    [self.tempTitle sizeToFit];
    [cell addSubview:self.tempTitle];
    [self.tempTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@42);
        
        make.top.equalTo(self.weatherImage.mas_bottom).offset(-10);
        make.centerX.equalTo(bgImage.mas_centerX);
    }];
    
    UILabel * tempUnitTitle = [[UILabel alloc]init];
    tempUnitTitle.text = [NSString stringWithFormat:@"°"];
    tempUnitTitle.textColor = [UIColor colorWithHexString:@"#939CB4"];
    tempUnitTitle.textAlignment = NSTextAlignmentLeft;
    tempUnitTitle.font = [UIFont systemFontOfSize:30 weight:UIFontWeightMedium];
    tempUnitTitle.numberOfLines = 1;
    [cell addSubview:tempUnitTitle];
    [tempUnitTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@42);
        make.width.equalTo(@100);
        make.top.equalTo(self.weatherImage.mas_bottom).offset(-10);
        make.left.equalTo(self.tempTitle.mas_right);
    }];
    
    
    
    self.tempTextTitle = [[UILabel alloc]init];
    self.tempTextTitle.text = [NSString stringWithFormat:@"制热"];
    self.tempTextTitle.textColor = [UIColor colorWithHexString:@"#C2C8D8"];
    self.tempTextTitle.textAlignment = NSTextAlignmentCenter;
    self.tempTextTitle.font = [UIFont systemFontOfSize:10];
    self.tempTextTitle.numberOfLines = 1;
    [cell addSubview:self.tempTextTitle];
    [self.tempTextTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@14);
        make.width.equalTo(@100);
        make.top.equalTo(self.tempTitle.mas_bottom).offset(-10);
        make.centerX.equalTo(bgImage.mas_centerX);
    }];
    
    
    
    
    self.modelTitle = [[UILabel alloc]init];
    self.modelTitle.text = [NSString stringWithFormat:@"模式选择:"];
    self.modelTitle.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    self.modelTitle.textAlignment = NSTextAlignmentLeft;
    self.modelTitle.font = [UIFont systemFontOfSize:14];
    self.modelTitle.numberOfLines = 1;
    [self.modelTitle sizeToFit];
    [cell addSubview:self.modelTitle];
    [self.modelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@21);
        make.top.equalTo(bgImage.mas_bottom).offset(39);
        make.left.equalTo(cell.mas_left).offset(16);
    }];
    
    self.btn1 = [[UIButton alloc]init];
    [self.btn1 setImage:[UIImage imageNamed:@"制热可选选中"] forState:UIControlStateNormal];
//    self.btn1.enabled = NO;
    [self.btn1 addTarget:self action:@selector(btn1Method) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:self.btn1];
    [self.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40);
        make.left.equalTo(self.modelTitle.mas_right).offset(4);
        make.centerY.equalTo(self.modelTitle.mas_centerY);
    }];
    
    self.btn2 = [[UIButton alloc]init];
    [cell addSubview:self.btn2];
    [self.btn2 addTarget:self action:@selector(btn2Method) forControlEvents:UIControlEventTouchUpInside];
    [self.btn2 setImage:[UIImage imageNamed:@"制冷可选未选中"] forState:UIControlStateNormal];
    [self.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40);
        make.left.equalTo(self.btn1.mas_right).offset(22);
        make.centerY.equalTo(self.modelTitle.mas_centerY);
    }];
    
    self.btn3 = [[UIButton alloc]init];
    [cell addSubview:self.btn3];
    [self.btn3 addTarget:self action:@selector(btn3Method) forControlEvents:UIControlEventTouchUpInside];
    [self.btn3 setImage:[UIImage imageNamed:@"除湿可选未选中"] forState:UIControlStateNormal];
    [self.btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40);
        make.left.equalTo(self.btn2.mas_right).offset(22);
        make.centerY.equalTo(self.modelTitle.mas_centerY);
    }];
    
    self.btn4 = [[UIButton alloc]init];
    [cell addSubview:self.btn4];
    [self.btn4 addTarget:self action:@selector(btn4Method) forControlEvents:UIControlEventTouchUpInside];
    [self.btn4 setImage:[UIImage imageNamed:@"送风可选未选中"] forState:UIControlStateNormal];
    [self.btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40);
        make.left.equalTo(self.btn3.mas_right).offset(22);
        make.centerY.equalTo(self.modelTitle.mas_centerY);
    }];
    
    self.tempSelLabel = [[UILabel alloc]init];
    [cell addSubview:self.tempSelLabel];
    self.tempSelLabel.text = @"温度选择:";
    self.tempSelLabel.font = [UIFont systemFontOfSize:14];
    self.tempSelLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    [self.tempSelLabel sizeToFit];
    [self.tempSelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.mas_left).offset(16);
        make.top.equalTo(self.modelTitle.mas_bottom).offset(39);
        make.height.equalTo(@21);
        
    }];
    
    
    
    self.confirmBtn = [[UIButton alloc]init];
    [cell addSubview:self.confirmBtn];
    [self.confirmBtn setTitle:@"确认操作" forState:UIControlStateNormal];
    [self.confirmBtn setBackgroundColor:[UIColor colorWithHexString:@"#F3F5F9"]];
    self.confirmBtn.titleLabel.font =[UIFont systemFontOfSize:14];
    [self.confirmBtn setTitleColor:[UIColor colorWithHexString:@"#C2CDDE"] forState:UIControlStateNormal];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.mas_left).offset(20);
        make.right.equalTo(cell.mas_right).offset(-21);
        make.height.equalTo(@37);
        make.bottom.equalTo(cell.mas_bottom).offset(-18);
    }];
    [self.confirmBtn addTarget:self action:@selector(confirmMethod:) forControlEvents:UIControlEventTouchUpInside];
    self.umberSlider = [[BAUISlider alloc] initWithFrame:CGRectMake(50, 100, self.view.frame.size.width-100, 30)];
    self.umberSlider.titleStyle = TopTitleStyle;
    self.umberSlider.isShowTitle = YES;
    //设置最大和最小值
    self.umberSlider.minimumValue = 0;
    self.umberSlider.maximumValue = 100;
    self.umberSlider.maximumTrackTintColor = [UIColor colorWithHexString:@"#F0F0F3"];//设置滑块线条的颜色（右边）,默认是灰色
    self.umberSlider.thumbTintColor = [UIColor colorWithHexString:@"#C8CFE1"];///设置滑块按钮的颜色
    [cell addSubview:self.umberSlider];
    self.umberSlider.valueChange = ^(int value) {
        self.tempTitle.text = [NSString stringWithFormat:@"%d",value];
        self.temValue = value;
    };
    [self.umberSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tempSelLabel.mas_right).offset(5);
        make.height.equalTo(@55);
        make.centerY.equalTo(self.tempSelLabel.mas_centerY);
        make.right.equalTo(cell.mas_right).offset(-31);
    }];
    return cell;
}


@end
