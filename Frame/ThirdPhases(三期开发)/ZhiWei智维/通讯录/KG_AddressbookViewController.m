//
//  ViewController.m
//  WeChatContacts-demo
//
//  Created by shen_gh on 16/3/12.
//  Copyright © 2016年 com.joinup(Beijing). All rights reserved.
//

#import "KG_AddressbookViewController.h"
#import "KG_AddressbookSecondViewController.h"
#import "ContactModel.h"
#import "ContactTableViewCell.h"
#import "ContactDataHelper.h"//根据拼音A~Z~#进行排序的tool
#import "KG_ContactTopView.h"
#import "KG_AddressbookModel.h"
#import "KG_AddressbookSearchViewController.h"
@interface KG_AddressbookViewController ()
<UITableViewDelegate,UITableViewDataSource,
UISearchBarDelegate,UISearchDisplayDelegate>
{
    NSArray *_rowArr;//row arr
    NSArray *_sectionArr;//section arr
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *serverDataArr;//数据源
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) UISearchBar *searchBar;//搜索框
@property (nonatomic,strong) UISearchDisplayController *searchDisplayController;//搜索VC

@property (nonatomic, strong)   UILabel                 *titleLabel;

@property (nonatomic, strong)   UIView                  *navigationView;

@property (nonatomic, strong)   UIButton                *rightButton;
@property (nonatomic, strong)  KG_AddressbookModel *dataModel;

@property (nonatomic,strong)  NSMutableArray *contactArray;

@property (nonatomic,copy)    NSString *nameID;
@property (nonatomic,copy)    NSString *nameStr;
@property (nonatomic,copy)    NSString *searchString;

@end

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation KG_AddressbookViewController{
    NSMutableArray *_searchResultArr;//搜索结果Arr
}

#pragma mark - dataArr(模拟从服务器获取到的数据)
- (NSArray *)serverDataArr{
    if (!_serverDataArr) {
         _serverDataArr = self.contactArray;
    }
    return _serverDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNaviTopView];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBar_bg"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
   
    self.dataArr=[NSMutableArray array];
    self.dataModel = [[KG_AddressbookModel alloc]init];
   
    [self queryContactData];
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
    [self.navigationController setNavigationBarHidden:NO];
    
}
- (void)configNav{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
    [btn setBackgroundImage:[UIImage imageNamed:@"contacts_add_friend"] forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:btn]];
}




#pragma mark - setUpView
- (void)setUpView{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0.0, kScreenHeight-49.0, kScreenWidth, 49.0)];
    [imageView setImage:[UIImage imageNamed:@"footerImage"]];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    [self.view addSubview:imageView];
    
    [self.view insertSubview:self.tableView belowSubview:imageView];
}
- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        [_searchBar setBackgroundImage:[UIImage imageNamed:@"ic_searchBar_bgImage"]];
        [_searchBar sizeToFit];
        [_searchBar setPlaceholder:@"搜索"];
        [_searchBar.layer setBorderWidth:0.5];
        [_searchBar.layer setBorderColor:[UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1].CGColor];
        [_searchBar setDelegate:self];
        [_searchBar setKeyboardType:UIKeyboardTypeDefault];
    }
    return _searchBar;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.0, NAVIGATIONBAR_HEIGHT, kScreenWidth, kScreenHeight - NAVIGATIONBAR_HEIGHT) style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
        [_tableView setSectionIndexColor:[UIColor darkGrayColor]];
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        
       
        //cell无数据时，不显示间隔线
        UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView setTableFooterView:v];
    }
    return _tableView;
}

#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //section
    if (tableView==_searchDisplayController.searchResultsTableView) {
        return 1;
    }else{
        return _rowArr.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //row
    if (tableView==_searchDisplayController.searchResultsTableView) {
        return _searchResultArr.count;
    }else{
        return [_rowArr[section] count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //viewforHeader
    id label = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    if (!label) {
        label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:14.5f]];
        [label setTextColor:[UIColor grayColor]];
        [label setBackgroundColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]];
    }
    [label setText:[NSString stringWithFormat:@"  %@",_sectionArr[section+1]]];
    return label;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView!=_searchDisplayController.searchResultsTableView) {
        return _sectionArr;
    }else{
        return nil;
    }
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index-1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==_searchDisplayController.searchResultsTableView) {
        return 0;
    }else{
        return 22.0;
    }
}

