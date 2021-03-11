//
//  KG_BeiJianListCell.m
//  Frame
//
//  Created by zhangran on 2020/7/30.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_BeiJianListCell.h"
#import "KG_BeiJianListDetailCell.h"

#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_BeiJianListCell ()<UITableViewDelegate,UITableViewDataSource>{
    

}

@property (nonatomic,strong)    UITableView             *tableView;

@property (nonatomic,strong)    NSMutableArray          *dataArray;


@property (nonatomic,strong)    UILabel             *titleLabel;

@end


@implementation KG_BeiJianListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = self.backgroundColor;
        [self createSubviewsView];
    }
    return self;
}

- (void)createSubviewsView {
    [self createTableView];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    if (dataDic.count) {
        self.dataArray = dataDic[@"attachmentInfo"];
    }
    self.titleLabel.text = safeString(dataDic[@"equipmentName"]);
    [self.tableView reloadData];
}

- (void)setTotalDic:(NSDictionary *)totalDic {
    _totalDic = totalDic;
}

- (void)createTableView {
    
    self.titleLabel = [[UILabel alloc]init];
    
    [self addSubview:self.titleLabel];
    self.titleLabel.text = @"--";
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.font = [UIFont my_font:14];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel sizeToFit];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(@(SCREEN_WIDTH/2- 30 -10));
        make.height.equalTo(self.mas_height);
    }];
    
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH/2- 30);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.height.equalTo(@1);
        make.bottom.equalTo(self.mas_bottom);
        
    }];
    
}


-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
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
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSDictionary *dataDic = self.dataArray[indexPath.row];
//    if (dataDic.count) {
//        return 45*self.dataArray.count;
//    }
    return 45;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_BeiJianListDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_BeiJianListDetailCell"];
    if (cell == nil) {
        cell = [[KG_BeiJianListDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_BeiJianListDetailCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    cell.dataDic = dataDic;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    if (self.didsel) {
        self.didsel(dataDic,self.totalDic);
    }
}
@end
