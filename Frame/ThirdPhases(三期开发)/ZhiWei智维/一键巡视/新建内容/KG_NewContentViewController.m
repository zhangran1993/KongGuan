//
//  KG_NewContentViewController.m
//  Frame
//
//  Created by zhangran on 2020/4/27.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_NewContentViewController.h"
#import "KG_NewContentCell.h"
#import "KG_NewContentTextCell.h"
#import "KG_NewContentModel.h"
#import "KG_CommonSelContentView.h"
#import "KG_CommonSelEquipView.h"
@interface KG_NewContentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) KG_NewContentModel *model;
@property(nonatomic, strong) KG_CommonSelContentView *contentView;
@property(nonatomic, strong) KG_CommonSelEquipView *equipView;

@property(nonatomic, strong) NSArray *listArr;
@end

@implementation KG_NewContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTableView];
    [self getTemplateData];
    [self createBottomView];
    self.model = [[KG_NewContentModel alloc]init];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FontSize(18),NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#24252A"]}] ;
    [self createNaviTopView];
    
    
}

- (void)createTableView {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-77);
    }];
    [self.tableView reloadData];
    
}
-  (void)createNaviTopView {
    UIButton *leftButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButon.frame = CGRectMake(0,0,FrameWidth(60),FrameWidth(60));
    [leftButon setImage:[UIImage imageNamed:@"back_gray"] forState:UIControlStateNormal];
    [leftButon setContentEdgeInsets:UIEdgeInsetsMake(0, - FrameWidth(20), 0, FrameWidth(20))];
    //button.alignmentRectInsetsOverride = UIEdgeInsetsMake(0, offset, 0, -(offset));
    [leftButon addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc]initWithCustomView:leftButon];
    self.navigationItem.leftBarButtonItem = fixedButton;
    
    UIButton *rightButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightButon.frame = CGRectMake(0,0,FrameWidth(40),FrameWidth(40));
    [rightButon setTitle:@"取消" forState:UIControlStateNormal];
    rightButon.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButon setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
    [rightButon addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightfixedButton = [[UIBarButtonItem alloc]initWithCustomView:rightButon];
    self.navigationItem.rightBarButtonItem = rightfixedButton;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = [NSString stringWithFormat:@"新建内容"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FontSize(18),NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#24252A"]}] ;
    
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.translucent = NO;
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)cancel {
    
}
- (void)createBottomView {
    UIButton *reportBtn = [[UIButton alloc]init];
    [self.view addSubview:reportBtn];
    [reportBtn setTitle:@"提交" forState:UIControlStateNormal];
    [reportBtn setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
    reportBtn.alpha = 0.3;
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

-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}
//提交
- (void)reportMethod:(UIButton *)button {
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/atcSafeguard/insertTourOrMaintain",WebNewHost];
    WS(weakSelf);
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    NSMutableArray *stationArr = [NSMutableArray array];
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    NSDictionary *dic = [self.listArr firstObject];
//    [stationArr addObject:currDic[@"code"]];
//    paraDic[@"stationCodeList"] = stationArr;
//    paraDic[@"engineRoomCodeList"] = dic[@"roomInfo"];
//    paraDic[@"planStartTime"] = dic[@"roomInfo"];
//    paraDic[@"planFinishTime"] = @"";
//    "patrolName":"XXX",      //执行负责人Id，从获取任务执行负责人/执行人列表接口获取
//    "typeCode":"oneTouchTour",       //固定，必填
//    "patrolCode":"normalInspection",   //固定，必填
//    "patrolId":"XXX",               //任务模板Id，必填，从上一接口的id获取
//    "taskName":"XXX"              //任务名称，必填
    
    [FrameBaseRequest postWithUrl:FrameRequestURL param:paraDic success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        [self.tableView.mj_footer endRefreshing];
        
        [self.dataArray addObjectsFromArray:result[@"value"][@"records"]] ;
        int pages = [result[@"value"][@"pages"] intValue];
        
       
        
        [self.tableView reloadData];
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
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        
    }
    return _tableView;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 1;
    
    //    return self.dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        KG_NewContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_NewContentCell"];
        if (cell == nil) {
            cell = [[KG_NewContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_NewContentCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"内容模块";
            [cell.selBtn setTitle:@"请选择内容模块" forState:UIControlStateNormal];
            [cell.selBtn setTitleColor:[UIColor colorWithHexString:@"#BABCC4"] forState:UIControlStateNormal];
            [cell.selBtn addTarget:self action:@selector(selectContent) forControlEvents:UIControlEventTouchUpInside];
            cell.lineView.hidden = NO;
        }else if (indexPath.row == 1) {
            cell.titleLabel.text = @"设备选择";
            [cell.selBtn setTitle:@"请选择设备" forState:UIControlStateNormal];
            [cell.selBtn setTitleColor:[UIColor colorWithHexString:@"#BABCC4"] forState:UIControlStateNormal];
            [cell.selBtn addTarget:self action:@selector(selectDevice) forControlEvents:UIControlEventTouchUpInside];
            cell.lineView.hidden = YES;
        }
        cell.hideKeyBoard = ^{
            [self.view endEditing:YES];
        };
        return cell;
    }
    
    if(indexPath.section == 1 || indexPath.section == 2){
        KG_NewContentTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_NewContentTextCell"];
        if (cell == nil) {
            cell = [[KG_NewContentTextCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_NewContentTextCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.section == 1) {
            cell.titleLabel.text = @"巡视内容";
            cell.textView.text = @"请输入巡视内容～";
            cell.textView.tag = indexPath.section;
        }else if (indexPath.section == 2) {
            cell.titleLabel.text = @"巡视结果";
            cell.textView.text = @"请输入巡视结果～";
            cell.textView.tag = indexPath.section;
        }
        cell.textString = ^(NSString * _Nonnull textStr, NSInteger tag) {
            if (tag == 1) {
                self.model.contentString = textStr;
            }else {
                self.model.resultString = textStr;
            }
        };
        cell.hideKeyBoard = ^{
            [self.view endEditing:YES];
            [cell.textView resignFirstResponder];
        };
        return cell;
    }
    return nil;
}
//选择内容
- (void)selectContent {
    if (_contentView == nil) {
        [JSHmainWindow addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.view.mas_top).offset(-NAVIGATIONBAR_HEIGHT);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }
    if (self.contentView.isHidden) {
        self.contentView.hidden = NO;
    }
}

//选择设备
- (void)selectDevice {
    if (_equipView == nil) {
        [JSHmainWindow addSubview:self.equipView];
        [self.equipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.view.mas_top).offset(-NAVIGATIONBAR_HEIGHT);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }
    if (self.equipView.isHidden) {
        self.equipView.hidden = NO;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0  ) {
        return 55;
    }else if (indexPath.section == 1 || indexPath.section == 2) {
        return 193;
    }
    return  0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    headView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    
    
    
    return headView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.f;
}
- (KG_CommonSelContentView *)contentView {
    if (!_contentView) {
        _contentView = [[KG_CommonSelContentView alloc]init];
        
    }
    return _contentView;
}

- (KG_CommonSelEquipView *)equipView {
    if (!_equipView) {
        _equipView = [[KG_CommonSelEquipView alloc]init];
        
    }
    return _equipView;
}
//
//获取某个台站某种任务类型下的模板列表：
//请求地址：/intelligent/atcSafeguard/templateList/{stationCode}/{typeCode}/{patrolCode}
//         其中，stationCode是台站编码，
//typeCode是任务大类型编码：
//一键巡视oneTouchTour
//                    例行维护routineMaintenance
//                    特殊保障分为特殊维护specialSafeguard和特殊巡视specialTour
//patrolCode是任务小类型编码，根据任务大类型从字典中获取。

//一键巡视
- (void)getTemplateData {
    
    NSString *bigStr = @"";
    NSString *smallStr = @"";
    if ([self.statusType isEqualToString:@"yijianxunshi"]) {
        bigStr = @"oneTouchTour";
        smallStr = @"normalInspection";
    }else if ([self.statusType isEqualToString:@"teshubaozhang"]) {
        bigStr = @"oneTouchTour";
        smallStr = @"";
    }else if ([self.statusType isEqualToString:@"lixingweihu"]) {
        bigStr = @"oneTouchTour";
        smallStr = @"";
    }
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
       
    NSString *rId = currDic[@"code"];
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcSafeguard/templateList/%@/%@/%@",rId,bigStr,smallStr]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        self.listArr = result[@"value"];
        NSLog(@"1");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
               NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
           [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
}
@end
