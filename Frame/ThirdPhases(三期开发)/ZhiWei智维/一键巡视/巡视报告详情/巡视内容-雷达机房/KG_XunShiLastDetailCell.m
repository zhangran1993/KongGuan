//
//  KG_XunShiLastDetailCell.m
//  Frame
//
//  Created by zhangran on 2020/11/19.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_XunShiLastDetailCell.h"
#import "KG_UpdateSegmentControl.h"
#import "KG_SelectCardTypeView.h"
#import "KG_SpecialNoneDataView.h"
#import "KG_SpecilaCanShuSignView.h"

#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_XunShiLastDetailCell ()<UITextViewDelegate> {
    
}

@property (nonatomic,strong)    NSDictionary               *modelDic;

@property (nonatomic,strong)    UIView                     *selectView;//选择框的视图
@property (nonatomic,strong)    UIButton                   *selectBtn;
@property (nonatomic, strong)   KG_SelectCardTypeView      *alertView;//选择框点击弹出的视图
@property (nonatomic,strong)    UILabel                    *selectTitleLabel;
@property (nonatomic,strong)    UIImageView                *selectImageView;

@property (nonatomic,strong)    UIView                     *segmentView;//左右栏视图
@property (nonatomic,strong)    UISegmentedControl         *segmentedControl;

@property (nonatomic,strong)    UIView                     *charsetView;//字符显示视图
@property (nonatomic,strong)    UIButton                   *charsetQushiBtn;//趋势图按钮
@property (nonatomic,strong)    UIImageView                *charsetWarnImageView;//字符label
@property (nonatomic,strong)    UILabel                    *charsetTitleLabel;//字符label

@property (nonatomic,strong)    UIView                     *textInputView;//输入字符视图
@property (nonatomic,strong)    UITextView                 *textView;

@property (nonatomic,strong)    UIView                     *specialContentView;//特殊参数内容显示视图
@property (nonatomic,strong)    UILabel                    *specialContentTitleLabel;//
@property (nonatomic,strong)    UILabel                    *specialContentDetailLabel;//

@property (nonatomic,strong)    UIView                     *specialView;//特殊参数标记视图
@property (nonatomic,strong)    UIButton                   *specialButton;//
@property (nonatomic,strong)    UIView                     *redPromptView;//红色感叹号视图

@property (nonatomic, strong)   UILabel                    *titleLabel;

@property (nonatomic, strong)   KG_SpecialNoneDataView     *promptSignView;

@property (nonatomic, strong)   KG_SpecilaCanShuSignView   *signView;

@end

@implementation KG_XunShiLastDetailCell

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
    
    [self createCommonView];
    //创建选择视图,单选
    [self createSelectView];
    //创建视图 segment
    [self createSegmentView];
    //创建文字视图 数值型
    [self createCharsetView];
    //创建输入视图 输入型
    [self createTextInputView];
    
    //创建特殊参数视图view
    [self createSpecialContentTextView];
    self.promptSignView = [[KG_SpecialNoneDataView alloc]init];
    [self addSubview:self.promptSignView];
    self.promptSignView.hidden = YES;
    [self.promptSignView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.redPromptView.mas_right).offset(-10);
        make.height.equalTo(@27);
        make.width.equalTo(@115);
    }];
    
}

