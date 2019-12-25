//
//  PatrolSetController.m
//  Frame
//
//  Created by hibayWill on 2018/3/29.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "PatrolSetController.h"
#import "Patroltems.h"
#import "MediaModel.h"

#import "FrameBaseRequest.h"
#import <UIImageView+WebCache.h>
#import "PGDatePickManager.h"
#import "FSTextView.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <AVKit/AVKit.h>
#import "WSLPictureBrowseView.h"
#import <AVFoundation/AVFoundation.h>
#import "PhotoBrowseViewController.h"
//多图选择
#import <QBImagePickerController/QBImagePickerController.h>


@interface PatrolSetController ()<UITableViewDataSource,UITableViewDelegate,PGDatePickerDelegate,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,QBImagePickerControllerDelegate>

@property (strong, nonatomic) NSMutableArray<Patroltems *> * Patroltem;

@property NSUInteger newHeight;
@property BOOL isInsert;
@property BOOL isBack;
@property(strong,nonatomic)UIButton *startDate;
@property(strong,nonatomic)PGDatePicker *startDatePicker;
@property (nonatomic,copy) NSString* start_time;
@property (nonatomic,copy) UITextField* PatrolManText;
@property (nonatomic,copy) NSString* patrolTitle;
@property (nonatomic,copy) NSDictionary* recode;

@property (nonatomic, assign) CGFloat keyBoardHeight;   //键盘高度
@property (nonatomic, assign) CGRect originalFrame;    //记录视图的初始坐标
@property (nonatomic,strong) FSTextView *resultTextView;   //当前输入框
@property (strong, nonatomic) NSMutableArray<MediaModel *> *  atcPatrolMediaList;



@property   int submitNum;
@property  BOOL isSuccess;

@property(nonatomic) UIView* bottomView;
@property(nonatomic) UITableView *tableview;
@property(nonatomic) UITableView *imageTableView;
@property(nonatomic) UITableView *videoTableView;
@property(nonatomic) NSMutableArray *imageList;
@property(nonatomic) NSMutableArray *videoList;
@property(nonatomic) NSMutableArray *mediaUrlList;
@property(nonatomic, strong)UIButton *rightButon;
@property(nonatomic, strong) UIButton *sesultBtn;
@end

@implementation PatrolSetController{
    
    UIImage *GitImage;
}

#pragma mark - 全局常量

#pragma mark - life cycle 生命周期方法

- (void)viewDidLoad {
    [self backBtn];
    _isBack = false;
    [super viewDidLoad];
    _patrolTitle = @"例行巡查";
    if([_type_code isEqualToString: @"comprehensive"] ){//routine////comprehensive//special
        _patrolTitle = @"全面巡查";
    }
    if([_type_code isEqualToString: @"special"] ){//routine////comprehensive//special
        _patrolTitle = @"特殊巡查";
    }
//    if([_specialCode isEqualToString: @"weatherInspection"] ){//routine////comprehensive//special
//        _patrolTitle = @"天气巡检";
//    }
    self.imageList = [NSMutableArray new];
    self.videoList = [NSMutableArray new];
    self.mediaUrlList = [NSMutableArray new];
    
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, View_Width, View_Height-ZNAVViewH)];
    self.tableview.backgroundColor = BGColor;
    //[self.tableview registerClass:[UITableViewCell class]forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.tableview];
    
    self.tableview.delegate =self;
    self.tableview.dataSource =self;
    self.tableview.separatorStyle = NO;
    
    //图片上传的
    self.imageTableView = [[UITableView alloc]initWithFrame:CGRectMake((WIDTH_SCREEN - FrameWidth(150))/2,(FrameWidth(150) - WIDTH_SCREEN)/2 + FrameWidth(80), FrameWidth(150), WIDTH_SCREEN) style:UITableViewStylePlain];
    self.imageTableView.dataSource=self;
    self.imageTableView.delegate=self;
    //对TableView要做的设置
    self.imageTableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
    self.imageTableView.showsVerticalScrollIndicator=NO;
    self.imageTableView.separatorStyle =NO;
    //视频上传的
    self.videoTableView = [[UITableView alloc]initWithFrame:CGRectMake((WIDTH_SCREEN - FrameWidth(150))/2,(FrameWidth(150) - WIDTH_SCREEN)/2 + FrameWidth(210), FrameWidth(150), WIDTH_SCREEN) style:UITableViewStylePlain];
    self.videoTableView.dataSource=self;
    self.videoTableView.delegate=self;
    //对TableView要做的设置
    self.videoTableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
    self.videoTableView.showsVerticalScrollIndicator=NO;
    self.videoTableView.separatorStyle =NO;
    
    
    [self setupTable];
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"PatrolSetController shopdetailviewWillAppear");
    [self registerForKeyboardNotifications];//注册键盘通知
    
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"PatrolSetController viewWillDisappear");
    [[NSNotificationCenter defaultCenter] removeObserver:self];//去除键盘通知
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    
}
-(void)viewDidDisappear:(BOOL)animated{
    
}
-(void)viewWillLayoutSubviews{
    
}
//注册键盘事件
- (void)registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //键盘消失时
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification*)notification{
    NSLog(@"keyboardWillShowalarm");
    //NSDictionary* info = [notification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    //CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    _keyBoardHeight = 50;//kbSize.height -180;
    //设置视图移动的位移
    if(self.tableview.frame.size.height >=self.view.bounds.size.height){
        NSLog(@"_keyBoardHeight %f",_keyBoardHeight);
        
        self.tableview.frame = CGRectMake(self.tableview.frame.origin.x, 0, self.tableview.frame.size.width, self.tableview.frame.size.height-_keyBoardHeight);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableview scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}

- (void)keyboardWillHide:(NSNotification *)notification{//返回
    NSLog(@"keyboardWillHide");
    self.tableview.frame = CGRectMake(self.tableview.frame.origin.x, 0, self.tableview.frame.size.width, self.view.bounds.size.height);
}


#pragma mark - private methods 私有方法

- (void)setupTable{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"station_code"] = _stationCode;
    if([_status isEqualToString:@"0"]){
        params[@"type"] = @"0";
        params[@"id"] = _id;
    }else{
        params[@"type"] = @"1";
    }
    params[@"type_code"] = _type_code;
    params[@"special_code"] = _specialCode;
    
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:@"/api/atcPatrolInfo"];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        NSMutableArray<Patroltems *> * arr = [[Patroltems class] mj_objectArrayWithKeyValuesArray:@[]];
        
        
        for (NSDictionary * infoList in result[@"value"][@"infoList"]) {
            Patroltems *m1 = [Patroltems mj_objectWithKeyValues:@{@"type":@"firstTitle",@"firstTitle":infoList[@"firstTitle"],@"LabelHeight":[NSNumber numberWithInt:FrameWidth(102)]}];
            [arr addObject:m1];
            
            
            for (NSArray * info in infoList[@"info"]) {
                Patroltems *infoPatrol = [Patroltems mj_objectWithKeyValues:info];
                [arr addObject:infoPatrol];
            }
        }
        self.Patroltem = [arr copy];
        
        _recode = [result[@"value"][@"recode"] copy];
        if (_recode[@"atcPatrolMediaList"] && [_recode[@"atcPatrolMediaList"] isKindOfClass:[NSArray class]]) {
            
            NSMutableArray<MediaModel *> * mediaList = [[MediaModel class] mj_objectArrayWithKeyValuesArray:_recode[@"atcPatrolMediaList"]];
            
            for (int i = 0; i< mediaList.count; i++) {
                if( [mediaList[i].url hasSuffix:@".mp4"]){
                    //NSURL *url = [NSURL URLWithString: mediaList[i].url];
                    [self.videoList addObject:mediaList[i].url];
                }else{
                    [self.imageList addObject:mediaList[i].url];
                }
            }
        }
        
        if(!_stationName){_stationName = _recode[@"stationName"];}
        
        self.navigationItem.title = [NSString stringWithFormat:@"%@-%@",_patrolTitle,_stationName];
        [self.videoTableView reloadData];
        [self.imageTableView reloadData];
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
    [self.view addSubview:self.tableview];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.imageTableView){
        return FrameWidth(150);
    }else if(tableView == self.videoTableView){
        return FrameWidth(150);
    }
    return _newHeight +FrameWidth(30);
}

