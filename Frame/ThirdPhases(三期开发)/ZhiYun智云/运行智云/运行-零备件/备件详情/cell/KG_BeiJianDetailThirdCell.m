//
//  KG_BeiJianDetailThirdCell.m
//  Frame
//
//  Created by zhangran on 2020/8/3.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_BeiJianDetailThirdCell.h"
#import "KG_BeiJianThirdView.h"

@interface KG_BeiJianDetailThirdCell (){
    
}
@property (nonatomic,strong)    KG_BeiJianThirdView     *thirdView;
@end
@implementation KG_BeiJianDetailThirdCell

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
    self.thirdView = [[KG_BeiJianThirdView alloc]init];
    self.thirdView.backgroundColor =[UIColor whiteColor];
    [self addSubview:self.thirdView];
    [self.thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(self.mas_top);
    }];
    self.thirdView.layer.cornerRadius = 10.f;
    self.thirdView.layer.masksToBounds = YES;
    self.thirdView.saveBlockMethod = ^(NSString * _Nonnull str) {
        if (self.saveBlockMethod) {
            self.saveBlockMethod(str);
        }
    };
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.thirdView.dataDic = dataDic;
}

- (void)setDescriptionStr:(NSString *)descriptionStr {
    _descriptionStr = descriptionStr;
    self.thirdView.descriptionStr = descriptionStr;
    
}
@end