//创建特殊参数视图view
- (void)createSpecialContentTextView{
    self.specialContentView = [[UIView alloc]init];
    [self addSubview:self.specialContentView];
    self.specialContentView.hidden = YES;
    self.specialContentView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    
    self.specialContentView.layer.cornerRadius = 4;
    self.specialContentView.layer.masksToBounds = YES;
    [self.specialContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self.mas_left).offset(50);
        make.right.equalTo(self.mas_right).offset(-32);
        make.height.equalTo(@57);
    }];
    
    self.specialContentTitleLabel = [[UILabel alloc]init];
    [self.specialContentView addSubview:self.specialContentTitleLabel];
    self.specialContentTitleLabel.text = @"A相输入电压特殊参数标记";
    self.specialContentTitleLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.specialContentTitleLabel.font = [UIFont systemFontOfSize:12];
    self.specialContentTitleLabel.font = [UIFont my_font:12];
    self.specialContentTitleLabel.numberOfLines = 1;
    self.specialContentTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.specialContentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.specialContentView.mas_top).offset(10);
        make.left.equalTo(self.specialContentView.mas_left).offset(9.5);
        make.right.equalTo(self.specialContentView.mas_right).offset(-20);
        make.height.equalTo(@12);
    }];
    
    self.specialContentDetailLabel = [[UILabel alloc]init];
    [self.specialContentView addSubview:self.specialContentDetailLabel];
    self.specialContentDetailLabel.text = @"电压过高";
    self.specialContentDetailLabel.textColor = [UIColor colorWithHexString:@"#FFB428"];
    self.specialContentDetailLabel.font = [UIFont systemFontOfSize:12];
    self.specialContentDetailLabel.font = [UIFont my_font:12];
    self.specialContentDetailLabel.numberOfLines = 1;
    self.specialContentDetailLabel.textAlignment = NSTextAlignmentLeft;
    [self.specialContentDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.specialContentTitleLabel.mas_bottom).offset(9.5);
        make.left.equalTo(self.specialContentView.mas_left).offset(9.5);
        make.right.equalTo(self.specialContentView.mas_right).offset(-20);
        make.height.equalTo(@12);
    }];
}

//创建公共视图区
- (void)createCommonView {
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor =[UIColor colorWithHexString:@"#626470"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.font = [UIFont my_font:14];
    [self.titleLabel sizeToFit];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(4);
        make.left.equalTo(self.mas_left).offset(49.5);
        make.height.equalTo(@32);
        make.width.lessThanOrEqualTo(@150);
    }];
    
    //数值未取到红色感叹号
    [self createRedPromptView];
    
    //特殊参数标记
    [self createSpecialView];
    
}
//特殊参数标记视图
- (void)createSpecialView {
    
    self.specialView = [[UIView alloc]init];
    [self addSubview:self.specialView];
    [self.specialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-16);
        make.width.height.equalTo(@32);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
    self.specialView.userInteractionEnabled = NO;
    
    //特殊参数标记的按钮
    self.specialButton = [[UIButton alloc]init];
    [self.specialView addSubview:self.specialButton];
    [self.specialButton setImage:[UIImage imageNamed:@"kg_grayStar"] forState:UIControlStateNormal];
    [self.specialButton addTarget:self action:@selector(specialMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.specialButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.specialView.mas_right);
        make.width.height.equalTo(@32);
        make.centerY.equalTo(self.specialView.mas_centerY);
    }];
}

//数值为空时显示
- (void)createRedPromptView {
    
    self.redPromptView = [[UIView alloc]init];
    [self addSubview:self.redPromptView];
    [self.redPromptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.left.equalTo(self.titleLabel.mas_right).offset(18);
        make.height.equalTo(@32);
        make.width.lessThanOrEqualTo(@32);
    }];
    
    UIButton *redPromptBtn = [[UIButton alloc]init];
    [self.redPromptView addSubview:redPromptBtn];
    [redPromptBtn addTarget:self action:@selector(promptMethod:)
           forControlEvents:UIControlEventTouchUpInside];
    [redPromptBtn setImage:[UIImage imageNamed:@"prompt_redIcon"] forState:UIControlStateNormal];
    [redPromptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.redPromptView.mas_centerY);
        make.left.equalTo(self.redPromptView.mas_left);
        make.height.equalTo(@32);
        make.width.lessThanOrEqualTo(@32);
    }];
}

