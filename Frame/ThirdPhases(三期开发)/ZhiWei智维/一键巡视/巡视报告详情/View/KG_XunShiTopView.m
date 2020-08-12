//
//  KG_XunShiTopView.m
//  Frame
//
//  Created by zhangran on 2020/4/26.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_XunShiTopView.h"
#import "KG_XunShiTopCell.h"

@interface KG_XunShiTopView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)     UITableView *tableView;

@property (nonatomic ,strong)     NSArray *dataArray;

@property (nonatomic ,assign)     BOOL shouqi;

@property (nonatomic ,strong)     NSDictionary *shouqiDic;

@property (nonatomic ,copy)       NSString *leadStr;

@property (nonatomic ,copy)       NSString *personStr;

@end

@implementation KG_XunShiTopView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
        [self setupDataSubviews];
       
        
    }
    return self;
}
//初始化数据
- (void)initData {
    self.dataArray = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
}

//创建视图
-(void)setupDataSubviews
{
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self.tableView reloadData];

}

// 背景按钮点击视图消失
- (void)buttonClickMethod :(UIButton *)btn {
    self.hidden = YES;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        
    }
    return _tableView;
}
-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}



#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.shouqi ) {
        return 3;
    }
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 28;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_XunShiTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_XunShiTopCell"];
    if (cell == nil) {
        cell = [[KG_XunShiTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_XunShiTopCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.shouqi) {
        if (indexPath.row == 0) {
            cell.titleLabel.text = safeString(self.model.taskRange);
            cell.iconImage.image = [UIImage imageNamed:@"xunshi_locIcon"];
        }else if (indexPath.row == 1){
            if(isSafeDictionary(self.dataDic)) {
                if(self.dataDic.count >0){
                    
                    cell.titleLabel.text = [self timestampToDayTimeStr:safeString(self.dataDic[@"planStartTime"])];
                }
            }
            if(safeString(self.model.taskTime).length) {
                cell.titleLabel.text = [self timestampToDayTimeStr:safeString(self.model.taskTime)];
                
            }
            cell.iconImage.image = [UIImage imageNamed:@"xunshi_timeIcon"];
        }else if (indexPath.row == 2) {
            cell.titleLabel.text = [NSString stringWithFormat:@"发布人：%@",@""];
            cell.iconImage.image = [UIImage imageNamed:@"xunshi_personIcon"];
            if(isSafeDictionary(self.shouqiDic)) {
                if(self.shouqiDic.count >0){
                    cell.titleLabel.text = [NSString stringWithFormat:@"发布人：%@ |%@",safeString(self.shouqiDic[@"createPerson"]),[self timestampToTimeStr:safeString(self.shouqiDic[@"createTime"])]];
                }
            }
        }
    }else {
        if (indexPath.row == 0) {
            cell.titleLabel.text = safeString(self.model.taskRange);
            cell.iconImage.image = [UIImage imageNamed:@"xunshi_locIcon"];
        }else if (indexPath.row == 1){
            if(isSafeDictionary(self.dataDic)) {
                if(self.dataDic.count >0){
                    
                    cell.titleLabel.text = [self timestampToDayTimeStr:safeString(self.dataDic[@"planStartTime"])];
                }
            }
            if(safeString(self.model.taskTime).length) {
                cell.titleLabel.text = [self timestampToDayTimeStr:safeString(self.model.taskTime)];
                
            }
            

            cell.iconImage.image = [UIImage imageNamed:@"xunshi_timeIcon"];
        }else if (indexPath.row == 2) {
            cell.titleLabel.text = [NSString stringWithFormat:@"发布人：%@",@""];
            cell.iconImage.image = [UIImage imageNamed:@"xunshi_personIcon"];
            if(isSafeDictionary(self.shouqiDic)) {
                if(self.shouqiDic.count >0){
                    cell.titleLabel.text = [NSString stringWithFormat:@"发布人：%@ |%@",safeString(self.shouqiDic[@"createPerson"]),[self timestampToTimeStr:safeString(self.shouqiDic[@"createTime"])]];
                }
            }
        }else if (indexPath.row == 3) {
            cell.titleLabel.text = [NSString stringWithFormat:@"执行负责人：%@",safeString(self.leadStr)];
            if (self.leaderString.length >0) {
               cell.titleLabel.text = [NSString stringWithFormat:@"执行负责人：%@",safeString(self.leaderString)];
            }
            cell.iconImage.image = [UIImage imageNamed:@"xunshi_personIcon"];
        }else if (indexPath.row == 4) {
            
            cell.titleLabel.text = [NSString stringWithFormat:@"执行人：%@",safeString(self.personStr)];
            cell.iconImage.image = [UIImage imageNamed:@"xunshi_personIcon"];
        }else if (indexPath.row == 5) {
            cell.titleLabel.text = [NSString stringWithFormat:@"提交人：%@",@""];
            cell.iconImage.image = [UIImage imageNamed:@"xunshi_personIcon"];
            if(isSafeDictionary(self.shouqiDic)) {
                if(self.shouqiDic.count >0){
                    if (self.shouqiDic[@"submitTime"] !=nil) {
                        cell.titleLabel.text = [NSString stringWithFormat:@"提交人：%@ |%@",safeString(self.shouqiDic[@"submitPerson"]),[self timestampToTimeStr:safeString(self.shouqiDic[@"submitTime"])]];
                        if(safeString(self.shouqiDic[@"submitTime"]).length == 0) {
                            cell.titleLabel.text = [NSString stringWithFormat:@"提交人："];
                        }
                    }
                }
            }
        }
        
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel *headTitle = [[UILabel alloc]initWithFrame:CGRectMake(22.5, 0, SCREEN_WIDTH -22.5-70, 44)];
    [headView addSubview:headTitle];
    if (safeString(self.model.taskName).length) {
        headTitle.text = safeString(self.model.taskName);
    }
    
    headTitle.textAlignment = NSTextAlignmentLeft;
    headTitle.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    headTitle.textColor = [UIColor colorWithHexString:@"#24252A"];
    headTitle.numberOfLines = 1;
    
    UIImageView *stastusImage = [[UIImageView alloc]init];
    stastusImage.image = [UIImage imageNamed:[self getTaskImage:safeString(self.model.taskStatus)]];
    [stastusImage sizeToFit];
    [headView addSubview:stastusImage];
    [stastusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headView.mas_right);
        make.centerY.equalTo(headTitle.mas_centerY);
        make.height.equalTo(@26);

    }];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(16, 43, SCREEN_WIDTH -32, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [headView addSubview:lineView];
    
    
    return headView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 54)];
    footView.backgroundColor = [UIColor whiteColor];
    UIButton *footBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH/2, 44)];
    [footBtn setTitle:@"收起" forState:UIControlStateNormal];
    if (self.shouqi) {
        [footBtn setTitle:@"展开" forState:UIControlStateNormal];
    }
    footBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [footBtn setTitleColor:[UIColor colorWithHexString:@"#1860B0"] forState:UIControlStateNormal];
    [footBtn addTarget:self action:@selector(zhankaiMethod:) forControlEvents:UIControlEventTouchUpInside];
    [footBtn setImage:[UIImage imageNamed:@"shouqi_icon"] forState:UIControlStateNormal];
    if (self.shouqi) {
     
        [footBtn setImage:[UIImage imageNamed:@"zhankai"]  forState:UIControlStateNormal];
    }
    [footBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 70, 0,0 )];
    [footView addSubview:footBtn];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 44,SCREEN_WIDTH, 10)];
    [footView addSubview:bgView];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(footView.mas_bottom);
        make.height.equalTo(@10);
        make.left.equalTo(footView.mas_left);
        make.right.equalTo(footView.mas_right);
        
    }];
    return footView;
}
- (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}


