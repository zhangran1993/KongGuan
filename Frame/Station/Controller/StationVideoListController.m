//
//  StationVideoListController.m
//  Frame
//
//  Created by hibayWill on 2018/3/30.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//


#import "StationVideoListController.h"

#import "SimpleDemoViewController.h"
#import "FrameBaseRequest.h"
#import <UIImageView+WebCache.h>
#import "VideoItems.h"
#import "StationItems.h"
#import <MJExtension.h>
#import "UIColor+Extension.h"
#import "HSIEmptyDataSetView.h"
#import "UIScrollView+EmptyDataSet.h"
@interface StationVideoListController ()<UITableViewDataSource,UITableViewDelegate,EmptyDataSetDelegate>

@property (strong, nonatomic) NSMutableArray<VideoItems *> * videoList;
@property (strong, nonatomic) NSMutableArray<StationItems *> * StationItem;
@property (strong, nonatomic) UIButton *rightButton;
@property(nonatomic) UITableView *filterTabView;


/** 请求管理者 */
//@property (nonatomic,weak) AFHTTPSessionManager * manager;
/** 用于加载下一页的参数(页码) */
@property   NSInteger didselect;
@property (nonatomic,copy) NSString* litpic;

@property (nonatomic,assign) double iscollect;
@property(nonatomic) UIView* bottomView;
@property(nonatomic) UITableView *tableview;

@property (nonatomic, strong)  UILabel   *titleLabel;
@property (nonatomic, strong)  UIView    *navigationView;

@end

@implementation StationVideoListController

#pragma mark - 全局常量



#pragma mark - life cycle 生命周期方法

- (void)viewDidLoad {
    
    //_station_code = @"all";
    [super viewDidLoad];
//    [self backBtn];
    [self.navigationController setNavigationBarHidden:YES];
    [self createNaviTopView];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetNotificationAction) name:kNetworkStatusNotification object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, WIDTH_SCREEN, HEIGHT_SCREEN- FrameWidth(100))];
    self.tableview.delegate =self;
    self.tableview.dataSource =self;
    self.tableview.separatorStyle = NO;
    //[self.tableview registerClass:[UITableViewCell class]forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.tableview];
    
    self.tableview.backgroundColor = BGColor;
    [self setupTable];
    
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"StationVideoListController  %@",_station_code);
    
    [self setupTable];
   
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES];
    
}
/**
 颜色转图片
 
 @param color 颜色
 @return 图片
 */
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

/**
 监听网络
 */
- (void)resetNotificationAction {
    if (!IsNetwork) {
        self.videoList = nil;
        [self.tableview reloadData];
    } else {
        [self setupTable];
    }
}
#pragma mark - private methods 私有方法

- (void)setupTable{
    ///api/atcVideoList/{station_code}
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/api/atcVideoList/%@",_station_code]];//
    NSLog(@"%@",FrameRequestURL);
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            self.tableview.emptyDataSetDelegate = self;
            [self.tableview reloadData];
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        NSArray * VItem = [result[@"value"] copy];
        NSMutableArray<VideoItems *> * VideoItem = [[NSMutableArray alloc]init];
        for (int i=0; i< VItem.count; i++) {
            NSDictionary * Video = VItem[i];
            
            NSMutableArray<VideoItems *> * vname = [[VideoItems class] mj_objectArrayWithKeyValuesArray:@[@{@"ip":@"ip",@"name":Video[@"name"],@"password":@"password",@"port":@"port",@"roomName":@"roomName",@"account":@"account"}]];
            NSMutableArray<VideoItems *> * SItem = [[VideoItems class] mj_objectArrayWithKeyValuesArray:[Video objectForKey:@"videos"] ];
            
            [VideoItem addObjectsFromArray:vname];
            [VideoItem addObjectsFromArray:SItem];
            
        }
        self.videoList = [VideoItem copy];
        
        self.tableview.emptyDataSetDelegate = self;
        //NSMutableArray<VideoItems *> * navigation = [[VideoItems class] mj_objectArrayWithKeyValuesArray:@[@{@"category":@"title",@"name":@"雷达台站"}]];
        
        [self.tableview reloadData];
        
        
        
        
        
    } failure:^(NSURLSessionDataTask *error)  {
        self.tableview.emptyDataSetDelegate = self;
        [self.tableview reloadData];
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
//        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
//            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
//            [FrameBaseRequest logout];
//            UIViewController *viewCtl = self.navigationController.viewControllers[0];
//            [self.navigationController popToViewController:viewCtl animated:YES];
//            return;
//        }else if(responses.statusCode == 502){
//            
//        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
    
    
    //去除分割线
    //self.tableview.separatorStyle =NO;
    [self.view addSubview:self.tableview];
    
}


