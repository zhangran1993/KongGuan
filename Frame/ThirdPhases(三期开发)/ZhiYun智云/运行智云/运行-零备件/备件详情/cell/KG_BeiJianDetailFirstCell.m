//
//  KG_BeiJianDetailFirstCell.m
//  Frame
//
//  Created by zhangran on 2020/8/3.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_BeiJianDetailFirstCell.h"
#import "KG_BeiJianFirstView.h"

@interface KG_BeiJianDetailFirstCell (){
    
}
@property (nonatomic,strong)    KG_BeiJianFirstView     *firstView;

@end

@implementation KG_BeiJianDetailFirstCell

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
    topImage.image = [UIImage imageNamed:@"beijian_bgImage"];
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@(208));
        make.top.equalTo(self.mas_top);
    }];
    
    
    self.firstView = [[KG_BeiJianFirstView alloc]init];
    [self addSubview:self.firstView];
    [self.firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(self.mas_top).offset(NAVIGATIONBAR_HEIGHT +10 );
    }];
    self.firstView.layer.cornerRadius = 10.f;
    self.firstView.layer.masksToBounds = YES;
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.firstView.dataDic = dataDic;
}

- (void)setCategoryString:(NSString *)categoryString {
    _categoryString = categoryString;
    self.firstView.categoryString = categoryString;
}

- (void)setDeviceString:(NSString *)deviceString {
    _deviceString = deviceString;
    self.firstView.deviceStr = deviceString;
}
@end
