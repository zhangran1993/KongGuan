//
//  KG_ZhiTaiEquipView.m
//  Frame
//
//  Created by zhangran on 2020/4/17.
//  Copyright © 2020 hibaysoft. All rights reserved.
//
#import "KG_ZhiTaiEquipView.h"

#import "KG_ZhiTaiEquipCell.h"
#define rowcellCount 2
@interface  KG_ZhiTaiEquipView()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) UIButton *bgBtn ;

@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSArray *dataArray;


@end
@implementation KG_ZhiTaiEquipView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
        [self setupDataSubviews];
        
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
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
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
-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (self.dataArray.count-1)/rowcellCount+1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_ZhiTaiEquipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_ZhiTaiEquipCell"];
    if (cell == nil) {
        cell = [[KG_ZhiTaiEquipCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_ZhiTaiEquipCell"];
    }
    //    NSDictionary *dataDic = self.dataArray[indexPath.row *2-1];
    //    cell.dataDic = dataDic;
    //
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //
    //    NSDictionary *detailDic = self.dataArray[indexPath.row *2];
    //    cell.detailDic = detailDic;
    
    
    NSUInteger row=[indexPath row];
    for (NSInteger i = 0; i < rowcellCount; i++)
    {
        
        //奇数
        if (i == 0)
        {
            
            NSDictionary *dataDic = self.dataArray[row *2 +i];
            cell.dataDic = dataDic;
            
            
        }else {
            NSDictionary *detailDic = self.dataArray[row *2 +i];
            cell.detailDic = detailDic;
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}



- (void)setPowArray:(NSArray *)powArray {
    _powArray = powArray;
    
    self.dataArray = powArray;
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(self.mas_height);
    }];
    [self.tableView reloadData];
}
@end
