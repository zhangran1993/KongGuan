//
//  StationMachineInfoListController.m
//  Frame
//
//  Created by hibayWill on 2018/5/5.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "StationMachineInfoListController.h"
#import "FrameBaseRequest.h"
#import <UIImageView+WebCache.h>
#import "MachineItems.h"

#import <MJExtension.h>

@interface StationMachineInfoListController ()<UITableViewDataSource,UITableViewDelegate>


@property NSMutableArray <MachineItems *> *objects;


@property(nonatomic) UITableView *tableview;
@property(nonatomic) UIView *machineStatusMain;

@end

@implementation StationMachineInfoListController

#pragma mark - 全局常量



#pragma mark - life cycle 生命周期方法

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backBtn];
    
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title = [NSString stringWithFormat:@"%@-%@",_machineDetail[@"station_name"],_machineDetail[@"machine_name"]];//详情
    //[NSString stringWithFormat:@"%@-%@",_machineDetail[@"roomName"],_machineDetail[@"alias"]];
    [self setupTable];
}
#pragma mark - private methods 私有方法

- (void)setupTable{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    
    //UPS状态
    UIView *machineStatusView = [[UIView alloc]initWithFrame:CGRectMake(0,9, WIDTH_SCREEN, 50)];
    machineStatusView.backgroundColor = [UIColor whiteColor];
 
    [self.view addSubview:machineStatusView];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(75), 0, WIDTH_SCREEN, FrameWidth(77)+2)];
    title.font = FontSize(14);
    title.text = [NSString stringWithFormat:@"%@-%@",_machineDetail[@"roomName"],_machineDetail[@"alias"]];//@"UPS状态";
    title.textColor = [UIColor colorWithHexString:@"#24252A"];
    [machineStatusView addSubview:title];//station_right
    
    
    //UPS图片
    
    
    UIImageView *nowMachine = [[UIImageView alloc] initWithFrame:CGRectMake(FrameWidth(20), FrameWidth(18), FrameWidth(45), FrameWidth(45))];
    nowMachine.backgroundColor = [UIColor clearColor];
    NSString * img1 = @"device_UPS";
    if([AllEquipment indexOfObject:_machineDetail[@"category"]] != NSNotFound){
        img1 = _machineDetail[@"category"];
        
    }
    nowMachine.image = [UIImage imageNamed:img1];
    [machineStatusView addSubview:nowMachine];
    
    float moreheight = FrameWidth(900);
    if(HEIGHT_SCREEN == 812){
        moreheight = -FrameWidth(1100);
    }
    
    [nowMachine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(machineStatusView.mas_left).offset(21);
        make.top.equalTo(machineStatusView.mas_top).offset(17);
        make.width.equalTo(@11);
        make.height.equalTo(@16);
    }];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(nowMachine.mas_right).offset(6);
           make.top.equalTo(machineStatusView.mas_top).offset(14);
           make.width.equalTo(@200);
           make.height.equalTo(@21);
       }];
    UIImageView *lineImage = [[UIImageView alloc]init];
    [machineStatusView addSubview:lineImage];
    lineImage.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(machineStatusView.mas_left).offset(16);
        make.right.equalTo(machineStatusView.mas_right).offset(-14);
        make.bottom.equalTo(machineStatusView.mas_bottom);
    }];
    
    _machineStatusMain = [[UIView alloc]initWithFrame:CGRectMake(0, machineStatusView.frame.origin.y + machineStatusView.frame.size.height + FrameWidth(20) , WIDTH_SCREEN , HEIGHT_SCREEN - kDefectHeight - machineStatusView.frame.origin.y - machineStatusView.frame.size.height - FrameWidth(20))];
    
    _machineStatusMain.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_machineStatusMain];
    
    
    [_machineStatusMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(machineStatusView.mas_bottom).offset(20);
        make.left.equalTo(machineStatusView.mas_left);
        make.right.equalTo(machineStatusView.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kDefectHeight-20);
    }];
    
    
    
    //去除分割线
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0,0 ,SCREEN_WIDTH,_machineStatusMain.frame.size.height - FrameWidth(10))];
    self.tableview.delegate =self;
    self.tableview.dataSource =self;
    self.tableview.separatorStyle = NO;
    [_machineStatusMain addSubview:self.tableview];
    [self.tableview reloadData];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_machineStatusMain.mas_top);
        make.left.equalTo(_machineStatusMain.mas_left);
        make.width.equalTo(_machineStatusMain.mas_width);
        make.right.equalTo(_machineStatusMain.mas_right);
        make.bottom.equalTo(_machineStatusMain.mas_bottom);
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationMachineInfoListController viewWillDisappear");
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    // NSLog(@"viewDidAppear");
    
}
-(void)viewDidDisappear:(BOOL)animated{
    
}
-(void)viewWillLayoutSubviews{
    // NSLog(@"viewWillLayoutSubviews");
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //if(self.detail[indexPath.row].typeid==1){
    if(indexPath.row==0){
        return  allHeight;//+
    }
    return 0;
}

