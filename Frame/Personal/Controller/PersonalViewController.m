//
//  PersonalViewController.m
//  Frame
//
//  Created by hibayWill on 2018/3/16.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "PersonalViewController.h"
#import "PersonalInfoController.h"
#import "PersonalSetController.h"
#import "PersonalChooseStationController.h"
#import "PersonalPatrolController.h"
#import "PersonalMsgController.h"
#import "FrameSettingItem.h"
#import "LoginViewController.h"
#import "FrameBaseRequest.h"

#import "FrameGroupItem.h"
#import <UIImageView+WebCache.h>
#import "UIViewController+YQSlideMenu.h"
#define MAXPersonalViewWIDTH (WIDTH_SCREEN/6)
@interface PersonalViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray * groups;/** 组数组 描述TableView有多少组 */
@property(strong,nonatomic)UILabel *stationName;
@property(strong,nonatomic)UILabel *newsNumLabel;
@property int clickNum;
@property int isLoginSuccess;
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation PersonalViewController


/** groups 数据懒加载*/
- (NSMutableArray *)groups
{
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}



-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"PersonalViewController viewWillDisappear");
    [self showNavigation];
    
}
-(void)viewDidAppear:(BOOL)animated{
    if(self.isLoginSuccess == 1){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginSuccess" object:nil];
        self.isLoginSuccess = 0;
        [self.tabBarController setSelectedIndex:2];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.groups = [NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAXPersonalViewWIDTH*5, HEIGHT_SCREEN) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //设置不可滚动
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    //去掉横线
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
     [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.view addSubview:self.tableView];
    if(isPlus||isIphone){
        self.tableView.scrollEnabled =NO;
    }
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headNotification) name:@"modifyingHeadNotification" object:nil];
    [self Initialization];
}

-(void)viewWillAppear:(BOOL)animated{
    //self.groups = [NSMutableArray array];
    
    //
    
}




- (void)Initialization {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(![userDefaults objectForKey:@"userAccount"]||[[userDefaults objectForKey:@"userAccount"] isEqualToString:@""]){
        
        [[NSNotificationCenter defaultCenter] addObserver:self   selector:@selector(loginSuccess) name:@"loginSuccess" object:nil];
        
        return ;
    }
    
    
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [_newsNumLabel removeFromSuperview];
    _newsNumLabel = [[UILabel alloc]init];
    _newsNumLabel.tag = 100;
    CGSize size = [@"我的消息" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontSize(14),NSFontAttributeName,nil]];
    _newsNumLabel.frame = CGRectMake(FrameWidth(125)+size.width, FrameWidth(28), FrameWidth(25), FrameWidth(25));
    _newsNumLabel.font = FontSize(10);
    _newsNumLabel.layer.cornerRadius = FrameWidth(12.5);
    _newsNumLabel.clipsToBounds = YES;
    _newsNumLabel.textColor = [UIColor whiteColor];
    _newsNumLabel.textAlignment = NSTextAlignmentCenter;
    _newsNumLabel.backgroundColor = [UIColor redColor];
    [_newsNumLabel setHidden:YES];
    self.groups = [NSMutableArray array];
    //添加第1组模型
    [self setGroup0];
    
    //添加台站值班，所属台站，我的消息，设置，清理缓存
    [self setGroup1];
    [self setGroup2];
    [self setGroup3];
    [self setGroup4];
    [self setGroup5];
    //退出登录
    [self setGroup6];
    [self getNewsNum];
}


#pragma mark--修改头像通知
- (void)headNotification {
    [self getNewsNum];
    [self.tableView reloadData];
}



