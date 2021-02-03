//
//  KG_CreateReportAlertView.m
//  Frame
//
//  Created by zhangran on 2020/6/2.
//  Copyright © 2020 hibaysoft. All rights reserved.
//
#import "KG_DutyManageSelAlertView.h"
#import "KG_DutyManageSelAlertCell.h"

#import "KG_DutyManageSelModel.h"

@interface  KG_DutyManageSelAlertView()<UITableViewDelegate,UITableViewDataSource>{
    
    
}

@property (nonatomic, strong) NSArray            *dataArray;


@property (nonatomic, strong) NSDictionary        *dataDic;

@property (nonatomic, strong) UITableView         *tableView;

@property (nonatomic, strong) UIButton            *bgBtn ;

@property (nonatomic, strong) UIView              *centerView;

@property (nonatomic, strong) UILabel             *topTitleLabel;//头部title

@property (nonatomic, strong) UILabel             *postTitleLabel;//岗位title

@property (nonatomic, strong) UIButton            *selBtn ;

@property (nonatomic, assign) BOOL                isAllSel;

@property (nonatomic, strong) NSMutableArray      *listArray;  //数据源


@end
@implementation KG_DutyManageSelAlertView

- (instancetype)initWithDataDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.dataDic = dic;
        self.dataArray = [KG_DutyManageSelModel mj_objectArrayWithKeyValuesArray:dic[@"taskList"]];
        [self initData];
        [self setupDataSubviews];
       
    }
    return self;
}
//初始化数据
- (void)initData {
    
    self.isAllSel = NO;
    
    NSMutableArray *oneTouchArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *weihuArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *specialArray = [NSMutableArray arrayWithCapacity:0];
    
    for (KG_DutyManageSelModel *model in self.dataArray) {
        if([safeString(model.typeCode) isEqualToString:@"oneTouchTour"] ||
           [safeString(model.typeCode) isEqualToString:@"fieldInspection"]) {
            [oneTouchArray addObject:model];
            
        }else if([safeString(model.typeCode) isEqualToString:@"routineMaintenance"]) {
            [weihuArray addObject:model];
            
        }else if([safeString(model.typeCode) isEqualToString:@"specialSafeguard"]
                 ||[safeString(model.typeCode) isEqualToString:@"specialTour"]) {
            [specialArray addObject:model];
            
        }
        
    }
    if(oneTouchArray.count >0) {
        [self.listArray addObject:oneTouchArray];
    }
    if(weihuArray.count >0) {
        [self.listArray addObject:weihuArray];
    }
    if(specialArray.count >0) {
        [self.listArray addObject:specialArray];
    }
   
    [self.tableView reloadData];
}

//创建视图
-(void)setupDataSubviews
{
    //按钮背景 点击消失
    self.bgBtn = [[UIButton alloc]init];
    [self addSubview:self.bgBtn];
    [self.bgBtn setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    self.bgBtn.alpha = 0.46;
    [self.bgBtn addTarget:self action:@selector(buttonClickMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    self.centerView = [[UIView alloc] init];
    self.centerView.frame = CGRectMake(52.5,209,270,242);
    self.centerView.backgroundColor = [UIColor whiteColor];
    self.centerView.layer.cornerRadius = 12;
    self.centerView.layer.masksToBounds = YES;
    [self addSubview:self.centerView];
    
    int mHeight = 198;
    if (self.dataArray.count == 1) {
        mHeight = 198 +106;
    }
    if (self.dataArray.count == 2) {
        mHeight = 198 +106 +106;
    }
    if (self.dataArray.count > 2) {
        mHeight = 198 +106 +106 + 40;
    }
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@271);
        make.height.equalTo(@(mHeight));
    }];
    
    //
    self.topTitleLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.topTitleLabel];
    self.topTitleLabel.text = safeString(self.dataDic[@"positionName"]);
