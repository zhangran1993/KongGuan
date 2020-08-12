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
    self.firstView = [[KG_BeiJianFirstView alloc]init];
    [self addSubview:self.firstView];
    [self.firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(self.mas_top);
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
