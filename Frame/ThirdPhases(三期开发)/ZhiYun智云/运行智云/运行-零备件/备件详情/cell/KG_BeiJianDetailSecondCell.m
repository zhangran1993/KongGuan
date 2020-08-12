//
//  KG_BeiJianDetailSecondCell.m
//  Frame
//
//  Created by zhangran on 2020/8/3.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_BeiJianDetailSecondCell.h"
#import "KG_BeiJianSecondView.h"

@interface KG_BeiJianDetailSecondCell (){

}

@property (nonatomic,strong)    KG_BeiJianSecondView    *secondView;
@end
@implementation KG_BeiJianDetailSecondCell

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
    self.secondView = [[KG_BeiJianSecondView alloc]init];
    [self addSubview:self.secondView];
    [self.secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(self.mas_top);
    }];
    self.secondView.layer.cornerRadius = 10.f;
    self.secondView.layer.masksToBounds = YES;
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.secondView.dataDic = dataDic;
}

@end
