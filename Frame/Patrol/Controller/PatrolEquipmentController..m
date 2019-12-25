//
//  PatrolSpecialController
//  Frame
//
//  Created by hibayWill on 2018/3/29.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "PatrolEquipmentController.h"
#import "PatrolSetController.h"
#import "Patroltems.h"

#import "FrameBaseRequest.h"
#import <UIImageView+WebCache.h>
#import "FSTextView.h"

#import <MJExtension.h>

@interface PatrolEquipmentController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray<Patroltems *> * Patroltem;

@property NSUInteger newHeight;
@property BOOL isBack;
@property (nonatomic, strong) NSMutableArray *objectLists;
@property (nonatomic, strong)NSMutableArray * evList;
@property (nonatomic, strong)NSMutableArray * faultList;
@property (nonatomic, strong)NSMutableArray * anotherList;


@property   int submitNum;

@property(nonatomic) UIView* bottomView;
@property(nonatomic) UITableView *tableview;
@end

@implementation PatrolEquipmentController

#pragma mark - 全局常量

#pragma mark - life cycle 生命周期方法

- (void)viewDidLoad {
    [self backBtn];
    _isBack = false;
    [super viewDidLoad];
    self.title = @"巡检设备清单";
    UIFont *font = [UIFont fontWithName:@"Arial-ItalicMT" size:21];
    NSDictionary *dic = @{NSFontAttributeName:font,  NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes =dic;
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, View_Width, View_Height - ZNAVViewH)];
    self.tableview.backgroundColor = BGColor;
    //[self.tableview registerClass:[UITableViewCell class]forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.tableview];
    
    self.tableview.delegate =self;
    self.tableview.dataSource =self;
    self.tableview.separatorStyle = NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    [self setupTable];
}

-(void)viewWillDisappear:(BOOL)animated{
    
}

-(void)viewDidAppear:(BOOL)animated{
    // NSLog(@"viewDidAppear");
}
-(void)viewDidDisappear:(BOOL)animated{
}
-(void)viewWillLayoutSubviews{
    // NSLog(@"viewWillLayoutSubviews");
}

#pragma mark - private methods 私有方法

- (void)setupTable{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:@"/api/getStationWeatherCheckList"];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        NSArray * AllStations = result[@"value"];
        self.objectLists = [NSMutableArray new];
        for (int a = 0; a < AllStations.count; a++) {
            self.evList = [NSMutableArray new];
            self.faultList = [NSMutableArray new];
            self.anotherList = [NSMutableArray new];
            
            if([AllStations[a][@"list"] isKindOfClass:[NSArray class]]){
                //list
                NSArray * dataList = AllStations[a][@"list"];
                for (int i = 0; i < dataList.count; i++) {
                    if([dataList[i][@"title"] isEqualToString:@"环境检查"] && [dataList[i][@"data"] isKindOfClass:[NSArray class]]){
                        NSArray * contentList = dataList[i][@"data"];
                        if(contentList.count > 0){
                            for (int j = 0; j < contentList.count; j++) {
                                [self.evList addObject:contentList[j][@"content"]];
                            }
                        }
                    }
                    if([dataList[i][@"title"] isEqualToString:@"重点设备"] && [dataList[i][@"data"] isKindOfClass:[NSArray class]]){
                        NSArray * contentList = dataList[i][@"data"];
                        if(contentList.count > 0){
                            for (int j = 0; j < contentList.count; j++) {
                                [self.faultList addObject:contentList[j][@"content"]];
                            }
                        }
                    }
                    if([dataList[i][@"title"] isEqualToString:@"备件储备情况"] && [dataList[i][@"data"] isKindOfClass:[NSArray class]]){
                        NSArray * contentList = dataList[i][@"data"];
                        if(contentList.count > 0){
                            for (int j = 0; j < contentList.count; j++) {
                                [self.anotherList addObject:contentList[j][@"content"]];
                            }
                        }
                    }
                }
                NSMutableDictionary *thisStationDic = [NSMutableDictionary new];
                [thisStationDic addEntriesFromDictionary:AllStations[a][@"station"]];
                [thisStationDic addEntriesFromDictionary:@{@"weatherStation":self.evList,@"faultStation":self.faultList,@"anotherStation":self.anotherList}];
  
                [ self.objectLists addObject:thisStationDic];
            }
        }
        
        [self.tableview reloadData];
        
    } failure:^(NSURLSessionDataTask *error)  {
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            [FrameBaseRequest logout];
            UIViewController *viewCtl = self.navigationController.viewControllers[0];
            [self.navigationController popToViewController:viewCtl animated:YES];
            return;
        }else if(responses.statusCode == 502){
            
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //weatherStation//faultStation//anotherStation
    NSDictionary * object = self.objectLists[indexPath.row];
    
    //高度放进model中
    return [self getCellHeight:object];
}

