//
//  KG_PowerOnView.m
//  Frame
//
//  Created by zhangran on 2020/4/3.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_NiControlView.h"
@interface  KG_NiControlView(){
    
}
@property (nonatomic, strong) UIButton *bgBtn ;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextView *textView;
@end
@implementation KG_NiControlView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
        [self setupDataSubviews];
        
    }
    return self;
}
//初始化数据
- (void)initData {
    self.dataArray = [NSArray arrayWithObjects:@"", nil];
}

//创建视图
-(void)setupDataSubviews
{
    //按钮背景 点击消失
    self.bgBtn = [[UIButton alloc]init];
    [self addSubview:self.bgBtn];
    [self.bgBtn setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    self.bgBtn.alpha = 0.46;
    [self.bgBtn addTarget:self action:@selector(buttonClickMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    UIView *centerView = [[UIView alloc] init];
    centerView.frame = CGRectMake(52.5,209,270,242);
    centerView.backgroundColor = [UIColor whiteColor];
    centerView.layer.cornerRadius = 12;
    centerView.layer.masksToBounds = YES;
    [self addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@270);
        make.height.equalTo(@242);
    }];
    UIButton *centerBtn = [[UIButton alloc]init];
    [centerView addSubview:centerBtn];
    [centerBtn setBackgroundColor:[UIColor clearColor]];
    [centerBtn setTitle:@"" forState:UIControlStateNormal];
    [centerBtn addTarget:self action:@selector(buttonClickMethod:) forControlEvents:UIControlEventTouchUpInside];
    [centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerView.mas_top);
        make.left.equalTo(centerView.mas_left);
        make.right.equalTo(centerView.mas_right);
        make.bottom.equalTo(centerView.mas_bottom);
    }];
    //
    UILabel *titleLabel = [[UILabel alloc]init];
    [centerView addSubview:titleLabel];
    titleLabel.text = @"反向控制操作";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.numberOfLines = 1;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(centerView.mas_centerX);
        make.top.equalTo(centerView.mas_top).offset(18);
        make.width.equalTo(@200);
        make.height.equalTo(@24);
    }];
    
    
    UILabel *passPromptLabel = [[UILabel alloc]init];
    [centerView addSubview:passPromptLabel];
    passPromptLabel.text = @"密码（必填）";
    passPromptLabel.font = [UIFont systemFontOfSize:12];
    passPromptLabel.textAlignment = NSTextAlignmentLeft;
    passPromptLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    passPromptLabel.numberOfLines = 1;
    [passPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView.mas_left).offset(15);
        make.top.equalTo(centerView.mas_top).offset(60);
        make.width.equalTo(@100);
        make.height.equalTo(@17);
    }];
    
    UIView *passView = [[UIView alloc]init];
    passView.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1.0];
    [centerView addSubview:passView];
    [passView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView.mas_left).offset(16);
        make.top.equalTo(passPromptLabel.mas_bottom).offset(5);
        make.height.equalTo(@24);
        make.right.equalTo(centerView.mas_right).offset(-19);
    }];
    
    self.textField = [[UITextField alloc]init];
    [passView addSubview:self.textField];
    self.textField.textColor = [UIColor colorWithHexString:@"#24252A"];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(passView);
    }];
    self.textField.font = [UIFont systemFontOfSize:14];
    self.textField.placeholder = @"请输入密码";
     [self.textField addTarget:self action:@selector(textEdit:) forControlEvents:UIControlEventEditingChanged];
    UILabel *remarkPromptLabel = [[UILabel alloc]init];
    [centerView addSubview:remarkPromptLabel];
    remarkPromptLabel.text = @"备注（选填）";
    remarkPromptLabel.font = [UIFont systemFontOfSize:12];
    remarkPromptLabel.textAlignment = NSTextAlignmentLeft;
    remarkPromptLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    remarkPromptLabel.numberOfLines = 1;
    [remarkPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView.mas_left).offset(15);
        make.top.equalTo(passView.mas_bottom).offset(9);
        make.width.equalTo(@100);
        make.height.equalTo(@17);
    }];
    
    UIView *remarkView = [[UIView alloc]init];
    [centerView addSubview:remarkView];
    remarkView.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
    
    [remarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView.mas_left).offset(16);
        make.right.equalTo(centerView.mas_right).offset(-19);
       
        make.height.equalTo(@50);
        make.top.equalTo(remarkPromptLabel.mas_bottom).offset(4);
    }];
    self.textView = [[UITextView alloc]init];
    [remarkView addSubview:self.textView];
    self.textView.textColor = [UIColor colorWithHexString:@"#24252A"];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.width.equalTo(remarkView);
    }];
    self.textView.text = @"请输入备注";
    self.textView.backgroundColor =  [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1.0];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#E6E8ED"];
    [centerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remarkView.mas_bottom).offset(12);
        make.height.equalTo(@1);
        make.width.equalTo(@270);
        make.left.equalTo(centerView.mas_left);
        make.right.equalTo(centerView.mas_right);
    }];
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [centerView addSubview:cancelBtn];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelMethod:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView.mas_left);
        make.top.equalTo(lineView.mas_bottom);
        make.width.equalTo(@135);
        make.height.equalTo(@43);
    }];
    
    
    UIButton *confirmBtn = [[UIButton alloc]init];
    [centerView addSubview:confirmBtn];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmMethod:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(centerView.mas_right);
        make.top.equalTo(lineView.mas_bottom);
        make.width.equalTo(@135);
        make.height.equalTo(@43);
    }];
    UIView *botLine = [[UIView alloc]init];
    botLine.backgroundColor = [UIColor colorWithHexString:@"#E6E8ED"];
    [centerView addSubview:botLine];
    [botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(centerView.mas_centerX);
        make.bottom.equalTo(centerView.mas_bottom);
        make.width.equalTo(@1);
        make.height.equalTo(@43);
    }];
}
//取消
- (void)cancelMethod:(UIButton *)button {
    self.hidden = YES;
    [self.textField resignFirstResponder];
    [self.textView resignFirstResponder];
}
//确定
- (void)confirmMethod:(UIButton *)button {
    self.hidden = YES;
    if(self.confirmMethod) {
        self.confirmMethod();
    }
    [self.textField resignFirstResponder];
    [self.textView resignFirstResponder];
}
- (void)buttonClickMethod:(UIButton *)button {
//    self.hidden = YES;
    [self.textField resignFirstResponder];
    [self.textView resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    
    [textField resignFirstResponder];
    
    return YES;
    
}
- (void)selMethod:(UIButton *)button {
    
}

//将要进入编辑模式[开始编辑]
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"请输入备注"] ) {
        
        textView.text = @"";
    }
    return YES;
   
}
//当textView的内容发生改变的时候调用
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length >0) {
        
    }else {
        textView.text = @"";
    }
    if (self.textString) {
        self.textString(textView.text);
    }
    
}
- (void)registNotification
{
    //弹出键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //收起键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}
 
-(void)keyboardWillShow:(NSNotification *)notification
{
//这样就拿到了键盘的位置大小信息frame，然后根据frame进行高度处理之类的信息
     CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
      
      //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
      CGFloat offset = kbHeight;
      
      // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
      double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
      
      //将视图上移计算好的偏移
//      if(offset > 0) {
//          [UIView animateWithDuration:duration animations:^{
//              self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
//          }];
//      }
}

/**
 *  键盘将要隐藏
 *
 *  @param notification 通知
 */
-(void)keyboardWillHidden:(NSNotification *)notification
{
     double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//      //视图下沉恢复原状
//      [UIView animateWithDuration:duration animations:^{
//          self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//      }];
   
}
-(void)dealloc
{
    [super dealloc];
    //第一种方法.这里可以移除该控制器下的所有通知
    //移除当前所有通知
    NSLog(@"移除了所有的通知");
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.hideKeyBoard) {
        self.hideKeyBoard();
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    return YES;
    
}
- (void)textEdit:(UITextField *)textField {
    if ([textField isEqual:self.textField]) {
        if (self.textFieldString) {
            self.textFieldString(textField.text);
        }
    }
}

@end
