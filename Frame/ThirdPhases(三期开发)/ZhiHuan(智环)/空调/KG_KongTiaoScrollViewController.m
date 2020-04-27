//
//  StationScrollViewController.m
//  Frame
//
//  Created by hibayWill on 2018/3/30.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "KG_KongTiaoScrollViewController.h"

#define titleWidth SCREEN_WIDTH/_titleArray.count
#define titleHeight 40
#define backColor [UIColor colorWithWhite:0.300 alpha:1.000]

@interface KG_KongTiaoScrollViewController ()<UIScrollViewDelegate> {
    
    UIButton *selectButton;
    UIView *_sliderView;
    UIViewController *_viewController;
    UIScrollView *_scrollView;
}

@property (nonatomic, strong) NSMutableArray *buttonArray;

@end

@implementation KG_KongTiaoScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _buttonArray = [NSMutableArray array];
    
}

- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = [titleArray copy];
    [self initWithTitleButton];
}

- (void)setControllerArray:(NSArray *)controllerArray {
    _controllerArray = [controllerArray copy];
    [self initWithController];
}

- (void)initWithTitleButton
{
    /* UIView *mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, FrameWidth(150))];
    [mainView setBackgroundColor:[UIColor whiteColor]];
    */
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = BGColor;
    [self.view addSubview:titleView];
    titleView.frame = CGRectMake(0, 0, SCREEN_WIDTH,81);
    //名称
    UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(16, 16, SCREEN_WIDTH -32, 50)];
    bgView1.backgroundColor = [UIColor whiteColor];
    bgView1.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    bgView1.layer.cornerRadius = 25;
    [titleView addSubview:bgView1];
   
    //UPS图片
    UIImageView *nowMachine = [[UIImageView alloc] initWithFrame:CGRectMake(7, 6, 38, 38)];
    NSString * img1 = @"ups_big";
//    if([AllEquipment indexOfObject:_machineDetail[@"category"]] != NSNotFound){
//        img1 = _machineDetail[@"category"];
//
//    }
    nowMachine.image = [UIImage imageNamed:img1];
    [bgView1 addSubview:nowMachine];
    //UPS名称
    UILabel *nowMachineName = [[UILabel alloc] initWithFrame:CGRectMake(55,0, 150, 50)];
    
    nowMachineName.text = [NSString stringWithFormat:@"%@ ",_machineDetail[@"machine_name"]];
    nowMachineName.numberOfLines = 2;
    nowMachineName.font = FontSize(17);
    nowMachineName.textColor = [UIColor colorWithHexString:@"#24252A"];
    CGSize size = [nowMachineName.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:nowMachineName.font,NSFontAttributeName,nil]];
   
    
    [bgView1 addSubview:nowMachineName];
    //UPS状态label
    
    UILabel *nowMachineLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nowMachineName.frame) + 5, FrameWidth(18), FrameWidth(130), FrameWidth(70))];
    nowMachineLabel.text = @"当前状态:";
    nowMachineLabel.font = FontSize(15);
    [bgView1 addSubview:nowMachineLabel];
    CGSize size1 = [nowMachineLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:nowMachineLabel.font,NSFontAttributeName,nil]];
    
    [nowMachineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView1.mas_right).offset(-55);
        make.centerY.equalTo(bgView1.mas_centerY);
        make.width.equalTo(@80);
        make.height.equalTo(@21);
    }];
    
    UIImageView *levelImage = [[UIImageView alloc]init];
    [bgView1 addSubview:levelImage];
    levelImage.image = [UIImage imageNamed:@"level_normal"];
    [bgView1 addSubview:levelImage];
    [levelImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView1.mas_right).offset(-18);
        make.width.equalTo(@32);
        make.height.equalTo(@17);
        make.centerY.equalTo(nowMachineLabel.mas_centerY);
    }];
    
