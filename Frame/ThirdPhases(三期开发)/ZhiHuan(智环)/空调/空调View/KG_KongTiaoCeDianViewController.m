//
//  KG_KongTiaoCeDianViewController.m
//  Frame
//
//  Created by zhangran on 2020/5/21.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_KongTiaoCeDianViewController.h"
#import "KG_KongTiaoCeDianCell.h"
@interface KG_KongTiaoCeDianViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UIButton *moreBtn ;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic ,strong) UILabel *bottomLabel;

@property (nonatomic ,strong) UILabel *tempTitle;

@property (nonatomic ,strong) UIImageView *tempImage;

@end

@implementation KG_KongTiaoCeDianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self createDataView];
}

- (void)createDataView {
    
    self.leftIcon = [[UIImageView alloc]init];
    [self.view addSubview:self.leftIcon];
    self.leftIcon.image = [UIImage imageNamed:@"staion_bgImage"];
    [self.leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(18);
        make.width.equalTo(@15);
        make.top.equalTo(self.view.mas_top).offset(21);
        make.height.equalTo(@12);
    }];
    
    self.leftTitle = [[UILabel alloc]init];
    [self.view addSubview:self.leftTitle];
    self.leftTitle.text = @"空调";
    self.leftTitle.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.leftTitle.font = [UIFont boldSystemFontOfSize:14];
    self.leftTitle.textAlignment = NSTextAlignmentLeft;
    [self.leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftIcon.mas_right).offset(5);
        make.centerY.equalTo(self.leftIcon.mas_centerY);
        make.height.equalTo(@21);
        make.width.equalTo(@250);
    }];
    
    self.moreBtn = [[UIButton alloc]init];
    [self.view addSubview:self.moreBtn];
    [self.moreBtn addTarget:self action:@selector(moreMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBtn setTitleColor:[UIColor colorWithHexString:@"#1860B0"] forState:UIControlStateNormal];
    self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [self.moreBtn setImage:[UIImage imageNamed:@"blue_jiantou"] forState:UIControlStateNormal];
    [self.moreBtn setTitle:@"更多参数" forState:UIControlStateNormal];
    [self.moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 75, 0, 0)];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.height.equalTo(@20);
        make.centerY.equalTo(self.leftTitle.mas_centerY);
        make.width.equalTo(@80);
    }];
    
    
    UIView *lineView = [[UIView alloc]init];
    [self.view addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(19);
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.top.equalTo(self.leftTitle.mas_bottom).offset(15);
        make.height.equalTo(@0.5);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(lineView.mas_bottom);
        make.height.equalTo(@50);
    }];
    
    
//    self.bottomLabel = [[UILabel alloc]init];
//    [self.view addSubview:self.bottomLabel];
//    self.bottomLabel.text = @"1#空调实时温度趋势";
//    self.bottomLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
//    self.bottomLabel.font = [UIFont boldSystemFontOfSize:14];
//    self.bottomLabel.textAlignment = NSTextAlignmentLeft;
//    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(16);
//        make.top.equalTo(self.tableView.mas_bottom).offset(16);
//        make.height.equalTo(@20);
//        make.width.equalTo(@200);
//    }];
//    
//    self.tempTitle = [[UILabel alloc]init];
//    [self.view addSubview:self.tempTitle];
//    self.tempTitle.text = @"温度";
//    self.tempTitle.textColor = [UIColor colorWithHexString:@"#24252A"];
//    self.tempTitle.font = [UIFont boldSystemFontOfSize:14];
//    self.tempTitle.textAlignment = NSTextAlignmentRight;
//    [self.tempTitle sizeToFit];
//    [self.tempTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.view.mas_right).offset(-21);
//        make.centerY.equalTo(self.bottomLabel.mas_centerY);
//        make.height.equalTo(@17);
//       
//    }];
//    
//    self.tempImage = [[UIImageView alloc]init];
//    [self.view addSubview:self.tempImage];
//    self.tempImage.backgroundColor = [UIColor colorWithHexString:@"#FFC427"];
//    [self.tempImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.tempTitle.mas_left).offset(-2);
//        make.width.equalTo(@13);
//        make.height.equalTo(@7);
//        make.centerY.equalTo(self.tempTitle.mas_centerY);
//    }];
//    
}

- (void)moreMethod:(UIButton *)button {
    if (self.moreAction) {
        self.moreAction(self.dataDic);
    }
    
}
//NSString *code = safeString(_machineDetail[@"name"]);
//   self.topIconImage.image = [UIImage imageNamed:@"UPS"];
//   if([code isEqualToString:@"UPS"]){
//       self.topIconImage.image = [UIImage imageNamed:@"device_UPS"];
//   }else if([code isEqualToString:@"水浸"]){
//       self.topIconImage.image = [UIImage imageNamed:@"device_shuijin"];
//   }else if([code isEqualToString:@"烟感"]){
//       self.topIconImage.image = [UIImage imageNamed:@"device_yangan"];
//   }else if([code isEqualToString:@"空调"]){
//       self.topIconImage.image = [UIImage imageNamed:@"device_kongtiao"];
//   }else if([code isEqualToString:@"蓄电池"]){
//       self.topIconImage.image = [UIImage imageNamed:@"device_xudianchi"];
//   }else if([code isEqualToString:@"柴油发电机"]){
//       self.topIconImage.image = [UIImage imageNamed:@"device_chaiyou"];
//   }else if([code isEqualToString:@"电量仪"]){
//       self.topIconImage.image = [UIImage imageNamed:@"device_dianliangyi"];
//   }else if([code isEqualToString:@"空开"]){
//       self.topIconImage.image = [UIImage imageNamed:@"device_kongtiao"];
//   }else if([code isEqualToString:@"电子围栏"]){
//       self.topIconImage.image = [UIImage imageNamed:@"device_zhalan"];
//   }else if([code isEqualToString:@"门禁"]){
//       self.topIconImage.image = [UIImage imageNamed:@"device_menjin"];
//   }else if([code isEqualToString:@"视频监测"]){
//       self.topIconImage.image = [UIImage imageNamed:@"device_video"];
//   }else if([code isEqualToString:@"温湿度"]){
//       self.topIconImage.image = [UIImage imageNamed:@"device_wenshidu"];
//   }else {
//       self.topIconImage.image = [UIImage imageNamed:@"device_UPS"];
//   }



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
      
      
    }
    return _tableView;
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
    KG_KongTiaoCeDianCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_KongTiaoCeDianCell"];
    if (cell == nil) {
        cell = [[KG_KongTiaoCeDianCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_KongTiaoCeDianCell"];

    }
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    cell.alarmArray = self.alarmArray;
    cell.dataDic = dataDic;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;


}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  
    return 50;
}


- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(50 * self.dataArray.count));
    }];
    [self.tableView reloadData];
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    NSString *code = safeString(_dataDic[@"category"]);
    NSString *name = safeString(_dataDic[@"name"]);
    self.leftIcon.image = [UIImage imageNamed:name];
    
    if ([code isEqualToString:@"airConditioner"]) {
        self.leftIcon.image = [UIImage imageNamed:@"空调"];
    }
}

- (void)setAlarmArray:(NSArray *)alarmArray {
    _alarmArray = alarmArray;
}

- (void)setLeftStr:(NSString *)leftStr {
    _leftStr = leftStr;
    self.leftTitle.text = leftStr;
    
}

- (void)setLeftIconStr:(NSString *)leftIconStr {
    _leftIconStr = leftIconStr;
     self.leftIcon.image = [UIImage imageNamed:@"空调"];
    
}

@end

