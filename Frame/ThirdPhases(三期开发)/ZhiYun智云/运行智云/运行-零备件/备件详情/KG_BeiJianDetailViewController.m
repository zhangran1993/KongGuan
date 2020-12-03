//
//  KG_BeiJianCategoryViewController.m
//  Frame
//
//  Created by zhangran on 2020/7/31.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_BeiJianDetailViewController.h"
#import "KG_BeiJianCategoryCell.h"
#import "KG_BeiJianDetailFirstCell.h"
#import "KG_BeiJianDetailSecondCell.h"
#import "KG_BeiJianDetailThirdCell.h"
#import "KG_BeiJianDetaiFourthCell.h"
@interface KG_BeiJianDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    
}

@property (nonatomic,strong)    UITableView             *tableView;

@property (nonatomic,strong)    NSMutableArray          *dataArray;

@property (nonatomic, strong)   UILabel                 *titleLabel;

@property (nonatomic, strong)   UIView                  *navigationView;

@property (nonatomic, strong)   UIImageView             *navigationBgImageView;

@property (nonatomic, strong)   NSDictionary            *currentDic;

@property (nonatomic, copy)     NSString                *categoryString;

@property (nonatomic, copy)     NSString                *descriptionStr;

@property (nonatomic, strong)   NSArray                 *lvliArr;

@property (nonatomic, strong)   UIImageView             *leftImage;



@end

