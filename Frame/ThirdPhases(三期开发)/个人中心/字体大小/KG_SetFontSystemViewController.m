//
//  KG_CenterCommonViewController.m
//  Frame
//
//  Created by zhangran on 2020/12/10.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_SetFontSystemViewController.h"

#import "KG_CenterCommonCell.h"
#import "KG_SetFontSystemViewController.h"
#import "KG_NewMessNotiViewController.h"

#import "KG_SetFontSystemLeftCell.h"
#import "KG_SetFontSystemRightCell.h"

#import "CLSlider.h"
#import "FMChooseFontView.h"
#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_SetFontSystemViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
}

@property (nonatomic,strong)    CLSlider                 *mSlider1;

@property (nonatomic, strong)   UITableView              *tableView;

@property (nonatomic, strong)   NSArray                  *dataArray;

@property (nonatomic, strong)   UITextField              *titleLabel;

@property (nonatomic, strong)   UIView                   *navigationView;

@property (nonatomic, strong)   UIButton                 *rightButton;


@property (nonatomic, assign)   int                      intFontSize;


@end

@implementation KG_SetFontSystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor colorWithHexString:@"#F6F7F9"];
    [self initData];
    // Do any additional setup after loading the view.
    [self createNaviTopView];
    
    [self createTableView];
    
    [self createSliderView];
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"StationDetailController viewWillAppear");
    if (@available(iOS 13.0, *)){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    }else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self.navigationController setNavigationBarHidden:YES];
 
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    
}

- (void)initData {
    
    self.dataArray = [NSArray arrayWithObjects:@"新消息通知",@"字体大小",@"清除缓存",nil];
    self.intFontSize = 16;
}

- (void)createNaviTopView {
    
    UIImageView *topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT +44)];
    [self.view addSubview:topImage1];
    topImage1.backgroundColor  =[UIColor whiteColor];
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 44)];
    [self.view addSubview:topImage];
    topImage.backgroundColor  =[UIColor whiteColor];
    topImage.image = [self createImageWithColor:[UIColor whiteColor]];
    /** 导航栏 **/
    self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_NavBar)];
    self.navigationView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.navigationView];
    
    /** 添加标题栏 **/
    [self.navigationView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navigationView.mas_centerX);
        make.top.equalTo(self.navigationView.mas_top).offset(Height_StatusBar+9);
    }];
    self.titleLabel.text = safeString(@"字体大小");
    
    /** 返回按钮 **/
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, (Height_NavBar -44)/2, 44, 44)];
    [backBtn addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.left.equalTo(self.navigationView.mas_left);
    }];
    
    //按钮设置点击范围扩大.实际显示区域为图片的区域
    UIImageView *leftImage = [[UIImageView alloc] init];
    leftImage.image = IMAGE(@"back_black");
    [backBtn addSubview:leftImage];
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backBtn.mas_centerX);
        make.centerY.equalTo(backBtn.mas_centerY);
    }];
  
}

