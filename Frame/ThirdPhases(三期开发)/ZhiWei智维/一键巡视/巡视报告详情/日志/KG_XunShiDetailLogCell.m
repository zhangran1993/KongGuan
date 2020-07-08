//
//  KG_XunShiResultCell.m
//  Frame
//
//  Created by zhangran on 2020/5/13.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_XunShiDetailLogCell.h"
#import "KG_XunShiLogView.h"

@interface KG_XunShiDetailLogCell(){
    
    
}
@property (nonatomic, strong) KG_XunShiLogView *logView;
@end
@implementation KG_XunShiDetailLogCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    if([super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        
        [self createUI];
    }
    
    return self;
}



- (void)createUI{
    [self addSubview:self.logView];
    [self.logView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@281);
    }];
}
- (KG_XunShiLogView *)logView {
    if (!_logView) {
        _logView = [[KG_XunShiLogView alloc]init];
      
    }
    return _logView;
}
- (void)setReceiveArr:(NSArray *)receiveArr {
    _receiveArr = receiveArr;
    self.logView.receiveArr = receiveArr;
}
- (void)setLogArr:(NSArray *)logArr {
    _logArr = logArr;
    self.logView.logArr = logArr;
}
@end
