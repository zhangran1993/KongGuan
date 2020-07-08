//
//  KG_ChooseSystemHeaderView.m
//  Frame
//
//  Created by zhangran on 2020/6/17.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_ChooseSystemHeaderView.h"

@interface KG_ChooseSystemHeaderView (){
    
    
}

@end

@implementation KG_ChooseSystemHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH -32, self.frame.size.height)];
        [self addSubview:self.titleLabel];
        self.titleLabel.text = @"1";
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
        self.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        
        
    }
    return self;
}


@end
