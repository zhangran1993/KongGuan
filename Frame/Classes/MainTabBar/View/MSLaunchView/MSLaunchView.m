//
//  MSLaunchView.m
//  MSLaunchView
//
//  Created by TuBo on 2018/11/8.
//  Copyright © 2018 TuBur. All rights reserved.
//

#import "MSLaunchView.h"
#import "MSLaunchOperation.h"
#import <UIImageView+WebCache.h>
#define MSHidden_TIME 1.0
#define MSScreenW   [UIScreen mainScreen].bounds.size.width
#define MSScreenH   [UIScreen mainScreen].bounds.size.height

#define MS_LAZY(object,assignment) (object = object ?:assignment)

@interface MSLaunchView()<UIScrollViewDelegate>{
    UIImageView *launchView;//获取到最后一个imageView 添加自定义按钮
    //
    CGFloat oldlastContentOffset;
    CGFloat newlastContentOffset;
    
    CGRect guideFrame;//
    CGRect videoFrame;
    UIImage *gbgImage;//按钮背景图片
}
@property (nonatomic, strong) UIButton *CountdownButton;//倒计时按钮
@property (nonatomic, strong) UIButton *skipButton;//跳过按钮
@property (nonatomic, strong) UIButton *guideButton;//立即进入按钮
@property (nonatomic, strong) UIView *adView;
@property (nonatomic, strong) UIPageControl           *imagePageControl;
@property (nonatomic, strong) AVPlayerViewController  *playerController;//视频播放
@property (nonatomic, copy) NSMutableArray<NSString *> *dataImages; //图片数据
@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, assign) BOOL isScrollOut;//是否左滑推出
@property (nonatomic, assign) int secondsCountDown;
@property (nonatomic, assign) NSTimer *countDownTimer;//倒计时计时器
@property (nonatomic, strong) NSArray *imageArray;
@end

static NSString *const kAppVersion = @"appVersion";

@implementation MSLaunchView

#pragma mark - 创建对象-->>倒计时+不带button 左滑动消失
+(instancetype)launchWithImage:(NSString *)image launchWithImages:(NSArray <NSString *>*)images{
    return [[MSLaunchView alloc] initWithImageframe:CGRectZero image:image images:images];
    
}


#pragma mark - 创建对象-->>不带button 左滑动消失
+(instancetype)launchWithImages:(NSArray <NSString *>*)images{
    return [[MSLaunchView alloc] initWithVideoframe:CGRectZero guideFrame:CGRectZero images:images gImage:nil sbName:nil videoUrl:nil isScrollOut:YES];
}


#pragma mark - 创建对象-->>带button 左滑动不消失
+(instancetype)launchWithImages:(NSArray <NSString *>*)images guideFrame:(CGRect)gframe  gImage:(UIImage *)gImage{
    return [[MSLaunchView alloc] initWithVideoframe:CGRectZero guideFrame:gframe images:images gImage:gImage sbName:nil videoUrl:nil isScrollOut:NO];
}



#pragma mark - 用storyboard创建的项目时调用，不带button 左滑动消失
+(instancetype)launchWithImages:(NSArray <NSString *>*)images sbName:(NSString *)sbName{
    return [[MSLaunchView alloc] initWithVideoframe:CGRectZero guideFrame:CGRectZero images:images gImage:nil sbName:![MSLaunchView isBlankString:sbName]? sbName:@"Main" videoUrl:nil isScrollOut:YES];
}

#pragma mark - 用storyboard创建的项目时调用，带button左滑动不消失
+(instancetype)launchWithImages:(NSArray <NSString *>*)images sbName:(NSString *)sbName guideFrame:(CGRect)gframe gImage:(UIImage *)gImage{
    return [[MSLaunchView alloc] initWithVideoframe:CGRectZero guideFrame:gframe images:images gImage:nil sbName:![MSLaunchView isBlankString:sbName]? sbName:@"Main" videoUrl:nil isScrollOut:NO];
}