#pragma mark - UITableviewDatasource 数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.imageTableView){
        if(self.imageList.count == 5){
            return self.imageList.count+1;
        }
        return self.imageList.count+2;
    }else if(tableView == self.videoTableView){
        if(self.videoList.count == 3){
            return self.videoList.count+1;
        }
        return self.videoList.count+2;
        
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.imageTableView){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FyCell"];//[tableView dequeueReusableCellWithIdentifier:@"FyCell"];
        if (!cell) {
            //cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FyCell"];
        }
        //对Cell要做的设置
        
        if(indexPath.row == 0){
            cell.textLabel.text= @"图片";
            cell.textLabel.textColor = [UIColor grayColor];
        }else if(indexPath.row == self.imageList.count+1){
            UIImageView * addImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"patrol_img_add"]];
            addImgView.frame = CGRectMake(FrameWidth(15), FrameWidth(15), FrameWidth(100), FrameWidth(100));
            
             [addImgView addGestureRecognizer:[[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(selImgShow:) ]];
            [addImgView setUserInteractionEnabled:YES];
            [cell addSubview:addImgView];
            
        }else{
            UIImageView * addImgView = [[UIImageView alloc]initWithFrame: CGRectMake(FrameWidth(15), FrameWidth(15), FrameWidth(100), FrameWidth(100))];
            addImgView.contentMode = 1;
            if([self.imageList[indexPath.row-1] isKindOfClass:[NSString class]]){
                [addImgView sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",WebHost,self.imageList[indexPath.row-1]]] ];
            }else{
                addImgView.image = self.imageList[indexPath.row-1];
            }
            
            //UIImageView * addImgView = [[UIImageView alloc]initWithImage:self.imageList[indexPath.row-1]];
            //addImgView.frame = CGRectMake(FrameWidth(15), FrameWidth(15), FrameWidth(100), FrameWidth(100));
            [cell addSubview:addImgView];
            
            UIImageView *deleteImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Patrol_img_delete"]];
            deleteImg.frame = CGRectMake(FrameWidth(90), FrameWidth(0), FrameWidth(40), FrameWidth(40));
            [deleteImg addGestureRecognizer:[[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(selImgDelete:) ]];
            [deleteImg setUserInteractionEnabled:YES];
            [cell addSubview:deleteImg];
            
        }
        cell.transform = CGAffineTransformMakeRotation(M_PI/2);
        cell.selectionStyle = 0;
        return cell;
    }else if(tableView == self.videoTableView){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FyCell1"];//[tableView dequeueReusableCellWithIdentifier:@"FyCell"];
        if (!cell) {
            //cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FyCell"];
        }
        //对Cell要做的设置
        
        if(indexPath.row == 0){
            cell.textLabel.text= @"视频";
            cell.textLabel.textColor = [UIColor grayColor];
        }else if(indexPath.row == self.videoList.count+1){
            UIImageView * addImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"patrol_img_add"]];
            addImgView.frame = CGRectMake(FrameWidth(15), FrameWidth(15), FrameWidth(100), FrameWidth(100));
            
            [addImgView addGestureRecognizer:[[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(selVideoShow:) ]];
            [addImgView setUserInteractionEnabled:YES];
            [cell addSubview:addImgView];
            
        }else{
            UIImageView * addImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"patrol_video"]];
            addImgView.frame = CGRectMake(FrameWidth(15), FrameWidth(15), FrameWidth(100), FrameWidth(100));
            [cell addSubview:addImgView];
            
            UIImageView *deleteImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Patrol_img_delete"]];
            [deleteImg addGestureRecognizer:[[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(selVideoDelete:) ]];
            [deleteImg setUserInteractionEnabled:YES];
            deleteImg.frame = CGRectMake(FrameWidth(90), FrameWidth(0), FrameWidth(40), FrameWidth(40));
            [cell addSubview:deleteImg];
        }
        cell.transform = CGAffineTransformMakeRotation(M_PI/2);
        cell.selectionStyle = 0;
        return cell;
    }
    
    
    UITableViewCell *thiscell = [[UITableViewCell alloc] init];
    thiscell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
    thiscell.backgroundColor = BGColor;
    //基本信息
    UIView *basicView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, FrameWidth(80))];
    basicView.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:basicView];
    //图
    UIImageView *basicImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Patrol_icon_jbxx"]];
    [basicImgView setFrame:CGRectMake(FrameWidth(20), FrameWidth(25), FrameWidth(30), FrameWidth(30))];
    [basicView addSubview:basicImgView];
    //name
    UILabel *basicnameLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(60), 0, FrameWidth(400), FrameWidth(80))];
    basicnameLabel.text = @"基本信息";
    basicnameLabel.font = FontSize(18);
    [basicView addSubview:basicnameLabel];
    
    //台站名称
    UIView *stationView = [[UIView alloc]initWithFrame:CGRectMake(0, basicView.frame.origin.y + basicView.frame.size.height+1, WIDTH_SCREEN, FrameWidth(72))];
    stationView.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:stationView];
    //title
    UILabel *stationNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(22),0, FrameWidth(300), FrameWidth(72))];
    stationNameLabel.textColor = [UIColor grayColor];
    stationNameLabel.text = @"台站名称";
    stationNameLabel.font = FontSize(17);
    [stationView addSubview:stationNameLabel];
    //name
    UILabel *stationLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(350), 0, FrameWidth(260), FrameWidth(72))];
    stationLabel.font = FontSize(17);
    stationLabel.textColor = [UIColor grayColor];
    stationLabel.textAlignment = NSTextAlignmentRight;
    stationLabel.text = _stationName;//@"台站名称";
    [stationView addSubview:stationLabel];
    
    //巡查类型
    UIView *PatrolTypeView = [[UIView alloc]initWithFrame:CGRectMake(0, stationView.frame.origin.y + stationView.frame.size.height+1, WIDTH_SCREEN, FrameWidth(72))];
    PatrolTypeView.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:PatrolTypeView];
    //title
    UILabel *PatrolTypNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(22), 0, FrameWidth(300), FrameWidth(72))];
    PatrolTypNameLabel.text = @"巡查类型";
    PatrolTypNameLabel.font = FontSize(17);
    PatrolTypNameLabel.textColor = [UIColor grayColor];
    [PatrolTypeView addSubview:PatrolTypNameLabel];
    //name
    UILabel *PatrolTypLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(350), 0, FrameWidth(260), FrameWidth(72))];
    PatrolTypLabel.text = _patrolTitle;//@"例行巡查";
    PatrolTypLabel.font = FontSize(17);
    PatrolTypLabel.textAlignment = NSTextAlignmentRight;
    PatrolTypLabel.textColor = [UIColor grayColor];
    [PatrolTypeView addSubview:PatrolTypLabel];
    
    
    //巡查人
    UIView *PatrolManView = [[UIView alloc]initWithFrame:CGRectMake(0, PatrolTypeView.frame.origin.y + PatrolTypeView.frame.size.height+1, WIDTH_SCREEN, FrameWidth(72))];
    PatrolManView.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:PatrolManView];
    //title
    UILabel *PatrolManNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(22), 0, FrameWidth(300), FrameWidth(72))];
    PatrolManNameLabel.text = @"巡查人";
    PatrolManNameLabel.font = FontSize(17);
    PatrolManNameLabel.textColor = [UIColor grayColor];
    [PatrolManView addSubview:PatrolManNameLabel];
    //name
    _PatrolManText = [[UITextField alloc]initWithFrame:CGRectMake(FrameWidth(160), 0, FrameWidth(480), FrameWidth(72))];
    _PatrolManText.delegate = self;
    _PatrolManText.font = FontSize(17);
    _PatrolManText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入巡查人姓名" attributes:@{NSFontAttributeName: FontSize(16)}];
    
    if(_recode&&![_recode[@"patrolName"] isEqual:[NSNull null]]){
        _PatrolManText.text = _recode[@"patrolName"];
    }
    [PatrolManView addSubview:_PatrolManText];
    

    //巡查时间
    UIView *PatrolDateView = [[UIView alloc]initWithFrame:CGRectMake(0, PatrolManView.frame.origin.y + PatrolManView.frame.size.height+1, WIDTH_SCREEN, FrameWidth(72))];
    PatrolDateView.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:PatrolDateView];
    //title
    UILabel *PatrolDateNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(22), 0, FrameWidth(300), FrameWidth(72))];
    PatrolDateNameLabel.text = @"巡查时间";
    
    
    PatrolDateNameLabel.font = FontSize(17);
    PatrolDateNameLabel.textColor = [UIColor grayColor];
    [PatrolDateView addSubview:PatrolDateNameLabel];
    //name
    _startDate = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(350), 0, FrameWidth(260), FrameWidth(72))];
    if(_recode &&![_recode[@"patrolTime"] isEqual:[NSNull null]]){
        _start_time = [FrameBaseRequest getDateByTimesp:[_recode[@"patrolTime"] doubleValue] dateType:@"YYYY-MM-dd"] ;
        [_startDate setTitle:_start_time forState:UIControlStateNormal];
    }else if(_start_time){
        [_startDate setTitle:_start_time forState:UIControlStateNormal];
    }else{
        [_startDate setTitle:@"请选择日期" forState:UIControlStateNormal];
    }
    [_startDate.titleLabel setFont:FontSize(17)];
    [_startDate setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _startDate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_startDate addTarget:self action:@selector(startDateAction) forControlEvents:UIControlEventTouchUpInside];
    [PatrolDateView addSubview:_startDate];
    //巡查内容
    UIView *detailView = [[UIView alloc]initWithFrame:CGRectMake(0, PatrolDateView.frame.origin.y + PatrolDateView.frame.size.height+FrameWidth(10), WIDTH_SCREEN, FrameWidth(80))];
    detailView.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:detailView];
    //图
    UIImageView *detailImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Patrol_icon_xcnr"]];
    [detailImgView setFrame:CGRectMake(FrameWidth(20), FrameWidth(25), FrameWidth(30), FrameWidth(30))];
    [detailView addSubview:detailImgView];
    //name
    UILabel *detailnameLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(60), 0, FrameWidth(400), FrameWidth(80))];
    detailnameLabel.text = @"巡查内容";
    detailnameLabel.font = FontSize(18);
    [detailView addSubview:detailnameLabel];
    
    _newHeight =  detailView.frame.origin.y + detailView.frame.size.height+2;
    for (int i=0; i<self.Patroltem.count; ++i) {
        int thisTag = i+1;
        if([self.Patroltem[i].type isEqualToString:@"radio"]){
            UIView *RadioView = [[UIView alloc]initWithFrame:CGRectMake(0, _newHeight , WIDTH_SCREEN, FrameWidth(140))];
            RadioView.backgroundColor = [UIColor whiteColor];
            [thiscell addSubview:RadioView];
            //title
            UILabel *RadioTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(20), 0, FrameWidth(600), FrameWidth(50))];
            RadioTitleLabel.text = [NSString stringWithFormat:@"%@",self.Patroltem[i].title];
            RadioTitleLabel.textColor = [UIColor grayColor];
            RadioTitleLabel.lineBreakMode = NSLineBreakByWordWrapping ;
            RadioTitleLabel.numberOfLines = 0;
            RadioTitleLabel.font = FontSize(16);
            [RadioTitleLabel sizeToFit];
            [RadioView addSubview:RadioTitleLabel];
            NSString *strUrl = [self.Patroltem[i].value  stringByReplacingOccurrencesOfString:@"[" withString:@""];
            strUrl = [strUrl  stringByReplacingOccurrencesOfString:@"]" withString:@""];
            strUrl = [strUrl  stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSArray *radioVal = [strUrl componentsSeparatedByString:@","];
            UIButton * RadioBtn =  [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(20), RadioTitleLabel.frame.size.height , FrameWidth(290), FrameWidth(80))];
            RadioBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//button内容横向居左
            RadioBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping ;
            RadioBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
            RadioBtn.tag = thisTag;
            [RadioBtn addTarget:self action:@selector(radioSelect:) forControlEvents:UIControlEventTouchUpInside];
            [RadioBtn setTitle:radioVal[0] forState:UIControlStateNormal];
            [RadioBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];//上左下右
            [RadioBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            //RadioBtn.titleLabel.textColor = [UIColor grayColor];
            //RadioBtn.backgroundColor = [UIColor blackColor];
            RadioBtn.titleLabel.font  = FontSize(16);
            [RadioBtn setImage:[UIImage imageNamed:@"Patrol_radio"] forState:UIControlStateNormal];
            [RadioBtn setImage:[UIImage imageNamed:@"Patrol_radio_s"] forState:UIControlStateSelected];
            [RadioView addSubview:RadioBtn];
            
            UIButton * RadioBtn2 =  [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(340), RadioTitleLabel.frame.size.height , FrameWidth(290), FrameWidth(80))];
            RadioBtn2.tag = thisTag + 1000;
            
            [RadioBtn2 addTarget:self action:@selector(radioSelect:) forControlEvents:UIControlEventTouchUpInside];
            [RadioBtn2 setImage:[UIImage imageNamed:@"Patrol_radio"] forState:UIControlStateNormal];
            [RadioBtn2 setImage:[UIImage imageNamed:@"Patrol_radio_s"] forState:UIControlStateSelected];
            [RadioBtn2 setTitle:radioVal[1] forState:UIControlStateNormal];
            [RadioBtn2 setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];//上左下右
            [RadioBtn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            RadioBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//button内容横向居左
            RadioBtn2.titleLabel.lineBreakMode = NSLineBreakByWordWrapping ;
            RadioBtn2.titleLabel.textAlignment = NSTextAlignmentLeft;
            RadioBtn2.titleLabel.font  = FontSize(16);
            
            [RadioView addSubview:RadioBtn2];
            
            [RadioView setFrameHeight:RadioBtn2.originY + RadioBtn2.frameHeight];
            if(self.Patroltem[i]&&![self.Patroltem[i].tagValue isEqual:[NSNull null]]){
                if([self.Patroltem[i].tagValue isEqualToString:radioVal[1]]){
                    [RadioBtn2 setSelected:YES];
                }
                if([self.Patroltem[i].tagValue isEqualToString:radioVal[0]]){
                    [RadioBtn setSelected:YES];
                }
            }
            
            _newHeight = RadioView.frame.origin.y + RadioView.frame.size.height+1;
        }else if([self.Patroltem[i].type isEqualToString:@"input"]){
            UIView *inputView = [[UIView alloc]initWithFrame:CGRectMake(0, _newHeight , WIDTH_SCREEN, FrameWidth(164))];
            inputView.backgroundColor = [UIColor whiteColor];
            [thiscell addSubview:inputView];
            //title
            UILabel *inputTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(20), FrameWidth(10), FrameWidth(600), FrameWidth(60))];
            
            inputTitleLabel.text = [NSString stringWithFormat:@"%@",self.Patroltem[i].title];
            inputTitleLabel.textColor = [UIColor grayColor];
            inputTitleLabel.font = FontSize(16);
            
            inputTitleLabel.lineBreakMode = NSLineBreakByWordWrapping ;
            inputTitleLabel.numberOfLines = 0;
            [inputTitleLabel sizeToFit];
            [inputView addSubview:inputTitleLabel];
            
            UITextField * inputTextfield = [[UITextField alloc]initWithFrame:CGRectMake(FrameWidth(22), FrameWidth(20)+inputTitleLabel.frameHeight, FrameWidth(595), FrameWidth(50))];
            inputTextfield.layer.cornerRadius = 4;
            inputTextfield.layer.borderWidth = 1;
            inputTextfield.delegate = self;
            inputTextfield.layer.borderColor = BGColor.CGColor;
            inputTextfield.font = FontSize(16);
            inputTextfield.tag = thisTag;
            inputTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 不超过200字" attributes:@{NSFontAttributeName: FontSize(16)}];
            [inputView addSubview:inputTextfield];
            
            [inputView setFrameHeight:inputTextfield.originY + inputTextfield.frameHeight + FrameWidth(40)];
            if(self.Patroltem[i]&&![self.Patroltem[i].tagValue isEqual:[NSNull null]]){
                inputTextfield.text = self.Patroltem[i].tagValue;
            }
            
            _newHeight = inputView.frame.origin.y + inputView.frame.size.height+1;
        }else if([self.Patroltem[i].type isEqualToString:@"textarea"]){
            UIView *inputView = [[UIView alloc]initWithFrame:CGRectMake(0, _newHeight , WIDTH_SCREEN, FrameWidth(286))];
            inputView.backgroundColor = [UIColor whiteColor];
            [thiscell addSubview:inputView];
            //title
            UILabel *inputTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(20), FrameWidth(10), FrameWidth(600), FrameWidth(60))];
            inputTitleLabel.text = [NSString stringWithFormat:@"%@",self.Patroltem[i].title];
            inputTitleLabel.textColor = [UIColor grayColor];
            inputTitleLabel.font = FontSize(16);
            inputTitleLabel.lineBreakMode = NSLineBreakByWordWrapping ;
            inputTitleLabel.numberOfLines = 0;
            [inputTitleLabel sizeToFit];
            [inputView addSubview:inputTitleLabel];
            
            
            
            UIView * resultTView = [[UIView alloc]initWithFrame:CGRectMake(FrameWidth(25), FrameWidth(20)+inputTitleLabel.frameHeight, FrameWidth(595), FrameWidth(166))];
            resultTView.layer.borderWidth = 1;
            resultTView.layer.borderColor = BGColor.CGColor;
            [inputView addSubview:resultTView];
            
            FSTextView *resultTextView = [FSTextView textView];
            resultTextView.tag = thisTag;
            resultTextView.font = FontSize(16);
            [resultTView addSubview:resultTextView];
            
            NSString *text = @"";
            if(self.Patroltem[i]&&![self.Patroltem[i].tagValue isEqual:[NSNull null]]){
                text = self.Patroltem[i].tagValue;
            }
            [self addTViewParent:resultTView textView:resultTextView text:text placeholder:@" 不超过200字" maxLength:200];
            
            [inputView setFrameHeight:resultTextView.originY + resultTextView.frameHeight + FrameWidth(60)];
            
            _newHeight = inputView.frame.origin.y + inputView.frame.size.height+1;
        }else if([self.Patroltem[i].type isEqualToString:@"firstTitle"]){
            UIView *inputView = [[UIView alloc]initWithFrame:CGRectMake(0, _newHeight , WIDTH_SCREEN, FrameWidth(80))];
            inputView.backgroundColor = [UIColor whiteColor];
            [thiscell addSubview:inputView];
            //title
            UILabel *inputTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(20), 0, FrameWidth(600), FrameWidth(80))];
            inputTitleLabel.text = [NSString stringWithFormat:@"%@",self.Patroltem[i].firstTitle];
            //inputTitleLabel.textColor = [UIColor grayColor];
            inputTitleLabel.font = FontSize(18);
            [inputView addSubview:inputTitleLabel];
            
            _newHeight = inputView.frame.origin.y + inputView.frame.size.height+2;
        }
    }
    //天气巡检的要求
    
    if([_specialCode isEqualToString: @"weatherInspection"]){
        UIView * demandView = [[UIView alloc]initWithFrame:CGRectMake(0, _newHeight+FrameWidth(5), WIDTH_SCREEN, FrameWidth(286))];
        demandView.backgroundColor = [UIColor whiteColor];
        [thiscell addSubview:demandView];
        
        
        UILabel * demandTitle = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(10),FrameWidth(5), WIDTH_SCREEN - FrameWidth(20), FrameWidth(50))];
        demandTitle.text = @"要求：";
        demandTitle.font = FontSize(16);
        [demandView addSubview:demandTitle];
        
        UIView *labelView = [[UIView alloc]initWithFrame:CGRectMake(FrameWidth(15),demandTitle.originY + demandTitle.frameHeight, WIDTH_SCREEN - FrameWidth(30), 0)];//
        
        [demandView addSubview:labelView];
        
        UILabel * demandLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,demandTitle.originY + demandTitle.frameHeight+FrameWidth(10), WIDTH_SCREEN - FrameWidth(30), MAXFLOAT)];//
        demandLabel.font = FontSize(15);
        demandLabel.text = @"1.机房和设备的环境整理工作，要求机房窗户关闭，防止雨水浸湿，无室外物品，台站物品规整合理。\n2.设备接地即设备的工作接地和设备的保护接地，主要检查设备接地情况，有无锈蚀、氧化、松动，设备与接地体是否接触紧合无松动。天馈系统防雷检查，主要检查天馈系统防雷系统接地是否良好。SPD状态主要检查电源SPD、信号SPD有无红色告警，状态指示有无变化等。\n3.雷雨前要对上述内容进行检查。";
        demandLabel.textColor = listGrayColor;
        demandLabel.lineBreakMode = NSLineBreakByCharWrapping;
        demandLabel.numberOfLines = 0;
        [labelView addSubview:demandLabel];
        
        NSStringDrawingOptions option = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        CGSize lblSize = [demandLabel.text boundingRectWithSize:CGSizeMake(demandLabel.frameWidth , MAXFLOAT) options:option attributes:@{NSFontAttributeName:FontSize(15)} context:nil].size;
        [demandLabel setFrameHeight:ceilf(lblSize.height)];
        [labelView setFrameHeight:ceilf(lblSize.height)];
        
        [demandView setFrameHeight:labelView.originY + labelView.frameHeight + FrameWidth(20)];
        
        _newHeight = demandView.originY + demandView.frameHeight ;
    }
    
    
    //巡查结果
    UIView *resultView = [[UIView alloc]initWithFrame:CGRectMake(0, _newHeight+FrameWidth(10), WIDTH_SCREEN, FrameWidth(286))];
    resultView.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:resultView];
    //图
    UIImageView *resultImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Patrol_icon_xcjg"]];
    [resultImgView setFrame:CGRectMake(FrameWidth(20), FrameWidth(25), FrameWidth(30), FrameWidth(30))];
    [resultView addSubview:resultImgView];
    //name
    UILabel *resultnameLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(60), 0, FrameWidth(400), FrameWidth(80))];
    resultnameLabel.text = @"巡查结果";
    resultnameLabel.font = FontSize(18);
    [resultView addSubview:resultnameLabel];
    
    self.sesultBtn = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(520), FrameWidth(20), FrameWidth(100), FrameWidth(50))];
    [self.sesultBtn setTitle:@"保存" forState:UIControlStateNormal];
    self.sesultBtn.layer.borderWidth = 1;
    self.sesultBtn.layer.borderColor = BGColor.CGColor;
    [self.sesultBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.sesultBtn.titleLabel.font  = FontSize(16);
    self.sesultBtn.tag = 100;
    [self.sesultBtn addTarget:self action:@selector(submitImage:) forControlEvents:UIControlEventTouchUpInside];
    [resultView addSubview:self.sesultBtn];
    
    
    
    
    // 达到最大限制时提示的Label
    UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(25), 0, FrameWidth(500), FrameWidth(80))];
    noticeLabel.font = FontSize(16);
    noticeLabel.textColor = UIColor.redColor;
    [resultView addSubview:noticeLabel];
    
    UIView * resultTView = [[UIView alloc]initWithFrame:CGRectMake(FrameWidth(25), FrameWidth(80), FrameWidth(595), FrameWidth(166))];
    NSString *text = @"";
    if(_recode&&![_recode[@"description"] isEqual:[NSNull null]]){
        text = _recode[@"description"];
    }
    _resultTextView = [FSTextView textView];
    [self addTViewParent:resultTView textView:_resultTextView text:text placeholder:@" 不超过200字" maxLength:200];
    
    _resultTextView.font = FontSize(16);
    resultTView.layer.borderWidth = 1;
    resultTView.layer.borderColor = BGColor.CGColor;
    [resultView addSubview:resultTView];
    _newHeight = resultView.frame.origin.y + resultView.frame.size.height+1;
    
    
    //附件上传
    UIView *uploadView = [[UIView alloc]initWithFrame:CGRectMake(0, _newHeight+FrameWidth(10), WIDTH_SCREEN, FrameWidth(350))];
    uploadView.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:uploadView];
    //图
    UIImageView *uploadImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Patrol_btn_wjsc"]];
    [uploadImgView setFrame:CGRectMake(FrameWidth(20), FrameWidth(25), FrameWidth(30), FrameWidth(30))];
    [uploadView addSubview:uploadImgView];
    //name
    UILabel *uploadnameLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(60), 0, FrameWidth(400), FrameWidth(90))];
    uploadnameLabel.text = @"附件上传";
    uploadnameLabel.font = FontSize(18);
    [uploadView addSubview:uploadnameLabel];
    
    
    [uploadView addSubview: self.imageTableView];
    [uploadView addSubview: self.videoTableView];
    
    
    
    
    
    
    
    
    _newHeight = uploadView.frame.origin.y + uploadView.frame.size.height+1;
    
    
    
    return thiscell;
    
    
}

