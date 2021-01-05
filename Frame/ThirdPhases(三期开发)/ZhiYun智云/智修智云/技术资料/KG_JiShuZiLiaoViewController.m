//
//  KG_TecInforViewController.m
//  Frame
//
//  Created by zhangran on 2020/5/20.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_JiShuZiLiaoViewController.h"
#import "KG_TechInfoCell.h"
#import "KG_StandardSpecificationViewController.h"
#import "KG_TecInforViewController.h"
@interface KG_JiShuZiLiaoViewController ()<UITableViewDelegate,UITableViewDataSource>{

}

@property (nonatomic, strong) NSMutableArray            *dataArray;
@property (nonatomic, strong) NSArray                   *listArray;
@property (nonatomic, strong) UITableView               *tableView;


@property (nonatomic, strong)   UILabel                 *titleLabel;

@property (nonatomic, strong)   UIView                  *navigationView;

@end

@implementation KG_JiShuZiLiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNaviTopView];
    [self createTopView];
    [self initViewData];
    [self queryData];
    
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


- (void)createTopView {
    UIView *topView = [[UIView alloc]init];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    topView.layer.cornerRadius = 10.f;
    topView.layer.masksToBounds = YES;
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(NAVIGATIONBAR_HEIGHT);
        make.height.equalTo(@120);
    }];
    
    UIImageView *speakIcon = [[UIImageView alloc]init];
    [topView addSubview:speakIcon];
    speakIcon.image = [UIImage imageNamed:@"speaker_icon"];
    [speakIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).offset(16);
        make.width.equalTo(@22);
        make.height.equalTo(@18);
        make.top.equalTo(topView.mas_top).offset(20);
    }];
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [topView addSubview:titleLabel];
    titleLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.font = [UIFont my_font:12];
    titleLabel.text = @"这里仅展示与该告警事件有关的技术资料，您可以切换到该台站查看更多信息。";
    titleLabel.numberOfLines = 2;
    [titleLabel sizeToFit];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(speakIcon.mas_centerY);
        make.left.equalTo(speakIcon.mas_right).offset(8);
        make.right.equalTo(topView.mas_right).offset(-15);
        
    }];

    UIButton *botBtn = [[UIButton alloc]init];
    [topView addSubview:botBtn];
    [botBtn setBackgroundColor:[UIColor colorWithRed:50.f/255.f green:97.f/255.f blue:206.f/255.f alpha:1]];
    [botBtn setTitle:@"本台站" forState:UIControlStateNormal];
    botBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [botBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [botBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView.mas_right).offset(-20);
        make.top.equalTo(topView.mas_top).offset(56);
        make.height.equalTo(@28);
        make.width.equalTo(@80);
    }];
    [botBtn addTarget:self action:@selector(botMethod:) forControlEvents:UIControlEventTouchUpInside];
    botBtn.layer.cornerRadius = 4.f;
    botBtn.layer.masksToBounds = YES;
    
}


- (void)botMethod:(UIButton *)btn {
    
    KG_TecInforViewController *vc = [[KG_TecInforViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)initViewData {
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    [dic1 setObject:@"标准规范" forKey:@"title"];
    [dic1 setObject:@"biaozhun_icon" forKey:@"icon"];
    
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    [dic2 setObject:@"操作指引" forKey:@"title"];
    [dic2 setObject:@"caozuo_icon" forKey:@"icon"];
    
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
    [dic3 setObject:@"地空通讯技术资料" forKey:@"title"];
    [dic3 setObject:@"dikong_icon" forKey:@"icon"];
    
    NSMutableDictionary *dic4 = [NSMutableDictionary dictionary];
    [dic4 setObject:@"导航设备资料" forKey:@"title"];
    [dic4 setObject:@"daohangshebei_icon" forKey:@"icon"];
    
    NSMutableDictionary *dic5 = [NSMutableDictionary dictionary];
    [dic5 setObject:@"平面通讯技术资料" forKey:@"title"];
    [dic5 setObject:@"pingmian_icon" forKey:@"icon"];
    
    NSMutableDictionary *dic6 = [NSMutableDictionary dictionary];
    [dic6 setObject:@"应急操作指引" forKey:@"title"];
    [dic6 setObject:@"yingji_icon" forKey:@"icon"];
    
    NSMutableDictionary *dic7 = [NSMutableDictionary dictionary];
    [dic7 setObject:@"监视设备资料" forKey:@"title"];
    [dic7 setObject:@"jianshi_icon" forKey:@"icon"];
    
    NSMutableDictionary *dic8 = [NSMutableDictionary dictionary];
    [dic8 setObject:@"设备维护规程" forKey:@"title"];
    [dic8 setObject:@"shebei_icon" forKey:@"icon"];
    
    [self.dataArray addObject:dic1];
    [self.dataArray addObject:dic2];
    [self.dataArray addObject:dic3];
    [self.dataArray addObject:dic4];
    [self.dataArray addObject:dic5];
    [self.dataArray addObject:dic6];
    [self.dataArray addObject:dic7];
    [self.dataArray addObject:dic8];
    
    [self createTableView];
}

- (void)createTableView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(NAVIGATIONBAR_HEIGHT+111);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.tableView reloadData];
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
    self.titleLabel.text = @"技术资料";
    
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


-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 8;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        
        
    }
    return _tableView;
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_TechInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_TechInfoCell"];
    if (cell == nil) {
        cell = [[KG_TechInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_TechInfoCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    cell.dataDic = dataDic;
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count != self.listArray.count) {
        return;
    }
    NSDictionary *dataDic = self.listArray[indexPath.row];
    KG_StandardSpecificationViewController *vc = [[KG_StandardSpecificationViewController alloc]init];
    vc.dataDic = dataDic;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    //    NSString *str = self.dataArray[indexPath.row];
    
}
//请求地址：/intelligent/atcTechnicalInfomation/equipmentRelated/{equipmentCode}
//其中，equipmentCode是告警设备编码
- (void)queryData {
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcTechnicalInfomation/equipmentRelated/%@",safeString(self.model.equipmentCode)]];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
           
            return ;
        }
        
        self.listArray = result[@"value"];
        
        
    } failure:^(NSURLSessionDataTask *error)  {
        [MBProgressHUD hideHUD];
        
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
        return ;
    }];
}
@end
