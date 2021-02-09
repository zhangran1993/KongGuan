//
//  KG_CreateXunShiContentViewController.m
//  Frame
//
//  Created by zhangran on 2020/4/28.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_CreateDayWeiHuViewController.h"
#import "KG_CreateDayWeiHuCell.h"
#import "KG_AddressbookViewController.h"
#import "KG_XunShiSelTimeView.h"
#import "WYLDatePickerView.h"
#import "KG_CreateDayWeiHuModel.h"
@interface KG_CreateDayWeiHuViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,WYLDatePickerViewDelegate>{
    
}

@property (nonatomic, strong) NSArray            *dataArray;

@property (nonatomic, strong) UITableView               *tableView;

@property (nonatomic, strong) UITextField               *textField;//内容

@property (nonatomic, strong) UIButton                  *stationBtn;

@property (nonatomic, strong) UIButton                  *yijianBtn;//一键巡视button

@property (nonatomic, strong) UIButton                  *normalBtn;//现场巡视button

@property (nonatomic, strong) UIButton                  *roomBtn;

@property (nonatomic, strong) UIButton                  *timeBtn;

@property (nonatomic, strong) UIButton                  *personBtn;

@property (nonatomic, strong)   UILabel                 *titleLabel;

@property (nonatomic, strong)   UIView                  *navigationView;

@property (nonatomic, strong)   UIButton                *rightButton;

@property (nonatomic, copy)   NSString                  *taskTitle;

@property (nonatomic,copy)    NSString                  *startTime;

@property (nonatomic,copy)    NSString                  *endTime;

@property (nonatomic,assign)  int                       currIndex;

@property (nonatomic, strong)   KG_CreateDayWeiHuModel *dataModel;

@property (nonatomic, strong)   NSDictionary          *dataDic;

@property (nonatomic, strong) WYLDatePickerView *dataPickerview;

@end

@implementation KG_CreateDayWeiHuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新建日维护";
    self.dataModel = [[KG_CreateDayWeiHuModel alloc]init];
    self.dataModel.taskType = @"daySafeguard";//默认日维护
    
    self.view.backgroundColor = [UIColor whiteColor];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"addressBookSelPerson" object:nil];
    [self createNaviTopView];
    [self createTableView];
    [self quertFrameData];
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillAppear");
    if (@available(iOS 13.0, *)){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    }else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    
    [self.navigationController setNavigationBarHidden:YES];
    
}
-(void)dealloc
{
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshData:(NSNotification *)notification {
    
    NSDictionary *dataDic = notification.userInfo;
    if (dataDic.count) {
        self.dataModel.realPersonID = safeString(dataDic[@"nameID"]);
        self.dataModel.realPersonName = safeString(dataDic[@"nameStr"]);
    }
    [self.tableView reloadData];
}

- (void)createTableView {
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.view.mas_bottom).offset(-80);
        
    }];
    
    UIButton *reportBtn = [[UIButton alloc]init];
    [self.view addSubview:reportBtn];
    [reportBtn setTitle:@"提交" forState:UIControlStateNormal];
    [reportBtn setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
   
    [reportBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    reportBtn.layer.cornerRadius = 6;
    reportBtn.layer.masksToBounds = YES;
    [reportBtn addTarget:self action:@selector(reportMethod:) forControlEvents:UIControlEventTouchUpInside];
    [reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.height.equalTo(@44);
        make.bottom.equalTo(self.view.mas_bottom).offset(-16);
    }];
    
}
//新增例行维护任务的提交接口（不包括巡检）：
//请求地址：/intelligent/atcSafeguard/insertTourOrMaintain
//请求方式：POST
//请求Body：
//{
//    "stationCodeList":["XXX"],       //台站编码，必填，目前仅支持单个台站
//    "engineRoomCodeList":["XXX"],  //机房编码列表，必填，从上接口的roomInfo获取
//    "planStartTime":"XXX",          //任务时间，必填，java中Date类型
//    “planFinishTime”:null,            //该字段为空即可
//    “patrolName”:”XXX”,      //执行负责人Id，从获取任务执行负责人/执行人列表接口获取
//    “typeCode”:” routineMaintenance”,       //固定，必填
//    “patrolCode”:”XXX”, //维护任务类型，必填，从例行维护子类型字典接口中获取
//    “patrolId”:”XXX”,               //任务模板Id，必填，从上接口的id获取
//    “taskName”:”XXX”              //任务名称，必填
//}