- (void)setGroup0{
    // 创建组模型
    FrameGroupItem *group = [[FrameGroupItem alloc]init];
    // 创建行模型
    FrameSettingItem *item = [FrameSettingItem itemWithtitle:@""];
    // 保存行模型数组
    group.items = @[item];
    // 把组模型保存到groups数组
    [self.groups addObject:group];
}
- (void)setGroup6{
    // 创建组模型
    FrameGroupItem *group = [[FrameGroupItem alloc]init];
    // 创建行模型
    FrameSettingItem *item = [FrameSettingItem itemWithtitle:@""];
    // 保存行模型数组
    group.items = @[item];
    // 把组模型保存到groups数组
    [self.groups addObject:group];
    
    [self.tableView reloadData];
}

- (void)setGroup1{
    // 创建组模型
    FrameGroupItem *group = [[FrameGroupItem alloc]init];
    // 创建行模型
    FrameSettingItem *item = [FrameSettingItem itemWithtitle:@"台站值班" itemWithimg:@"personal_Patrol"];
    // 保存行模型数组
    group.items = @[item];
    // 把组模型保存到groups数组
    [self.groups addObject:group];
}

//itemWithtitle:(NSString *)title itemWithimg:(NSString *)img
- (void)setGroup:(NSString *)value forKey:(NSString *)key{
    FrameGroupItem *group = [[FrameGroupItem alloc]init];
    // 创建行模型
    FrameSettingItem *item = [FrameSettingItem itemWithtitle:value itemWithimg:key];
    group.items = @[item];
    [self.groups addObject:group];
}

- (void)setGroup2{
    
    FrameGroupItem *group = [[FrameGroupItem alloc]init];
    FrameSettingItem *item = [FrameSettingItem itemWithtitle:@"所属台站" itemWithimg:@"personal_station"];
    
    group.items = @[item];
    
    [self.groups addObject:group];
}

- (void)setGroup3{
    
    FrameGroupItem *group = [[FrameGroupItem alloc]init];
    FrameSettingItem *item = [FrameSettingItem itemWithtitle:@"我的消息" itemWithimg:@"personal_msg"];
    
    group.items = @[item];
    
    [self.groups addObject:group];
}
- (void)setGroup4{
    
    FrameGroupItem *group = [[FrameGroupItem alloc]init];
    FrameSettingItem *item = [FrameSettingItem itemWithtitle:@"设置" itemWithimg:@"personal_set"];
    
    group.items = @[item];
    
    [self.groups addObject:group];
}
- (void)setGroup5{
    
    FrameGroupItem *group = [[FrameGroupItem alloc]init];
    FrameSettingItem *item = [FrameSettingItem itemWithtitle:@"清理缓存" itemWithimg:@"personal_clean"];
    
    group.items = @[item];
    
    [self.groups addObject:group];
}
#pragma mark - TableView的数据源代理方法实现

