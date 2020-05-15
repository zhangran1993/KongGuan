//
//  KG_NewContentCell.m
//  Frame
//
//  Created by zhangran on 2020/4/27.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_NewContentTextCell.h"

@interface KG_NewContentTextCell ()<UITextViewDelegate>

@end

@implementation KG_NewContentTextCell

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
         [self registNotification];
    }
    
    return self;
}



- (void)createUI{
   
    
    self.iconImage = [[UIImageView alloc]init];
    [self addSubview:self.iconImage];
   
    self.iconImage.image = [UIImage imageNamed:@"must_starIcon"];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.mas_top).offset(24);
        make.width.height.equalTo(@7);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.text = @"设备选择";
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(10);
        make.width.equalTo(@200);
        make.centerY.equalTo(self.iconImage.mas_centerY);
    }];
    self.textView = [[UITextView alloc]init];
    self.textView.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
    self.textView.layer.cornerRadius = 6;
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.text = @"请输入巡视内容～";
    self.textView.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    self.textView.layer.masksToBounds = YES;
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.delegate = self;
    self.textView.textContainerInset = UIEdgeInsetsMake(15, 15, 5, 15);
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.top.equalTo(self.mas_top).offset(51);
        make.height.equalTo(@126);
    }];
}

- (void)selMethod:(UIButton *)button {
    
}

//将要进入编辑模式[开始编辑]
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"请输入巡视内容～"] ||[textView.text isEqualToString:@"请输入巡视结果～"]) {
        
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
        self.textString(textView.text,textView.tag);
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

@end
