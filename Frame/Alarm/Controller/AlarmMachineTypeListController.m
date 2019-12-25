//
//  AlarmMachineTypeListController.m
//  Frame
//
//  Created by hibayWill on 2018/4/8.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "AlarmMachineTypeListController.h"
#import "AlarmItems.h"
#import "AlarmListCell.h"
#import "PGDatePickManager.h"
#import "AlarmDetailController.h"
#import "AlarmMachineListController.h"
#import "SearchView.h"
#import "FrameBaseRequest.h"
#import <MJExtension.h>
#import "UIView+LX_Frame.h"
#import "SparePartTableViewCell.h"
#import "RecordTableViewCell.h"
#import "SparePartListModel.h"
#import "CurriculumVitaeModel.h"
#import "AtcAttachmentRecordsModel.h"
#import "NSString+Extension.h"
#import "AlarmMachineDetailController.h"
#import "UIColor+Extension.h"
#import "HSIEmptyDataSetView.h"
#import "UIScrollView+EmptyDataSet.h"
static NSString *SparePartTableViewCellID = @"SparePartTableViewCellID";
static NSString *RecordTableViewCellID = @"RecordTableViewCellID";
@interface AlarmMachineTypeListController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SearchViewDelegeat,UIScrollViewDelegate,EmptyDataSetDelegate>


@property NSString* type;


@property (strong, nonatomic) NSMutableArray<AlarmItems *> * AlarmItem;
@property (strong, nonatomic) NSMutableArray<AlarmItems *> * SearchItem;
@property(strong,nonatomic)UITableView *onetableview;
@property(strong,nonatomic) UITextField *  searchText;

/** 请求管理者 */
//@property (nonatomic,weak) AFHTTPSessionManager * manager;
/** 用于加载下一页的参数(页码) */
@property (nonatomic,assign) NSInteger pageNo;
@property (nonatomic,assign) NSInteger viewNum;
@property (nonatomic,assign) NSInteger chooseDay;


@property (nonatomic, strong)SearchView *searchView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *bavkView;
@property (nonatomic, strong)UIButton *leftButton;
@property (nonatomic, strong)UIButton *rightButton;
@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, strong)NSArray *sparePartArray;
@property (nonatomic, strong)NSArray *curriculumVitaeArray;
@property (nonatomic, strong)NSString *sparePartString;
@property (nonatomic, strong)NSString *curriculumVitaeString;
@end

@implementation AlarmMachineTypeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigation];
    [self setSearchView];
    [self switchView];
    [self setTableView];
    self.sparePartString = @"";
    [self sparePartData:self.sparePartString];
    self.curriculumVitaeString = @"";
    [self sparePartCurriculumVitaeData:self.curriculumVitaeString];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetNotificationAction) name:kNetworkStatusNotification object:nil];
}



/**
 监听网络
 */
- (void)resetNotificationAction {
    if (self.index == 0) {
        if (!IsNetwork) {
            self.sparePartArray = nil;
            [self.tableView reloadData];
        } else {
             [self sparePartData:self.sparePartString];
        }
    } else {
        if (!IsNetwork) {
            self.curriculumVitaeArray = nil;
            [self.onetableview reloadData];
        } else {
           [self sparePartCurriculumVitaeData:self.curriculumVitaeString];
        }
    }
}


/**
 开始搜索

 @param searchFieldText 输入的文字
 */
- (void)startSearch:(NSString *)searchFieldText {
    if (self.index == 0) {
        if (searchFieldText.length > 0) {
            self.sparePartString = searchFieldText;
            [self sparePartData:self.sparePartString];
        } else {
            self.sparePartString = @"";
            [self sparePartData:self.sparePartString];
        }
    } else {
        if (searchFieldText.length > 0) {
            self.curriculumVitaeString = searchFieldText;
            [self sparePartCurriculumVitaeData:self.curriculumVitaeString];
        } else {
            self.curriculumVitaeString = @"";
            [self sparePartCurriculumVitaeData:self.curriculumVitaeString];
        }
    }
    
}

/**
 输入框输入完毕

 @param textFieldText 输入框n文字
 */
