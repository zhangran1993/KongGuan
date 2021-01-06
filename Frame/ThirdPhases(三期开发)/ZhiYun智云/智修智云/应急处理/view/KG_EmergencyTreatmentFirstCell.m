//
//  KG_EmergencyTreatmentFirstCell.m
//  Frame
//
//  Created by zhangran on 2020/10/29.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_EmergencyTreatmentFirstCell.h"
#import "KG_EquipmentTroubleshootDetailCell.h"
#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_EmergencyTreatmentFirstCell ()<UITableViewDelegate,UITableViewDataSource> {
    
}


@property (nonatomic,strong)    UITableView             *topTableView;



@property (nonatomic, strong) UIButton        *bottomBtn;

@property (nonatomic, strong) UIView          *footView;

@end

@implementation KG_EmergencyTreatmentFirstCell

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
    [self createTopView];
}

- (void)createTopView {
    
    NSInteger height = 50 + self.topArray.count *50;
    if (self.topArray.count >3) {
        height = 50 + 50 *3 +44;
    }
    
    
    [self addSubview:self.topTableView];
    [self.topTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    headView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    UIView *bgTopView = [[UIView alloc]init];
    [headView addSubview:bgTopView];
    bgTopView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [bgTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left);
        make.right.equalTo(headView.mas_right);
        make.height.equalTo(@10);
        make.top.equalTo(headView.mas_top);
    }];
    
    UIImageView *iconImage = [[UIImageView alloc]init];
    [headView addSubview:iconImage];
    iconImage.image = [UIImage imageNamed:@"kg_icon_yingjicaozuo"];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left).offset(6);
        make.top.equalTo(headView.mas_top).offset(10+17);
        make.width.equalTo(@14);
        make.height.equalTo(@16);
    }];
    
    UILabel *topTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 84, 50)];
    [headView addSubview:topTitleLabel];
    topTitleLabel.text = @"应急操作指引提醒";
    topTitleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    topTitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    topTitleLabel.font = [UIFont my_font:16];
    topTitleLabel.numberOfLines = 1;
    topTitleLabel.backgroundColor = [UIColor clearColor];
    topTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    [topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconImage.mas_centerY);
        make.left.equalTo(iconImage.mas_right).offset(8);
        make.right.equalTo(headView.mas_right);
        make.height.equalTo(@30);
    }];
    
    self.topTableView.tableHeaderView = headView;
    
    
    
    self.footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    self.bottomBtn = [[UIButton alloc]init];
    [self.footView addSubview:self.bottomBtn];
    [self.bottomBtn setTitle:@"展开" forState:UIControlStateNormal];
    [self.bottomBtn setTitleColor:[UIColor colorWithHexString:@""] forState:UIControlStateNormal];
    
    
    self.bottomBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [self.bottomBtn setTitleColor:[UIColor colorWithHexString:@"#1860B0"] forState:UIControlStateNormal];
    self.bottomBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 70, 0, 0);
    [self.bottomBtn setImage:[UIImage imageNamed:@"zhankai"]  forState:UIControlStateNormal];
    if (self.isZhanKai) {
        [self.bottomBtn setImage:[UIImage imageNamed:@"shouqi_icon"] forState:UIControlStateNormal];
        [self.bottomBtn setTitle:@"收起" forState:UIControlStateNormal];
    }
    
    
    
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.footView.mas_left);
        make.right.equalTo(self.footView.mas_right);
        make.top.equalTo(self.footView.mas_top);
        make.bottom.equalTo(self.footView.mas_bottom);
    }];
    [self.bottomBtn addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.topTableView.tableFooterView = self.footView;
    
    [self.topTableView reloadData];
    
    
}


- (void)bottomButtonClick :(UIButton *)btn {
    self.isZhanKai = !self.isZhanKai;
    if (self.isZhanKai) {
        NSInteger height = 50 + self.topArray.count *50 +50;
        
        [self.topTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(height));
        }];
    }else {
        NSInteger height = 50 + self.topArray.count *50;
        if (self.topArray.count >3) {
            height = 50 + 50 *3 +44;
        }
        [self.topTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(height));
        }];
    }
    
    if (self.topArray.count <=3) {
        [self.topTableView.tableFooterView removeFromSuperview];
        self.topTableView.tableFooterView = nil;
    }else {
        
        //        [self.topTableView.tableFooterView removeFromSuperview];
        //        self.topTableView.tableFooterView = nil;
        //        self.footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        //
        //        self.bottomBtn = [[UIButton alloc]init];
        //        [self.footView addSubview:self.bottomBtn];
        //        [self.bottomBtn setTitle:@"展开" forState:UIControlStateNormal];
        //        [self.bottomBtn setTitleColor:[UIColor colorWithHexString:@""] forState:UIControlStateNormal];
        //
        //
        //        self.bottomBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        //        [self.bottomBtn setTitleColor:[UIColor colorWithHexString:@"#1860B0"] forState:UIControlStateNormal];
        //
        //        [self.bottomBtn setImage:[UIImage imageNamed:@"zhankai"]  forState:UIControlStateNormal];
        //        if (self.isZhanKai) {
        //            [self.bottomBtn setImage:[UIImage imageNamed:@"shouqi_icon"] forState:UIControlStateNormal];
        //            [self.bottomBtn setTitle:@"收起" forState:UIControlStateNormal];
        //        }
        //
        //
        //
        //        [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.left.equalTo(self.footView.mas_left);
        //            make.right.equalTo(self.footView.mas_right);
        //            make.top.equalTo(self.footView.mas_top);
        //            make.bottom.equalTo(self.footView.mas_bottom);
        //        }];
        //        [self.bottomBtn addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        //        self.topTableView.tableFooterView = self.footView;
        //
        
        [self.bottomBtn setTitle:@"展开" forState:UIControlStateNormal];
        [self.bottomBtn setImage:[UIImage imageNamed:@"zhankai"]  forState:UIControlStateNormal];
        if (self.isZhanKai) {
            [self.bottomBtn setImage:[UIImage imageNamed:@"shouqi_icon"] forState:UIControlStateNormal];
            [self.bottomBtn setTitle:@"收起" forState:UIControlStateNormal];
        }
        
        
    }
    
    
    [self.topTableView reloadData];
    
    if (self.zhanKaiMethod) {
        self.zhanKaiMethod(self.isZhanKai);
    }
}


- (UITableView *)topTableView {
    if (!_topTableView) {
        _topTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _topTableView.delegate = self;
        _topTableView.dataSource = self;
        _topTableView.backgroundColor = self.backgroundColor;
        _topTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _topTableView.scrollEnabled = NO;
        
    }
    return _topTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if(self.topArray.count >0) {
        return 1;
    }
    return 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (self.isZhanKai == NO) {
        if (self.topArray.count >3) {
            return 3;
        }else {
            return self.topArray.count;
        }
    }else {
        return self.topArray.count;
    }
    return self.topArray.count;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 50;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.topArray[indexPath.row];
    if(self.pushToNextStep) {
        self.pushToNextStep(dic);
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:self.topTableView]) {
        KG_EquipmentTroubleshootDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_EquipmentTroubleshootDetailCell"];
        if (cell == nil) {
            cell = [[KG_EquipmentTroubleshootDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_EquipmentTroubleshootDetailCell"];
        }
        NSDictionary *dic = self.topArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataDic = dic;
        
        return cell;
    }
    
    
    return nil;
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    return topView;
}





- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}


- (void)setTopArray:(NSArray *)topArray {
    _topArray =topArray;
    [self.topTableView reloadData];
}

@end
