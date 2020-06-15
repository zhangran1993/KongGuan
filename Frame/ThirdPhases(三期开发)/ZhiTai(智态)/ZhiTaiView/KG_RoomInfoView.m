//
//  KG_JifangView.m
//  Frame
//
//  Created by zhangran on 2020/4/20.
//  Copyright © 2020 hibaysoft. All rights reserved.
//
#import "KG_RoomInfoView.h"
#import "KG_JifangCell.h"
#import "KG_ZhiTaiEquipCell.h"
#define rowcellCount 2
@interface  KG_RoomInfoView()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) UIButton *bgBtn ;

@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSArray *dataArray;

@end
@implementation KG_RoomInfoView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
        [self setupDataSubviews];
       
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame

{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self setupDataSubviews];
        
        self.frame = frame;
    }
    return self;
}
//初始化数据
- (void)initData {
    //    self.dataArray = [NSArray arrayWithObjects:@"1",@"2",@"3", nil];
}

//创建视图
-(void)setupDataSubviews
{
    
    
    [self addSubview:self.tableView];
    
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.mas_centerX);
//        make.centerY.equalTo(self.mas_centerY);
//        make.height.equalTo(@(SCREEN_WIDTH));
//        make.width.equalTo(@50);
//    }];
    [self.tableView reloadData];
    
}

// 背景按钮点击视图消失
- (void)buttonClickMethod :(UIButton *)btn {
    self.hidden = YES;
}

- (UITableView *)tableView {
    if (!_tableView) {
      CGRect tableViewRect = CGRectMake(0.0, 0.0, 50.0, SCREEN_WIDTH);
       _tableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
//        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        //tableview逆时针旋转90度。
        _tableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        // scrollbar 不显示
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}
-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = safeString(self.dataArray[indexPath.row][@"roomInfo"][@"alias"]);
    CGRect fontRect = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil];
    return fontRect.size.width+20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_JifangCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_JifangCell"];
    if (cell == nil) {
        cell = [[KG_JifangCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_JifangCell"];
        cell.transform = CGAffineTransformMakeRotation(M_PI / 2);
    }
    cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = safeString(self.dataArray[indexPath.row][@"roomInfo"][@"alias"]);
    if (indexPath.row == self.selIndex) {
        cell.lineView.hidden = NO;
        cell.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
        cell.titleLabel.font = [UIFont systemFontOfSize:16];
        
    }else {
        cell.lineView.hidden = YES;
        cell.titleLabel.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        cell.titleLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selIndex = (int)indexPath.row;
    if(self.didsel ){
        self.didsel(self.selIndex);
    }
    [self.tableView reloadData];
}



- (void)setPowArray:(NSArray *)powArray {
    _powArray = powArray;
    
    self.dataArray = powArray;
//
//    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.mas_centerY);
//        make.centerY.equalTo(self.mas_centerX);
//        make.height.equalTo(@(SCREEN_WIDTH));
//        make.width.equalTo(@50);
//
//    }];
    [self.tableView reloadData];
}

- (void)setSelIndex:(int)selIndex {
    _selIndex = selIndex;
    [self.tableView reloadData];
}

- (void)setRoomInfo:(NSDictionary *)roomInfo {
    _roomInfo = roomInfo;
    
    
}
@end
