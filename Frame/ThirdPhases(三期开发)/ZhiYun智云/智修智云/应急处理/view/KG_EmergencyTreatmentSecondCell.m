//
//  KG_EmergencyTreatmentSecondCell.m
//  Frame
//
//  Created by zhangran on 2020/10/29.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_EmergencyTreatmentSecondCell.h"
#import "KG_BeiJianListCell.h"
@interface KG_EmergencyTreatmentSecondCell ()<UITableViewDelegate,UITableViewDataSource> {
    
}


@property (nonatomic,strong)    UITableView             *tableView;



@end

@implementation KG_EmergencyTreatmentSecondCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubviewsView];
    }
    return self;
}

- (void)createSubviewsView {
    
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    headView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    UIView *bgTopView = [[UIView alloc]init];
    [headView addSubview:bgTopView];
    bgTopView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [bgTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left);
        make.right.equalTo(headView.mas_right);
        make.height.equalTo(@10);
        make.top.equalTo(headView.mas_top);
    }];
    
    UIImageView *iconImage = [[UIImageView alloc]init];
    [headView addSubview:iconImage];
    iconImage.image = [UIImage imageNamed:@"kg_icon_beijianxinxi"];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left).offset(16);
        make.top.equalTo(headView.mas_top).offset(10+17);
        make.width.equalTo(@14);
        make.height.equalTo(@16);
    }];
    
    UILabel *topTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 84, 50)];
    [headView addSubview:topTitleLabel];
    topTitleLabel.text = @"备件信息";
    topTitleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    topTitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    topTitleLabel.numberOfLines = 1;
    topTitleLabel.backgroundColor = [UIColor clearColor];
    topTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    [topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconImage.mas_centerY);
        make.left.equalTo(iconImage.mas_right).offset(8);
        make.right.equalTo(headView.mas_right);
        make.height.equalTo(@30);
    }];
    
    self.tableView.tableHeaderView = headView;
    
    
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
  
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    if (section == 0) {
        if (self.secondTopDic.count) {
            NSArray *dataArr = self.secondTopDic[@"attachmentInfo"];
            if (dataArr.count) {
                return 1;
            }

            return 0;
        }
        return 0;
    }else {
        if (self.secondBotDic.count) {
            NSArray *otherArr = self.secondBotDic[@"attachmentInfo"];
            if (otherArr.count) {
                return 1;
            }

            return 0;
        }
        return 0;
   }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    
    if(indexPath.section == 0){
        if(self.secondTopDic.count) {
            NSArray *dataArr = self.secondTopDic[@"attachmentInfo"];
            if(dataArr.count == 0 &&self.secondTopDic.count >0) {
                return 45;
            }
            return dataArr.count *45 ;
        }
        return 45;


    }else {
        if(self.secondBotDic.count) {
            NSArray *otherArr = self.secondBotDic[@"attachmentInfo"];
            if(otherArr.count == 0 &&self.secondBotDic.count >0) {
                return 45;
            }
            return otherArr.count *45 ;
        }
        return 45;

    }

    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
    }else {
        
        
    }
   
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    KG_BeiJianListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_BeiJianListCell"];
    if (cell == nil) {
        cell = [[KG_BeiJianListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_BeiJianListCell"];
    }
    cell.didsel = ^(NSDictionary * _Nonnull dataDic, NSDictionary * _Nonnull totalDic) {

     
        if(self.pushToNextStep) {
            self.pushToNextStep(dataDic,totalDic);
        }
        
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {

        cell.totalDic =self.secondTopDic ;
        cell.dataDic = self.secondTopDic;
    }else {

        cell.totalDic =self.secondBotDic;
        cell.dataDic =self.secondBotDic;
    }


    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    UIView *topBgView = [[UIView alloc]init];
    topBgView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [topView addSubview:topBgView];
    [topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top);
        make.left.equalTo(topView.mas_left);
        make.right.equalTo(topView.mas_right);
        make.height.equalTo(@50);
    }];



    UIView *shuView = [[UIView alloc]init];
    [topBgView addSubview:shuView];
    shuView.layer.cornerRadius = 2.f;
    shuView.layer.masksToBounds = YES;
    shuView.backgroundColor = [UIColor colorWithRed:47/255.0 green:94/255.0 blue:209/255.0 alpha:1.0];
    [shuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).offset(16);
        make.width.equalTo(@3);
        make.height.equalTo(@15);
        make.centerY.equalTo(topBgView.mas_centerY);

    }];



    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 84, 50)];
    [topBgView addSubview:titleLabel];
    titleLabel.text = @"当前告警设备备件";
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    titleLabel.numberOfLines = 1;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top);
        make.left.equalTo(shuView.mas_right).offset(10);
        make.right.equalTo(topBgView.mas_right);
        make.height.equalTo(@50);
    }];




    UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 50, 84, 50)];
    [topView addSubview:firstLabel];
    firstLabel.text = @"备件所属设备";
    firstLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    firstLabel.font = [UIFont systemFontOfSize:14];
    firstLabel.numberOfLines = 1;
    firstLabel.textAlignment = NSTextAlignmentLeft;
    [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).offset(16);
        make.height.equalTo(@50);
        make.width.lessThanOrEqualTo(@120);
        make.top.equalTo(topBgView.mas_bottom);
    }];

    UILabel *secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 50, 84, 50)];
    [topView addSubview:secondLabel];
    secondLabel.text = @"备件类型";
    secondLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    secondLabel.font = [UIFont systemFontOfSize:14];
    secondLabel.numberOfLines = 1;
    secondLabel.textAlignment = NSTextAlignmentLeft;
    [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).offset(SCREEN_WIDTH/2- 30);
        make.height.equalTo(@50);
        make.width.lessThanOrEqualTo(@120);
        make.top.equalTo(topBgView.mas_bottom);
    }];


    UILabel *thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 50, 84, 50)];
    [topView addSubview:thirdLabel];
    thirdLabel.text = @"备件数量";
    thirdLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    thirdLabel.font = [UIFont systemFontOfSize:14];
    thirdLabel.numberOfLines = 1;
    thirdLabel.textAlignment = NSTextAlignmentRight;
    [thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView.mas_right).offset(-16);
        make.height.equalTo(@50);
        make.width.equalTo(@120);
        make.top.equalTo(topBgView.mas_bottom);
    }];

    if (section == 0) {
        titleLabel.text = @"当前告警设备备件";
    }else {
        titleLabel.text = @"其他备件";
    }

    return  topView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (void)setSecondTopArray:(NSArray *)secondTopArray {
    _secondTopArray = secondTopArray;
}

- (void)setSecondBotArray:(NSArray *)secondBotArray {
    _secondBotArray = secondBotArray;
}

- (void)setSecondTopDic:(NSDictionary *)secondTopDic {
    _secondTopDic = secondTopDic;
    [self.tableView reloadData];
}

- (void)setSecondBotDic:(NSDictionary *)secondBotDic {
    _secondBotDic = secondBotDic;
    [self.tableView reloadData];
}

@end