#pragma  mark - 关于Video引导页

#pragma mark - 创建对象，不带button 左滑动消失
+ (instancetype)launchWithVideo:(CGRect)videoFrame videoURL:(NSURL *)videoURL{
    return [[MSLaunchView alloc] initWithVideoframe:videoFrame guideFrame:CGRectZero images:nil gImage:nil sbName:nil videoUrl:videoURL isScrollOut:YES];
}

#pragma mark - 创建对象，不带button 左滑动不消失
+ (instancetype)launchWithVideo:(CGRect)videoFrame videoURL:(NSURL *)videoURL guideFrame:(CGRect)gframe gImage:(UIImage *)gImage{
    return [[MSLaunchView alloc] initWithVideoframe:videoFrame guideFrame:gframe images:nil gImage:gImage sbName:nil videoUrl:videoURL isScrollOut:NO];
}


#pragma mark - 用storyboard创建的项目时调用，不带button左滑动消失
+ (instancetype)launchWithVideo:(CGRect)videoFrame videoURL:(NSURL *)videoURL sbName:(NSString *)sbName{
    return [[MSLaunchView alloc] initWithVideoframe:videoFrame guideFrame:CGRectZero images:nil gImage:nil sbName:![MSLaunchView isBlankString:sbName]? sbName:@"Main" videoUrl:videoURL isScrollOut:YES];
}

#pragma mark - 用storyboard创建的项目时调用，带button左滑动不消失
+ (instancetype)launchWithVideo:(CGRect)videoFrame videoURL:(NSURL *)videoURL sbName:(NSString *)sbName guideFrame:(CGRect)gframe gImage:(UIImage *)gImage {
    return [[MSLaunchView alloc] initWithVideoframe:videoFrame guideFrame:gframe images:nil gImage:gImage sbName:![MSLaunchView isBlankString:sbName]? sbName:@"Main" videoUrl:videoURL isScrollOut:NO];
}
//return [[MSLaunchView alloc] initWithImageframe:CGRectZero image:image images:images];
-(instancetype) initWithImageframe:(CGRect)frame image:(NSString *)image images:(NSArray <NSString *>*)images{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, MSScreenW, MSScreenH);
        self.backgroundColor = [UIColor whiteColor];
        if (![MSLaunchView isBlankString:image]  ) {
            UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
            [window addSubview:self];
            //处理引导图
            if (images.count>0) {
                self.dataImages = [NSMutableArray arrayWithArray:images];
                [self addImages];
            }
            
            
            
            self.adView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
            [self addSubview:self.adView];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MSScreenW, MSScreenH)];
            if ([[MSLaunchOperation ms_contentTypeForImageData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:image ofType:nil]]] isEqualToString:@"gif"]) {
                NSData *localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:image ofType:nil]];
                imageView = (UIImageView *)[[MSLaunchOperation alloc] initWithFrame:imageView.frame gifImageData:localData];
                [self.adView addSubview:imageView];
            } else {
                [self.adView addSubview:imageView];
                [imageView sd_setImageWithURL:[NSURL URLWithString:image]];
            }
            [imageView setUserInteractionEnabled:YES];
            [imageView addSubview:self.CountdownButton];
            
            
            
        }else{
            [self removeGuidePageHUD];
        }
    }
    return self;
}

