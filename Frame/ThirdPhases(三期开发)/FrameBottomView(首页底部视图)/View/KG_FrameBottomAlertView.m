//
//  KG_FrameBottomAlertView.m
//  Frame
//
//  Created by zhangran on 2020/3/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_FrameBottomAlertView.h"
#import "FrameBottomCell.h"


@interface KG_FrameBottomAlertView ()<UITableViewDelegate,UITableViewDataSource>


/**  <#mark#> */
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation KG_FrameBottomAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
//        [self createSubviews];
        [self CreatUI];
        
    }
    return self;
}

- (void)createSubviews {
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 83)];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self addSubview:bgView];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"";
    titleLabel.textColor = [UIColor colorWithHexString:@"#101010"];
    titleLabel.numberOfLines = 1;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(14);
        make.top.equalTo(bgView.mas_top).offset(13);
        make.width.lessThanOrEqualTo(@200);
        make.height.equalTo(@22);
    }];
    
    UIButton *rightBtn = [[UIButton alloc]init];
    [rightBtn setTitle:@"查看视频" forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    rightBtn.titleLabel.font  = [UIFont systemFontOfSize:14];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"#51A2FF"] forState:UIControlStateNormal];
    [bgView addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(buttonRightClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).offset(-11);
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.width.lessThanOrEqualTo(@100);
        make.height.equalTo(@24);
    }];
    
    
    
    
}
//查看视频
- (void)buttonRightClicked :(UIButton *)button {
    
    if (self.rightBuutonClicked) {
        self.rightBuutonClicked(@"");
    }
    
}

