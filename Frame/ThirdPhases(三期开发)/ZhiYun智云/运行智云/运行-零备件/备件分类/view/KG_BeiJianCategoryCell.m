//
//  KG_BeiJianCategoryCell.m
//  Frame
//
//  Created by zhangran on 2020/7/31.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_BeiJianCategoryCell.h"

#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_BeiJianCategoryCell (){
    
}

@property (nonatomic ,strong) UILabel *firstLabel;

@property (nonatomic ,strong) UILabel *secondLabel;

@property (nonatomic ,strong) UILabel *thirdLabel;

@property (nonatomic ,strong) UILabel *fourthLabel;

@end

@implementation KG_BeiJianCategoryCell

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
    self.firstLabel = [[UILabel alloc]init];
    [self addSubview:self.firstLabel];
    self.firstLabel.text = @"--";
    self.firstLabel.font = [UIFont systemFontOfSize:14];
    self.firstLabel.font = [UIFont my_font:14];
    self.firstLabel.textAlignment = NSTextAlignmentLeft;
    self.firstLabel.textColor = [UIColor colorWithHexString:@"#004EC4"];
    [self.firstLabel sizeToFit];
    self.firstLabel.numberOfLines = 2;
    [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.mas_top);
        make.width.lessThanOrEqualTo(@110);
        make.height.equalTo(@50);
    }];
    
    
    self.secondLabel = [[UILabel alloc]init];
    [self addSubview:self.secondLabel];
    self.secondLabel.text = @"--";
    self.secondLabel.font = [UIFont systemFontOfSize:14];
    self.secondLabel.font = [UIFont my_font:14];
    self.secondLabel.textAlignment = NSTextAlignmentRight;
    self.secondLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    [self.secondLabel sizeToFit];
    self.secondLabel.numberOfLines = 2;
    [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_left).offset(SCREEN_WIDTH/2-30);
        
        make.top.equalTo(self.mas_top);
        make.width.lessThanOrEqualTo(@120);
        make.height.equalTo(@50);
    }];
    
    self.thirdLabel = [[UILabel alloc]init];
    [self addSubview:self.thirdLabel];
    self.thirdLabel.text = @"--";
    self.thirdLabel.font = [UIFont systemFontOfSize:14];
    self.thirdLabel.font = [UIFont my_font:14];
    self.thirdLabel.textAlignment = NSTextAlignmentLeft;
    self.thirdLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    [self.thirdLabel sizeToFit];
    self.thirdLabel.numberOfLines = 2;
    [self.thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.secondLabel.mas_right).offset(40);
        make.top.equalTo(self.mas_top);
        make.width.lessThanOrEqualTo(@70);
        make.height.equalTo(@50);
    }];
    
    
    self.fourthLabel = [[UILabel alloc]init];
    [self addSubview:self.fourthLabel];
    self.fourthLabel.text = @"--";
    self.fourthLabel.font = [UIFont systemFontOfSize:14];
    self.fourthLabel.font = [UIFont my_font:14];
    self.fourthLabel.textAlignment = NSTextAlignmentRight;
    self.fourthLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    [self.fourthLabel sizeToFit];
    self.fourthLabel.numberOfLines = 2;
    [self.fourthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-16);
        make.top.equalTo(self.mas_top);
        make.width.lessThanOrEqualTo(@120);
        make.height.equalTo(@50);
    }];
    
    UIView *lineImage = [[UIView alloc]initWithFrame:CGRectMake(16,49, SCREEN_WIDTH - 32, 1)];
    [self addSubview:lineImage];
    lineImage.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    
   
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.firstLabel.text = safeString(dataDic[@"name"]);
    
    self.secondLabel.text = safeString(dataDic[@"code"]);
    
    self.thirdLabel.text = safeString(dataDic[@"statusName"]);
    
    self.fourthLabel.text = safeString(dataDic[@"model"]);
    
}
@end
