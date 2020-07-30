//
//  KG_GaoJingDetailViewController.m
//  Frame
//
//  Created by zhangran on 2020/5/20.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_GaoJingDetailViewController.h"
#import "KG_GaoJingDetailFirstCell.h"
#import "KG_GaoJingDetailSecondCell.h"
#import "KG_GaoJingDetailThirdCell.h"
#import "KG_GaoJingFourthCell.h"
#import "KG_GaoJingDetailFifthCell.h"
#import "KG_GaoJingDetailSixthCell.h"
#import "KG_ResultPromptViewController.h"
#import "KG_GaoJingDetailModel.h"
#import "KG_ControlGaoJingAlertView.h"
#import "StationVideoListController.h"
#import "KG_RunZhiYunViewController.h"
#import "KG_ReViewPhotoView.h"
#import <AVKit/AVKit.h>
@interface KG_GaoJingDetailViewController ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate>


@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *videoArray;

@property (nonatomic, strong) KG_GaoJingDetailModel *dataModel;

@property (nonatomic, copy) NSString *recordDescription;

@property (nonatomic, strong) NSMutableDictionary *paramDic;

@property (nonatomic, copy) NSString *removeStartTime;
@property (nonatomic, copy) NSString *removeEndTime;

@property (nonatomic, strong) KG_ReViewPhotoView *rePhotoView;
@property (nonatomic, strong)  UILabel   *titleLabel;
@property (nonatomic, strong)  UIView    *navigationView;
@property (nonatomic, assign)   BOOL fixStatus;

@property (nonatomic, assign)   AVPlayerViewController *playerViewController;
@end

@implementation KG_GaoJingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self initViewData];
    [self createNaviTopView];
    [self createTableView];
    [self getData];
}
- (void)refreshGetData {
    NSString *idCode = safeString(self.model.id);
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/keepInRepair/getAlarmInfo/%@",idCode]];
   
    [FrameBaseRequest getDataWithUrl:FrameRequestURL param:nil success:^(id result) {
        [MBProgressHUD hideHUD];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        self.dataModel = nil;
        self.dataModel = [[KG_GaoJingDetailModel alloc]init];
        [self.imageArray removeAllObjects];
        [self.videoArray removeAllObjects];
        [self.dataModel mj_setKeyValues:result[@"value"]];
        self.recordDescription = safeString(self.dataModel.info[@"recordDescription"]);
        for (NSDictionary *dic in self.dataModel.image) {
            NSString *urlString = [NSString stringWithFormat:@"%@",dic[@"url"]];
            
            [self.imageArray addObject:urlString];
        }
        for (NSDictionary *dic1 in self.dataModel.videos) {
            NSString *urlString = [NSString stringWithFormat:@"%@",dic1[@"url"]];
            
            [self.videoArray addObject:urlString];
        }
        
        [self.tableView reloadData];
        
        
        NSLog(@"");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        
    }];
}
//获取某个告警详情信息：
//请求地址：/intelligent/keepInRepair/getAlarmInfo/{id}
//请求方式：GET
//请求返回：
//如： /intelligent/keepInRepair/getAlarmInfo/5835280f-57f7-4ecd-a2ca-477389e6a27e

- (void)getData {
    
    NSString *idCode = safeString(self.model.id);
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/keepInRepair/getAlarmInfo/%@",idCode]];
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest getDataWithUrl:FrameRequestURL param:nil success:^(id result) {
        [MBProgressHUD hideHUD];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        self.dataModel = nil;
        self.dataModel = [[KG_GaoJingDetailModel alloc]init];
        [self.imageArray removeAllObjects];
        [self.videoArray removeAllObjects];
        [self.dataModel mj_setKeyValues:result[@"value"]];
        self.recordDescription = safeString(self.dataModel.info[@"recordDescription"]);
        for (NSDictionary *dic in self.dataModel.image) {
            NSString *urlString = [NSString stringWithFormat:@"%@",dic[@"url"]];
            
            [self.imageArray addObject:urlString];
        }
        for (NSDictionary *dic1 in self.dataModel.videos) {
            NSString *urlString = [NSString stringWithFormat:@"%@",dic1[@"url"]];
            
            [self.videoArray addObject:urlString];
        }
        
        [self.tableView reloadData];
        
        
        NSLog(@"");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        
    }];
}