-(void)radioSelect:(UIButton *)btn{
    
    _isInsert = YES;
    if(btn.isSelected){
        /*
         btn.selected = false;
         if(btn.tag >= 1000){
         UIButton * btn2 = [self.view viewWithTag:btn.tag - 1000];
         btn2.selected = true;
         }else{
         UIButton * btn2 = [self.view viewWithTag:btn.tag + 1000];
         btn2.selected = true;
         }
         */
    }else{
        btn.selected = true;
        if(btn.tag >= 1000){
            UIButton * btn2 = [self.view viewWithTag:btn.tag - 1000];
            btn2.selected = false;
        }else{
            UIButton * btn2 = [self.view viewWithTag:btn.tag + 1000];
            btn2.selected = false;
        }
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    _isInsert = YES;
    BOOL isOperate = YES;
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    NSInteger pointLength = existedLength - selectedLength + replaceLength;
    
    if (pointLength > 200){
        isOperate = NO;
    }
    return isOperate;
}



#pragma mark - UITableviewDelegate 代理方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 点击了第indexPath.row行Cell所做的操作
    [self.view endEditing:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(tableView == self.imageTableView&&indexPath.row > 0 && indexPath.row < self.imageList.count+1){
        if([self.imageList[indexPath.row - 1] isKindOfClass:[NSString class]]){
            [self tapImage:self.imageList[indexPath.row - 1] imageV:[UIImage alloc]];
        }else{
            [self tapImage:@"" imageV:self.imageList[indexPath.row - 1]];
        }
    }
    
    if(tableView == self.videoTableView&&indexPath.row > 0 && indexPath.row < self.videoList.count+1){
        NSURL *videourl = self.videoList[indexPath.row - 1];
        
        NSString * thisUrl = [NSString stringWithFormat:@"%@",videourl];
        NSURL *url = [NSURL URLWithString:thisUrl];
        if ([thisUrl hasPrefix:@"/img/video"]) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WebHost,thisUrl]];
        }
        AVPlayer *player = [AVPlayer playerWithURL:url];
        AVPlayerViewController *playerViewController = [AVPlayerViewController new];
        playerViewController.player = player;
        [self presentViewController:playerViewController animated:YES completion:nil];
        [playerViewController.player play];
    }
    return ;
}

