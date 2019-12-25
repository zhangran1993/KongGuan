//
//  ContactManufacturerView.m
//  Frame
//
//  Created by centling on 2018/12/5.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "ContactManufacturerView.h"
#import "ContactsCell.h"
#import "UIColor+Extension.h"
#import "UIView+LX_Frame.h"
#import "ValueModel.h"
#import "TelModel.h"
#import "PersonModel.h"
#import "VenderModel.h"
static NSString *ContactsCellID = @"ContactsCellID";
@interface ContactManufacturerView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@end
@implementation ContactManufacturerView
-(instancetype)init{
    self=[super init];
    if (self) {
        self.frame=CGRectMake(0,0,WIDTH_SCREEN,HEIGHT_SCREEN);
        self.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.55f];
    }
    return self;
}


-(void)setContactManufactureArray:(NSArray *)contactManufactureArray {
    _contactManufactureArray = contactManufactureArray;
    [self.tableView reloadData];
}

//弹框显示
-(void)show{
    [UIView animateWithDuration:0.3 animations:^{
        UIWindow * window=[UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
    } completion:^(BOOL finished) {
    }];
}

//弹框隐藏
-(void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        [self removeFromSuperview];
    } completion:^(BOOL finished) {
    }];
}


- (void)InitializationListView {
    CGFloat height = (HEIGHT_SCREEN/2)-13;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(FrameWidth(70), self.center.y-(height/2), WIDTH_SCREEN - FrameWidth(140), height)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 10;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, backView.lx_width, backView.lx_height - 40) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle =NO;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ContactsCell class]) bundle:nil] forCellReuseIdentifier:ContactsCellID];
    [backView addSubview:self.tableView];
    
    UIButton *closeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), backView.lx_width, backView.lx_height - CGRectGetMaxY(self.tableView.frame))];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    closeButton.titleLabel.font = FontSize(16);
    closeButton.backgroundColor = [UIColor whiteColor];
    [closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:closeButton];
}

- (void)closeButtonClick {
    [self hide];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.lx_width, 40)];
    backView.backgroundColor = [UIColor colorWithHexString:@"F0F6FA"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.lx_width, backView.lx_height)];
    label.textColor = [UIColor colorWithHexString:@"338DE5"];;
    label.font = FontSize(16);
    label.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:label];
    ValueModel *model = _contactManufactureArray[0];
    if (section == 0) {
        PersonModel *perModel = model.person;
        label.text = perModel.name;
    } else if(section == 1){
        VenderModel *venModel = model.vender;
        label.text = venModel.name;
    }
    return backView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ValueModel *model = _contactManufactureArray[0];
    if (section == 0) {
        PersonModel *perModel = model.person;
        NSArray *arr = (NSArray *)perModel.value;
         return arr.count;
    } else {
        VenderModel *venderModel = model.vender;
        NSArray *arr = (NSArray *)venderModel.value;
        return arr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:ContactsCellID];
    cell.selectionStyle = 0;
    ValueModel *model = _contactManufactureArray[0];
    if (indexPath.section == 0) {
        PersonModel *perModel = model.person;
        NSArray *arr = (NSArray *)perModel.value;
        TelModel *model = arr[indexPath.row];
        cell.nameLabel.text = model.name;
        cell.telLabel.text = model.tel;
    } else if(indexPath.section == 1){
        VenderModel *venModel = model.vender;
        NSArray *arr = (NSArray *)venModel.value;
        TelModel *model = arr[indexPath.row];
        cell.nameLabel.text = model.name;
        cell.telLabel.text = model.tel;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hide];
    ValueModel *model = _contactManufactureArray[0];
    if (indexPath.section == 0) {
        PersonModel *perModel = model.person;
        NSArray *arr = (NSArray *)perModel.value;
        TelModel *model = arr[indexPath.row];
        [self broadcastPhoneCalls:model.tel];
    } else if(indexPath.section == 1){
        VenderModel *venModel = model.vender;
        NSArray *arr = (NSArray *)venModel.value;
        TelModel *model = arr[indexPath.row];
        [self broadcastPhoneCalls:model.tel];
    }
}


- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:kCellHighlightColor];
    
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}

/**
 拨打电话
 @param phoneNumber 手机号码
 */
- (void)broadcastPhoneCalls:(NSString *)phoneNumber {
    NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNumber];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]]];
    [self addSubview:callWebview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