#pragma mark - UITableviewDatasource 数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.objectLists.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *thiscell = [[UITableViewCell alloc] init];
    thiscell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
    thiscell.backgroundColor = BGColor;
    //title
    UIView *titleBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIDTH_SCREEN, FrameWidth(80))];
    titleBGView.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:titleBGView];
    
    
    UILabel * titleLable = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(20), 0, FrameWidth(600), FrameWidth(80))];
    titleLable.font = FontSize(18);
    titleLable.text = [NSString stringWithFormat:@"%@%@",@"检查台站：",self.objectLists[indexPath.row][@"alias"]] ;
    [titleBGView addSubview:titleLable];
    
    
    //环境检查
    
    //[thisStationDic addEntriesFromDictionary:@{@"weatherStation":self.evList,@"faultStation":self.faultList,@"anotherStation":self.anotherList}];
 
    float evHeight = [self setFilterView:thiscell objects:self.objectLists[indexPath.row][@"weatherStation"] title:@"环境检查" OrignY:titleLable.originY + titleLable.frameHeight+2];
    
    float faultHeight = [self setFilterView:thiscell objects:self.objectLists[indexPath.row][@"faultStation"] title:@"重点设备" OrignY:evHeight];
    float anotherHeight = [self setFilterView:thiscell objects:self.objectLists[indexPath.row][@"anotherStation"] title:@"备件储备情况" OrignY:faultHeight];
    
    
    //生成巡检任务
    UIView * messionBGView = [[UIView alloc] initWithFrame:CGRectMake(0, anotherHeight, WIDTH_SCREEN, FrameWidth(120))];
    messionBGView.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:messionBGView];
    
    UIButton * makeSureBtn = [[UIButton alloc] initWithFrame:CGRectMake(FrameWidth(224), FrameWidth(37)+anotherHeight, FrameWidth(220), FrameWidth(50))];
    [makeSureBtn setTitle:@"生成巡检任务" forState:UIControlStateNormal];
    
    
    [makeSureBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [makeSureBtn.layer setCornerRadius:FrameWidth(10)]; //设置矩形四个圆角半径
    [makeSureBtn.layer setBorderWidth:1.5]; //边框宽度
    [makeSureBtn setTitleColor:FrameColor(100, 170, 250) forState:UIControlStateNormal];//title color
    [makeSureBtn setTitleColor:FrameColor(10, 70, 50) forState:UIControlStateHighlighted];
    makeSureBtn.titleLabel.font = FontSize(15);
    [makeSureBtn.layer setBorderColor:[UIColor colorWithRed:100/255.0 green:170/255.0 blue:250/255.0 alpha:1].CGColor];//边框颜色
    [thiscell addSubview:makeSureBtn];
    
    return thiscell;
    
}



