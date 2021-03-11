//
//  KG_OperationGuideDetailCell.m
//  Frame
//
//  Created by zhangran on 2020/9/25.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_EmergencyTreatmentFileDetailCell.h"

#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_EmergencyTreatmentFileDetailCell (){
    
    
}

@property (nonatomic,strong)     UILabel        *titieLabel;

@property (nonatomic,strong)     UIImageView    *bgImage;

@end

@implementation KG_EmergencyTreatmentFileDetailCell

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
        self.contentView.backgroundColor = self.backgroundColor;
        [self createSubviewsView];
    }
    return self;
}

- (void)createSubviewsView {
    
    self.titieLabel = [[UILabel alloc]init];
    [self addSubview:self.titieLabel];
    [self.titieLabel sizeToFit];
    self.titieLabel.numberOfLines = 0;
    self.titieLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    self.titieLabel.font = [UIFont systemFontOfSize:14];
    self.titieLabel.font = [UIFont my_font:14];
    [self.titieLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(32);
        make.right.equalTo(self.mas_right).offset(-32);
        make.top.equalTo(self.mas_top);
    }];
    
    self.bgImage = [[UIImageView alloc]init];
    [self addSubview:self.bgImage];
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titieLabel.mas_bottom).offset(11);
        make.left.equalTo(self.mas_left).offset(32);
        make.right.equalTo(self.mas_right).offset(-32);
        make.height.equalTo(@200);
        
        
    }];
    
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    [self.bgImage sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",WebNewHost,safeString(dataDic[@"url"])]] ];
    
    self.titieLabel.text = safeString(dataDic[@"method"]);
}
@end