- (void)backButtonClick:(UIButton *)button {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeFontNotification" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}

/** 标题栏 **/
- (UITextField *)titleLabel {
    if (!_titleLabel) {
        UITextField *titleLabel = [[UITextField alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
        titleLabel.userInteractionEnabled = NO;
        _titleLabel = titleLabel;
    }
    return _titleLabel;
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

- (void)createTableView {
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(NAVIGATIONBAR_HEIGHT);
        make.height.equalTo(@10);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(NAVIGATIONBAR_HEIGHT +10);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

-(NSArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.row == 0) {
        return 83;
    }else if (indexPath.row == 1) {
        return 96;
    }else if (indexPath.row == 2) {
        return 150;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0) {
        KG_SetFontSystemLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_SetFontSystemLeftCell"];
        
        if (cell == nil) {
            cell = [[KG_SetFontSystemLeftCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_SetFontSystemLeftCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
//        cell.fontSize = self.intFontSize;
        
        return  cell;
    }else {
        
        KG_SetFontSystemRightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_SetFontSystemRightCell"];
        
        if (cell == nil) {
            cell = [[KG_SetFontSystemRightCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_SetFontSystemRightCell"];
            cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if(indexPath.row == 1) {
            
            cell.titleLabel.text = safeString(@"拖动下面的滑块，可设置字体大小");
        }else if(indexPath.row == 2) {
            
       
            cell.titleLabel.text = @"设置后，会改变所有功能的字体大小。如果在使用过程中存 在问题或意见，可反馈给智慧 台站团队";
            
        }
//        cell.fontSize = self.intFontSize;
        return  cell;
    }
 
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
}


- (void)createSliderView {
    
//    UIView *botView = [[UIView alloc]init];
//    [self.view addSubview:botView];
//    botView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
//    [botView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view.mas_bottom).offset(-kDefectHeight);
//        make.height.equalTo(@94);
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//    }];
    
    [FMChooseFontView showChooseFontViewWith:^(FMChooseFont currentFont, NSInteger tag) {
        //            [FMFontManager refreshFontWithView:self.view];
        [[ChangeFontManager shareManager]switchLanguageFontCompletionBlock:^(BOOL success) {
            
        }];
        
    } completion:^(FMChooseFont currentFont, NSInteger tag) {
        if (tag == 1) {
            //                [FMFontManager refreshFontWithView:self.view];
            [[ChangeFontManager shareManager]switchLanguageFontCompletionBlock:^(BOOL success) {
                
            }];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeFontNotification" object:nil];
        }else if (tag == 2){
            
        }
    }];

    
    //    UILabel *firstLabel = [[UILabel alloc]init];
    //    [botView addSubview:firstLabel];
    //    firstLabel.text = @"A";
    //    firstLabel.font = [UIFont systemFontOfSize:14];
    //    firstLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    //    [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.height.equalTo(@20);
    //        make.top.equalTo(botView.mas_top).offset(21);
    //        make.left.equalTo(botView.mas_left).offset(21.5);
    //        make.width.equalTo(@22);
    //    }];
    //
    //    UILabel *secondLabel = [[UILabel alloc]init];
    //    [botView addSubview:secondLabel];
    //    secondLabel.text = @"标准";
    //    secondLabel.font = [UIFont systemFontOfSize:16];
    //    secondLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    //    [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.height.equalTo(@20);
    //        make.top.equalTo(botView.mas_top).offset(21);
    //        make.left.equalTo(botView.mas_left).offset(56);
    //        make.width.equalTo(@44);
    //    }];
    //
    //    UILabel *thirdLabel = [[UILabel alloc]init];
    //    [botView addSubview:thirdLabel];
    //    thirdLabel.text = @"A";
    //    thirdLabel.font = [UIFont systemFontOfSize:28];
    //    thirdLabel.textAlignment = NSTextAlignmentRight;
    //    thirdLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    //    [thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.height.equalTo(@20);
    //        make.top.equalTo(botView.mas_top).offset(21);
    //        make.right.equalTo(botView.mas_right).offset(-20);
    //        make.width.equalTo(@44);
    //    }];
    //
    //    self.mSlider1 = [CLSlider new];
    //    self.mSlider1.sliderStyle = CLSliderStyle_Nomal;
//    self.mSlider1.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
//    self.mSlider1.thumbTintColor = [UIColor colorWithHexString:@"#FFFFFF"];
//    self.mSlider1.thumbShadowColor = [UIColor colorWithHexString:@"#ABABAB"];
//    self.mSlider1.thumbShadowOpacity = 0.9f;
//    self.mSlider1.thumbDiameter = 25;
//    self.mSlider1.scaleLineColor = [UIColor colorWithHexString:@"##ABABAB"];
//    self.mSlider1.scaleLineWidth = 2.0f;
//    self.mSlider1.scaleLineHeight = 10;
//    self.mSlider1.scaleLineNumber = 7;
//    [self.mSlider1 setSelectedIndex:1];
//    [self.mSlider1 addTarget:self action:@selector(slider01ChangeAction:) forControlEvents:UIControlEventValueChanged];
//    [botView addSubview:self.mSlider1];
//    [self.mSlider1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(botView.mas_bottom);
//        make.height.equalTo(@54);
//        make.left.equalTo(botView.mas_left).offset(16);
//        make.right.equalTo(botView.mas_right).offset(-16);
//    }];
//
}

- (void)slider01ChangeAction:(CLSlider *)sender {
    
    self.intFontSize = (int)sender.currentIdx;
    [self.tableView reloadData];
    
    [self saveFont:sender.currentIdx*2];
//    self.titleLabel.font = [UIFont systemFontOfSize:self.intFontSize weight:UIFontWeightMedium];
    
//    //只取整数值，固定间距
//    NSString *tempStr = [self numberFormat:sender.currentIdx];
//    if (tempStr.floatValue ==sender.currentIdx) {
//        return;
//    }
//    [sender setValue:tempStr.integerValue];
//    if (tempStr.integerValue != self.currentFont) {
//        [self saveFont:tempStr.integerValue];
//        !self.state?:self.state(self.currentFont,0);
//    }
    
}

-(void)saveFont:(FMChooseFont)font{
    [FMFontManager savePreFont:self.intFontSize currentFont:font];
//    self.currentFont = font;
}

- (NSString *)numberFormat:(float)num
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"0"];
    return [formatter stringFromNumber:[NSNumber numberWithFloat:num]];
}
@end
