//
//  AlarmMachineListController.m
//  Frame
//
//  Created by hibayWill on 2018/4/4.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "AlarmMachineListController.h"
#import "AlarmItems.h"
#import "AlarmListCell.h"
#import "PGDatePickManager.h"
#import "AlarmDetailController.h"
#import "AlarmMachineDetailController.h"



#import "FrameBaseRequest.h"
#import <MJExtension.h>

@interface AlarmMachineListController ()<UITableViewDelegate,UITableViewDataSource,PGDatePickerDelegate,UITextFieldDelegate>

@property NSString* type;
@property(strong,nonatomic) UITextField *  searchText;

/** 存放数据模型的数组 */
@property(strong,nonatomic)UILabel *dateLabel;
@property(strong,nonatomic)UIButton *leftBtn;
@property(strong,nonatomic)UIButton *rightBtn;
@property(strong,nonatomic)UILabel *leftLabel;
@property(strong,nonatomic)UILabel *rightLabel;
@property(strong,nonatomic)UIButton *statusBtn;
@property(strong,nonatomic)UIButton *endDate;
@property(strong,nonatomic)UIButton *startDate;

@property NSDate *NstartDate;
@property NSDate *NendDate;
@property  NSString* Name;

@property(strong,nonatomic)UITableView *filterTabView;
@property(strong,nonatomic)PGDatePicker *startDatePicker;
@property(strong,nonatomic)PGDatePicker *endDatePicker;
@property(strong,nonatomic)UIViewController *vc;
@property NSString* stationSelect;
@property NSString* statusSelect;
@property NSUInteger newHeight1;
@property NSUInteger newHeight4;
@property NSMutableArray *ALLtags;
@property NSMutableArray *typetags;



@property (strong, nonatomic) NSMutableArray<AlarmItems *> * AlarmItem;
@property (strong, nonatomic) NSMutableArray<AlarmItems *> * SearchItem;
@property (strong, nonatomic) NSMutableArray<AlarmItems *>  * atStatusItem;
@property (strong, nonatomic) NSMutableArray * atMOdelItem;
@property(strong,nonatomic)UITableView *onetableview;

/** 请求管理者 */
//@property (nonatomic,weak) AFHTTPSessionManager * manager;
/** 用于加载下一页的参数(页码) */
@property (nonatomic,assign) NSInteger pageNo;
@property (nonatomic,assign) NSInteger viewNum;
@property (nonatomic,assign) NSInteger chooseDay;
@end

@implementation AlarmMachineListController

#pragma mark - 全局常量
//
static NSString * const FrameCellID = @"AlarmListCell";


#pragma mark - life cycle 生命周期方法