//提交
- (void)reportMethod:(UIButton *)button {
    if (safeString(self.dataModel.taskTitle).length == 0) {
        [FrameBaseRequest showMessage:@"请输入任务名称"];
        return;
    }
    
    if (self.dataArray.count == 0) {
        [FrameBaseRequest showMessage:@"该台站下暂无此类型模版"];
        return;
    }
    
    if (self.dataModel.xunshiRoom.length == 0) {
        [FrameBaseRequest showMessage:@"请选择巡视机房"];
        return;
    }
    
    if (self.dataModel.selTime.length == 0) {
        [FrameBaseRequest showMessage:@"请选择时间"];
        return;
    }
    
    if (self.dataModel.realPersonName.length == 0) {
        [FrameBaseRequest showMessage:@"请选择执行负责人"];
        return;
    }
    NSString *stationCode = @"";
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
    if (currentDic.count) {
        stationCode = safeString(currentDic[@"code"]);
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSMutableArray *stationArr = [NSMutableArray arrayWithCapacity:0];
    [stationArr addObject:stationCode];
    params[@"stationCodeList"] = stationArr;
    
    
    NSMutableArray *engineArr = [NSMutableArray arrayWithCapacity:0];
   
    if (safeString(self.dataModel.xunshiRoomCode).length >0) {
        NSArray *arr = [safeString(self.dataModel.xunshiRoomCode) componentsSeparatedByString:@","];
        for (NSString *ss in arr) {
            [engineArr addObject:safeString(ss)];
        }
    }
    
    
    params[@"engineRoomCodeList"] = engineArr ;
    
    
  
    NSString *ss = [self nsstringConversionNSDate:safeString(self.dataModel.selTime)];
    params[@"planStartTime"] = safeString(ss);
    
    
    params[@"planFinishTime"] = @"";
    params[@"patrolName"] = safeString(self.dataModel.realPersonID);
    params[@"typeCode"] = @"routineMaintenance";
    params[@"patrolCode"] = @"daySafeguard";
    params[@"patrolId"] = safeString(self.dataModel.xunshiRoomID);
    params[@"taskName"] = safeString(self.dataModel.taskTitle);
    
    NSString *FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcSafeguard/insertTourOrMaintain"]];
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:params success:^(id result) {
        [MBProgressHUD hideHUD];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            
          return ;
        }
        [FrameBaseRequest showMessage:@"提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
      
    }  failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"请求失败 原因：%@",error);
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    } ];
    
    
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        headView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        _tableView.tableHeaderView = headView;
    }
    return _tableView;
}



