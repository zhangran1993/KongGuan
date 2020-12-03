//
//  KG_NewScreenViewController.m
//  Frame
//
//  Created by zhangran on 2020/8/18.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_EquipmentHistoryScreenViewController.h"
#import "KG_EquipmentHistoryEquScreenCell.h"
#import "KG_WeiHuCardAlertHeaderView.h"
#import "KG_NewScreenSelTimeCell.h"
#import "KG_NewScreenHeaderView.h"

@interface KG_EquipmentHistoryScreenViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{

}
@property (nonatomic,strong)        UICollectionView  *collectionView;

/** 数组 */
@property(nonatomic , strong)       NSMutableArray    *dataArray;

@property (nonatomic, strong)       UILabel           *titleLabel;

@property (nonatomic, strong)       UIView            *navigationView;

@property (nonatomic, strong)       UIButton          *rightButton;

@end

@implementation KG_EquipmentHistoryScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNaviTopView];
    [self createTopView];
    [self initCollevtionView];
    [self createBottomView];
    [self queryData];
}

-(void)createTopView {
    
    UIView *lineView = [[UIView alloc]init];
    [self.view addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@10);
        make.top.equalTo(self.navigationView.mas_bottom);
    }];
    
    UILabel *topLabel = [[UILabel alloc]init];
    [self.view addSubview:topLabel];
    topLabel.text = @"选择设备";
    topLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    topLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@44);
        make.top.equalTo(lineView.mas_bottom);
    }];
    
}

//初始化collectionview
- (void)initCollevtionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 12;
    flowLayout.minimumInteritemSpacing = 2;
    flowLayout.sectionInset = UIEdgeInsetsMake(5.0, 16.0, 5.0, 16.0);
    flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 50);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom).offset(54);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-70-Height_BottomBar);
    }];
    [self.collectionView registerClass:[KG_WeiHuCardAlertHeaderView class]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"KG_WeiHuCardAlertHeaderView"];
    [self.collectionView registerClass:[KG_EquipmentHistoryEquScreenCell class] forCellWithReuseIdentifier:@"KG_EquipmentHistoryEquScreenCell"];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.scrollEnabled = YES;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDictionary *dataDic = self.dataArray[section];
    
    NSArray *arr = dataDic[@"mainEquipmentList"];
    return arr.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.collectionView) {
       
        KG_EquipmentHistoryEquScreenCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KG_EquipmentHistoryEquScreenCell" forIndexPath:indexPath];
      
        NSDictionary *dataDic = self.dataArray[indexPath.section];
        NSArray *arr = dataDic[@"mainEquipmentList"];
        
        NSDictionary *detailDic = arr[indexPath.row];
        cell.dataDic = detailDic;
        if (self.selStr.length >0) {
            cell.selStr =self.selStr;
        }
        [cell.btn addTarget:self action:@selector(onTouchBtnInCell:) forControlEvents:(UIControlEventTouchUpInside)];
               
        return cell;
    }
    return nil;
    
}

#pragma mark  定义每个UICollectionViewCell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    return CGSizeMake((SCREEN_WIDTH -32-30)/3,38);
    
}

#pragma mark - collectionView代理方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ldsection-===-----------",(long)indexPath.section);
    NSLog(@"%ldrow====-----------",(long)indexPath.row);
    
}
/**数组  */
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)createNaviTopView {
    
    UIImageView *topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT +44)];
    [self.view addSubview:topImage1];
    topImage1.backgroundColor  =[UIColor whiteColor];
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 44)];
    [self.view addSubview:topImage];
    topImage.backgroundColor  =[UIColor whiteColor];
    topImage.image = [self createImageWithColor:[UIColor whiteColor]];
    /** 导航栏 **/
    self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_NavBar)];
    self.navigationView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.navigationView];
    
    /** 添加标题栏 **/
    [self.navigationView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navigationView.mas_centerX);
        make.top.equalTo(self.navigationView.mas_top).offset(Height_StatusBar+9);
    }];
    self.titleLabel.text = @"筛选";
    
    /** 返回按钮 **/
    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, (Height_NavBar -44)/2, 44, 44)];
    [backBtn addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.left.equalTo(self.navigationView.mas_left);
    }];
    
    //按钮设置点击范围扩大.实际显示区域为图片的区域
    UIImageView *leftImage = [[UIImageView alloc] init];
    leftImage.image = IMAGE(@"back_black");
    [backBtn addSubview:leftImage];
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backBtn.mas_centerX);
        make.centerY.equalTo(backBtn.mas_centerY);
    }];
    
}

