//
//  KG_RunReportDetailViewController.m
//  Frame
//
//  Created by zhangran on 2020/6/2.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RunReportDetailViewController.h"
#import "KG_RunReportDetailFirstCell.h"
#import "KG_RunReportDetailSecondCell.h"
#import "KG_RunReportDetailThirdCell.h"
#import "KG_RunReportDetailFourthCell.h"
#import "KG_RunReportDetailFifthCell.h"
#import "KG_RunReportDetailSixthCell.h"
#import "KG_RunReportDetailSeventhCell.h"
#import "KG_RunReportDetailEighthCell.h"
#import "KG_RunReportDeatilModel.h"
#import "KG_RunReportDetailNinethCell.h"
@interface KG_RunReportDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;


@property (nonatomic, strong)  UILabel   *titleLabel;
@property (nonatomic, strong)  UIView    *navigationView;
@property (nonatomic, strong)  UIButton  *rightButton;
@property (nonatomic, strong)  KG_RunReportDeatilModel *dataModel;

@property (nonatomic, copy)  NSString *descriptionStr;
@end

@implementation KG_RunReportDetailViewController


-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillAppear");
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    [self.navigationController setNavigationBarHidden:NO];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataModel = [[KG_RunReportDeatilModel alloc]init];
    [self createNaviTopView];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.tableView reloadData];
    [self queryData];
}

