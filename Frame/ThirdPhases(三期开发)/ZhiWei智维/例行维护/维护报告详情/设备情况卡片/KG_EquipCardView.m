//
//  KG_EquipCardView.m
//  Frame
//
//  Created by zhangran on 2020/6/16.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_EquipCardView.h"
#import "KG_EquipCardFirstCell.h"
#import "KG_EquipCardSecondCell.h"
#import "KG_EquipCardThirdCell.h"
#import "KG_OperationGuideViewController.h"
#import "KG_EquipCardFourthCell.h"
@interface KG_EquipCardView ()<UITableViewDataSource,UITableViewDelegate>{
    
}
@property (nonatomic,strong) UITableView *sliderTableView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView * statusImage;
@property (nonatomic,strong) UIButton * moreBtn;
@end

@implementation KG_EquipCardView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self addSubview:self.tableView];
    self.tableView.layer.shadowOffset = CGSizeMake(0,1);
    self.tableView.layer.shadowOpacity = 1;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.layer.shadowRadius = 3;
    self.tableView.layer.borderWidth = 0.5;
    self.tableView.layer.borderColor = [UIColor colorWithRed:239/255.0 green:240/255.0 blue:247/255.0 alpha:1.0].CGColor;
    self.tableView.layer.cornerRadius = 10;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(22);
        make.right.equalTo(self.mas_right).offset(-22);
        make.bottom.equalTo(self.mas_bottom).offset(-80);
    }];
    
    [self addSubview:self.sliderTableView];
    
    [self.sliderTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom);
        make.left.equalTo(self.mas_left).offset(22);
        make.right.equalTo(self.mas_right).offset(-22);
        make.height.equalTo(@44);
    }];
    
    
    
    
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
- (UITableView *)sliderTableView {
    if (!_sliderTableView) {
        _sliderTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _sliderTableView.delegate = self;
        _sliderTableView.dataSource = self;
        _sliderTableView.backgroundColor = self.backgroundColor;
        _sliderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _sliderTableView.scrollEnabled = NO;
        
    }
    return _sliderTableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.sliderTableView]) {
        return 1;
    }
    if(section == 0){
        return self.dataArray.count;
    }else {
        return 1;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 2) {
        NSString *str =  safeString(self.dataDic[@"operationalGuidelines"]);
        CGRect fontRect = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 64, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil];
        NSLog(@"%f",fontRect.size.height);
        return  fontRect.size.height +24;
    }else if (indexPath.section == 1) {
        NSString *str =  safeString(self.dataDic[@"remark"]);
        if (str.length == 0) {
            return 0;
        }
        return 40;
    }
     return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section  {
    
    if ([tableView isEqual:self.sliderTableView]) {
        UIView  *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
        return headView;
    }
    
    UIView  *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    
    NSString *str =  safeString(self.dataDic[@"remark"]);
    if (str.length == 0 && section == 1) {
        UIView  *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,0.001)];
        return headView;
    }
    
   
           
    if (section == 0) {
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.numberOfLines = 1;
        titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
        titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        [headView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headView.mas_left).offset(16);
            make.height.equalTo(@24);
            make.centerY.equalTo(headView.mas_centerY);
            make.right.equalTo(headView.mas_right).offset(-70);
        }];
        
        self.statusImage  = [[UIImageView alloc]init];
        [self.statusImage sizeToFit];
        self.statusImage.contentMode = UIViewContentModeScaleAspectFit;
        [headView addSubview:self.statusImage];
        [self.statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(headView.mas_right);
            make.centerY.equalTo(headView.mas_centerY);
            
            make.height.equalTo(@26);
        }];
        titleLabel.text = [NSString stringWithFormat:@"%@",safeString(self.dataDic[@"title"])];
        self.statusImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"状态标签-%@",[self getTaskStatus:safeString(self.taskStatus)]]];
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
        [headView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headView.mas_left).offset(16);
            make.right.equalTo(headView.mas_right).offset(-16);
            make.height.equalTo(@1);
            make.bottom.equalTo(headView.mas_bottom);
        }];
        
    }else if (section == 1) {
        
       
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.numberOfLines = 1;
        titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [headView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headView.mas_left).offset(16);
            make.height.equalTo(@24);
            make.centerY.equalTo(headView.mas_centerY);
            make.right.equalTo(headView.mas_right).offset(-70);
        }];
        titleLabel.text = @"备注";
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
        [headView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headView.mas_left).offset(16);
            make.right.equalTo(headView.mas_right).offset(-16);
            make.height.equalTo(@1);
            make.bottom.equalTo(headView.mas_bottom);
        }];
    }else if (section == 2) {
      
        UIImageView *iconImage = [[UIImageView alloc]init];
        [headView addSubview:iconImage];
        iconImage.image = [UIImage imageNamed:@"operaguide_icon"];
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headView.mas_left).offset(16);
            make.width.height.equalTo(@14);
            make.top.equalTo(headView.mas_top).offset(16);
            
        }];
        
        
        
        UILabel *titleLabel = [[UILabel alloc]init];
        [headView addSubview:titleLabel];
        titleLabel.text = @"操作指引";
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
        titleLabel.numberOfLines = 1;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImage.mas_right).offset(12.5);
            make.centerY.equalTo(headView.mas_centerY);
            make.width.equalTo(@200);
            make.height.equalTo(@24);
        }];
        
        self.moreBtn = [[UIButton alloc]init];
        [headView addSubview:self.moreBtn];
        [self.moreBtn addTarget:self action:@selector(moreMethod:) forControlEvents:UIControlEventTouchUpInside];
        [self.moreBtn setTitleColor:[UIColor colorWithHexString:@"#1860B0"] forState:UIControlStateNormal];
        self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.moreBtn setImage:[UIImage imageNamed:@"blue_jiantou"] forState:UIControlStateNormal];
        [self.moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        
        [self.moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0,85, 0, 0)];
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(headView.mas_right).offset(-20);
            make.centerY.equalTo(iconImage.mas_centerY  );
            make.width.equalTo(@100);
            make.height.equalTo(@(102 -44));
        }];
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
        [headView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headView.mas_left).offset(16);
            make.right.equalTo(headView.mas_right).offset(-16);
            make.height.equalTo(@1);
            make.bottom.equalTo(headView.mas_bottom);
        }];
        
    }else {
        
    }
    
    return headView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:self.sliderTableView]) {
        return 0.001;
    }
    if (section == 1) {
        NSString *str =  safeString(self.dataDic[@"remark"]);
        if (str.length == 0) {
            return 0.001;
        }
        return 44;
    }
    return 44;
}
- (void)moreMethod:(UIButton *)button {
    if (self.moreBlockMethod) {
        self.moreBlockMethod(self.dataDic);
    }
}


