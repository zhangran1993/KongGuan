//
//  KG_NewScreenViewController.m
//  Frame
//
//  Created by zhangran on 2020/8/18.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_HistoryWarnEventScreenViewController.h"
#import "KG_HistoryWarnEventScreenCell.h"
#import "KG_WeiHuCardAlertHeaderView.h"
#import "KG_NewScreenSelTimeCell.h"
#import "KG_NewScreenHeaderView.h"
#import "ZRDatePickerView.h"
@interface KG_HistoryWarnEventScreenViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,ZRDatePickerViewDelegate>


//
@property (nonatomic,strong)UICollectionView *collectionView;

/** 数组 */
@property(nonatomic , strong) NSMutableArray *dataArray;

@property (nonatomic, strong) ZRDatePickerView *dataPickerview;

@property (nonatomic, strong)  UILabel   *titleLabel;
@property (nonatomic, strong)  UIView    *navigationView;
@property (nonatomic, strong)  UIButton  *rightButton;

//机房
@property(nonatomic , strong) NSArray *roomArray;

//设备类型
@property(nonatomic , strong) NSArray *equipTypeArray;

//告警等级
@property(nonatomic , strong) NSArray *alarmLevelArray;

//告警状态
@property(nonatomic , strong) NSArray *alarmStatusArray;


@property(strong,nonatomic)   NSArray              *guideListArray;



@property (nonatomic,assign)   int currIndex;

@property (nonatomic,assign)   BOOL isKongGuanDevice;
@end

@implementation KG_HistoryWarnEventScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currIndex = 0;
    self.isKongGuanDevice = NO;
    [self createNaviTopView];
    [self initCollevtionView];
    [self createBottomView];
    [self initViewData];
    [self queryEquipTypeData];
    [self queryRoomData];
    [self getOperationGuideTypeList];
    [self.collectionView reloadData];
}

-(void)initViewData {
    
    self.alarmLevelArray = [NSArray arrayWithObjects:@"紧急",@"重要",@"次要",@"提示", nil];
    self.alarmStatusArray = [NSArray arrayWithObjects:@"未确认",@"已确认",@"已解决",@"已解除",@"已挂起", nil];
    [self.collectionView reloadData];
    
}
//初始化collectionview
- (void)initCollevtionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 12;
    flowLayout.minimumInteritemSpacing = 2;
    flowLayout.sectionInset = UIEdgeInsetsMake(5.0, 16.0, 5.0, 16.0);
    flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 50);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-70-Height_BottomBar);
    }];
    [self.collectionView registerClass:[KG_WeiHuCardAlertHeaderView class]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"KG_WeiHuCardAlertHeaderView"];
    [self.collectionView registerClass:[KG_HistoryWarnEventScreenCell class] forCellWithReuseIdentifier:@"KG_HistoryWarnEventScreenCell"];
    [self.collectionView registerClass:[KG_NewScreenHeaderView class]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"KG_NewScreenHeaderView"];
//    [self.collectionView registerClass:[KG_NewScreenSelTimeCell class] forCellWithReuseIdentifier:@"KG_NewScreenSelTimeCell"];
    
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.scrollEnabled = YES;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    
}
#pragma mark ---- collectionView 数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0) {
        return self.roomArray.count;
    }else if (section == 1) {
        return self.equipTypeArray.count;
    }else if (section == 2) {
        return self.guideListArray.count;
    }else if (section == 3) {
        return self.alarmLevelArray.count;
    }else if (section == 4) {
        return self.alarmStatusArray.count;
    }else if (section == 5) {
        return 0;
    }else if (section == 6) {
        return 0;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 7;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.collectionView) {
       
        KG_HistoryWarnEventScreenCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KG_HistoryWarnEventScreenCell" forIndexPath:indexPath];
        
        cell.roomStr = self.roomStr;
        cell.equipTypeStr = self.equipTypeStr;
        cell.alarmStatusStr = self.alarmStatusStr;
        cell.alarmLevelStr = self.alarmLevelStr;
        cell.kongguanDeviceStr = self.kongguanTypeStr;
        cell.btn.alpha = 1;
        if (indexPath.section == 0) {
            NSDictionary *dataDic = self.roomArray[indexPath.row];
            cell.roomDic = dataDic;
        }else if (indexPath.section == 1) {
            NSDictionary *dataDic = self.equipTypeArray[indexPath.row];
            cell.dataDic = dataDic;
        }else if (indexPath.section == 2) {
            NSDictionary *dataDic = self.guideListArray[indexPath.row];
            if (self.isKongGuanDevice) {
                cell.btn.alpha = 1;
            }else {
                cell.btn.alpha = 0.39;
                
            }
            cell.kongguanDic = dataDic;
        }else if (indexPath.section == 3) {
            NSString *str = self.alarmLevelArray[indexPath.row];
            cell.str = str;
        }else if (indexPath.section == 4) {
            NSString *str = self.alarmStatusArray[indexPath.row];
            cell.str = str;
        }
        
        [cell.btn addTarget:self action:@selector(onTouchBtnInCell:) forControlEvents:(UIControlEventTouchUpInside)];
        
        
        return cell;
    }
    return nil;
    
    
}