#pragma mark - 初始化
- (instancetype)initWithVideoframe:(CGRect)frame guideFrame:(CGRect)gframe images:(NSArray <NSString *>*)images gImage:(UIImage *)gImage sbName:(NSString *)sbName videoUrl:(NSURL *)videoUrl isScrollOut:(BOOL)isScrollOut{
    self = [super init];
    if (self) {
        
        
        self.frame = CGRectMake(0, 0, MSScreenW, MSScreenH);
        self.backgroundColor = [UIColor whiteColor];
        if (images.count>0) {
            self.dataImages = [NSMutableArray arrayWithArray:images];
        }
        
        self.videoUrl = videoUrl;
        videoFrame = frame;
        guideFrame = gframe;
        gbgImage = gImage;
        self.isScrollOut = isScrollOut;
        self.isPalyEndOut = YES;
        self.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        if ([self isFirstLauch]) {
            UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
            
            if (sbName != nil) {
                UIStoryboard *story = [UIStoryboard storyboardWithName:sbName bundle:nil];
                UIViewController * vc = story.instantiateInitialViewController;
                window.rootViewController = vc;
                [vc.view addSubview:self];
            }else{
                [window addSubview:self];
            }

            if (videoUrl && images == nil) {
                [self addVideo];
            }else{
                self.imageArray = images;
                [self addImages];
            }
        }else{
            [self removeGuidePageHUD];
        }
    }
    return self;
}


#pragma mark - 判断是不是首次登录或者版本更新
-(BOOL)isFirstLauch{
    //获取当前版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentAppVersion = infoDic[@"CFBundleShortVersionString"];
    //获取上次启动应用保存的appVersion
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:kAppVersion];
    //版本升级或首次登录
    if ([MSLaunchView isBlankString:version] || ![version isEqualToString:currentAppVersion]) {
        [[NSUserDefaults standardUserDefaults] setObject:currentAppVersion forKey:kAppVersion];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }else{
        return YES;//NO
    }
}
#pragma mark - 创建滚动视图、添加引导页图片
-(void)addImages{
    UIScrollView *launchScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    launchScrollView.showsHorizontalScrollIndicator = NO;
    launchScrollView.bounces = NO;
    launchScrollView.pagingEnabled = YES;
    launchScrollView.delegate = self;
    launchScrollView.contentSize = CGSizeMake(MSScreenW * self.dataImages.count, MSScreenH);
    [self addSubview:launchScrollView];
    
    for (int i = 0; i < self.dataImages.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * MSScreenW, 0, MSScreenW, MSScreenH)];
        imageView.contentMode = 1;
        if ([[MSLaunchOperation ms_contentTypeForImageData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.dataImages[i] ofType:nil]]] isEqualToString:@"gif"]) {
            NSData *localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.dataImages[i] ofType:nil]];
            imageView = (UIImageView *)[[MSLaunchOperation alloc] initWithFrame:imageView.frame gifImageData:localData];
            [launchScrollView addSubview:imageView];
        } else {
            [launchScrollView addSubview:imageView];
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.dataImages[i]]];
        }
        
        if (i == self.dataImages.count - 1) {
            //拿到最后一个图片，添加自定义体验按钮
            launchView = imageView;
            
            //判断要不要添加button
            if (!self.isScrollOut) {
                [imageView setUserInteractionEnabled:YES];
                [imageView addSubview:self.guideButton];
            }
        }
    }
    
    [self addSubview:self.skipButton];
    if (self.dataImages.count > 1) {
        [self addSubview:self.imagePageControl];
    }
}