- (void)backButtonClick:(UIButton *)button {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

/** 标题栏 **/
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (void)createBottomView {
    
    UIView *bottomView = [[UIView alloc]init];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-Height_BottomBar);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@70);
    }];
    
    
    UIView *lineView = [[UIView alloc]init];
    [bottomView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@10);
        make.left.equalTo(bottomView.mas_left);
        make.right.equalTo(bottomView.mas_right);
        make.top.equalTo(bottomView.mas_top);
    }];
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    [bottomView addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#2F5ED1"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    cancelBtn.layer.cornerRadius =4 ;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.borderColor = [[UIColor colorWithHexString:@"#2F5ED1"] CGColor];
    cancelBtn.layer.borderWidth = 1;
    [cancelBtn setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    [cancelBtn addTarget:self action:@selector(cancelMethod:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).offset(16);
        make.top.equalTo(lineView.mas_bottom).offset(10);
        make.width.equalTo(@(SCREEN_WIDTH/2-5-16));
        make.height.equalTo(@40);
    }];
    
    UIButton *confirmBtn = [[UIButton alloc]init];
    [bottomView addSubview:confirmBtn];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    confirmBtn.layer.cornerRadius =4 ;
    confirmBtn.layer.masksToBounds = YES;
    
    [confirmBtn addTarget:self action:@selector(confirmMethod:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView.mas_right).offset(-16);
        make.top.equalTo(lineView.mas_bottom).offset(10);
        make.width.equalTo(@(SCREEN_WIDTH/2-5-16));
        make.height.equalTo(@40);
    }];
    
}

//取消
- (void)cancelMethod:(UIButton *)button {
    
     [self.navigationController popViewControllerAnimated:YES];
}

//确认
- (void)confirmMethod:(UIButton *)button {
    
    if (self.confirmBlockMethod) {
        self.confirmBlockMethod(safeString(self.selStr),self.dataArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    if (kind == UICollectionElementKindSectionHeader) {
       
        KG_WeiHuCardAlertHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"KG_WeiHuCardAlertHeaderView" forIndexPath:indexPath];
        headerView.titleLabel.alpha = 1;
        
        NSDictionary *dataDic = self.dataArray[indexPath.section];
        headerView.titleLabel.text = safeString(dataDic[@"categoryName"]);
        
        return headerView;
    }
    return nil;
}

- (UIImage*)createImageWithColor: (UIColor*) color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//请求地址：/intelligent/atcEquipment/mainDevices/{stationCode}
//         其中，stationCode是台站的编码
//请求方式：GET

- (void)queryData {
    
    NSDictionary *currentDic = [UserManager shareUserManager].currentStationDic;
    if (currentDic.count == 0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if([userDefaults objectForKey:@"station"]){
            currentDic = [userDefaults objectForKey:@"station"];
        }else {
            NSArray *stationArr = [UserManager shareUserManager].stationList;
            
            if (stationArr.count >0) {
                currentDic = [stationArr firstObject][@"station"];
            }
        }
    }
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcEquipment/mainDevices/%@",safeString(currentDic[@"code"])]];
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        [MBProgressHUD hideHUD];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            
            return ;
        }
        self.dataArray = result[@"value"];
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask *error)  {
        [MBProgressHUD hideHUD];
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [FrameBaseRequest showMessage:@"身份已过期，请重新登录！"];
            [FrameBaseRequest logout];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.slideMenuController showViewController:login];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
        return ;
    }];
    
}

- (void)onTouchBtnInCell:(UIButton *)sender {
    
    CGPoint point = sender.center;
    
    point = [self.collectionView convertPoint:point fromView:sender.superview];
    
    NSIndexPath* indexpath = [self.collectionView indexPathForItemAtPoint:point];
    
    NSLog(@"%ld",(long)indexpath.row);
    NSLog(@"%ld",(long)indexpath.section);
    
    NSDictionary *dataDic = self.dataArray[indexpath.section];
    
    NSArray *arr = dataDic[@"mainEquipmentList"];
    
    NSDictionary *detailDic = arr[indexpath.row];
    
    if (safeString(detailDic[@"name"]).length >0) {
        if ([self.selStr isEqualToString:safeString(detailDic[@"name"])]) {
            self.selStr = @"";
        }else {
            
            self.selStr = safeString(detailDic[@"name"]);
        }
    }
    
    [self.collectionView reloadData];
    
}

@end