- (void)viewDidLoad {
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    self.statusBtn =  [UIButton new];
    [self backBtn];
    self.navigationItem.title = @"备件列表";
    self.view.backgroundColor =  [UIColor  colorWithPatternImage:[UIImage imageNamed:@"personal_gray_bg"]] ;
    UIView * oneView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, FrameWidth(95))];
    oneView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:oneView];
    
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(FrameWidth(25), FrameWidth(13),FrameWidth(596), FrameWidth(70))];
    searchView.backgroundColor = BGColor;
    searchView.layer.borderColor = [UIColor colorWithWhite:100/255 alpha:0.1].CGColor ;
    searchView.layer.borderWidth = 1;
    searchView.layer.cornerRadius = FrameWidth(35);
    [oneView addSubview:searchView];
    
    
    _searchText = [[UITextField alloc]initWithFrame:CGRectMake(FrameWidth(20), 0,FrameWidth(500), FrameWidth(70))];
    _searchText.delegate = self;
    _searchText.backgroundColor = BGColor;
    _searchText.font = FontSize(17);
    _searchText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索备件" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];//.placeholder = @"搜索备件";
    [_searchText addTarget:self  action:@selector(valueChanged)  forControlEvents:UIControlEventAllEditingEvents];
    //searchText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //searchText.layer.borderWidth = 1;
    [searchView addSubview:_searchText];
    UIImageView * searechImg = [[UIImageView alloc]initWithFrame:CGRectMake(FrameWidth(525), FrameWidth(9),FrameWidth(50), FrameWidth(50))];
    searechImg.image = [UIImage imageNamed:@"alarm_search"];
    [searchView addSubview:searechImg];
    
    
    UIView * twoView =  [[UIView alloc] initWithFrame:CGRectMake(0, oneView.frame.origin.y+oneView.frame.size.height+FrameWidth(10), WIDTH_SCREEN, FrameWidth(86))];
    twoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:twoView];
    
    //@{@"code":@"编号",@"num":@"备件数量",@"name":@"备件名称",@"status":@"状态",@"model":@"型号"}
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(10), 0, FrameWidth(200), FrameWidth(86))];
    typeLabel.text = @"备件名称";
    typeLabel.font = FontSize(17);
    [twoView addSubview:typeLabel];
    
    //编号
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(260), 0, FrameWidth(210), FrameWidth(86))];
    numLabel.text =  @"编号";
    numLabel.font = FontSize(17);
    [twoView addSubview:numLabel];
    //状态
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(310), 0, FrameWidth(220), FrameWidth(86))];
    statusLabel.text =  @"状态";
    statusLabel.font = FontSize(17);
    statusLabel.textAlignment = NSTextAlignmentCenter;
    [twoView addSubview:statusLabel];
    /*
     UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(130), 0, FrameWidth(200), FrameWidth(86))];
     numLabel.text = @"编号";
     numLabel.textAlignment = NSTextAlignmentRight;
     [twoView addSubview:numLabel];
     
     UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(230), 0, FrameWidth(200), FrameWidth(86))];
     statusLabel.text = @"状态";
     statusLabel.textAlignment = NSTextAlignmentCenter;
     [twoView addSubview:statusLabel];
     */
    UILabel *modelLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(500), 0, FrameWidth(130), FrameWidth(86))];
    modelLabel.text = @"型号";
    modelLabel.font = FontSize(17);
    modelLabel.textAlignment = NSTextAlignmentCenter;
    [twoView addSubview:modelLabel];
    
    
    
    _onetableview = [[UITableView alloc] initWithFrame:CGRectMake(0,twoView.frame.origin.y+twoView.frame.size.height+ FrameWidth(10), WIDTH_SCREEN, View_Height -( twoView.frame.origin.y+twoView.frame.size.height+ FrameWidth(100)))];
    _onetableview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //[twoView addSubview:_onetableview];
    _onetableview.dataSource = self;
    _onetableview.delegate = self;
    _onetableview.estimatedRowHeight = 0;
    _onetableview.estimatedSectionHeaderHeight = 0;
    _onetableview.estimatedSectionFooterHeight = 0;
    _onetableview.separatorStyle = UITableViewCellSelectionStyleNone;
    _onetableview.backgroundColor = BGColor;
    //[_onetableview registerNib:[UINib nibWithNibName:NSStringFromClass([ALA class]) bundle:nil] forCellReuseIdentifier:FrameCellID];
    [self.view addSubview:_onetableview];
    _onetableview.rowHeight = FrameWidth(87);//230
    _typetags = [[NSMutableArray alloc]init];
    [self attachmentModel];
    
}

- (UITableView *)onetableview{
    //[_onetableview setBackgroundColor:[UIColor redColor]];
    if (_onetableview ==nil)
    {
        NSLog(@"_onetableview ==nil");
        //使用约束布局，将frame置为CGRectZero
        _onetableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 0)];
        
        
        _onetableview.delegate =self;
        _onetableview.dataSource =self;
        _onetableview.backgroundColor = BGColor;
        [self.view addSubview:_onetableview];
    }
    _onetableview.rowHeight = FrameWidth(86);//230
    //
    return _onetableview;
    
}
#pragma mark - private methods 私有方法



-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"AlarmMachineListController viewWillAppear");
}


#pragma mark - 请求数据方法
/**
 *  发送请求并获取数据方法
 */




-(void)viewWillDisappear:(BOOL)animated{
}

-(void)viewDidDisappear:(BOOL)animated{
    
}
-(void)viewAppear:(BOOL)animated{
    
    
}
-(void)valueChanged{
    
    if ([FrameBaseRequest stringContainsEmoji:_searchText.text]) {
        [FrameBaseRequest showMessage:@"输入内容含有表情，请重新输入"];
        _searchText.text = @"";
    }else{
        _Name = _searchText.text;
        
        if(_searchText.text.length ==0 ){
            self.SearchItem = self.AlarmItem;
            [_onetableview reloadData];
            return ;
        }
        self.SearchItem = [[AlarmItems class] alloc];
        NSMutableArray <AlarmItems *> * searchAlarm = [[AlarmItems class] mj_objectArrayWithKeyValuesArray:@[]];
        for (AlarmItems * item in self.AlarmItem) {
            if([item.name containsString:_searchText.text] ){
                [searchAlarm addObject:item];
            }
        }
        self.SearchItem = [searchAlarm copy];
        [_onetableview reloadData];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"点击了搜索");
    
    return [textField resignFirstResponder];
    //return YES;
}