#pragma mark  定义每个UICollectionViewCell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 5 || indexPath.section == 6) {
        
        return CGSizeMake(SCREEN_WIDTH, 60);
    }
    return  CGSizeMake(80,38);
    
}

#pragma mark - collectionView代理方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ldsection-===-----------",(long)indexPath.section);
    NSLog(@"%ldrow====-----------",(long)indexPath.row);
    
}
/**  数组  */
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)createNaviTopView {
    
    UIImageView *topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT +44)];
    [self.view addSubview:topImage1];
    topImage1.backgroundColor  =[UIColor whiteColor];
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 44)];
    [self.view addSubview:topImage];
    topImage.backgroundColor  =[UIColor whiteColor];
    topImage.image = [self createImageWithColor:[UIColor whiteColor]];
    /** 导航栏 **/
    self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_NavBar)];
    self.navigationView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.navigationView];
    
    /** 添加标题栏 **/
    [self.navigationView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navigationView.mas_centerX);
        make.top.equalTo(self.navigationView.mas_top).offset(Height_StatusBar+9);
    }];
    self.titleLabel.text = @"筛选";
    
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
    leftImage.image = IMAGE(@"back_black");
    [backBtn addSubview:leftImage];
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backBtn.mas_centerX);
        make.centerY.equalTo(backBtn.mas_centerY);
    }];
    
}
- (void)backButtonClick:(UIButton *)button {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
/** 标题栏 **/
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (void)createBottomView {
    
    UIView *bottomView = [[UIView alloc]init];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-Height_BottomBar);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@70);
    }];
    
    
    UIView *lineView = [[UIView alloc]init];
    [bottomView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@10);
        make.left.equalTo(bottomView.mas_left);
        make.right.equalTo(bottomView.mas_right);
        make.top.equalTo(bottomView.mas_top);
    }];
    
    
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    [bottomView addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#2F5ED1"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    cancelBtn.layer.cornerRadius =4 ;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.borderColor = [[UIColor colorWithHexString:@"#2F5ED1"] CGColor];
    cancelBtn.layer.borderWidth = 1;
    [cancelBtn setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    [cancelBtn addTarget:self action:@selector(cancelMethod:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).offset(16);
        make.top.equalTo(lineView.mas_bottom).offset(10);
        make.width.equalTo(@(SCREEN_WIDTH/2-5-16));
        make.height.equalTo(@40);
    }];
    
    
    UIButton *confirmBtn = [[UIButton alloc]init];
    [bottomView addSubview:confirmBtn];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    confirmBtn.layer.cornerRadius =4 ;
    confirmBtn.layer.masksToBounds = YES;
    
    [confirmBtn addTarget:self action:@selector(confirmMethod:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView.mas_right).offset(-16);
        make.top.equalTo(lineView.mas_bottom).offset(10);
        make.width.equalTo(@(SCREEN_WIDTH/2-5-16));
        make.height.equalTo(@40);
    }];
    
    
}

//取消
- (void)cancelMethod:(UIButton *)button {
    
     [self.navigationController popViewControllerAnimated:YES];
}

