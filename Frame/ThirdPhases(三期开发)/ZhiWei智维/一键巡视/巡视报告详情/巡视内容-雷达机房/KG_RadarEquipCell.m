//
//  KG_RadarEnvCell.m
//  Frame
//
//  Created by zhangran on 2020/4/26.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RadarEquipCell.h"
#import "KG_SelectCardTypeView.h"
#import "KG_UpdateSegmentControl.h"
#import "KG_SpecilaCanShuSignView.h"
#import "KG_SpecialNoneDataView.h"

#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_RadarEquipCell ()<UITextViewDelegate>{
    
}

@property (nonatomic, strong)  KG_SelectCardTypeView       *alertView;
@property (nonatomic, strong)  KG_SpecilaCanShuSignView    *signView;
@property (nonatomic, strong)  KG_SpecialNoneDataView      *promptView;
@end

@implementation KG_RadarEquipCell

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
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor =[UIColor colorWithHexString:@"#626470"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.font = [UIFont my_Pingfont:14];
    [self.titleLabel sizeToFit];
    [self.titleLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(4);
        make.left.equalTo(self.mas_left).offset(49.5);
        make.height.equalTo(@32);
        make.width.lessThanOrEqualTo(@150);
    }];
    
    self.detailLabel = [[UILabel alloc]init];
    [self addSubview:self.detailLabel];
    self.detailLabel.textColor =[UIColor colorWithHexString:@"#626470"];
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    self.detailLabel.font = [UIFont my_Pingfont:14];
    self.detailLabel.textAlignment = NSTextAlignmentRight;
    [self.detailLabel sizeToFit];
    [self.detailLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.equalTo(self.mas_height);
        make.width.lessThanOrEqualTo(@250);
    }];
    
    self.specialStarBtn = [[UIButton alloc]init];
    [self addSubview:self.specialStarBtn];
    [self.specialStarBtn setImage:[UIImage imageNamed:@"yellow_staricon"] forState:UIControlStateNormal];
    [self.specialStarBtn setTitle:@"" forState:UIControlStateNormal];
    [self.specialStarBtn addTarget:self action:@selector(specialMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.specialStarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@30);
        make.right.equalTo(self.detailLabel.mas_left).offset(-20);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
    
    self.promptBtn = [[UIButton alloc]init];
    [self addSubview:self.promptBtn];
    [self.promptBtn setImage:[UIImage imageNamed:@"prompt_redIcon"] forState:UIControlStateNormal];
    [self.promptBtn setTitle:@"" forState:UIControlStateNormal];
    [self.promptBtn addTarget:self action:@selector(promptMethod:) forControlEvents:UIControlEventTouchUpInside];
    self.promptBtn.hidden = YES;
    [self.promptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@12);
        make.left.equalTo(self.titleLabel.mas_right).offset(20);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
    
    [self createSegment];
    [self createButton];
    [self createTextField];
    
    self.detailView = [[UIView alloc]init];
    [self addSubview:self.detailView];
    self.detailView.hidden = YES;
    self.detailView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self.mas_left).offset(50);
        make.right.equalTo(self.mas_right).offset(-32);
        make.height.equalTo(@57);
    }];
    
    self.detailTitleLabel = [[UILabel alloc]init];
    [self.detailView addSubview:self.detailTitleLabel];
    self.detailTitleLabel.text = @"A相输入电压特殊参数标记";
    self.detailTitleLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.detailTitleLabel.font = [UIFont systemFontOfSize:12];
    self.detailTitleLabel.font = [UIFont my_Pingfont:12];
    self.detailTitleLabel.numberOfLines = 1;
    self.detailTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.detailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailView.mas_top).offset(10);
        make.left.equalTo(self.detailView.mas_left).offset(9.5);
        make.right.equalTo(self.detailView.mas_right).offset(-20);
        make.height.equalTo(@12);
    }];
    
    self.detailTextTitleLabel = [[UILabel alloc]init];
    [self.detailView addSubview:self.detailTextTitleLabel];
    self.detailTextTitleLabel.text = @"电压过高";
    self.detailTextTitleLabel.textColor = [UIColor colorWithHexString:@"#FFB428"];
    self.detailTextTitleLabel.font = [UIFont systemFontOfSize:12];
    self.detailTextTitleLabel.font = [UIFont my_Pingfont:12];
    self.detailTextTitleLabel.numberOfLines = 1;
    self.detailTextTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.detailTextTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailTitleLabel.mas_bottom).offset(9.5);
        make.left.equalTo(self.detailView.mas_left).offset(9.5);
        make.right.equalTo(self.detailView.mas_right).offset(-20);
        make.height.equalTo(@12);
    }];
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

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.segmentedControl.hidden = YES;
    self.selectBtn.hidden = YES;
    self.textView.hidden = YES;
    self.detailLabel.hidden = NO;
    if ([safeString(dataDic[@"measureTagName"]) isEqualToString:@"当前模式"]) {
        NSLog(@"1");
    }
    if ([safeString(dataDic[@"measureTagName"]) isEqualToString:@"温度"]) {
        NSLog(@"2");
    }
    
    if ([safeString(dataDic[@"measureTagName"]) containsString:@"周"]) {
        NSLog(@"2");
    }
    NSDictionary *dd = nil;
    NSArray *arr = _dataDic[@"childrens"];
    if (arr.count >0) {
        dd = [arr firstObject];
    }
    NSArray *sixArr = dd[@"childrens"];
    if (sixArr.count >0) {
        
        dd = [sixArr firstObject];
    }
    if ([dd[@"special"] boolValue]) {
        self.specialStarBtn.hidden = NO;
    }else {
        self.specialStarBtn.hidden = YES;
    }
    
    if (isSafeDictionary(dd[@"atcSpecialTag"])) {
        NSDictionary *atcDic = dd[@"atcSpecialTag"];
        if (atcDic.count && [[atcDic allValues] count] >0 && safeString(atcDic[@"specialTagCode"]).length >0) {
            self.detailView.hidden = NO;
            self.detailTitleLabel.text = [NSString stringWithFormat:@"%@特殊参数标记内容",safeString(atcDic[@"specialTagName"])];
            self.detailTextTitleLabel.text = safeString(atcDic[@"description"]);
            if ([dd[@"special"] boolValue]) {
                self.specialStarBtn.hidden = NO;
            }else {
                self.specialStarBtn.hidden = YES;
            }
        }else {
            self.detailView.hidden = YES;
        }
    }else {
        self.detailView.hidden = YES;
    }
    if([safeString(dd[@"type"]) isEqualToString:@"charset"] ||
       [safeString(dd[@"type"]) isEqualToString:@"data"]
       ){
        NSDictionary *dd = [dataDic[@"childrens"] firstObject];
        NSString *value = safeString(dd[@"value"]);
        NSString *valueNum = safeString(self.dataDic[@"measureValueAlias"]) ;
        if (valueNum.length == 0) {
            self.promptView.hidden = NO;
        }else {
            self.promptView.hidden = YES;
        }
    }else {
        self.promptView.hidden = YES;
    }
    if ([UserManager shareUserManager].isChangeTask) {
        self.specialStarBtn.userInteractionEnabled = YES;
        self.promptBtn.userInteractionEnabled = YES;
    }else {
        self.promptBtn.userInteractionEnabled = NO;
        self.specialStarBtn.userInteractionEnabled = NO;
    }
    
    self.titleLabel.text = safeString(dataDic[@"measureTagName"]);
    if (safeString(dataDic[@"measureTagName"]).length == 0) {
        self.titleLabel.text = safeString(dataDic[@"title"]);
    }
    self.detailLabel.text = safeString(dataDic[@"measureValueAlias"]);
    if (safeString(dataDic[@"unit"]).length > 0) {
        self.detailLabel.text = [NSString stringWithFormat:@"%@%@",safeString(dataDic[@"measureValueAlias"]),safeString(dataDic[@"unit"])];
        if ([safeString(dataDic[@"measureValueAlias"]) containsString:safeString(dataDic[@"unit"])]) {
            self.detailLabel.text = [NSString stringWithFormat:@"%@",safeString(dataDic[@"measureValueAlias"])];
        }
        if (safeString(dataDic[@"unit"]).length == 0) {
            self.detailLabel.text = [NSString stringWithFormat:@"%@",safeString(dataDic[@"valueAlias"])] ;
        }
    }
    if (safeString(dataDic[@"measureValueAlias"]).length == 0) {
        self.detailLabel.text =@"--";
    }
    
    
    if([safeString(dd[@"type"])  isEqualToString:@"charset"]
       ) {
        if ([UserManager shareUserManager].isChangeTask) {
            self.segmentedControl.userInteractionEnabled = YES;
        }else {
            self.segmentedControl.userInteractionEnabled = NO;
        }
        self.segmentedControl.hidden = NO;
        self.detailLabel.hidden = YES;
        self.selectBtn.hidden = YES;
        self.textView.hidden = YES;
        if ([dataDic[@"childrens"] count] >0) {
            NSDictionary *dd = [dataDic[@"childrens"] firstObject];
            NSString *value = safeString(dd[@"value"]) ;
            NSString *valueNum = safeString(self.dataDic[@"measureValueAlias"]) ;
            if (value.length >0) {
                
                NSArray *array = [value componentsSeparatedByString:@"@&@"];
                if (array.count == 2) {
                    [self.segmentedControl setTitle:safeString(array[0]) forSegmentAtIndex:0];
                    [self.segmentedControl setTitle:safeString(array[1]) forSegmentAtIndex:1];
                    if (valueNum.length >0) {
                        if ([valueNum isEqualToString:array[0]]) {
                            self.segmentedControl.selectedSegmentIndex = 0;
                            
                        }else if ([valueNum isEqualToString:array[1]]) {
                            self.segmentedControl.selectedSegmentIndex = 1;
                            
                        }else {
                            self.segmentedControl.selectedSegmentIndex = -1;
                        }
                    }else {
                        self.segmentedControl.selectedSegmentIndex = -1;
                    }
                    NSString *parentId = safeString(dd[@"parentId"]) ;
                    NSDictionary *dic =  [UserManager shareUserManager].resultDic;
                    if ([dic count]) {
                        NSArray *arr = [dic allKeys];
                        if (arr.count) {
                            
                            for (NSString *pId in arr) {
                                if ([pId isEqualToString:parentId]) {
                                    NSString *cc = [dic objectForKey:parentId];
                                    if ([cc isEqualToString:array[0]]) {
                                        self.segmentedControl.selectedSegmentIndex = 0;
                                        
                                    }else if ([cc isEqualToString:array[1]]) {
                                        self.segmentedControl.selectedSegmentIndex = 1;
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }else {
                
                if (value.length == 0 && valueNum.length >0 ) {
                    self.detailLabel.hidden = NO;
                    self.segmentedControl.hidden = YES;
                }
                
                NSArray *array = [NSArray arrayWithObjects:@"正常",@"不正常", nil];
                if (array.count == 2) {
                    [self.segmentedControl setTitle:safeString(array[0]) forSegmentAtIndex:0];
                    [self.segmentedControl setTitle:safeString(array[1]) forSegmentAtIndex:1];
                    if (valueNum.length >0) {
                        if ([valueNum isEqualToString:array[0]]) {
                            self.segmentedControl.selectedSegmentIndex = 0;
                            
                        }else if ([valueNum isEqualToString:array[1]]) {
                            self.segmentedControl.selectedSegmentIndex = 1;
                            
                        }else {
                            self.segmentedControl.selectedSegmentIndex = -1;
                        }
                    }else {
                        self.segmentedControl.selectedSegmentIndex = -1;
                    }
                    NSString *parentId = safeString(dd[@"parentId"]) ;
                    NSDictionary *dic =  [UserManager shareUserManager].resultDic;
                    if ([dic count]) {
                        NSArray *arr = [dic allKeys];
                        if (arr.count) {
                            
                            for (NSString *pId in arr) {
                                if ([pId isEqualToString:parentId]) {
                                    NSString *cc = [dic objectForKey:parentId];
                                    if ([cc isEqualToString:array[0]]) {
                                        self.segmentedControl.selectedSegmentIndex = 0;
                                        
                                    }else if ([cc isEqualToString:array[1]]) {
                                        self.segmentedControl.selectedSegmentIndex = 1;
                                        
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
        }
    }else if( [safeString(dd[@"type"])  isEqualToString:@"radio"]) {
        if ([UserManager shareUserManager].isChangeTask) {
            self.segmentedControl.userInteractionEnabled = YES;
        }else {
            self.segmentedControl.userInteractionEnabled = NO;
        }
        
        
        self.selectBtn.hidden = YES;
        self.textView.hidden = YES;
        
        self.segmentedControl.hidden = NO;
        self.segmentedControl.selectedSegmentIndex = -1;
        self.detailLabel.hidden = YES;
        if ([dataDic[@"childrens"] count] >0) {
            NSDictionary *dd = [dataDic[@"childrens"] firstObject];
            NSString *value = safeString(dd[@"value"]) ;
            NSString *valueNum = safeString(self.dataDic[@"measureValueAlias"]) ;
            if (value.length >0) {
                
                NSArray *array = [value componentsSeparatedByString:@"@&@"];
                if (array.count == 2) {
                    [self.segmentedControl setTitle:safeString(array[0]) forSegmentAtIndex:0];
                    [self.segmentedControl setTitle:safeString(array[1]) forSegmentAtIndex:1];
                    if (valueNum.length >0) {
                        if ([valueNum isEqualToString:array[0]]) {
                            self.segmentedControl.selectedSegmentIndex = 0;
                            
                        }else if ([valueNum isEqualToString:array[1]]) {
                            self.segmentedControl.selectedSegmentIndex = 1;
                            
                        }
                    }
                    NSString *parentId = safeString(dd[@"parentId"]) ;
                    NSDictionary *dic =  [UserManager shareUserManager].resultDic;
                    if ([dic count]) {
                        NSArray *arr = [dic allKeys];
                        if (arr.count) {
                            
                            for (NSString *pId in arr) {
                                if ([pId isEqualToString:parentId]) {
                                    NSString *cc = [dic objectForKey:parentId];
                                    if ([cc isEqualToString:array[0]]) {
                                        self.segmentedControl.selectedSegmentIndex = 0;
                                        
                                    }else if ([cc isEqualToString:array[1]]) {
                                        self.segmentedControl.selectedSegmentIndex = 1;
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }else {
                
                if (value.length == 0 && valueNum.length >0 ) {
                    self.detailLabel.hidden = NO;
                    self.segmentedControl.hidden = YES;
                }
                
                NSArray *array = [NSArray arrayWithObjects:@"正常",@"不正常", nil];
                if (array.count == 2) {
                    
                    [self.segmentedControl setTitle:safeString(array[0]) forSegmentAtIndex:0];
                    [self.segmentedControl setTitle:safeString(array[1]) forSegmentAtIndex:1];
                    NSString *parentId = safeString(dd[@"parentId"]) ;
                    NSDictionary *dic =  [UserManager shareUserManager].resultDic;
                    if ([dic count]) {
                        NSArray *arr = [dic allKeys];
                        if (arr.count) {
                            
                            for (NSString *pId in arr) {
                                if ([pId isEqualToString:parentId]) {
                                    NSString *cc = [dic objectForKey:parentId];
                                    if ([cc isEqualToString:array[0]]) {
                                        self.segmentedControl.selectedSegmentIndex = 0;
                                        
                                    }else if ([cc isEqualToString:array[1]]) {
                                        self.segmentedControl.selectedSegmentIndex = 1;
                                        
                                    }
                                }
                            }
                        }
                    }
                    
                    
                    
                }
            }
            
            
        }
        
        
    }else if( [safeString(dd[@"type"])  isEqualToString:@"data"]) {
        
        self.detailLabel.hidden = NO;
        
        self.segmentedControl.hidden = YES;
        
        self.selectBtn.hidden = YES;
        self.textView.hidden = YES;
    }else if([safeString(dd[@"type"]) isEqualToString:@"textarea"]) {
        
        
    }else if([safeString(dd[@"type"])  isEqualToString:@"select"]) {
        self.detailLabel.hidden = YES;
        self.segmentedControl.hidden = YES;
        self.selectBtn.hidden = NO;
        
        self.textView.hidden = YES;
        
        [self.specialStarBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@30);
            make.right.equalTo(self.selectBtn.mas_left).offset(-20);
            make.centerY.equalTo(self.titleLabel.mas_centerY);
        }];
        if ([UserManager shareUserManager].isChangeTask) {
            self.selectBtn.userInteractionEnabled = YES;
        }else {
            self.selectBtn.userInteractionEnabled = NO ;
        }
        if(safeString(self.dataDic[@"measureValueAlias"]).length >0)
        {
            [self.selectBtn setTitle:safeString(self.dataDic[@"measureValueAlias"]) forState:UIControlStateNormal];
        }else {
            NSString *value = safeString(dd[@"value"]) ;
            NSString *valueNum = safeString(self.dataDic[@"measureValueAlias"]) ;
            if (value.length >0) {
                
                NSArray *array = [value componentsSeparatedByString:@"@&@"];
                if (array.count == 2) {
                    
                    if (valueNum.length >0) {
                        if ([valueNum isEqualToString:array[0]]) {
                            
                            [self.selectBtn setTitle:array[0] forState:UIControlStateNormal];
                        }else if ([valueNum isEqualToString:array[1]]) {
                            [self.selectBtn setTitle:array[1] forState:UIControlStateNormal];
                            
                        }
                    }else {
                        [self.selectBtn setTitle:array[0] forState:UIControlStateNormal];
                    }
                }
            }
            
        }
        NSString *value = safeString(dd[@"value"]) ;
        if (value.length >0) {
            
            NSArray *array = [value componentsSeparatedByString:@"@&@"];
            NSString *parentId = safeString(dd[@"parentId"]) ;
            NSDictionary *dic =  [UserManager shareUserManager].resultDic;
            if ([dic count]) {
                NSArray *arr = [dic allKeys];
                if (arr.count) {
                    
                    for (NSString *pId in arr) {
                        if ([pId isEqualToString:parentId]) {
                            NSString *cc = [dic objectForKey:parentId];
                            if ([cc isEqualToString:array[0]]) {
                                
                                [self.selectBtn setTitle:array[0] forState:UIControlStateNormal];
                            }else if ([cc isEqualToString:array[1]]) {
                                [self.selectBtn setTitle:array[1] forState:UIControlStateNormal];
                                
                            }
                        }
                    }
                }
            }
        }
        [self.selectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -
                                                            self.selectBtn.imageView.frame.size.width, 0, self.selectBtn.imageView.frame.size.width)];
        [self.selectBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.selectBtn.titleLabel.bounds.size.width, 0, - self.selectBtn.titleLabel.bounds.size.width)];
        
        
    }else if([safeString(dd[@"type"]) isEqualToString:@"input"]) {
        self.textView.hidden = NO;
        self.detailLabel.hidden = YES;
        self.segmentedControl.hidden = YES;
        self.selectBtn.hidden = YES;
        
        if ([UserManager shareUserManager].isChangeTask) {
            self.textView.userInteractionEnabled = YES;
        }else {
            self.textView.userInteractionEnabled = NO;
        }
        if(safeString(self.dataDic[@"measureValueAlias"]).length >0)
        {
            self.textView.text = safeString(self.dataDic[@"measureValueAlias"]);
        }else {
            
            self.textView.text = @"";
        }
        
        
        NSString *value = safeString(dd[@"value"]) ;
        if (value.length >0) {
            
            NSArray *array = [value componentsSeparatedByString:@"@&@"];
            NSString *parentId = safeString(dd[@"parentId"]) ;
            NSDictionary *dic =  [UserManager shareUserManager].resultDic;
            if ([dic count]) {
                NSArray *arr = [dic allKeys];
                if (arr.count) {
                    
                    for (NSString *pId in arr) {
                        if ([pId isEqualToString:parentId]) {
                            NSString *cc = [dic objectForKey:parentId];
                            if ([cc isEqualToString:array[0]]) {
                                
                                self.textView.text = cc;
                            }
                        }
                    }
                }
            }
        }
        
        
    }
    
    
}
- (void)createSegment {
    
    NSArray *array = [NSArray arrayWithObjects:@"正常",@"不正常", nil];
    
    [self.segmentedControl removeFromSuperview];
    
    self.segmentedControl = [[KG_UpdateSegmentControl alloc]initWithItems:array];
    self.segmentedControl.frame = CGRectMake(SCREEN_WIDTH - 32 -84, 8,84,24);
    
    
    
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF"]}forState:UIControlStateSelected];
    
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#2F5ED1"],NSFontAttributeName:[UIFont boldSystemFontOfSize:10.0f]}forState:UIControlStateNormal];
    [self addSubview:self.segmentedControl];
    self.segmentedControl.selectedSegmentIndex = -1;
    self.segmentedControl.tintColor = [UIColor colorWithHexString:@"#2F5ED1"];
    self.segmentedControl.layer.borderWidth = 1;                   //    边框宽度，重新画边框，若不重新画，可能会出现圆角处无边框的情况
    self.segmentedControl.layer.borderColor = [UIColor colorWithHexString:@"#2F5ED1"].CGColor; //     边框颜色
    [self.segmentedControl setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]]
                                     forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segmentedControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    
    [self.segmentedControl setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#2F5ED1"]]
                                     forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self.segmentedControl  sizeToFit];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        
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


- (void)createButton {
    self.selectBtn = [[UIButton alloc]init];
    [self.selectBtn setTitleColor:[UIColor colorWithHexString:@"#626470"] forState:UIControlStateNormal];
    self.selectBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [self.selectBtn addTarget:self action:@selector(selectButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    self.selectBtn.userInteractionEnabled = NO;
    [self addSubview:self.selectBtn];
    self.selectBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 90, 0, 0);
    [self.selectBtn setImage:[UIImage imageNamed:@"common_right"] forState:UIControlStateNormal];
    [self.selectBtn sizeToFit];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.equalTo(self.mas_height);
        //        make.width.equalTo(@120);
    }];
    
}
- (void)selectButtonMethod {
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
                [self.selectBtn setTitle:ss forState:UIControlStateNormal];
            }
            
        }
        
        
    };
    
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

- (void)createTextField {
    
    self.textView = [[UITextView alloc]init];
    self.textView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.textView.layer.cornerRadius = 6;
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.text = @"输入内容";
    self.textView.userInteractionEnabled = NO;
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = [[UIColor colorWithHexString:@"#E6E8ED"] CGColor];
    self.textView.hidden = YES;
    self.textView.textColor = [UIColor colorWithHexString:@"#626470"];
    self.textView.layer.masksToBounds = YES;
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.delegate = self;
    self.textView.textAlignment = NSTextAlignmentRight;
    self.textView.textContainerInset = UIEdgeInsetsMake(15, 15, 5, 15);
    [self addSubview:self.textView];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.equalTo(@32);
        make.width.equalTo(@120);
    }];
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
    
    //    if (self.textStringChangeBlock) {
    //        self.textStringChangeBlock(textView.text);
    //    }
    
    NSDictionary *dd = [self.dataDic[@"childrens"] firstObject];
    
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
- (void)specialMethod:(UIButton *)btn {
    
    NSLog(@"点击了特殊参数标记");
    _signView = nil;
    [_signView removeFromSuperview];
    [JSHmainWindow addSubview:self.signView];
    self.signView.saveBlockMethod = ^(NSString * _Nonnull str) {
        NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
        NSDictionary *dd = nil;
        NSArray *arr = _dataDic[@"childrens"];
        if (arr.count >0) {
            dd = [arr firstObject];
        }
        [dataDic setValue:safeString(str) forKey:@"description"];
        [dataDic setValue:safeString(self.dataDic[@"measureTagName"]) forKey:@"specialTagName"];
        [dataDic setValue:safeString(self.dataDic[@"measureValueAlias"]) forKey:@"specialTagValue"];
        [dataDic setValue:safeString(dd[@"parentId"]) forKey:@"patrolRecordId"];
        //        [dataDic setValue:safeString(dd[@"infoId"]) forKey:@"patrolInfoId"];
        
        //        [dataDic setValue:safeString(self.dataDic[@"equipmentCode"]) forKey:@"equipmentCode"];
        //        [dataDic setValue:safeString(self.dataDic[@"equipmentName"]) forKey:@"equipmentName"];
        [dataDic setValue:safeString(self.dataDic[@"engineRoomCode"]) forKey:@"engineRoomCode"];
        [dataDic setValue:safeString(self.dataDic[@"engineRoomName"]) forKey:@"engineRoomName"];
        //        [dataDic setValue:safeString(self.dataDic[@"taskTime"]) forKey:@"taskTime"];
        
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

- (void)promptMethod:(UIButton *)btn {
    
    _promptView = nil;
    [_promptView removeFromSuperview];
    NSLog(@"点击了提示标记");
    if(_promptView == nil) {
        [self addSubview:self.promptView];
        [self.promptView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.promptBtn.mas_right);
            make.height.equalTo(@27);
            make.width.equalTo(@115);
        }];
    }
}

- (KG_SpecilaCanShuSignView *)signView {
    
    if (!_signView) {
        _signView = [[KG_SpecilaCanShuSignView alloc]init];
        
    }
    return _signView;
}

- (KG_SpecialNoneDataView *)promptView {
    
    if (!_promptView) {
        _promptView = [[KG_SpecialNoneDataView alloc]init];
        
    }
    return _promptView;
}

@end
