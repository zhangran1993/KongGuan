//
//  FrameScrollList.m
//  Frame
//
//  Created by zhangran on 2020/3/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "FrameScrollList.h"
#import "FrameScrollListCell.h"
#import "KG_ScrollListModel.h"
#import "KG_ScrollListDetailModel.h"
@interface FrameScrollList ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray; //当前的数据源

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *bigArray;
@property (nonatomic, strong) NSMutableArray *dataDetailArray;
@property (nonatomic, strong) NSMutableArray *nextArray;

@property (nonatomic, strong) NSMutableArray *shouqiArray;
@end

@implementation FrameScrollList


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initData];
        [self setupDataSubviews];
        [self getStationCagetoryData];
    }
    return self;
}

//初始化数据
- (void)initData {
    
}

//创建视图
-(void)setupDataSubviews
{
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
  
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 44)];
    NSDictionary *headDic = [self.nextArray[section] firstObject][@"title"];
    if (isSafeDictionary(headDic)) {
         headLabel.text = [NSString stringWithFormat:@"%@",headDic[@"name"]] ;
    }
   
    headLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    [headView addSubview:headLabel];
    headLabel.numberOfLines = 1;
    headLabel.textAlignment = NSTextAlignmentLeft;
    headLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    
    
    UIImageView *jiantouImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-20-4, 20, 4, 4)];
    jiantouImage.image = [UIImage imageNamed:@"gray_jiantou"];
    [headView addSubview:jiantouImage];
    
    UIButton *shouqiBtn = [[UIButton alloc]initWithFrame:CGRectMake(jiantouImage.frame.origin.x-2-70, 9, 70, 26)];
    if ([self.shouqiArray[section] isEqualToString:@"0"]) {
        [shouqiBtn setTitle:@"展开全部" forState:UIControlStateNormal];
        jiantouImage.image = [UIImage imageNamed:@"gray_jiantou"];
        
    }else {
        [shouqiBtn setTitle:@"收起" forState:UIControlStateNormal];
        jiantouImage.image = [UIImage imageNamed:@"grayup_jiantou"];
    }
    
    shouqiBtn.tag = section;
    [headView addSubview:shouqiBtn];
    [shouqiBtn setTitleColor:[UIColor colorWithHexString:@"#626470"] forState:UIControlStateNormal];
    shouqiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [shouqiBtn addTarget:self action:@selector(zhankaiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
   
    
    return headView;
    
}
//展开或者收起
- (void)zhankaiButtonClick:(UIButton *)button {
    int tag = (int)button.tag;
    if ([self.shouqiArray[tag] isEqualToString:@"0"]) {
        [self.shouqiArray replaceObjectAtIndex:tag withObject:@"1"];
    }else {
        [self.shouqiArray replaceObjectAtIndex:tag withObject:@"0"];
    }
    [self.tableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    footView.backgroundColor = [UIColor colorWithHexString:@"#EFEFF4"];
    return footView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.nextArray.count;
}
#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.dataArray.count;
    NSArray *array = self.nextArray[section];
    if (array.count >2 && [self.shouqiArray[section] isEqualToString:@"0"]) {
       return 2;
    }
    return array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FrameScrollListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FrameScrollListCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FrameScrollListCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *dataArray = self.nextArray[indexPath.section];
    
    NSDictionary *dataDic = dataArray[indexPath.row][@"detail"];
    cell.dataDic = dataDic;
    cell.backgroundColor = [UIColor whiteColor];
    
    [cell.watchVideoButton addTarget:self action:@selector(didPingJiaButton: event:) forControlEvents:UIControlEventTouchUpInside];
    cell.watchVideoButton.tag = indexPath.section;
    return cell;
}
//查看视频
- (void)didPingJiaButton:(UIButton *)sender event:(id)event{
    
    NSSet *touches=[event allTouches];
    
    UITouch *touch=[touches anyObject];
    
    CGPoint cureentTouchPosition=[touch locationInView:self.tableView];
    
    //得到indexPath
    NSIndexPath *indexPath=[self.tableView indexPathForRowAtPoint:cureentTouchPosition];
    
    NSArray *array = self.nextArray;
    NSDictionary *dic = array[indexPath.section][indexPath.row][@"detail"][@"station"];
    
    if (self.watchVideo) {
        self.watchVideo(dic[@"code"], dic[@"name"]);
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",(long)indexPath.row);
    NSArray *listArr = self.nextArray[indexPath.section];
    NSDictionary *dataD = listArr[indexPath.row];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]initWithDictionary:dataD[@"detail"][@"station"]];
      for (NSString*s in [dataDic allKeys]) {
          if ([dataDic[s] isEqual:[NSNull null]]) {
              [dataDic setObject:@"" forKey:s];
          }
      }
      
      
      NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
      [userDefaults setObject:dataDic forKey:@"station"];
      [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (self.selStation) {
        self.selStation();
    }
}

-(UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView

{
    if(scrollView.contentOffset.y <0){
        
        NSLog(@"%f",scrollView.contentOffset.y);
        if (scrollView.contentOffset.y <-100) {
            if (self.sliderDown) {
                self.sliderDown(YES);
            }
        }
        
    }else if(scrollView.contentOffset.y> 0){
        
        NSLog(@"%f",scrollView.contentOffset.y);
        
        
    }
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
   NSLog(@"1");
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
   NSLog(@"2");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"3");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"4");
}

