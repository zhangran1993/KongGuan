//
//  KG_AddressbookSearchViewController.m
//  Frame
//
//  Created by zhangran on 2020/9/2.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_HistorySearchViewController.h"
#import "KG_HistoryTaskCell.h"
#import "KG_XunShiReportDetailViewController.h"
@interface KG_HistorySearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong)    UITableView             *tableView;

@property (nonatomic,strong)    NSMutableArray          *dataArray;

@property (nonatomic, strong)   UILabel                 *titleLabel;

@property (nonatomic, strong)   UIView                  *navigationView;

@property (nonatomic, strong)   UIButton                *rightButton;

@property (nonatomic, strong)   UILabel                 *containLabel;

@end

@implementation KG_HistorySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNaviTopView];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [self createUI];
}
- (void)createNaviTopView {
    
    UIImageView *topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT +44)];
    [self.view addSubview:topImage1];
    topImage1.backgroundColor  = [UIColor colorWithHexString:@"#F6F7F9"];
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 44)];
    [self.view addSubview:topImage];
    topImage.backgroundColor  = [UIColor colorWithHexString:@"#F6F7F9"];
    topImage.image = [self createImageWithColor:[UIColor colorWithHexString:@"#F6F7F9"]];
    /** 导航栏 **/
    self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_NavBar)];
    self.navigationView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.navigationView];
    
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    
    [self.rightButton setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
    [self.rightButton setTitle:@"取消" forState:UIControlStateNormal];
    
    [self.view addSubview:self.rightButton];
    
    [self.rightButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton sizeToFit];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.navigationView.mas_top).offset(Height_StatusBar);
        make.height.equalTo(@44);
        make.right.equalTo(self.view.mas_right).offset(-15);
    }];
    
    
    UIView *searchView = [[UIView alloc]init];
    [self.navigationView addSubview:searchView];
    searchView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navigationView.mas_left).offset(16);
        make.centerY.equalTo(self.rightButton.mas_centerY);
        make.height.equalTo(@30);
        make.right.equalTo(self.navigationView.mas_right).offset(-54);
    }];
    searchView.layer.cornerRadius = 5.f;
    searchView.layer.masksToBounds = YES;
    
    
    UIImageView *searchIconImage = [[UIImageView alloc]init];
    [searchView addSubview:searchIconImage];
    searchIconImage.image = [UIImage imageNamed:@"kg_search"];
    [searchIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchView.mas_left).offset(6);
        make.centerY.equalTo(searchView.mas_centerY);
        make.height.width.equalTo(@18);
    }];
    
    UITextField *textField = [[UITextField alloc]init];
    [searchView addSubview:textField];
    textField.placeholder = @"搜索";
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchIconImage.mas_right).offset(9);
        make.height.equalTo(searchView.mas_height);
        make.centerY.equalTo(searchView.mas_centerY);
        make.right.equalTo(searchView.mas_right);
    }];
    textField.delegate = self;
    textField.textColor = [UIColor colorWithHexString:@"#24252A"];
    textField.font = [UIFont systemFontOfSize:14];
    textField.returnKeyType = UIReturnKeySearch;
    
}

- (void)createUI {
    
    self.containLabel = [[UILabel alloc]init];
    [self.view addSubview:self.containLabel];
    self.containLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    self.containLabel.font = [UIFont systemFontOfSize:12];
    self.containLabel.numberOfLines = 1;
    [self.containLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom).offset(13);
        make.height.equalTo(@20);
        make.left.equalTo(self.view.mas_left).offset(19);
        make.right.equalTo(self.view.mas_right).offset(-20);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containLabel.mas_bottom).offset(13);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (void)sureMethod {
    
    
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




-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    if (dataDic.count) {
        NSArray *biaoqianArr = dataDic[@"atcSpecialTagList"];
        if (biaoqianArr.count ) {
            return 128;
        }
    }
    return  108;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_HistoryTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_HistoryTaskCell"];
    if (cell == nil) {
        cell = [[KG_HistoryTaskCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_HistoryTaskCell"];
    }
    
    cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    cell.dataDic = dataDic;
    cell.currIndex = 0;
    cell.taskMethod = ^(NSDictionary * _Nonnull dic) {
        BOOL islingDao = NO;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if([userDefaults objectForKey:@"role"]){
            NSArray *arr = [userDefaults objectForKey:@"role"];
            if (arr.count) {
                for (NSString *str in arr) {
                    if ([safeString(str) isEqualToString:@"领导"]) {
                        islingDao = YES;
                        break;
                    }
                }
            }
        }
        //        if (islingDao) {
        //            [self showSelContactAlertView:dic];
        //        }else {
        //            [self getTask:dic];
        //        }
    };
    return cell;
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSDictionary *dic = self.dataArray[indexPath.row];
//    if (self.didselBlock) {
//        self.didselBlock(safeString(dic[@"id"]), safeString(dic[@"name"]));
//    };
//    [self.navigationController popViewControllerAnimated:YES];
//
//}
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
    [self.navigationController setNavigationBarHidden:NO];
    
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    
    [textField resignFirstResponder];
    [self searchData:safeString(textField.text)];
    return YES;
    
}

//搜索
- (void)searchData:(NSString *)search {
    
   
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
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = @"stationCode";
    params[@"type"] = @"eq";
    params[@"content"] = safeString(currentDic[@"code"]);
    NSMutableArray *paraArr = [NSMutableArray arrayWithCapacity:0];
    [paraArr addObject:params];
    if (search.length >0) {
        NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
        params1[@"name"] = @"key";
        params1[@"type"] = @"eq";
        params1[@"content"] = safeString(search);
        [paraArr addObject:params1];
    }
    
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcPatrolRecode/searchHistory"]];
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:paraArr success:^(id result) {
        [MBProgressHUD hideHUD];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            return ;
        }
        
        self.dataArray = result[@"value"];
        self.containLabel.text = [NSString stringWithFormat:@"包含“%@”的内容",safeString(search)];
        [self.tableView reloadData];
        
        NSLog(@"1");
    }  failure:^(NSError *error) {
        NSLog(@"请求失败 原因：%@",error);
        [MBProgressHUD hideHUD];
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    } ];
}

//指派任务
- (void)showSelContactAlertView:(NSDictionary *)dic {
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showAssignView"
                                                        object:self
                                                      userInfo:dic];
}

- (void)getTask:(NSDictionary *)dataDic {
    NSString *userID = [UserManager shareUserManager].userID ;
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/atcSafeguard/updateAtcPatrolRecode",WebNewHost];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    paramDic[@"id"] = safeString(dataDic[@"id"]);
    paramDic[@"patrolName"] = safeString(userID);
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    
    [FrameBaseRequest postWithUrl:FrameRequestURL param:paramDic success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];  [FrameBaseRequest showMessage:@"领取失败"];
            return ;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshZhiWeiData" object:self];
        [FrameBaseRequest showMessage:@"领取成功"];
        
        
        [self.dataArray removeAllObjects];
        
        
        
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [FrameBaseRequest showMessage:@"领取失败"];
        [MBProgressHUD hideHUD];
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        return ;
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    
    KG_XunShiReportDetailViewController *vc = [[KG_XunShiReportDetailViewController alloc]init];
    vc.dataDic = dataDic;
    [self.navigationController pushViewController:vc animated:YES];
    //    NSString *str = self.dataArray[indexPath.row];
    
}

@end
