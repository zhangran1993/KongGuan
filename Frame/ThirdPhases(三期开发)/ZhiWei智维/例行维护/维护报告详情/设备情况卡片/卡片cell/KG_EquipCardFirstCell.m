//
//  KG_EquipCardFirstCell.m
//  Frame
//
//  Created by zhangran on 2020/6/16.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_EquipCardFirstCell.h"
#import "KG_UpdateSegmentControl.h"
#import "KG_SelectCardTypeView.h"

@interface KG_EquipCardFirstCell ()<UITextViewDelegate>{
    
}
@property (nonatomic, strong)  KG_SelectCardTypeView *alertView;


@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIImageView *statusImage;

@property (nonatomic,strong) UILabel *detailLabel;

@property (nonatomic,strong) UIImageView *arrowImage;

@property (nonatomic, strong) KG_UpdateSegmentControl *segmentedControl;

@end

@implementation KG_EquipCardFirstCell

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
    
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.text = @"";
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-150);
        make.height.equalTo(self.mas_height);
    }];
    //
    //    self.statusImage  = [[UIImageView alloc]init];
    //    [self.statusImage sizeToFit];
    //    self.statusImage.contentMode = UIViewContentModeScaleAspectFit;
    //    [self addSubview:self.statusImage];
    //    [self.statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(self.mas_right);
    //        make.top.equalTo(self.mas_top).offset(14);
    //
    //        make.height.equalTo(@26);
    //    }];
    
    self.detailLabel = [[UILabel alloc]init];
    [self addSubview:self.detailLabel];
    self.detailLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    self.detailLabel.textAlignment = NSTextAlignmentRight;
    self.detailLabel.text = @"";
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@200);
        make.height.equalTo(self.mas_height);
    }];
    
    [self createSegment];
    [self createButton];
    [self createTextField];
