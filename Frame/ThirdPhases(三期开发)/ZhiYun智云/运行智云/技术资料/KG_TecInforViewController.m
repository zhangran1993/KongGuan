//
//  KG_TecInforViewController.m
//  Frame
//
//  Created by zhangran on 2020/5/20.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_TecInforViewController.h"
#import "KG_TechInfoCell.h"
#import "KG_StandardSpecificationViewController.h"
@interface KG_TecInforViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
}

@property (nonatomic, strong) NSMutableArray            *dataArray;
@property (nonatomic, strong) NSArray                   *listArray;
@property (nonatomic, strong) UITableView               *tableView;


@property (nonatomic, strong)   UILabel                 *titleLabel;

@property (nonatomic, strong)   UIView                  *navigationView;

@property (nonatomic, strong)  NSIndexPath  *editingIndexPath;

@end

@implementation KG_TecInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNaviTopView];
    [self initViewData];
    [self queryData];
    
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillAppear");
    if (@available(iOS 13.0, *)){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    }else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self.navigationController setNavigationBarHidden:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    
    
}
- (void)initViewData {
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    [dic1 setObject:@"标准规范" forKey:@"title"];
    [dic1 setObject:@"biaozhun_icon" forKey:@"icon"];
    
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    [dic2 setObject:@"操作指引" forKey:@"title"];
    [dic2 setObject:@"caozuo_icon" forKey:@"icon"];
    
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
    [dic3 setObject:@"地空通讯技术资料" forKey:@"title"];
    [dic3 setObject:@"dikong_icon" forKey:@"icon"];
    
    NSMutableDictionary *dic4 = [NSMutableDictionary dictionary];
    [dic4 setObject:@"导航设备资料" forKey:@"title"];
    [dic4 setObject:@"daohangshebei_icon" forKey:@"icon"];
    
    NSMutableDictionary *dic5 = [NSMutableDictionary dictionary];
    [dic5 setObject:@"平面通讯技术资料" forKey:@"title"];
    [dic5 setObject:@"pingmian_icon" forKey:@"icon"];
    
    NSMutableDictionary *dic6 = [NSMutableDictionary dictionary];
    [dic6 setObject:@"应急操作指引" forKey:@"title"];
    [dic6 setObject:@"yingji_icon" forKey:@"icon"];
    
    NSMutableDictionary *dic7 = [NSMutableDictionary dictionary];
    [dic7 setObject:@"监视设备资料" forKey:@"title"];
    [dic7 setObject:@"jianshi_icon" forKey:@"icon"];
    
    NSMutableDictionary *dic8 = [NSMutableDictionary dictionary];
    [dic8 setObject:@"设备维护规程" forKey:@"title"];
    [dic8 setObject:@"shebei_icon" forKey:@"icon"];
    
    [self.dataArray addObject:dic1];
    [self.dataArray addObject:dic2];
    [self.dataArray addObject:dic3];
    [self.dataArray addObject:dic4];
    [self.dataArray addObject:dic5];
    [self.dataArray addObject:dic6];
    [self.dataArray addObject:dic7];
    [self.dataArray addObject:dic8];
    
    [self createTableView];
}

- (void)createTableView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(NAVIGATIONBAR_HEIGHT);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.tableView reloadData];
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
    self.titleLabel.text = @"技术资料";
    
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

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 8;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        
        
    }
    return _tableView;
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_TechInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_TechInfoCell"];
    if (cell == nil) {
        cell = [[KG_TechInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_TechInfoCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    cell.dataDic = dataDic;
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count != self.listArray.count) {
        return;
    }
    NSDictionary *dataDic = self.listArray[indexPath.row];
    KG_StandardSpecificationViewController *vc = [[KG_StandardSpecificationViewController alloc]init];
    vc.dataDic = dataDic;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    //    NSString *str = self.dataArray[indexPath.row];
    
}
//请求地址：/intelligent/atcDictionary?type_code=technicalInfomationType
//请求方式：GET
//请求返回：

- (void)queryData {
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcDictionary?type_code=technicalInfomationType"]];
    
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            
            return ;
        }
        
        self.listArray = result[@"value"];
        
        
    } failure:^(NSURLSessionDataTask *error)  {
        [MBProgressHUD hideHUD];
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)error.response;
        if (responses.statusCode == 401||responses.statusCode == 402||responses.statusCode == 403) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
            
        }else if(responses.statusCode == 502){
            
        }
        return ;
    }];
}