//确认
- (void)confirmMethod:(UIButton *)button {
    if (self.confirmBlockMethod) {
        self.confirmBlockMethod(safeString(self.roomStr), safeString(self.equipTypeStr), safeString(self.kongguanTypeStr), safeString(self.alarmLevelStr), safeString(self.alarmStatusStr), safeString(self.startTime), safeString(self.endTime),self.roomArray,self.guideListArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 5 || indexPath.section == 6) {
            KG_NewScreenHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"KG_NewScreenHeaderView" forIndexPath:indexPath];
            if (indexPath.section == 5) {
                [headerView.rightBtn addTarget:self action:@selector(selStartTimeMethod:) forControlEvents:UIControlEventTouchUpInside];
                if (self.startTime.length == 0) {
                    headerView.promptLabel.text = @"请选择";
                }else {
                    headerView.promptLabel.text = safeString(self.startTime);
                }
            }else {
                [headerView.rightBtn addTarget:self action:@selector(selEndTimeMethod:) forControlEvents:UIControlEventTouchUpInside];
                if (self.endTime.length == 0) {
                    headerView.promptLabel.text = @"请选择";
                }else {
                    headerView.promptLabel.text = safeString(self.endTime);
                }
            }
            
            return headerView;
        }
        KG_WeiHuCardAlertHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"KG_WeiHuCardAlertHeaderView" forIndexPath:indexPath];
        headerView.titleLabel.alpha = 1;
        if (indexPath.section == 0) {
            headerView.titleLabel.text = @"机房";
        }else if (indexPath.section == 1) {
            headerView.titleLabel.text = @"设备类型";
        }else if (indexPath.section == 2) {
            headerView.titleLabel.text = @"空管设备";
            if (self.isKongGuanDevice) {
                headerView.titleLabel.alpha = 1;
            }else {
                
                headerView.titleLabel.alpha = 0.31;
               
            }
        }else if (indexPath.section == 3) {
            headerView.titleLabel.text = @"告警等级";
        }else if (indexPath.section == 4) {
            headerView.titleLabel.text = @"告警状态";
        }
        headerView.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        return headerView;
    }
    return nil;
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

//获取设备类型列表
- (void)queryEquipTypeData {
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcDictionary?type_code=equipmentGroup"]];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            
            return ;
        }
        self.equipTypeArray = result[@"value"];
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask *error)  {
        [MBProgressHUD hideHUD];
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
            [FrameBaseRequest logout];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
        //        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
    
}
//
//获取某个台站下的机房列表：
//请求地址：/intelligent/atcStation/engineRoomList/{stationCode}
//          其中，stationCode是台站编码