//复选栏视图创建
- (void)createSelectView {
    
    self.selectView = [[UIView alloc]init];
    [self addSubview:self.selectView];
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.specialView.mas_left);
        make.height.equalTo(@32);
        make.width.equalTo(@160);
    }];
    
    self.selectBtn = [[UIButton alloc]init];
    [self.selectBtn setTitleColor:[UIColor colorWithHexString:@"#626470"] forState:UIControlStateNormal];
    self.selectBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [self.selectBtn addTarget:self action:@selector(selectButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    self.selectBtn.userInteractionEnabled = NO;
    [self.selectView addSubview:self.selectBtn];
    //    self.selectBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 90, 0, 0);
    //    [self.selectBtn setImage:[UIImage imageNamed:@"common_right"] forState:UIControlStateNormal];
    //    [self.selectBtn sizeToFit];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.selectView.mas_centerY);
        make.right.equalTo(self.selectView.mas_right);
        make.height.equalTo(@24);
        make.width.equalTo(@120);
    }];
    
    self.selectImageView = [[UIImageView alloc]init];
    [self.selectView addSubview:self.selectImageView];
    self.selectImageView.image = [UIImage imageNamed:@"common_right"];
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.selectView.mas_centerY);
        make.right.equalTo(self.selectView.mas_right);
        make.height.equalTo(@14);
        make.width.equalTo(@14);
    }];
    
    self.selectTitleLabel = [[UILabel alloc]init];
    [self.selectView addSubview:self.selectTitleLabel];
    self.selectTitleLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    self.selectTitleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.selectTitleLabel.font = [UIFont my_font:14];
    self.selectTitleLabel.textAlignment = NSTextAlignmentRight;
    [self.selectTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.selectView.mas_centerY);
        make.right.equalTo(self.selectImageView.mas_left).offset(-2);
        make.height.equalTo(@32);
        make.width.equalTo(@80);
    }];
}

//复选栏视图创建
- (void)createSegmentView {
    
    self.segmentView = [[UIView alloc]init];
    [self addSubview:self.segmentView];
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.specialView.mas_right).offset(-14);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.height.equalTo(@32);
        make.width.equalTo(@160);
    }];
    
    NSArray *array = [NSArray arrayWithObjects:@"正常",@"不正常", nil];
    
    self.segmentedControl = [[KG_UpdateSegmentControl alloc]initWithItems:array];
    self.segmentedControl.frame = CGRectMake(SCREEN_WIDTH - 32 -84, 8,84,24);
    
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF"]}forState:UIControlStateSelected];
    
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#2F5ED1"],NSFontAttributeName:[UIFont boldSystemFontOfSize:10.0f]}forState:UIControlStateNormal];
    [self.segmentView addSubview:self.segmentedControl];
    
    self.segmentedControl.tintColor = [UIColor colorWithHexString:@"#2F5ED1"];
    self.segmentedControl.layer.borderWidth = 1;                   //    边框宽度，重新画边框，若不重新画，可能会出现圆角处无边框的情况
    self.segmentedControl.layer.borderColor = [UIColor colorWithHexString:@"#2F5ED1"].CGColor; //     边框颜色
    [self.segmentedControl setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]]
                                     forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segmentedControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    
    [self.segmentedControl setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#2F5ED1"]]
                                     forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self.segmentedControl sizeToFit];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.segmentView.mas_right).offset(-16);
        make.centerY.equalTo(self.segmentView.mas_centerY);
        
        make.height.equalTo(@24);
    }];
}