-(void)viewDidAppear:(BOOL)animated{
    // NSLog(@"viewDidAppear");
}
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"StationVideoListController viewDidDisappear");
}
-(void)viewWillLayoutSubviews{
    // NSLog(@"viewWillLayoutSubviews");
}

#pragma mark - 请求数据方法
/**
 *  发送请求并获取数据方法
 */



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //if(tableView == self.filterTabView){
    if(tableView.frame.size.width != WIDTH_SCREEN){
        return FrameWidth(56);
    }
    
    if(indexPath.row + 1 > self.videoList.count){return 0;}
    if([self.videoList[indexPath.row].account isEqualToString:@"account"]   ){
        return FrameWidth(86);
    }else{
        return FrameWidth(108);
    }
    //if(self.detail[indexPath.row].typeid==1){
    /*
    if(indexPath.row==0){
        if(getScreen.size.height > allHeight){
            return getScreen.size.height*2;
        }
        return  allHeight;//+
    }
    return 0;
     */
}

#pragma mark - UITableviewDatasource 数据源方法
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.filterTabView) {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithHexString:kCellHighlightColor];
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.filterTabView) {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //if(tableView == self.filterTabView){
    if(tableView.frame.size.width != WIDTH_SCREEN){
        return self.StationItem.count;
    }
    return self.videoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //if(tableView == self.filterTabView){
    if(tableView.frame.size.width != WIDTH_SCREEN){
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
        
        StationItems *item = self.StationItem[indexPath.row];
        if([item.category isEqualToString:@"title"]){
            if(indexPath.row !=0){
                UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FrameWidth(300), 1)];
                line.image = [UIImage imageNamed:@"personal_gray_bg"];
                [cell addSubview:line];
            }
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(55), 0, FrameWidth(300), FrameWidth(54))];
            titleLabel.text = item.alias;
            titleLabel.font =  FontSize(15);
            [cell addSubview:titleLabel];
        }else{
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(80), 0, FrameWidth(220), FrameWidth(54))];
            titleLabel.text = item.alias;
            titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
            titleLabel.font = FontSize(15);
            [cell addSubview:titleLabel];
            
            UIImageView *dot = [[UIImageView alloc] initWithFrame:CGRectMake(FrameWidth(55), FrameWidth(20), FrameWidth(12), FrameWidth(12))];
            dot.image = [UIImage imageNamed:@"video_icon"];
            [cell addSubview:dot];
            UIImageView *rightArrow = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(20), FrameWidth(13), FrameWidth(72), FrameWidth(72))];
            rightArrow.image = [UIImage imageNamed:@"video_right"];
            [cell addSubview:rightArrow];//station_right
            [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.mas_right).offset(-10);
                make.width.height.equalTo(@18);
                make.centerY.equalTo(dot.mas_centerY);
            }];
        }
        
        return cell;
    }
    
    UITableViewCell *thiscell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN - FrameWidth(100))];
    thiscell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
    thiscell.backgroundColor = [UIColor whiteColor];
    if(indexPath.row + 1 > self.videoList.count){return thiscell;}
    if([self.videoList[indexPath.row].account isEqualToString:@"account"]   ){
        if(indexPath.row != 0){
            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 5)];
            lineLabel.backgroundColor = BGColor;
            [thiscell addSubview:lineLabel];
        }
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(25), 0, WIDTH_SCREEN, FrameWidth(72))];
        titleLabel.font = FontSize(17);
        titleLabel.text = self.videoList[indexPath.row].name;
        [thiscell addSubview:titleLabel];
    }else{
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 1)];
        lineLabel.backgroundColor = BGColor;
        [thiscell addSubview:lineLabel];
        
        UIImageView *videoImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(20), FrameWidth(13), FrameWidth(72), FrameWidth(72))];
        videoImg.image = [UIImage imageNamed:@"video_icon"];
        [thiscell addSubview:videoImg];//station_right
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(120), FrameWidth(1), FrameWidth(450), FrameWidth(107))];
        titleLabel.font = FontSize(17);
        titleLabel.text = self.videoList[indexPath.row].name;
        titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
        [thiscell addSubview:titleLabel];
        
        
        UIImageView *rightArrow = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(20), FrameWidth(13), FrameWidth(72), FrameWidth(72))];
        rightArrow.image = [UIImage imageNamed:@"video_right"];
        [thiscell addSubview:rightArrow];//station_right
        [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(thiscell.mas_right).offset(-10);
            make.width.height.equalTo(@18);
            make.centerY.equalTo(videoImg.mas_centerY);
        }];
        
    }
    return thiscell;
    
   
}