//    self.topTitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.topTitleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    self.topTitleLabel.font = [UIFont my_font:16];
    self.topTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.topTitleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.topTitleLabel.numberOfLines = 1;
    [self.topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerView.mas_centerX);
        make.top.equalTo(self.centerView.mas_top);
        make.width.equalTo(@200);
        make.height.equalTo(@48);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    [self.centerView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#E6E8ED"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left);
        make.right.equalTo(self.centerView.mas_right);
        make.height.equalTo(@0.5);
        make.top.equalTo(self.topTitleLabel.mas_bottom);
    }];
    
    
    self.postTitleLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.postTitleLabel];
    self.postTitleLabel.text = @"岗位调班";
    self.postTitleLabel.font = [UIFont systemFontOfSize:16];
    self.postTitleLabel.font = [UIFont my_font:16];
    self.postTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.postTitleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.postTitleLabel.numberOfLines = 1;
    [self.postTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerView.mas_centerX);
        make.top.equalTo(lineView.mas_bottom).offset(16);
        make.width.equalTo(@300);
        make.height.equalTo(@22);
    }];
        
    
    UIView *leftReportLineView = [[UIView alloc]init];
    [self.centerView addSubview:leftReportLineView];
    leftReportLineView.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    [leftReportLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(14);
        make.top.equalTo(lineView.mas_top).offset(60);
        make.height.equalTo(@8);
        make.width.equalTo(@3);
    }];
    
    
    UILabel *leftReportTitleLabel = [[UILabel alloc]init];
    [self.centerView addSubview:leftReportTitleLabel];
    leftReportTitleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    leftReportTitleLabel.font = [UIFont systemFontOfSize:14];
    leftReportTitleLabel.numberOfLines = 1;
    leftReportTitleLabel.text = @"任务清单";
    [leftReportTitleLabel sizeToFit];
    [leftReportTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftReportLineView.mas_right).offset(4);
        make.height.equalTo(@20);
        make.centerY.equalTo(leftReportLineView.mas_centerY);
    }];
    
    UILabel *leftReportDetailLabel = [[UILabel alloc]init];
    [self.centerView addSubview:leftReportDetailLabel];
    leftReportDetailLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    leftReportDetailLabel.font = [UIFont systemFontOfSize:10];
    leftReportDetailLabel.numberOfLines = 1;
    leftReportDetailLabel.text = @"请选择任务，更新任务执行负责人";
    [leftReportDetailLabel sizeToFit];
    [leftReportDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftReportTitleLabel.mas_right).offset(4);
        
        make.height.equalTo(@20);
        make.centerY.equalTo(leftReportLineView.mas_centerY);
    }];
    
    
    [self.centerView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left);
        make.right.equalTo(self.centerView.mas_right);
        make.top.equalTo(leftReportLineView.mas_bottom).offset(13);
        make.bottom.equalTo(self.centerView.mas_bottom).offset(-45-32);
    }];
    [self.tableView reloadData];
    
    UIView *allSelView = [[UIView alloc] init];
    [self addSubview:allSelView];
    [allSelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.centerView.mas_bottom).offset(-44);
        make.height.equalTo(@32);
        
        make.left.equalTo(self.centerView.mas_left);
        make.right.equalTo(self.centerView.mas_right);
    }];
    
    
    UIView *selLayerView = [[UIView alloc] init];
    [allSelView addSubview:selLayerView];
    selLayerView.frame = CGRectMake(0,0,271,32);

    selLayerView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    selLayerView.layer.shadowColor = [UIColor colorWithRed:238/255.0 green:240/255.0 blue:245/255.0 alpha:1.0].CGColor;
    selLayerView.layer.shadowOffset = CGSizeMake(0,-1);
    selLayerView.layer.shadowOpacity = 1;
    selLayerView.layer.shadowRadius = 2;
    
    
    
    self.selBtn = [[UIButton alloc]init];
    [allSelView addSubview:self.selBtn];
    [self.selBtn setImage:[UIImage imageNamed:@"kg_dutymanageunSelImage"] forState:UIControlStateNormal];
    [self.selBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@18);
        make.left.equalTo(self.centerView.mas_left).offset(20);
        make.centerY.equalTo(allSelView.mas_centerY);
    
    }];
    [self.selBtn addTarget:self action:@selector(allSelMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *allselLabel = [[UILabel alloc]init];
    [allSelView addSubview:allselLabel];
    allselLabel.text = @"全选";
    allselLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    allselLabel.font = [UIFont systemFontOfSize:14];
    [allselLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.left.equalTo(self.selBtn.mas_right).offset(12);
        make.centerY.equalTo(allSelView.mas_centerY);
        make.height.equalTo(@32);
    }];
    
    
    
    
    UIView *botLineView = [[UIView alloc]init];
    botLineView.backgroundColor = [UIColor colorWithHexString:@"#E6E8ED"];
    [self.centerView addSubview:botLineView];
    [botLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerView.mas_bottom).offset(-44);
        make.height.equalTo(@1);
        make.width.equalTo(@270);
        make.left.equalTo(self.centerView.mas_left);
        make.right.equalTo(self.centerView.mas_right);
    }];
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.centerView addSubview:cancelBtn];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelMethod:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left);
        make.top.equalTo(botLineView.mas_bottom);
        make.width.equalTo(@135);
        make.height.equalTo(@43);
    }];
    
    
    
    
    
    
    
    UIButton *confirmBtn = [[UIButton alloc]init];
    [self.centerView addSubview:confirmBtn];
    [confirmBtn setTitle:@"确认调班" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmMethod:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.centerView.mas_right);
        make.top.equalTo(botLineView.mas_bottom);
        make.width.equalTo(@135);
        make.height.equalTo(@43);
    }];
    UIView *botLine = [[UIView alloc]init];
    botLine.backgroundColor = [UIColor colorWithHexString:@"#E6E8ED"];
    [self.centerView addSubview:botLine];
    [botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerView.mas_centerX);
        make.bottom.equalTo(self.centerView.mas_bottom);
        make.width.equalTo(@1);
        make.height.equalTo(@43);
    }];
    
 
    
}
//取消
- (void)cancelMethod:(UIButton *)button {
    if (self.cancelMethod) {
        self.cancelMethod();
    }
}
//确定
- (void)confirmMethod:(UIButton *)button {

    if (self.confirmMethod) {
        self.confirmMethod(self.dataDic);
    }
}
- (void)buttonClickMethod:(UIButton *)button {
    if (self.cancelMethod) {
        self.cancelMethod();
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.listArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *dataArray = self.listArray[section];
    
    return  dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSArray *dataArray = self.listArray[indexPath.section];
    KG_DutyManageSelModel *model = dataArray[indexPath.row];
    NSString *str = [NSString stringWithFormat:@"%@",safeString(model.taskName)];
    CGRect fontRect = [str boundingRectWithSize:CGSizeMake(270-38-32, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil];
    if(fontRect.size.height >17) {
        return 76+15;
    }
    return 76;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_DutyManageSelAlertCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_DutyManageSelAlertCell"];
    if (cell == nil) {
        cell = [[KG_DutyManageSelAlertCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_DutyManageSelAlertCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSArray *dataArray = self.listArray[indexPath.section];
    
    KG_DutyManageSelModel *model = dataArray[indexPath.row];
    
    cell.model = model;
   
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSArray *dataArray = self.listArray[section];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10+17)];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 5, SCREEN_WIDTH -24, 17)];
    [headerView addSubview:titleLabel];
    titleLabel.textColor = [UIColor colorWithHexString:@"#004EC4"];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.numberOfLines = 1;
    NSString *ss = @"常规巡视";
    for (KG_DutyManageSelModel *model in dataArray) {
        if ([safeString(model.typeCode) isEqualToString:@"oneTouchTour"] ||
            [safeString(model.typeCode) isEqualToString:@"fieldInspection"]) {
            ss = @"常规巡视";
        }else if ([safeString(model.typeCode) isEqualToString:@"routineMaintenance"]) {
            ss = @"例行维护";
            
        }else {
            ss = @"特殊保障";
        }
        break;
    }
    titleLabel.text = ss;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 27;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *dataArray = self.listArray[indexPath.section];
    KG_DutyManageSelModel *model = dataArray[indexPath.row];
    model.isSelect = !model.isSelect;
    
    
    self.isAllSel = YES;
    for (KG_DutyManageSelModel *model in self.dataArray) {
        if (model.isSelect == NO) {
            self.isAllSel = NO;
            break;
        }
    }
    if (self.isAllSel) {
        [self.selBtn setImage:[UIImage imageNamed:@"kg_dutymanageSelImage"] forState:UIControlStateNormal];
       
    }else {
        [self.selBtn setImage:[UIImage imageNamed:@"kg_dutymanageunSelImage"] forState:UIControlStateNormal];
       
    }
    if (self.selContact) {
        self.selContact(self.dataArray);
    }
    
    [self.tableView reloadData];
    
    
    
    
}

//将时间戳转换为时间字符串
- (NSString *)timestampToTimeStr:(NSString *)timestamp {
    if (isSafeObj(timestamp)==NO) {
        return @"-/-";
    }
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:timestamp.integerValue/1000];
    NSString *timeStr=[[self dateFormatWith:@"YYYY-MM-dd HH:mm:ss"] stringFromDate:date];
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

- (void)setOldPostName:(NSString *)oldPostName {
    _oldPostName = oldPostName;
    self.postTitleLabel.text = [NSString stringWithFormat:@"%@>%@",safeString(self.oldPostName),safeString(self.dataDic[@"changePerson"])];
    
}

//全选
- (void)allSelMethod:(UIButton *)btn {
    
    self.isAllSel = !self.isAllSel;
    
    
    if (self.isAllSel) {
        [self.selBtn setImage:[UIImage imageNamed:@"kg_dutymanageSelImage"] forState:UIControlStateNormal];
        for (KG_DutyManageSelModel *model in self.dataArray) {
            model.isSelect = YES;
        }
    }else {
        [self.selBtn setImage:[UIImage imageNamed:@"kg_dutymanageunSelImage"] forState:UIControlStateNormal];
        for (KG_DutyManageSelModel *model in self.dataArray) {
            model.isSelect = NO;
        }
    }
    if (self.selContact) {
        self.selContact(self.dataArray);
    }
    [self.tableView reloadData];
    
}


-(NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc]init];
    }
    return _listArray;
}

@end