-(void)startDateAction{
    [self.view endEditing:YES];
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackground = true;
    _startDatePicker = datePickManager.datePicker;
    _startDatePicker.maximumDate = [NSDate date];
    _startDatePicker.delegate = self;
    _startDatePicker.datePickerType = PGPickerViewLineTypeline;
    _startDatePicker.isHiddenMiddleText = false;
    _startDatePicker.datePickerMode = PGDatePickerModeDate;
    [self presentViewController:datePickManager animated:false completion:nil];
    
}

#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat =@"yyyy-MM-dd";
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    // 时间转为字符串
    NSString *dateStr = [formatter stringFromDate:[calendar dateFromComponents:dateComponents]];
    //NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)dateComponents.year,(long)dateComponents.month,(long)dateComponents.day];
    
    _isInsert = YES;
    if(datePicker == _startDatePicker){
        //NSLog(@"dateComponents_startDatePicker = %@", dateComponents);
        [_startDate setTitle:dateStr forState:UIControlStateNormal];
        
    }
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
    
    
    self.rightButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.rightButon.frame = CGRectMake(0,0,FrameWidth(100),FrameWidth(40));
    self.rightButon.titleLabel.font = FontSize(15);
    [self.rightButon setTitle:@"提交" forState:UIControlStateNormal];
    [self.rightButon setContentEdgeInsets:UIEdgeInsetsMake(0,  FrameWidth(17), 0, -FrameWidth(17))];
    [self.rightButon addTarget:self action:@selector(submitImage:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightfixedButton = [[UIBarButtonItem alloc]initWithCustomView:self.rightButon];
    self.navigationItem.rightBarButtonItem = rightfixedButton;
    
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
-(void)backAction {
    [self.view endEditing:YES];
    if(_isInsert == YES ){
        UIAlertController *alertContor = [UIAlertController alertControllerWithTitle:@"是否保存?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertContor addAction:[UIAlertAction actionWithTitle:@"不保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }]];
        [alertContor addAction:[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            UIButton *btn = [self.view viewWithTag:100];
            _isBack = true;
            [self submitImage:btn];
            //[self.navigationController popViewControllerAnimated:YES];
            return ;
        }]];
        [self presentViewController:alertContor animated:NO completion:nil];
        return ;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addTViewParent:(UIView *)ParentView textView:(FSTextView *)textView text:(NSString*)text placeholder:(NSString *)placeholder maxLength:(int)maxLength{
    
    textView.placeholder = placeholder;
    textView.font = FontSize(16);
    textView.canPerformAction = NO;
    textView.frame = CGRectMake(0, 0, ParentView.frameWidth, ParentView.frameHeight);
    [ParentView addSubview:textView];
    textView.text = text;
    // 限制输入最大字符数.
    textView.maxLength = maxLength;
    // 添加输入改变Block回调.
    [textView addTextDidChangeHandler:^(FSTextView *textView) {
        _isInsert = YES;
        NSLog(@"addTextDidChangeHandler   %@",textView.text);
    }];
    // 添加到达最大限制Block回调.
    [textView addTextLengthDidMaxHandler:^(FSTextView *textView) {
        NSLog(@"addTextLengthDidMaxHandler");
    }];
    // constraint
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [ParentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textView]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(textView)]];
    [ParentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textView)]];
    
}

