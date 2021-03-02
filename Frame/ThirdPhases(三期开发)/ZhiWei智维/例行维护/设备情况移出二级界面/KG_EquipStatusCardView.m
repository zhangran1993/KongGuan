//
//  KG_EquipCardViewController.m
//  Frame
//
//  Created by zhangran on 2020/6/16.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_EquipStatusCardView.h"
#import "KG_EquipCardCell.h"
#import "KG_WeiHuCardAlertView.h"
#import "KG_OperationGuideViewController.h"
@interface KG_EquipStatusCardView ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>


@property (nonatomic, strong)  UILabel   *titleLabel;
@property (nonatomic, strong)  UIView    *navigationView;
@property (nonatomic, strong)  UIButton  *rightButton;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong)  UIView    *headView;

@property (nonatomic, strong)  UIScrollView  *scrollView;
@property (nonatomic, strong) KG_WeiHuCardAlertView *alertView;

@property (nonatomic, strong)  UIButton  *leftBtn;
@property (nonatomic, strong)  UIButton  *rightBtn;
@property (nonatomic, assign)  NSInteger selIndex;
@property (nonatomic, assign)  NSInteger selDetailIndex;

@property (nonatomic, strong)  NSDictionary * curSelDic;
@property (nonatomic, strong)  NSDictionary * curSelDetailDic;

@property (nonatomic, strong) UIView         *sliderBgView;
@property (nonatomic, strong) UIView         *sliderView;
@property (nonatomic, assign) int       cardHeight ;

@end

@implementation KG_EquipStatusCardView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCardHeight:) name:@"refreshCardHeight" object:nil];
        [self createUI];
//        [self createNaviTopView];
        // Do any additional setup after loading the view.
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.selIndex = 0;
        [UserManager shareUserManager].resultDic = nil;
        self.selDetailIndex = 0;
        [self createScrollView];
        
    }
    return self;
}

- (void)createUI {
    
    
}
- (void)createScrollView {
    
    
}

- (void)createNaviTopView {
    
    UIImageView *topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT +44)];
    [self addSubview:topImage1];
    topImage1.backgroundColor  =[UIColor whiteColor];
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 44)];
    [self addSubview:topImage];
    topImage.backgroundColor  =[UIColor whiteColor];
    topImage.image = [UIImage imageNamed:@"zhiyun_bgImage"];
    /** 导航栏 **/
    self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_NavBar)];
    self.navigationView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.navigationView];
    
    /** 添加标题栏 **/
    [self.navigationView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navigationView.mas_centerX);
        make.top.equalTo(self.navigationView.mas_top).offset(Height_StatusBar+9);
    }];
    self.titleLabel.text = @"设备情况";
    
    /** 返回按钮 **/
    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, (Height_NavBar -44)/2, 44, 44)];
    [backBtn addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.left.equalTo(self.navigationView.mas_left);
    }];
    
    //按钮设置点击范围扩大.实际显示区域为图片的区域
    UIImageView *leftImage = [[UIImageView alloc] init];
    leftImage.image = IMAGE(@"backwhite");
    [backBtn addSubview:leftImage];
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backBtn.mas_centerX);
        make.centerY.equalTo(backBtn.mas_centerY);
    }];
  
}


