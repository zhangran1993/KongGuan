//
//  KG_InstrumentationCell.m
//  Frame
//
//  Created by zhangran on 2020/9/22.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_InstrumentationCell.h"

@interface KG_InstrumentationCell (){
    
    
}
@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UIImageView *iconImage;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UILabel *typeTextLabel;

@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic,strong) UILabel *statusTextLabel;

@property (nonatomic,strong) UILabel *addressLabel;
@property (nonatomic,strong) UILabel *addressTextLabel;


@end

@implementation KG_InstrumentationCell

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
    
    self.bgView = [[UIView alloc]init];
    [self addSubview:self.bgView];
    self.bgView.backgroundColor = [UIColor colorWithHexString:@"#F3F7FC"];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.mas_top).offset(16);
        make.width.equalTo(@148);
        make.height.equalTo(@104);
    }];
    
    self.iconImage = [[UIImageView alloc]init];
    [self.bgView addSubview:self.iconImage];
    self.iconImage.image = [UIImage imageNamed:@""];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(8);
        make.top.equalTo(self.bgView.mas_top).offset(8);
        make.right.equalTo(self.bgView.mas_right).offset(-8);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-8);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
  
    self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.titleLabel.font = [UIFont my_font:16];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = @"";
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel sizeToFit];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.mas_top).offset(19);
    }];
    
    
    self.typeLabel = [[UILabel alloc]init];
    [self addSubview:self.typeLabel];
    self.typeLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.typeLabel.font = [UIFont systemFontOfSize:14];
    self.typeLabel.font = [UIFont my_font:14];
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
    [self addSubview:self.typeTextLabel];
    self.typeTextLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    self.typeTextLabel.font = [UIFont systemFontOfSize:14];
    self.typeTextLabel.font = [UIFont my_font:14];
    self.typeTextLabel.textAlignment = NSTextAlignmentRight;
    self.typeTextLabel.text = @"";
    self.typeTextLabel.numberOfLines = 1;
    [self.typeTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.width.equalTo(@200);
        make.centerY.equalTo(self.typeLabel.mas_centerY);
        make.height.equalTo(@20);
    }];
    
    
    self.statusLabel = [[UILabel alloc]init];
    [self addSubview:self.statusLabel];
    self.statusLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    self.statusLabel.font = [UIFont my_font:14];
    self.statusLabel.textAlignment = NSTextAlignmentLeft;
    self.statusLabel.text = @"状态:";
    self.statusLabel.numberOfLines = 1;
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_right).offset(10);
        make.width.equalTo(@80);
        make.top.equalTo(self.typeLabel.mas_bottom).offset(4);
        make.height.equalTo(@20);
    }];
    
    
    self.statusTextLabel = [[UILabel alloc]init];
    [self addSubview:self.statusTextLabel];
    self.statusTextLabel.textColor = [UIColor colorWithHexString:@"#004EC4"];
    self.statusTextLabel.font = [UIFont systemFontOfSize:14];
    self.statusTextLabel.font = [UIFont my_font:14];
    self.statusTextLabel.textAlignment = NSTextAlignmentRight;
    self.statusTextLabel.text = @"";
    self.statusTextLabel.numberOfLines = 1;
    [self.statusTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.width.equalTo(@200);
        make.centerY.equalTo(self.statusLabel.mas_centerY);
        make.height.equalTo(@20);
    }];
    
    
    self.addressLabel = [[UILabel alloc]init];
    [self addSubview:self.addressLabel];
    self.addressLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.addressLabel.font = [UIFont systemFontOfSize:14];
    self.addressLabel.font = [UIFont my_font:14];
    self.addressLabel.textAlignment = NSTextAlignmentLeft;
    self.addressLabel.text = @"存放地点:";
    self.addressLabel.numberOfLines = 1;
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_right).offset(10);
        make.width.equalTo(@80);
        make.top.equalTo(self.statusLabel.mas_bottom).offset(4);
        make.height.equalTo(@20);
    }];
    
    
    self.addressTextLabel = [[UILabel alloc]init];
    [self addSubview:self.addressTextLabel];
    self.addressTextLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    self.addressTextLabel.font = [UIFont systemFontOfSize:14];
    self.addressTextLabel.font = [UIFont my_font:14];
    self.addressTextLabel.textAlignment = NSTextAlignmentRight;
    self.addressTextLabel.text = @"";
    self.addressTextLabel.numberOfLines = 1;
    [self.addressTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.width.equalTo(@200);
        make.centerY.equalTo(self.addressLabel.mas_centerY);
        make.height.equalTo(@20);
    }];
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",WebNewHost,_dataDic[@"picture"]]]  ];
    
    self.titleLabel.text = safeString(dataDic[@"name"]);
    
    self.typeTextLabel.text = safeString(dataDic[@"model"]);
    
    NSString *status = safeString(dataDic[@"status"]);
    
    if ([status isEqualToString:@"depositAndDeposit"]) {
        self.statusTextLabel.text = @"库存中" ;
    }else if ([status isEqualToString:@"alreadyOutOfStore"]) {
        self.statusTextLabel.text = @"已出库" ;
    }

    
    self.addressTextLabel.text = safeString(dataDic[@"stockLocation"]);
    
}


@end