- (NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    // delete action
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"DeleteLabel", @"") handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                          {
        [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
        
    }];
    
    // read action
    // 根据cell当前的状态改变选项文字
    NSInteger index = indexPath.section;
    
    NSString *readTitle =@"Read";
    
    // 创建action
    UITableViewRowAction *readAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:readTitle handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                        {
        [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
        
    }];
    
    return @[deleteAction, readAction];
}

- (void)configSwipeButtons
{
    // 获取选项按钮的reference
    if (@available(iOS 11.0, *))
    {
        // iOS 11层级 (Xcode 9编译): UITableView -> UISwipeActionPullView
        for (UIView *subview in self.tableView.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")] && [subview.subviews count] >= 2)
            {
                // 和iOS 10的按钮顺序相反
                UIButton *deleteButton = subview.subviews[1];
                UIButton *readButton = subview.subviews[0];
                
                [self configDeleteButton:deleteButton];
                [self configReadButton:readButton];
            }
        }
    }
    else
    {
        // iOS 8-10层级: UITableView -> UITableViewCell -> UITableViewCellDeleteConfirmationView
        KG_TechInfoCell *tableCell = [self.tableView cellForRowAtIndexPath:self.editingIndexPath];
        for (UIView *subview in tableCell.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")] && [subview.subviews count] >= 2)
            {
                UIButton *deleteButton = subview.subviews[0];
                UIButton *readButton = subview.subviews[1];
                
                [self configDeleteButton:deleteButton];
                [self configReadButton:readButton];
                [subview setBackgroundColor:[UIColor colorWithHexString:@"#E5E8E8"]];
            }
        }
    }
    
    //    [self configDeleteButton:deleteButton];
    //    [self configReadButton:readButton];
}
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.editingIndexPath = indexPath;
    [self.view setNeedsLayout];   // 触发-(void)viewDidLayoutSubviews
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.editingIndexPath = nil;
}

- (void)configDeleteButton:(UIButton*)deleteButton
{
    if (deleteButton)
    {
        [deleteButton.titleLabel setFont:[UIFont fontWithName:@"SFUIText-Regular" size:12.0]];
        [deleteButton setTitleColor:[UIColor colorWithHexString:@"D0021B"] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"Delete_icon_.png"] forState:UIControlStateNormal];
        [deleteButton setBackgroundColor:[UIColor  colorWithHexString:@"E5E8E8"]];
        // 调整按钮上图片和文字的相对位置（该方法的实现在下面）
        [self centerImageAndTextOnButton:deleteButton];
    }
}

- (void)configReadButton:(UIButton*)readButton
{
    if (readButton)
    {
        [readButton.titleLabel setFont:[UIFont fontWithName:@"SFUIText-Regular" size:12.0]];
        [readButton setTitleColor:[UIColor  colorWithHexString:@"4A90E2"] forState:UIControlStateNormal];
        
        UIImage *readButtonImage = [UIImage imageNamed: @"Mark_as_unread_icon_.png"];
        [readButton setImage:readButtonImage forState:UIControlStateNormal];
        
        [readButton setBackgroundColor:[UIColor  colorWithHexString:@"E5E8E8"]];
        // 调整按钮上图片和文字的相对位置（该方法的实现在下面）
        [self centerImageAndTextOnButton:readButton];
    }
}
- (void)centerImageAndTextOnButton:(UIButton*)button
{
    // this is to center the image and text on button.
    // the space between the image and text
    CGFloat spacing = 35.0;
    
    // lower the text and push it left so it appears centered below the image
    CGSize imageSize = button.imageView.image.size;
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered above the text
    CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
    button.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
    
    // increase the content height to avoid clipping
    CGFloat edgeOffset = (titleSize.height - imageSize.height) / 2.0;
    button.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);
    
    // move whole button down, apple placed the button too high in iOS 10
    if (@available(iOS 11.0, *)){
        
        CGRect btnFrame = button.frame;
        btnFrame.origin.y = 18;
        button.frame = btnFrame;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"想写什么都行";
}
- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos){// delete action
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action,__kindof UIView * _Nonnull sourceView,void (^ _Nonnull completionHandler)(BOOL)) {
        [tableView setEditing:NO animated:YES];// 这句很重要，退出编辑模式，隐藏左滑菜单
       
    }];
    
    UISwipeActionsConfiguration *actions = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    actions.performsFirstActionWithFullSwipe = NO;
    return actions;
}
@end