//收起
- (void)zhankaiMethod:(UIButton *)button {
    
    if(self.shouqi ){
        self.shouqi = NO;
        [self.tableView reloadData];
        if (self.zhankaiMethod) {
            self.zhankaiMethod();
        }
        return;
    }
   
   
    self.shouqi = YES;
    [self.tableView reloadData];
    if (self.shouqiMethod) {
        self.shouqiMethod();
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 54;
}

- (void)setModel:(KG_XunShiReportDetailModel *)model {
    _model = model;
    NSString *patrolName = safeString(model.patrolName);
    NSArray *leadArr = [UserManager shareUserManager].leaderNameArray;
//    if (patrolName.length == 0) {
//        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
//        if ([userdefaults objectForKey:@"name"]) {
//            patrolName = [userdefaults objectForKey:@"name"];
//            
//        }
//        
//    }
   
    [self getLeaderNameData];
//
//    for (NSDictionary *dic in leadArr) {
//        if ([safeString(dic[@"id"]) isEqualToString:patrolName]) {
//            self.leadStr = safeString(dic[@"name"]);
//            break;
//        }
//    }
//    NSMutableString *ss = [NSMutableString stringWithCapacity:0];
//    for (NSDictionary *personDic in model.workPersonName) {
//        NSString *personId = safeString(personDic[@"id"]);
//        for (NSDictionary *dic in leadArr) {
//            if ([safeString(dic[@"id"]) isEqualToString:personId]) {
//               [ss appendString:[NSString stringWithFormat:@"%@ ",safeString(dic[@"name"])]];
//                break;
//            }
//        }
//
//    }
//    self.personStr = ss;
//    [self.tableView reloadData];
}
//将时间戳转换为时间字符串
- (NSString *)timestampToDayTimeStr:(NSString *)timestamp {
    if (isSafeObj(timestamp)==NO) {
        return @"-/-";
    }
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:timestamp.integerValue/1000];
    NSString *timeStr=[[self dateFormatWith:@"YYYY年MM月dd日"] stringFromDate:date];
//    NSString *timeStr=[[self dateFormatWith:@"YYYY-MM-dd"] stringFromDate:date];
    return timeStr;

}