//    UIView *lineView = [[UIView alloc]init];
//    [self addSubview:lineView];
//    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(16);
//        make.right.equalTo(self.mas_right).offset(-16);
//        make.height.equalTo(@1);
//        make.bottom.equalTo(self.mas_bottom);
//    }];
    
    
    
    
}
- (void)setDic:(NSDictionary *)dic {
    _dic = dic;
    self.detailLabel.hidden = NO;
    self.segmentedControl.hidden = YES;
    self.textView.hidden = YES;
    self.selectBtn.hidden = YES;
    self.titleLabel.text = safeString(dic[@"title"]);
    if(safeString(dic[@"title"]).length == 0) {
        self.titleLabel.text = safeString(dic[@"measureTagName"]);
    }
    self.statusImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"状态标签-%@",[self getTaskStatus:safeString(dic[@"status"])]]];
    if ([dic[@"childrens"] count] ==0) {
        return;
    }
    self.detailLabel.text = safeString(self.dic[@"measureValueAlias"]);
    if (safeString(dic[@"unit"]).length > 0) {
        self.detailLabel.text = [NSString stringWithFormat:@"%@%@",safeString(dic[@"measureValueAlias"]),safeString(dic[@"unit"])];
        
        if ([safeString(dic[@"measureValueAlias"]) containsString:safeString(dic[@"unit"])]) {
            self.detailLabel.text = [NSString stringWithFormat:@"%@",safeString(dic[@"measureValueAlias"])];
        }
       
        if (safeString(dic[@"unit"]).length == 0) {
            self.detailLabel.text = [NSString stringWithFormat:@"%@",safeString(dic[@"valueAlias"])] ;
        }
        
        
    }
    NSDictionary *fifDic = [self.dic[@"childrens"] firstObject];
    if([safeString(fifDic[@"type"])  isEqualToString:@"charset"]){
        self.detailLabel.hidden = YES;
        self.segmentedControl.hidden = NO;
        if ([UserManager shareUserManager].isChangeTask) {
            self.segmentedControl.userInteractionEnabled = YES;
        }else {
            self.segmentedControl.userInteractionEnabled = NO;
        }
        NSString *value = safeString(fifDic[@"value"]) ;
        NSString *valueNum = safeString(self.dic[@"measureValueAlias"]) ;
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
            }
            NSString *parentId = safeString(fifDic[@"parentId"]) ;
            NSDictionary *dic =  [UserManager shareUserManager].resultCardDic;
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
            
            
            
            
            
            
            
        }else {
            if (safeString(self.dic[@"measureValueAlias"]).length >0) {
                self.detailLabel.hidden = NO;
                self.segmentedControl.hidden = YES;
            }
        }
        
        
    }else if ([safeString(fifDic[@"type"])  isEqualToString:@"select"]){
        
        self.detailLabel.hidden = YES;
        self.segmentedControl.hidden = YES;
        self.selectBtn.hidden = NO;
        
        if ([UserManager shareUserManager].isChangeTask) {
            self.selectBtn.userInteractionEnabled = YES;
        }else {
            self.selectBtn.userInteractionEnabled = NO;
        }
        if(safeString(self.dic[@"measureValueAlias"]).length >0)
        {
            [self.selectBtn setTitle:safeString(self.dic[@"measureValueAlias"]) forState:UIControlStateNormal];
        }else {
            NSString *value = safeString(fifDic[@"value"]) ;
            NSString *valueNum = safeString(self.dic[@"measureValueAlias"]) ;
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
        NSString *value = safeString(fifDic[@"value"]) ;
        if (value.length >0) {
            
            NSArray *array = [value componentsSeparatedByString:@"@&@"];
            NSString *parentId = safeString(fifDic[@"parentId"]) ;
            NSDictionary *dic =  [UserManager shareUserManager].resultCardDic;
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
        
        
        
        if (value.length >0) {
            
            NSArray *array = [value componentsSeparatedByString:@"@&@"];
            NSString *parentId = safeString(fifDic[@"parentId"]) ;
            NSDictionary *dic =  [UserManager shareUserManager].resultCardDic;
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
        
        
    }
    
    else if ([safeString(fifDic[@"type"])  isEqualToString:@"radio"]){
        self.segmentedControl.hidden = NO;
        self.detailLabel.hidden = YES;
        
        if ([UserManager shareUserManager].isChangeTask) {
            self.segmentedControl.userInteractionEnabled = YES;
        }else {
            self.segmentedControl.userInteractionEnabled = NO;
        }
        NSString *value = safeString(fifDic[@"value"]) ;
        NSString *valueNum = safeString(self.dic[@"measureValueAlias"]) ;
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
            }
            
            NSString *parentId = safeString(fifDic[@"parentId"]) ;
            NSDictionary *dic =  [UserManager shareUserManager].resultCardDic;
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
            
            
            
            
        }else {
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
            }
            
            
            NSString *parentId = safeString(fifDic[@"parentId"]) ;
            NSDictionary *dic =  [UserManager shareUserManager].resultCardDic;
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
        
    }else if ([safeString(fifDic[@"type"])  isEqualToString:@"input"]){
        self.textView.hidden = NO;
        self.detailLabel.hidden = YES;
        self.segmentedControl.hidden = YES;
        self.selectBtn.hidden = YES;
        
        if ([UserManager shareUserManager].isChangeTask) {
            self.textView.userInteractionEnabled = YES;
        }else {
            self.textView.userInteractionEnabled = NO;
        }
        if(safeString(self.dic[@"measureValueAlias"]).length >0)
        {
            self.textView.text = safeString(self.dic[@"measureValueAlias"]);
        }else {
            
            NSString *valueNum = safeString(self.dic[@"measureValueAlias"]) ;
            
            self.textView.text = valueNum;
          
        }
        NSString *value = safeString(fifDic[@"value"]) ;
        if (value.length >0) {
            
           
            NSString *parentId = safeString(fifDic[@"parentId"]) ;
            NSDictionary *dic =  [UserManager shareUserManager].resultCardDic;
            if ([dic count]) {
                NSArray *arr = [dic allKeys];
                if (arr.count) {
                    
                    for (NSString *pId in arr) {
                        if ([pId isEqualToString:parentId]) {
                            NSString *cc = [dic objectForKey:parentId];
                            
                                self.textView.text = cc;
                           
                            }
                        }
                    }
                }
            }
       
        
        
    }else {
        self.segmentedControl.hidden = YES;
        self.detailLabel.hidden = NO;
    }
    
}

