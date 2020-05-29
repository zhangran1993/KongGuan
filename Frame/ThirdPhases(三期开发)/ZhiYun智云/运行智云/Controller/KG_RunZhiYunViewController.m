//
//  KG_RunZhiYunViewController.m
//  Frame
//
//  Created by zhangran on 2020/5/15.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RunZhiYunViewController.h"
#import "KG_RunZhiYunCell.h"
#import "KG_ZhiTaiStationModel.h"
#import "UIViewController+CBPopup.h"
@interface KG_RunZhiYunViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
//品牌
@property (nonatomic,strong)UICollectionView *collectionView;

/** 品牌数组 */
@property(nonatomic , strong) NSMutableArray *dataArray;


@property (nonatomic, strong)  UILabel   *titleLabel;
@property (nonatomic, strong)  UIView    *navigationView;
@property (nonatomic, strong)  UIButton  *rightButton;


@property(strong,nonatomic)   NSArray *stationArray;
@property(strong,nonatomic)   UITableView *stationTabView;
@end

@implementation KG_RunZhiYunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNaviTopView];
    [self initViewData];
    
}
- (void)initViewData {
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    [dic1 setObject:@"零备件" forKey:@"title"];
    [dic1 setObject:@"lingbeijian_icon" forKey:@"icon"];
    
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    [dic2 setObject:@"技术资料" forKey:@"title"];
    [dic2 setObject:@"jishuziliao_icon" forKey:@"icon"];
    
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
    [dic3 setObject:@"巡视维护记录" forKey:@"title"];
    [dic3 setObject:@"weihujilu_icon" forKey:@"icon"];
    
    NSMutableDictionary *dic4 = [NSMutableDictionary dictionary];
    [dic4 setObject:@"历史告警事件" forKey:@"title"];
    [dic4 setObject:@"historyevent_icon" forKey:@"icon"];
    
    NSMutableDictionary *dic5 = [NSMutableDictionary dictionary];
    [dic5 setObject:@"线缆图谱" forKey:@"title"];
    [dic5 setObject:@"xianlantupu_icon" forKey:@"icon"];
    
    NSMutableDictionary *dic6 = [NSMutableDictionary dictionary];
    [dic6 setObject:@"案例库" forKey:@"title"];
    [dic6 setObject:@"anliku_icon" forKey:@"icon"];
    
    NSMutableDictionary *dic7 = [NSMutableDictionary dictionary];
    [dic7 setObject:@"仪器仪表" forKey:@"title"];
    [dic7 setObject:@"yiqiyibiao_icon" forKey:@"icon"];
    
    NSMutableDictionary *dic8 = [NSMutableDictionary dictionary];
    [dic8 setObject:@"设备履历" forKey:@"title"];
    [dic8 setObject:@"devicelvli_icon" forKey:@"icon"];
    
    [self.dataArray addObject:dic1];
    [self.dataArray addObject:dic2];
    [self.dataArray addObject:dic3];
    [self.dataArray addObject:dic4];
    [self.dataArray addObject:dic5];
    [self.dataArray addObject:dic6];
    [self.dataArray addObject:dic7];
    [self.dataArray addObject:dic8];
    [self initCollevtionView];
    [self.collectionView reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillAppear");
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    if (self.isPush) {
      [self.navigationController setNavigationBarHidden:NO];
    }
    
    
}
//初始化collectionview
- (void)initCollevtionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 28;
    flowLayout.minimumInteritemSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.collectionView.layer.cornerRadius = 10.f;
    self.collectionView.layer.masksToBounds = YES;
    [self.collectionView registerClass:[KG_RunZhiYunCell class] forCellWithReuseIdentifier:@"KG_RunZhiYunCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
   
    
}
#pragma mark ---- collectionView 数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.collectionView) {
        KG_RunZhiYunCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KG_RunZhiYunCell" forIndexPath:indexPath];
        cell.dataDic = self.dataArray[indexPath.row];
        
        return cell;
    }
    return nil;
    
    
}

#pragma mark  定义每个UICollectionViewCell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return  CGSizeMake(SCREEN_WIDTH/4,101);
    
}