- (void)change:(UISegmentedControl *)sender {
    NSLog(@"测试");
    self.segmentedControl.selectedSegmentIndex = sender.selectedSegmentIndex;
    if (sender.selectedSegmentIndex == 0) {
        NSLog(@"1");
    }else if (sender.selectedSegmentIndex == 1){
        NSLog(@"2");
    }else if (sender.selectedSegmentIndex == 2){
        NSLog(@"3");
    }else if (sender.selectedSegmentIndex == 3){
        NSLog(@"4");
    }
    NSMutableDictionary *toDic = [NSMutableDictionary dictionary];
    
    NSDictionary *resultDic  = [UserManager shareUserManager].resultDic;
    [toDic addEntriesFromDictionary:resultDic];
    NSDictionary *dd = [self.dataDic[@"childrens"] firstObject];
    
    NSString *infoId = safeString(dd[@"parentId"]);
    NSString *value = safeString(dd[@"value"]) ;
    
    if (value.length >0) {
        
        NSArray *array = [value componentsSeparatedByString:@"@&@"];
        if (array.count == 2) {
            NSString *valueNum = safeString(array[sender.selectedSegmentIndex]);
            NSMutableDictionary *aDic = [NSMutableDictionary dictionary];
            [aDic setValue:safeString(valueNum) forKey:safeString(infoId)];
            [toDic addEntriesFromDictionary:aDic];
            [UserManager shareUserManager].resultDic = toDic;
        }
        
    }else {
        NSArray *array = [NSArray arrayWithObjects:@"正常",@"不正常", nil];
        if (array.count == 2) {
            NSString *valueNum = safeString(array[sender.selectedSegmentIndex]);
            NSMutableDictionary *aDic = [NSMutableDictionary dictionary];
            [aDic setValue:safeString(valueNum) forKey:safeString(infoId)];
            [toDic addEntriesFromDictionary:aDic];
            [UserManager shareUserManager].resultDic = toDic;
        }
    }
    switch (sender.selectedSegmentIndex) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        default:
            break;
    }
    
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

//复选栏视图创建
- (void)createCharsetView {
    
    self.charsetView = [[UIView alloc]init];
    [self addSubview:self.charsetView];
    [self.charsetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.specialView.mas_left);
        make.height.equalTo(@32);
        make.width.equalTo(@160);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
    
    self.charsetQushiBtn = [[UIButton alloc]init];
    [self.charsetView addSubview:self.charsetQushiBtn];
    [self.charsetQushiBtn addTarget:self action:@selector(qushiMethod:)
                   forControlEvents:UIControlEventTouchUpInside];
    [self.charsetQushiBtn setImage:[UIImage imageNamed:@"kg_qushi_GrayImage"] forState:UIControlStateNormal];
    [self.charsetQushiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.redPromptView.mas_centerY);
        make.right.equalTo(self.charsetView.mas_right);
        make.height.equalTo(@32);
        make.width.lessThanOrEqualTo(@32);
    }];
    
    self.charsetWarnImageView = [[UIImageView alloc]init];
    [self.charsetView addSubview:self.charsetWarnImageView];
    [self.charsetWarnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.charsetView.mas_centerY);
        make.right.equalTo(self.charsetQushiBtn.mas_left).offset(-14);
        make.height.equalTo(@0);
        make.width.equalTo(@0);
    }];
    
    self.charsetTitleLabel = [[UILabel alloc]init];
    [self.charsetView addSubview:self.charsetTitleLabel];
    self.charsetTitleLabel.textColor =[UIColor colorWithHexString:@"#626470"];
    self.charsetTitleLabel.font = [UIFont systemFontOfSize:14];
    self.charsetTitleLabel.font = [UIFont my_font:14];
    self.charsetTitleLabel.textAlignment = NSTextAlignmentRight;
    [self.charsetTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.charsetView.mas_centerY);
        make.right.equalTo(self.charsetWarnImageView.mas_left).offset(-1);
        make.height.equalTo(@32);
        make.width.lessThanOrEqualTo(@120);
    }];
    
}

//趋势
- (void)qushiMethod:(UIButton *)button {
    
    
}

