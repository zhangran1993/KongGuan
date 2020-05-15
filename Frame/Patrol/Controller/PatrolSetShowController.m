//
//  PatrolSetShowController.m
//  Frame
//
//  Created by hibayWill on 2018/3/27.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "PatrolSetShowController.h"
#import "Patroltems.h"
#import "MediaModel.h"

#import "FrameBaseRequest.h"
#import <UIImageView+WebCache.h>

#import <MJExtension.h>

#import <AVKit/AVKit.h>
#import "WSLPictureBrowseView.h"
#import <AVFoundation/AVFoundation.h>
#import "PhotoBrowseViewController.h"
@interface PatrolSetShowController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray<Patroltems *> * Patroltem;

@property NSUInteger newHeight;
@property (nonatomic,copy) NSString* start_time;
@property (nonatomic,copy) NSString* patrolTitle;
@property (nonatomic,copy) NSDictionary* recode;

@property (nonatomic, assign) CGFloat keyBoardHeight;   //键盘高度
@property (nonatomic, assign) CGRect originalFrame;    //记录视图的初始坐标
@property (nonatomic,strong) UITextView *resultTextView;   //当前输入框



@property   int submitNum;

@property(nonatomic) UIView* bottomView;
@property(nonatomic) UITableView *tableview;

@property(nonatomic) UITableView *imageTableView;
@property(nonatomic) UITableView *videoTableView;
@property(nonatomic) NSMutableArray *imageList;
@property(nonatomic) NSMutableArray *videoList;
@property(nonatomic, strong) NSMutableArray *imageAraay;

@end

@implementation PatrolSetShowController

#pragma mark - 全局常量




#pragma mark - life cycle 生命周期方法