- (void)searchTextFieldDidEndEditing:(NSString *)textFieldText {
//    if (self.index == 0) {
//        if (textFieldText.length > 0) {
//            self.sparePartString = textFieldText;
//            [self sparePartData:self.sparePartString];
//        } else {
//            self.sparePartString = @"";
//            [self sparePartData:self.sparePartString];
//        }
//    } else {
//        if (textFieldText.length > 0) {
//            self.curriculumVitaeString = textFieldText;
//            [self sparePartCurriculumVitaeData:self.curriculumVitaeString];
//        } else {
//            self.curriculumVitaeString = @"";
//            [self sparePartCurriculumVitaeData:self.curriculumVitaeString];
//        }
//    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.index == 0) {
        return 40;
    } else {
        return CGFLOAT_MIN;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.index == 0) {
        return 50;
    } else {
        CurriculumVitaeModel *curModel = self.curriculumVitaeArray[indexPath.row];
        AtcAttachmentRecordsModel *model = curModel.atcAttachmentRecords;
        CGFloat textHeight = curModel.textHeight + model.textHeight;
        return textHeight + 20;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.index == 0) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 40)];
        backView.backgroundColor = [UIColor whiteColor];
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, WIDTH_SCREEN/2 -10, backView.lx_height)];
        leftLabel.text  =@"备件类型";
        leftLabel.textColor = [UIColor blackColor];
        leftLabel.font = FontSize(17);
        [backView addSubview:leftLabel];
        
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftLabel.frame), 0, WIDTH_SCREEN/2 -10, backView.lx_height)];
        rightLabel.text  =@"备件数量";
        rightLabel.textColor = [UIColor blackColor];
        rightLabel.font = FontSize(17);
        rightLabel.textAlignment = NSTextAlignmentRight;
        [backView addSubview:rightLabel];
        return backView;
    } else  {
        return nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.index == 0) {
        return self.sparePartArray.count;
    } else {
        return self.curriculumVitaeArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.index == 0) {
        SparePartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SparePartTableViewCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.sparePartListModel = self.sparePartArray[indexPath.row];
        return cell;
    } else {
        RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RecordTableViewCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.curriculumVitaeString = self.curriculumVitaeString;
        cell.curriculumVitaeModel = self.curriculumVitaeArray[indexPath.row];
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.index == 0) {
        SparePartListModel *model = self.sparePartArray[indexPath.row];
        if ([model.num integerValue] >0 ) {
            AlarmMachineListController  *vc = [[AlarmMachineListController alloc] init];
            vc.code = [CommonExtension returnWithString:model.code];
            vc.category = [CommonExtension returnWithString:model.category] ;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [FrameBaseRequest showMessage:@"对不起，暂无此类型备件"];
        }
    } else {
        CurriculumVitaeModel *currModel = self.curriculumVitaeArray[indexPath.row];
        AlarmMachineDetailController *vc= [AlarmMachineDetailController new];
        vc.code = [CommonExtension returnWithString:currModel.code] ;
        vc.id = [CommonExtension returnWithString:currModel.id] ;
        vc.status = [CommonExtension returnWithString:currModel.status] ;
        vc.model = [CommonExtension returnWithString:currModel.model] ;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


/**
 切换按钮
 */
- (void)switchButtonClick:(UIButton *)sender {
    self.index = sender.tag;
    switch (sender.tag) {
        case 0: {
            self.leftButton.backgroundColor = [UIColor colorWithHexString:@"F5FBFF"];
            self.rightButton.backgroundColor = [UIColor whiteColor];
            self.lineView.frame = CGRectMake(0, CGRectGetMaxY(self.leftButton.frame), self.leftButton.lx_width, 2);
            [self.tableView reloadData];
        }
            break;
        case 1: {
            self.leftButton.backgroundColor = [UIColor whiteColor];
            self.rightButton.backgroundColor = [UIColor colorWithHexString:@"F5FBFF"];
            self.lineView.frame = CGRectMake(CGRectGetMaxX(self.leftButton.frame), CGRectGetMaxY(self.leftButton.frame), self.leftButton.lx_width, 2);
            [self.tableView reloadData];
        }
            break;
            
        default:
            break;
    }
}




/**
 *  备件列表数据
 */
- (void)sparePartData:(NSString *)sparePartString{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = _type;
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:@"/api/atcAttachmentList?name="];
    FrameRequestURL = [FrameRequestURL stringByAppendingString:sparePartString];
    NSLog(@"FrameRequestURL %@   %@",FrameRequestURL,params);
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            self.tableView.emptyDataSetDelegate = self;
            [self.tableView reloadData];
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        NSMutableArray *mutableArray = [NSMutableArray array];
        if (result[@"value"] || [result[@"value"] isKindOfClass:[NSArray class]] || [result[@"value"] count] > 0) {
            for (NSDictionary *dict in result[@"value"]) {
                SparePartListModel *model = [SparePartListModel mj_objectWithKeyValues:dict];
                [mutableArray addObject:model];
            }
        }
        self.sparePartArray = [mutableArray copy];
        self.tableView.emptyDataSetDelegate = self;
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        self.tableView.emptyDataSetDelegate = self;
        [self.tableView reloadData];
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



/**
 *  备件履历数据
 */
- (void)sparePartCurriculumVitaeData:(NSString *)curriculumVitaeString{
    
    NSDictionary *params = @{
                             @"key":curriculumVitaeString
                             };
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:@"/api/atcAttachmentAndRecordList"];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            self.tableView.emptyDataSetDelegate = self;
            [self.tableView reloadData];
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        NSMutableArray *mutableArray = [NSMutableArray array];
        if (result[@"value"] || [result[@"value"] isKindOfClass:[NSArray class]] || [result[@"value"] count] > 0) {
            for (NSDictionary *dict in result[@"value"]) {
               
                if (dict[@"atcAttachmentRecords"] || [dict[@"atcAttachmentRecords"] isKindOfClass:[NSArray class]] || [dict[@"atcAttachmentRecords"] count] > 0) {
                    for (NSDictionary *dic in dict[@"atcAttachmentRecords"]) {
                        CurriculumVitaeModel *model = [CurriculumVitaeModel mj_objectWithKeyValues:dict];
                        model.textHeight = [self heightForString:model.name fontSize:15 andWidth:WIDTH_SCREEN -20];
                        
                        
                    //for (NSDictionary *dic in dict[@"atcAttachmentRecords"]) {
                        AtcAttachmentRecordsModel *atcModel = [AtcAttachmentRecordsModel mj_objectWithKeyValues:dic];
                        atcModel.content = [CommonExtension returnWithString:atcModel.content];
                        atcModel.textHeight = [self heightForString:atcModel.content fontSize:17 andWidth:WIDTH_SCREEN - 20]+10;
                        model.atcAttachmentRecords = atcModel;
                        
                        [mutableArray addObject:model];
                    }
                }else{
                    CurriculumVitaeModel *model = [CurriculumVitaeModel mj_objectWithKeyValues:dict];
                    model.textHeight = [self heightForString:[CommonExtension returnWithString:model.name] fontSize:15 andWidth:WIDTH_SCREEN -20];
                    [mutableArray addObject:model];
                }
            }
        }
        NSMutableArray *listArray = [NSMutableArray array];
        
        if (mutableArray.count) {
            
            NSString *repeatString = @"";
            for (int i=0;i<mutableArray.count;i++) {
                CurriculumVitaeModel *model = mutableArray[i];
                if (![repeatString isEqualToString:model.name]) {
                    repeatString = model.name;
                    [listArray addObject:model];
                }
            }
        }
       
        self.curriculumVitaeArray = [listArray copy];
        self.tableView.emptyDataSetDelegate = self;
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        self.tableView.emptyDataSetDelegate = self;
        [self.tableView reloadData];
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

- (float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width {
    if ([value isNull]) {
        return 0;
    }
    NSDictionary *font = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize size = [value boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:font context:nil].size;
    return size.height;
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
    if (self.index == 0) {
        [self sparePartData:[CommonExtension returnWithString:self.sparePartString]];
    } else {
        [self sparePartCurriculumVitaeData:[CommonExtension returnWithString:self.curriculumVitaeString]];
    }
}


/**
 列表
 */
- (void)setTableView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bavkView.frame), WIDTH_SCREEN, HEIGHT_SCREEN -ZNAVViewH - CGRectGetMaxY(self.bavkView.frame)) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.tableView.emptyDataSetDelegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SparePartTableViewCell class]) bundle:nil] forCellReuseIdentifier:SparePartTableViewCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RecordTableViewCell class]) bundle:nil] forCellReuseIdentifier:RecordTableViewCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}