#pragma mark - APP视频新特性页面(新增测试模块内容)
-(void)addVideo{
    
    [self addSubview:self.playerController.view];
    [self addSubview:self.guideButton];

    [UIView animateWithDuration:MSHidden_TIME animations:^{
        [self.guideButton setAlpha:1.0];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideGuidView) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [self addSubview:self.skipButton];

}

#pragma mark -- >> 自定义属性设置

#pragma mark - 跳过按钮的简单设置
-(void)setSkipTitle:(NSString *)skipTitle{
    [self.skipButton setTitle:skipTitle forState:UIControlStateNormal];
}

-(void)setSkipBackgroundClolr:(UIColor *)skipBackgroundClolr{
    [self.skipButton setBackgroundColor:skipBackgroundClolr];
}

-(void)setIsHiddenSkipBtn:(BOOL)isHiddenSkipBtn{
    self.skipButton.hidden = isHiddenSkipBtn;
}

-(void)skipBtnCustom:(UIButton *(^)(void))btn{
    [self.skipButton removeFromSuperview];
    [self addSubview:btn()];
}


#pragma mark - 立即体验按钮的简单设置
-(void)setGuideTitle:(NSString *)guideTitle{
    [self.guideButton setTitle:guideTitle forState:UIControlStateNormal];
}

-(void)setGuideBackgroundImage:(UIImage *)guideBackgroundImage{
    [self.guideButton setBackgroundImage:guideBackgroundImage forState:UIControlStateNormal];
}

-(void)setGuideTitleColor:(UIColor *)guideTitleColor{
    [self.guideButton setTitleColor:guideTitleColor forState:UIControlStateNormal];
}

#pragma mark - 自定义进入按钮
-(void)guideBtnCustom:(UIButton *(^)(void))btn{
    
    if(guideFrame.size.height || guideFrame.origin.x) return;
    
    //移除当前的体验按钮
    [self.guideButton removeFromSuperview];
    if (_videoUrl) {
        [self addSubview:btn()];
    }else{
        [launchView addSubview:btn()];
    }
}

#pragma mark - UIPageControl简单设置

-(void)setCurrentColor:(UIColor *)currentColor{
    self.imagePageControl.currentPageIndicatorTintColor = currentColor;
}

-(void)setNomalColor:(UIColor *)nomalColor{
    self.imagePageControl.pageIndicatorTintColor = nomalColor;
}

-(void)setIsHiddenPageControl:(BOOL)isHiddenPageControl{
    self.imagePageControl.hidden = isHiddenPageControl;
}

#pragma mark - UIPageControl简单设置


-(void)setVideoGravity:(AVLayerVideoGravity)videoGravity{
    self.playerController.videoGravity = videoGravity;
}

-(void)setIsPalyEndOut:(BOOL)isPalyEndOut{
    if (!isPalyEndOut) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}
-(void)hideAdView{//隐藏开屏页
    [self.adView removeFromSuperview];
    if(self.dataImages.count == 0){
        [self hideGuidView];
    }
}
#pragma mark - 隐藏引导页

-(void)hideGuidView{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"firstLoginNotify" object:self];
    
    [UIView animateWithDuration:MSHidden_TIME animations:^{
        self.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MSHidden_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self performSelector:@selector(removeGuidePageHUD) withObject:nil afterDelay:1];
        });
    }];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)removeGuidePageHUD {
    //解决第二次进入视屏不显示还能听到声音的BUG
    if (self.videoUrl) {
        self.playerController = nil;
    }
    [self removeFromSuperview];
   
}



#pragma mark - ScrollerView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //总宽度
    CGFloat totalWidth =  MSScreenW * self.dataImages.count;
    if ( totalWidth -(scrollView.contentOffset.x  + MSScreenW )< MSScreenW/2) {
        self.isHiddenPageControl = YES;
        self.skipButton.hidden = YES;
    } else {
        self.isHiddenPageControl = NO;
        self.skipButton.hidden = NO;
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    oldlastContentOffset = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    newlastContentOffset = scrollView.contentOffset.x;
    int cuttentIndex = (int)(oldlastContentOffset/MSScreenW);
    
    if (cuttentIndex == self.dataImages.count - 1) {
        if ([self isScrolltoLeft:scrollView]) {
            if (!self.isScrollOut) {
                return ;
            }
            [self hideGuidView];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int cuttentIndex = (int)(scrollView.contentOffset.x/MSScreenW);
    self.imagePageControl.currentPage = cuttentIndex;
}


#pragma mark - 判断滚动方向
-(BOOL)isScrolltoLeft:(UIScrollView *)scrollView{
    if (oldlastContentOffset - newlastContentOffset >0 ){
        return NO;
    }
    return YES;
}

#pragma mark - prvite void
//判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)string{
    
    if (string == nil || string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] ==0) {
        return YES;
    }
    return NO;
}