#pragma mark - UITableviewDelegate 代理方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 点击了第indexPath.row行Cell所做的操作
    [self.view endEditing:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了第%ld行Cell所做的操作",(long)indexPath.row);
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
-(void)submitAction:(UIButton *)btn{
    UITableViewCell *cell = (UITableViewCell *)[btn superview];
    // 获取cell的indexPath
    NSIndexPath *indexPath = [self.tableview indexPathForCell:cell];
    
    
    PatrolSetController  *PatrolSet = [[PatrolSetController alloc] init];
    PatrolSet.specialCode = @"weatherInspection";
    PatrolSet.status = @"1";
    
    PatrolSet.stationName = self.objectLists[indexPath.row][@"alias"];
    PatrolSet.stationCode = self.objectLists[indexPath.row][@"code"];
    PatrolSet.type_code = @"special";
    
    
    [self.navigationController pushViewController:PatrolSet animated:YES];
    /*
    
    NSString *FrameRequestURL = [WebHost stringByAppendingString:@"/api/saveAtcPatrolRecode"];
    
    [FrameBaseRequest putWithUrl:FrameRequestURL param:nil success:^(id result) {
        _submitNum = 0;
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        _id =  [result[@"value"][@"recode"][@"id"] copy];
        
        if(btn.tag == 100){
            [FrameBaseRequest showMessage:@"保存成功"];
        }else{
            [FrameBaseRequest showMessage:@"提交成功"];
            [self backAction];
        }
        if(_isBack){
            [self backAction];
        }else{
        }
        
    } failure:^(NSError *error)  {
        _submitNum = 0;
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
            [FrameBaseRequest logout];
            UIViewController *viewCtl = self.navigationController.viewControllers[0];
            [self.navigationController popToViewController:viewCtl animated:YES];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
    */
    
}
-(void)backAction {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation2"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat) getCellHeight:(NSDictionary *)objects {
    CGFloat nowHeight = FrameWidth(92)*3;
    //weatherStation//faultStation//anotherStation
    
    NSMutableArray *ALLObject = [NSMutableArray arrayWithArray:objects[@"weatherStation"]];
    [ALLObject addObjectsFromArray:objects[@"faultStation"]];
    [ALLObject addObjectsFromArray:objects[@"anotherStation"]];
    //列表
    for (int i =0; i<ALLObject.count; i++) {
        CGRect rect = [ALLObject[i] boundingRectWithSize:CGSizeMake(FrameWidth(520), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName :  FontSize(16)} context:nil];
        nowHeight += (rect.size.height+FrameWidth(20));
        
    }
    return nowHeight+FrameWidth(210)+2;
}


-(CGFloat) setFilterView :(UITableViewCell *)vc objects:(NSArray *)objects title:(NSString *)title OrignY:(float )OrignY  {
    CGFloat Thisheight = OrignY;
    //总背景
    UIView *BgView = [[UIView alloc]initWithFrame:CGRectMake(0,Thisheight, WIDTH_SCREEN, 0)];
    BgView.backgroundColor = [UIColor whiteColor];
    [vc addSubview:BgView];
    //列表背景
    UIView *BGListView = [[UIView alloc]initWithFrame:CGRectMake(FrameWidth(20),FrameWidth(15), FrameWidth(595), FrameWidth(595))];
    BGListView.backgroundColor = [UIColor whiteColor];
    BGListView.layer.borderWidth = 0.5;
    BGListView.layer.cornerRadius = 5;
    BGListView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [BgView addSubview:BGListView];
    
    //设置标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake( FrameWidth(20),FrameWidth(5), FrameWidth(540) , FrameWidth(57))];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font =  FontSize(18);
    titleLabel.textColor = listGrayColor;
    [BGListView addSubview:titleLabel];
    float nowHeight = titleLabel.originY + titleLabel.frameHeight;
    //列表
    for (int i =0; i<objects.count; i++) {
        UIImageView * starImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"station_rank1"]];
        starImgV.frame = CGRectMake(FrameWidth(25),nowHeight + FrameWidth(30), FrameWidth(15), FrameWidth(15));
        [BGListView addSubview:starImgV];
        
        UILabel * descLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(55), nowHeight + FrameWidth(15), FrameWidth(520), FrameWidth(35))];
        descLabel.numberOfLines = 0;
        descLabel.font = FontSize(16);
        descLabel.textColor = listGrayColor;
        descLabel.text = objects[i];
        
        CGRect rect = [descLabel.text boundingRectWithSize:CGSizeMake(descLabel.frameWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : descLabel.font} context:nil];
        [descLabel setFrameHeight:rect.size.height];
        [BGListView addSubview:descLabel];
        
        nowHeight = descLabel.originY + descLabel.frameHeight;
        
        
    }
    [BGListView setFrameHeight:nowHeight + FrameWidth(15)];
    [BgView setFrameHeight:BGListView.originY +BGListView.frameHeight];
    return BgView.frameHeight + BgView.originY;
    
}


@end