@implementation KG_BeiJianDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];

    [self createUI];
    
    [self createNaviTopView];
    
    [self queryData];
    if (self.totalDic.count) {
        self.categoryString = safeString(self.totalDic[@"attachmentTypeName"]);
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)dealloc
{
    //第一种方法.这里可以移除该控制器下的所有通知
    //移除当前所有通知
    NSLog(@"移除了所有的通知");
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    //第二种方法.这里可以移除该控制器下名称为tongzhi的通知
    //移除名称为tongzhi的那个通知
    NSLog(@"移除了名称为tongzhi的通知");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tongzhi" object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillAppear");
    if (@available(iOS 13.0, *)){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    }else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self.navigationController setNavigationBarHidden:YES];
    if([ self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        
        if(@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
        }else{
            
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    
    
}
/**
 *  键盘将要显示
 *
 *  @param notification 通知
 */
-(void)keyboardWillShow:(NSNotification *)notification
{
//这样就拿到了键盘的位置大小信息frame，然后根据frame进行高度处理之类的信息
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat endHeight = self.tableView.contentSize.height + frame.size.height;
    self.tableView.contentSize = CGSizeMake(0, endHeight);
    self.tableView.contentOffset = CGPointMake(0,frame.size.height);
}

/**
 *  键盘将要隐藏
 *
 *  @param notification 通知
 */
-(void)keyboardWillHidden:(NSNotification *)notification
{
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat endHeight = self.tableView.contentSize.height - frame.size.height;
    self.tableView.contentSize = CGSizeMake(0, endHeight);
}
- (void)createNaviTopView {
    
//    UIImageView *topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT +44)];
//    [self.view addSubview:topImage1];
//    topImage1.backgroundColor  =[UIColor whiteColor];
//    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 208)];
//    [self.view addSubview:topImage];
//    topImage.backgroundColor  =[UIColor colorWithHexString:@"#F6F7F9"];
//    topImage.image = [UIImage imageNamed:@"beijian_bgImage"];
    /** 导航栏 **/
    self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_NavBar)];
    
    self.navigationView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.navigationView];
    
    self.navigationBgImageView = [[UIImageView alloc]init];
    [self.navigationView addSubview:self.navigationBgImageView];
    self.navigationBgImageView.backgroundColor = [UIColor clearColor];
    
    [self.navigationBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navigationView.mas_left);
        make.right.equalTo(self.navigationView.mas_right);
        make.top.equalTo(self.navigationView.mas_top);
        make.bottom.equalTo(self.navigationView.mas_bottom);
    }];
   
    /** 添加标题栏 **/
    [self.navigationView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navigationView.mas_centerX);
        make.top.equalTo(self.navigationView.mas_top).offset(Height_StatusBar+9);
    }];
    self.titleLabel.text = @"备件详情";
    
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
    self.leftImage = [[UIImageView alloc] init];
    self.leftImage.image = IMAGE(@"backwhite");
    [backBtn addSubview:self.leftImage];
    [self.leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
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
        titleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
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
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.layer.cornerRadius = 10.f;
//        _tableView.layer.masksToBounds = YES;
        _tableView.scrollEnabled = YES;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return  250 +NAVIGATIONBAR_HEIGHT +10;
    }else if (indexPath.section == 1) {
        return  250;
    }else if (indexPath.section == 2) {
        return  185;
    }else if (indexPath.section == 3) {
        if (self.lvliArr.count == 0) {
            return 240;
        }
        
        int height = 0;
        for (NSDictionary *dataDic in self.lvliArr) {
            NSString *str = safeString(dataDic[@"content"]);
            CGRect fontRect = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 220, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil];
            NSLog(@"%f",fontRect.size.height);
            if (fontRect.size.height <40) {
                height += 80;
            }else {
                height += fontRect.size.height +40;
            }
            
        }
        
        return height + 50;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        KG_BeiJianDetailFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_BeiJianDetailFirstCell"];
        if (cell == nil) {
            cell = [[KG_BeiJianDetailFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_BeiJianDetailFirstCell"];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dataDic = self.dataDic;
        cell.categoryString = self.categoryString;
        cell.deviceString = self.deviceStr;
        cell.dataDic = dataDic;
        
        return cell;
    }else if (indexPath.section == 1) {
        KG_BeiJianDetailSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_BeiJianDetailSecondCell"];
        if (cell == nil) {
            cell = [[KG_BeiJianDetailSecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_BeiJianDetailSecondCell"];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dataDic = self.dataDic;
        cell.categoryString = self.categoryString;
        cell.dataDic = dataDic;
        return cell;
    }else if (indexPath.section == 2) {
        KG_BeiJianDetailThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_BeiJianDetailThirdCell"];
        if (cell == nil) {
            cell = [[KG_BeiJianDetailThirdCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_BeiJianDetailThirdCell"];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.categoryString = self.categoryString;
        NSDictionary *dataDic = self.dataDic;
        cell.dataDic = dataDic;
        cell.descriptionStr = self.descriptionStr;
        cell.saveBlockMethod = ^(NSString * _Nonnull str) {
            [self saveMethod:str];
        };
        return cell;
    }else if (indexPath.section == 3) {
        KG_BeiJianDetaiFourthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_BeiJianDetaiFourthCell"];
        if (cell == nil) {
            cell = [[KG_BeiJianDetaiFourthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_BeiJianDetaiFourthCell"];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.categoryString = self.categoryString;
        NSDictionary *dataDic = self.dataDic;
        cell.dataDic = dataDic;
        cell.lvliArr = self.lvliArr;
        
        return cell;
    }
    
    return nil;
    
}
//零备件：修改某个备件备注的提交：
//请求地址：/intelligent/atcAttachment
//请求方式：PUT
//请求Body：JSON格式的AtcAttachment对象：
//    {
//        "id": "XXX",
//        "description": "XXX",    //APP端只允许修改这一个字段，备件备注
////其他字段，必填，原封不动从备件详情接口填充即可
//        "name": "XXX",
//        "code": "XXX",
//        "serialNumber": "XXX",
//        "source": "XXX",
//        "storageLocation": "XXX",
//        "keeper": "XXX",
//        "time": XXX,
//        "model": "XXX",
//        "status": "XXX",
//        "category": "XXX",
//        "stationCode": "XXX",
//        "engineRoomCode": "XXX",
//"parentEquipmentCode": null,
//        "equipmentCode": "XXX",
//        "grade": "XXX",
//"partNumber": "XXX",
//        "lastStartUseTime": XXX
//    }
//保存备注
- (void)saveMethod :(NSString *)str {
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcAttachment"]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
   
    params[@"id"] = safeString(self.dataDic[@"id"]);
    params[@"description"] = safeString(str);//APP端只允许修改这一个字段，
    params[@"name"] = safeString(self.dataDic[@"name"]);
    params[@"code"] = safeString(self.dataDic[@"code"]);
    params[@"serialNumber"] = safeString(self.dataDic[@"serialNumber"]);
    params[@"source"] = safeString(self.dataDic[@"source"]);
    params[@"storageLocation"] = safeString(self.dataDic[@"storageLocation"]);
    params[@"keeper"] = safeString(self.dataDic[@"keeper"]);
    params[@"time"] = safeString(self.dataDic[@"time"]);
    params[@"model"] = safeString(self.dataDic[@"model"]);
    params[@"category"] = safeString(self.dataDic[@"category"]);
    params[@"status"] = safeString(self.dataDic[@"status"]);
    params[@"stationCode"] = safeString(self.dataDic[@"stationCode"]);
    params[@"engineRoomCode"] = safeString(self.dataDic[@"engineRoomCode"]);
    params[@"parentEquipmentCode"] = safeString(self.dataDic[@"parentEquipmentCode"]);
    params[@"equipmentCode"] = safeString(self.dataDic[@"equipmentCode"]);
    params[@"grade"] = safeString(self.dataDic[@"grade"]);
    params[@"partNumber"] = safeString(self.dataDic[@"partNumber"]);
    params[@"lastStartUseTime"] = safeString(self.dataDic[@"lastStartUseTime"]);
    
    [FrameBaseRequest putWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            
            return ;
        }
        [FrameBaseRequest showMessage:@"保存成功"];
//        [self.tableView reloadData];
        
    }  failure:^(NSError *error) {
        NSLog(@"请求失败 原因：%@",error);
        
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    } ];
    
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

- (void)createUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    return footView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}
//
//零备件：获取某个备件详情：
//请求地址：/intelligent/atcAttachment/{id}
//    其中，id是备件的id
//请求方式：GET
//请求返回:
//如：http://192.168.100.173:8089/intelligent/atcAttachment/10040
//{



- (void)queryData{
    //    NSString *FrameRequestURL = @"http://10.33.33.147:8089/intelligent/api/stationList";
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcAttachment/%@",self.dataDic[@"id"]]];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
       
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
    
            return ;
        }
        NSDictionary * dataDic = result[@"value"];
        if (dataDic.count) {
            self.lvliArr = dataDic[@"atcAttachmentRecords"];
            self.descriptionStr = dataDic[@"description"];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *error)  {
        [MBProgressHUD hideHUD];
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
        return ;
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView

{
    NSLog(@"contentOffset====%f",self.tableView.contentOffset.y);
    if (self.tableView.contentOffset.y > 0) {
        float orY= self.tableView.contentOffset.y/208;
      
        self.navigationBgImageView.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
        self.navigationBgImageView.alpha = orY;
        
    }else {
        self.navigationBgImageView.backgroundColor = [UIColor clearColor];
        self.navigationBgImageView.alpha = 1;
    }
    
//    if(self.tableView.contentOffset.y >10 ) {
//
//        self.leftImage.image = [UIImage imageNamed:@"back_black"];
//        self.titleLabel.textColor = [UIColor colorWithHexString:@"24252A"];
//    }else {
//
//        self.leftImage.image = [UIImage imageNamed:@"backwhite"];
//        self.titleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
//    }
    
}
@end
