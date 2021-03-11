//
//  KG_FaultEventRecordSecondCell.m
//  Frame
//
//  Created by zhangran on 2020/10/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_FaultEventRecordSecondCell.h"
#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_FaultEventRecordSecondCell (){
    
    
}
@end

@implementation KG_FaultEventRecordSecondCell

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
    
    
    self.iconImage = [[UIImageView alloc]init];
    [self addSubview:self.iconImage];
    self.iconImage.layer.cornerRadius = 3.f;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@6);
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.mas_top).offset(18);
    }];
    
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.font = [UIFont my_font:14];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.width.equalTo(@200);
        make.left.equalTo(self.iconImage.mas_right).offset(14);
        make.centerY.equalTo(self.iconImage.mas_centerY);
    }];
    
    self.detailLabel = [[UILabel alloc]init];
    [self addSubview:self.detailLabel];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    self.detailLabel.font = [UIFont my_font:14];
    [self.detailLabel sizeToFit];
  
    self.detailLabel.numberOfLines = 0;
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
    }];

    
}

-(void)setLineSpace:(CGFloat)lineSpace withText:(NSString *)text inLabel:(UILabel *)label{
    if (!text || !label) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;  //设置行间距
    paragraphStyle.lineBreakMode = label.lineBreakMode;
    paragraphStyle.alignment = label.textAlignment;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    label.attributedText = attributedString;
}

- (void)setStr:(NSString *)str {
    _str = str;
    self.titleLabel.text = safeString(str);
}
- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
//    self.detailLabel.text = safeString(self.dataDic[@"implementationCase"]);
    
    NSString *str = safeString(self.dataDic[@"recordDescription"]);
        
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8.0; // 设置行间距
    paragraphStyle.alignment = NSTextAlignmentJustified; //设置两端对齐显示
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedStr.length)];
    
    self.detailLabel.attributedText = attributedStr;
    [self.detailLabel sizeToFit];
    //调用
//    [self setLineSpace:55.0f withText:safeString(self.dataDic[@"implementationCase"]) inLabel:self.detailLabel];

}
   
@end
