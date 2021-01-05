//
//  KG_GaoJingDetailSixthCell.m
//  Frame
//
//  Created by zhangran on 2020/5/20.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_GaoJingDetailSixthCell.h"
#import "KG_ProgressLeftCell.h"
#import "KG_ProgressRightCell.h"
@interface KG_GaoJingDetailSixthCell()<UITableViewDelegate,UITableViewDataSource>{
    
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation KG_GaoJingDetailSixthCell

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
        [self createSubviewsView];
    }
    return self;
}

- (void)createSubviewsView {
    UILabel *titleLabel = [[UILabel alloc]init];
    [self addSubview:titleLabel];
    titleLabel.text = @"流程记录";
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    titleLabel.font = [UIFont my_font:16];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.mas_top).offset(13);
        make.width.equalTo(@120);
        make.height.equalTo(@22);
    }];
    
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left);
        make.width.equalTo(self.mas_width);
        make.top.equalTo(titleLabel.mas_bottom);
    }];
       

}

- (void)setModel:(KG_GaoJingDetailModel *)model {
    _model = model;
   
    self.dataArray = model.log;
    [self.tableView reloadData];
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
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row %2==0) {//如果是偶数
        KG_ProgressLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_ProgressLeftCell "];
        if (cell == nil) {
            cell = [[KG_ProgressLeftCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_ProgressLeftCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSDictionary *dic = self.dataArray[indexPath.row];
        cell.dic = dic;
        if (self.dataArray.count >0) {
            if (indexPath.row == self.dataArray.count - 1) {
                cell.lineImage.backgroundColor = [UIColor colorWithHexString:@"#E9EDF6"];
            }
        }
        
        return cell;
        
    }else{//如果是奇数
        KG_ProgressRightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_ProgressRightCell "];
        if (cell == nil) {
            cell = [[KG_ProgressRightCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_ProgressRightCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSDictionary *dic = self.dataArray[indexPath.row];
        cell.dic = dic;
        if (self.dataArray.count >0) {
            if (indexPath.row == self.dataArray.count - 1) {
                cell.lineImage.backgroundColor = [UIColor colorWithHexString:@"#E9EDF6"];
            }
        }
        return cell;
        
        
        
    }
    return nil;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
 
}


@end
