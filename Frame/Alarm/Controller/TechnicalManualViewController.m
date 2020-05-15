//
//  TechnicalManualViewController.m
//  Frame
//
//  Created by centling on 2018/12/4.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "TechnicalManualViewController.h"
#import "TechnicalManualTableViewCell.h"
#import "FilePreviewViewController.h"
#import "FrameBaseRequest.h"
#import "SearchView.h"
#import "XDMultTableView.h"
#import "CategoryModel.h"
#import "technicalManualListModel.h"
#import "PopularModel.h"
#import "PopularView.h"
#import <MJExtension.h>
#import "UIColor+Extension.h"
#import "DIYNoDataView.h"


static NSString *TechnicalManualTableViewCellID = @"TechnicalManualTableViewCellID";
@interface TechnicalManualViewController ()<XDMultTableViewDatasource,XDMultTableViewDelegate,SearchViewDelegeat,RollDelegate,PopularViewDelegate,DIYNoDataViewDelegate>
//搜索
@property (nonatomic, strong)SearchView *searchView;
@property (nonatomic, weak)PopularView *centerView;
@property (nonatomic, strong)XDMultTableView *tableView;
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)NSMutableArray *searchArray;
@property (nonatomic, strong)NSArray *topLabelArray;
@property (nonatomic, strong)NSString *fieldText;
@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)NSMutableArray *textMutableArray;
@property (nonatomic, strong)DIYNoDataView *backView;

//选择关键词
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSArray *modelArray;
@end

@implementation TechnicalManualViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchArray = [NSMutableArray array];
    [self setupUI];
    [self searchLabelData];
    self.textMutableArray = [NSMutableArray array];
}

- (void)setupUI {
    [self navigation];
    [self backBtn];
    [self topViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetNotificationAction) name:kNetworkStatusNotification object:nil];
}


/**
 监听网络
 */
- (void)resetNotificationAction {
    if (!IsNetwork) {
        self.dataArray = nil;
        [self.tableView reloadData];
        self.backView.hidden = NO;
        self.backView.noDataImage.image = [UIImage imageNamed:@"error_net"];
        self.backView.tipsLabel.text = scrollViewNoNetworkText;
        self.backView.button.hidden = NO;
    } else {
        [self initData];
    }
}


/**
 无数据占位图
 */
- (void)setEmptyDataSetView {
    self.backView = [[DIYNoDataView alloc]initWithFrame:self.tableView.bounds];
    self.backView.hidden = YES;
    self.backView.delegate = self;
    self.backView.userInteractionEnabled = YES;
    [self.tableView.tableView addSubview:self.backView ];
}

- (void)DIYNoDataViewButtonClcik {
    [self initData];
}

#pragma mark--开始搜索
- (void)startSearch:(NSString *)searchFieldText {
    [self initData];
    /*
    if (searchFieldText.length > 0) {
        [self initData];
    } else {
        [FrameBaseRequest showMessage:@"搜索"];
    }
     */
}



- (void)tableViewRequestData {
    [self initData];
}

- (void)initData {
    if (self.searchView.searchField.text.length > 0) {
        NSArray *arr = [self.searchView.searchField.text componentsSeparatedByString:@"、"];
        self.searchArray = [arr mutableCopy];
    } else {
        [self.searchArray removeAllObjects];
    }
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:@"/api/technicalManual"];
    FrameRequestURL = [NSString stringWithFormat:@"%@/%@",FrameRequestURL,self.alarmInfo.measureTagCode];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.searchArray success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            [self.tableView endOfRequest];
            return ;
        }
        NSMutableArray *dataMutableArray = [NSMutableArray array];
        if (result[@"value"] && [result[@"value"] count] > 0 &&[result[@"value"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in result[@"value"]) {
                CategoryModel *model = [CategoryModel mj_objectWithKeyValues:dict];
                NSMutableArray *listArray = [NSMutableArray array];
                if (dict[@"technicalManualList"] && [dict[@"technicalManualList"] count] > 0 && [dict[@"technicalManualList"] isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dic in dict[@"technicalManualList"]) {
                        NSLog(@"dicdicdicdic %@",dic);
                        technicalManualListModel *listModel = [technicalManualListModel mj_objectWithKeyValues:dic];
                        model.technicalManualList = listModel;
                        [listArray addObject:listModel];
                    }
                    model.technicalManualList = [listArray copy];
                }
                [dataMutableArray addObject:model];
            }
            self.backView.button.hidden = YES;
            self.backView.hidden = YES;
            self.dataArray = [dataMutableArray copy];
            [self.tableView reloadData];
        } else {
            self.backView.hidden = NO;
            self.backView.button.hidden = YES;
            self.backView.noDataImage.image = [UIImage imageNamed:@"error_date"];
            self.backView.tipsLabel.text = scrollViewNoDataText;
            self.dataArray = [dataMutableArray copy];
            [self.tableView reloadData];
        }
        [self.tableView endOfRequest];
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSMutableArray *dataMutableArray = [NSMutableArray array];
        self.dataArray = [dataMutableArray copy];
         [self.tableView reloadData];
        self.backView.hidden = NO;
        self.backView.noDataImage.image = [UIImage imageNamed:@"error_net"];
        self.backView.tipsLabel.text = scrollViewNoNetworkText;
        self.backView.button.hidden = NO;
//        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
//            [FrameBaseRequest showMessage:@"身份已过期，请重新登录"];
//            [FrameBaseRequest logout];
//            UIViewController *viewCtl = self.navigationController.viewControllers[0];
//            [self.navigationController popToViewController:viewCtl animated:YES];
//            
//            [self.tableView endOfRequest];
//            return;
//        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        [self.tableView endOfRequest];
        return ;
    }];
}