//获取设备类型列表
- (void)queryRoomData {
    
    NSDictionary *currentDic = [UserManager shareUserManager].currentStationDic;
    if (currentDic.count == 0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if([userDefaults objectForKey:@"station"]){
            currentDic = [userDefaults objectForKey:@"station"];
        }else {
            NSArray *stationArr = [UserManager shareUserManager].stationList;
            
            if (stationArr.count >0) {
                currentDic = [stationArr firstObject][@"station"];
            }
        }
    }
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcStation/engineRoomList/%@",safeString(currentDic[@"code"])]];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            
            return ;
        }
        self.roomArray = result[@"value"];
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask *error)  {
        [MBProgressHUD hideHUD];
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
            [FrameBaseRequest logout];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
        //        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
    
}
- (void)onTouchBtnInCell:(UIButton *)sender {
    
    CGPoint point = sender.center;
    
    point = [self.collectionView convertPoint:point fromView:sender.superview];
    
    NSIndexPath* indexpath = [self.collectionView indexPathForItemAtPoint:point];
    
    NSLog(@"%ld",(long)indexpath.row);
    NSLog(@"%ld",(long)indexpath.section);
    if (indexpath.section == 0) {
        if (self.roomStr.length >0 && [self.roomStr isEqualToString:safeString(self.roomArray[indexpath.row][@"alias"])]) {
            self.roomStr = @"";
        }else {
             self.roomStr = safeString(self.roomArray[indexpath.row][@"alias"]);
        }
       
    }else if (indexpath.section == 1) {
        if (self.equipTypeStr.length >0 && [self.equipTypeStr isEqualToString:safeString(self.equipTypeArray[indexpath.row][@"name"])]) {
            self.equipTypeStr = @"";
        }else {
            self.equipTypeStr = safeString(self.equipTypeArray[indexpath.row][@"name"]);
        }
        if ([self.equipTypeStr isEqualToString:@"设备"]) {
            self.isKongGuanDevice = YES;
        }else {
            self.isKongGuanDevice = NO;
        }
        
    }else if (indexpath.section == 2) {
        if (self.kongguanTypeStr.length >0 && [self.kongguanTypeStr isEqualToString:safeString(self.guideListArray[indexpath.row][@"name"])]) {
            self.kongguanTypeStr = @"";
        }else {
            self.kongguanTypeStr = safeString(self.guideListArray[indexpath.row][@"name"]);
        }
    }else if (indexpath.section == 3) {
        if (self.alarmLevelStr.length >0 && [self.alarmLevelStr isEqualToString:safeString(self.alarmLevelArray[indexpath.row])]) {
            self.alarmLevelStr = @"";
        }else {
            self.alarmLevelStr = self.alarmLevelArray[indexpath.row];
        }
    }else if (indexpath.section == 4) {
        if (self.alarmStatusStr.length >0 && [self.alarmStatusStr isEqualToString:safeString(self.alarmStatusArray[indexpath.row])]) {
            self.alarmStatusStr = @"";
        }else {
            self.alarmStatusStr = self.alarmStatusArray[indexpath.row];
        }
    }
    
    [self.collectionView reloadData];
    
}
- (ZRDatePickerView *)dataPickerview
{
    if (!_dataPickerview) {
        _dataPickerview = [[ZRDatePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300) withDatePickerType:ZRDatePickerTypeYMDHMS];
        _dataPickerview.delegate = self;
        _dataPickerview.title = @"请选择时间";
        _dataPickerview.isSlide = NO;
        _dataPickerview.toolBackColor = [UIColor colorWithHexString:@"#F7F7F7"];
        _dataPickerview.toolTitleColor = [UIColor colorWithHexString:@"#555555"];
        _dataPickerview.saveTitleColor = [UIColor colorWithHexString:@"#EA3425"];
        _dataPickerview.cancleTitleColor = [UIColor colorWithHexString:@"#EA3425"];
        
        [self.view addSubview:_dataPickerview];
        
    }
    return _dataPickerview;
}
- (void)datePickerViewSaveBtnClickDelegate:(NSString *)timer {
    
    if (self.currIndex == 0) {
        self.startTime = timer;
    }else {
        
        self.endTime = timer;
    }
    [self.collectionView reloadData];
    
//    NSMutableDictionary *ddic = [[NSMutableDictionary alloc]initWithDictionary:self.dataDic];
    
//    [ddic setValue:self.startTime forKey:@"time"];
    [self.collectionView reloadData];

    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerview.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
        
        [self.dataPickerview show];
    }];
    
}
/**
 取消按钮代理方法
 */
- (void)datePickerViewCancelBtnClickDelegate {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerview.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
        [self.dataPickerview show];
    }];
}
- (void)selEndTimeMethod:(UIButton *)btn{
    self.currIndex = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerview.frame = CGRectMake(0,  self.view.frame.size.height-300, self.view.frame.size.width, 300);
        [self.dataPickerview show];
    }];
}
- (void)selStartTimeMethod:(UIButton *)btn{
    self.currIndex = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerview.frame = CGRectMake(0,  self.view.frame.size.height-300, self.view.frame.size.width, 300);
        [self.dataPickerview show];
    }];
}


//请求地址：/intelligent/atcDictionary?type_code=equipmentCategory
//请求方式：GET
//请求返回：

- (void)getOperationGuideTypeList {
    
    NSString *FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcDictionary?type_code=equipmentCategory"]];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            
            return ;
        }
        
        
        
        self.guideListArray = result[@"value"];
        
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask *error)  {
        [MBProgressHUD hideHUD];
        FrameLog(@"请求失败，返回数据 : %@",error);
        
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
            [FrameBaseRequest logout];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
        //        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
    
}
@end