#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.dataArray.count >0) {
         return 5;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count >0) {
        if (section == 2) {
            return self.dataArray.count;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count >0) {
        if (indexPath.section == 2) {
            return 50 ;
        }
        return 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_CreateDayWeiHuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_CreateDayWeiHuCell"];
    if (cell == nil) {
        cell = [[KG_CreateDayWeiHuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_CreateDayWeiHuCell"];
    }
    if (self.dataArray.count >0) {
        if (indexPath.section == 2) {
            cell.titleLabel.text = safeString(self.dataArray[indexPath.row][@"roomNameList"]);
        }
    }
    cell.selRoomStr = self.dataModel.xunshiRoom;
    
    cell.roomStr = safeString(self.dataArray[indexPath.row][@"roomNameList"]);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *roomStr = self.dataArray[indexPath.row][@"roomNameList"];
    self.dataModel.xunshiRoom = safeString(roomStr);
    self.dataModel.xunshiRoomCode = safeString(self.dataArray[indexPath.row][@"roomInfo"]);
    self.dataModel.xunshiRoomID = safeString(self.dataArray[indexPath.row][@"id"]);
    self.dataModel.xunshiSelIndex = indexPath.row;
    [self.tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 55)];
        headView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        UIImageView *iconImage = [[UIImageView alloc]init];
        [headView addSubview:iconImage];
        iconImage.image = [UIImage imageNamed:@"must_starIcon"];
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@7);
            make.left.equalTo(headView.mas_left).offset(16);
            make.top.equalTo(headView.mas_top).offset(24);
        }];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.numberOfLines = 1;
        [headView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImage.mas_right).offset(10);
            make.top.equalTo(headView.mas_top);
            make.bottom.equalTo(headView.mas_bottom);
            make.width.lessThanOrEqualTo(@150);
        }];
        
        UIView *lineView = [[UIView alloc]init];
        [headView addSubview:lineView];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headView.mas_left);
            make.right.equalTo(headView.mas_right);
            make.height.equalTo(@0.5);
            make.bottom.equalTo(headView.mas_bottom);
        }];
        
        
        if (section == 0) {
            titleLabel.text = safeString(@"任务名称");
            UITextField *textField = [[UITextField alloc]init];
            textField.placeholder = @"请输入任务名称";
            if (self.dataModel.taskTitle.length) {
                textField.text = safeString(self.dataModel.taskTitle);
            }
            [headView addSubview:textField];
            textField.textAlignment = NSTextAlignmentRight;
            textField.textColor = [UIColor colorWithHexString:@"#24252A"];
            textField.font = [UIFont systemFontOfSize:14];
            textField.delegate = self;
            textField.returnKeyType = UIReturnKeyDone;
            [textField addTarget:self action:@selector(textEdit:) forControlEvents:UIControlEventEditingChanged];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(headView.mas_right).offset(-16);
                make.width.equalTo(@250);
                make.height.equalTo(@55);
                make.top.equalTo(headView.mas_top);
            }];
        }else if (section == 1) {
            titleLabel.text = safeString(@"维护台站");
            self.stationBtn = [[UIButton alloc]init];
            [headView addSubview:self.stationBtn];
            
            self.stationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [self.stationBtn setTitle:@"请选择台站" forState:UIControlStateNormal];
            
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
            if (currentDic.count) {
                [self.stationBtn setTitle:safeString(currentDic[@"name"]) forState:UIControlStateNormal];
                
                [self.stationBtn setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
            }else {
                [self.stationBtn setTitleColor:[UIColor colorWithHexString:@"#BABCC4"] forState:UIControlStateNormal];
            }
            
            
            
            self.stationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self.stationBtn addTarget:self action:@selector(selectStation:) forControlEvents:UIControlEventTouchUpInside];
            [self.stationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headView.mas_centerY);
                make.right.equalTo(headView.mas_right).offset(-16);
                make.height.equalTo(headView.mas_height);
                make.width.equalTo(@150);
            }];
            
        }
        return headView;
        
    }else {
        
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 55)];
        headView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        UIImageView *iconImage = [[UIImageView alloc]init];
        [headView addSubview:iconImage];
        iconImage.image = [UIImage imageNamed:@"must_starIcon"];
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@7);
            make.left.equalTo(headView.mas_left).offset(16);
            make.top.equalTo(headView.mas_top).offset(24);
        }];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.numberOfLines = 1;
        [headView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImage.mas_right).offset(10);
            make.top.equalTo(headView.mas_top);
            make.bottom.equalTo(headView.mas_bottom);
            make.width.lessThanOrEqualTo(@150);
        }];
        
        UIView *lineView = [[UIView alloc]init];
        [headView addSubview:lineView];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headView.mas_left);
            make.right.equalTo(headView.mas_right);
            make.height.equalTo(@0.5);
            make.bottom.equalTo(headView.mas_bottom);
        }];
        
        
        if (section == 0) {
            titleLabel.text = safeString(@"任务名称");
            UITextField *textField = [[UITextField alloc]init];
            textField.placeholder = @"请输入任务名称";
            if (self.dataModel.taskTitle.length) {
                textField.text = safeString(self.dataModel.taskTitle);
            }
            [headView addSubview:textField];
            textField.textAlignment = NSTextAlignmentRight;
            textField.textColor = [UIColor colorWithHexString:@"#24252A"];
            textField.font = [UIFont systemFontOfSize:14];
            textField.delegate = self;
            textField.returnKeyType = UIReturnKeyDone;
            [textField addTarget:self action:@selector(textEdit:) forControlEvents:UIControlEventEditingChanged];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(headView.mas_right).offset(-16);
                make.width.equalTo(@150);
                make.height.equalTo(@55);
                make.top.equalTo(headView.mas_top);
            }];
        }else if (section == 1) {
            titleLabel.text = safeString(@"巡视台站");
            self.stationBtn = [[UIButton alloc]init];
            [headView addSubview:self.stationBtn];
            
            self.stationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [self.stationBtn setTitle:@"请选择台站" forState:UIControlStateNormal];
            
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
            if (currentDic.count) {
                [self.stationBtn setTitle:safeString(currentDic[@"name"]) forState:UIControlStateNormal];
                
                [self.stationBtn setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
            }else {
                [self.stationBtn setTitleColor:[UIColor colorWithHexString:@"#BABCC4"] forState:UIControlStateNormal];
            }
            
            
            
            self.stationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self.stationBtn addTarget:self action:@selector(selectStation:) forControlEvents:UIControlEventTouchUpInside];
            [self.stationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headView.mas_centerY);
                make.right.equalTo(headView.mas_right).offset(-16);
                make.height.equalTo(headView.mas_height);
                make.width.equalTo(@150);
            }];
            
        }else if (section == 2) {
            titleLabel.text = safeString(@"巡视机房");
            self.roomBtn = [[UIButton alloc]init];
            [headView addSubview:self.roomBtn];
            
            self.roomBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [self.roomBtn setTitle:@"请选择巡视机房" forState:UIControlStateNormal];
            [self.roomBtn setTitleColor:[UIColor colorWithHexString:@"#BABCC4"] forState:UIControlStateNormal];
            if(self.dataModel.xunshiRoom.length) {
                [self.roomBtn setTitle:safeString(self.dataModel.xunshiRoom) forState:UIControlStateNormal];
                [self.roomBtn setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
            }
            
            
            self.roomBtn.titleLabel.numberOfLines =2;
            self.roomBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self.roomBtn addTarget:self action:@selector(selectRoom:) forControlEvents:UIControlEventTouchUpInside];
            [self.roomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headView.mas_centerY);
                make.right.equalTo(headView.mas_right).offset(-16);
                make.height.equalTo(headView.mas_height);
                make.width.equalTo(@250);
            }];
        }else if (section == 3) {
            titleLabel.text = safeString(@"时间选择");
            UIImageView *rightImage = [[UIImageView alloc]init];
            [headView addSubview:rightImage];
            rightImage.image = [UIImage imageNamed:@"content_right"];
            [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(headView.mas_right).offset(-12);
                make.width.height.equalTo(@15);
                make.centerY.equalTo(headView.mas_centerY);
            }];
            
            
            self.timeBtn = [[UIButton alloc]init];
            [headView addSubview:self.timeBtn];
            
            self.timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [self.timeBtn setTitle:@"请选择时间" forState:UIControlStateNormal];
            [self.timeBtn setTitleColor:[UIColor colorWithHexString:@"#BABCC4"] forState:UIControlStateNormal];
            if(self.dataModel.selTime.length) {
                [self.timeBtn setTitle:safeString(self.dataModel.selTime) forState:UIControlStateNormal];
                [self.timeBtn setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
            }
            
            self.timeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self.timeBtn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
            [self.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headView.mas_centerY);
                make.right.equalTo(rightImage.mas_left).offset(-1);
                make.height.equalTo(headView.mas_height);
                make.width.equalTo(@150);
            }];
        }else if (section == 4) {
            titleLabel.text = safeString(@"执行负责人");
            UIImageView *rightImage = [[UIImageView alloc]init];
            [headView addSubview:rightImage];
            rightImage.image = [UIImage imageNamed:@"content_right"];
            [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(headView.mas_right).offset(-12);
                make.width.height.equalTo(@15);
                make.centerY.equalTo(headView.mas_centerY);
            }];
            
            
            self.personBtn = [[UIButton alloc]init];
            [headView addSubview:self.personBtn];
            
            self.personBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [self.personBtn setTitle:@"请选择执行负责人" forState:UIControlStateNormal];
            [self.personBtn setTitleColor:[UIColor colorWithHexString:@"#BABCC4"] forState:UIControlStateNormal];
            if(self.dataModel.realPersonName.length >0) {
                [self.personBtn setTitle:safeString(self.dataModel.realPersonName) forState:UIControlStateNormal];
                [self.personBtn setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
            }
            
            self.personBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self.personBtn addTarget:self action:@selector(selectPerson:) forControlEvents:UIControlEventTouchUpInside];
            [self.personBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headView.mas_centerY);
                make.right.equalTo(rightImage.mas_left).offset(-1);
                make.height.equalTo(headView.mas_height);
                make.width.equalTo(@150);
            }];
        }
        return headView;
    }
    return nil;
    
}
//选择台站
- (void)selectStation:(UIButton *)button {
    
}