- (void)viewDidLoad {
    [self backBtn];
    [super viewDidLoad];
    _patrolTitle = @"例行巡查";
    if([_type_code isEqualToString: @"comprehensive"] ){//routine////comprehensive//special
        _patrolTitle = @"全面巡查";
    }
    if([_type_code isEqualToString: @"special"] ){//routine////comprehensive//special
        _patrolTitle = @"特殊巡查";
    }
    self.imageList = [[NSMutableArray alloc]init];
    self.videoList = [[NSMutableArray alloc]init];
    self.imageAraay = [NSMutableArray array];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, View_Width, View_Height-ZNAVViewH)];
    self.tableview.delegate =self;
    self.tableview.dataSource =self;
    //[self.tableview registerClass:[UITableViewCell class]forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.tableview];
    
    
    self.tableview.delegate =self;
    self.tableview.dataSource =self;
    self.tableview.separatorStyle = NO;
    
    
    
    //图片上传的
    self.imageTableView = [[UITableView alloc]initWithFrame:CGRectMake((WIDTH_SCREEN - FrameWidth(130))/2,(FrameWidth(130) - WIDTH_SCREEN)/2 + FrameWidth(80), FrameWidth(130), WIDTH_SCREEN) style:UITableViewStylePlain];
    self.imageTableView.dataSource=self;
    self.imageTableView.delegate=self;
    //对TableView要做的设置
    self.imageTableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
    self.imageTableView.showsVerticalScrollIndicator=NO;
    self.imageTableView.separatorStyle =NO;
    //视频上传的
    self.videoTableView = [[UITableView alloc]initWithFrame:CGRectMake((WIDTH_SCREEN - FrameWidth(130))/2,(FrameWidth(130) - WIDTH_SCREEN)/2 + FrameWidth(210), FrameWidth(130), WIDTH_SCREEN) style:UITableViewStylePlain];
    self.videoTableView.dataSource=self;
    self.videoTableView.delegate=self;
    //对TableView要做的设置
    self.videoTableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
    self.videoTableView.showsVerticalScrollIndicator=NO;
    self.videoTableView.separatorStyle =NO;
    [self.view addSubview:self.tableview];
    
    [self setupTable];
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"PatrolSetController shopdetailviewWillAppear");
    [self registerForKeyboardNotifications];//注册键盘通知
    
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"PatrolSetShowController viewWillDisappear");
    [[NSNotificationCenter defaultCenter] removeObserver:self];//去除键盘通知
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    // NSLog(@"viewDidAppear");
}
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"PatrolSetShowController viewDidDisappear");
}
-(void)viewWillLayoutSubviews{
    // NSLog(@"viewWillLayoutSubviews");
}
//注册
- (void)registerForKeyboardNotifications{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //键盘消失时
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    //self.currentTextView = textView;
    // self.originalFrame = self.view.frame;
}
- (void)keyboardWillShow:(NSNotification*)notification{
    NSDictionary* info = [notification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    _keyBoardHeight = kbSize.height;
    
    //设置视图移动的位移
    if(self.tableview.frame.size.height ==self.view.bounds.size.height){
        
        self.tableview.frame = CGRectMake(self.tableview.frame.origin.x, 0, self.tableview.frame.size.width, self.tableview.frame.size.height-_keyBoardHeight);
    }
    
}

- (void)keyboardWillHide:(NSNotification *)notification{//返回
    self.tableview.frame = CGRectMake(self.tableview.frame.origin.x, 0, self.tableview.frame.size.width, self.view.bounds.size.height);
}


#pragma mark - private methods 私有方法

- (void)setupTable{
    //self.view.backgroundColor = [UIColor whiteColor];
    //去除分割线
    //self.tableview.separatorStyle =NO;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"station_code"] = _stationCode;
    params[@"type"] = @"0";
    params[@"id"] = _id;
    params[@"type_code"] = _type_code;
    
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:@"/api/atcPatrolInfo"];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        
        /*
        self.Patroltem = [[Patroltems class]  mj_objectArrayWithKeyValuesArray: result[@"value"][@"infoList"]];
        _recode = [result[@"value"][@"recode"] copy];
         */
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
                    [self.videoList insertObject:mediaList[i].url atIndex:0];
                    //[self.videoList addObject:mediaList[i].url];
                }else{
                    //[self.imageList addObject:mediaList[i].url];
                    [self.imageList insertObject:mediaList[i].url atIndex:0];
                    UIImageView *tapImage = [UIImageView new];
                    //[self.view addSubview:tapImage];
                    [tapImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WebHost,mediaList[i].url]]];
                    [self.imageAraay insertObject:tapImage atIndex:0];//addObject:tapImage];
                    //[tapImage removeFromSuperview];
                }
                
            }
        }
        
        if(!_stationName){
            _stationName = [CommonExtension isEmptyWithString:_recode[@"stationName"]]?@" ": _recode[@"stationName"];
            
        }
        self.navigationItem.title = @"巡查查看";
        
        [self.videoTableView reloadData];
        [self.imageTableView reloadData];
        [self.tableview reloadData];
        
    } failure:^(NSURLSessionDataTask *error)  {
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
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.imageTableView){
        return FrameWidth(130);
    }else if(tableView == self.videoTableView){
        return FrameWidth(130);
    }
    
    return _newHeight +FrameWidth(30);
}

