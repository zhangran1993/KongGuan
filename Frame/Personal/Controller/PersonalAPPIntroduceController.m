//
//  PersonalAPPIntroduceController.m
//  Frame
//
//  Created by hibayWill on 2018/3/17.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "PersonalAPPIntroduceController.h"
#import "PersonalEditPwdController.h"
#import "FrameBaseRequest.h"

@interface PersonalAPPIntroduceController (){
}

@end

@implementation PersonalAPPIntroduceController

//static NSString * const reuseIdentifier = @"Cell";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"APP介绍";
    [self backBtn];
    [self loadBgView];
    
}
-(void)loadBgView{
    //背景色
    self.view.backgroundColor =  [UIColor  colorWithPatternImage:[UIImage imageNamed:@"personal_gray_bg"]] ;
    //logo和版本
    UIImageView *logoImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    
    logoImg.frame = CGRectMake(WIDTH_SCREEN/2-FrameWidth(60), FrameWidth(60), FrameWidth(120), FrameWidth(120));
    
    UILabel *vsersionLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH_SCREEN/2-FrameWidth(60),FrameWidth(200) ,FrameWidth(120), 20)];
    vsersionLabel.textAlignment = NSTextAlignmentCenter;
    vsersionLabel.text = AppVersion;
    [self.view addSubview:vsersionLabel];
    
    [self.view addSubview:logoImg];
    //APP介绍
    UILabel * intoductionLabel = [[UILabel alloc] initWithFrame:CGRectMake((WIDTH_SCREEN -FrameWidth(580))/2, FrameWidth(270), FrameWidth(580),FrameWidth(580))];
    
    intoductionLabel.numberOfLines = 20;
    intoductionLabel.font = FontSize(17);
    [intoductionLabel setTextColor:[UIColor grayColor]];
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置为30
    [paragraphStyle  setLineSpacing:5];
    NSString  *testString =  @"      智慧台站是一款针对民航空管业内人士提供通导外台站远程监控、信息通报、智能排故、大数据分析的专业软件。通过移动互联网帮助业内外台站维护人士第一时间掌握台站运行情况，引入大数据、AI技术，实现联动性智能运维，贯彻无人值守管理办法，提升外台站的应急处置能力，辅助台站管理人员综合决策，实现通导集约化管理。";
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:testString];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [testString length])];
    
    // 设置Label要显示的text
    [intoductionLabel  setAttributedText:setString];
    [intoductionLabel sizeToFit];
    
    
    
    [self.view addSubview:intoductionLabel];
    
    
    
}

-(void)backBtn{
    UIButton *leftButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButon.frame = CGRectMake(0,0,FrameWidth(60),FrameWidth(60));
    [leftButon setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [leftButon setContentEdgeInsets:UIEdgeInsetsMake(0, - FrameWidth(20), 0, FrameWidth(20))];
    //button.alignmentRectInsetsOverride = UIEdgeInsetsMake(0, offset, 0, -(offset));
    [leftButon addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc]initWithCustomView:leftButon];
    self.navigationItem.leftBarButtonItem = fixedButton;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
}
-(void)backAction {
    //[self dismissViewControllerAnimated:YES completion:nil];
    //return ;
    //[self.navigationController pushViewController:[[FrameLoginController alloc]init] animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end