/**
 *  返回有多少组的代理方法
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groups.count;
}
/**
 *  返回每组有多少行的代理方法
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    FrameGroupItem *group = self.groups[section];
    return group.items.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return FrameWidth(350);
    }
    return FrameWidth(80);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0){
        return FrameWidth(30);
    }
    return FrameWidth(8);
}


/**
 *  返回每一行Cell的代理方法
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1 初始化Cell
    // 1.1 设置Cell的重用标识
    static NSString *ID = @"cell";
    // 1.2 去缓存池中取Cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 1.3 若取不到便创建一个带重用标识的Cell
    if (cell == nil) {
        cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    // 2 设置数据
    // 2.1 取出组模型
    FrameGroupItem *group = self.groups[indexPath.section];
    // 2.2 根据组模型取出行（Cell）模型
    FrameSettingItem *item = group.items[indexPath.row];
    int thisViewwidth = (MAXPersonalViewWIDTH * 5)/2;
    if(indexPath.section == 0){
        //清空这个cell中的内容
        cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
        //返回按钮和标题
        
        UIButton * backBtn = [UIButton new];
        backBtn.frame = CGRectMake(0, 20, FrameWidth(65), FrameWidth(65));
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
        [cell addSubview:backBtn];
        
        UILabel * backTitle = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(120), 20, FrameWidth(300), FrameWidth(65))];
        backTitle.textColor = [UIColor whiteColor];
        backTitle.textAlignment = NSTextAlignmentCenter;
        backTitle.font = FontBSize(15);
        backTitle.text = @"个人中心";
        [cell addSubview:backTitle];
        
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *name = [userDefaults objectForKey:@"name"];
        NSArray * positions = [userDefaults objectForKey:@"role"];
        NSString *position = @"";
        if(![positions  isEqual: @[]] ){
            position = positions[0];
            for (int i = 1; i < positions.count; i++) {
                position = [NSString stringWithFormat:@"%@、%@",position,positions[i]];
            }
            //position = [userDefaults objectForKey:@"role"][0];
        }
       
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personal_bg"]];
        imgView.frame = CGRectMake(0, 0, MAXPersonalViewWIDTH*5, FrameWidth(350));
        
        //imgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//底部固定，调整顶部的距离//UIViewAutoresizingFlexibleHeight;//UIViewAutoresizingNone;//UIViewAutoresizingFlexibleWidth;
        
        [cell insertSubview:imgView atIndex:0];
        
        
        UIImageView *userIconImageV=[[UIImageView alloc]initWithFrame:CGRectMake(((MAXPersonalViewWIDTH * 5) - FrameWidth(120))/2, FrameWidth(125), FrameWidth(120), FrameWidth(120))];
        userIconImageV.tag = 100;
        userIconImageV.layer.masksToBounds=YES;
        userIconImageV.layer.cornerRadius=FrameWidth(60); //设置为图片宽度的一半出来为圆形
        if([userDefaults objectForKey:@"icon"]){
            
            [userIconImageV sd_setImageWithURL:[NSURL URLWithString: [WebHost stringByAppendingString:[userDefaults objectForKey:@"icon"]]] placeholderImage:[UIImage imageNamed:@"personal_head"]];
        }
        [userIconImageV setUserInteractionEnabled:YES];
        [userIconImageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoInfo)]];
        [cell addSubview:userIconImageV];
        
        
        //userIconImageV.image=[UIImage imageNamed:@"4"];//faceurl
        CGSize size = [name sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontSize(16),NSFontAttributeName,nil]];
        UILabel *username = [[UILabel alloc]initWithFrame:CGRectMake(thisViewwidth-size.width/2, FrameWidth(265), size.width+10, 20)];
        username.font = FontSize(16);
        username.textAlignment = NSTextAlignmentCenter;
        username.textColor = [UIColor whiteColor];
        username.tag = 101;
        username.text = name;
        [cell addSubview:username];
        
        UIImageView *personalEdit=[[UIImageView alloc]initWithFrame:CGRectMake(thisViewwidth+size.width/2+8, FrameWidth(270), 15, 15)];
        personalEdit.tag = 102;
        [personalEdit setUserInteractionEnabled:YES];
        [personalEdit addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoInfo)]];
        personalEdit.image = [UIImage imageNamed:@"personal_edit"];
        
        [cell addSubview:personalEdit];
        
        CGSize psize = [position sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontSize(14),NSFontAttributeName,nil]];
        UILabel *userposition = [[UILabel alloc]initWithFrame:CGRectMake(thisViewwidth-psize.width/2, FrameWidth(300), psize.width+10, 20)];
        userposition.font = FontSize(14);
        userposition.textAlignment = NSTextAlignmentCenter;
        userposition.textColor = [UIColor whiteColor];
        userposition.tag = 101;
        userposition.text = position;
        [cell addSubview:userposition];
        
        
    }else if(indexPath.section == 6){
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        logoutBtn.frame = CGRectMake((MAXPersonalViewWIDTH*5)/2-FrameWidth(160),FrameWidth(30),  FrameWidth(320),FrameWidth(60));
        [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        [logoutBtn.layer setCornerRadius:FrameWidth(30)]; //设置矩形四个圆角半径
        //[registerbtn setBorderWidth:1.0]; //边框宽度
        [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//title color
        logoutBtn.titleLabel.font = FontSize(16);
        [logoutBtn.layer setBackgroundColor:[UIColor colorWithRed:100/255.0 green:170/255.0 blue:250/255.0 alpha:1].CGColor];//边框颜色
        [cell addSubview:logoutBtn];
    }else{
        if(indexPath.section != 5){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;// 设置Cell右边的小箭头
        }
        
        cell.imageView.image = [UIImage imageNamed:item.litpic];
        cell.imageView.frame = CGRectMake(17, 10, 40, 40);
        // 2.3 根据行模型的数据赋值
        cell.textLabel.text = item.title;
        if(indexPath.section == 2){
            if (!_stationName) {
                _stationName = [[UILabel alloc]init];
                CGFloat width = MAXPersonalViewWIDTH*5;
                _stationName.frame = CGRectMake(width/2, FrameWidth(30), width/2 - 35, FrameWidth(20));
                _stationName.font = FontSize(14);
                _stationName.textAlignment = NSTextAlignmentRight;
                [cell addSubview:_stationName];
            }
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            if([userDefaults objectForKey:@"station"]){
                _stationName.text = [userDefaults objectForKey:@"station"][@"alias"];
            }
        }
        if(indexPath.section == 3){
            [cell addSubview:_newsNumLabel];
        }
        cell.textLabel.font = FontSize(16);
    }
    
    
    
    return cell;
}
//获取消息数量

-(void)getNewsNum{
    _newsNumLabel.text = [NSString stringWithFormat:@"%ld",(long)unReadNum];//;
    
    if(![[NSString stringWithFormat:@"%@",_newsNumLabel.text] isEqualToString:@"0"]){
        [_newsNumLabel setHidden:NO];
        return ;
    }else{
        [_newsNumLabel setHidden:YES];
        return ;
    }
    
    /*
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *FrameRequestURL = [WebHost stringByAppendingString:@"/api/getNotReadNum/all"];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        if(code == 0){
            //UILabel * newsNumLabel = [self.view viewWithTag:100];
            _newsNumLabel.text = [NSString stringWithFormat:@"%@",result[@"value"][@"num"]];//;
            
            [[NSUserDefaults standardUserDefaults] setInteger:[_newsNumLabel.text integerValue] forKey:@"unReadNum"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if(![[NSString stringWithFormat:@"%@",result[@"value"][@"num"]] isEqualToString:@"0"]){
                [_newsNumLabel setHidden:NO];
                return ;
            }else{
                [_newsNumLabel setHidden:YES];
                return ;
            }
            
        }
    } failure:^(NSURLSessionDataTask *error)  {
        [_newsNumLabel setHidden:YES];
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            [FrameBaseRequest logout];
            
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
     */
}