//复选栏视图创建
- (void)createTextInputView {
    
    self.textInputView = [[UIView alloc]init];
    [self addSubview:self.textInputView];
    [self.textInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.specialView.mas_left);
        make.height.equalTo(@32);
        make.width.equalTo(@160);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
    
    self.textView = [[UITextView alloc]init];
    self.textView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.textView.layer.cornerRadius = 6;
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.text = @"输入内容";
    self.textView.userInteractionEnabled = NO;
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = [[UIColor colorWithHexString:@"#E6E8ED"] CGColor];
    
    self.textView.textColor = [UIColor colorWithHexString:@"#626470"];
    self.textView.layer.masksToBounds = YES;
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.delegate = self;
    self.textView.textAlignment = NSTextAlignmentLeft;
    self.textView.textContainerInset = UIEdgeInsetsMake(5, 10, 0, 0);
    [self.textInputView addSubview:self.textView];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textInputView.mas_centerY);
        make.right.equalTo(self.textInputView.mas_right);
        make.height.equalTo(@24);
        make.width.equalTo(@120);
    }];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    //先判断是四级还是五级 模板，取值
    int levelMax = [self.dataDic[@"levelMax"] intValue];
    if (levelMax == 4) {
        NSArray *modelArr = self.dataDic[@"childrens"];
        if (modelArr.count) {
            self.modelDic = [self.dataDic[@"childrens"] firstObject];
        }
        
    }else if (levelMax == 5) {
        NSArray *modelArr = self.dataDic[@"childrens"];
        if (modelArr.count) {
            NSDictionary *dataDic = [self.dataDic[@"childrens"] firstObject];
            NSArray *detailArr = dataDic[@"childrens"];
            if (detailArr.count) {
                self.modelDic = [detailArr firstObject];
            }
        }
    }
    
    //判断一下是否是修改任务了 如果修改任务要让控件可以点击
    if([UserManager shareUserManager].isChangeTask) {
        
        self.segmentedControl.userInteractionEnabled = YES;
        self.textView.userInteractionEnabled = YES;
        self.selectBtn.userInteractionEnabled = YES;
        self.specialView.userInteractionEnabled = YES;
    }else {
        
        self.segmentedControl.userInteractionEnabled = NO;
        self.textView.userInteractionEnabled = NO;
        self.selectBtn.userInteractionEnabled = NO;
        self.specialView.userInteractionEnabled = NO;
        
    }
    
    //判断一下是否特殊参数标记
    BOOL special = self.modelDic[@"special"];//特殊参数标记
    if (special) {
        [self.specialView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-16);
            make.width.height.equalTo(@32);
            make.centerY.equalTo(self.titleLabel.mas_centerY);
        }];
        self.specialView.hidden = NO;
        //有特殊参数标记了  再判断一下 是否已经标记了特殊参数标记
        if (isSafeDictionary(self.modelDic[@"atcSpecialTag"])) {
            NSDictionary *atcDic = self.modelDic[@"atcSpecialTag"];
            if (atcDic.count && [[atcDic allValues] count] >0 && safeString(atcDic[@"specialTagCode"]).length >0) {
                [self.specialButton setImage:[UIImage imageNamed:@"yellow_staricon"] forState:UIControlStateNormal];
                self.specialContentView.hidden = NO;
                self.specialContentTitleLabel.text = [NSString stringWithFormat:@"%@特殊参数标记内容",safeString(atcDic[@"specialTagName"])];
                self.specialContentDetailLabel.text = safeString(atcDic[@"description"]);
                
            }else {
                self.specialContentView.hidden = YES;
            }
        }else {
            self.specialContentView.hidden = YES;
        }
    }else {
        
        [self.specialView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-16);
            make.width.height.equalTo(@0);
            make.centerY.equalTo(self.titleLabel.mas_centerY);
        }];
        self.specialView.hidden = YES;
    }
    
    //判断一下是否未自动获取到数值
    self.redPromptView.hidden = YES;
    if ([safeString(self.modelDic[@"type"]) isEqualToString:@"charset"] ||
        [safeString(self.modelDic[@"type"]) isEqualToString:@"data"]) {
        NSString *valueString = safeString(self.dataDic[@"measureValueAlias"]);
        if (valueString.length == 0) {
            self.redPromptView.hidden = NO;
        }else {
            self.redPromptView.hidden = YES;
        }
    }
    
    //确定了数据类型之后，根据字典开始按类型区分
    
    self.titleLabel.text = safeString(dataDic[@"measureTagName"]);
    if (safeString(dataDic[@"measureTagName"]).length == 0) {
        self.titleLabel.text = safeString(dataDic[@"title"]);
    }
    
    if([safeString(self.dataDic[@"measureTagName"]) isEqualToString:@"门窗卫生"]) {
        
        NSLog(@"1");
    }
    
    if([safeString(self.dataDic[@"measureTagName"]) isEqualToString:@"识别码"]) {
        
        NSLog(@"1");
    }
    if([safeString(self.dataDic[@"measureTagName"]) isEqualToString:@"接收机灵敏度"]) {
        
        NSLog(@"1");
    }
    
    if ([safeString(self.modelDic[@"type"]) isEqualToString:@"select"]) {
        
        self.selectView.hidden = NO;
        self.segmentView.hidden = YES;
        self.charsetView.hidden = YES;
        self.textInputView.hidden = YES;
        
    }else if([safeString(self.modelDic[@"type"]) isEqualToString:@"charset"]) {
        
        self.selectView.hidden = YES;
        self.segmentView.hidden = YES;
        self.charsetView.hidden = NO;
        [self.charsetQushiBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel.mas_centerY);
            make.right.equalTo(self.charsetView.mas_right);
            make.height.equalTo(@32);
            make.width.lessThanOrEqualTo(@0);
        }];
        self.textInputView.hidden = YES;
        
    }else if([safeString(self.modelDic[@"type"]) isEqualToString:@"data"]){
        
        self.selectView.hidden = YES;
        self.segmentView.hidden = YES;
        self.charsetView.hidden = NO;
        [self.charsetQushiBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel.mas_centerY);
            make.right.equalTo(self.charsetView.mas_right);
            make.height.equalTo(@32);
            make.width.lessThanOrEqualTo(@0);
        }];
        self.textInputView.hidden = YES;
        
    }else if([safeString(self.modelDic[@"type"]) isEqualToString:@"radio"]) {
        
        self.selectView.hidden = YES;
        self.segmentView.hidden = NO;
        self.charsetView.hidden = YES;
        self.textInputView.hidden = YES;
        
    }else {
        
        self.selectView.hidden = YES;
        self.segmentView.hidden = YES;
        self.charsetView.hidden = YES;
        self.textInputView.hidden = YES;
    }
    
    //赋值
    if ([safeString(self.modelDic[@"type"]) isEqualToString:@"select"]) {
        self.selectTitleLabel.text = safeString(self.dataDic[@"measureValueAlias"]);
        if (safeString(self.dataDic[@"measureValueAlias"]).length == 0) {
            NSString *ss = safeString(self.modelDic[@"value"]);
            if (ss.length >0) {
                NSArray *array = [ss componentsSeparatedByString:@"@&@"];
                if (array.count) {
                    self.selectTitleLabel.text = [array firstObject];
                }
            }
        }
    }else if([safeString(self.modelDic[@"type"]) isEqualToString:@"charset"]) {
        self.charsetTitleLabel.text = safeString(self.dataDic[@"measureValueAlias"]);
        if([safeString(self.dataDic[@"alarmContent"]) containsString:@"告警"] ) {
            self.charsetTitleLabel.textColor = [UIColor colorWithHexString:@"#FB394C"];
            
        }else {
            self.charsetTitleLabel.textColor = [UIColor colorWithHexString:@"#626470"];
            
        }
        if (safeString(self.dataDic[@"measureValueAlias"]).length == 0) {
            self.charsetTitleLabel.text = @"";
            self.selectView.hidden = YES;
            self.segmentView.hidden = NO;
            self.charsetView.hidden = YES;
            self.textInputView.hidden = YES;
            NSArray *array = [NSArray arrayWithObjects:@"正常",@"不正常", nil];
            if (array.count == 2) {
                [self.segmentedControl setTitle:safeString(array[0]) forSegmentAtIndex:0];
                [self.segmentedControl setTitle:safeString(array[1]) forSegmentAtIndex:1];
            }
        }
    }else if([safeString(self.modelDic[@"type"]) isEqualToString:@"data"]) {
        
        self.charsetTitleLabel.text = safeString(self.dataDic[@"measureValueAlias"]);
        if([safeString(self.dataDic[@"alarmContent"]) containsString:@"告警"] ) {
            self.charsetTitleLabel.textColor = [UIColor colorWithHexString:@"#FB394C"];
            
        }else {
            self.charsetTitleLabel.textColor = [UIColor colorWithHexString:@"#626470"];
            
        }
        
        if([safeString(self.dataDic[@"alarmContent"]) isEqualToString:@"上限告警"] ) {
            [self.charsetWarnImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.charsetView.mas_centerY);
                make.right.equalTo(self.charsetQushiBtn.mas_left).offset(-14);
                make.height.equalTo(@14);
                make.width.equalTo(@8.5);
            }];
            self.charsetWarnImageView.image = [UIImage imageNamed:@"red_upslider"];
            
        }else if([safeString(self.dataDic[@"alarmContent"]) isEqualToString:@"下限告警"] ) {
            [self.charsetWarnImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.charsetView.mas_centerY);
                make.right.equalTo(self.charsetQushiBtn.mas_left).offset(-14);
                make.height.equalTo(@14);
                make.width.equalTo(@8.5);
            }];
            self.charsetWarnImageView.image = [UIImage imageNamed:@"red_downslider"];
        }else {
            [self.charsetWarnImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.charsetView.mas_centerY);
                make.right.equalTo(self.charsetQushiBtn.mas_left).offset(-14);
                make.height.equalTo(@0);
                make.width.equalTo(@0);
            }];
            self.charsetWarnImageView.image = [UIImage imageNamed:@""];
        }
        
        if (safeString(self.dataDic[@"measureValueAlias"]).length == 0) {
            NSString *ss = safeString(self.modelDic[@"value"]);
            if (ss.length >0) {
                NSArray *array = [ss componentsSeparatedByString:@"@&@"];
                if (array.count) {
                    self.selectTitleLabel.text = [array firstObject];
                }
            }else {
                
                self.charsetTitleLabel.text = @"";
                self.selectView.hidden = YES;
                self.segmentView.hidden = YES;
                self.charsetView.hidden = YES;
                self.textInputView.hidden = NO;
            }
        }
        
    }else if([safeString(self.modelDic[@"type"]) isEqualToString:@"radio"]) {
        
        NSString *value = safeString(self.modelDic[@"value"]);
        if (value.length ==0) {
            NSArray *array = [NSArray arrayWithObjects:@"正常",@"不正常", nil];
            if (array.count == 2) {
                [self.segmentedControl setTitle:safeString(array[0]) forSegmentAtIndex:0];
                [self.segmentedControl setTitle:safeString(array[1]) forSegmentAtIndex:1];
            }
        }else {
            
            NSArray *array = [value componentsSeparatedByString:@"@&@"];;
            if (array.count == 2) {
                [self.segmentedControl setTitle:safeString(array[0]) forSegmentAtIndex:0];
                [self.segmentedControl setTitle:safeString(array[1]) forSegmentAtIndex:1];
            }
            
            NSString *valueAlias = safeString(self.dataDic[@"measureValueAlias"]);
            if ([valueAlias isEqualToString:safeString(array[0])]) {
                self.segmentedControl.selectedSegmentIndex = 0;
            }else if ([valueAlias isEqualToString:safeString(array[1])]) {
                self.segmentedControl.selectedSegmentIndex = 1;
            }else {
                self.segmentedControl.selectedSegmentIndex = -1;
            }
        }
    }else {
        
    }
}

