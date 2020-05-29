//
//  KG_ResultPromptViewController.m
//  Frame
//
//  Created by zhangran on 2020/5/20.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_ResultPromptViewController.h"
#import "KG_ResultPromptCell.h"
@interface KG_ResultPromptViewController ()<UITextViewDelegate>

@property (nonatomic ,strong) UIView *resultView;
@property (nonatomic ,strong) UITextView *textView ;
@property (nonatomic ,strong) NSMutableArray *btnArr;
@end

@implementation KG_ResultPromptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [self initViewData];
    [self createNaviTopView];
    [self createTopView];
    
}

- (NSMutableArray *)btnArr {
    if(!_btnArr){
        
        _btnArr = [[NSMutableArray alloc]init];
    }
    return _btnArr;
}
- (void)initViewData {
    
}
- (void)createTopView {
    
    self.resultView = [[UIView alloc]init];
    self.resultView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:self.resultView];
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(11);
        make.height.equalTo(@327);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [self.resultView addSubview:titleLabel];
    titleLabel.text = @"处理描述";
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.resultView.mas_left).offset(16);
        make.top.equalTo(self.resultView.mas_top).offset(13);
        make.width.equalTo(@120);
        make.height.equalTo(@22);
    }];
    
    UIImageView *bgImage = [[UIImageView alloc]init];
    [self.resultView addSubview:bgImage];
    bgImage.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.resultView.mas_left).offset(16);
        make.right.equalTo(self.resultView.mas_right).offset(-15);
        make.top.equalTo(titleLabel.mas_bottom).offset(13);
        make.height.equalTo(@214);
    }];
    
    self.textView = [[UITextView alloc]init];
    self.textView.delegate = self;
    [self.resultView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImage.mas_top).offset(13);
        make.left.equalTo(bgImage.mas_left).offset(16);
        make.right.equalTo(bgImage.mas_right).offset(-17);
        make.bottom.equalTo(bgImage.mas_bottom).offset(-13);
    }];
    self.textView.textColor = [UIColor colorWithHexString:@"#7C7E86"];
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
    NSDictionary *dic = self.model.info;
    
    NSString *remark = safeString(dic[@"recordDescription"]);
    
    self.textView.text = remark;
    
    for (int i = 0; i<self.model.labels.count; i++) {
        NSString *ss = self.model.labels[i];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(16 +i*(78 +11 ),277 , 78, 34)];
        [self.resultView addSubview:btn];
        [btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [btn setTitle:safeString(ss) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.layer.cornerRadius = 4;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = [[UIColor colorWithHexString:@"#EDEEF5"] CGColor];
        btn.layer.borderWidth = 1;
        btn.tag = i;
        [btn setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
        [btn addTarget:self action:@selector(buttonMethod:) forControlEvents:UIControlEventTouchUpInside];
        [_btnArr addObject:btn];
    }
    
    
}

- (void)buttonMethod:(UIButton *)button {
    for (int i = 0; i<self.btnArr.count; i++) {
        UIButton *btn = self.btnArr[i];
        if (btn.tag ==button.tag) {
            [btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
        }else {
            [btn setTitleColor:[UIColor colorWithHexString:@"#B0B6C6"] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor colorWithHexString:@"#EDEEF5"]];
        }
        
    }
    
}

//创建导航栏视图
-  (void)createNaviTopView {
    UIButton *leftButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButon.frame = CGRectMake(0,0,FrameWidth(60),FrameWidth(60));
    [leftButon setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
    [leftButon setContentEdgeInsets:UIEdgeInsetsMake(0, - FrameWidth(20), 0, FrameWidth(20))];
    //button.alignmentRectInsetsOverride = UIEdgeInsetsMake(0, offset, 0, -(offset));
    [leftButon addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc]initWithCustomView:leftButon];
    self.navigationItem.leftBarButtonItem = fixedButton;
    
    UIButton *rightButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightButon.frame = CGRectMake(0,0,FrameWidth(40),FrameWidth(40));
    [rightButon setTitle:@"保存" forState:UIControlStateNormal];
    rightButon.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButon setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    [rightButon addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightfixedButton = [[UIBarButtonItem alloc]initWithCustomView:rightButon];
    self.navigationItem.rightBarButtonItem = rightfixedButton;
  
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = [NSString stringWithFormat:@"处理描述"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FontSize(18),NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#24252A"]}] ;
    
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.translucent = NO;
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (UIImage*)createImageWithColor: (UIColor*) color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save {
    
    if (self.textString) {
        self.textString(self.textView.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
  
}

- (void)setModel:(KG_GaoJingDetailModel *)model {
    _model = model;
  
}
//当textView的内容发生改变的时候调用
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length >0) {
        
    }else {
        textView.text = @"";
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
