//
//  KG_InstrumentationThirdCell.m
//  Frame
//
//  Created by zhangran on 2020/9/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_InstrumentationThirdCell.h"

@interface KG_InstrumentationThirdCell (){
    
    
}

@property (nonatomic ,strong)     UIView             *centerView;

@property (nonatomic ,strong)     UIImageView        *iconImage;

@property (nonatomic ,strong)     UILabel            *titleLabel;

@property (nonatomic ,strong)     UILabel            *detailLabel;


@end

@implementation KG_InstrumentationThirdCell

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
    
    self.centerView = [[UIView alloc]init];
    self.centerView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self addSubview:self.centerView];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    self.centerView.layer.cornerRadius = 10.f;
    self.centerView.layer.masksToBounds = YES;
//    self.centerView.layer.shadowOffset = CGSizeMake(0,2);
//    self.centerView.layer.shadowOpacity = 1;
//    self.centerView.layer.shadowRadius = 2;
//    
//    
    
    self.iconImage = [[UIImageView alloc]init];
    [self.centerView addSubview:self.iconImage];
    self.iconImage.image = [UIImage imageNamed:@"kg_confirm_guide"];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(15);
        make.top.equalTo(self.centerView.mas_top).offset(14);
       
        make.width.height.equalTo(@18);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = @"设备简介";
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(7);
        make.width.equalTo(@120);
        make.centerY.equalTo(self.iconImage.mas_centerY);
        make.height.equalTo(@45);
    }];
    
    
    self.detailLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.detailLabel];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    self.detailLabel.text = @"";
    self.detailLabel.numberOfLines = 0;
    [self.detailLabel sizeToFit];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.centerView.mas_right).offset(-16);
        make.left.equalTo(self.centerView.mas_left).offset(15);
        make.top.equalTo(self.iconImage.mas_bottom).offset(10);
        
    }];
    
}

- (void)setDataModel:(KG_InstrumentationDetailModel *)dataModel {
    _dataModel = dataModel;
    self.detailLabel.text = safeString(dataModel.introduce);
}
@end