- (KG_SelectCardTypeView *)alertView {
    
    if (!_alertView) {
        _alertView = [[KG_SelectCardTypeView alloc]init];
        _alertView.dataDic = self.dataDic;
        [JSHmainWindow addSubview:_alertView];
        [_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo([UIApplication sharedApplication].keyWindow.mas_left);
            make.right.equalTo([UIApplication sharedApplication].keyWindow.mas_right);
            make.top.equalTo([UIApplication sharedApplication].keyWindow.mas_top);
            make.bottom.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom);
        }];
    }
    return _alertView;
}

//点击单选
- (void)selectButtonMethod {
    [_alertView removeFromSuperview];
    _alertView = nil;
    self.alertView.hidden = NO;
    self.alertView.didselTextBlock = ^(NSDictionary * _Nonnull str) {
        if (isSafeDictionary(str)) {
            if (str.count) {
                NSMutableDictionary *toDic = [NSMutableDictionary dictionary];
                NSDictionary *resultDic  = [UserManager shareUserManager].resultDic;
                [toDic addEntriesFromDictionary:resultDic];
                [toDic addEntriesFromDictionary:str];
                
                [UserManager shareUserManager].resultDic = toDic;
                NSString *ss = safeString([[str allValues] firstObject]);
                self.selectTitleLabel.text = safeString(ss);
            }
        }
    };
}