#pragma mark - UITableviewDelegate 代理方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 点击了第indexPath.row行Cell所做的操作
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了第%ld行Cell所做的操作",(long)indexPath.row);
    //if(tableView == self.filterTabView){
    if(tableView.frame.size.width != WIDTH_SCREEN){
        StationItems *item = self.StationItem[indexPath.row];
        if(![item.category isEqualToString:@"title"]){
            [self cb_dismissPopupViewControllerAnimated:YES completion:nil];
            _station_code = item.code;
            _station_name =item.alias;
            //[_rightButton setTitle:_station_name forState:UIControlStateNormal];
            [self stationBtn];
            [self setupTable];
        }
        return ;
    }
    if(_didselect == indexPath.row){
       // [FrameBaseRequest showMessage:@"正在获取视频，请稍候"];
        return ;
    }
    _didselect = indexPath.row;
    if(!self.videoList[indexPath.row] || !self.videoList[indexPath.row].port ||![FrameBaseRequest isPureInt:self.videoList[indexPath.row].port] ){
        [FrameBaseRequest showMessage:@"获取视频出错"];
        //_didselect = 1000;
        return ;
    }
    _didselect = 1000;
    
    SimpleDemoViewController  *SimpleDemoView = [[SimpleDemoViewController alloc] init];
    SimpleDemoView.ip = self.videoList[indexPath.row].ip;
    SimpleDemoView.name = self.videoList[indexPath.row].account;
    SimpleDemoView.password = self.videoList[indexPath.row].password;
    SimpleDemoView.port = self.videoList[indexPath.row].port;
    SimpleDemoView.channelId = self.videoList[indexPath.row].channelId;
    
    
    
    [self.navigationController pushViewController:SimpleDemoView animated:YES];
    
    
     
}

-(void)stationAction {
    if(self.StationItem){
        [self getStationList];
    }else{
        NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:@"/intelligent/api/allStationList"];
        NSLog(@"%@",FrameRequestURL);
        [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
            NSInteger code = [[result objectForKey:@"errCode"] intValue];
            if(code  <= -1){
                [FrameBaseRequest showMessage:result[@"errMsg"]];
                return ;
            }
            NSMutableArray<StationItems *> * SItem = [[StationItems class] mj_objectArrayWithKeyValuesArray:[result objectForKey:@"value"] ];
            NSMutableArray<StationItems *> * radar = [[StationItems class] mj_objectArrayWithKeyValuesArray:@[@{@"category":@"title",@"alias":@"雷达台站"}]];
            NSMutableArray<StationItems *> * navigation = [[StationItems class] mj_objectArrayWithKeyValuesArray:@[@{@"category":@"title",@"alias":@"导航台站"}]];
            NSMutableArray<StationItems *> * local = [[StationItems class] mj_objectArrayWithKeyValuesArray:@[@{@"category":@"title",@"alias":@"本场"}]];
             NSMutableArray<StationItems *> * shelter = [[StationItems class] mj_objectArrayWithKeyValuesArray:@[@{@"category":@"title",@"alias":@"方舱"}]];
            //[navigation addObject:radar];
            
            for(StationItems *item in SItem){
                
                if([item.category isEqualToString:@"navigation"]){
                    [navigation addObject:item];
                }else if([item.category isEqualToString:@"radar"]){
                    [radar addObject:item];
                }else if([item.category isEqualToString:@"local"]){
                    [local addObject:item];
                }else if([item.category isEqualToString:@"shelter"]){
                    [shelter addObject:item];
                }
            }
            [radar addObjectsFromArray:navigation];
            [radar addObjectsFromArray:local];
            [radar addObjectsFromArray:shelter];
            //
            
            self.StationItem = [radar copy];
            [self getStationList];
            
        } failure:^(NSURLSessionDataTask *error)  {
            FrameLog(@"请求失败，返回数据 : %@",error);
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
//            if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
//                [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
//                [FrameBaseRequest logout];
//                UIViewController *viewCtl = self.navigationController.viewControllers[0];
//                [self.navigationController popToViewController:viewCtl animated:YES];
//                return;
//            }else if(responses.statusCode == 502){
//
//            }
            [FrameBaseRequest showMessage:@"网络链接失败"];
            return ;
            
        }];
    }
    
}