#pragma mark - UITableView dataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIde=@"cellIde";
    ContactTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell==nil) {
        cell=[[ContactTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (tableView==_searchDisplayController.searchResultsTableView){
        [cell.phoneLabel setText:safeString([_searchResultArr[indexPath.row] valueForKey:@"tel"])];
        [cell.nameLabel setText:safeString([_searchResultArr[indexPath.row] valueForKey:@"name"])];
    }else{
        ContactModel *model=_rowArr[indexPath.section][indexPath.row];
        [cell.phoneLabel setText:safeString(model.tel)];
//        [cell.headImageView setImage:[UIImage imageNamed:model.portrait]];
        [cell.nameLabel setText:safeString(model.name)];
        if([self.nameID isEqualToString:safeString(model.nameID)]) {
            cell.headImageView.image = [UIImage imageNamed:@"kg_contacg_sel"];
        }else {
            cell.headImageView.image = [UIImage imageNamed:@"kg_contacg_unsel"];
        }
       
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactModel *model=_rowArr[indexPath.section][indexPath.row];
    if (self.nameID.length >0 ) {
        if ([self.nameID isEqualToString:safeString(model.nameID)]) {
            self.nameID = @"";
        }
        if ([self.nameStr isEqualToString:safeString(model.name)]) {
            self.nameStr = @"";
        }
        if (self.nameID.length == 0 && self.nameStr.length == 0) {
            [self.tableView reloadData];
            return;
        }
    }

    self.nameID = safeString(model.nameID);
    self.nameStr = safeString(model.name);
    
    [self.tableView reloadData];
}

#pragma mark searchBar delegate
//searchBar开始编辑时改变取消按钮的文字
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSArray *subViews;
    subViews = [(searchBar.subviews[0]) subviews];
    for (id view in subViews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton* cancelbutton = (UIButton* )view;
            [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
            break;
        }
    }
    searchBar.showsCancelButton = YES;
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    //取消
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
}

#pragma mark searchDisplayController delegate
- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView{
    //cell无数据时，不显示间隔线
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [tableView setTableFooterView:v];
    
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterContentForSearchText:searchString
                               scope:[self.searchBar scopeButtonTitles][self.searchBar.selectedScopeButtonIndex]];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self filterContentForSearchText:self.searchBar.text
                               scope:self.searchBar.scopeButtonTitles[searchOption]];
    return YES;
}