- (void)initViewData{
    
}

- (void)createNaviTopView {
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
    self.titleLabel.text = @"告警详情";
    
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
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillAppear");
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    [self.navigationController setNavigationBarHidden:YES];
    
    
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



-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createTableView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.navigationView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        
        
    }
    return _tableView;
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        KG_GaoJingDetailFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_GaoJingDetailFirstCell"];
        if (cell == nil) {
            cell = [[KG_GaoJingDetailFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_GaoJingDetailFirstCell"];
            
        }
        //确认
        cell.confirmMethod = ^{
            [self confirmData];
        };
        //解除
        cell.removeMethod = ^{
            [self removeData];
        };
        //挂起
        cell.hangupMethod = ^{
            [self hangupData];
            
        };
        cell.model = self.dataModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.section == 1) {
        KG_GaoJingDetailSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_GaoJingDetailSecondCell"];
        if (cell == nil) {
            cell = [[KG_GaoJingDetailSecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_GaoJingDetailSecondCell"];
            
        }
        cell.clickToVideo = ^{
            StationVideoListController  *StationVideo = [[StationVideoListController alloc] init];
            StationVideo.station_code = safeString(self.dataModel.info[@"stationCode"]);
            StationVideo.station_name = safeString(self.dataModel.info[@"stationName"]);
            [self.navigationController pushViewController:StationVideo animated:YES];
        };
        cell.clickToYun = ^{
            KG_RunZhiYunViewController  *yunVC = [[KG_RunZhiYunViewController alloc] init];
            yunVC.isPush = YES;
            [self.navigationController pushViewController:yunVC animated:YES];
        };
        cell.clickToGuZhang = ^{
            NSLog(@"跳转故障通告");
        };
        cell.clickToHuiZhen = ^{
            NSLog(@"跳转远程会诊");
        };
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.section == 2) {
        KG_GaoJingDetailThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_GaoJingDetailThirdCell"];
        if (cell == nil) {
            cell = [[KG_GaoJingDetailThirdCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_GaoJingDetailThirdCell"];
            
        }
        cell.model = self.dataModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.section == 3) {
        KG_GaoJingFourthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_GaoJingFourthCell"];
        if (cell == nil) {
            cell = [[KG_GaoJingFourthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_GaoJingFourthCell"];
            
        }
        cell.dataArray = self.imageArray;
        cell.addMethod = ^{
            [self pushTZImagePickerController];
        };
        cell.closeMethod = ^(NSInteger index) {
            [self updateDetailInfo];
            NSLog(@"%@",self.imageArray);
        };
        cell.addVideoMethod = ^{
            [self pushTZVideoPickerController];
        };
        cell.playVideoMethod = ^(NSString * _Nonnull dataDic) {
            [self playVideo:dataDic];
        };
        cell.closeVideoMethod = ^(NSInteger index) {
            [self updateDetailInfo];
            NSLog(@"%@",self.videoArray);
        };
        cell.zhankaiMethod = ^(NSString * _Nonnull dataDic) {
        
            NSLog(@"%@",dataDic);
            [self zhankaiImage:dataDic];
        };
        
        cell.videoArray = self.videoArray;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.section == 4) {
        KG_GaoJingDetailFifthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_GaoJingDetailFifthCell"];
        if (cell == nil) {
            cell = [[KG_GaoJingDetailFifthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_GaoJingDetailFifthCell"];
            
        }
        cell.model = self.dataModel;
        if (self.recordDescription.length >0) {
            cell.recordDescription = self.recordDescription;
        }
        cell.fixMethod = ^{
            KG_ResultPromptViewController *vc = [[KG_ResultPromptViewController alloc]init];
            vc.textString = ^(NSString * _Nonnull textStr) {
                self.fixStatus = YES;
                self.recordDescription = textStr;
                
                [self updateDetailInfo];
            };
            vc.model = self.dataModel;
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.section == 5) {
        KG_GaoJingDetailSixthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_GaoJingDetailSixthCell"];
        if (cell == nil) {
            cell = [[KG_GaoJingDetailSixthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_GaoJingDetailSixthCell"];
            
        }
        cell.model = self.dataModel;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    return nil;
    
}

- (void)playVideo:(NSString *)dic {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", dic]];
    self.playerViewController = [[AVPlayerViewController alloc] init];
    self.playerViewController.player= [[AVPlayer alloc]initWithURL:url];
    [self.playerViewController.player play];
    [self presentViewController:self.playerViewController animated:YES completion:nil];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 174;
    }else if (indexPath.section == 1) {
        return 136;
    }else if (indexPath.section == 2) {
        return 131  ;
    }else if (indexPath.section == 3) {
        return 317;
    }else if (indexPath.section == 4) {
        return 104;
    }else if (indexPath.section == 5) {
        return self.dataModel.log.count *60+44;
    }
    return 0;
}

- (void)getTask:(NSDictionary *)dataDic {
    NSString *userID = [UserManager shareUserManager].userID ;
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/atcSafeguard/updateAtcPatrolRecode",WebNewHost];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
     paramDic[@"id"] = safeString(dataDic[@"id"]);
     paramDic[@"patrolName"] = safeString(userID);
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:paramDic success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //    NSString *str = self.dataArray[indexPath.row];
    
}


- (NSMutableArray *)videoArray {
    
    if (!_videoArray) {
        _videoArray = [[NSMutableArray alloc] init];
    }
    return _videoArray;
}
- (NSMutableArray *)imageArray {
    
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}
- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    return footView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    return headView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001;
}

#pragma mark - UIImagePickerController
- (void)pushTZImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:5 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.isSelectOriginalPhoto = NO;//禁止选择原图
    imagePickerVc.allowTakePicture = YES;// 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = NO;// 在内部显示拍视频按
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.maxImagesCount = 1;
    imagePickerVc.allowPickingVideo = NO;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        NSLog(@"%@",photos);
        
         [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
        [self.tableView reloadData];
        [self upDateHeadIcon:[photos firstObject]];
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
//- (void)uploadImageSourece:(NSString *)filename {
//
//    //    /
//    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/meetRecodeMedia/setAtcAlarmManager",WebNewHost];
//    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
//    paramDic[@"file"] = filename;
//
//    [FrameBaseRequest postWithUrl:FrameRequestURL param:paramDic success:^(id result) {
//        NSInteger code = [[result objectForKey:@"errCode"] intValue];
//        if(code  <= -1){
//            [FrameBaseRequest showMessage:result[@"errMsg"]];
//
//            return ;
//        }
//
//
//    } failure:^(NSError *error)  {
//        FrameLog(@"请求失败，返回数据 : %@",error);
//
//        [FrameBaseRequest showMessage:@"网络链接失败"];
//        return ;
//    }];
//}
#pragma mark - UIImagePickerController
- (void)pushTZVideoPickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:5 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.isSelectOriginalPhoto = NO;//禁止选择原图
    imagePickerVc.allowTakePicture = YES;// 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = NO;// 在内部显示拍视频按
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.maxImagesCount = 1;
    imagePickerVc.allowPickingImage = NO;
    //    [imagePickerVc didFinishPickingVideoHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
    //        NSLog(@"%@",photos);
    //        [self.videoArray removeAllObjects];
    //        [self.videoArray addObjectsFromArray:photos];
    //        [self.tableView reloadData];
    //    }];
    [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
        NSLog(@"%@",coverImage);
        
        
        [self.tableView reloadData];
        //        [self submitVideo:coverImage]
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"1");
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    PHAsset *asset = [assets firstObject];
    NSArray *resources = [PHAssetResource assetResourcesForAsset:asset];
    NSString *orgFilename = ((PHAssetResource*)resources[0]).originalFilename;
    
    
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    NSLog(@"1");
}
//- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker __attribute__((deprecated("Use -tz_imagePickerControllerDidCancel:.")));
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    NSLog(@"1");
}
- (void)upDateHeadIcon:(UIImage *)photo{
    
    //请求地址
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/meetRecodeMedia/setAtcAlarmManager",WebNewHost];
    //photo.压缩
    NSData * datapng = UIImageJPEGRepresentation(photo, 0.3);
   
    //请求设置
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
    //manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //[manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Accept"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",  @"text/html", @"image/jpeg",  @"image/png", @"application/octet-stream", @"text/json",@"multipart/form-data",@"application/x-www-form-urlencoded", nil];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:FrameRequestURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:datapng//datapng
                                    name:@"file"
                                fileName:@"file.jpg"
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        NSLog(@"请求中：%@",uploadProgress);
        //打印下上传进度
    } success:^(NSURLSessionDataTask *_Nonnull task,id _Nullable responseObject) {
        NSLog(@"请求success %@",responseObject );
        [MBProgressHUD hideHUD];
        if(![[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"errCode"]]  isEqual: @"0"]){
            NSLog(@"请求失败%@",[responseObject objectForKey:@"errMsg"]);
            
        }
        NSDictionary *response = [responseObject objectForKey:@"value"];
        NSLog(@"OK请求成功：%@",response);
        [self.imageArray addObject:[NSString stringWithFormat:@"%@%@",WebNewHost,response[@"url"]]];
        [self.tableView reloadData];
        [self updateDetailInfo];
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"_Nonnull error：%@",error);
        [MBProgressHUD hideHUD];
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return;
        //上传失败
    }];
    
    return ;
    
}

- (void)updateDetailInfo {
    
    //    请求地址：/intelligent/keepInRepair/saveAlarmInfo
    //    请求方式：POST
    //    请求内容：
    //    {
    //          "id": "XXX",                   //告警事件的id，必填
    //          "recordDescription": "XXX",      //处理描述的内容
    //          "videosList": ["XXX"],           //上传视频后返回的URL地址
    //          "imageList": ["XXX"],           //上传图片后返回的URL地址
    //          "recordStatus": "XXX"           //处理流程状态的编码
    //           //默认初始值：unconfirmed，同告警状态status的默认初始值。
    //           //告警确认：confirmed。后台会将该告警状态同步到流程处理状态。
    //           //应急处理：emergency，后台会设置处理流程状态。
    //           //故障通告：announce，后台会设置处理流程状态。
    //           //设备排故：shooting，后台会设置处理流程状态。
    //           //告警解决：completed。后台会将该处理流程状态同步到告警状态。
    //    }
    NSString *idCode = safeString(self.model.id);
    
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/keepInRepair/saveAlarmInfo",WebNewHost];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    paramDic[@"id"] = idCode;
    paramDic[@"recordDescription"] = safeString(self.recordDescription) ;
    paramDic[@"videosList"] = self.videoArray;
    paramDic[@"imageList"] = self.imageArray;
    paramDic[@"recordStatus"] =safeString(self.dataModel.info[@"recordStatus"]) ;
   
    [FrameBaseRequest postWithUrl:FrameRequestURL param:paramDic success:^(id result) {
        [MBProgressHUD hideHUD];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        if (self.fixStatus) {
            
            [FrameBaseRequest showMessage:@"修改成功"];
            self.fixStatus = NO;
        }else {
            if([UserManager shareUserManager].isDeletePicture) {
                [FrameBaseRequest showMessage:@"删除成功"];
            }else {
                [FrameBaseRequest showMessage:@"上传成功"];
            }
        }
        [self refreshGetData];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}

-(void)submitVideo:(NSURL *)videourl{
    //请求地址
    NSString *FrameRequestURL = [WebNewHost stringByAppendingString:@"/intelligent/meetRecodeMedia/setAtcAlarmVideo"];
    
    
    //    NSString *urlString = [NSString stringWithFormat:@"%@%@",WebNewHost,str];
    
    //    NSURL *videourl = [NSURL URLWithString:urlString];
    
    NSString * thisUrl = [NSString stringWithFormat:@"%@",videourl];
    if ([thisUrl hasPrefix:@"/img/video"]) {
        NSMutableDictionary *mediaInfo = [NSMutableDictionary dictionary];
        
        mediaInfo[@"url"] = thisUrl;
        
    }
    //    [MBProgressHUD showMessage:@""];
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
        [MBProgressHUD hideHUD];
        if(![[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"errCode"]]  isEqual: @"0"]){
            NSLog(@"请求失败%@",[responseObject objectForKey:@"errMsg"]);
            [MBProgressHUD hideHUD];
            [FrameBaseRequest showMessage:[responseObject objectForKey:@"errMsg"]];
            return ;
        }
        NSDictionary *response = [responseObject objectForKey:@"value"];
        [self.videoArray addObject:[NSString stringWithFormat:@"%@%@",WebNewHost,response[@"url"]]];
        [self.tableView reloadData];
        [self updateDetailInfo];
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"error ：%@",error);
        [MBProgressHUD hideHUD];
        [FrameBaseRequest showMessage:@"网络链接失败"];
        //上传失败
    }];
    
}

// If user picking a video and allowPickingMultipleVideo is NO, this callback will be called.
// If allowPickingMultipleVideo is YES, will call imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:
// 如果用户选择了一个视频且allowPickingMultipleVideo是NO，下面的代理方法会被执行
// 如果allowPickingMultipleVideo是YES，将会调用imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset{
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            AVURLAsset *urlAsset = (AVURLAsset *)asset;
            NSURL *sourceURL = urlAsset.URL;
            
            [self submitVideo:sourceURL];
            
        }];
    }
    
    
    //
    //
    //    NSArray *resources = [PHAssetResource assetResourcesForAsset:asset];
    //    NSString *orgFilename = ((PHAssetResource*)resources[0]).originalFilename;
    //
}