-(void)getStationList{
    float moreheight = FrameWidth(900);
    if(HEIGHT_SCREEN == 812){
        moreheight = -FrameWidth(1100);
    }
    
    UIViewController *vc = [UIViewController new];
    
    vc.view.frame = CGRectMake(FrameWidth(320), FrameWidth(128), FrameWidth(320),  moreheight);
    //_vc.view.layer.cornerRadius = 4.0;
    vc.view.layer.masksToBounds = YES;
    UIImageView * xialaImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, FrameWidth(300),  FrameWidth(20))];
    xialaImage.image = [UIImage imageNamed:@"station_pulldown_right"];
    [vc.view addSubview:xialaImage];
    
    float tabelHeight = self.StationItem.count * FrameWidth(56);
    if(tabelHeight > FrameWidth(400)){
        tabelHeight = FrameWidth(400);
    }
    
    UIView *alphaView = [[UIView alloc]initWithFrame:CGRectMake(0, tabelHeight, FrameWidth(300),  FrameWidth(1000))];
    alphaView.userInteractionEnabled = YES;
    UITapGestureRecognizer *viewTapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeFrame)];
    [alphaView addGestureRecognizer:viewTapGesture];
    [viewTapGesture setNumberOfTapsRequired:1];
    [vc.view addSubview:alphaView];
    
    //设置滚动
    self.filterTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, FrameWidth(20), FrameWidth(300) , tabelHeight)];
    self.filterTabView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [vc.view addSubview:self.filterTabView];
    self.filterTabView.dataSource = self;
    self.filterTabView.delegate = self;
    //[self.filterTabView reloadData];
    
    
    [self cb_presentPopupViewController:vc animationType:CBPopupViewAnimationSlideFromRight aligment:CBPopupViewAligmentRight overlayDismissed:nil];
    
}
-(void)backBtn{
    UIButton *leftButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButon.frame = CGRectMake(0,0,FrameWidth(60),FrameWidth(60));
    [leftButon setImage:[UIImage imageNamed:@"back_gray"] forState:UIControlStateNormal];
    [leftButon setContentEdgeInsets:UIEdgeInsetsMake(0, - FrameWidth(20), 0, FrameWidth(20))];
    //button.alignmentRectInsetsOverride = UIEdgeInsetsMake(0, offset, 0, -(offset));
    [leftButon addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc]initWithCustomView:leftButon];
    self.navigationItem.leftBarButtonItem = fixedButton;
    

    [self stationBtn];
}
-(void)stationBtn{
//    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,  FrameWidth(100), FrameWidth(30))];
//
//    [_rightButton addTarget:self action:@selector(stationAction) forControlEvents:UIControlEventTouchUpInside];
//    _rightButton.titleLabel.font = FontSize(15);
//    CGSize size = [_station_name sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontSize(15),NSFontAttributeName,nil]];
//
//    //[leftButton setBackgroundColor:[UIColor blueColor]];
//    [_rightButton setFrame:CGRectMake(FrameWidth(30), 0, size.width, FrameWidth(30))];
//    [_rightButton setTitle:_station_name forState:UIControlStateNormal];
//
//    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
//
//
//    UIButton *rightButton1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, FrameWidth(20), FrameWidth(30))];
//    [rightButton1 setImage:[UIImage imageNamed:@"station_pulldown"] forState:UIControlStateNormal];
//    UIBarButtonItem *rightBarButton1 = [[UIBarButtonItem alloc]initWithCustomView:rightButton1];
//    self.navigationItem.rightBarButtonItems = @[ rightBarButton1,rightBarButton];
//
    
}
-(void)backAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"bottomapevent" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)closeFrame{
    
    [self cb_dismissPopupViewControllerAnimated:YES completion:nil];
}

#pragma mark --EmptyDataSetDelegate
- (nullable UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    if (!IsNetwork) {
        return [UIImage imageNamed:@"error_net"];
    } else {
        return [UIImage imageNamed:@"error_date"];
    }
}

- (nullable NSAttributedString *)tipsForEmptyDataSet:(UIScrollView *)scrollView{
    if (!IsNetwork) {
        NSAttributedString *tips = [[NSAttributedString alloc] initWithString:scrollViewNoNetworkText];
        return tips;
    } else {
        NSAttributedString *tips = [[NSAttributedString alloc] initWithString:scrollViewNoDataText];
        return tips;
    }
}

- (nullable NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    if (!IsNetwork) {
        NSAttributedString *buttonTitle =  [[NSAttributedString alloc] initWithString:scrollViewButtonText];
        return buttonTitle;
    } else {
        NSAttributedString *buttonTitle = nil;
        return buttonTitle;
    }
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    [self setupTable];
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
    self.titleLabel.text = @"台站实时视频";
    
    /** 返回按钮 **/
    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, (Height_NavBar -44)/2, 44, 44)];
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
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
/** 标题栏 **/
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}
@end