- (void)promptMethod:(UIButton *)btn {
    
    if (self.promptSignView.hidden == YES) {
        self.promptSignView.hidden = NO;
    }else {
        self.promptSignView.hidden = YES;
    }
}

- (void)specialMethod:(UIButton *)btn {
    
    //不是领导不能标记给个提示吧
    if (![CommonExtension isLingDao]) {
        [FrameBaseRequest showMessage:@"暂无标记权限"];
        return;
    }
    NSLog(@"点击了特殊参数标记");
    _signView = nil;
    [_signView removeFromSuperview];
    [JSHmainWindow addSubview:self.signView];
    self.signView.saveBlockMethod = ^(NSString * _Nonnull str) {
        NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
        
        [dataDic setValue:safeString(str) forKey:@"description"];
        [dataDic setValue:safeString(self.dataDic[@"measureTagName"]) forKey:@"specialTagName"];
        [dataDic setValue:safeString(self.dataDic[@"measureValueAlias"]) forKey:@"specialTagValue"];
        [dataDic setValue:safeString(self.modelDic[@"parentId"]) forKey:@"patrolRecordId"];
        [dataDic setValue:safeString(self.dataDic[@"engineRoomCode"]) forKey:@"engineRoomCode"];
        [dataDic setValue:safeString(self.dataDic[@"engineRoomName"]) forKey:@"engineRoomName"];
        if (self.specialData) {
            self.specialData(dataDic);
        }
        
    };
    [self.signView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo([UIApplication sharedApplication].keyWindow.mas_left);
        make.right.equalTo([UIApplication sharedApplication].keyWindow.mas_right);
        make.top.equalTo([UIApplication sharedApplication].keyWindow.mas_top);
        make.bottom.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom);
    }];
}

