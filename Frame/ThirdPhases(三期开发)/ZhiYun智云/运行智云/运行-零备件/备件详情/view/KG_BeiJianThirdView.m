//
//  KG_BeiJianThirdView.m
//  Frame
//
//  Created by zhangran on 2020/7/31.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_BeiJianThirdView.h"

@interface KG_BeiJianThirdView ()<UITextViewDelegate> {
    
    
}


@property (strong, nonatomic) UILabel *placeholderLabel;

@property (nonatomic,strong) UILabel *numLabel;

@property (nonatomic,strong) UITextView *textView;
@end

@implementation KG_BeiJianThirdView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
       
    }
    return self;
}
//初始化数据
- (void)initData {
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    UIImageView *iconImage = [[UIImageView alloc]init];
    [bgView addSubview:iconImage];
    iconImage.image = [UIImage imageNamed:@"beijian_remark"];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@16);
        make.left.equalTo(bgView.mas_left).offset(17);
        make.top.equalTo(bgView.mas_top).offset(16);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [bgView addSubview:titleLabel];
    titleLabel.text = @"备注";
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconImage.mas_centerY);
        make.left.equalTo(iconImage.mas_right).offset(7);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    
    UIButton *saveBtn = [[UIButton alloc]init];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [bgView addSubview:saveBtn];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [saveBtn setTitleColor:[UIColor colorWithHexString:@"#BABCC4"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveMethod:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn sizeToFit];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-19);
        make.centerY.equalTo(iconImage.mas_centerY);
        make.height.equalTo(@50);
        make.width.lessThanOrEqualTo(@80);
    }];
    
    
    UIView *textBgView = [[UIView alloc]init];
    textBgView.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
    [bgView addSubview:textBgView];
    [textBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImage.mas_bottom).offset(16);
        make.left.equalTo(bgView.mas_left).offset(16);
        make.right.equalTo(bgView.mas_right).offset(-16);
        make.height.equalTo(@121);
    }];
    
   
    
    
    
    
    self.textView = [[UITextView alloc]init];
    self.textView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.textView.layer.cornerRadius = 6;
//    self.textView.layer.borderWidth = 0.5;
    self.textView.delegate = self;
    self.textView.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
       
//    self.textView.layer.borderColor = [[UIColor colorWithHexString:@"#E6E8ED"] CGColor];
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.text = @"";
    self.textView.userInteractionEnabled = YES;
   
    self.textView.textColor = [UIColor colorWithHexString:@"#626470"];
    self.textView.layer.masksToBounds = YES;
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.delegate = self;
    self.textView.textAlignment = NSTextAlignmentLeft;
    //    self.textView.textContainerInset = UIEdgeInsetsMake(15, 15, 5, 15);
    [textBgView addSubview:self.textView];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textBgView.mas_left);
        make.right.equalTo(textBgView.mas_right);
        make.top.equalTo(textBgView.mas_top);
        make.bottom.equalTo(textBgView.mas_bottom);
       
    }];
    
    self.placeholderLabel = [[UILabel alloc]init];
    [textBgView addSubview:self.placeholderLabel];
    self.placeholderLabel.text = @"请填写备注内容";
   
    self.placeholderLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
    self.placeholderLabel.numberOfLines = 1;
    self.placeholderLabel.textAlignment = NSTextAlignmentLeft;
    self.placeholderLabel.font = [UIFont systemFontOfSize:14];
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(textBgView.mas_right).offset(-16);
        make.top.equalTo(textBgView.mas_top).offset(3);
        make.height.equalTo(@20);
        make.left.equalTo(textBgView.mas_left).offset(3);
    }];
    
    
    self.numLabel = [[UILabel alloc]init];
    [bgView addSubview:self.numLabel];
    self.numLabel.text = @"0/50";
    self.numLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    self.numLabel.font = [UIFont systemFontOfSize:14];
    self.numLabel.numberOfLines = 1;
    self.numLabel.textAlignment = NSTextAlignmentRight;
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(textBgView.mas_right).offset(-15);
        make.bottom.equalTo(textBgView.mas_bottom).offset(-13);
        make.width.equalTo(@80);
        make.height.equalTo(@20);
    }];
    
    
    
     
}
- (void)saveMethod:(UIButton *)btn {
    [self.textView resignFirstResponder];
    
    if (self.saveBlockMethod) {
        self.saveBlockMethod(self.textView.text);
    }
}


//将要进入编辑模式[开始编辑]
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
 
   
    textView.selectedRange = NSMakeRange(textView.text.length, 0);
    if([textView.text isEqualToString:@"请填写备注内容"] ||[textView.text isEqualToString:@"输入内容"]) {
        
        textView.text = @"";
    }
    return YES;
   
}
//当textView的内容发生改变的时候调用
- (void)textViewDidChange:(UITextView *)textView {
    
//    if (self.textStringChangeBlock) {
//        self.textStringChangeBlock(textView.text);
//    }
    if ([self.textView.text isEqualToString:@""]){
        self.placeholderLabel.hidden = NO;
    }else{
        self.placeholderLabel.hidden = YES;
    }
   
    
    NSString *ss = safeString(textView.text);
    if (ss.length>50) {
        ss = [ss substringToIndex:50];
    }
    self.textView.text = ss;
    self.numLabel.text = [NSString stringWithFormat:@"%lu/50",(unsigned long)ss.length];
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
  
}
- (void)setDescriptionStr:(NSString *)descriptionStr {
    _descriptionStr = descriptionStr;
    
    if ([safeString(descriptionStr) isEqualToString:@""]){
        self.placeholderLabel.hidden = NO;
    }else{
        self.placeholderLabel.hidden = YES;
    }
    if (safeString(descriptionStr).length == 0) {
        self.numLabel.text = @"0/50";
        self.textView.text = @"";
        return;
    }
    self.textView.text = safeString(descriptionStr);
    self.numLabel.text = [NSString stringWithFormat:@"%lu/50",(unsigned long)descriptionStr.length];
    
    
}
@end