#pragma mark - 源字符串内容是否包含或等于要搜索的字符串内容
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSMutableArray *tempResults = [NSMutableArray array];
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    
    for (int i = 0; i < self.dataArr.count; i++) {
        NSString *storeString = [(ContactModel *)self.dataArr[i] name];
        NSString *storeImageString=[(ContactModel *)self.dataArr[i] portrait]?[(ContactModel *)self.dataArr[i] portrait]:@"";
        
        NSRange storeRange = NSMakeRange(0, storeString.length);
        
        NSRange foundRange = [storeString rangeOfString:searchText options:searchOptions range:storeRange];
        if (foundRange.length) {
            NSDictionary *dic=@{@"name":storeString,@"portrait":storeImageString};
            
            [tempResults addObject:dic];
        }
        
    }
    [_searchResultArr removeAllObjects];
    [_searchResultArr addObjectsFromArray:tempResults];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.titleLabel.text = @"联系人";
    
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
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.titleLabel.font = FontSize(16);
    
    [self.rightButton setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    [self.rightButton setTitle:@"确定" forState:UIControlStateNormal];
    
    [self.view addSubview:self.rightButton];
    
    [self.rightButton addTarget:self action:@selector(sureMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@60);
        make.centerY.equalTo(backBtn.mas_centerY);
        make.height.equalTo(@44);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
}
- (void)sureMethod {
    
    if(self.sureBlockMethod){
        
        self.sureBlockMethod(self.nameID, self.nameStr);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
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
//
//搜索/获取任务执行负责人/执行人列表，与组织结构关联（新）：
//请求地址：/intelligent/atcPatrolRecode/contactByOrg
//请求方式：POST
//请求Body：
//[{
//"name": "rootNode",     //组织结构节点id
//       "type": "eq",
//       "content": "XXX"       //获取和搜索接口均必填，默认为""即可
// },
//{
//"name": "key",          //搜索关键字，模糊搜索名字和手机号
//       "type": "eq",
//       "content": "XXX"       //搜索接口必填
//                       }]
//请求返回：
//如：默认进来时：
//[{
// "name": "rootNode",
//    "type": "eq",
//    "content": ""

//获取联系人列表
- (void)queryContactData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = @"rootNode";
    params[@"type"] = @"eq";
    params[@"content"] = @"";
    NSMutableArray *paraArr = [NSMutableArray arrayWithCapacity:0];
    [paraArr addObject:params];
    
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/atcPatrolRecode/contactByOrg"]];
    [MBProgressHUD showHUDAddedTo:JSHmainWindow animated:YES];
    [FrameBaseRequest postWithUrl:FrameRequestURL param:paraArr success:^(id result) {
        [MBProgressHUD hideHUD];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            return ;
        }
        [self.dataModel mj_setKeyValues:result[@"value"]];
        
        
        for (int i =0; i<self.dataModel.contacts.count; i++) {
            contacts *contact = self.dataModel.contacts[i];
            NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:0];
            [parDic setValue:safeString(contact.name) forKey:@"name"];
            [parDic setValue:safeString(contact.tel) forKey:@"tel"];
            [parDic setValue:[NSNumber numberWithInt:i] forKey:@"portrait"];
            [parDic setValue:safeString(contact.id) forKey:@"nameID"];
            [self.contactArray addObject:parDic];
        }
        for (NSDictionary *subDic in self.serverDataArr) {
            ContactModel *model=[[ContactModel alloc]initWithDic:subDic];
            [self.dataArr addObject:model];
        }
        
        
        _rowArr=[ContactDataHelper getFriendListDataBy:self.dataArr];
        _sectionArr=[ContactDataHelper getFriendListSectionBy:[_rowArr mutableCopy]];
        
        //configNav
        [self configNav];
        //布局View
        [self setUpView];
        //
        //    _searchDisplayController=[[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
        //    [_searchDisplayController setDelegate:self];
        //    [_searchDisplayController setSearchResultsDataSource:self];
        //    [_searchDisplayController setSearchResultsDelegate:self];
        //
        _searchResultArr=[NSMutableArray array];
        [self refreshPageView];
        [self.tableView reloadData];
        
        NSLog(@"1");
    }  failure:^(NSError *error) {
        NSLog(@"请求失败 原因：%@",error);
        [MBProgressHUD hideHUD];
        if([[NSString stringWithFormat:@"%@",error] rangeOfString:@"unauthorized"].location !=NSNotFound||[[NSString stringWithFormat:@"%@",error] rangeOfString:@"forbidden"].location !=NSNotFound){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutMethod" object:self];
            return;
        }
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    } ];
}

- (void)refreshPageView {
    float height = self.dataModel.orgInfo.count *72;
    float secHeight = 0;
    for (orgInfo *info in self.dataModel.orgInfo) {
        secHeight += info.subOrgInfo.count *44;
    }
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height + secHeight +40)];
    KG_ContactTopView *topView = [[KG_ContactTopView alloc]init];
    topView.model = self.dataModel;
    topView.searchMethod = ^(NSString * _Nonnull searchStr) {
      KG_AddressbookSearchViewController *vc = [[KG_AddressbookSearchViewController alloc]init];
        vc.didselBlock = ^(NSString * _Nonnull nameID, NSString * _Nonnull name) {
            self.nameStr = safeString(name);
            self.nameID = safeString(nameID);
            [self.tableView reloadData];
            /* 滚动指定段的指定row  到 指定位置*/
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        };
      [self.navigationController pushViewController:vc animated:YES];
        
    };
    topView.pushToNextPage = ^(NSInteger selSection, NSInteger selIndex) {
        
        KG_AddressbookSecondViewController *vc = [[KG_AddressbookSecondViewController alloc]init];
       
        NSArray *arr = self.dataModel.orgInfo;
        if (arr.count) {
            orgInfo *orgInfo = arr[selSection];
            NSArray *secArr = orgInfo.subOrgInfo;
            if (secArr.count) {
                NSDictionary *secDic = secArr[selIndex];
                NSString *secID = safeString(secDic[@"orgId"]);
                vc.strID = secID;
                NSString *secName = safeString(secDic[@"orgName"]);
                vc.secondTitle = secName;
            }
        }
        
        [self.navigationController pushViewController:vc animated:YES];
        
    };
    [headView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left);
        make.right.equalTo(headView.mas_right);
        make.top.equalTo(headView.mas_top);
        make.bottom.equalTo(headView.mas_bottom);
    }];
    
    
    _tableView.tableHeaderView = headView;
}
-(NSMutableArray *)contactArray{
    if (!_contactArray) {
        _contactArray = [[NSMutableArray alloc]init];
    }
    return _contactArray;
}
@end