//将时间戳转换为时间字符串
- (NSString *)timestampToTimeStr:(NSString *)timestamp {
    if (isSafeObj(timestamp)==NO) {
        return @"-/-";
    }
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:timestamp.integerValue/1000];
    NSString *timeStr=[[self dateFormatWith:@"YYYY年MM月dd日 HH:mm"] stringFromDate:date];
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
- (NSString *)getTaskImage:(NSString *)status {
    NSString *ss = @"yiwancheng_icon";
    if ([status isEqualToString:@"0"]) {
        ss = @"daizhixing_icon";
    }else if ([status isEqualToString:@"1"]) {
        ss = @"jinxingzhong_icon";
    }else if ([status isEqualToString:@"2"]) {
        ss = @"yiwancheng_icon";
    }else if ([status isEqualToString:@"3"]) {
        ss = @"yuqiweiwancheng_icon";
    }else if ([status isEqualToString:@"4"]) {
        ss = @"yuqiyiwancheng_icon";
    }else if ([status isEqualToString:@"5"]) {
        ss = @"dailingqu_icon";
    }else if ([status isEqualToString:@"6"]) {
        ss = @"daizhipai_icon";
    }
    return ss;
    
}
- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.tableView reloadData];
   
}

- (void)setDic:(NSDictionary *)dic {
    _dic =dic;
    self.shouqiDic = dic;
    [self.tableView reloadData];
    
}
//获取执行负责人列表
- (void)getLeaderNameData {
    
//
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/keepInRepair/userList"]];
    [FrameBaseRequest getDataWithUrl:FrameRequestURL param:nil success:^(id result) {
        
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        [UserManager shareUserManager].leaderNameArray = result[@"value"];
        NSString *patrolName = safeString(self.model.patrolName);
//        if (patrolName.length == 0) {
//            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
//            if ([userdefaults objectForKey:@"name"]) {
//                patrolName = [userdefaults objectForKey:@"name"];
//
//            }
//
//        }
        NSArray *leadArr = [UserManager shareUserManager].leaderNameArray;
        NSLog(@"完成");
        for (NSDictionary *dic in leadArr) {
            if ([safeString(dic[@"id"]) isEqualToString:patrolName]) {
                self.leadStr = safeString(dic[@"name"]);
                break;
            }
        }
        NSMutableString *ss = [NSMutableString stringWithCapacity:0];
        for (NSDictionary *personDic in self.model.workPersonName) {
            NSString *personId = safeString(personDic[@"id"]);
            for (NSDictionary *dic in leadArr) {
                if ([safeString(dic[@"id"]) isEqualToString:personId]) {
                   [ss appendString:[NSString stringWithFormat:@"%@ ",safeString(dic[@"name"])]];
                    break;
                }
            }
            
        }
        self.personStr = ss;
        [self.tableView reloadData];
       
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSLog(@"完成");
        
    }];

}

- (void)setLeaderString:(NSString *)leaderString {
    _leaderString = leaderString;
    
    [self.tableView reloadData];
}
@end
