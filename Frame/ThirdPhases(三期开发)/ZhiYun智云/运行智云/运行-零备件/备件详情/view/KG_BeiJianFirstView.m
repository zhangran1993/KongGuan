//
//  KG_BeiJianFirstView.m
//  Frame
//
//  Created by zhangran on 2020/7/31.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_BeiJianFirstView.h"
#import "KG_BeiJianDetailCell.h"
@interface KG_BeiJianFirstView ()<UITableViewDelegate,UITableViewDataSource>{
    

}
@property (nonatomic,strong)    UILabel                 *leftTitleLabel;

@property (nonatomic,strong)    UIImageView             *rightImage;

@property (nonatomic,strong)    UITableView             *tableView;

@property (nonatomic,strong)    NSMutableArray          *dataArray;

@end

@implementation KG_BeiJianFirstView


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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH- 32, 250)];
    [self addSubview:bgView];

    // gradient
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,SCREEN_WIDTH- 32,50);
    gl.startPoint = CGPointMake(0.5, 0);
    gl.endPoint = CGPointMake(0.5, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:220/255.0 green:233/255.0 blue:255/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:249/255.0 green:253/255.0 blue:255/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    bgView.layer.cornerRadius = 10;
    bgView.layer.masksToBounds = YES;
    [bgView.layer addSublayer:gl];
    self.leftTitleLabel = [[UILabel alloc]init];
    [bgView addSubview:self.leftTitleLabel];
    self.leftTitleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.leftTitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.leftTitleLabel.numberOfLines = 2;
    [self.leftTitleLabel sizeToFit];
    [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(16);
        make.top.equalTo(bgView.mas_top);
        make.height.equalTo(@50);
        make.width.equalTo(@(SCREEN_WIDTH -50 -32-16));
    }];
   
    
    self.rightImage = [[UIImageView alloc]init];
    [bgView addSubview:self.rightImage];
    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right);
        make.height.width.equalTo(@48);
        make.top.equalTo(bgView.mas_top);
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
        _tableView.scrollEnabled = YES;
    }
    return _tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSDictionary *dataDic = self.dataArray[indexPath.row];
   
    return 50;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_BeiJianDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_BeiJianDetailCell"];
    if (cell == nil) {
        cell = [[KG_BeiJianDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_BeiJianDetailCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"备件等级";
        cell.detailLabel.text = safeString(self.dataDic[@"gradeName"]);
        cell.detailLabel.textColor = [UIColor colorWithHexString:@"#004EC4"];
    }else if (indexPath.row == 1) {
        cell.titleLabel.text = @"所属设备";
        cell.detailLabel.text = safeString(self.dataDic[@"equipmentName"]);
        cell.detailLabel.textColor = [UIColor colorWithHexString:@"#626470"];
        
    }else if (indexPath.row == 2) {
        cell.titleLabel.text = @"备件型号";
        cell.detailLabel.text = safeString(self.dataDic[@"model"]);
        cell.detailLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    }else if (indexPath.row == 3) {
        cell.titleLabel.text = @"备件分类";
        cell.detailLabel.text = safeString(self.categoryString);
        if(self.categoryString.length == 0) {
            cell.detailLabel.text = safeString(self.dataDic[@"categoryName"]);
        }
        cell.detailLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    }
    
    
    return cell;
    
}
- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.tableView reloadData];
    self.leftTitleLabel.text = safeString(self.dataDic[@"name"]);
    
    
    self.rightImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"备件标签-%@",safeString(dataDic[@"statusName"])]];
}

- (void)setCategoryString:(NSString *)categoryString {
    _categoryString = categoryString;
    [self.tableView reloadData];
}

- (void)setDeviceStr:(NSString *)deviceStr {
    _deviceStr = deviceStr;
    [self.tableView reloadData];
}
@end