#pragma mark - UITableviewDatasource 数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *thiscell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN)];
    thiscell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
    
    
    
    
    
    
    
    UIView *InView = [[UIView alloc]init];
    
    self.objects =  [[MachineItems class] mj_objectArrayWithKeyValuesArray: _machineDetail[@"tagList"]];
    
    
    CGFloat neworign_y = 0;
    if(self.objects.count > 0){
        //NSInteger rowCount = _objects2.count;
        for (int i=0; i<self.objects.count; ++i) {
            neworign_y =  i * 50;
            
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(38, neworign_y, FrameWidth(195),50)];
            nameLabel.font = FontSize(14);
            nameLabel.text =[self.objects[i].name isEqual:[NSNull null]]? @"":self.objects[i].name;
            nameLabel.numberOfLines = 0;
            nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
            nameLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
            [InView addSubview:nameLabel];
            
            UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -100-17-16, neworign_y, 100, 50)];
            numLabel.font = FontSize(14);
            numLabel.textAlignment = NSTextAlignmentRight;
            NSString * unit = [CommonExtension isEmptyWithString:   self.objects[i].unit]?@"":self.objects[i].unit;
            numLabel.text =[NSString stringWithFormat:@"%@%@",[CommonExtension isEmptyWithString:  self.objects[i].tagValue ]? @"":self.objects[i].tagValue,unit];
            numLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
            [InView addSubview:numLabel];
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(380), neworign_y, FrameWidth(200), FrameWidth(70))];
            titleLabel.font = FontSize(16);
            titleLabel.textAlignment = NSTextAlignmentCenter;
            NSString *bottomLimit = @"";
            NSString *topLimit = @"";
            if([FrameBaseRequest isPureInt:self.objects[i].bottomLimit]){
                bottomLimit = [NSString stringWithFormat:@"%0.1f",[self.objects[i].bottomLimit floatValue]];
                topLimit = [NSString stringWithFormat:@"%0.1f",[self.objects[i].topLimit floatValue]];
            }else{
                bottomLimit = [CommonExtension isEmptyWithString:  self.objects[i].bottomLimit]? @"":self.objects[i].bottomLimit;
                topLimit = [CommonExtension isEmptyWithString:  self.objects[i].topLimit ]? @"":self.objects[i].topLimit;
            }
            titleLabel.text =  [NSString stringWithFormat:@"%@%@~%@%@",bottomLimit,unit,topLimit,unit];
            if(![self.objects[i].category isEqualToString:@"switchQuantity"]){
                //暂时隐藏
                //[InView addSubview:titleLabel];
            }
            
            UIImageView * typeImg = [[UIImageView alloc]initWithFrame:CGRectMake(23, neworign_y+22, 6, 6)];
            typeImg.backgroundColor = [UIColor colorWithHexString:@"#95A8D7"];
            typeImg.layer.cornerRadius = 3.f;
            typeImg.layer.masksToBounds = YES;
            [InView addSubview:typeImg];
            
//            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(25), neworign_y + FrameWidth(70), FrameWidth(500), 1)];
//            lineLabel.backgroundColor = BGColor;
//            [InView addSubview:lineLabel];
//
            
            if(self.objects[i].alarmStatus){
                typeImg.backgroundColor = [UIColor colorWithHexString:@"#F11B3D"];
                titleLabel.textColor = [UIColor colorWithHexString:@"#F11B3D"];
                nameLabel.textColor = [UIColor colorWithHexString:@"#F11B3D"];
                numLabel.textColor = [UIColor colorWithHexString:@"#F11B3D"];
            }
            
        }
    }
    [InView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100+neworign_y)];
    
    
    
    allHeight = InView.frame.size.height ;
    float MainHeight = allHeight;
    if(MainHeight > FrameWidth(900)){
        MainHeight = FrameWidth(900);
    }
    [_machineStatusMain setFrame:CGRectMake(_machineStatusMain.frame.origin.x, _machineStatusMain.frame.origin.y, _machineStatusMain.frame.size.width, HEIGHT_SCREEN - kDefectHeight - _machineStatusMain.frame.origin.y -10)];
    [_machineStatusMain mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(60);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kDefectHeight-20);
    }];
    [self.tableview setFrame:CGRectMake(self.tableview.frame.origin.x, self.tableview.frame.origin.y, self.tableview.frame.size.width, HEIGHT_SCREEN - kDefectHeight - self.tableview.frame.origin.y)];
    [self.tableview mas_updateConstraints:^(MASConstraintMaker *make) {
          make.top.equalTo(_machineStatusMain.mas_top);
          make.left.equalTo(_machineStatusMain.mas_left);
          make.width.equalTo(_machineStatusMain.mas_width);
          make.right.equalTo(_machineStatusMain.mas_right);
          make.bottom.equalTo(_machineStatusMain.mas_bottom);
      }];
    [thiscell addSubview:InView];
    
    
    return thiscell;
    
    
}


#pragma mark - UITableviewDelegate 代理方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 点击了第indexPath.row行Cell所做的操作
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了第%ld行Cell所做的操作",(long)indexPath.row);
}


#pragma mark - 请求数据方法
/**
 *  发送请求并获取数据方法
 */
-(void)backBtn{
    UIButton *leftButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButon.frame = CGRectMake(0,0,FrameWidth(60),FrameWidth(60));
    [leftButon setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
    [leftButon setContentEdgeInsets:UIEdgeInsetsMake(0, - FrameWidth(20), 0, FrameWidth(20))];
    //button.alignmentRectInsetsOverride = UIEdgeInsetsMake(0, offset, 0, -(offset));
    [leftButon addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc]initWithCustomView:leftButon];
    self.navigationItem.leftBarButtonItem = fixedButton;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FontSize(18),NSForegroundColorAttributeName:[UIColor blackColor]}] ;
}
-(void)backAction {
    //[self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
@end