/**
搜索提示标签
 */
- (void)searchLabelData {
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:@"/api/technicalLabel/"];
//    self.alarmInfo.equipmentName
    [FrameBaseRequest getWithUrl:[NSString stringWithFormat:@"%@%@",FrameRequestURL,self.alarmInfo.equipmentName] param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [self centerViews:0];
            [self bottomView];
            [self setEmptyDataSetView];
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        NSMutableArray *labelArray = [NSMutableArray array];
        if (result[@"value"] && [result[@"value"] isKindOfClass:[NSArray class]] &&[result[@"value"] count] > 0) {
            labelArray = [result[@"value"] mutableCopy];
        }
        self.topLabelArray = [labelArray copy];
        int num;
        if (self.topLabelArray.count  > 0) {
             num = (int)self.topLabelArray.count % 4 == 0 ? (int)self.topLabelArray.count / 4 : (int)self.topLabelArray.count / 4 + 1;
        } else {
            num = 0;
        }
        CGFloat centerViewHeight = num * 50;
        [self centerViews:centerViewHeight];
        [self bottomView];
        [self setEmptyDataSetView];
        if (self.topLabelArray.count  > 0) {
            self.centerView.dataArray = self.topLabelArray;
        }
    } failure:^(NSURLSessionDataTask *error)  {
        [self centerViews:0];
        [self bottomView];
        [self setEmptyDataSetView];
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
//        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
//            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
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



#pragma mark - datasource
- (NSInteger)mTableView:(XDMultTableView *)mTableView numberOfRowsInSection:(NSInteger)section{
    CategoryModel *model = self.dataArray[section];
    NSArray *arr = (NSArray *)model.technicalManualList;
    return arr.count;
}

- (TechnicalManualTableViewCell *)mTableView:(XDMultTableView *)mTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TechnicalManualTableViewCell *cell = [mTableView dequeueReusableCellWithIdentifier:TechnicalManualTableViewCellID];
    if (cell == nil) {
        cell = [[TechnicalManualTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TechnicalManualTableViewCellID];
    }
    CategoryModel *model = self.dataArray[indexPath.section];
    NSArray *arr= (NSArray *)model.technicalManualList;
    cell.technicalManualListModel = arr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(XDMultTableView *)mTableView{
    return self.dataArray.count;
}

-(NSString *)mTableView:(XDMultTableView *)mTableView titleForHeaderInSection:(NSInteger)section{
    CategoryModel *model = self.dataArray[section];
    
    return model.category;
}


#pragma mark - delegate
- (CGFloat)mTableView:(XDMultTableView *)mTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)mTableView:(XDMultTableView *)mTableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}


- (void)mTableView:(XDMultTableView *)mTableView willOpenHeaderAtSection:(NSInteger)section{
    NSLog(@"即将展开");
}


- (void)mTableView:(XDMultTableView *)mTableView willCloseHeaderAtSection:(NSInteger)section{
    NSLog(@"即将关闭");
}

