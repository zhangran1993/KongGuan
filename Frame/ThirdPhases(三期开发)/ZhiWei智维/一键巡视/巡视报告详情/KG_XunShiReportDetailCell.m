//
//  KG_XunShiReportDetailCell.m
//  Frame
//
//  Created by zhangran on 2020/5/13.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_XunShiReportDetailCell.h"
#import "KG_XunShiRadarView.h"

@interface KG_XunShiReportDetailCell (){
    
}
@property (nonatomic,strong) KG_XunShiRadarView *radarView;
@end
@implementation KG_XunShiReportDetailCell

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
    
    
    self.radarView = [[KG_XunShiRadarView alloc]init];
    [self addSubview:self.radarView];
    [self.radarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}

- (void)setModel:(taskDetail *)model {
    _model = model;
    self.radarView.detailModel = model;
}
@end