// If user picking a gif image and allowPickingMultipleVideo is NO, this callback will be called.
// If allowPickingMultipleVideo is YES, will call imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:
// 如果用户选择了一个gif图片且allowPickingMultipleVideo是NO，下面的代理方法会被执行
// 如果allowPickingMultipleVideo是YES，将会调用imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:
- (void)imagePickerController:(TZImagePickerController *)picker{
    
}
-(void)dealloc
{
    [super dealloc];
    //第一种方法.这里可以移除该控制器下的所有通知
    //移除当前所有通知
    NSLog(@"移除了所有的通知");
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
//确认
- (void)confirmData {
    if ([safeString(self.dataModel.info[@"status"]) isEqualToString:@"removed"]) {
        [FrameBaseRequest showMessage:@"该告警状态为:已解除,不能确认"];
        return;
    }
    //    确认某个告警事件
    //    前提：告警事件没有被挂起，并且告警事件状态是未确认
    //     {
    //         "id": "XXX",          //告警事件的id，必填
    //         "status":"confirmed"    //告警确认状态的编码，固定值，必填
    //    }
    [self.paramDic removeAllObjects];
    NSDictionary *dic = self.dataModel.info;
    if ([safeString(dic[@"hangupStatus"]) boolValue] == NO && [safeString(dic[@"status"]) isEqualToString:@"unconfirmed" ] ){
        
        self.paramDic[@"id"] = safeString(dic[@"id"]);
        self.paramDic[@"status"] = @"confirmed";
        [self queryData];
        
    }else {
        
    }
}
//解除
- (void)removeData {
    if ([safeString(self.dataModel.info[@"status"]) isEqualToString:@"removed"]) {
        [FrameBaseRequest showMessage:@"该告警状态为:已解除,不能解除"];
        return;
    }
    KG_ControlGaoJingAlertView *view = [[KG_ControlGaoJingAlertView alloc]init];
    [JSHmainWindow addSubview:view];
    view.selTime = ^(NSString * _Nonnull timeStr, int index) {
        
        if (index == 0) {
            self.removeStartTime = timeStr;
        }else {
            self.removeEndTime = timeStr;
        }
    };
    view.sureMethod = ^{
        [self.paramDic removeAllObjects];
        NSDictionary *dic = self.dataModel.info;
        
        if (![safeString(dic[@"status"]) isEqualToString:@"removed"]){
            
            self.paramDic[@"id"] = safeString(dic[@"id"]);
            self.paramDic[@"status"] = @"removed";
            NSString *startStr = safeString(self.removeStartTime);
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-ddTHH:mm:ssZ"];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
            NSDate *startDate = [dateFormatter dateFromString:startStr];
            
            NSString *endStr= safeString(self.removeEndTime);
            NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"yyyy-MM-ddTHH:mm:ssZ"];
            [dateFormatter1 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
            NSDate *endDate = [dateFormatter1 dateFromString:endStr];
            
            
            self.paramDic[@"suppressStartTime"] = startDate ;
            self.paramDic[@"suppressEndTime"] = endDate;
            
            [self queryData];
        }
    };
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo([UIApplication sharedApplication].keyWindow.mas_left);
        make.right.equalTo([UIApplication sharedApplication].keyWindow.mas_right);
        make.top.equalTo([UIApplication sharedApplication].keyWindow.mas_top);
        make.bottom.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom);
    }];
    
    //    解除某个告警事件
    //    前提：告警事件状态不是已解除。如果告警事件已挂起，则解除挂起，并解除告警。
    //     {
    //         "id": "XXX",               //告警事件的id，必填
    //         "status":"removed",          //告警已解除状态的编码，固定值，必填
    //         "suppressStartTime":"XXX",  //告警抑制开始时间，如："2020-04-15 17:30:00"
    //    //JAVA中Date数据类型格式
    //         "suppressEndTime": "XXX"   //告警抑制结束时间，如："2020-04-20 17:30:00"
    //    //JAVA中Date数据类型格式
    
    
}
//挂起
- (void)hangupData {
    //     挂起某个告警事件
    //    前提：告警事件状态是未确认，或者已确认，并且事件尚为挂起
    //     {
    //         "id": "XXX",          //告警事件的id，必填
    //         "status":"",            //告警事件的状态编码，为空即可，必填
    //         "hangUp": true         //挂起标志，固定值，必填
    //    }
    if ([safeString(self.dataModel.info[@"status"]) isEqualToString:@"removed"]) {
        [FrameBaseRequest showMessage:@"该告警状态为:已解除,不能挂起"];
        return;
    }
    
    [self.paramDic removeAllObjects];
    NSDictionary *dic = self.dataModel.info;
    if ([safeString(dic[@"hangupStatus"]) boolValue] == NO &&( [safeString(dic[@"status"]) isEqualToString:@"unconfirmed"] ||[safeString(dic[@"status"]) isEqualToString:@"confirmed"])){
        
        self.paramDic[@"id"] = safeString(dic[@"id"]);
        self.paramDic[@"status"] = @"";
        self.paramDic[@"hangUp"] = @"true";
        [self queryData];
        
    }else if ([safeString(dic[@"hangupStatus"]) boolValue] == YES){
        self.paramDic[@"id"] = safeString(dic[@"id"]);
        self.paramDic[@"status"] = @"";
        self.paramDic[@"hangUp"] = @"false";
        [self queryData];
    }
    //    解除挂起某个告警事件
    //    前提：告警事件已被挂起
    //     {
    //         "id": "XXX",          //告警事件的id，必填
    //         "status":"",            //告警事件的状态编码，为空即可，必填
    //         "hangUp": false        //解除挂起标志，固定值，必填
    //    }
    
}