-(void)submitAction{
    if(self.statusBtn.tag > 0 &&self.statusBtn.isSelected){
        _statusSelect = self.atStatusItem[self.statusBtn.tag-1].code;
    }else{
        _statusSelect = nil;
    }
    
    
    _status = _statusSelect;
    _attachment_start_time = ![_startDate.titleLabel.text isEqualToString:@"开始日期"]?_startDate.titleLabel.text:nil;
    _attachment_end_time = ![_endDate.titleLabel.text isEqualToString:@"结束日期"]?_endDate.titleLabel.text:nil;
    [self loadMoreData];
    
    [self cb_dismissPopupViewControllerAnimated:YES completion:nil];
}


-(void)resetAction{
    [self.statusBtn setSelected:false];
    [_endDate setTitle:@"结束日期" forState:UIControlStateNormal];
    [_startDate setTitle:@"开始日期" forState:UIControlStateNormal];
    
}

/**
 *  加载更多数据
 */
- (void)loadMoreData{
    _name = @"";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"category"] = _code;
    params[@"attachment_start_time"] = _attachment_start_time;
    params[@"attachment_end_time"] = _attachment_end_time;
    params[@"status"] = _status;
    params[@"model"] = _model;
    
    
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:@"/api/atcAttachment"];
    NSLog(@"FrameRequestURL %@   %@",FrameRequestURL,params);
    [FrameBaseRequest getWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        
        NSMutableArray <AlarmItems *> *dictArray = [[AlarmItems class] mj_objectArrayWithKeyValuesArray:result[@"value"]];
        NSMutableArray <AlarmItems *> *  alarmdic = [[AlarmItems class] mj_objectArrayWithKeyValuesArray:@[]];
        if(dictArray){
            [alarmdic addObjectsFromArray:[dictArray copy]];
        }
        self.AlarmItem = [alarmdic copy];
        
        self.SearchItem = [alarmdic copy];
        //[_onetableview reloadData];
        [self valueChanged];
        
        return ;
        
        
        //[self getStationList];
        
    } failure:^(NSURLSessionDataTask *error)  {
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
    
    
    
}
-(bool)attachmentStatus{
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:@"/api/atcDictionary/attachmentStatus"  ];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        NSArray *dictArray = [result[@"value"] copy];
        [_typetags addObjectsFromArray:[dictArray copy]];
        self.atStatusItem = [[AlarmItems class] mj_objectArrayWithKeyValuesArray:dictArray];
        
        
        [_filterTabView reloadData];
        [self loadMoreData];
        
    } failure:^(NSURLSessionDataTask *error)  {
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
    return YES;
}
-(bool)attachmentModel{//获取备件状态的
    NSString * FrameRequestURL = [WebHost stringByAppendingString:@"/api/atcDictionary/attachmentModel"  ];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        NSArray *dictArray = [result[@"value"] copy];
        
        [_typetags addObjectsFromArray:[dictArray copy]];
        
        [self attachmentStatus];
    } failure:^(NSURLSessionDataTask *error)  {
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
    return YES;
}


- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:kCellHighlightColor];
    
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}