//    //状态图标
//    UIFont * warnFont = FontBSize(13);
//    if([_machineDetail[@"totalDetail"][@"status"] isEqualToString:@"1"]  ){
//        UIButton *warnBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(10)+size1.width, FrameWidth(23), FrameWidth(120), FrameWidth(28))];
//        [warnBtn setBackgroundColor:warnColor];
//        warnBtn.layer.cornerRadius = 2;
//        warnBtn.titleLabel.font = warnFont;
//        [warnBtn setTitle:[NSString stringWithFormat:@"%@%@",@"告警数量",_machineDetail[@"totalDetail"][@"totalNum"]] forState:UIControlStateNormal];
//        warnBtn.titleLabel.textColor = [UIColor whiteColor];
//        [nowMachineLabel addSubview:warnBtn];
//        //[warnBtn setHidden:true];
//        UIButton *levelBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(140)+size1.width, FrameWidth(23), FrameWidth(60), FrameWidth(28))];
//        levelBtn.layer.cornerRadius = 2;
//        levelBtn.titleLabel.font = FontBSize(13);
//
//        [CommonExtension addLevelBtn:levelBtn level:_machineDetail[@"totalDetail"][@"totalLevel"]];
//
//
//        [nowMachineLabel addSubview:levelBtn];
//
//
//    }else if([_machineDetail[@"totalDetail"][@"status"] isEqualToString:@"2"]  ){
//
//        UIButton *normalBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(10)+size1.width, FrameWidth(23), FrameWidth(60), FrameWidth(28))];
//        [normalBtn setTitle: @"--"   forState:UIControlStateNormal];
//        [nowMachineLabel addSubview:normalBtn];
//
//    }else if([_machineDetail[@"totalDetail"][@"status"] isEqualToString:@"3"]  ){
//
//        UIButton *normalBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(10)+size1.width, FrameWidth(23), FrameWidth(60), FrameWidth(28))];
//        [normalBtn setBackgroundColor:FrameColor(252,201,84)];
//        normalBtn.layer.cornerRadius = 2;
//        normalBtn.titleLabel.font = FontBSize(13);
//        [normalBtn setTitle: @"正常"   forState:UIControlStateNormal];
//        normalBtn.titleLabel.textColor = [UIColor whiteColor];
//        [nowMachineLabel addSubview:normalBtn];
//
//    }else{
//
//        UIButton *normalBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(10)+size1.width, FrameWidth(23), FrameWidth(60), FrameWidth(28))];
//        [normalBtn setBackgroundColor:FrameColor(120, 203, 161)];
//        normalBtn.layer.cornerRadius = 2;
//        normalBtn.titleLabel.font = FontBSize(13);
//        [normalBtn setTitle: @"正常"   forState:UIControlStateNormal];
//        normalBtn.titleLabel.textColor = [UIColor whiteColor];
//        [nowMachineLabel addSubview:normalBtn];
//
//    }
//
//
//
    /*
    for (int i = 0; i < _titleArray.count; i++) {
        
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.frame = CGRectMake(titleWidth*i, 0, titleWidth, titleHeight);
        [titleButton setTitle:_titleArray[i] forState:UIControlStateNormal];
        [titleButton setTitleColor:backColor forState:UIControlStateNormal];
        titleButton.tag = 100+i;
        [titleButton addTarget:self action:@selector(scrollViewSelectToIndex:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:titleButton];
        if (i == 0) {
            selectButton = titleButton;
            [selectButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }
        [_buttonArray addObject:titleButton];
        
    }
     */
    //滑块
    float sliderV_X = ( _titleArray.count-1)*18;
    float sliderVX = WIDTH_SCREEN /2;
    UIView *sliderV=[[UIView alloc]initWithFrame:CGRectMake(sliderVX, 77, 6, 6)];
    
    sliderV.layer.cornerRadius = 3;
    sliderV.backgroundColor = [UIColor colorWithHexString:@"#005DC4"];
    [titleView insertSubview:sliderV atIndex:1];
    //[titleView addSubview:sliderV];
    _sliderView=sliderV;
    for (int i = 0; i <  _titleArray.count; i++) {
        //滑块
        float sliderV_X = i*18;
        //float sliderVX = WIDTH_SCREEN - FrameWidth(sliderV_X);
        
        float sliderX = WIDTH_SCREEN/2 - FrameWidth(sliderV_X);//WIDTH_SCREEN - FrameWidth(i*18+30);
        UIView *sliderV=[[UIView alloc]initWithFrame:CGRectMake(sliderX, 77, 6, 6)];
        sliderV.layer.cornerRadius = 3;
        sliderV.backgroundColor = [UIColor grayColor];
        [titleView insertSubview:sliderV atIndex:0];
        
    }
    
    
}

- (void)scrollViewSelectToIndex:(UIButton *)button
{
    NSLog(@"scrollViewSelectToIndex %ld",(long)button.tag);
    [self selectButton:button.tag-100];
    [UIView animateWithDuration:0 animations:^{
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH*(button.tag-100), 0);
    }];
}

//选择某个标题
- (void)selectButton:(NSInteger)index
{
    [UIView animateWithDuration:0.3 animations:^{
        float sliderV_X = (_titleArray.count - index -1)*18;
        //float sliderVX = WIDTH_SCREEN - FrameWidth(sliderV_X);
        
        float sliderX = WIDTH_SCREEN/2 - FrameWidth(sliderV_X);//WIDTH_SCREEN - FrameWidth(i*18+30);
        _sliderView.frame = CGRectMake(sliderX,77, 6, 6);
        //NSLog(@"selectButton  %f",sliderX);
        [self.view insertSubview:_sliderView atIndex:10];
    }];
    /*
    [selectButton setTitleColor:backColor forState:UIControlStateNormal];
    selectButton = _buttonArray[index];
    [selectButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    */
}

//监听滚动事件判断当前拖动到哪一个了
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
    [self selectButton:index];
    
}

- (void)initWithController
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    NSLog(@"SCREEN_HEIGHT %f",SCREEN_HEIGHT);
    NSLog(@"HEIGHT_SCREEN %f",HEIGHT_SCREEN);
    scrollView.frame = CGRectMake(0, 90, SCREEN_WIDTH, SCREEN_HEIGHT -90 - ZNAVViewH);
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor colorWithWhite:0.900 alpha:1.000];
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*_controllerArray.count, 0);
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    for (int i = 0; i < _controllerArray.count; i++) {
        UIView *viewcon = [[UIView alloc] init];
        UIViewController *viewcontroller = _controllerArray[i];
        viewcon = viewcontroller.view;
        viewcon.frame = CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, _scrollView.frameHeight);
        
        NSLog(@"_scrollView.frameHeight %f",_scrollView.frameHeight);
        [_scrollView addSubview:viewcon];
        
    }
    
}


@end