#pragma mark - collectionView代理方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld",(long)indexPath.row);
}
/**  数组  */
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)createNaviTopView {
    
    UIImageView *topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT +44)];
    [self.view addSubview:topImage1];
    topImage1.backgroundColor  =[UIColor whiteColor];
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 44)];
    [self.view addSubview:topImage];
    topImage.backgroundColor  =[UIColor whiteColor];
    topImage.image = [UIImage imageNamed:@"zhiyun_bgImage"];
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
    self.titleLabel.text = @"智云";
    
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
    leftImage.image = IMAGE(@"backwhite");
    [backBtn addSubview:leftImage];
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backBtn.mas_centerX);
        make.centerY.equalTo(backBtn.mas_centerY);
    }];
   
    
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.titleLabel.font = FontSize(12);
    self.rightButton.layer.borderColor = [[UIColor colorWithHexString:@"#DFDFDF"]CGColor];
    self.rightButton.layer.borderWidth = 0.5f;
    self.rightButton.layer.cornerRadius = 12.5f;
    self.rightButton.layer.masksToBounds = YES;
    
    [self.rightButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [self.rightButton setTitle:@"黄城导航台" forState:UIControlStateNormal];
    self.rightButton.frame = CGRectMake(0,0,81,22);
    [self.rightButton setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
    [self.rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 70, 0,0 )];
    [self.rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0,0 )];
    [self.view addSubview:self.rightButton];
    NSDictionary *currDic = [UserManager shareUserManager].currentStationDic;
    if (currDic.count) {
        [self.rightButton setTitle:safeString(currDic[@"alias"]) forState:UIControlStateNormal];
    }
    [self.rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@81);
        make.centerY.equalTo(backBtn.mas_centerY);
        make.height.equalTo(@22);
        make.right.equalTo(self.view.mas_right).offset(-16);
    }];
    
  
    
    
}
- (void)rightAction {
    
    [self stationAction];
}


- (void)backButtonClick:(UIButton *)button {
    if (self.isPush) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
        
    }
    
}
/** 标题栏 **/
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        titleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}
-(void)stationAction {
    
    
    NSArray *array = [UserManager shareUserManager].stationList;
    
    NSMutableArray *list = [NSMutableArray array];
    for (NSDictionary *stationDic in array) {
        [list addObject:stationDic[@"station"]];
    }
    self.stationArray = [KG_ZhiTaiStationModel mj_objectArrayWithKeyValuesArray:list];
    [self getStationList];
    
    
    
}


-(void)getStationList{
    
    UIViewController *vc = [UIViewController new];
    //按钮背景 点击消失
    UIButton * bgBtn = [[UIButton alloc]init];
    [vc.view addSubview:bgBtn];
    [bgBtn setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    bgBtn.alpha = 0.1;
    [bgBtn addTarget:self action:@selector(closeFrame) forControlEvents:UIControlEventTouchUpInside];
    [bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vc.view.mas_top);
        make.left.equalTo(vc.view.mas_left);
        make.right.equalTo(vc.view.mas_right);
        make.bottom.equalTo(vc.view.mas_bottom);
    }];
    
    [vc.view addSubview:bgBtn];
    vc.view.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT -64 +44, SCREEN_WIDTH,  SCREEN_HEIGHT);
    //_vc.view.layer.cornerRadius = 4.0;
    vc.view.layer.masksToBounds = YES;
    UIImageView *topImage = [[UIImageView alloc]init];
    topImage.image = [UIImage imageNamed:@"slider_up"];
    
    [vc.view addSubview:topImage];
    //设置滚动
    self.stationTabView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -162- 16, FrameWidth(20), 162 ,294)];
    self.stationTabView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [vc.view addSubview:self.stationTabView];
    self.stationTabView.dataSource = self;
    self.stationTabView.delegate = self;
    self.stationTabView.separatorStyle = NO;
    [self.stationTabView reloadData];
    float xDep = NAVIGATIONBAR_HEIGHT;
    
    [self.stationTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vc.view.mas_top).offset(xDep);
        make.right.equalTo(vc.view.mas_right).offset(-16);
        make.width.equalTo(@162);
        make.height.equalTo(@311);
    }];
    self.stationTabView.layer.cornerRadius = 8.f;
    self.stationTabView.layer.masksToBounds = YES;
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stationTabView.mas_top).offset(-7);
        make.right.equalTo(vc.view.mas_right).offset(-28);
        make.width.equalTo(@25);
        make.height.equalTo(@7);
    }];
    
    
    
    
    
    
    [self cb_presentPopupViewController:vc animationType:CBPopupViewAnimationSlideFromRight aligment:CBPopupViewAligmentLeft overlayDismissed:nil];
    
}
-(void)closeFrame{//消失
    
    [self cb_dismissPopupViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableviewDatasource 数据源方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.stationTabView){
        
        return 40;
    }
    return FrameWidth(210);
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.stationTabView){
        return self.stationArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1.2 去缓存池中取Cell
    if(tableView == self.stationTabView){
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
        KG_ZhiTaiStationModel *model = self.stationArray[indexPath.row];
        cell.textLabel.text = safeString(model.name) ;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
        
        return cell;
        
    }
    
    
    
    return nil;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_ZhiTaiStationModel *model = self.stationArray[indexPath.row];
    NSLog(@"1");
    [UserManager shareUserManager].currentStationDic = [model mj_keyValues];
    [[UserManager shareUserManager] saveStationData:[model mj_keyValues]];
    [self.rightButton setTitle:safeString(model.name) forState:UIControlStateNormal];
    
    
    
    [self cb_dismissPopupViewControllerAnimated:YES completion:nil];
   
}



@end