//- (void)setDic:(NSDictionary *)dic {
//    _dic = dic;
//
//    self.titleLabel.text = safeString(dic[@"title"]);
//
//    if(safeString(dic[@"title"]).length == 0) {
//
//        self.titleLabel.text = safeString(dic[@"measureTagName"]);
//    }
//    self.statusImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"状态标签-%@",[self getTaskStatus:safeString(dic[@"status"])]]];
//
//    if ([dic[@"childrens"] count] ==0) {
//        return;
//    }
//    self.detailLabel.text = safeString(self.dic[@"measureValueAlias"]);
//    if (safeString(dic[@"unit"]).length > 0) {
//        self.detailLabel.text = [NSString stringWithFormat:@"%@%@",safeString(dic[@"measureValueAlias"]),safeString(dic[@"unit"])];
//    }
//    //    NSDictionary *fifDic = [self.dic[@"childrens"] firstObject];
////
////    if([safeString(fifDic[@"type"]) isEqualToString:@"textarea"] ||[safeString(fifDic[@"type"]) isEqualToString:@"charset"] ) {
////        self.segmentedControl.hidden = YES;
////        self.detailLabel.hidden = NO;
////        self.detailLabel.text = safeString(self.dic[@"measureValueAlias"]);
////    }else if([safeString(fifDic[@"type"]) isEqualToString:@"radio"] ||[safeString(fifDic[@"type"])  isEqualToString:@"select"]) {
////        if ([UserManager shareUserManager].isChangeTask) {
////            self.segmentedControl.userInteractionEnabled = YES;
////        }else {
////            self.segmentedControl.userInteractionEnabled = NO;
////        }
////        self.segmentedControl.hidden = NO;
////        if ([dic[@"childrens"] count] >0) {
////            NSDictionary *dd = [dic[@"childrens"] firstObject];
////            NSString *value = safeString(dd[@"value"]) ;
////            NSString *valueNum = safeString(self.dic[@"measureValueAlias"]) ;
////            if (value.length >0) {
////
////                NSArray *array = [value componentsSeparatedByString:@"@&@"];
////                if (array.count == 2) {
////                    [self.segmentedControl setTitle:safeString(array[0]) forSegmentAtIndex:0];
////                    [self.segmentedControl setTitle:safeString(array[1]) forSegmentAtIndex:1];
////                    if (valueNum.length >0) {
////                        if ([valueNum isEqualToString:array[0]]) {
////                            self.segmentedControl.selectedSegmentIndex = 0;
////
////                        }else if ([valueNum isEqualToString:array[1]]) {
////                            self.segmentedControl.selectedSegmentIndex = 1;
////
////                        }else {
////                            self.segmentedControl.selectedSegmentIndex = 2;
////                        }
////                    }else {
////                        self.segmentedControl.selectedSegmentIndex = 2;
////                    }
////                }
////            }else {
////
////                NSArray *array = [NSArray arrayWithObjects:@"正常",@"不正常", nil];
////                if (array.count == 2) {
////                    [self.segmentedControl setTitle:safeString(array[0]) forSegmentAtIndex:0];
////                    [self.segmentedControl setTitle:safeString(array[1]) forSegmentAtIndex:1];
////
////                }
////            }
////
////
////    }
////    self.detailLabel.hidden = YES;
////}
//
//    NSDictionary *dd = nil;
//    NSArray *arr = _dic[@"childrens"];
//    if (arr.count >0) {
//        dd = [arr firstObject];
//    }
//     if ([_dic[@"levelMax"] isEqualToString:@"4"]) {
//
//
//        if(safeString(dic[@"measureValueAlias"]).length >0){
//            self.segmentedControl.hidden = YES;
//            self.detailLabel.hidden = NO;
//        }else {
//
//
//            if([safeString(dd[@"type"])  isEqualToString:@"charset"]
//               || [safeString(dd[@"type"])  isEqualToString:@"radio"]) {
//                if ([UserManager shareUserManager].isChangeTask) {
//                    self.segmentedControl.userInteractionEnabled = YES;
//                }else {
//                    self.segmentedControl.userInteractionEnabled = NO;
//                }
//                self.segmentedControl.hidden = NO;
//
//                    self.detailLabel.hidden = YES;
//
//                if ([_dic[@"childrens"] count] >0) {
//                    NSDictionary *dd = [_dic[@"childrens"] firstObject];
//                    NSString *value = safeString(dd[@"value"]) ;
//                    NSString *valueNum = safeString(_dic[@"measureValueAlias"]) ;
//                    if (value.length >0) {
//
//                        NSArray *array = [value componentsSeparatedByString:@"@&@"];
//                        if (array.count == 2) {
//                            [self.segmentedControl setTitle:safeString(array[0]) forSegmentAtIndex:0];
//                            [self.segmentedControl setTitle:safeString(array[1]) forSegmentAtIndex:1];
//                            if (valueNum.length >0) {
//                                if ([valueNum isEqualToString:array[0]]) {
//                                    self.segmentedControl.selectedSegmentIndex = 0;
//
//                                }else if ([valueNum isEqualToString:array[1]]) {
//                                    self.segmentedControl.selectedSegmentIndex = 1;
//
//                                }else {
//                                    self.segmentedControl.selectedSegmentIndex = 2;
//                                }
//                            }else {
//                                self.segmentedControl.selectedSegmentIndex = 2;
//                            }
//                        }
//                    }else {
////                        if (value.length == 0 && valueNum.length >0) {
////                            self.detailLabel.hidden = NO;
////                            self.segmentedControl.hidden = YES;
////                        }
//                        NSArray *array = [NSArray arrayWithObjects:@"正常",@"不正常", nil];
//                        if (array.count == 2) {
//                            [self.segmentedControl setTitle:safeString(array[0]) forSegmentAtIndex:0];
//                            [self.segmentedControl setTitle:safeString(array[1]) forSegmentAtIndex:1];
//
//                        }
//                    }
//
//
//                }
//
//
//            }else if([safeString(_dic[@"type"]) isEqualToString:@"textarea"]) {
//
//
//            }else if([safeString(_dic[@"type"])  isEqualToString:@"select"]) {
//
//            }else if([safeString(_dic[@"type"]) isEqualToString:@"input"]) {
//                if ([UserManager shareUserManager].isChangeTask) {
//                    self.segmentedControl.userInteractionEnabled = YES;
//                }else {
//                    self.segmentedControl.userInteractionEnabled = NO;
//                }
//                self.segmentedControl.hidden = NO;
//                if ([_dic[@"childrens"] count] >0) {
//                    NSDictionary *dd = [_dic[@"childrens"] firstObject];
//                    NSString *value = safeString(dd[@"value"]) ;
//                    NSString *valueNum = safeString(_dic[@"measureValueAlias"]) ;
//                    if (value.length >0) {
//
//                        NSArray *array = [value componentsSeparatedByString:@"@&@"];
//                        if (array.count == 2) {
//                            [self.segmentedControl setTitle:safeString(array[0]) forSegmentAtIndex:0];
//                            [self.segmentedControl setTitle:safeString(array[1]) forSegmentAtIndex:1];
//                            if (valueNum.length >0) {
//                                if ([valueNum isEqualToString:array[0]]) {
//                                    self.segmentedControl.selectedSegmentIndex = 0;
//
//                                }else if ([valueNum isEqualToString:array[1]]) {
//                                    self.segmentedControl.selectedSegmentIndex = 1;
//
//                                }else {
//                                    self.segmentedControl.selectedSegmentIndex = 2;
//                                }
//                            }else {
//                                self.segmentedControl.selectedSegmentIndex = 2;
//                            }
//                        }
//                    }
//
//
//                }
//                self.detailLabel.hidden = YES;
//            }
//        }
//        }else {
//
//                NSArray *chilArr = self.dic[@"childrens"];
//                if (chilArr.count == 0) {
//                    return;
//                }
//                NSDictionary *fifDic = [chilArr firstObject];
//
//                if([safeString(fifDic[@"type"])  isEqualToString:@"charset"]
//                   || [safeString(fifDic[@"type"])  isEqualToString:@"radio"]) {
//                    if ([UserManager shareUserManager].isChangeTask) {
//                        self.segmentedControl.userInteractionEnabled = YES;
//                    }else {
//                        self.segmentedControl.userInteractionEnabled = NO;
//                    }
//                    self.segmentedControl.hidden = NO;
//
//                        self.detailLabel.hidden  = YES;
//
//                    if ([_dic[@"childrens"] count] >0) {
//                        NSDictionary *dd = [_dic[@"childrens"] firstObject];
//                        NSString *value = safeString(dd[@"value"]) ;
//                        NSString *valueNum = safeString(_dic[@"measureValueAlias"]) ;
//                        if (value.length >0) {
//
//                            NSArray *array = [value componentsSeparatedByString:@"@&@"];
//                            if (array.count == 2) {
//                                [self.segmentedControl setTitle:safeString(array[0]) forSegmentAtIndex:0];
//                                [self.segmentedControl setTitle:safeString(array[1]) forSegmentAtIndex:1];
//                                if (valueNum.length >0) {
//                                    if ([valueNum isEqualToString:array[0]]) {
//                                        self.segmentedControl.selectedSegmentIndex = 0;
//
//                                    }else if ([valueNum isEqualToString:array[1]]) {
//                                        self.segmentedControl.selectedSegmentIndex = 1;
//
//                                    }else {
//                                        self.segmentedControl.selectedSegmentIndex = 2;
//                                    }
//                                }else {
//                                    self.segmentedControl.selectedSegmentIndex = 2;
//                                }
//                            }
//                        }else {
////                            if (value.length == 0 && valueNum.length >0) {
////                                self.detailLabel.hidden = NO;
////                                self.segmentedControl.hidden = YES;
////                            }
//                            NSArray *array = [NSArray arrayWithObjects:@"正常",@"不正常", nil];
//                            if (array.count == 2) {
//                                [self.segmentedControl setTitle:safeString(array[0]) forSegmentAtIndex:0];
//                                [self.segmentedControl setTitle:safeString(array[1]) forSegmentAtIndex:1];
//
//                            }
//                        }
//
//
//                    }
//
//
//                }else if([safeString(fifDic[@"type"]) isEqualToString:@"textarea"]) {
//
//
//                }else if([safeString(fifDic[@"type"])  isEqualToString:@"select"]) {
//
//                }else if([safeString(fifDic[@"type"]) isEqualToString:@"input"]) {
//                    if ([UserManager shareUserManager].isChangeTask) {
//                        self.segmentedControl.userInteractionEnabled = YES;
//                    }else {
//                        self.segmentedControl.userInteractionEnabled = NO;
//                    }
//                    self.segmentedControl.hidden = NO;
//                    if ([fifDic[@"childrens"] count] >0) {
//                        NSDictionary *dd = [_dic[@"childrens"] firstObject];
//                        NSString *value = safeString(dd[@"value"]) ;
//                        NSString *valueNum = safeString(_dic[@"measureValueAlias"]) ;
//                        if (value.length >0) {
//
//                            NSArray *array = [value componentsSeparatedByString:@"@&@"];
//                            if (array.count == 2) {
//                                [self.segmentedControl setTitle:safeString(array[0]) forSegmentAtIndex:0];
//                                [self.segmentedControl setTitle:safeString(array[1]) forSegmentAtIndex:1];
//                                if (valueNum.length >0) {
//                                    if ([valueNum isEqualToString:array[0]]) {
//                                        self.segmentedControl.selectedSegmentIndex = 0;
//
//                                    }else if ([valueNum isEqualToString:array[1]]) {
//                                        self.segmentedControl.selectedSegmentIndex = 1;
//
//                                    }else {
//                                        self.segmentedControl.selectedSegmentIndex = 2;
//                                    }
//                                }else {
//                                    self.segmentedControl.selectedSegmentIndex = 2;
//                                }
//                            }
//                        }
//
//
//                    }
//
//                }
//            }
//
//
//    }