- (void)setTaskType:(UIButton *)button {
    int i = (int)button.tag;
    if (i == 1) {
        self.dataModel.taskType = @"daySafeguard";//默认一键巡视
        self.normalBtn.layer.borderColor = [[UIColor colorWithHexString:@"#F1F1F1"] CGColor];
        self.normalBtn.layer.borderWidth = 1.f;
        self.normalBtn.layer.cornerRadius = 4.f;
        self.normalBtn.layer.masksToBounds = YES;
        [self.normalBtn setTitleColor:[UIColor colorWithHexString:@"#7C7E86"] forState:UIControlStateNormal];
        [self.normalBtn setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
        
        self.yijianBtn.layer.borderColor = [[UIColor colorWithHexString:@"#F1F1F1"] CGColor];
        self.yijianBtn.layer.borderWidth = 1.f;
        self.yijianBtn.layer.cornerRadius = 4.f;
        self.yijianBtn.layer.masksToBounds = YES;
        [self.yijianBtn setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
        [self.yijianBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        
    }else {
        self.dataModel.taskType = @"daySafeguard";//现场巡视
        
        self.yijianBtn.layer.borderColor = [[UIColor colorWithHexString:@"#F1F1F1"] CGColor];
        self.yijianBtn.layer.borderWidth = 1.f;
        self.yijianBtn.layer.cornerRadius = 4.f;
        self.yijianBtn.layer.masksToBounds = YES;
        [self.yijianBtn setTitleColor:[UIColor colorWithHexString:@"#7C7E86"] forState:UIControlStateNormal];
        [self.yijianBtn setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
        
        self.normalBtn.layer.borderColor = [[UIColor colorWithHexString:@"#F1F1F1"] CGColor];
        self.normalBtn.layer.borderWidth = 1.f;
        self.normalBtn.layer.cornerRadius = 4.f;
        self.normalBtn.layer.masksToBounds = YES;
        [self.normalBtn setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
        [self.normalBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    }
    [self quertFrameData];
    
}
//选择机房
- (void)selectRoom:(UIButton *)button {
    
    
}
//选择负责人
- (void)selectPerson:(UIButton *)button {
    
    KG_AddressbookViewController *vc = [[KG_AddressbookViewController alloc]init];
    vc.sureBlockMethod = ^(NSString * _Nonnull nameID, NSString * _Nonnull nameStr) {
        self.dataModel.realPersonID = nameID;
        self.dataModel.realPersonName = nameStr;
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
//选择时间
//- (void)selectTime:(UIButton *)button {
//
//
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 55;
}



//
//NSString *bigStr = @"";
// NSString *smallStr = @"";
// if ([self.statusType isEqualToString:@"yijianxunshi"]) {
//     bigStr = @"oneTouchTour";
//     smallStr = @"normalInspection";
// }else if ([self.statusType isEqualToString:@"teshubaozhang"]) {
//     bigStr = @"oneTouchTour";
//     smallStr = @"";
// }else if ([self.statusType isEqualToString:@"lixingweihu"]) {
//     bigStr = @"oneTouchTour";
//     smallStr = @"";
// }
// NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
//
// NSString *rId = currDic[@"code"];

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
    self.titleLabel.text = @"新建日维护";
    
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
    
    
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.titleLabel.font = FontSize(16);
    
    [self.rightButton setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
    [self.rightButton setTitle:@"取消" forState:UIControlStateNormal];
    
    [self.view addSubview:self.rightButton];
    
    [self.rightButton addTarget:self action:@selector(cancelMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@60);
        make.centerY.equalTo(backBtn.mas_centerY);
        make.height.equalTo(@44);
        make.right.equalTo(self.view.mas_right).offset(-10);
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

//取消方法
- (void)cancelMethod {
     [self.navigationController popViewControllerAnimated:YES];
}


// 询问委托人是否应该在指定的文本字段中开始编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}
// return NO to disallow editing.

// 告诉委托人在指定的文本字段中开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
}
// became first responder


// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end

// 告诉委托人对指定的文本字段停止编辑
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    
}
// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

// 告诉委托人对指定的文本字段停止编辑
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0) {
    
    
}
// if implemented, called in place of textFieldDidEndEditing:

// 询问委托人是否应该更改指定的文本
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return YES;
}

// called when clear button pressed. return NO to ignore (no notifications)

// 询问委托人文本字段是否应处理按下返回按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
    
}

- (void)textEdit:(UITextField *)textField {
    self.taskTitle = textField.text;
    self.dataModel.taskTitle = textField.text;
    
}

//获取某个台站某种任务类型下的模板列表：
//请求地址：/intelligent/atcSafeguard/templateList/{stationCode}/{typeCode}/{patrolCode}
//         其中，stationCode是台站编码，
//typeCode是任务大类型编码：
//一键巡视oneTouchTour
//                    例行维护routineMaintenance
//                    特殊保障分为特殊维护specialSafeguard和特殊巡视specialTour
//patrolCode是任务小类型编码，根据任务大类型从字典中获取。

- (void)quertFrameData{
    NSString *stationCode = @"";
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
    if (currentDic.count) {
        stationCode = safeString(currentDic[@"code"]);
    }
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcSafeguard/templateList/%@/%@/%@",safeString(stationCode),@"routineMaintenance",@"daySafeguard"]];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            return ;
        }
     
        self.dataArray = result[@"value"];
//        NSString *roomStr = safeString(self.dataDic[@"roomNameList"]);
//
//        if (roomStr.length) {
//            NSArray *arr = [roomStr componentsSeparatedByString:@","];
//            [self.dataArray addObjectsFromArray:arr];
//        }
        
        [self.tableView reloadData];
        if (self.dataArray.count == 0) {
            [FrameBaseRequest showMessage:@"该台站下暂无此类型模版"];
        }
        
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
        
        return ;
    }];
}

//将时间戳转换为时间字符串
- (NSString *)timestampToTimeStr:(NSString *)timestamp {
    if (isSafeObj(timestamp)==NO) {
        return @"-/-";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp.integerValue/1000];
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
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    return formatter;
}


- (void)saveBtnClick:(NSString *)timer {
    
    self.startTime = timer;
    self.dataModel.selTime = timer;
    [self.timeBtn setTitle:safeString(self.startTime) forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerview.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
    }];
    
}
/**
 取消按钮代理方法
 */
- (void)cancelBtnClick{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerview.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
       
    }];
}
- (void)selectTime:(UIButton *)btn{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerview.frame = CGRectMake(0,  self.view.frame.size.height-300, self.view.frame.size.width, 300);
        [self.dataPickerview  show];
    }];
}

- (WYLDatePickerView *)dataPickerview
{
    if (!_dataPickerview) {
        _dataPickerview = [[WYLDatePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300) withDatePickerType:WYLDatePickerTypeYMD];
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
    
    
    self.startTime = timer;
    self.dataModel.selTime = timer;
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerview.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
        [self.dataPickerview  show];
    }];
    [self.tableView reloadData];
    
}
/**
 取消按钮代理方法
 */
- (void)datePickerViewCancelBtnClickDelegate {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerview.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
        [self.dataPickerview  show];
    }];
}
-(NSString *)nsstringConversionNSDate:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *datestr = [dateFormatter dateFromString:dateStr];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datestr timeIntervalSince1970]*1000];
    return timeSp;
    
}


@end
