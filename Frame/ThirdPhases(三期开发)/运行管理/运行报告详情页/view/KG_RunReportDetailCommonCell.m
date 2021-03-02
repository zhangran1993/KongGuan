//
//  KG_RunReportDetailCommonCell.m
//  Frame
//
//  Created by zhangran on 2020/6/2.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RunReportDetailCommonCell.h"

@interface KG_RunReportDetailCommonCell ()<UITextViewDelegate>{
    
    
}


@end

@implementation KG_RunReportDetailCommonCell

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
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(26);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(self.mas_height);
        make.top.equalTo(self.mas_top);
    }];
    
    self.textView = [[UITextView alloc]init];
    self.textView.textAlignment = NSTextAlignmentLeft;
    self.textView.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
    self.textView.textColor = [UIColor colorWithHexString:@"#626470"];
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.delegate = self;
    [bgView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left);
        make.right.equalTo(bgView.mas_right);
        make.top.equalTo(bgView.mas_top);
        make.bottom.equalTo(bgView.mas_bottom);
    }];
    self.textView.userInteractionEnabled = NO;
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    [topView setBarStyle:UIBarStyleBlack];
    
    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
    [doneButton release];
    [btnSpace release];
    [helloButton release];
    
    [topView setItems:buttonsArray];
    [self.textView setInputAccessoryView:topView];
}
-(IBAction)dismissKeyBoard
{
    [self.textView resignFirstResponder];
}

- (void)setString:(NSString *)string {
    _string = string;
    self.textView.text = safeString(string);
    
    
}
//将要进入编辑模式[开始编辑]
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    return YES;
    
}

//当textView的内容发生改变的时候调用
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length >0) {
        
    }else {
        textView.text = @"";
    }
    if (textView.text.length >0) {
        if (self.textString) {
            self.textString(textView.text);
        }
    }
    
    
}
@end