-(void)selImgShow:(UIImageView * )imageView{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择图片来源" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * firstAction = [UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //相册选取
        [self chooseImageFromLibary];
        NSLog(@"点击相册");
    }];
    
    UIAlertAction * secondAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self takePhoto];
        NSLog(@"点击拍照");
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击取消");
    }];
    
    [alert addAction:firstAction];
    [alert addAction:secondAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
-(void)selVideoShow:(UIImageView * )imageView{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"视频" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * firstAction = [UIAlertAction actionWithTitle:@"从相册获取视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self choosevideo];
    }];
    
    UIAlertAction * secondAction = [UIAlertAction actionWithTitle:@"录制视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self openLocalCamera];
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击取消");
    }];
    
    [alert addAction:firstAction];
    [alert addAction:secondAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)takePhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)chooseImageFromLibary {
    QBImagePickerController *imagePickerController = [QBImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.mediaType = QBImagePickerMediaTypeImage;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    imagePickerController.maximumNumberOfSelection = 5 - self.imageList.count;
    
    [self presentViewController:imagePickerController animated:YES completion:NULL];
    
    /*
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
     */
}

#pragma mark - QBImagePickerControllerDelegate

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets{
    NSLog(@"Selected assets:");
    NSLog(@"%@", assets);
    _isInsert = YES;
    dispatch_group_t dispatchGroup = dispatch_group_create();
    //为了记录在选择视频的时候，是否包含大于50M的文件，如果包含 则加1；在选择图片的时候 加0
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (PHAsset *asset in assets) {
        if (asset.mediaType == PHAssetMediaTypeVideo) {
            // 从asset中获得视频
            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
            options.version = PHImageRequestOptionsVersionCurrent;
            options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
            
            PHImageManager *manager = [PHImageManager defaultManager];
            dispatch_group_enter(dispatchGroup);
            [manager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                AVURLAsset *urlAsset = (AVURLAsset *)asset;
                //判断视频大小
                NSURL *sourceURL = urlAsset.URL;
                NSData *videoData = [NSData dataWithContentsOfURL:sourceURL];
                NSLog(@"视频大小：%@", [[NSByteCountFormatter new] stringFromByteCount:videoData.length]);
                NSString *videoSize =[[NSByteCountFormatter new] stringFromByteCount:videoData.length];
                int fileSize = [videoSize intValue];
                if (fileSize > 50) {
                    [mutableArray addObject:@"1"];
                }
                dispatch_group_leave(dispatchGroup);
            }];
            
        }else{
            
            [mutableArray addObject:@"0"];
            // 从asset中获得图片
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                dispatch_async(dispatch_get_main_queue(), ^{//通知主线程刷新
                    [self.imageList insertObject:result atIndex:0];
                    [self.imageTableView reloadData];
                });
                [self dismissViewControllerAnimated:YES completion:NULL];
            }];
        }
    }
    
    
    /**
    针对选择视频的做法
     包含大于50兆的视频则此次选择的视频失效
     */
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
        if ([mutableArray containsObject:@"1"]) {
            [FrameBaseRequest showMessage:@"只能上传50M以内的视频"];
            [self dismissViewControllerAnimated:YES completion:NULL];
        } else {
            for (PHAsset *asset in assets) {
                if (asset.mediaType == PHAssetMediaTypeVideo) {
                    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
                    options.version = PHImageRequestOptionsVersionCurrent;
                    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
                    PHImageManager *manager = [PHImageManager defaultManager];
                    [manager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                        AVURLAsset *urlAsset = (AVURLAsset *)asset;
                        NSURL *sourceURL = urlAsset.URL;
                        dispatch_async(dispatch_get_main_queue(), ^{//通知主线程刷新
                            [self.videoList insertObject:sourceURL atIndex:0];
                            [self.videoTableView reloadData];
                        });
                        [self dismissViewControllerAnimated:YES completion:NULL];
                    }];
                }
            }
        }
    });
    
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    NSLog(@"Canceled.");
    [self dismissViewControllerAnimated:YES completion:NULL];
}



