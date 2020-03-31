//
//  FrameScrollListCell.m
//  Frame
//
//  Created by zhangran on 2020/3/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "FrameBottomCell.h"

@interface FrameBottomCell (){
    
    
    
}






@end
@implementation FrameBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
  
    [_iconImage release];
    [_titleLabel release];
    [_firstTitleLabel release];
    [_firstStatusLabel release];
    [_secondTitleLabel release];
    [_secondStatusLabel release];
    [_watchVideoButton release];
    [_firstNumLabel release];
    [_secondNumLabel release];
    [_thirdNumLabel release];
    [_fourthNumLabel release];
    [super dealloc];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    
}


- (IBAction)dasdasdsa:(id)sender {
    NSLog(@"1");
}

@end
