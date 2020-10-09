//
//  KG_InstrumentationDetailCell.m
//  Frame
//
//  Created by zhangran on 2020/9/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_InstrumentationDetailFirstCell.h"

@interface KG_InstrumentationDetailFirstCell (){
    
}

@property (nonatomic ,strong)     UIView          *centerView;

@property (nonatomic ,strong)     UIView          *bgView;

@property (nonatomic,strong)      UIImageView     *iconImage;

@property (nonatomic,strong)      UILabel         *titleLabel;

@property (nonatomic,strong)      UILabel         *typeLabel;//型号

@property (nonatomic,strong)      UILabel         *typeTextLabel;

@property (nonatomic,strong)      UILabel         *codeLabel;//编码

@property (nonatomic,strong)      UILabel         *codeTextLabel;

@property (nonatomic,strong)      UILabel         *partLabel;//部件号

@property (nonatomic,strong)      UILabel         *partTextLabel;

@property (nonatomic,strong)      UILabel         *statusLabel;//状态

@property (nonatomic,strong)      UILabel         *statusTextLabel;
 


@end

@implementation KG_InstrumentationDetailFirstCell

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
        make.top.equalTo(self.mas_top).offset(5);
        make.height.equalTo(@170);
    }];
    self.centerView.layer.cornerRadius = 10.f;
    self.centerView.layer.masksToBounds = YES;
    self.centerView.layer.shadowOffset = CGSizeMake(0,2);
    self.centerView.layer.shadowOpacity = 1;
    self.centerView.layer.shadowRadius = 2;
    
    
    self.titleLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = @"无线电综合测试仪";
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(16);
        make.right.equalTo(self.centerView.mas_right).offset(-15);
        make.top.equalTo(self.centerView.mas_top);
        make.height.equalTo(@48);
    }];
    
    self.bgView = [[UIView alloc]init];
    self.bgView.backgroundColor = [UIColor colorWithHexString:@"#F3F7FC"];
    [self.centerView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(16);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.width.equalTo(@148);
        make.height.equalTo(@104);
    }];
    self.bgView.layer.cornerRadius = 6.f;
    self.bgView.layer.masksToBounds = YES;
   

    self.iconImage = [[UIImageView alloc]init];
    [self.bgView addSubview:self.iconImage];
    self.iconImage.image = [UIImage imageNamed:@""];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(8);
        make.top.equalTo(self.bgView.mas_top).offset(8);
        make.right.equalTo(self.bgView.mas_right).offset(-8);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-8);
    }];
    
    
    
    self.typeLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.typeLabel];
    self.typeLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.typeLabel.font = [UIFont systemFontOfSize:14];
    self.typeLabel.textAlignment = NSTextAlignmentLeft;
    self.typeLabel.text = @"型号:";
    self.typeLabel.numberOfLines = 1;
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_right).offset(10);
        make.width.equalTo(@80);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.height.equalTo(@20);
    }];
    
    self.typeTextLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.typeTextLabel];
    self.typeTextLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    self.typeTextLabel.font = [UIFont systemFontOfSize:14];
    self.typeTextLabel.textAlignment = NSTextAlignmentRight;
    self.typeTextLabel.text = @"";
    self.typeTextLabel.numberOfLines = 1;
    [self.typeTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.centerView.mas_right).offset(-15);
        make.width.equalTo(@200);
        make.centerY.equalTo(self.typeLabel.mas_centerY);
        make.height.equalTo(@20);
    }];
    
    
    self.codeLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.codeLabel];
    self.codeLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.codeLabel.font = [UIFont systemFontOfSize:14];
    self.codeLabel.textAlignment = NSTextAlignmentLeft;
    self.codeLabel.text = @"编码:";
    self.codeLabel.numberOfLines = 1;
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_right).offset(10);
        make.width.equalTo(@80);
        make.top.equalTo(self.typeLabel.mas_bottom).offset(8);
        make.height.equalTo(@20);
    }];
    
    self.codeTextLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.codeTextLabel];
    self.codeTextLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    self.codeTextLabel.font = [UIFont systemFontOfSize:14];
    self.codeTextLabel.textAlignment = NSTextAlignmentRight;
    self.codeTextLabel.text = @"";
    self.codeTextLabel.numberOfLines = 1;
    [self.codeTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.centerView.mas_right).offset(-15);
        make.width.equalTo(@200);
        make.centerY.equalTo(self.codeLabel.mas_centerY);
        make.height.equalTo(@20);
    }];
    
    self.partLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.partLabel];
    self.partLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.partLabel.font = [UIFont systemFontOfSize:14];
    self.partLabel.textAlignment = NSTextAlignmentLeft;
    self.partLabel.text = @"部件号:";
    self.partLabel.numberOfLines = 1;
    [self.partLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_right).offset(10);
        make.width.equalTo(@80);
        make.top.equalTo(self.codeLabel.mas_bottom).offset(8);
        make.height.equalTo(@20);
    }];
    
    self.partTextLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.partTextLabel];
    self.partTextLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    self.partTextLabel.font = [UIFont systemFontOfSize:14];
    self.partTextLabel.textAlignment = NSTextAlignmentRight;
    self.partTextLabel.text = @"";
    self.partTextLabel.numberOfLines = 1;
    [self.partTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.centerView.mas_right).offset(-15);
        make.width.equalTo(@200);
        make.centerY.equalTo(self.partLabel.mas_centerY);
        make.height.equalTo(@20);
    }];
    
    
    self.statusLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.statusLabel];
    self.statusLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    self.statusLabel.textAlignment = NSTextAlignmentLeft;
    self.statusLabel.text = @"状态:";
    self.statusLabel.numberOfLines = 1;
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_right).offset(10);
        make.width.equalTo(@80);
        make.top.equalTo(self.partLabel.mas_bottom).offset(4);
        make.height.equalTo(@20);
    }];
    
    
    self.statusTextLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.statusTextLabel];
    self.statusTextLabel.textColor = [UIColor colorWithHexString:@"#004EC4"];
    self.statusTextLabel.font = [UIFont systemFontOfSize:14];
    self.statusTextLabel.textAlignment = NSTextAlignmentRight;
    self.statusTextLabel.text = @"";
    self.statusTextLabel.numberOfLines = 1;
    [self.statusTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.centerView.mas_right).offset(-15);
        make.width.equalTo(@200);
        make.centerY.equalTo(self.statusLabel.mas_centerY);
        make.height.equalTo(@20);
    }];

}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    
}

- (void)setDataModel:(KG_InstrumentationDetailModel *)dataModel {
    _dataModel = dataModel;
    
    self.titleLabel.text = safeString(dataModel.name);
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",WebNewHost,safeString(dataModel.picture)]]];
    
    self.typeTextLabel.text = safeString(dataModel.model);
    
    self.codeTextLabel.text = safeString(dataModel.code);
    
    self.partTextLabel.text = safeString(dataModel.manufactor);
    
    NSString *status = safeString(dataModel.status);
    
    if ([status isEqualToString:@"depositAndDeposit"]) {
        self.statusTextLabel.text = @"库存中" ;
    }else if ([status isEqualToString:@"alreadyOutOfStore"]) {
        self.statusTextLabel.text = @"已出库" ;
    }

    
}
@end
