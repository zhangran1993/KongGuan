//
//  KG_BeiJianDetaiFourthCell.m
//  Frame
//
//  Created by zhangran on 2020/8/3.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_BeiJianDetaiFourthCell.h"
#import "KG_BeiJianFourthView.h"

@interface KG_BeiJianDetaiFourthCell (){
    
}
@property (nonatomic,strong)    KG_BeiJianFourthView    *fourthView;
@end

@implementation KG_BeiJianDetaiFourthCell

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
    self.fourthView = [[KG_BeiJianFourthView alloc]init];
    self.fourthView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.fourthView];
    [self.fourthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(self.mas_top);
    }];
    self.fourthView.layer.cornerRadius = 10.f;
    self.fourthView.layer.masksToBounds = YES;
}
- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.fourthView.dataDic = dataDic;
}

- (void)setLvliArr:(NSArray *)lvliArr {
    _lvliArr = lvliArr;
    self.fourthView.lvliArr = lvliArr;
    
    
    
}
@end