//退出
-(void)logout{
    UIAlertController *alertContor = [UIAlertController alertControllerWithTitle:@"确定要退出？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertContor addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:nil]];
    [alertContor addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [FrameBaseRequest logout];
        
        //发送退出请求
        [self postLogout];
        
        
        
        //[self presentViewController:alertContor animated:NO completion:nil];
        return ;
    }]];
    [self presentViewController:alertContor animated:NO completion:nil];
    
}
-(void)postLogout{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *FrameRequestURL = [WebHost stringByAppendingString:@"/api/logout"];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:params success:^(id result) {
        NSLog(@"/api/logout ---%@---%@", params, result);
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            [FrameBaseRequest logout];
            
             [[NSNotificationCenter defaultCenter] addObserver:self   selector:@selector(loginSuccess) name:@"loginSuccess" object:nil];
            //跳转登陆页
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
            
            return ;
        }
        if(code == 0){
            
            [FrameBaseRequest showMessage:result[@"value"]];
            [FrameBaseRequest logout];
             [[NSNotificationCenter defaultCenter] addObserver:self   selector:@selector(loginSuccess) name:@"loginSuccess" object:nil];
            //跳转登陆页
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
        }
        
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            [FrameBaseRequest logout];
             [[NSNotificationCenter defaultCenter] addObserver:self   selector:@selector(loginSuccess) name:@"loginSuccess" object:nil];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
            return;
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
    
}
-(void)gotoInfo{
    PersonalInfoController *InfoController = [[PersonalInfoController alloc] init];
    [self.slideMenuController showViewController:InfoController];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第%ld行Cell所做的操作",(long)indexPath.section);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_typeClick) {
        _typeClick(indexPath.section,[BasicViewController class]);
    }    NSInteger pathrow = indexPath.section;
    if(pathrow == 0){//头像
        _clickNum = 0;
        return ;
    }
    if(pathrow == 1){//台站值班#import "PersonalPatrolController.h"
        [self showNavigation];
        PersonalPatrolController *PatrolController = [[PersonalPatrolController alloc] init];
        [self.slideMenuController showViewController:PatrolController];
        return ;
    }
    if(pathrow == 2){//所属台站
        [self showNavigation];
        PersonalChooseStationController *ChooseStation = [[PersonalChooseStationController alloc] init];
        [self.slideMenuController showViewController:ChooseStation];
        return ;
    }
    if(pathrow == 3){//我的消息
        [self showNavigation];
        PersonalMsgController *ChooseStation = [[PersonalMsgController alloc] init];
        [self.slideMenuController showViewController:ChooseStation];
        return ;
    }
    if(pathrow == 4){//设置
         [self showNavigation];
        PersonalSetController *ChooseStation = [[PersonalSetController alloc] init];
        [self.slideMenuController showViewController:ChooseStation];
        return ;
    }
    if(pathrow == 5){//清理缓存
        NSLog(@"登录缓存不可清除   %f",[self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject]);
        NSLog(@"size   %f",[self folderSizeAtPath:NSTemporaryDirectory()]);
        //
        CGFloat size = [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject] +[self folderSizeAtPath:NSTemporaryDirectory()];
        //if(size <= 0.00025){
         //   size = 0.0;
        //}
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:@"station"];
        _stationName.text = @"";
        NSString *message =@"";
        if(size > 1){
            message =[NSString stringWithFormat:@"成功清理%.2fM缓存", size];
        } else if(size == 0){
            message =[NSString stringWithFormat:@"成功清理%dK缓存", 0];
        }else{
            message =[NSString stringWithFormat:@"成功清理%.2fKB缓存", size * 1024.0];
        }
        
        
        [self cleanCaches:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject];
        //[self cleanCaches:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject];
        [self cleanCaches:NSTemporaryDirectory()];
        //NSString * msg = [NSString stringWithFormat:@"成功清理%0.2fKB缓存",huan];
        
        [FrameBaseRequest showMessage:message];
        return ;
    }
    
    if(pathrow == 6){//退出登录
        return ;
    }
    
    PersonalSetController *SetController = [[PersonalSetController alloc] init];
    [self.navigationController pushViewController:SetController animated:YES];
    return ;
    
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

// 计算目录大小
- (CGFloat)folderSizeAtPath:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    if ([manager fileExistsAtPath:path]) {
        // 获取该目录下的文件，计算其大小
        NSArray *childrenFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            size += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
        // 将大小转化为M
        return size / 1024.0 / 1024.0;
    }
    return 0;
}
// 根据路径删除文件
- (void)cleanCaches:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        // 获取该路径下面的文件名
        NSArray *childrenFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childrenFiles) {
            // 拼接路径
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            // 将文件删除
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    
}
//登录成功跳首页
-(void)loginSuccess{
    self.isLoginSuccess = 1;
    [self Initialization];
    return ;
}

//展示navigation背景色
-(void)showNavigation{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}
-(void)backAction{
    
    
    [self.slideMenuController  hideMenu];
}

@end