- (KG_SpecilaCanShuSignView *)signView {
    
    if (!_signView) {
        _signView = [[KG_SpecilaCanShuSignView alloc]init];
        
    }
    return _signView;
}

//将要进入编辑模式[开始编辑]
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.selectedRange = NSMakeRange(textView.text.length, 0);
    if([textView.text isEqualToString:@"输入内容"] ||[textView.text isEqualToString:@"输入内容"]) {
        
        textView.text = @"";
    }
    return YES;
    
}
//当textView的内容发生改变的时候调用
- (void)textViewDidChange:(UITextView *)textView {
    
    NSDictionary *dd = self.modelDic ;
    
    NSString *infoId = safeString(dd[@"parentId"]);
    [UserManager shareUserManager].changeEquipStatus = YES;
    NSMutableDictionary *toDic = [NSMutableDictionary dictionary];
    NSDictionary *resultDic  = [UserManager shareUserManager].resultDic;
    [toDic addEntriesFromDictionary:resultDic];
    
    NSMutableDictionary *aDic = [NSMutableDictionary dictionary];
    [aDic setValue:safeString(textView.text) forKey:safeString(infoId)];
    [toDic addEntriesFromDictionary:aDic];
    
    [UserManager shareUserManager].resultDic = toDic;
    
    NSString *ss = safeString(textView.text);
    self.textView.text = ss;
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

@end
