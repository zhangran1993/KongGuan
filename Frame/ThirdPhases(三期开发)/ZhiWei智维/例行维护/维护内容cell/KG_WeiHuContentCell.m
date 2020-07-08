//
//  KG_XunShiReportDetailCell.m
//  Frame
//
//  Created by zhangran on 2020/5/13.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_WeiHuContentCell.h"
#import "KG_WeiHuContentView.h"

@interface KG_WeiHuContentCell (){
    
}
@property (nonatomic,strong) KG_WeiHuContentView *weihuContentView;
@end
@implementation KG_WeiHuContentCell

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
    
    
    self.weihuContentView = [[KG_WeiHuContentView alloc]init];
    [self addSubview:self.weihuContentView];
    [self.weihuContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}

- (void)setModel:(taskDetail *)model {
    _model = model;
    self.weihuContentView.detailModel = model;
}
@end
