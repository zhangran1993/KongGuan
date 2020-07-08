//
//  KG_OnsiteInspectionView.m
//  Frame
//
//  Created by zhangran on 2020/6/10.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_OnsiteInspectionView.h"
#import "KG_OnsiteInspectionCell.h"
@interface KG_OnsiteInspectionView()<UITableViewDelegate,UITableViewDataSource>{
    
  }
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;
   
@property (nonatomic, strong) UIButton *bgBtn ;

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIView *centerView;

@property (nonatomic, strong) NSDictionary *dataDic;

@end
@implementation KG_OnsiteInspectionView

- (instancetype)initWithCondition:(NSDictionary *)condition;
{
    self = [super init];
    if (self) {
        self.dataDic = condition;
        [self initData];
        [self setupDataSubviews];
        
    }
    return self;
}
//初始化数据
- (void)initData {
    
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
    self.dataArray = self.dataDic[@"atcPatrolRoomList"];
    NSInteger height = 356-120 +self.dataArray.count *70;
    if (self.dataArray.count >2) {
        height = 356;
    }
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.mas_top).offset((SCREEN_HEIGHT -326)/2);
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.equalTo(@(height));
    }];
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [self.centerView addSubview:titleLabel];
    titleLabel.text = @"现场巡视详情";
    titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.numberOfLines = 1;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerView.mas_centerX);
        make.top.equalTo(self.centerView.mas_top).offset(18);
        make.width.equalTo(@200);
        make.height.equalTo(@24);
    }];
    
    UIImageView *shuImage = [[UIImageView alloc]init];
    [self.centerView addSubview:shuImage];
    shuImage.image = [UIImage imageNamed:@"xunshi_shuImage"];
    [shuImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(15);
        make.top.equalTo(titleLabel.mas_bottom).offset(23);
        make.width.equalTo(@4);
        make.height.equalTo(@11);
    }];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    [self.centerView addSubview:timeLabel];
    timeLabel.text = @"任务时间：";
    [timeLabel sizeToFit];
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    timeLabel.numberOfLines = 1;
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shuImage.mas_centerY);
        make.left.equalTo(shuImage.mas_right).offset(8);
        
        make.height.equalTo(@20);
    }];
    
    
    UILabel *timeTextLabel = [[UILabel alloc]init];
    [self.centerView addSubview:timeTextLabel];
    timeTextLabel.text = [self timestampToTimeStr:safeString(self.dataDic[@"patrolIntervalTime"])];
    [timeTextLabel sizeToFit];
    timeTextLabel.font = [UIFont systemFontOfSize:14];
    timeTextLabel.textAlignment = NSTextAlignmentRight;
    timeTextLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    timeTextLabel.numberOfLines = 1;
    [timeTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shuImage.mas_centerY);
        make.right.equalTo(self.centerView.mas_right).offset(-20);
        
        make.height.equalTo(@20);
    }];
      
    
    
    
    
    UIImageView *shuImage1 = [[UIImageView alloc]init];
    [self.centerView addSubview:shuImage1];
    shuImage1.image = [UIImage imageNamed:@"xunshi_shuImage"];
    [shuImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(15);
        make.top.equalTo(shuImage.mas_bottom).offset(24);
        make.width.equalTo(@4);
        make.height.equalTo(@11);
    }];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    [self.centerView addSubview:nameLabel];
    nameLabel.text = @"任务名称：";
    [nameLabel sizeToFit];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    nameLabel.numberOfLines = 1;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shuImage1.mas_centerY);
        make.left.equalTo(shuImage1.mas_right).offset(8);
        
        make.height.equalTo(@20);
    }];
    
    
    UILabel *nameTextLabel = [[UILabel alloc]init];
    [self.centerView addSubview:nameTextLabel];
    nameTextLabel.text = safeString(self.dataDic[@"taskName"]);
    [nameTextLabel sizeToFit];
    nameTextLabel.font = [UIFont systemFontOfSize:14];
    nameTextLabel.textAlignment = NSTextAlignmentRight;
    nameTextLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    nameTextLabel.numberOfLines = 1;
    [nameTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shuImage1.mas_centerY);
        make.right.equalTo(self.centerView.mas_right).offset(-20);
        
        make.height.equalTo(@20);
    }];
    
    
    
    
    UIImageView *shuImage2 = [[UIImageView alloc]init];
    [self.centerView addSubview:shuImage2];
    shuImage2.image = [UIImage imageNamed:@"xunshi_shuImage"];
    [shuImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(15);
        make.top.equalTo(shuImage1.mas_bottom).offset(24);
        make.width.equalTo(@4);
        make.height.equalTo(@11);
    }];
    
    UILabel *peopleLabel = [[UILabel alloc]init];
    [self.centerView addSubview:peopleLabel];
    peopleLabel.text = @"执行负责人：";
    [peopleLabel sizeToFit];
    peopleLabel.font = [UIFont systemFontOfSize:14];
    peopleLabel.textAlignment = NSTextAlignmentLeft;
    peopleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    peopleLabel.numberOfLines = 1;
    [peopleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shuImage2.mas_centerY);
        make.left.equalTo(shuImage2.mas_right).offset(8);
        
        make.height.equalTo(@20);
    }];
    
    
    UILabel *peopleTextLabel = [[UILabel alloc]init];
    [self.centerView addSubview:peopleTextLabel];
    peopleTextLabel.text = safeString(self.dataDic[@"leaderName"]);
    [peopleTextLabel sizeToFit];
    peopleTextLabel.font = [UIFont systemFontOfSize:14];
    peopleTextLabel.textAlignment = NSTextAlignmentRight;
    peopleTextLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    peopleTextLabel.numberOfLines = 1;
    [peopleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shuImage2.mas_centerY);
        make.right.equalTo(self.centerView.mas_right).offset(-20);
        
        make.height.equalTo(@20);
    }];
    
    
    
    UIImageView *shuImage3 = [[UIImageView alloc]init];
    [self.centerView addSubview:shuImage3];
    shuImage3.image = [UIImage imageNamed:@"xunshi_shuImage"];
    [shuImage3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(15);
        make.top.equalTo(shuImage2.mas_bottom).offset(24);
        make.width.equalTo(@4);
        make.height.equalTo(@11);
    }];
    
    UILabel *resultLabel = [[UILabel alloc]init];
    [self.centerView addSubview:resultLabel];
    resultLabel.text = @"巡视结果：";
    [resultLabel sizeToFit];
    resultLabel.font = [UIFont systemFontOfSize:14];
    resultLabel.textAlignment = NSTextAlignmentLeft;
    resultLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    resultLabel.numberOfLines = 1;
    [resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shuImage3.mas_centerY);
        make.left.equalTo(shuImage3.mas_right).offset(8);
        
        make.height.equalTo(@20);
    }];
    UILabel *resultTextLabel = [[UILabel alloc]init];
    [self.centerView addSubview:resultTextLabel];
    resultTextLabel.text = safeString(self.dataDic[@"result"]);
    [resultTextLabel sizeToFit];
    resultTextLabel.font = [UIFont systemFontOfSize:14];
    resultTextLabel.textAlignment = NSTextAlignmentRight;
    resultTextLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    resultTextLabel.numberOfLines = 1;
    [resultTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shuImage3.mas_centerY);
        make.right.equalTo(self.centerView.mas_right).offset(-20);
        
        make.height.equalTo(@20);
    }];
    
    
    
    [self.centerView addSubview:self.tableView];
    NSInteger tableHeight = self.dataArray.count *70;
    if(self.dataArray.count >2) {
        tableHeight = 140;
    }
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(resultTextLabel.mas_bottom).offset(9);
        make.left.equalTo(self.centerView.mas_left);
        make.right.equalTo(self.centerView.mas_right);
        make.height.equalTo(@(tableHeight));
    }];
   
    
    [self.tableView reloadData];
    
 
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



#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return   1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_OnsiteInspectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_OnsiteInspectionCell"];
    if (cell == nil) {
        cell = [[KG_OnsiteInspectionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_OnsiteInspectionCell"];
    }
    NSDictionary *dic = self.dataArray[indexPath.section];
    cell.dic = dic;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (void)buttonClickMethod:(UIButton *)btn {
     self.hidden = YES;
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


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    headView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    return headView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    footView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}
@end