- (void)mTableView:(XDMultTableView *)mTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CategoryModel *model = self.dataArray[indexPath.section];
    NSArray *arr= (NSArray *)model.technicalManualList;
    technicalManualListModel *listModel = arr[indexPath.row];
    FilePreviewViewController *vc = [FilePreviewViewController new];
    vc.fileURLString = [NSString stringWithFormat:@"%@%@",WebHost,listModel.url];
    vc.fileName = listModel.name;
    vc.url = listModel.url;
    vc.title = listModel.name;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)clickCell:(NSString *)text isBool:(BOOL)isBool index:(nonnull NSIndexPath *)index modelArray:(nonnull NSArray *)modelArray{
    if (isBool) {
        [self.textMutableArray addObject:text];
    } else {
        [self.textMutableArray removeObject:text];
    }
    if (self.textMutableArray.count > 0) {
        for (int i = 0; i < self.textMutableArray.count; i++) {
            if (i == 0) {
                self.fieldText = self.textMutableArray[i];
            } else {
                self.fieldText =[NSString stringWithFormat:@"%@、%@",self.fieldText,self.textMutableArray[i]];
            }
        }
        self.searchView.searchField.text = self.fieldText;
    } else {
        self.searchView.searchField.text = @"";
    }
    
    //处理搜索框是否可点击逻辑
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < modelArray.count; i ++) {
        PopularModel *model = modelArray[i];
        [arr addObject:@(model.Checked)];
    }
    if ([arr containsObject:@(1)]) {
        self.searchView.searchField.enabled = NO;
    } else {
        self.searchView.searchField.enabled = YES;
    }
    
}


- (void)startRoll {
  [self.view endEditing:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



- (void)topViews {
    self.searchView = [[SearchView alloc]initWithFrame:CGRectMake(0, ZNAVViewH, WIDTH_SCREEN, 45)];
    self.searchView.delegeat = self;
    self.searchView.fieldPlaceholder = @"请输入您要搜索的内容";
    [self.view addSubview:self.searchView];
    
    /*
    CGFloat collectionViewHeihgt = 0.0;
    if (self.topLabelArray.count > 0) {
        int num = (int)self.topLabelArray.count % 4 == 0 ? (int)self.topLabelArray.count / 4 : (int)self.topLabelArray.count / 4 + 1;
        collectionViewHeihgt = num*50;
    }
    
    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.searchView.frame), WIDTH_SCREEN, collectionViewHeihgt);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
     */
}

- (void)centerViews:(CGFloat)ViewHeight {
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchView.frame)+10, WIDTH_SCREEN, 1)];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"ECECEC"];
    [self.view addSubview:self.topView];
    PopularView *centerView = [[PopularView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), WIDTH_SCREEN, ViewHeight)];
    centerView.delegate = self;
    [self.view addSubview:centerView];
    self.centerView = centerView;
}

- (void)bottomView {
    self.automaticallyAdjustsScrollViewInsets = NO;
     self.tableView = [[XDMultTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.centerView.frame), WIDTH_SCREEN, HEIGHT_SCREEN - CGRectGetMaxY(self.centerView.frame))];
    self.tableView.delegate = self;
    self.tableView.datasource = self;
    self.tableView.rollDelegate = self;
    self.tableView.autoAdjustOpenAndClose = NO;
//    _tableView.openSectionArray = [NSArray arrayWithObjects:@0, nil];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TechnicalManualTableViewCell class]) bundle:nil] forCellReuseIdentifier:TechnicalManualTableViewCellID];
    [self.view addSubview:self.tableView];

}

- (void)keyboardHide {
     [self.view endEditing:YES];
}

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

- (void)navigation {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}







/**
 处理manageInsert 与标签文字逻辑
 
 @param textViewTxt manageInsert 文字
 @param markText 标签文字
 @return manageInsert文字
 */
/*
 - (void)clickCell:(NSString *)text isBool:(BOOL)isBool{
 if (isBool) {
 self.searchView.searchField.text = [self wordProcessing:self.searchView.searchField.text markText:text];
 } else {
 self.searchView.searchField.text = [self wordProcessing:self.searchView.searchField.text markText:text];
 }
 }
- (NSString *)wordProcessing:(NSString *)textViewTxt markText:(NSString *)markText {
    return  textViewTxt = [NSString stringWithFormat:@"%@%@",textViewTxt,markText];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.topLabelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PopularCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PopularCollectionViewCellID2 forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.model = self.topLabelArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PopularModel *model = self.topLabelArray[indexPath.row];
    model.Checked = true;//!model.Checked
    [self clickCell:model.name isBool:model.Checked];
    [self.collectionView reloadData];
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
//定义每个Section 的 margin (内容整体边距设置)//分别为上、左、下、右
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath   {
    return CGSizeMake((WIDTH_SCREEN-50)/4, 30);
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        flowLayout.sectionInset =UIEdgeInsetsMake(0, 0, 0, 0);
        
        flowLayout.itemSize = CGSizeMake(100, 120);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.bounces = YES;
        _collectionView.scrollEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PopularCollectionViewCell class]) bundle:nil]  forCellWithReuseIdentifier:PopularCollectionViewCellID2];
    }
    
    return _collectionView;
}
*/
@end
