//
//  KG_RunReportDetailThirdCell.m
//  Frame
//
//  Created by zhangran on 2020/6/2.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_CaseLibraryCell.h"
#import "KG_CaseLibraryDetailCell.h"
#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface  KG_CaseLibraryCell()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong)          UITableView          *tableView;

@property (nonatomic, strong)          NSMutableArray       *dataArray;

@property (nonatomic, strong)          UIView               *tableHeadView;

@property (nonatomic, strong)          UILabel              *headTitleLabel;

@end

@implementation KG_CaseLibraryCell

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
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    self.tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    self.tableHeadView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.headTitleLabel = [[UILabel alloc]init];
    [self.tableHeadView addSubview:self.headTitleLabel];
    self.headTitleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.headTitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.headTitleLabel.font = [UIFont my_font:16];
    
    [self.headTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableHeadView.mas_left).offset(16);
        make.width.equalTo(@200);
        make.top.equalTo(self.tableHeadView.mas_top);
        make.bottom.equalTo(self.tableHeadView.mas_bottom);
    }];
    self.tableView.tableHeaderView = self.tableHeadView;

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
   return self.listArray.count;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_CaseLibraryDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_CaseLibraryDetailCell"];
    if (cell == nil) {
        cell = [[KG_CaseLibraryDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_CaseLibraryDetailCell"];
    }
    
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dataDic = self.listArray[indexPath.row];
    
    cell.dataDic = dataDic;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSLog(@"section ===%ld,row ===%ld",(long)indexPath.section,(long)indexPath.row);
    NSDictionary *dataDic = self.listArray[indexPath.row];
       
    if(self.didsel){
        
        self.didsel(dataDic);
    }
}


- (void)setListArray:(NSArray *)listArray {
    _listArray = listArray;

    [self.tableView reloadData];
    
    
    
}


- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic =dataDic;
    
    self.headTitleLabel.text = safeString(dataDic[@"categoryName"]);
    
}
@end
