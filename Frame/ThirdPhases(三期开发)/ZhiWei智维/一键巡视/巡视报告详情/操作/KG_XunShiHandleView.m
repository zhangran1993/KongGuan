//
//  KG_XunShiHandleView.m
//  Frame
//
//  Created by zhangran on 2020/4/27.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_XunShiHandleView.h"
#import "KG_XunShiHandleCell.h"
@interface  KG_XunShiHandleView()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) UIButton *bgBtn ;

@property (nonatomic, strong) UITableView *tableView;


@end
@implementation KG_XunShiHandleView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
        [self setupDataSubviews];
        
    }
    return self;
}
- (void)initData{
    self.dataArray = [NSArray arrayWithObjects:@"修改任务",@"移交任务",@"提交任务",@"删除任务", nil];
    
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
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(176+44+3+30));
    }];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-30);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(176+44+3));
    }];
   
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
        
        
        
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        footView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 3)];
        bgView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        [footView addSubview:bgView];
        
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 3, footView.frame.size.width ,44-3 )];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [footView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(buttonClickMethod:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _tableView.tableFooterView = footView;
        
        
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
    
    KG_XunShiHandleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_XunShiHandleCell"];
    if (cell == nil) {
        cell = [[KG_XunShiHandleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_XunShiHandleCell"];
        
    }
    
    cell.titleLabel.text = safeString(self.dataArray[indexPath.row]);
    cell.titleLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    if (indexPath.row == 0) {
        cell.iconImage.image = [UIImage imageNamed:@"change_task"];
    }else if (indexPath.row == 1) {
        cell.iconImage.image = [UIImage imageNamed:@"move_task_gray"];
        cell.titleLabel.textColor = [UIColor colorWithHexString:@"#D0CFCF"];
    }else if (indexPath.row == 2) {
        cell.iconImage.image = [UIImage imageNamed:@"report_task"];
    }else if (indexPath.row == 3) {
        cell.iconImage.image = [UIImage imageNamed:@"delete_task_gray"];
        cell.titleLabel.textColor = [UIColor colorWithHexString:@"#D0CFCF"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1 ||indexPath.row == 3) {
        return;
    }
    NSString *dataStr = self.dataArray[indexPath.row];
      
    if (indexPath.row == 2) {
        [self jiaoyanTijiao];
       
    }
   
    if (self.didsel) {
        self.didsel(dataStr);
    }
    self.hidden = YES;
}



- (void)jiaoyanTijiao {
   
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcRunReport/%@",@""]];
    [FrameBaseRequest getDataWithUrl:FrameRequestURL param:nil success:^(id result) {
        
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
   
        NSLog(@"完成");
    
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSLog(@"完成");
        
    }];
}
//
//任务保存/提交/移交校验接口：
//请求地址：/intelligent/atcSafeguard/checkUpdate/{patrolId}/{oldUpdateTime}
//其中，patrolId是任务的id；
//oldUpdateTime是任务详情接口返回的taskLastUpdateTime字段，精确到ms的时间戳
//请求方式：GET
//请求返回：
//  {
//      "errCode": 0,
//      "errMsg": "",
//      "value": {
//        "isUpdateEnable": true,            //可以正常提交
//        "description": "Update Enable"
//      }
//}
//
//{
//      "errCode": 0,
//      "errMsg": "",
//      "value": {
//        "isUpdateEnable": false,            //前台提示用户是否要覆盖别人的提交
//        "description": "Someone has changed this Task"
//      }
//}

//请求地址：/intelligent/atcSafeguard/updateAtcPatrolRecode
//请求方式：POST
//请求Body：
//{
//    "id": "XXX",                                       //任务Id，必填
//    "result": "{"XXX":"XXX"}",                          //存储巡查结果
//    "status": "2",                                       //任务状态，固定为2
//    "remark": "{"XXX":"XXX"}",                         //存储备注内容
//    "patrolName": "XXX",                               //任务执行负责人Id
//    "atcPatrolLabelList": ["name": "XXX"],                 //标签列表
//"description": "XXX",                      //巡视结果，仅巡视任务支持，默认填充为空
//    "atcPatrolWorkList": ["workPersonName": "XXX"]        //执行人id列表
//}
//其中：
//result和remark采用JSONObject的数据格式，key存储父节点的id，value存内容。
//如上图片所示：
//result里面有两个key-value对，一个key是“环境内容”所在节点的id，value是“干净”；一个key是“告警延时”所在节点的id，value是“18s”。
//remark里面有两个key-value对，参考如下模板内容配置页面，一个key是“环境内容”所在节点的id，value是“环境内容巡查准确”；一个key是“台站环境巡视”所在节点的id，value是“台站环境巡查正确”。
//
//请求返回：
//如：
//{
//    "id": "0658e77a25a942fd8ae0be2ee73f658d",
//    "result": "{
//"99f29833-0c39-48f9-81b3-9246e25ee9f7":"干净",
//"233b470f-0d6f-43a6-9f35-dcaa43657e27":"18s"
//}",
//    "status": "2",
//     "description": "",
//    "remark": "{
//"99f29833-0c39-48f9-81b3-9246e25ee9f7":"环境内容巡查准确",
//"fb86ae3a-1344-42f0-8fab-636f599b694b":"台站环境巡查正确"
//}",
//    "patrolName": "c27b7e2f-cea2-4c70-8e87-4c8ee166e5ff",
//    "atcPatrolLabelList": [{"name": "DVOR"},{"name": "油机"}],
//    "atcPatrolWorkList": [{
//            "workPersonName": "1d13c2dc-fb3a-441f-976d-7a7537018245"
//         }, {
//            "workPersonName": "304df150-599b-4c60-8b36-9613d913c467"
//    }]
//}
@end