- (void)queryData {
    NSString *rId = safeString(self.dataDic[@"atcRunReportId"]);
    if (rId.length == 0) {
        rId = self.dataDic[@"id"];
    }
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcRunReport/%@",rId]];
    [FrameBaseRequest getDataWithUrl:FrameRequestURL param:nil success:^(id result) {
        
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        [self.dataModel mj_setKeyValues:result[@"value"]];
        [self.tableView reloadData];
        NSLog(@"完成");
        
        NSLog(@"");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSLog(@"完成");
        
    }];
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
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
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        
    }
    return _tableView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.pushType isEqualToString:@"jieban"] ||[self.pushType isEqualToString:@"jiaoban"] || [self.pushType isEqualToString:@"create"]) {
        return 9;
    }
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 105;
    }else if (indexPath.section == 1) {
        int height = 0;
        
        NSString *str = safeString(self.dataModel.info[@"autoAlarmContent"]);
        CGRect fontRect = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 64, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil];
        NSLog(@"%f",fontRect.size.height);
        height += fontRect.size.height;
        
        int height1 = 0;
        NSString *str1 = safeString(self.dataModel.info[@"manualAlarmContent"]);
        CGRect fontRect1 = [str1 boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 64, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil];
        NSLog(@"%f",fontRect.size.height);
        height1 += fontRect1.size.height;
        
        if(safeString(self.dataModel.info[@"manualAlarmContent"]).length == 0 &&safeString(self.dataModel.info[@"autoAlarmContent"]).length ==0){
            
            return 88;
        }
        
        return height +height1 +88+60 +24;
    }else if (indexPath.section == 2) {
        int height = 0;
        
        NSString *str = safeString(self.dataModel.info[@"changeContent"]);
        CGRect fontRect = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 64, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil];
        NSLog(@"%f",fontRect.size.height);
        height += fontRect.size.height;
        
        
        return height +60 +24;
    }else if (indexPath.section == 3) {
        
        int height = 0;
        NSString *str = safeString(self.dataModel.info[@"otherAlarmContent"]);
          
            CGRect fontRect = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 64, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil];
            NSLog(@"%f",fontRect.size.height);
            height += fontRect.size.height;
       
        return height +24 +60;
    }else if (indexPath.section == 4) {
        
        NSString *str = safeString(self.dataModel.info[@"promptContent"]);
        CGRect fontRect = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 64, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil];
        NSLog(@"%f",fontRect.size.height);
        
        return fontRect.size.height+24 +60;
    }else if (indexPath.section == 5) {
        
        int height = 0;
        if (self.dataModel.info.count >0) {
            NSString *json1=safeString(self.dataModel.info[@"fileUrl"]) ;
            if (json1.length >0) {
                 NSData *jsonData = [json1 dataUsingEncoding:NSUTF8StringEncoding];
                           NSError *err;
                           NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                          options:NSJSONReadingMutableContainers
                                                                            error:&err];
                           
                           for (NSDictionary *dic in arr) {
                               NSString *str = [NSString stringWithFormat:@"%d.%@",(int)indexPath.row +1,safeString(dic[@"name"])];
                               CGRect fontRect = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 64, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil];
                               NSLog(@"%f",fontRect.size.height);
                               height += fontRect.size.height;
                           }
                            return height +arr.count *24 +60;
            }
           
        }
      
       
        return 60;
    }else if (indexPath.section == 6) {
        return 95;
    }else if (indexPath.section == 7) {
       
        return self.dataModel.changeShifts.count *80 +60;
    }else if (indexPath.section == 8) {
       
        return 86;
    }
    return 81;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        KG_RunReportDetailFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunReportDetailFirstCell"];
        if (cell == nil) {
            cell = [[KG_RunReportDetailFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunReportDetailFirstCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        }
        cell.model = self.dataModel;
        return cell;
  
    }else if (indexPath.section == 1) {
        KG_RunReportDetailSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunReportDetailSecondCell"];
        if (cell == nil) {
            cell = [[KG_RunReportDetailSecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunReportDetailSecondCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        }
        cell.model = self.dataModel;
        return cell;
    }else if (indexPath.section == 2) {
        KG_RunReportDetailThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunReportDetailThirdCell"];
        if (cell == nil) {
            cell = [[KG_RunReportDetailThirdCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunReportDetailThirdCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        }
        cell.model = self.dataModel;
        return cell;
    }else if (indexPath.section == 3) {
        KG_RunReportDetailFourthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunReportDetailFourthCell"];
        if (cell == nil) {
            cell = [[KG_RunReportDetailFourthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunReportDetailFourthCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        }
         cell.model = self.dataModel;
        return cell;
    }else if (indexPath.section == 4) {
        KG_RunReportDetailFifthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunReportDetailFifthCell"];
        if (cell == nil) {
            cell = [[KG_RunReportDetailFifthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunReportDetailFifthCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        }
         cell.model = self.dataModel;
        return cell;
    }else if (indexPath.section == 5) {
        KG_RunReportDetailSixthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunReportDetailSixthCell"];
        if (cell == nil) {
            cell = [[KG_RunReportDetailSixthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunReportDetailSixthCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        }
        cell.model = self.dataModel;
        return cell;
    }else if (indexPath.section == 6) {
        KG_RunReportDetailSeventhCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunReportDetailSeventhCell"];
        if (cell == nil) {
            cell = [[KG_RunReportDetailSeventhCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunReportDetailSeventhCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        }
        cell.textString = ^(NSString * _Nonnull textStr) {
            self.descriptionStr = safeString(textStr);
        };
        cell.pushType = self.pushType;
//        cell.model = self.dataModel;
        return cell;
    }else if (indexPath.section == 7) {
        KG_RunReportDetailEighthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunReportDetailEighthCell"];
        if (cell == nil) {
            cell = [[KG_RunReportDetailEighthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunReportDetailEighthCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        }
        cell.model = self.dataModel;
        return cell;
    }else if (indexPath.section == 8) {
        KG_RunReportDetailNinethCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunReportDetailNinethCell"];
        if (cell == nil) {
            cell = [[KG_RunReportDetailNinethCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunReportDetailNinethCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.pushType isEqualToString:@"jieban"]) {
            [cell.centerBtn setTitle:@"接班" forState:UIControlStateNormal];
            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
            if ([userdefaults objectForKey:@"name"]) {
                NSString *userName = [userdefaults objectForKey:@"name"];
                
                int num = 0;
                for (NSDictionary *dic in self.dataModel.changeShifts) {
                    if ([safeString(dic[@"successorName"]) isEqualToString:safeString(userName)] &&safeString(dic[@"successorName"]).length >0 &&safeString(userName).length >0) {
                        num ++;
                    }
                }
                if (num >0) {
                    [cell.centerBtn setBackgroundColor:[UIColor colorWithHexString:@"EBF4FF"]];
                    cell.centerBtn.enabled = NO;
                }else {
                    [cell.centerBtn setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
                    cell.centerBtn.enabled = YES;
                }
            }
            
            
            
            
        }else if ([self.pushType isEqualToString:@"jiaoban"]) {
            [cell.centerBtn setTitle:@"交班" forState:UIControlStateNormal];
            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
            if ([userdefaults objectForKey:@"name"]) {
                NSString *userName = [userdefaults objectForKey:@"name"];
            
                int num = 0;
                for (NSDictionary *dic in self.dataModel.changeShifts) {
                    if ([safeString(dic[@"handoverName"]) isEqualToString:safeString(userName)] &&safeString(dic[@"handoverName"]).length >0 &&safeString(userName).length >0) {
                        num ++;
                    }
                }
                if (num >0) {
                    [cell.centerBtn setBackgroundColor:[UIColor colorWithHexString:@"EBF4FF"]];
                    cell.centerBtn.enabled = NO;
                }else {
                    [cell.centerBtn setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
                    cell.centerBtn.enabled = YES;
                }
            }
           
        }else {
            [cell.centerBtn setTitle:@"生成运行报告" forState:UIControlStateNormal];
        }
        [cell.centerBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return nil;
}

- (void)buttonClicked:(UIButton *)btn {
    if ([self.pushType isEqualToString:@"jieban"]) {
        [self jiebanMethod];
    }else if ([self.pushType isEqualToString:@"jiaoban"]) {
        [self jiaobanMethod];
    }else {
        [self createReportMethod];
    }
    
}

//交班接口：
//请求地址：/atcChangeShiftsRecord/shiftHandover/{post}/{runReportId}
//请求方式：POST
//请求参数：post岗位编码 runReportId报告id
//请求返回：
//如：
//{
//    "errCode": 0,
//    "errMsg": "",
//    "value": true              //交接成功返回true
//}
//
//接班接口：
//请求地址：/atcChangeShiftsRecord/succession/{post}/{runReportId}
//请求方式：POST
//请求参数：post岗位编码 runReportId报告id
//请求返回：
//如：
//{
//接班
- (void)jiebanMethod{
    
    NSString *rId = safeString(self.dataDic[@"atcRunReportId"]);
    if (rId.length == 0) {
        rId = self.dataDic[@"id"];
    }
    if(rId.length == 0) {
        
        [FrameBaseRequest showMessage:@"请交班人生成运行报告"];
    }
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcChangeShiftsRecord/succession/%@/%@",safeString(self.dataDic[@"post"]),rId]];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            
            return ;
        }
        
        NSLog(@"请求成功");
        if ([result[@"value"] boolValue]) {
            [MBProgressHUD showSuccess:@"接班成功"];
        }
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshYunxingData" object:self];
               
    }  failure:^(NSError *error) {
        NSLog(@"请求失败 原因：%@",error);
        
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    } ];
          
}
//交班
- (void)jiaobanMethod{
    
    
    int num  =0;
    
    for (NSDictionary *dd in self.dataModel.changeShifts) {
        if (safeString(dd[@"successorName"]).length>0) {
            num ++;
        }
        
    }
    if (num == 0) {
        [FrameBaseRequest showMessage:@"请先接班再交班"];
        return;
    }
    
    NSString *rId = safeString(self.dataDic[@"atcRunReportId"]);
    if (rId.length == 0) {
        rId = self.dataDic[@"id"];
    }
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcChangeShiftsRecord/shiftHandover/%@/%@",safeString(self.dataDic[@"post"]),rId]];
   
    [FrameBaseRequest postWithUrl:FrameRequestURL param:nil success:^(id result) {
           NSInteger code = [[result objectForKey:@"errCode"] intValue];
           if(code != 0){
               
               return ;
           }
        if ([result[@"value"] boolValue]) {
           [FrameBaseRequest showMessage:@"交班成功"];
        }
        [self.navigationController popViewControllerAnimated:YES];
         NSLog(@"请求成功");
         [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshYunxingData" object:self];
        
       }  failure:^(NSError *error) {
           NSLog(@"请求失败 原因：%@",error);
           
           [FrameBaseRequest showMessage:@"网络链接失败"];
           return ;
       } ];
       
    
}
//生成运行报告
- (void)createReportMethod{
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:@"/intelligent/atcRunReport"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (safeString(self.dataDic[@"time"]).length >10 && self.endTime.length >10) {
        NSString *startTimeStr = [safeString(self.dataDic[@"time"]) substringToIndex:10];
        NSString *endTimeStr = [self.endTime substringToIndex:10];
        
        NSString *title = [NSString stringWithFormat:@"%@%@-%@%@",[CommonExtension getWorkType:safeString(self.dataDic[@"post"])],startTimeStr,endTimeStr,@"运行报告"];
        params[@"title"] = title;
    }
    
   
    params[@"reportRange"] =safeString(self.dataDic[@"stationCode"]);
    params[@"startTime"] =[self CurTimeMilSec:safeString(self.dataDic[@"time"])] ;
    params[@"endTime"] = [self CurTimeMilSec:safeString(self.endTime)];
    params[@"post"] = safeString(self.dataDic[@"post"]);
    params[@"submitter"] = safeString(self.dataModel.info[@"operatorId"]);
    params[@"id"] = safeString(self.dataDic[@"id"]);
   
    if (self.dataModel.info.count >0) {
        NSString *json1=safeString(self.dataModel.info[@"fileUrl"]) ;
        if (json1.length >0) {
             params[@"fileUrl"] = safeString(self.dataModel.info[@"fileUrl"]);
        }
        
    }
    if (self.description.length > 0) {
        params[@"description"] = safeString(self.descriptionStr);            //其他补充内容
    }else {
        params[@"description"] = safeString(self.dataModel.info[@"description"]);            //其他补充内容
    }
    
    
    params[@"promptContent"] = safeString(self.dataModel.info[@"promptContent"]); //下日运行提示
    if (safeString(self.dataModel.info[@"autoAlarmContent"]).length) {
        params[@"autoAlarmContent"] = safeString(self.dataModel.info[@"autoAlarmContent"]); //设备发生问题及处理情况中的设备实时监控
    }else {
        params[@"autoAlarmContent"] = @"";
    }
    
    if (safeString(self.dataModel.info[@"otherAlarmContent"]).length) {
        params[@"otherAlarmContent"] = safeString(self.dataModel.info[@"otherAlarmContent"]); //其他相关工作
    }else {
        params[@"otherAlarmContent"] = @"";
    }
    
    if (safeString(self.dataModel.info[@"changeContent"]).length) {
        params[@"changeContent"] = safeString(self.dataModel.info[@"changeContent"]); //设备调试调整
    }else {
        params[@"changeContent"] = @"";
    }
    
    
    if (safeString(self.dataModel.info[@"manualAlarmContent"]).length) {
        params[@"manualAlarmContent"] = safeString(self.dataModel.info[@"manualAlarmContent"]); //设备发生问题及处理情况中的运行事件
    }else {
        params[@"manualAlarmContent"] = @"";
    }
    
    [FrameBaseRequest putWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
      
        [FrameBaseRequest showMessage:@"生成报告成功"];
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshYunxingData" object:self];
        
             
        
    } failure:^(NSError *error)  {
        
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
    

}
-(NSString *) CurTimeMilSec:(NSString*)pstrTime
{
    NSDateFormatter *pFormatter= [[NSDateFormatter alloc]init];
    [pFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *pCurrentDate = [pFormatter dateFromString:pstrTime];
    return [NSString stringWithFormat:@"%.f",[pCurrentDate timeIntervalSince1970] * 1000];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
 
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    headView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    return headView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001;
}

- (void)createNaviTopView {
    
    UIImageView *topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT +44)];
    [self.view addSubview:topImage1];
    topImage1.backgroundColor  =[UIColor whiteColor];
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 44)];
    [self.view addSubview:topImage];
    topImage.backgroundColor  =[UIColor whiteColor];
    topImage.image = [UIImage imageNamed:@"zhiyun_bgImage"];
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
    self.titleLabel.text = @"运行报告";
    
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
- (void)setJiaojiebanArray:(NSArray *)jiaojiebanArray {
    _jiaojiebanArray = jiaojiebanArray;
}
@end
