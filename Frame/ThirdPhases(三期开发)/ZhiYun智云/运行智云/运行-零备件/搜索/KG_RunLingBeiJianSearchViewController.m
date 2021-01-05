//
//  KG_AddressbookSearchViewController.m
//  Frame
//
//  Created by zhangran on 2020/9/2.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RunLingBeiJianSearchViewController.h"
#import "KG_RunLingBeiJianSearchCell.h"
#import "KG_NoDataPromptView.h"
#import "KG_BeiJianDetailViewController.h"
@interface KG_RunLingBeiJianSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong)    UITableView             *tableView;

@property (nonatomic,strong)    NSMutableArray          *dataArray;

@property (nonatomic, strong)   UILabel                 *titleLabel;

@property (nonatomic, strong)   UIView                  *navigationView;

@property (nonatomic, strong)   UIButton                *rightButton;

@property (nonatomic, strong)   UILabel                 *containLabel;


@property(strong,nonatomic)   KG_NoDataPromptView  *nodataView;

@end

@implementation KG_RunLingBeiJianSearchViewController

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
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
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
    self.containLabel.font = [UIFont my_font:12];
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
    
   
    return  88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_RunLingBeiJianSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunLingBeiJianSearchCell"];
    if (cell == nil) {
        cell = [[KG_RunLingBeiJianSearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunLingBeiJianSearchCell"];
    }
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    cell.dataDic = dataDic;
    
    cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    return cell;
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
    [self.navigationController setNavigationBarHidden:NO];
    
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    
    [textField resignFirstResponder];
    [self searchData:safeString(textField.text)];
    return YES;
    
}

//搜索
- (void)searchData:(NSString *)search {
    
    if ([self.fromType isEqualToString:@"zhixiu"]) {
        [self searchZhiXiuData:search];
        return;
    }
   
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
    
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcAttachment/searchByKey"]];
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:paraArr success:^(id result) {
        [MBProgressHUD hideHUD];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            return ;
        }
        
        self.dataArray = result[@"value"];
        if (self.dataArray.count == 0) {
            [self.nodataView showView];
        }else {
            [self.nodataView hideView];
        }
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



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    KG_BeiJianDetailViewController *vc = [[KG_BeiJianDetailViewController alloc]init];
    vc.dataDic = dataDic;
//    vc.totalDic = self.dataDic;
//    if (self.totalDic.count) {
//        vc.deviceStr = safeString(self.totalDic[@"equipmentName"]);
//    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (KG_NoDataPromptView *)nodataView {
    if (!_nodataView) {
        _nodataView = [[KG_NoDataPromptView alloc]init];
        [self.view addSubview:_nodataView];
        [self.view bringSubviewToFront:_nodataView];
        _nodataView.noDataLabel.text = @"未找到相关结果";
        _nodataView.iconImage.image = [UIImage imageNamed:@"kg_lingbeijian_NodataImage"];
        [_nodataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo([UIApplication sharedApplication].keyWindow.mas_left);
            make.right.equalTo([UIApplication sharedApplication].keyWindow.mas_right);
            make.top.equalTo([UIApplication sharedApplication].keyWindow.mas_top).offset(NAVIGATIONBAR_HEIGHT);
            make.bottom.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom);
        }];
       
    }
    return _nodataView;
}

- (void)searchZhiXiuData:(NSString *)search {
    
  
       
       NSMutableDictionary *params = [NSMutableDictionary dictionary];
       params[@"name"] = @"equipmentCode";
       params[@"type"] = @"eq";
       params[@"content"] = safeString(self.model.equipmentCode);
       NSMutableArray *paraArr = [NSMutableArray arrayWithCapacity:0];
       [paraArr addObject:params];
       if (search.length >0) {
           NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
           params1[@"name"] = @"key";
           params1[@"type"] = @"eq";
           params1[@"content"] = safeString(search);
           [paraArr addObject:params1];
       }
       
       
       NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcAttachment/searchByKey"]];
       [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
       [FrameBaseRequest postWithUrl:FrameRequestURL param:paraArr success:^(id result) {
           [MBProgressHUD hideHUD];
           NSInteger code = [[result objectForKey:@"errCode"] intValue];
           if(code != 0){
               return ;
           }
           
           self.dataArray = result[@"value"];
           if (self.dataArray.count == 0) {
               [self.nodataView showView];
           }else {
               [self.nodataView hideView];
           }
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
@end