#pragma mark - UITableviewDatasource 数据源方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _onetableview){
        return FrameWidth(86);
    }else{//如果是筛选的列表，则判断高度决定cell高度
        NSInteger HEIGHT = _newHeight1+_newHeight4;
        if(HEIGHT > FrameWidth(1075)){
            return HEIGHT;
        }
        return FrameWidth(1075);
    }
    return FrameWidth(86);
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == _onetableview){
        return self.SearchItem.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1.2 去缓存池中取Cell
    
    if(tableView == _onetableview){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];//[tableView dequeueReusableCellWithIdentifier:FrameCellID];
        // 1.3 若取不到便创建一个带重用标识的Cell
        if (cell == nil) {
            cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FrameCellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
        
        AlarmItems *group = self.SearchItem[indexPath.row];
        //线
        UILabel *bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, WIDTH_SCREEN, 1)];
        bgLabel.backgroundColor = BGColor;
        [cell addSubview:bgLabel];
        
        //名称
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(20), 0, FrameWidth(210), FrameWidth(86))];
        nameLabel.text = group.name;
        nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        nameLabel.numberOfLines = 2;
        
        //nameLabel.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:nameLabel];
        //编号
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(230), 0, FrameWidth(140), FrameWidth(86))];
        numLabel.text = group.code;
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.lineBreakMode = NSLineBreakByCharWrapping;
        numLabel.numberOfLines = 2;
        [cell addSubview:numLabel];
        //状态
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(370), 0, FrameWidth(100), FrameWidth(86))];
        statusLabel.text = group.status;
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.lineBreakMode = NSLineBreakByCharWrapping;
        statusLabel.numberOfLines = 2;
        [cell addSubview:statusLabel];
        
        
        //日期
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(470), 0, FrameWidth(150), FrameWidth(86))];
        countLabel.text = group.model;
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.lineBreakMode = NSLineBreakByCharWrapping;
        countLabel.numberOfLines = 2;
        [cell addSubview:countLabel];
        
        for (int i =0; i< _typetags.count; i++) {
            if([_typetags[i][@"code"] isEqualToString:group.model]){
                countLabel.text = _typetags[i][@"code"];
            }
            if([_typetags[i][@"code"] isEqualToString:group.status]){
                statusLabel.text = _typetags[i][@"name"];
            }
        }
        
        
        
        
        nameLabel.textColor = [UIColor grayColor];
        numLabel.textColor = [UIColor grayColor];
        statusLabel.textColor = [UIColor grayColor];
        countLabel.textColor = [UIColor grayColor];
        countLabel.font = FontSize(15);
        statusLabel.font = FontSize(15);
        nameLabel.font = FontSize(16);
        numLabel.font = FontSize(15);
        
        
        
        return cell;
    }else{
        static NSString *ID = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        // 1.3 若取不到便创建一个带重用标识的Cell
        //if (cell == nil) {
            cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        //}
        //cell.backgroundColor = [UIColor cyanColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
        
        _newHeight1 = [self setFilterBtn:cell objects:self.atStatusItem title:@"备件状态"];
        
        return cell;
        
    }
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 点击了第indexPath.row行Cell所做的操作
    NSLog(@"点击了第%ld行Cell所做的操作",(long)indexPath.row);
    [self.view endEditing:YES];
    if(tableView == _onetableview){
        AlarmMachineDetailController  *AlarmMachineDetail = [[AlarmMachineDetailController alloc] init];
        AlarmItems *group = self.SearchItem[indexPath.row];
        
        AlarmMachineDetail.id = group.id;
        AlarmMachineDetail.code = group.code;
        
        for (int i =0; i< _typetags.count; i++) {
            if([_typetags[i][@"code"] isEqualToString:group.model]){
                AlarmMachineDetail.model = _typetags[i][@"name"];
            }
        }
        
        //AlarmMachineDetail.model = group.model;
        for (int i =0; i< _typetags.count; i++) {
            if([_typetags[i][@"code"] isEqualToString:group.status]){
                AlarmMachineDetail.status = _typetags[i][@"name"];
            }
        }
        NSLog(@"group.status %@",group.status);
        //AlarmMachineDetail.status =group.status ;
        [self.navigationController pushViewController:AlarmMachineDetail animated:YES];
        
    }
}