- (NSMutableDictionary *)paramDic
{
    if (!_paramDic) {
        _paramDic = [[NSMutableDictionary alloc] init];
    }
    return _paramDic;
}

- (void)queryData {
    NSString *FrameRequestURL = [NSString stringWithFormat:@"%@/intelligent/keepInRepair/handleAlarmStatus",WebNewHost];
    
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:self.paramDic success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        [MBProgressHUD hideHUD];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            
            return ;
        }
        NSString *status = safeString(self.paramDic[@"status"]);
        if ([status isEqualToString:@"removed"]) {
            [FrameBaseRequest showMessage:@"解除成功"];
        }else {
            [FrameBaseRequest showMessage:@"操作成功"];
        }
        [self getData];
        
    } failure:^(NSError *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        [MBProgressHUD hideHUD];
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    }];
}

- (void)zhankaiImage:(NSString *)str {
    if(str.length == 0){
        return;
    }
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:str]];
    UIImage *image = imageView.image;
    KG_ReViewPhotoView *review = [[KG_ReViewPhotoView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) Photo:image];
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionReveal;
    transition.duration = 0.5;
    [review.layer addAnimation:transition forKey:nil];
    [self.navigationController.view addSubview:review];
    review.longpressblock =^(UIImage *blockimage) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"保存图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *savephotoAction = [UIAlertAction actionWithTitle:@"保存到本地" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), NULL);
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVc addAction:savephotoAction];
        [alertVc addAction:cancelAction];
        [self.navigationController presentViewController:alertVc animated:YES completion:^{
            
        }];
  
    };
}

// 指定回调方法
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"保存成功");
}

@end
