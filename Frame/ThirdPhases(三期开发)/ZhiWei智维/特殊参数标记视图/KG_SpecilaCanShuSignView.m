//
//  KG_OnsiteInspectionView.m
//  Frame
//
//  Created by zhangran on 2020/6/10.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_SpecilaCanShuSignView.h"
#import "KG_OnsiteInspectionCell.h"
@interface KG_SpecilaCanShuSignView()<UITextViewDelegate>{
    
}
@property (nonatomic, strong)  UITableView        *tableView;

@property (nonatomic, strong)  NSArray            *dataArray;

@property (nonatomic, strong)  UIButton           *bgBtn ;

@property (nonatomic, strong)  UITextField        *textField;

@property (nonatomic, strong)  UITextView         *textView;

@property (nonatomic, strong)  UIView             *centerView;

@property (nonatomic, strong)  NSDictionary       *dataDic;

@property (nonatomic, strong)  UILabel *  placeholderLabel;

@end
@implementation KG_SpecilaCanShuSignView

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
    self.centerView = [[UIView alloc] init];
    self.centerView.frame = CGRectMake(52.5,209,270,164);
    self.centerView.backgroundColor = [UIColor whiteColor];
    self.centerView.layer.cornerRadius = 12;
    self.centerView.layer.masksToBounds = YES;
    [self addSubview:self.centerView];
  
    NSInteger height = 164;
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset((SCREEN_HEIGHT -270)/2);
        make.left.equalTo(self.mas_left).offset((SCREEN_WIDTH - 270)/2);
        make.width.equalTo(@270);
        make.height.equalTo(@(height));
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [self.centerView addSubview:titleLabel];
    titleLabel.text = @"特殊参数标记";
    titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.numberOfLines = 1;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerView.mas_centerX);
        make.top.equalTo(self.centerView.mas_top);
        make.width.equalTo(@270);
        make.height.equalTo(@48);
    }];
    UIView *textBgView = [[UIView alloc]init];
    textBgView.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
    [self.centerView addSubview:textBgView];
    [textBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerView.mas_top).offset(48);
        make.left.equalTo(self.centerView.mas_left).offset(16);
        make.right.equalTo(self.centerView.mas_right).offset(-16);
        make.height.equalTo(@60);
    }];
    
    self.textView = [[UITextView alloc]init];
    self.textView.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
    self.textView.layer.cornerRadius = 6;
    self.textView.layer.borderWidth = 0.5;
    self.textView.delegate = self;
    self.textView.layer.borderColor = [[UIColor colorWithHexString:@"#E6E8ED"] CGColor];
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
    self.placeholderLabel.text = @"请填写特殊标记的原因";
       self.placeholderLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
       self.placeholderLabel.numberOfLines = 1;
       self.placeholderLabel.textAlignment = NSTextAlignmentLeft;
       self.placeholderLabel.font = [UIFont systemFontOfSize:14];
       [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
           make.right.equalTo(textBgView.mas_right).offset(-16);
           make.top.equalTo(textBgView.mas_top).offset(5);
           make.height.equalTo(@20);
           make.left.equalTo(textBgView.mas_left).offset(3);
       }];
    
   
      UIView *lineView = [[UIView alloc]init];
      lineView.backgroundColor = [UIColor colorWithHexString:@"#E6E8ED"];
      [self.centerView addSubview:lineView];
      [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.equalTo(self.centerView.mas_bottom).offset(-44);
          make.height.equalTo(@1);
          make.width.equalTo(@270);
          make.left.equalTo(self.centerView.mas_left);
          make.right.equalTo(self.centerView.mas_right);
      }];
      
      UIButton *cancelBtn = [[UIButton alloc]init];
      [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
      [self.centerView addSubview:cancelBtn];
      cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
      [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
      [cancelBtn addTarget:self action:@selector(cancelMethod:) forControlEvents:UIControlEventTouchUpInside];
      [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self.centerView.mas_left);
          make.top.equalTo(lineView.mas_bottom);
          make.width.equalTo(@135);
          make.height.equalTo(@43);
      }];
      
      
      UIButton *confirmBtn = [[UIButton alloc]init];
      [self.centerView addSubview:confirmBtn];
      [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
      [confirmBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
      [confirmBtn addTarget:self action:@selector(confirmMethod:) forControlEvents:UIControlEventTouchUpInside];
      [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
          make.right.equalTo(self.centerView.mas_right);
          make.top.equalTo(lineView.mas_bottom);
          make.width.equalTo(@135);
          make.height.equalTo(@43);
      }];
      UIView *botLine = [[UIView alloc]init];
      botLine.backgroundColor = [UIColor colorWithHexString:@"#E6E8ED"];
      [self.centerView addSubview:botLine];
      [botLine mas_makeConstraints:^(MASConstraintMaker *make) {
          make.centerX.equalTo(self.centerView.mas_centerX);
          make.bottom.equalTo(self.centerView.mas_bottom);
          make.width.equalTo(@1);
          make.height.equalTo(@43);
      }];
}

//取消
- (void)cancelMethod:(UIButton *)button {
    self.hidden = YES;
    [self.textView resignFirstResponder];
}
//确定
- (void)confirmMethod:(UIButton *)button {
    if (self.saveBlockMethod) {
        self.saveBlockMethod(self.textView.text);
    }
    [self.textView resignFirstResponder];
    self.hidden = YES;
}
- (void)buttonClickMethod:(UIButton *)button {
    self.hidden = YES;
   
    [self.textView resignFirstResponder];
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
   
    
//    NSString *ss = safeString(textView.text);
//    if (ss.length>50) {
//        ss = [ss substringToIndex:50];
//    }
//    self.textView.text = ss;
   
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    if (text.length >=50) {
        return  NO;
    }
    return YES;
    
}

@end