- (NSString *)getTaskStatus :(NSString *)status {
    NSString *ss = @"已完成";
    if ([status isEqualToString:@"0"]) {
        ss = @"待执行";
    }else if ([status isEqualToString:@"1"]) {
        ss = @"进行中";
    }else if ([status isEqualToString:@"2"]) {
        ss = @"已完成";
    }else if ([status isEqualToString:@"3"]) {
        ss = @"逾期未完成";
    }else if ([status isEqualToString:@"4"]) {
        ss = @"逾期完成";
    }else if ([status isEqualToString:@"5"]) {
        ss = @"待领取";
    }else if ([status isEqualToString:@"6"]) {
        ss = @"待指派";
    }
    return ss;
    
}

- (void)createSegment {
    
    NSArray *array = [NSArray arrayWithObjects:@"正常",@"不正常", nil];
    
    [self.segmentedControl removeFromSuperview];
    
    self.segmentedControl = [[KG_UpdateSegmentControl alloc]initWithItems:array];
    self.segmentedControl.frame = CGRectMake(SCREEN_WIDTH - 32 -84, 8,84,24);
    
    
    
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF"]}forState:UIControlStateSelected];
    
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#2F5ED1"],NSFontAttributeName:[UIFont boldSystemFontOfSize:10.0f]}forState:UIControlStateNormal];
    [self addSubview:self.segmentedControl];
    self.segmentedControl.userInteractionEnabled = NO;
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
        make.centerY.equalTo(self.mas_centerY);
        
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
    [UserManager shareUserManager].changeEquipStatus = YES;
    NSMutableDictionary *toDic = [NSMutableDictionary dictionary];
    
    NSDictionary *resultDic  = [UserManager shareUserManager].resultCardDic;
    [toDic addEntriesFromDictionary:resultDic];
    NSDictionary *dd = [self.dic[@"childrens"] firstObject];
    
    NSString *infoId = safeString(dd[@"parentId"]);
    NSString *value = safeString(dd[@"value"]) ;
    
    if (value.length >0) {
        
        NSArray *array = [value componentsSeparatedByString:@"@&@"];
        
        if (array.count == 2) {
            
            NSString *valueNum = safeString(array[sender.selectedSegmentIndex]);
            //            for (NSString *str in [resultDic allKeys]) {
            //                NSLog(@"%@",str);
            //                NSLog(@"%@",infoId);
            //                if ([str isEqualToString:infoId]) {
            NSMutableDictionary *aDic = [NSMutableDictionary dictionary];
            [aDic setValue:safeString(valueNum) forKey:safeString(infoId)];
            [toDic addEntriesFromDictionary:aDic];
            //                }
            //            }
            
            [UserManager shareUserManager].resultCardDic = toDic;
            
        }
        
    }else {
        NSArray *array = [NSArray arrayWithObjects:@"正常",@"不正常", nil];
        if (array.count == 2) {
            NSString *valueNum = safeString(array[sender.selectedSegmentIndex]);
            NSMutableDictionary *aDic = [NSMutableDictionary dictionary];
            [aDic setValue:safeString(valueNum) forKey:safeString(infoId)];
            [toDic addEntriesFromDictionary:aDic];
            [UserManager shareUserManager].resultCardDic = toDic;
        }
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

- (void)createButton {
    self.selectBtn = [[UIButton alloc]init];
    [self.selectBtn setTitleColor:[UIColor colorWithHexString:@"#626470"] forState:UIControlStateNormal];
   
    self.selectBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [self.selectBtn addTarget:self action:@selector(selectButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    self.selectBtn.userInteractionEnabled = NO;
    [self addSubview:self.selectBtn];
//    self.selectBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 90, 0, 0);
    [self.selectBtn setImage:[UIImage imageNamed:@"common_right"] forState:UIControlStateNormal];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.equalTo(self.mas_height);
        make.width.equalTo(@120);
    }];
    
}
- (void)selectButtonMethod {
    self.alertView.hidden = NO;
    
    self.alertView.didselTextBlock = ^(NSDictionary * _Nonnull str) {
        if (isSafeDictionary(str)) {
            if (str.count) {
                [UserManager shareUserManager].changeEquipStatus = YES;
                NSMutableDictionary *toDic = [NSMutableDictionary dictionary];
                NSDictionary *resultDic  = [UserManager shareUserManager].resultCardDic;
                [toDic addEntriesFromDictionary:resultDic];
                [toDic addEntriesFromDictionary:str];
                
                [UserManager shareUserManager].resultCardDic = toDic;
                
                NSString *ss = safeString([[str allValues] firstObject]);
                [self.selectBtn setTitle:ss forState:UIControlStateNormal];
            }
            
        }
        
        
    };
    
}
- (KG_SelectCardTypeView *)alertView {
    
    if (!_alertView) {
        _alertView = [[KG_SelectCardTypeView alloc]init];
        _alertView.dataDic = self.dic;
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
        make.centerY.equalTo(self.mas_centerY);
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
    
    NSDictionary *dd = [self.dic[@"childrens"] firstObject];
       
     NSString *infoId = safeString(dd[@"parentId"]);
    [UserManager shareUserManager].changeEquipStatus = YES;
    NSMutableDictionary *toDic = [NSMutableDictionary dictionary];
    NSDictionary *resultDic  = [UserManager shareUserManager].resultCardDic;
    [toDic addEntriesFromDictionary:resultDic];
    
    NSMutableDictionary *aDic = [NSMutableDictionary dictionary];
    [aDic setValue:safeString(textView.text) forKey:safeString(infoId)];
    [toDic addEntriesFromDictionary:aDic];
    
    [UserManager shareUserManager].resultCardDic = toDic;
    
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