- (void)choosevideo {
    QBImagePickerController *imagePickerController = [QBImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.mediaType = QBImagePickerMediaTypeVideo;
    //QBImagePickerMediaTypeImage,
    //QBImagePickerMediaTypeVideo
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    imagePickerController.maximumNumberOfSelection = 3 - self.videoList.count;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
    /*
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
    NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];//Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
    ipc.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];//设置媒体类型为public.movie
    [self presentViewController:ipc animated:YES completion:nil];
    ipc.delegate = self;//设置委托
     */
}

- (void)openLocalCamera{
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //录制视频时长，默认10s
    picker.videoMaximumDuration = 20;
    
    //相机类型（拍照、录像...）这里表示我们打开相机支持的是相机和录像两个功能。
    picker.mediaTypes = @[(NSString *)kUTTypeMovie];
    picker.delegate = self;
    picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    //设置摄像头模式（拍照，录制视频）为相机模式
    //    UIImagePickerControllerCameraCaptureModeVideo  这个是设置为视频模式
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    [self presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *mediaType = [NSString stringWithFormat:@"%@",info[@"UIImagePickerControllerMediaType"]];
    if([mediaType isEqualToString:@"public.movie"]){
        
        //如果是视频资源patrol_video
        NSURL *sourceURL = info[UIImagePickerControllerMediaURL];
        NSLog(@"%@",[NSString stringWithFormat:@"%@ s", [sourceURL path]]);
        //self.videoImage.image = [self thumbnailImageForVideo:sourceURL atTime:1];
        [self.videoList insertObject:sourceURL atIndex:0];
        [self.videoTableView reloadData];
    }
    
    if([mediaType isEqualToString:@"public.image"]){
        if (picker.allowsEditing) {
            UIImage *image = [self processImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
            GitImage = image;
            [self.imageList insertObject:GitImage atIndex:0];
            [self.imageTableView reloadData];
            [picker dismissViewControllerAnimated:YES completion:nil];
        } else {
            UIImage *image = [self processImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
            GitImage = image;
            [self.imageList insertObject:GitImage atIndex:0];
            [self.imageTableView reloadData];
            [picker dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

//如果要上传到服务器，最好在压缩一下UIImageJPEGRepresentation(image, 0-1)
- (UIImage *)processImage:(UIImage *)image {
    CGFloat hFactor = image.size.width / self.view.frameWidth;
    CGFloat wFactor = image.size.height / self.view.frameHeight;
    CGFloat factor = fmaxf(hFactor, wFactor);
    CGFloat newW = image.size.width / factor;
    CGFloat newH = image.size.height / factor;
    CGSize newSize = CGSizeMake(newW, newH);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newW, newH)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//删除某元素
-(void)selImgDelete:(UITapGestureRecognizer *)sender{
    UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
    
    // 获取所在的cell
    UITableViewCell *cell = (UITableViewCell *)[tapRecognizer.view superview];
    // 获取cell的indexPath
    NSIndexPath *indexPath = [self.imageTableView indexPathForCell:cell];
    // 打印 --- test
    NSLog(@"点击的是第%ld行",indexPath.row);
    if(indexPath.row > 0&& indexPath.row <self.imageList.count+1){
        [self.imageList removeObjectAtIndex:indexPath.row - 1];
        [self.imageTableView reloadData];
        
    }
}

-(void)selVideoDelete:(UITapGestureRecognizer *)sender{
    UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
    
    // 获取所在的cell
    UITableViewCell *cell = (UITableViewCell *)[tapRecognizer.view superview];
    // 获取cell的indexPath
    NSIndexPath *indexPath = [self.videoTableView indexPathForCell:cell];
    // 打印 --- test
    NSLog(@"点击的是第%ld行",indexPath.row);
    if(indexPath.row > 0&& indexPath.row <self.videoList.count+1){
        [self.videoList removeObjectAtIndex:indexPath.row - 1];
        [self.videoTableView reloadData];
        
    }
}
//提交


-(void)submitAction:(UIButton *)btn{
    
    [self.view endEditing:YES];
    if(_submitNum == 1){return ;}
    _submitNum = 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = _id;
    params[@"stationCode"] = _stationCode;
    params[@"stationName"] = _stationName;
    params[@"typeCode"] = _type_code;
    params[@"typeName"] = _patrolTitle;
    if([_PatrolManText.text isEqualToString:@""]||[_PatrolManText.text isEqual:[NSNull null]]){
        self.rightButon.enabled = YES;
        self.sesultBtn.enabled = YES;
        [FrameBaseRequest showMessage:@"输入巡查人姓名"];
        _submitNum = 0;
        return ;
    }
    if([_resultTextView.formatText isEqualToString:@""]||[_resultTextView.formatText isEqual:[NSNull null]]){
        self.rightButon.enabled = YES;
        self.sesultBtn.enabled = YES;
        [FrameBaseRequest showMessage:@"输入巡查结果"];
        _submitNum = 0;
        return ;
    }
    if([_startDate.titleLabel.text isEqualToString:@"请选择日期"]){
        self.rightButon.enabled = YES;
        self.sesultBtn.enabled = YES;
        [FrameBaseRequest showMessage:@"请选择日期"];
        _submitNum = 0;
        return ;
    }
    if(btn.tag == 100){
        params[@"status"] = @"0";
    }else{
        params[@"status"] = @"1";
    }
    //FSTextView *resultTextView = [self.view viewWithTag:2000 ];
    params[@"description"] = _resultTextView.formatText;
    params[@"patrolName"] = _PatrolManText.text;
    _start_time = ![_startDate.titleLabel.text isEqualToString:@"请选择日期"]?_startDate.titleLabel.text:nil;
    params[@"patrolTime"] = _start_time;
    
    NSString *result = @"{";
    for (int i=0; i<self.Patroltem.count; ++i) {
        if([self.Patroltem[i].type isEqualToString:@"radio"]){
            UIButton * radioBtn = [self.view viewWithTag:i+1];
            UIButton * radioBtn2 = [self.view viewWithTag:radioBtn.tag + 1000];
            if(radioBtn.isSelected){
                result = [NSString stringWithFormat:@"%@\"%@\":\"%@\",",result,self.Patroltem[i].id,radioBtn.currentTitle];
                //result[self.Patroltem[i].id] = radioBtn.currentTitle;
            }else if(radioBtn2.isSelected){
                result = [NSString stringWithFormat:@"%@\"%@\":\"%@\",",result,self.Patroltem[i].id,radioBtn2.currentTitle];
                //result[self.Patroltem[i].id] = radioBtn2.currentTitle;
            }
        }
        
        if([self.Patroltem[i].type isEqualToString:@"input"]){
            UITextField * inputField = [self.view viewWithTag:i+1];
            inputField.delegate = self;
            
            result = [NSString stringWithFormat:@"%@\"%@\":\"%@\",",result,self.Patroltem[i].id,inputField.text];
        }
        if([self.Patroltem[i].type isEqualToString:@"textarea"]){
            
            FSTextView * textareaView = [self.view viewWithTag:i+1];
            NSString * textareaViewtext = @"";
            if(textareaView.formatText != nil &&![textareaView.formatText isEqual:[NSNull null]]){
                textareaViewtext = textareaView.formatText;
            }
            result = [NSString stringWithFormat:@"%@\"%@\":\"%@\",",result,self.Patroltem[i].id,textareaViewtext];
            //result[self.Patroltem[i].id] = textareaView.text;
        }
        
    }
    if([result length] > 1){
        params[@"result"] = [NSString stringWithFormat:@"%@}",[result substringToIndex:[result length]-1]];
    }else{
        params[@"result"] = [NSString stringWithFormat:@"%@}",result];
    }
    
    if(self.mediaUrlList.count > 0){
        params[@"atcPatrolMediaList"] = self.mediaUrlList;
    }
    
    
    NSString *FrameRequestURL = [WebHost stringByAppendingString:@"/api/saveAtcPatrolRecode"];
    
    [FrameBaseRequest putWithUrl:FrameRequestURL param:params success:^(id result) {
        _submitNum = 0;
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            self.rightButon.enabled = YES;
            self.sesultBtn.enabled = YES;
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        _isInsert = NO;
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
        self.rightButon.enabled = YES;
        self.sesultBtn.enabled = YES;
        
    } failure:^(NSError *error)  {
        self.rightButon.enabled = YES;
        self.sesultBtn.enabled = YES;
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
    
    
}
-(void)submitImage:(UIButton *)btn{
    self.rightButon.enabled = NO;
    self.sesultBtn.enabled = NO;
    self.mediaUrlList = [NSMutableArray new];
    //请求地址
    NSString *FrameRequestURL = [WebHost stringByAppendingString:@"/upload/atcPatrolRecode"];
    dispatch_group_t dispatch = dispatch_group_create();
    if(self.imageList.count  >0 ){
        
        //for (UIImage *photo in self.imageList) {
        for (int i = 0; i< self.imageList.count; i++) {
            dispatch_group_enter(dispatch);
            
            if([self.imageList[i] isKindOfClass:[NSString class]]){
                dispatch_group_leave(dispatch);
                NSMutableDictionary *mediaInfo = [NSMutableDictionary dictionary];
                mediaInfo[@"patrolRecordId"] = _patrolRecordId;
                mediaInfo[@"url"] = self.imageList[i];
                [self.mediaUrlList insertObject:mediaInfo atIndex:0];
                //[self.mediaUrlList addObject:mediaInfo];
                continue;
            }
            UIImage * photo = self.imageList[i];
            
            //压缩
            NSData * datapng = UIImageJPEGRepresentation(photo, 1);
            
            //请求设置
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            
            manager.requestSerializer.HTTPShouldHandleCookies = YES;
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",  @"image/jpeg",  @"image/png",  nil];
            //[NSSet setWithObjects:@"application/json",  @"text/html", @"image/jpeg",  @"image/png", @"application/octet-stream", @"text/json",@"multipart/form-data",@"application/x-www-form-urlencoded", nil];
            //
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            
            [manager POST:FrameRequestURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
                [formData appendPartWithFileData:datapng    name:@"file"  fileName:@"file.JPG"  mimeType:@"image/jpeg"];
                
            } progress:^(NSProgress *_Nonnull uploadProgress) {
                //NSLog(@"请求中：%@",uploadProgress);
                //打印下上传进度
            } success:^(NSURLSessionDataTask *_Nonnull task,id _Nullable responseObject) {
                NSLog(@"responseObject    %@",responseObject);
                if(![[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"errCode"]]  isEqual: @"0"]){
                    NSLog(@"请求失败%@",[responseObject objectForKey:@"errMsg"]);
                    [FrameBaseRequest showMessage:[responseObject objectForKey:@"errMsg"]];
                    dispatch_group_leave(dispatch);
                    return ;
                }
                
                NSMutableDictionary *mediaInfo = [NSMutableDictionary dictionary];
                mediaInfo[@"patrolRecordId"] = _patrolRecordId;
                mediaInfo[@"url"] = responseObject[@"value"][@"url"];
                self.imageList[i] = mediaInfo[@"url"];
                [self.mediaUrlList insertObject:mediaInfo atIndex:0];
                [self.imageTableView reloadData];
                dispatch_group_leave(dispatch);
                
            } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                NSLog(@"error ：%@",error);
                [FrameBaseRequest showMessage:@"网络链接失败"];
                dispatch_group_leave(dispatch);
                //上传失败
            }];
        }
    }
    dispatch_group_notify(dispatch, dispatch_get_main_queue(),^(){
        [self submitVideo:btn];
    });
    
    
}
-(void)submitVideo:(UIButton *)btn{
    //请求地址
    NSString *FrameRequestURL = [WebHost stringByAppendingString:@"/upload/video"];
    
    dispatch_group_t dispatch = dispatch_group_create();
    if(self.videoList.count > 0){
        //for (NSURL *videourl in self.videoList) {
        for (int i = 0; i< self.videoList.count; i++) {
            dispatch_group_enter(dispatch);
            
            NSURL *videourl = self.videoList[i];
            
            NSString * thisUrl = [NSString stringWithFormat:@"%@",videourl];
            if ([thisUrl hasPrefix:@"/img/video"]) {
                NSMutableDictionary *mediaInfo = [NSMutableDictionary dictionary];
                mediaInfo[@"patrolRecordId"] = _patrolRecordId;
                mediaInfo[@"url"] = thisUrl;
                [self.mediaUrlList insertObject:mediaInfo atIndex:0];
                dispatch_group_leave(dispatch);
                continue;
            }
            //请求设置
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            
            
            manager.requestSerializer.HTTPShouldHandleCookies = YES;
            [manager.requestSerializer setValue:@"form/data" forHTTPHeaderField:@"Content-Type"];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            
            
            [manager POST:FrameRequestURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
                
                NSError *error;
                [formData appendPartWithFileURL:videourl name:@"file" fileName:@"file.mp4" mimeType:@"video/mp4" error:&error];
                //[formData appendPartWithFileData:datapng  name:@"file" fileName:@"file.mp4"  mimeType:@"video/mp4"];
                
            } progress:^(NSProgress *_Nonnull uploadProgress) {
                //NSLog(@"请求中：%@",uploadProgress);
                //打印下上传进度
            } success:^(NSURLSessionDataTask *_Nonnull task,id _Nullable responseObject) {
                NSLog(@"responseObject    %@",responseObject);
                if(![[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"errCode"]]  isEqual: @"0"]){
                    NSLog(@"请求失败%@",[responseObject objectForKey:@"errMsg"]);
                    dispatch_group_leave(dispatch);
                    [FrameBaseRequest showMessage:[responseObject objectForKey:@"errMsg"]];
                    return ;
                }
                
                
                NSMutableDictionary *mediaInfo = [NSMutableDictionary dictionary];
                mediaInfo[@"patrolRecordId"] = _patrolRecordId;
                mediaInfo[@"url"] = responseObject[@"value"][@"url"];
                self.videoList[i] = mediaInfo[@"url"];
                [self.mediaUrlList insertObject:mediaInfo atIndex:0];
                [self.videoTableView reloadData];
                dispatch_group_leave(dispatch);
                
            } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                NSLog(@"error ：%@",error);
                dispatch_group_leave(dispatch);
                [FrameBaseRequest showMessage:@"网络链接失败"];
                //上传失败
            }];
        }
    }
    dispatch_group_notify(dispatch, dispatch_get_main_queue(),^(){
        [self submitAction:btn];
    });
}
//预览图片和视频

- (void)tapImage:(NSString *)imageName imageV:(UIImage *)imageV{
    
    UIImage *image = [[UIImage alloc] init];
    if([imageName isEqualToString:@""]){
        image = imageV;
    }else{
        image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WebHost,imageName]]]];
    }
    PhotoBrowseViewController* controller = [[PhotoBrowseViewController alloc] initWithImage:image lastPageFrame:CGRectMake(0, 0,WIDTH_SCREEN, HEIGHT_SCREEN)];
    controller.modalPresentationStyle = UIModalPresentationOverFullScreen;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:controller animated:true completion:nil];
//    WSLPictureBrowseView * browseView = [[WSLPictureBrowseView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN)];
//    browseView.backgroundColor = [UIColor blackColor];
//    browseView.imgArray = [NSMutableArray arrayWithArray:@[image]];
//    browseView.viewController = self;
//    [[UIApplication sharedApplication].keyWindow addSubview:browseView];
    
    
    //UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    //[bgView addGestureRecognizer:tap];
}

//隐藏
- (void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    [UIView animateWithDuration:0.3 animations:^{
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}


@end

