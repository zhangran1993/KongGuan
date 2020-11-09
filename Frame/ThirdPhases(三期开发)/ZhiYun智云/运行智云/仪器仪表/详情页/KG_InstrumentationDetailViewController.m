//
//  KG_InstrumentationViewController.m
//  Frame
//
//  Created by zhangran on 2020/9/22.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_InstrumentationDetailViewController.h"
#import "KG_InstrumentationCell.h"
#import "KG_InstrumentationSearchViewController.h"
#import "KG_InstrumentationDetailViewController.h"
#import "KG_OperationGuideDetailViewController.h"

#import "KG_InstrumentationDetailFirstCell.h"
#import "KG_InstrumentationDetailSecondCell.h"
#import "KG_InstrumentationThirdCell.h"
#import "KG_InstrumentDetailFourthCell.h"
#import "KG_InstrumentationDetailFifthCell.h"
#import "KG_InstrumentationDetailSixthCell.h"
#import "KG_YiQiOperationGuideAlertView.h"
#import "KG_InstrumentationDetailModel.h"
#import "KG_WatchPdfViewController.h"


@interface KG_InstrumentationDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    
}

@property (nonatomic,strong)    UITableView             *tableView;

@property (nonatomic,strong)    NSMutableArray          *dataArray;

@property (nonatomic, strong)   UILabel                 *titleLabel;

@property (nonatomic, strong)   UIView                  *navigationView;

@property (nonatomic, strong)   UIButton                *searchBtn;

@property (nonatomic, strong)   UIButton                *rightButton;

@property (nonatomic, assign)   int                     pageNum;

@property (nonatomic, assign)   int                     pageSize;

@property (nonatomic,strong) UIView  *noDataView;

@property (nonatomic,strong) KG_InstrumentationDetailModel *dataModel;


@property (nonatomic,strong)    NSArray                 *guideListArray;//操作指引弹出的框的数组

@property (nonatomic,strong)    NSArray                 *guideContentListArray;

@property (nonatomic,copy)    NSString                  *guideTypeStr;
 @property (nonatomic,copy)    NSString                 *guideNameStr;

@property (nonatomic,strong)  KG_YiQiOperationGuideAlertView *guideAlertView;

@property (nonatomic, assign)   BOOL                     shouqi;

@end

@implementation KG_InstrumentationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageNum = 1;
    self.pageSize = 10;
    self.dataModel = [[KG_InstrumentationDetailModel alloc]init];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    self.shouqi = YES;
    [self createNaviTopView];
    
    [self createUI];
    [self createTableView];
    [self getData];
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
    
}

- (void)createTableView {
       
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
  
}

- (void)createUI {
   
    
}
- (void)createNaviTopView {
    
    UIImageView *topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT +44)];
    [self.view addSubview:topImage1];
    topImage1.backgroundColor  =[UIColor whiteColor];
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 44)];
    [self.view addSubview:topImage];
    topImage.backgroundColor  =[UIColor whiteColor];
    topImage.image = [UIImage imageNamed:@"kg_InstruTopImage"];
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
    self.titleLabel.text = @"仪器仪表详情";
    

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