#pragma mark - UITableviewDatasource 数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.imageTableView){
        return self.imageList.count+1;
    }else if(tableView == self.videoTableView){
        return self.videoList.count+1;
        
    }
    if(_stationName){return 1;}
    return 0;
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
        }else{
            
            UIImageView * addImgView = [[UIImageView alloc]initWithFrame: CGRectMake(FrameWidth(15), FrameWidth(15), FrameWidth(100), FrameWidth(100))];
            addImgView.contentMode = 1;
            
            if([self.imageList[indexPath.row-1] isKindOfClass:[NSString class]]){
                [addImgView sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",WebHost,self.imageList[indexPath.row-1]]] ];
            }else{
                addImgView.image = self.imageList[indexPath.row-1];
            }
            [cell addSubview:addImgView];
        }
        cell.transform = CGAffineTransformMakeRotation(M_PI/2);
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
        }else{
            UIImageView * addImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"patrol_video"]];
            addImgView.frame = CGRectMake(FrameWidth(15), FrameWidth(15), FrameWidth(100), FrameWidth(100));
            [cell addSubview:addImgView];
            
        }
        cell.transform = CGAffineTransformMakeRotation(M_PI/2);
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
    basicnameLabel.font = FontSize(18);
    basicnameLabel.text = @"基本信息";
    [basicView addSubview:basicnameLabel];
    
    //台站名称
    UIView *stationView = [[UIView alloc]initWithFrame:CGRectMake(0, basicView.frame.origin.y + basicView.frame.size.height+1, WIDTH_SCREEN, FrameWidth(72))];
    stationView.backgroundColor = [UIColor whiteColor];
    [thiscell addSubview:stationView];
    //title
    UILabel *stationNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(22),0, FrameWidth(300), FrameWidth(72))];
    stationNameLabel.font = FontSize(17);
    stationNameLabel.textColor = [UIColor grayColor];
    stationNameLabel.text = @"台站名称";
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
    UILabel * PatrolManText = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(160), 0, FrameWidth(450), FrameWidth(72))];
    if(_recode&&![_recode[@"patrolName"] isEqual:[NSNull null]]){
        PatrolManText.text = _recode[@"patrolName"];
    }
    PatrolManText.font = FontSize(17);
    PatrolManText.textAlignment = NSTextAlignmentRight;
    PatrolManText.textColor = [UIColor grayColor];
    [PatrolManView addSubview:PatrolManText];
    
    /*
     UILabel *PatrolManLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(450), 0, FrameWidth(160), FrameWidth(72))];
     PatrolManLabel.text = @"例行巡查";
     PatrolManLabel.font = FontSize(16);
     PatrolManLabel.textColor = [UIColor grayColor];
     [PatrolManView addSubview:PatrolManLabel];
     */
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
    UIButton * _startDate = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(350), 0, FrameWidth(260), FrameWidth(72))];
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
        if([self.Patroltem[i].type isEqualToString:@"firstTitle"]){
            UIView *inputView = [[UIView alloc]initWithFrame:CGRectMake(0, _newHeight , WIDTH_SCREEN, FrameWidth(80))];
            inputView.backgroundColor = [UIColor whiteColor];
            [thiscell addSubview:inputView];
            //title
            UILabel *inputTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(20), 0, FrameWidth(600), FrameWidth(80))];
            inputTitleLabel.text = [NSString stringWithFormat:@"%@",self.Patroltem[i].firstTitle];
            //inputTitleLabel.textColor = [UIColor grayColor];
            inputTitleLabel.font = FontSize(17);
            [inputView addSubview:inputTitleLabel];
            
            _newHeight = inputView.frame.origin.y + inputView.frame.size.height+3;
        }else{
            
            UIView *inputView = [[UIView alloc]initWithFrame:CGRectMake(0, _newHeight , WIDTH_SCREEN, FrameWidth(164))];
            inputView.backgroundColor = [UIColor whiteColor];
            [thiscell addSubview:inputView];
            //title
            UILabel *inputTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(20), FrameWidth(10), FrameWidth(600), FrameWidth(60))];
            inputTitleLabel.numberOfLines = 0;
            inputTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            inputTitleLabel.text = self.Patroltem[i].title;
            inputTitleLabel.textColor = [UIColor grayColor];
            inputTitleLabel.font = FontSize(16);
            //自适应文字高度
            CGSize titleSize = [inputTitleLabel sizeThatFits:CGSizeMake(FrameWidth(595), MAXFLOAT)];
            inputTitleLabel.frame = CGRectMake(FrameWidth(20), FrameWidth(10), FrameWidth(600), titleSize.height);
            
            [inputView addSubview:inputTitleLabel];
            
            
            UILabel * inputTextfield = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(22), FrameWidth(80), FrameWidth(595), FrameWidth(50))];
            inputTextfield.textColor = [UIColor grayColor];
            inputTextfield.font = FontSize(16);
            inputTextfield.numberOfLines = 0;
            inputTextfield.lineBreakMode = NSLineBreakByWordWrapping;
            
            NSLog(@"tagValuetagValuetagValue   %@",self.Patroltem[i].tagValue);
            if(self.Patroltem[i]&&![self.Patroltem[i].tagValue isEqual:[NSNull null]]){
                if(self.Patroltem[i].tagValue){
                    inputTextfield.text = self.Patroltem[i].tagValue;
                }
            }
            
            //自适应文字高度
            CGSize inputSize = [inputTextfield sizeThatFits:CGSizeMake(FrameWidth(595), MAXFLOAT)];
            
            //NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            
            //sizeWithFont:inputTextfield.font constrainedToSize:CGSizeMake(FrameWidth(595), MAXFLOAT)];
            inputTextfield.frame = CGRectMake(FrameWidth(22),FrameWidth(22)+ inputTitleLabel.frame.origin.y  +inputTitleLabel.frame.size.height, FrameWidth(595), FrameWidth(22)+inputSize.height);
            
            [inputView addSubview:inputTextfield];
            inputView.frame = CGRectMake(0, _newHeight , WIDTH_SCREEN,inputTextfield.frame.size.height +inputTextfield.frame.origin.y);
            //FrameWidth(114) + inputSize.height);
            
            
            _newHeight = inputView.frame.origin.y + inputView.frame.size.height+2 ;
        }
        
        
        
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
    
    
    
    _resultTextView = [[UITextView alloc]initWithFrame:CGRectMake(FrameWidth(25), FrameWidth(80), FrameWidth(595), FrameWidth(166))];
    
    _resultTextView.layer.borderWidth = 1;
    _resultTextView.layer.borderColor = BGColor.CGColor;
    _resultTextView.textColor = listGrayColor;
    if(_recode&&![_recode[@"description"] isEqual:[NSNull null]]){
        _resultTextView.text = _recode[@"description"];
    }
    _resultTextView.font = FontSize(16);
    [_resultTextView setEditable:NO];
    [resultView addSubview:_resultTextView];
    
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