/*返回*/
-(void)backBtn{
    UIButton *leftButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButon.frame = CGRectMake(0,0,FrameWidth(60),FrameWidth(60));
    [leftButon setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [leftButon setContentEdgeInsets:UIEdgeInsetsMake(0, - FrameWidth(20), 0, FrameWidth(20))];
    //button.alignmentRectInsetsOverride = UIEdgeInsetsMake(0, offset, 0, -(offset));
    [leftButon addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc]initWithCustomView:leftButon];
    self.navigationItem.leftBarButtonItem = fixedButton;
    
    
    UIButton *rightButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightButon.titleLabel.font = FontSize(15);
    [rightButon setTitle:@"筛选" forState:UIControlStateNormal];
    rightButon.frame = CGRectMake(0,0,FrameWidth(70),FrameWidth(40));
    //[rightButon setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    //[rightButon setContentEdgeInsets:UIEdgeInsetsMake(0, - 17, 0, 17)];
    //button.alignmentRectInsetsOverride = UIEdgeInsetsMake(0, offset, 0, -(offset));
    [rightButon addTarget:self action:@selector(filterAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButon];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)filterAction {
    [self.view endEditing:YES];
    _newHeight1=0;
    _newHeight4=0;
    _ALLtags = [[NSMutableArray alloc]init];
    _vc = [UIViewController new];
    _vc.view.backgroundColor = [UIColor whiteColor];
    
    _vc.view.frame = CGRectMake(FrameWidth(120), 0, FrameWidth(520), HEIGHT_SCREEN);
    //_vc.view.layer.cornerRadius = 4.0;
    _vc.view.layer.masksToBounds = YES;
    //设置滚动
    _filterTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, FrameWidth(25), WIDTH_SCREEN -4 , FrameWidth(1050))];
    _filterTabView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [_vc.view addSubview:_filterTabView];
    _filterTabView.dataSource = self;
    _filterTabView.delegate = self;
    [_filterTabView reloadData];
    
    //设置重置和提交
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [resetBtn setFrame:CGRectMake(0,HEIGHT_SCREEN - FrameWidth(61),
                                  FrameWidth(260),
                                  FrameWidth(61))];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    //resetBtn.layer.cornerRadius = 5.0;
    resetBtn.backgroundColor = [UIColor colorWithRed:85/255.0 green:185/255.0 blue:250/255.0 alpha:1];
    [resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[resetBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [resetBtn.titleLabel setFont:FontSize(14)];
    [resetBtn addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_vc.view addSubview:resetBtn];
    
    
    UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [completeBtn setFrame:CGRectMake(FrameWidth(260),HEIGHT_SCREEN - FrameWidth(61),
                                     FrameWidth(260),
                                     FrameWidth(61))];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    //completeBtn.layer.cornerRadius = 5.0;
    [completeBtn setBackgroundColor:[UIColor colorWithRed:30/255.0 green:160/255.0 blue:240/255.0 alpha:1]];
    //completeBtn.backgroundColor = [UIColor colorWithRed:30 green:160 blue:240 alpha:1];
    [completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[completeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [completeBtn.titleLabel setFont:FontSize(14)];
    [completeBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_vc.view addSubview:completeBtn];
    
    
    [self cb_presentPopupViewController:_vc animationType:CBPopupViewAnimationSlideFromRight aligment:CBPopupViewAligmentRight overlayDismissed:nil];
    //[self cb_presentPopupViewController:vc animationType:CBPopupViewAnimationSlideFromRight aligment:CBPopupViewAligmentTop overlayDismissed:nil];
    
}

-(CGFloat) setFilterBtn :(UITableViewCell *)vc objects:(NSArray *)objects title:(NSString *)title  {
    CGFloat Thisheight = FrameWidth(10)+_newHeight1;
    
    //设置标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake( FrameWidth(30),Thisheight, FrameWidth(300) , FrameWidth(90))];
    titleLabel.text = title;
    //titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.textColor = [UIColor grayColor];
    [titleLabel setFont:FontSize(17)];
    [vc addSubview:titleLabel];
    
    //设置按钮
    const NSInteger countPerRow = 3;
    NSInteger rowCount = (objects.count + (countPerRow - 1)) / countPerRow;
    CGFloat horizontalPadding = FrameWidth(10);
    CGFloat verticalPadding = FrameWidth(9);
    
    UIView *containerView = [UIView new];
    containerView.frame = CGRectMake(0, titleLabel.frame.origin.y+titleLabel.frame.size.height, FrameWidth(470), FrameWidth(70)*rowCount);
    containerView.center = CGPointMake(FrameWidth(260), containerView.frame.size.height/2+titleLabel.frame.origin.y+titleLabel.frame.size.height);
    [self.view addSubview:containerView];
    
    CGFloat buttonWidth = (containerView.bounds.size.width - horizontalPadding * (countPerRow - 1)) / countPerRow;
    //CGFloat buttonHeight = (containerView.bounds.size.height - verticalPadding * rowCount) / rowCount;
    NSMutableArray *heights = [NSMutableArray new];
    
    for (int i=0; i<objects.count; ++i) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping ;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        //[button setFrame:CGRectMake((buttonWidth + horizontalPadding) * (i % countPerRow),  (buttonHeight + verticalPadding) * (i / countPerRow),  buttonWidth,  buttonHeight)];
        
        
        
        AlarmItems *group = objects[i];//self.AlarmItem[indexPath.row];
        
        [button setTitle:group.name forState:UIControlStateNormal];
        
        CGFloat buttonHeight =  [CommonExtension heightForString:button.titleLabel.text fontSize:FontSize(14) andWidth:buttonWidth] +FrameWidth(20);
        if(heights.count <=  (i / countPerRow)){
            [heights addObject:[NSString stringWithFormat:@"%f",buttonHeight]];
        }else if([heights[i / countPerRow] floatValue] < buttonHeight){
            heights[i / countPerRow] = [NSString stringWithFormat:@"%f",buttonHeight];
        }
        float buttony = 0;
        for (int a=0; a<heights.count-1; ++a) {
            buttony += ([heights[a] floatValue] + verticalPadding);
        }
        [button setFrame:CGRectMake((buttonWidth + horizontalPadding) * (i % countPerRow),
                                    buttony,
                                    buttonWidth,
                                    buttonHeight)];
        [containerView setFrameHeight:button.originY + button.frameHeight + FrameWidth(20)];
        
        
        button.tag = i+1;
        [_ALLtags addObject:[NSString stringWithFormat:@"%ld",(long)button.tag]];
        if([_statusSelect isEqualToString:group.code ]){
            [button setSelected:YES];
            self.statusBtn = button;
        }
        
        //button.backgroundColor = QianGray;
        [button setBackgroundImage:[UIImage imageNamed:@"Patrol_btn"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"Patrol_btn_s"] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.layer.cornerRadius = 5.0;
        //[button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [button.titleLabel setFont:FontSize(14)];
        [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [containerView addSubview:button];
    }
    [vc addSubview:containerView];
    //巡查类别添加完，添加巡查日期
    //containerView.layer.borderColor = QianGray.CGColor;
    // containerView.layer.borderWidth = 1;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake( 0,Thisheight+FrameWidth(20), FrameWidth(520) , 1)];
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake( 0,Thisheight+FrameWidth(20)+containerView.frame.size.height+titleLabel.frame.size.height, FrameWidth(520) , 1)];
    lineView.backgroundColor = QianGray;
    lineView2.backgroundColor = QianGray;
    [vc addSubview:lineView];
    [vc addSubview:lineView2];
    
    //设置巡查日期标题
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake( FrameWidth(30),Thisheight+containerView.frame.size.height+titleLabel.frame.size.height, FrameWidth(300) , FrameWidth(90))];
    dateLabel.text = @"入库时间";
    //dateLabel.backgroundColor = [UIColor redColor];
    dateLabel.textColor = [UIColor grayColor];
    [dateLabel setFont:FontSize(17)];
    [vc addSubview:dateLabel];
    
    UIView *dateView = [[UIView alloc] initWithFrame:CGRectMake( FrameWidth(30),dateLabel.frame.origin.y+dateLabel.frame.size.height, FrameWidth(480) , FrameWidth(60))];
    dateView.backgroundColor = QianGray;
    [vc addSubview:dateView];
    
    _startDate = [[UIButton alloc]initWithFrame:CGRectMake( 5,FrameWidth(10), FrameWidth(215) , FrameWidth(40))];
    [_startDate setTitle:@"开始日期" forState:UIControlStateNormal];
    [_startDate setTitleEdgeInsets:UIEdgeInsetsMake(0, FrameWidth(8), 0, -FrameWidth(8))];//上左下右
    [_startDate.titleLabel setFont:FontSize(15)];
    [_startDate setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //_startDate = NSTextAlignmentLeft;
    if(_attachment_start_time){
        [_startDate setTitle:_attachment_start_time forState:UIControlStateNormal];
    }else{
        [_startDate setTitle:@"开始日期" forState:UIControlStateNormal];
    }
    _startDate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //_startDate = [UIColor grayColor];
    _startDate.backgroundColor = [UIColor whiteColor];
    [_startDate addTarget:self action:@selector(startDateAction) forControlEvents:UIControlEventTouchUpInside];
    [dateView addSubview:_startDate];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(_startDate.frame.origin.x+_startDate.frame.size.width+5, FrameWidth(28), FrameWidth(23), 4)];
    lineView3.backgroundColor = [UIColor grayColor];
    
    [dateView addSubview:lineView3];
    
    _endDate = [[UIButton alloc]initWithFrame:CGRectMake( FrameWidth(260),FrameWidth(10), FrameWidth(215) , FrameWidth(40))];
    [_endDate setTitle:@"结束日期" forState:UIControlStateNormal];
    [_endDate setTitleEdgeInsets:UIEdgeInsetsMake(0, FrameWidth(8), 0, -FrameWidth(8))];//上左下右
    [_endDate.titleLabel setFont:FontSize(15)];
    [_endDate setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _endDate.backgroundColor = [UIColor whiteColor];
    if(_attachment_end_time){
        [_endDate setTitle:_attachment_end_time forState:UIControlStateNormal];
    }else{
        [_endDate setTitle:@"结束日期" forState:UIControlStateNormal];
    }
    //endDate.titleLabel.textColor = [UIColor grayColor];
    //endDate.titleLabel.textAlignment = NSTextAlignmentLeft;
    _endDate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_endDate addTarget:self action:@selector(endDateAction) forControlEvents:UIControlEventTouchUpInside];
    [dateView addSubview:_endDate];
    _newHeight4 = dateLabel.frame.size.height +  dateView.frame.size.height ;
    [containerView setFrameHeight:containerView.frameHeight + dateView.frameHeight +  dateLabel.frameHeight];
    
    
    //返回设置的高度
    return containerView.frame.size.height+titleLabel.frame.size.height;
}

- (void)tapButton:(UIButton *)button{
    
    [button setSelected:true];
    //[button setSelected:!button.isSelected];
    
    if (button.isSelected) {
        
        for (NSInteger i=0; i<_ALLtags.count; i++) {
            if(button.tag != [_ALLtags[i] intValue]){
                UIButton *thisBtn = [_vc.view viewWithTag:[_ALLtags[i] intValue] ];
                thisBtn.selected = false;
            }
        }
        long tagnum = button.tag-1;
        _statusSelect = self.atStatusItem[tagnum].code;
        self.statusBtn = button;
        //[button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        //[button setBackgroundColor:[UIColor colorWithRed:30/255.0 green:160/255.0 blue:240/255.0 alpha:1]];
    }else{
        _statusSelect = nil;
    }
    
}

-(void)startDateAction{
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackground = true;
    _startDatePicker = datePickManager.datePicker;
    _startDatePicker.delegate = self;
    _startDatePicker.datePickerType = PGPickerViewLineTypeline;
    _startDatePicker.isHiddenMiddleText = false;
    _startDatePicker.datePickerMode = PGDatePickerModeDate;
    [self presentViewController:datePickManager animated:false completion:nil];
    
}
-(void)endDateAction{
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackground = true;
    _endDatePicker = datePickManager.datePicker;
    _endDatePicker.delegate = self;
    _endDatePicker.datePickerType = PGPickerViewLineTypeline;
    _endDatePicker.isHiddenMiddleText = false;
    _endDatePicker.datePickerMode = PGDatePickerModeDate;
    [self presentViewController:datePickManager animated:false completion:nil];
    
}
#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    
    
    dateComponents.hour = 0;
    dateComponents.minute = 0;
    dateComponents.second = 0;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat =@"yyyy-MM-dd";
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    // 时间转为字符串
    NSString *dateStr = [formatter stringFromDate:[calendar dateFromComponents:dateComponents]];
    //NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)dateComponents.year,(long)dateComponents.month,(long)dateComponents.day];
    
    
    if(datePicker == _endDatePicker){
        if(![[calendar dateFromComponents:dateComponents] isEqualToDate:_NstartDate] &&[[calendar dateFromComponents:dateComponents] laterDate:_NstartDate] == _NstartDate&&_NstartDate != nil){
            [_endDate setTitle:@"结束时间" forState:UIControlStateNormal];
            [FrameBaseRequest showMessage:@"开始时间不能大于结束时间"];
            return ;
        }
        
        
        _NendDate = [calendar dateFromComponents:dateComponents];
        [_endDate setTitle:dateStr forState:UIControlStateNormal];
        
    }
    if(datePicker == _startDatePicker){
        
        if(![_NendDate isEqualToDate:[calendar dateFromComponents:dateComponents]]&&[_NendDate laterDate:[calendar dateFromComponents:dateComponents]] == [calendar dateFromComponents:dateComponents]&&_NendDate != nil){
            [_startDate setTitle:@"开始时间" forState:UIControlStateNormal];
            [FrameBaseRequest showMessage:@"开始时间不能大于结束时间"];
            return ;
        }
        
        
        _NstartDate = [calendar dateFromComponents:dateComponents];
        [_startDate setTitle:dateStr forState:UIControlStateNormal];
        
    }
}

@end
