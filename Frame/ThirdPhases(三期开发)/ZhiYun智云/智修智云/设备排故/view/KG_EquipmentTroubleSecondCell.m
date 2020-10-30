//
//  KG_FailureNoticeCell.m
//  Frame
//
//  Created by zhangran on 2020/10/21.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_EquipmentTroubleSecondCell.h"
#import "KG_EquipmentTroubleshootDetailCell.h"
@interface  KG_EquipmentTroubleSecondCell()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) UITableView     *tableView;

@property (nonatomic, strong) NSArray         *dataArray;

@property (nonatomic, strong) UIButton        *bottomBtn;

@property (nonatomic, strong) UIView          *footView;

@property (nonatomic, assign)     BOOL               isZhankai;

@end
@implementation KG_EquipmentTroubleSecondCell

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
    
    UIImageView *iconImage = [[UIImageView alloc]init];
    [self addSubview:iconImage];
    iconImage.image = [UIImage imageNamed:@"kg_icon_jishuziliao"];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@16);
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.mas_top).offset(17);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [self addSubview:titleLabel];
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"技术资料";
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconImage.mas_centerY);
        make.left.equalTo(iconImage.mas_right).offset(8);
        make.height.equalTo(@25);
        make.width.equalTo(@150);
    }];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(50);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}

//展开或收起
- (void)bottomButtonClick:(UIButton *)btn {
    
    self.isZhankai = !self.isZhankai;
    if (self.isZhankai) {
        [self.bottomBtn setTitle:@"收起" forState:UIControlStateNormal];
    }else {
        [self.bottomBtn setTitle:@"展开" forState:UIControlStateNormal];
    }
    if (self.bottomButtonBlock) {
        self.bottomButtonBlock(self.isZhankai);
    }
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count >3 &&self.isZhankai == NO) {
        return 3;
    }else if (self.dataArray.count >3 &&self.isZhankai == YES) {
        return self.dataArray.count;
    }
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KG_EquipmentTroubleshootDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_EquipmentTroubleshootDetailCell"];
    if (cell == nil) {
        cell = [[KG_EquipmentTroubleshootDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_EquipmentTroubleshootDetailCell"];
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dataDic = dic;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    NSDictionary *dic = self.dataArray[indexPath.row];
    if (self.pushToNextStep) {
        self.pushToNextStep(dic);
    }
    
}

- (void)setListArray:(NSArray *)listArray {
    _listArray = listArray;
    self.dataArray = listArray;
    if (listArray.count <=3) {
        [self.tableView.tableHeaderView removeFromSuperview];
        self.tableView.tableHeaderView = nil;
    }else {
        self.footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        
        self.bottomBtn = [[UIButton alloc]init];
        [self.footView addSubview:self.bottomBtn];
        [self.bottomBtn setTitle:@"展开" forState:UIControlStateNormal];
        [self.bottomBtn setTitleColor:[UIColor colorWithHexString:@""] forState:UIControlStateNormal];
        
       
        self.bottomBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        [self.bottomBtn setTitleColor:[UIColor colorWithHexString:@"#1860B0"] forState:UIControlStateNormal];
      
        [self.bottomBtn setImage:[UIImage imageNamed:@"zhankai"]  forState:UIControlStateNormal];
        if (self.isZhankai) {
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
        self.tableView.tableFooterView = self.footView;
       
    }
    [self.tableView reloadData];
}

@end
