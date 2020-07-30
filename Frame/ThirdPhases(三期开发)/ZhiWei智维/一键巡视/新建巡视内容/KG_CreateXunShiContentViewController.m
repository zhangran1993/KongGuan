//
//  KG_CreateXunShiContentViewController.m
//  Frame
//
//  Created by zhangran on 2020/4/28.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_CreateXunShiContentViewController.h"
#import "KG_XunShiRoomCell.h"
@interface KG_CreateXunShiContentViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
}

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *textField;//内容

@property (nonatomic, strong) UIButton *stationBtn;

@property (nonatomic, strong) UIButton *roomBtn;

@property (nonatomic, strong) UIButton *timeBtn;

@property (nonatomic, strong) UIButton *personBtn;

@end

@implementation KG_CreateXunShiContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新建巡视任务";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillAppear");
    if (@available(iOS 13.0, *)){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    }else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self.navigationController setNavigationBarHidden:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    
      [self.navigationController setNavigationBarHidden:YES];
    
    
    
}

- (void)createTableView {
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.view.mas_bottom).offset(-80);
        
    }];
    
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
//提交
- (void)reportMethod:(UIButton *)button {
    
    
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
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_XunShiRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_XunShiRoomCell "];
    if (cell == nil) {
        cell = [[KG_XunShiRoomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_XunShiRoomCell"];
        
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
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
    
    if (section == 0) {
        titleLabel.text = safeString(@"任务名称");
        UITextField *textField = [[UITextField alloc]init];
        textField.placeholder = @"请输入任务名称";
        [headView addSubview:textField];
        textField.textAlignment = NSTextAlignmentRight;
        textField.textColor = [UIColor colorWithHexString:@"#24252A"];
        textField.font = [UIFont systemFontOfSize:14];
        textField.delegate = self;
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(headView.mas_right).offset(-16);
            make.width.equalTo(@100);
            make.height.equalTo(@55);
            make.top.equalTo(headView.mas_top);
        }];
    }else if (section == 1) {
        
        self.stationBtn = [[UIButton alloc]init];
        [headView addSubview:self.stationBtn];
       
        self.stationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.stationBtn setTitle:@"请选择台站" forState:UIControlStateNormal];
        [self.stationBtn setTitleColor:[UIColor colorWithHexString:@"#BABCC4"] forState:UIControlStateNormal];
        self.stationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.stationBtn addTarget:self action:@selector(selectStation:) forControlEvents:UIControlEventTouchUpInside];
        [self.stationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headView.mas_centerY);
            make.right.equalTo(headView.mas_right).offset(-16);
            make.height.equalTo(headView.mas_height);
            make.width.equalTo(@150);
        }];
        
    }else if (section == 2) {
        self.roomBtn = [[UIButton alloc]init];
        [headView addSubview:self.roomBtn];
       
        self.roomBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.roomBtn setTitle:@"请选择巡视机房" forState:UIControlStateNormal];
        [self.roomBtn setTitleColor:[UIColor colorWithHexString:@"#BABCC4"] forState:UIControlStateNormal];
        self.roomBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.roomBtn addTarget:self action:@selector(selectRoom:) forControlEvents:UIControlEventTouchUpInside];
        [self.roomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headView.mas_centerY);
            make.right.equalTo(headView.mas_right).offset(-16);
            make.height.equalTo(headView.mas_height);
            make.width.equalTo(@150);
        }];
    }else if (section == 3) {
        
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
        [self.timeBtn setImage:[UIImage imageNamed:@"content_right"] forState:UIControlStateNormal];
        self.timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.timeBtn setTitle:@"请选择时间" forState:UIControlStateNormal];
        [self.timeBtn setTitleColor:[UIColor colorWithHexString:@"#BABCC4"] forState:UIControlStateNormal];
        self.timeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.timeBtn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
        [self.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headView.mas_centerY);
            make.right.equalTo(rightImage.mas_left).offset(-1);
            make.height.equalTo(headView.mas_height);
            make.width.equalTo(@150);
        }];
    }else if (section == 4) {
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
        [self.personBtn setImage:[UIImage imageNamed:@"content_right"] forState:UIControlStateNormal];
        self.personBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.personBtn setTitle:@"请选择时间" forState:UIControlStateNormal];
        [self.personBtn setTitleColor:[UIColor colorWithHexString:@"#BABCC4"] forState:UIControlStateNormal];
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
//选择台站
- (void)selectStation:(UIButton *)button {
    
    
}
//选择机房
- (void)selectRoom:(UIButton *)button {
    
    
}
//选择负责人
- (void)selectPerson:(UIButton *)button {
    
    
}
//选择时间
- (void)selectTime:(UIButton *)button {
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 55;
}


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
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
@end