- (void)backButtonClick:(UIButton *)button {
   
//    if ([UserManager shareUserManager].isChangeTask && [UserManager shareUserManager].changeEquipStatus ) {
//
//        UIAlertController *alertContor = [UIAlertController alertControllerWithTitle:@"您确定要保存吗" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//        [alertContor addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
////             [self.navigationController popViewControllerAnimated:YES];
////            [UserManager shareUserManager].changeEquipStatus = NO;
////            [UserManager shareUserManager].resultCardDic = nil;
////            return ;
//        }]];
//        [alertContor addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//            [self changeTask];
//            [UserManager shareUserManager].changeEquipStatus = NO;
//            return ;
//        }]];
//        [self presentViewController:alertContor animated:NO completion:nil];
//    }else {
////        [self.navigationController popViewControllerAnimated:YES];
//    }

    
     
    
    
}
- (void)changeTask {
    NSString *leadStr = @"";
    NSString *patrolName = safeString(self.dataModel.patrolName);
    NSArray *leadArr = [UserManager shareUserManager].leaderNameArray;
    
    for (NSDictionary *dic in leadArr) {
        if ([safeString(dic[@"id"]) isEqualToString:patrolName]) {
            leadStr = safeString(dic[@"name"]);
            break;
        }
    }
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if ([userdefaults objectForKey:@"name"]) {
        NSString *userName = [userdefaults objectForKey:@"name"];
        if (![safeString(self.dataDic[@"leaderName"]) isEqualToString:userName]) {
            [FrameBaseRequest showMessage:@"您没有修改任务的权限"];
            return;
        }
    }
    
    
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/atcSafeguard/updateAtcPatrolRecode",WebNewHost];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    
    paramDic[@"id"] = safeString(self.dataDic[@"id"]);
    NSDictionary *resultDic = [UserManager shareUserManager].resultDic;
    paramDic[@"result"] = [self convertToJsonData:resultDic];
    paramDic[@"status"] = @"1";
    paramDic[@"description"] = @"";
    NSDictionary *remarkDic = [NSDictionary dictionary];
    if (isSafeDictionary(self.dataDic[@"remark"])) {
        if ([self.dataDic[@"remark"] count]) {
            paramDic[@"remark"] = [self convertToJsonData:self.dataDic[@"remark"]];
        }else {
            paramDic[@"remark"] =[self convertToJsonData:remarkDic] ;
        }
    }else {
        paramDic[@"remark"] = [self convertToJsonData:remarkDic];
    }
    
    
    paramDic[@"patrolName"] = safeString(self.dataDic[@"patrolName"]);
    //
    NSMutableArray *labelList = [NSMutableArray arrayWithCapacity:0];
    //    NSMutableDictionary *labelDic = [NSMutableDictionary dictionary];
    //    [labelDic setValue:@"DVOR" forKey:@"name"];
    //    [labelList addObject:labelDic];
    if (isSafeArray(self.dataDic[@"atcPatrolLabelList"])) {
        if ([self.dataDic[@"atcPatrolLabelList"] count]) {
            paramDic[@"atcPatrolLabelList"] = self.dataDic[@"atcPatrolLabelList"];
        }else {
            paramDic[@"atcPatrolLabelList"] = labelList;
        }
        
    }else {
        paramDic[@"atcPatrolLabelList"] = labelList;
        
    }
    
    
    NSMutableArray *workList = [NSMutableArray arrayWithCapacity:0];
    //    NSMutableDictionary *workDic = [NSMutableDictionary dictionary];
    //    [workDic setValue:@"1d13c2dc-fb3a-441f-976d-7a7537018245" forKey:@"workPersonName"];
    //    [workList addObject:workDic];
    if (isSafeArray(self.dataDic[@"atcPatrolWorkList"])) {
        if ([self.dataDic[@"atcPatrolWorkList"] count]) {
            paramDic[@"atcPatrolWorkList"] = self.dataDic[@"atcPatrolWorkList"];
        }else {
            paramDic[@"atcPatrolWorkList"] = workList;
        }
    }else {
        paramDic[@"atcPatrolWorkList"] = workList;
    }
    
    
    
    
    [FrameBaseRequest postWithUrl:FrameRequestURL param:paramDic success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        [FrameBaseRequest showMessage:@"保存任务成功"];
        if(self.saveSuccessBlock) {
            self.saveSuccessBlock();
        }
        
        [UserManager shareUserManager].resultDic = nil;
//        [self.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
    
}
/** 标题栏 **/
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        titleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}


