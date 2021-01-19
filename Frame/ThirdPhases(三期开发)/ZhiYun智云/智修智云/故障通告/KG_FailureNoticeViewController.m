//
//  KG_HistoryTaskViewController.m
//  Frame
//
//  Created by zhangran on 2020/5/11.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_FailureNoticeViewController.h"
#import "KG_FailureNoticeCell.h"
#import "KG_FailureNoticeSecondCell.h"
#import "KG_FailureNoticeFlowChartViewController.h"
#import "KG_DutyGroupViewController.h"
#import "KG_FactoryViewController.h"
@interface KG_FailureNoticeViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong)     NSArray            *dataArray;

@property (nonatomic, strong)     UITableView        *tableView;

@property (nonatomic, strong)     UILabel            *titleLabel;

@property (nonatomic, strong)     UIView             *navigationView;

@property (nonatomic, assign)     BOOL               isZhankai;

@end

@implementation KG_FailureNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNaviTopView];
    [self createTopView];
  
    self.dataArray = self.model.announce[@"announce"];
    [self.tableView reloadData];
}

- (void) createTopView{
    
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
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
    self.titleLabel.text = @"故障通告";
    
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
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
      

    }
    return _tableView;
}

- (void)loadMoreData {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
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
    footView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0) {
        
        return 1;
    }else if(section == 1) {
        return 1;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.dataArray.count >3 &&self.isZhankai == NO) {
            return 50 + 3 *40 +40;
        }else if (self.dataArray.count >3 &&self.isZhankai == YES) {
            return 50 + self.dataArray.count *40 +40;
        }
        return 50 + self.dataArray.count *40;
    }else if (indexPath.section == 1) {
        return 130;
    }
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        KG_FailureNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_FailureNoticeCell"];
        if (cell == nil) {
            cell = [[KG_FailureNoticeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_FailureNoticeCell"];
        }
        cell.bottomButtonBlock = ^(BOOL isshouqi) {
            self.isZhankai =isshouqi;
            [self.tableView reloadData];
        };
        cell.pushToNextStep = ^(NSDictionary * _Nonnull dataDic) {
            KG_FailureNoticeFlowChartViewController *vc = [[KG_FailureNoticeFlowChartViewController alloc]init];
            vc.dataDic = dataDic;
            [self.navigationController pushViewController:vc animated:YES];
        };
       
        cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.listArray = self.dataArray;
        return cell;
    }else {
        KG_FailureNoticeSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_FailureNoticeSecondCell"];
        if (cell == nil) {
            cell = [[KG_FailureNoticeSecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_FailureNoticeSecondCell"];
        }
        cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.pushToNextStep = ^(NSString * _Nonnull loc) {
            
            //值班班组
            if ([loc isEqualToString:@"left"]) {
                KG_DutyGroupViewController *vc = [[KG_DutyGroupViewController alloc]init];
                vc.dataDic = self.model.announce;
                [self.navigationController pushViewController:vc animated:YES];
            //厂家
            }else if ([loc isEqualToString:@"right"]) {
                KG_FactoryViewController  *vc = [[KG_FactoryViewController alloc]init];
                vc.dataDic = self.model.announce;
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
        return cell;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}







@end