/**
 切换模块
 */
- (void)switchView {
    self.bavkView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchView.frame)+1, WIDTH_SCREEN, 40)];
    self.bavkView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bavkView];
    
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN/2, 38)];
    [self.leftButton setTitle:@"备件列表" forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor colorWithHexString:@"2E2D2F"] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = FontSize(18);
    //[UIFont  fontWithName:@"Helvetica-Bold" size:17];
    [self.leftButton addTarget:self action:@selector(switchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.leftButton.tag = 0;
    self.leftButton.backgroundColor = [UIColor colorWithHexString:@"F5FBFF"];
    [self.bavkView addSubview:self.leftButton];
    
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftButton.frame), 0, WIDTH_SCREEN/2, 38)];
    [self.rightButton setTitle:@"备件履历" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor colorWithHexString:@"2E2D2F"] forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = FontSize(18);
    //[UIFont fontWithName:@"Helvetica-Bold" size:16];
    [self.rightButton addTarget:self action:@selector(switchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.tag = 1;
    [self.bavkView addSubview:self.rightButton];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.leftButton.frame), self.leftButton.lx_width, 2)];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"3389E5"];
    [self.bavkView addSubview:self.lineView];
    
    self.index = self.leftButton.tag;
    
}



/**
 搜索模块
 */
- (void)setSearchView {
    self.searchView = [[SearchView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 55)];
    self.searchView.fieldPlaceholder = @"搜索";
    self.searchView.delegeat = self;
    [self.view addSubview:self.searchView];
}


- (void)navigation {
    [self backBtn];
    self.navigationItem.title = @"备件列表";
    self.view.backgroundColor =  [UIColor  colorWithPatternImage:[UIImage imageNamed:@"personal_gray_bg"]] ;
}

/*返回*/
-(void)backBtn{
    UIButton *leftButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButon.frame = CGRectMake(0,0,FrameWidth(60),FrameWidth(60));
    [leftButon setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [leftButon setContentEdgeInsets:UIEdgeInsetsMake(0, - FrameWidth(20), 0, FrameWidth(20))];
    [leftButon addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc]initWithCustomView:leftButon];
    self.navigationItem.leftBarButtonItem = fixedButton;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