#pragma mark - UITableviewDelegate 代理方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 点击了第indexPath.row行Cell所做的操作
    [self.view endEditing:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了第%ld行Cell所做的操作",(long)indexPath.row);
    
    if(tableView == self.imageTableView&&indexPath.row > 0 && indexPath.row < self.imageList.count+1){
        if([self.imageList[indexPath.row - 1] isKindOfClass:[NSString class]]){
            UIImageView *imageView = self.imageAraay[indexPath.row - 1];
            [self tapImage:@"" imageV:imageView.image];
        }else{
            UIImageView *imageView = self.imageAraay[indexPath.row - 1];
            [self tapImage:@"" imageV:imageView.image];
        }
    }
    if(tableView == self.videoTableView&&indexPath.row > 0 && indexPath.row < self.videoList.count+1){
        NSURL *videourl = self.videoList[indexPath.row - 1];
        
        NSString * thisUrl = [NSString stringWithFormat:@"%@",videourl];
        NSURL *url = [NSURL fileURLWithPath:thisUrl];
        if ([thisUrl hasPrefix:@"/img/video"]) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WebHost,thisUrl]];
        }
        NSLog(@"urlurlurlurlurl%@",url);
        AVPlayer *player = [AVPlayer playerWithURL:url];
        AVPlayerViewController *playerViewController = [AVPlayerViewController new];
        playerViewController.player = player;
        [self presentViewController:playerViewController animated:YES completion:nil];
        [playerViewController.player play];
    }
    return ;
    
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
    [self.navigationController popViewControllerAnimated:YES];
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