//获取台站分类接口
- (void)getStationCagetoryData {
    
    //    NSString *  FrameRequestURL = [WebHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcDictionary?type_code=%@",@"stationCategory"]];
    
    
//    NSString *  FrameRequestURL = @"http://10.33.33.147:8089/intelligent/atcDictionary?type_code=stationCategory";
    //    __weak typeof(self) weakSelf = self;
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcDictionary?type_code=stationCategory"]];
    [FrameBaseRequest getDataWithUrl:FrameRequestURL param:nil success:^(id result) {
        
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        self.bigArray = [KG_ScrollListModel mj_objectArrayWithKeyValuesArray:[result objectForKey:@"value"]] ;
        [self getStationCagetoryDetailData];
        NSLog(@"");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        
        
    }];
}

//获取台站分类详情接口
- (void)getStationCagetoryDetailData {
    
    //    NSString *  FrameRequestURL = [WebHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcDictionary?type_code=%@",@"stationCategory"]];
    
    
//    NSString *  FrameRequestURL = @"http://10.33.33.147:8089/intelligent/api/stationList";
    //    __weak typeof(self) weakSelf = self;
     NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/api/stationList"]];
    [FrameBaseRequest getDataWithUrl:FrameRequestURL param:nil success:^(id result) {
        
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        self.dataDetailArray = [KG_ScrollListDetailModel mj_objectArrayWithKeyValuesArray:[result objectForKey:@"value"]] ;
        [self getFinalData];
        
        NSLog(@"");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        
        
    }];
}

- (void)getFinalData {
    [self.nextArray removeAllObjects];
    NSMutableArray *finalArray = [[NSMutableArray alloc] init];
    
    for (KG_ScrollListModel *model in self.bigArray) {
        NSMutableArray *smallArray = [[NSMutableArray alloc] init];
        for (KG_ScrollListDetailModel *detailModel in self.dataDetailArray) {

            if ([model.code isEqualToString:detailModel.station[@"category"]]) {
                NSMutableDictionary *finalDic = [[NSMutableDictionary alloc]initWithCapacity:0];

                [finalDic setValue:[detailModel mj_keyValues] forKey:@"detail"];
                [finalDic setValue:[model mj_keyValues] forKey:@"title"];
               
                [smallArray addObject:finalDic];
            }

        }

        [finalArray addObject:smallArray];

    }
    [self.nextArray addObjectsFromArray:finalArray];
    for (int i=0;i<self.nextArray.count;i++) {
        [self.shouqiArray addObject:@"0"];
    }
    
    [self.tableView reloadData];
    
    NSLog(@"1");
    
}

- (NSMutableArray *)bigArray
{
    if (!_bigArray) {
        _bigArray = [[NSMutableArray alloc] init];
    }
    return _bigArray;
}

- (NSMutableArray *)dataDetailArray
{
    if (!_dataDetailArray) {
        _dataDetailArray = [[NSMutableArray alloc] init];
    }
    return _dataDetailArray;
}
- (NSMutableArray *)nextArray
{
    if (!_nextArray) {
        _nextArray = [[NSMutableArray alloc] init];
    }
    return _nextArray;
}
- (NSMutableArray *)shouqiArray
{
    if (!_shouqiArray) {
        _shouqiArray = [[NSMutableArray alloc] init];
    }
    return _shouqiArray;
}

- (void)setRefreshData:(NSString *)refreshData {
    _refreshData = refreshData;
    if ([refreshData isEqualToString:@"YES"]) {
       
        [self getStationCagetoryData];
    }
}
@end