- (void)searchAction:(UIButton *)btn {
    
    KG_InstrumentationSearchViewController *vc = [[KG_InstrumentationSearchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
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
        _tableView.scrollEnabled = YES;
       
        
    }
    return _tableView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 6;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   if(indexPath.section == 0) {
       
       return 170;
   }else if(indexPath.section == 1) {
       
       return 45*5;
   }else if(indexPath.section == 2) {
       NSString *str = safeString(self.dataModel.introduce);
       CGRect fontRect = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 64, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil];
       return fontRect.size.height +50;
       
   }else if(indexPath.section == 3) {
       
       return 48 +self.guideContentListArray.count *50;
       
   }else if(indexPath.section == 4) {
       NSArray *arr = self.dataModel.fileList;
       if (arr.count >2 &&self.shouqi) {
           return 48+ 40*2 +40;
       }
       return 48 + self.dataModel.fileList.count *40 +40;
   }else if(indexPath.section == 5) {
       NSArray *arr = self.dataModel.recordList;
       return arr.count *108 +48;
       
   }
    return 136;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
 
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0) {

        KG_InstrumentationDetailFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_InstrumentationDetailFirstCell"];
        if (cell == nil) {
            cell = [[KG_InstrumentationDetailFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_InstrumentationDetailFirstCell"];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataModel = self.dataModel;
        return cell;
    }else if(indexPath.section == 1) {

        KG_InstrumentationDetailSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_InstrumentationDetailSecondCell"];
        if (cell == nil) {
            cell = [[KG_InstrumentationDetailSecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_InstrumentationDetailSecondCell"];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataModel = self.dataModel;
        return cell;
    }else if(indexPath.section == 2) {

        KG_InstrumentationThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_InstrumentationThirdCell"];
        if (cell == nil) {
            cell = [[KG_InstrumentationThirdCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_InstrumentationThirdCell"];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataModel = self.dataModel;
        return cell;
    }else if(indexPath.section == 3) {

        KG_InstrumentDetailFourthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_InstrumentDetailFourthCell"];
        if (cell == nil) {
            cell = [[KG_InstrumentDetailFourthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_InstrumentDetailFourthCell"];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataModel = self.dataModel;
        cell.listArray = self.guideContentListArray;
        cell.guideTypeStr = self.guideTypeStr;
        cell.guideNameStr = self.guideNameStr;
        cell.selGudieListBlock = ^{
            _guideAlertView = nil;
            [_guideAlertView removeFromSuperview];
            [JSHmainWindow addSubview:self.guideAlertView];
            self.guideAlertView.selTypeStr = ^(NSString * _Nonnull typeStr, NSString * _Nonnull nameStr) {
                
                self.guideTypeStr = typeStr;
                self.guideNameStr = nameStr;
                [self getOperationGuide];
                
            };
            [self.guideAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo([UIApplication sharedApplication].keyWindow.mas_left);
                make.right.equalTo([UIApplication sharedApplication].keyWindow.mas_right);
                make.top.equalTo([UIApplication sharedApplication].keyWindow.mas_top);
                make.bottom.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom);
            }];
        };
        
        cell.pushToDetailBlock = ^(NSDictionary * _Nonnull dataDic) {
            KG_OperationGuideDetailViewController *vc = [[KG_OperationGuideDetailViewController alloc]init];
            vc.dataDic = dataDic;
            [self.navigationController pushViewController:vc animated:YES];
            
        };
        return cell;
    }else if(indexPath.section == 4) {

        KG_InstrumentationDetailFifthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_InstrumentationDetailFifthCell"];
        if (cell == nil) {
            cell = [[KG_InstrumentationDetailFifthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_InstrumentationDetailFifthCell"];
        }
        cell.changeShouQiBlock = ^(BOOL shouqi) {
            self.shouqi = shouqi;
            [self.tableView reloadData];
        };
        cell.pushToNextStep = ^(NSDictionary * _Nonnull dataDic) {
            
            KG_WatchPdfViewController *vc = [[KG_WatchPdfViewController alloc]init];
            vc.dataDic = dataDic;
            [self.navigationController pushViewController:vc animated:YES];
        };
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataModel = self.dataModel;
        return cell;
    }else if(indexPath.section == 5) {

        KG_InstrumentationDetailSixthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_InstrumentationDetailSixthCell"];
        if (cell == nil) {
            cell = [[KG_InstrumentationDetailSixthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_InstrumentationDetailSixthCell"];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataModel = self.dataModel;
        return cell;
    }
    return nil;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    return topView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

//仪器仪表：获取某个仪器仪表的详情：
//请求地址：/intelligent/atcInstrument/{id}
//请求方式：GET
//请求返回：


- (void)queryData:(dispatch_group_t)group {
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcInstrument/%@",safeString(self.idStr)]];
    WS(weakSelf);
//
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        [MBProgressHUD hideHUD];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [weakSelf.tableView.mj_footer endRefreshing];
        if(code != 0){
            
            return ;
        }
       [self.dataModel mj_setKeyValues:result[@"value"]];
        
       
       [self.tableView reloadData];
    
       dispatch_group_leave(group);
    } failure:^(NSURLSessionDataTask *error)  {
        [MBProgressHUD hideHUD];
        FrameLog(@"请求失败，返回数据 : %@",error);
        dispatch_group_leave(group);
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

- (UIView *)noDataView {
    
    if (_noDataView) {
        _noDataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        UIImageView *iconImage = [[UIImageView alloc]init];
        iconImage.image = [UIImage imageNamed:@"station_ReportNoData@2x"];
        [_noDataView addSubview:iconImage];
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@302);
            make.height.equalTo(@153);
            make.centerX.equalTo(_noDataView.mas_centerX);
            make.centerY.equalTo(_noDataView.mas_centerY);
        }];
        
        UILabel *noDataLabel = [[UILabel alloc]init];
        [_noDataView addSubview:noDataLabel];
        noDataLabel.text = @"当前暂无任务";
        noDataLabel.textColor = [UIColor colorWithHexString:@"#BFC6D2"];
        noDataLabel.font = [UIFont systemFontOfSize:12];
        noDataLabel.textAlignment = NSTextAlignmentCenter;
        [noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_noDataView.mas_centerX);
            make.height.equalTo(@17);
            make.width.equalTo(@200);
            make.top.equalTo(iconImage.mas_bottom).offset(27);
        }];
        
    }
    
    return _noDataView;
}


//    仪器仪表：获取某类仪器仪表、某类操作指引:
//    请求地址：/intelligent/atcInstrumentGuideInfo/{type}/{instrumentType}
//       其中，type是仪器仪表操作指引分类编码
//    instrument Type是当前仪器仪表的类型编码
//    请求方式：GET
//    请求返回：
//          如：/intelligent/atcInstrumentGuideInfo/radioTest/wirelessComprehensiveTester
//


- (void)getOperationGuide {
    
    NSString *FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcInstrumentGuideInfo/%@/%@",safeString(self.guideTypeStr),safeString(self.dataModel.type)]];
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        [MBProgressHUD hideHUD];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
          
            return ;
        }
        self.guideContentListArray = result[@"value"];
        [self.tableView reloadData];
        
        
       
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

//请求地址：/intelligent/atcDictionary?type_code=handleGuideCategory
//请求方式：GET
//请求返回：

- (void)getOperationGuideTypeList:(dispatch_group_t)group {
    
    NSString *FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcDictionary?type_code=handleGuideCategory"]];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
          
            return ;
        }
        
        
        NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dd in result[@"value"]) {
            if((![safeString(dd[@"name"]) isEqualToString:@"新增"]) && safeString(dd[@"name"]).length >0) {
                
                [dataArr addObject:dd];
            }
        }
        self.guideListArray = dataArr;
        dispatch_group_leave(group);
       
    } failure:^(NSURLSessionDataTask *error)  {
        [MBProgressHUD hideHUD];
        FrameLog(@"请求失败，返回数据 : %@",error);
        dispatch_group_leave(group);
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

- (void) getData {
    
    
    /** 创建新的队列组 **/
    dispatch_group_t group = dispatch_group_create();
    

    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
      
        [self queryData:group];
        
    });
    
    
    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self getOperationGuideTypeList:group];
      
        
    });
    
    
    
    
    /** 队列组所有任务都结束以后，通知队列组在主线程进行其他操作 **/
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //界面刷新
        NSLog(@"请求完成");
        if(self.guideListArray.count) {
            self.guideTypeStr = safeString([self.guideListArray firstObject][@"code"]);
            self.guideNameStr = safeString([self.guideListArray firstObject][@"name"]);
            [self getOperationGuide];
           }
        
    });
    
}


- (KG_YiQiOperationGuideAlertView *)guideAlertView {
    
    if (!_guideAlertView) {
        _guideAlertView = [[KG_YiQiOperationGuideAlertView alloc]initWithDataArray:self.guideListArray];
        
    }
    
    return _guideAlertView;
}
@end
