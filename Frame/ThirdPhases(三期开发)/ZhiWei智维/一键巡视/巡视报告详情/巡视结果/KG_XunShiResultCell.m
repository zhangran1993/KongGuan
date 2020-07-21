//
//  KG_XunShiResultCell.m
//  Frame
//
//  Created by zhangran on 2020/5/13.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_XunShiResultCell.h"
#import "KG_XunShiResultView.h"

@interface KG_XunShiResultCell(){
    
    
}
@property (nonatomic, strong) KG_XunShiResultView *resultView;
@end
@implementation KG_XunShiResultCell

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
    [self addSubview:self.resultView];
    self.resultView.textStringChangeBlock = ^(NSString * _Nonnull taskDescription) {
        if (self.textStringChangeBlock) {
            self.textStringChangeBlock(taskDescription);
        }
    };
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@124);
    }];
}
- (KG_XunShiResultView *)resultView {
    if (!_resultView) {
        _resultView = [[KG_XunShiResultView alloc]init];
      
    }
    return _resultView;
}
- (void)setTaskDescription:(NSString *)taskDescription {
    _taskDescription = taskDescription;
    self.resultView.taskDescription = taskDescription;
    
}

@end
