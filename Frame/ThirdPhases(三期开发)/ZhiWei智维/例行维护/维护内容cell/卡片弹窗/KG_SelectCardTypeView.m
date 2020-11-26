//
//  KG_SelectCardTypeView.m
//  Frame
//
//  Created by zhangran on 2020/7/24.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_SelectCardTypeView.h"

@interface KG_SelectCardTypeView ()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *bgBtn ;
@end

@implementation KG_SelectCardTypeView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDataSubviews];
        
    }
    return self;
}

- (void)setupDataSubviews {
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
    
    [self addSubview:self.tableView];
    self.tableView.layer.borderWidth = 0.5;
    self.tableView.layer.borderColor = [[UIColor colorWithHexString:@"#E6E8ED"] CGColor];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@100);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    [self.dataArray addObject:@"完成"];
    [self.dataArray addObject:@"未完成"];
    
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

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    cell.textLabel.text = self.dataArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    }else {
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = safeString(self.dataArray[indexPath.row]);
    
    NSDictionary *dd = [self.dataDic[@"childrens"] firstObject];
    
    NSString *infoId = safeString(dd[@"parentId"]);
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setValue:safeString(str) forKey:safeString(infoId)];
    if (self.didselTextBlock) {
        self.didselTextBlock(dic);
    }
    self.hidden = YES;
}

- (void)buttonClickMethod:(UIButton *)btn {
    self.hidden = YES;
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    NSDictionary *dd = [self.dataDic[@"childrens"] firstObject];
    
    //判断是四级还是五级模板
    
    if([safeString(dd[@"levelMax"]) isEqualToString:@"5"]) {
        
        NSDictionary *fifDic = [dd[@"childrens"] firstObject];
        
        dd = fifDic;
    }
    
    NSString *value = safeString(dd[@"value"]) ;
    if (value.length >0) {
        
        NSArray *array = [value componentsSeparatedByString:@"@&@"];
        if (array.count == 2) {
            
            [self.dataArray removeAllObjects];
            [self.dataArray addObject:array[0]];
            [self.dataArray addObject:array[1]];
            
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@100);
                make.left.equalTo(self.mas_left);
                make.right.equalTo(self.mas_right);
                make.bottom.equalTo(self.mas_bottom);
            }];
            [self.tableView reloadData];
            
        }else if (array.count == 3) {
            
            [self.dataArray removeAllObjects];
            [self.dataArray addObject:array[0]];
            [self.dataArray addObject:array[1]];
            [self.dataArray addObject:array[2]];
            [self.tableView reloadData];
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@150);
                make.left.equalTo(self.mas_left);
                make.right.equalTo(self.mas_right);
                make.bottom.equalTo(self.mas_bottom);
            }];
            [self.tableView reloadData];
            
        }
    }
}
@end