- (void)createView {
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(44);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    self.tableView.layer.cornerRadius = 6;
    self.tableView.layer.masksToBounds = YES;
    [self.tableView reloadData];
    
    
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 56)];
    self.tableView.tableHeaderView = self.headView;
    
    
    UIView *bgView = [[UIView alloc] init];
   
    bgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    bgView.layer.borderWidth = 0.5;
    bgView.layer.borderColor = [UIColor colorWithRed:239/255.0 green:240/255.0 blue:247/255.0 alpha:1.0].CGColor;
    bgView.layer.cornerRadius = 6;
    [self.headView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headView.mas_centerY);
        make.left.equalTo(self.headView.mas_left).offset(16);
        make.right.equalTo(self.headView.mas_right).offset(-16);
        make.height.equalTo(self.headView.mas_height);
    }];
    
    UIImageView *iconImage = [[UIImageView alloc]init];
    [self.headView addSubview:iconImage];
    iconImage.backgroundColor = [UIColor colorWithHexString:@"#BABCC4"];
    iconImage.layer.cornerRadius =2.5f;
    iconImage.layer.masksToBounds = YES;
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headView.mas_centerY);
        make.left.equalTo(self.headView.mas_left).offset(32);
        make.width.height.equalTo(@5);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [self.headView addSubview:titleLabel];
    titleLabel.text = @"系统和设备情况";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.numberOfLines = 1;
    [titleLabel sizeToFit];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImage.mas_right).offset(4);
        make.centerY.equalTo(iconImage.mas_centerY);
        make.height.equalTo(@24);
        make.width.equalTo(@100);
    }];
    
   
    for (NSDictionary *dic in self.listArray) {
        
    }
   
    self.leftBtn = [[UIButton alloc]init];
    [self.headView addSubview:self.leftBtn];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"equip_buttonBgImage"] forState:UIControlStateNormal];
    self.leftBtn.contentMode = UIViewContentModeScaleAspectFill;
    [self.leftBtn setTitleColor:[UIColor colorWithHexString:@"#626470"] forState:UIControlStateNormal];
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.leftBtn sizeToFit];
    [self.leftBtn addTarget:self action:@selector(showAlertView) forControlEvents:UIControlEventTouchUpInside];
    [self.leftBtn.titleLabel setNumberOfLines:2];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(6);
        
        make.width.equalTo(@100);
        make.centerY.equalTo(titleLabel.mas_centerY);
    }];
    
    
    self.rightBtn = [[UIButton alloc]init];
    [self.headView addSubview:self.rightBtn];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"equip_buttonBgImage"] forState:UIControlStateNormal];
    self.rightBtn.contentMode = UIViewContentModeScaleAspectFill;
    [self.rightBtn setTitleColor:[UIColor colorWithHexString:@"#626470"] forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.rightBtn sizeToFit];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftBtn.mas_right).offset(5);
        make.right.equalTo(self.headView.mas_right).offset(-24);
        make.centerY.equalTo(titleLabel.mas_centerY);
    }];
     [self.rightBtn.titleLabel setNumberOfLines:2];
    [self.rightBtn addTarget:self action:@selector(showAlertView) forControlEvents:UIControlEventTouchUpInside];
    if(self.listArray.count == 0){
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = YES;
    }else if(self.listArray.count > 0){
        NSDictionary *dic = self.listArray[self.selIndex];
        [self.leftBtn setTitle:safeString(dic[@"systemName"]) forState:UIControlStateNormal];
        self.leftBtn.hidden = NO;
        if (dic.count) {
            NSArray *arr = dic[@"equipmentList"];
            if (arr.count >0) {
                NSDictionary *detailDic = arr[self.selDetailIndex];
                self.rightBtn.hidden = NO;
                [self.rightBtn setTitle:safeString(detailDic[@"equipmentName"]) forState:UIControlStateNormal];
            }else {
                self.rightBtn.hidden = YES;
            }
        }
//
//    }else if(self.listArray.count == 2){
//        NSDictionary *dic = [self.listArray firstObject];
//        NSDictionary *dic1 = [self.listArray lastObject];
//        [self.leftBtn setTitle:safeString(dic[@"systemName"]) forState:UIControlStateNormal];
//
//
//
    }
    
}
//弹出
- (void)showAlertView{
    [_alertView removeFromSuperview];
    _alertView = nil;
    if (_alertView == nil) {
        [JSHmainWindow addSubview:self.alertView];
        
        if (self.curSelDic.count) {
            self.alertView.curSelDic = self.curSelDic;
        }
        if (self.curSelDetailDic.count) {
            self.alertView.curSelDetailDic = self.curSelDetailDic;
        }
        self.alertView.dataArray = self.listArray;
        
        self.alertView.buttonBlockMethod = ^(NSDictionary * _Nonnull dataDic, NSDictionary * _Nonnull detailDic) {
            NSLog(@"%@----%@",dataDic,detailDic);
            if (dataDic.count) {
                self.curSelDic = dataDic;
                [self.leftBtn setTitle:safeString(dataDic[@"systemName"]) forState:UIControlStateNormal];
            }
            if (detailDic.count) {
                self.curSelDetailDic = detailDic;
                [self.rightBtn setTitle:safeString(detailDic[@"equipmentName"]) forState:UIControlStateNormal];
            }
            
            [self.tableView reloadData];
            
        };
        [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo([UIApplication sharedApplication].keyWindow.mas_left);
            make.right.equalTo([UIApplication sharedApplication].keyWindow.mas_right);
            make.top.equalTo([UIApplication sharedApplication].keyWindow.mas_top);
            make.bottom.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom);
        }];
    }else {
        self.alertView.hidden = NO;
    }
    
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
      
    }
    return _tableView;
}
- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (self.cardHeight >0) {
        return self.cardHeight;
    }
    return SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_EquipCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_EquipCardCell"];
    if (cell == nil) {
        cell = [[KG_EquipCardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_EquipCardCell"];
        cell.moreBlockMethod = ^(NSDictionary * _Nonnull dataDic) {
            if (self.moreBlockMethod) {
                self.moreBlockMethod(dataDic);
            }
           
        };
        cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.curSelDic.count) {
        cell.curSelDic = self.curSelDic;
    }
    if (self.curSelDetailDic.count) {
        cell.curSelDetialDic = self.curSelDetailDic;
    }
    cell.listArray = self.listArray;
    cell.dataModel = self.dataModel;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
}

- (KG_WeiHuCardAlertView *)alertView {
    if (!_alertView) {
        _alertView = [[KG_WeiHuCardAlertView alloc]init];
        
    }
    return _alertView;
}
//sliderview
- (void)createSliderView {
    
    self.sliderBgView = [[UIView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT-200, SCREEN_WIDTH, 26)];
    [self addSubview:self.sliderBgView];
    self.sliderBgView.backgroundColor = self.backgroundColor;
    
    float sliderV_X = SCREEN_WIDTH/2;
    float sliderVX =  sliderV_X;
    UIView *sliderV=[[UIView alloc]initWithFrame:CGRectMake(sliderVX, 10, 6, 6)];
    
    sliderV.layer.cornerRadius = 3;
    sliderV.backgroundColor = [UIColor colorWithHexString:@"#005DC4"];
    [self.sliderBgView insertSubview:sliderV atIndex:1];
    _sliderView=sliderV;
    for (int i = 0; i <self.dataArray.count; i++) {
        //滑块
        float sliderV_X =SCREEN_WIDTH /2+ i*10;
        //float sliderVX = WIDTH_SCREEN - FrameWidth(sliderV_X);
        
        float sliderX = sliderV_X;//WIDTH_SCREEN - FrameWidth(i*18+30);
        UIView *sliderV=[[UIView alloc]initWithFrame:CGRectMake(sliderX,  10, 6, 6)];
        sliderV.layer.cornerRadius = 3;
        sliderV.alpha= 0.19;
        sliderV.backgroundColor = [UIColor colorWithHexString:@"#005DC4"];
        [self.sliderBgView insertSubview:sliderV atIndex:0];
        
    }
}
#pragma mark ----  字典转Json字符串
-(NSString *)convertToJsonData:(NSDictionary *)dict

{
    if (dict.count ==0) {
        return @"";
    }
    NSError *error;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];

    NSString *jsonString;

    if (!jsonData) {



    }else{

        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

    NSRange range = {0,jsonString.length};

    //去掉字符串中的空格

    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];

    NSRange range2 = {0,mutStr.length};

    //去掉字符串中的换行符

    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

    return mutStr;

}
- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic =dataDic;
    
}

- (void)setDataModel:(KG_XunShiReportDetailModel *)dataModel {
    _dataModel = dataModel;
   
    [self createView];
}

- (void)setListArray:(NSArray *)listArray {
    _listArray = listArray;
    
   
    
}
//实现方法
-(void)refreshCardHeight:(NSNotification *)notification{
    NSLog(@"接收 不带参数的消息");
   
    self.cardHeight = [notification.object intValue];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}
@end
