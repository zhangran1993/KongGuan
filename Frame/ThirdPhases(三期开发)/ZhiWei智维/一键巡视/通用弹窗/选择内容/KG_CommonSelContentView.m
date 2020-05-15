//
//  KG_CommonSelContentView.m
//  Frame
//
//  Created by zhangran on 2020/4/27.
//  Copyright © 2020 hibaysoft. All rights reserved.
//
#import "KG_CommonSelContentView.h"
#import "KG_ComminSelContentCell.h"
@interface  KG_CommonSelContentView()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) UIButton *bgBtn ;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

@end
@implementation KG_CommonSelContentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
        [self setupDataSubviews];
        [self getContentData];
        
    }
    return self;
}
//初始化数据
- (void)initData {
    self.dataArray = [NSArray arrayWithObjects:@"选择内容模块",@"环境情况",@"动力情况",@"设备情况",@"其他", nil];
}

//创建视图
-(void)setupDataSubviews
{
    //按钮背景 点击消失
    self.bgBtn = [[UIButton alloc]init];
    [self addSubview:self.bgBtn];
    [self.bgBtn setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    self.bgBtn.alpha = 0.46;
    [self.bgBtn addTarget:self action:@selector(buttonClickMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    UIView *centerView = [[UIView alloc] init];
    centerView.frame = CGRectMake(52.5,209,270,234);
    centerView.backgroundColor = [UIColor whiteColor];
    centerView.layer.cornerRadius = 12;
    centerView.layer.masksToBounds = YES;
    [self addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset((SCREEN_WIDTH -270)/2);
        make.top.equalTo(self.mas_top).offset((SCREEN_HEIGHT -254)/2);;
        make.width.equalTo(@270);
        make.height.equalTo(@254);
       
    }];
    [centerView addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(centerView.mas_bottom).offset(-10);
        make.right.equalTo(centerView.mas_right);
        make.left.equalTo(centerView.mas_left);
        make.width.equalTo(centerView.mas_width);
        make.top.equalTo(centerView.mas_top).offset(10);
    }];
    
    
    [self.tableView reloadData];
    

}



// 背景按钮点击视图消失
- (void)buttonClickMethod :(UIButton *)btn {
    self.hidden = YES;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        
    }
    return _tableView;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_ComminSelContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_ComminSelContentCell"];
    if (cell == nil) {
        cell = [[KG_ComminSelContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_ComminSelContentCell"];
        
    }
    
    cell.titleLabel.text = safeString(self.dataArray[indexPath.row]);
    if (indexPath.row == 0) {
        cell.titleLabel.textColor = [UIColor colorWithHexString:@"#030303"];
        cell.titleLabel.font = [UIFont systemFontOfSize:18];
    }else {
        cell.titleLabel.textColor = [UIColor colorWithHexString:@"#004EC4"];
        cell.titleLabel.font = [UIFont systemFontOfSize:17];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
 


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    NSString *str = self.dataArray[indexPath.row];
   
    if (self.didsel) {
        self.didsel(str);
    }
    self.hidden = YES;
}
//intelligent/atcSafeguard/insertTourOrMaintain
//{
//    "stationCodeList":["XXX"],       //台站编码，必填，目前仅支持单个台站
//    "engineRoomCodeList":["XXX"],  //机房编码列表，必填，从上一接口的roomInfo获取
//    "planStartTime":"XXX",          //任务时间，必填，java中Date类型
////从上一接口的intervalTimeList获取
//    "planFinishTime":null,            //该字段为空即可
//    "patrolName":"XXX",      //执行负责人Id，从获取任务执行负责人/执行人列表接口获取
//    "typeCode":"oneTouchTour",       //固定，必填
//    "patrolCode":"normalInspection",   //固定，必填
//    "patrolId":"XXX",               //任务模板Id，必填，从上一接口的id获取
//    "taskName":"XXX"              //任务名称，必填
//}
- (void)getContentData {
    NSString *taskId = @"";
    NSString *stationCode = @"";
    NSString *FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcSafeguard/getPatrolInfoTitleList/%@/%@",taskId,stationCode]];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        
        NSLog(@"1");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
        
    }];
}
@end
