//
//  StationScrollViewController.m
//  Frame
//
//  Created by hibayWill on 2018/3/30.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "StationScrollViewController.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define titleWidth SCREEN_WIDTH/_titleArray.count
#define titleHeight 40
#define backColor [UIColor colorWithWhite:0.300 alpha:1.000]

@interface StationScrollViewController ()<UIScrollViewDelegate> {
    
    UIButton *selectButton;
    UIView *_sliderView;
    UIViewController *_viewController;
    UIScrollView *_scrollView;
}

@property (nonatomic, strong) NSMutableArray *buttonArray;

@end

@implementation StationScrollViewController

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
    
    
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = BGColor;
    [self.view addSubview:titleView];
    titleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, FrameWidth(200));
    //名称
    UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FrameWidth(150))];
    bgView1.backgroundColor = [UIColor whiteColor];
    [titleView addSubview:bgView1];
    //110 600
    UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(FrameWidth(20), FrameWidth(15), FrameWidth(600), FrameWidth(110))];
    bgView2.backgroundColor = [UIColor whiteColor];
    bgView2.layer.cornerRadius = FrameWidth(55);
    bgView2.layer.borderWidth = 2;
    bgView2.layer.borderColor = BGColor.CGColor;
    [titleView addSubview:bgView2];
    //UPS图片
    UIImageView *nowMachine = [[UIImageView alloc] initWithFrame:CGRectMake(FrameWidth(22), FrameWidth(18), FrameWidth(70), FrameWidth(70))];
    NSString * img1 = @"equipment";
    if([AllEquipment indexOfObject:_machineDetail[@"category"]] != NSNotFound){
        img1 = _machineDetail[@"category"];
        
    }
    nowMachine.image = [UIImage imageNamed:img1];
    [bgView2 addSubview:nowMachine];
    //UPS名称
    UILabel *nowMachineName = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(120), FrameWidth(18), FrameWidth(140), FrameWidth(70))];
    
    nowMachineName.text = [NSString stringWithFormat:@"%@ ",_machineDetail[@"machine_name"]];
    nowMachineName.numberOfLines = 2;
    nowMachineName.font = FontSize(17);
    CGSize size = [nowMachineName.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:nowMachineName.font,NSFontAttributeName,nil]];
    [nowMachineName setFrame:CGRectMake(FrameWidth(120), FrameWidth(18), size.width+FrameWidth(10), FrameWidth(70))];
    
    
    [bgView2 addSubview:nowMachineName];
    //UPS状态label
    
    UILabel *nowMachineLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nowMachineName.frame) + 5, FrameWidth(18), FrameWidth(130), FrameWidth(70))];
    nowMachineLabel.text = @"当前状态:";
    nowMachineLabel.font = FontSize(15);
    [bgView2 addSubview:nowMachineLabel];
    CGSize size1 = [nowMachineLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:nowMachineLabel.font,NSFontAttributeName,nil]];
    //状态图标
    UIFont * warnFont = FontBSize(13);
    if([_machineDetail[@"totalDetail"][@"status"] isEqualToString:@"1"]  ){
        UIButton *warnBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(10)+size1.width, FrameWidth(23), FrameWidth(120), FrameWidth(28))];
        [warnBtn setBackgroundColor:warnColor];
        warnBtn.layer.cornerRadius = 2;
        warnBtn.titleLabel.font = warnFont;
        [warnBtn setTitle:[NSString stringWithFormat:@"%@%@",@"告警数量",_machineDetail[@"totalDetail"][@"totalNum"]] forState:UIControlStateNormal];
        warnBtn.titleLabel.textColor = [UIColor whiteColor];
        [nowMachineLabel addSubview:warnBtn];
        //[warnBtn setHidden:true];
        UIButton *levelBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(140)+size1.width, FrameWidth(23), FrameWidth(60), FrameWidth(28))];
        levelBtn.layer.cornerRadius = 2;
        levelBtn.titleLabel.font = FontBSize(13);
        
        [CommonExtension addLevelBtn:levelBtn level:_machineDetail[@"totalDetail"][@"totalLevel"]];
        
        
        [nowMachineLabel addSubview:levelBtn];
        
        
    }else if([_machineDetail[@"totalDetail"][@"status"] isEqualToString:@"2"]  ){
        
        UIButton *normalBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(10)+size1.width, FrameWidth(23), FrameWidth(60), FrameWidth(28))];
        [normalBtn setTitle: @"--"   forState:UIControlStateNormal];
        [nowMachineLabel addSubview:normalBtn];
        
    }else if([_machineDetail[@"totalDetail"][@"status"] isEqualToString:@"3"]  ){
        
        UIButton *normalBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(10)+size1.width, FrameWidth(23), FrameWidth(60), FrameWidth(28))];
        [normalBtn setBackgroundColor:FrameColor(252,201,84)];
        normalBtn.layer.cornerRadius = 2;
        normalBtn.titleLabel.font = FontBSize(13);
        [normalBtn setTitle: @"正常"   forState:UIControlStateNormal];
        normalBtn.titleLabel.textColor = [UIColor whiteColor];
        [nowMachineLabel addSubview:normalBtn];
        
    }else{
        
        UIButton *normalBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(10)+size1.width, FrameWidth(23), FrameWidth(60), FrameWidth(28))];
        [normalBtn setBackgroundColor:FrameColor(120, 203, 161)];
        normalBtn.layer.cornerRadius = 2;
        normalBtn.titleLabel.font = FontBSize(13);
        [normalBtn setTitle: @"正常"   forState:UIControlStateNormal];
        normalBtn.titleLabel.textColor = [UIColor whiteColor];
        [nowMachineLabel addSubview:normalBtn];
        
    }
    
    
    
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
    float sliderV_X = ( _titleArray.count-1)*18+30;
    float sliderVX = WIDTH_SCREEN - FrameWidth(sliderV_X);
    UIView *sliderV=[[UIView alloc]initWithFrame:CGRectMake(sliderVX, FrameWidth(170), 5, 5)];
    
    sliderV.layer.cornerRadius = 2.5;
    sliderV.backgroundColor = navigationColor;
    [titleView insertSubview:sliderV atIndex:1];
    //[titleView addSubview:sliderV];
    _sliderView=sliderV;
    for (int i = 0; i <  _titleArray.count; i++) {
        //滑块
        float sliderV_X = i*18+30;
        //float sliderVX = WIDTH_SCREEN - FrameWidth(sliderV_X);
        
        float sliderX = WIDTH_SCREEN - FrameWidth(sliderV_X);//WIDTH_SCREEN - FrameWidth(i*18+30);
        UIView *sliderV=[[UIView alloc]initWithFrame:CGRectMake(sliderX, FrameWidth(170), 5, 5)];
        sliderV.layer.cornerRadius = 2.5;
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
        float sliderV_X = (_titleArray.count - index -1)*18+30;
        //float sliderVX = WIDTH_SCREEN - FrameWidth(sliderV_X);
        
        float sliderX = WIDTH_SCREEN - FrameWidth(sliderV_X);//WIDTH_SCREEN - FrameWidth(i*18+30);
        _sliderView.frame = CGRectMake(sliderX, FrameWidth(170), 5, 5);
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
    scrollView.frame = CGRectMake(0, FrameWidth(190), SCREEN_WIDTH, SCREEN_HEIGHT - FrameWidth(200) - ZNAVViewH);
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

