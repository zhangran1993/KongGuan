//
//  KG_CaseLibraryDetailFirstCell.m
//  Frame
//
//  Created by zhangran on 2020/10/15.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_CaseLibraryDetailFirstCell.h"

@interface KG_CaseLibraryDetailFirstCell () {
    
}

@property (nonatomic ,strong)     UIView          *centerView;

@property (nonatomic ,strong)     UIView          *bgView;

@property (nonatomic ,strong)     UILabel         *titleLabel;

@property (nonatomic ,strong)     UIImageView     *iconImage;

@property (nonatomic ,strong)     UILabel         *malfunLabel;

@property (nonatomic ,strong)     UILabel         *malfunTextLabel;

@property (nonatomic ,strong)     UILabel         *rightLabel;
@end

@implementation KG_CaseLibraryDetailFirstCell

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
    
    
    UIImageView *topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT +44)];
    [self addSubview:topImage1];
    [topImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@(NAVIGATIONBAR_HEIGHT +44));
        make.top.equalTo(self.mas_top);
    }];
    
    
    topImage1.backgroundColor  =[UIColor whiteColor];
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 208)];
    [self addSubview:topImage];
    topImage.backgroundColor  =[UIColor colorWithHexString:@"#F6F7F9"];
    topImage.image = [UIImage imageNamed:@"kg_anliku_bgImage"];
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@(208));
        make.top.equalTo(self.mas_top);
    }];
    
    
    
    self.centerView = [[UIView alloc]init];
    self.centerView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self addSubview:self.centerView];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.top.equalTo(self.mas_top).offset(5).offset(NAVIGATIONBAR_HEIGHT);
        make.height.equalTo(@170);
    }];
    self.centerView.layer.cornerRadius = 10.f;
    self.centerView.layer.masksToBounds = YES;
//    self.centerView.layer.shadowOffset = CGSizeMake(0,2);
//    self.centerView.layer.shadowOpacity = 1;
//    self.centerView.layer.shadowRadius = 2;
    
    
    self.titleLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = @"UPS";
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(16);
        make.width.equalTo(@200);
        make.top.equalTo(self.centerView.mas_top);
        make.height.equalTo(@48);
    }];
    
    self.bgView = [[UIView alloc]init];
    self.bgView.backgroundColor = [UIColor colorWithHexString:@"#F3F7FC"];
    [self.centerView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(16);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.width.equalTo(@116);
        make.height.equalTo(@106);
    }];
    self.bgView.layer.cornerRadius = 6.f;
    self.bgView.layer.masksToBounds = YES;
    
    
    self.iconImage = [[UIImageView alloc]init];
    [self.bgView addSubview:self.iconImage];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left);
        make.right.equalTo(self.bgView.mas_right);
        make.top.equalTo(self.bgView.mas_top);
        make.bottom.equalTo(self.bgView.mas_bottom);
    }];
    
    self.malfunTextLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.malfunTextLabel];
    self.malfunTextLabel.textColor = [UIColor colorWithHexString:@"#F11B3D"];
    [self.malfunTextLabel sizeToFit];
    self.malfunTextLabel.numberOfLines = 1;
    self.malfunTextLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [self.malfunTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.centerView.mas_right).offset(-15);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.height.equalTo(@22);
    }];
    
    self.malfunLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.malfunLabel];
    self.malfunLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    [self.malfunLabel sizeToFit];
    self.malfunLabel.text = @"故障等级:";
    self.malfunLabel.numberOfLines = 1;
    self.malfunLabel.textAlignment = NSTextAlignmentRight;
    self.malfunLabel.font = [UIFont systemFontOfSize:14];
    [self.malfunLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.malfunTextLabel.mas_left).offset(-5);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.height.equalTo(@22);
    }];
    
    self.rightLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.rightLabel];
    self.rightLabel.textColor = [UIColor colorWithHexString:@"#636571"];
    self.rightLabel.font = [UIFont systemFontOfSize:14];
    self.rightLabel.textAlignment = NSTextAlignmentLeft;
    [self.rightLabel sizeToFit];
    self.rightLabel.numberOfLines = 4;
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(12);
        make.right.equalTo(self.centerView.mas_right).offset(-15);
        make.top.equalTo(self.malfunLabel.mas_bottom).offset(22);
    }];
  
    
}


- (void)setDataModel:(KG_CaseLibraryDetailModel *)dataModel {
    _dataModel = dataModel;
    self.titleLabel.text = safeString(dataModel.equipmentCategoryName);

    [self.iconImage sd_setImageWithURL:[NSURL URLWithString: [WebNewHost stringByAppendingString:safeString(dataModel.picture)]] ];
    
    self.malfunTextLabel.text = [self getLevelStr:safeString(dataModel.grade)];
    
    self.rightLabel.text = safeString(dataModel.name);
    
    
}

- (NSString *)getLevelStr:(NSString *)ss {
    NSString *levelStr = @"";
    if ([ss containsString:@"one"]) {
        levelStr = @"I级";
    }else if ([ss containsString:@"two"]) {
        levelStr = @"II级";
    }else if ([ss containsString:@"three"]) {
        levelStr = @"III级";
    }else if ([ss containsString:@"four"]) {
        levelStr = @"IV级";
    }else if ([ss containsString:@"five"]) {
        levelStr = @"V级";
    }
    return levelStr;

}
@end
