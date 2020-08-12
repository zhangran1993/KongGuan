//
//  KG_BeiJianThirdView.m
//  Frame
//
//  Created by zhangran on 2020/7/31.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_BeiJianFourthView.h"
#import "KG_BeiJianLvLiCell.h"
@interface KG_BeiJianFourthView ()<UITableViewDelegate,UITableViewDataSource>{

}

@property (nonatomic,strong)    UITableView             *tableView;

@property (nonatomic,strong)    NSMutableArray          *dataArray;
    


@end

@implementation KG_BeiJianFourthView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
       
    }
    return self;
}
//初始化数据
- (void)initData {
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    UIImageView *iconImage = [[UIImageView alloc]init];
    [bgView addSubview:iconImage];
    iconImage.image = [UIImage imageNamed:@"beijian_lvli"];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@16);
        make.left.equalTo(bgView.mas_left).offset(17);
        make.top.equalTo(bgView.mas_top).offset(16);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [bgView addSubview:titleLabel];
    titleLabel.text = @"备件履历";
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconImage.mas_centerY);
        make.left.equalTo(iconImage.mas_right).offset(7);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    
    
    [bgView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(50);
        make.left.equalTo(bgView.mas_left);
        make.right.equalTo(bgView.mas_right);
        make.bottom.equalTo(bgView.mas_bottom);
    }];
    
     
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.lvliArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSDictionary *dataDic = self.dataArray[indexPath.row];
   
    return 80;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_BeiJianLvLiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_BeiJianLvLiCell"];
    if (cell == nil) {
        cell = [[KG_BeiJianLvLiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_BeiJianLvLiCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    NSDictionary *dataDic = self.lvliArr[indexPath.row];
    cell.dataDic = dataDic;
    if(indexPath.row == 0) {
        
        cell.line.hidden = YES;
    }else {
        cell.line.hidden = NO;
    }
    if (self.lvliArr.count) {
        if(indexPath.row == self.lvliArr.count -1 ) {
            cell.botImage.hidden = NO;
        }else {
            cell.botImage.hidden = YES;
        }
    }
    
    return cell;
    
}
- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.tableView reloadData];
   
}

- (void)setCategoryString:(NSString *)categoryString {
    _categoryString = categoryString;
    [self.tableView reloadData];
}

- (void)setLvliArr:(NSArray *)lvliArr {
    _lvliArr = lvliArr;
    [self.tableView reloadData];
}

@end