- (NSString *)getTaskStatus :(NSString *)status {
    NSString *ss = @"已完成";
    if ([status isEqualToString:@"0"]) {
        ss = @"待执行";
    }else if ([status isEqualToString:@"1"]) {
        ss = @"进行中";
    }else if ([status isEqualToString:@"2"]) {
        ss = @"已完成";
    }else if ([status isEqualToString:@"3"]) {
        ss = @"逾期未完成";
    }else if ([status isEqualToString:@"4"]) {
        ss = @"逾期完成";
    }else if ([status isEqualToString:@"5"]) {
        ss = @"待领取";
    }else if ([status isEqualToString:@"6"]) {
        ss = @"待指派";
    }
    return ss;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.sliderTableView]) {
        KG_EquipCardFourthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_EquipCardFourthCell"];
        if (cell == nil) {
            cell = [[KG_EquipCardFourthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_EquipCardFourthCell"];
        }
        cell.dataArray = self.dataArray;
        cell.totalNum = self.cardTotalNum;
        cell.selIndex = self.cardCurrNum;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if(indexPath.section == 0) {
        
        KG_EquipCardFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_EquipCardFirstCell"];
        if (cell == nil) {
            cell = [[KG_EquipCardFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_EquipCardFirstCell"];
        }
        NSDictionary *dic = self.dataArray[indexPath.row];
        cell.dic = dic;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if(indexPath.section == 1) {
        KG_EquipCardSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_EquipCardSecondCell"];
        if (cell == nil) {
            cell = [[KG_EquipCardSecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_EquipCardSecondCell"];
        }
         NSString *str = safeString(self.dataDic[@"remark"]);
        cell.str = str;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else if(indexPath.section == 2) {
        KG_EquipCardThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_EquipCardThirdCell"];
        if (cell == nil) {
            cell = [[KG_EquipCardThirdCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_EquipCardThirdCell"];
        }
        NSString *str = safeString(self.dataDic[@"operationalGuidelines"]);
        cell.str = str;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.dataArray = dataDic[@"childrens"];
    [self.tableView reloadData];
}

- (void)setTaskStatus:(NSString *)taskStatus {
    _taskStatus = taskStatus;
    
}

- (void)setCardCurrNum:(int)cardCurrNum {
    _cardCurrNum = cardCurrNum;
     [self.tableView reloadData];
}

- (void)setCardTotalNum:(int)cardTotalNum {
    _cardTotalNum = cardTotalNum;
    [self.tableView reloadData];
    
}
@end