- (void)CreatUI {
    [self addSubview:self.tableView];
    self.tableView.scrollEnabled = NO;
   
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
  
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = self.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     
        _tableView.estimatedRowHeight = 152;
    }
    return _tableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    FrameBottomCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FrameBottomCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FrameBottomCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dataDic = self.dataDic;
    [cell.watchVideoButton addTarget:self action:@selector(buttonClickedMethod:) forControlEvents:UIControlEventTouchUpInside];
   
   
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",WebNewHost,self.dataDic[@"picture"]]] placeholderImage:[UIImage imageNamed:@"station_indexbg"]  ];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",safeString(self.dataDic[@"name"])];
    cell.backgroundColor = [UIColor whiteColor];
    cell.firstNumLabel.layer.cornerRadius = 4.f;
    cell.firstNumLabel.layer.masksToBounds = YES;
    
    cell.secondNumLabel.layer.cornerRadius = 4.f;
    cell.secondNumLabel.layer.masksToBounds = YES;
    
    cell.thirdNumLabel.layer.cornerRadius = 4.f;
    cell.thirdNumLabel.layer.masksToBounds = YES;
    
    cell.fourthNumLabel.layer.cornerRadius = 4.f;
    cell.fourthNumLabel.layer.masksToBounds = YES;
    
    cell.firstNumLabel.adjustsFontSizeToFitWidth = YES;
    cell.secondNumLabel.adjustsFontSizeToFitWidth = YES;
    
    cell.thirdNumLabel.adjustsFontSizeToFitWidth = YES;
    
    cell.fourthNumLabel.adjustsFontSizeToFitWidth = YES;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"equipmentStatus"]){
        NSDictionary *dic = [userDefaults objectForKey:@"equipmentStatus"];
       
      
        if([dic[@"status"] isEqualToString:@"0"] ||[dic count] ==0){
            //正常
            cell.firstStatusLabel.image = [UIImage imageNamed:@"level_normal"];
        }else if([dic[@"status"] isEqualToString:@"3"] ){
            //正常
            cell.firstStatusLabel.image = [UIImage imageNamed:@"level_normal"];
        }else{
            int isNullm = isNullm( dic[@"num"]);
            NSString *equipNum = isNullm == 1?dic[@"num"]:@"0";
            cell.firstNumLabel.text = [NSString stringWithFormat:@"%@",equipNum];
            cell.firstNumLabel.backgroundColor = [self getTextColor:dic[@"level"]];
            if (isNullm >0) {
                cell.firstNumLabel.hidden = NO;
            }else {
                cell.firstNumLabel.hidden = YES;
            }
            cell.firstStatusLabel.image = [UIImage imageNamed:[self getLevelImage:dic[@"level"]]];
        }
        
       
    }
    if([userDefaults objectForKey:@"powerStatus"]){
        
        NSDictionary *dic = [userDefaults objectForKey:@"powerStatus"];
             
            
              if([dic[@"status"] isEqualToString:@"0"] ||[dic count] ==0){
                  //正常
                  cell.secondStatusLabel.image = [UIImage imageNamed:@"level_normal"];
              }else if([dic[@"status"] isEqualToString:@"3"] ){
                  //正常
                  cell.secondStatusLabel.image = [UIImage imageNamed:@"level_normal"];
              }else{
                  int isNullm = isNullm( dic[@"num"]);
                  NSString *equipNum = isNullm == 1?dic[@"num"]:@"0";
                  cell.secondNumLabel.text = [NSString stringWithFormat:@"%@",equipNum];
                  cell.secondNumLabel.backgroundColor = [self getTextColor:dic[@"level"]];
                  if (isNullm >0) {
                      cell.secondNumLabel.hidden = NO;
                  }else {
                      cell.secondNumLabel.hidden = YES;
                  }
                  cell.secondStatusLabel.image = [UIImage imageNamed:[self getLevelImage:dic[@"level"]]];
              }
              
    }
    if([userDefaults objectForKey:@"environmentStatus"]){
       
        NSDictionary *dic = [userDefaults objectForKey:@"environmentStatus"];
             
            
              if([dic[@"status"] isEqualToString:@"0"] ||[dic count] ==0){
                  //正常
                  cell.thirdStatusLabel.image = [UIImage imageNamed:@"level_normal"];
              }else if([dic[@"status"] isEqualToString:@"3"] ){
                  //正常
                  cell.thirdStatusLabel.image = [UIImage imageNamed:@"level_normal"];
              }else{
                  int isNullm = isNullm( dic[@"num"]);
                  NSString *equipNum = isNullm == 1?dic[@"num"]:@"0";
                  cell.thirdNumLabel.text = [NSString stringWithFormat:@"%@",equipNum];
                  cell.thirdNumLabel.backgroundColor = [self getTextColor:dic[@"level"]];
                  if (isNullm >0) {
                      cell.thirdNumLabel.hidden = NO;
                  }else {
                      cell.thirdNumLabel.hidden = YES;
                  }
                  cell.thirdStatusLabel.image = [UIImage imageNamed:[self getLevelImage:dic[@"level"]]];
              }
              
    }
    if([userDefaults objectForKey:@"securityStatus"]){
        
        NSDictionary *dic = [userDefaults objectForKey:@"securityStatus"];
             
            
              if([dic[@"status"] isEqualToString:@"0"] ||[dic count] ==0){
                  //正常
                  cell.fourthStatusLabel.image = [UIImage imageNamed:@"level_normal"];
              }else if([dic[@"status"] isEqualToString:@"3"] ){
                  //正常
                  cell.fourthStatusLabel.image = [UIImage imageNamed:@"level_normal"];
              }else{
                  int isNullm = isNullm( dic[@"num"]);
                  NSString *equipNum = isNullm == 1?dic[@"num"]:@"0";
                  cell.fourthNumLabel.text = [NSString stringWithFormat:@"%@",equipNum];
                  cell.fourthNumLabel.backgroundColor = [self getTextColor:dic[@"level"]];
                  if (isNullm >0) {
                      cell.fourthNumLabel.hidden = NO;
                  }else {
                      cell.fourthNumLabel.hidden = YES;
                  }
                  cell.fourthStatusLabel.image = [UIImage imageNamed:[self getLevelImage:dic[@"level"]]];
              }
              
    }
   
    
    return cell;
}
- (IBAction)buttonClickedMethod:(UIButton *)sender {
   
    if (self.watchVideo) {
        self.watchVideo(self.dataDic[@"code"], self.dataDic[@"name"]);
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",(long)indexPath.row);
    if (self.selStation) {
        self.selStation();
    }
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataDic.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 97 ;
}
- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.tableView reloadData];
    
}


- (NSString *)getLevelImage:(NSString *)level {
    NSString *levelString = @"level_normal";
    
    if ([level isEqualToString:@"0"]) {
        levelString = @"level_normal";
    }else if ([level isEqualToString:@"4"]) {
        levelString = @"level_prompt";
    }else if ([level isEqualToString:@"3"]) {
        levelString = @"level_ciyao";
    }else if ([level isEqualToString:@"2"]) {
        levelString = @"level_important";
    }else if ([level isEqualToString:@"1"]) {
        levelString = @"level_jinji";
    }
    
    //紧急
    return levelString;
}
- (UIColor *)getTextColor:(NSString *)level {
    UIColor *textColor = [UIColor colorWithHexString:@"FFFFFF"];
    
    if ([level isEqualToString:@"0"]) {
        textColor = [UIColor colorWithHexString:@"FFFFFF"];
    }else if ([level isEqualToString:@"4"]) {
        textColor = [UIColor colorWithHexString:@"2986F1"];
    }else if ([level isEqualToString:@"3"]) {
        textColor = [UIColor colorWithHexString:@"FFA800"];
    }else if ([level isEqualToString:@"2"]) {
        textColor = [UIColor colorWithHexString:@"FC7D0E"];
    }else if ([level isEqualToString:@"1"]) {
        textColor = [UIColor colorWithHexString:@"F62546"];
    }
    
    //紧急
    return textColor;
}
@end