#pragma mark - >> 懒加载部分
#pragma mark - 倒计时按钮
-(UIButton *)CountdownButton{
    return MS_LAZY(_CountdownButton, ({
        // 设置引导页上的跳过按钮
        UIButton *CountdownButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CountdownButton.frame = CGRectMake(MSScreenW*0.8, MSScreenW*0.1, 50, 25);
        
        _secondsCountDown = 3;
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 timeFireMethod
        
        //设置倒计时显示的时间
        [CountdownButton setTitle:@"3秒" forState:UIControlStateNormal];
        [CountdownButton.titleLabel setFont:FontSize(14)];
        [CountdownButton setBackgroundColor:[UIColor grayColor]];
        [CountdownButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [CountdownButton.layer setCornerRadius:(CountdownButton.frame.size.height * 0.5)];
        [CountdownButton addTarget:self action:@selector(hideAdView) forControlEvents:UIControlEventTouchUpInside];
        CountdownButton;
    }));
}

#pragma mark - 跳过按钮
-(UIButton *)skipButton{
    return MS_LAZY(_skipButton, ({
        // 设置引导页上的跳过按钮
        UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        skipButton.frame = CGRectMake(MSScreenW - 60, MSScreenW*0.1, 50, 25);
        [skipButton setTitle:@"跳过" forState:UIControlStateNormal];
        [skipButton.titleLabel setFont:FontSize(14)];
        [skipButton setTitleColor:[UIColor colorWithHexString:@"c3c3c3"] forState:UIControlStateNormal];
        [skipButton addTarget:self action:@selector(hideGuidView) forControlEvents:UIControlEventTouchUpInside];
        skipButton;
    }));
}

#pragma mark - 进入按钮
-(UIButton *)guideButton{
    return MS_LAZY(_guideButton, ({
        // 设置引导页上的跳过按钮
        //CGRectMake(MSScreenW*0.3, MSScreenH*0.8, MSScreenW*0.4, MSScreenH*0.08)
        UIButton *guideButton = [UIButton new];
        guideButton.frame = guideFrame;
        [guideButton setTitle:@"立即体验" forState:UIControlStateNormal];
        [guideButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [guideButton setBackgroundImage:gbgImage forState:UIControlStateNormal];
        [guideButton.titleLabel setFont:FontSize(21)];
        [guideButton addTarget:self action:@selector(hideGuidView) forControlEvents:UIControlEventTouchUpInside];
        guideButton;
    }));
}



-(UIPageControl *)imagePageControl{
    return MS_LAZY(_imagePageControl, ({
        UIPageControl *imagePageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, MSScreenH - 50, MSScreenW, 30)];
        imagePageControl.numberOfPages = self.dataImages.count;
        imagePageControl.backgroundColor = [UIColor clearColor];
        imagePageControl.currentPage = 0;
        imagePageControl.defersCurrentPageDisplay = YES;
        imagePageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        imagePageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        imagePageControl;
    }));
}

#pragma mark - 视频播放VC
-(AVPlayerViewController *)playerController{
    return MS_LAZY(_playerController, ({
        AVPlayerViewController *playerController = [[AVPlayerViewController alloc] init];
        playerController.view.frame = videoFrame;
        playerController.view.backgroundColor = [UIColor whiteColor];
        [playerController.view setAlpha:1.0];
        playerController.player = [[AVPlayer alloc] initWithURL:self.videoUrl];
        playerController.videoGravity = self.videoGravity;
        playerController.showsPlaybackControls = NO;
        [playerController.player play];
        playerController;
    }));
}

#pragma mark - 倒计时

-(void)timeFireMethod{
    //倒计时-1
    _secondsCountDown--;
    //修改倒计时标签现实内容
    [self.CountdownButton setTitle:[NSString stringWithFormat:@"%d秒",_secondsCountDown] forState:UIControlStateNormal];
    
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(_secondsCountDown==0){
        [self hideAdView];
        [self.countDownTimer invalidate];
        [self.CountdownButton removeFromSuperview];
    }
}

@end


