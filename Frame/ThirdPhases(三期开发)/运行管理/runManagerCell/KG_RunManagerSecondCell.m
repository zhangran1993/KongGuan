//
//  KG_RunManagerSecondCell.m
//  Frame
//
//  Created by zhangran on 2020/6/4.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RunManagerSecondCell.h"
#import "KG_RunWeiHuCell.h"
@interface KG_RunManagerSecondCell ()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong)  UIView    *stationWeihuView;//维护
@property (nonatomic, strong)  UITableView *weihuTableView;//2
@end

@implementation KG_RunManagerSecondCell

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
    //
    [self setUpWeihuView];
}

- (void)setReportListArr:(NSArray *)reportListArr {
    _reportListArr = reportListArr;
    
    [self.weihuTableView reloadData];
    //第二个
//    [self setUpWeihuView];
}

//第二个维护view
- (void)setUpWeihuView {
    
    [self.stationWeihuView removeFromSuperview];
    self.stationWeihuView = nil;
    self.stationWeihuView = [[UIView alloc]init];
    [self addSubview:self.stationWeihuView];
    self.stationWeihuView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.stationWeihuView.layer.cornerRadius = 10;
    self.stationWeihuView.layer.masksToBounds = YES;
    [self.stationWeihuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@72);
    }];
    
    UIImageView *weihuIcon = [[UIImageView alloc]init];
    [self.stationWeihuView addSubview:weihuIcon];
    weihuIcon.image = [UIImage imageNamed:@"run_weihuIcon"];
    [weihuIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@56);
        make.left.equalTo(self.stationWeihuView.mas_left).offset(3);
        make.centerY.equalTo(self.stationWeihuView.mas_centerY);
    }];
    UIImageView *shuLineIcon = [[UIImageView alloc]init];
    [self.stationWeihuView addSubview:shuLineIcon];
    shuLineIcon.image = [UIImage imageNamed:@"run_weihuLine"];
    [shuLineIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@2);
        make.height.equalTo(@41);
        make.left.equalTo(weihuIcon.mas_right).offset(6);
        make.centerY.equalTo(self.stationWeihuView.mas_centerY);
    }];
    
    [self.stationWeihuView addSubview:self.weihuTableView];
    self.weihuTableView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.weihuTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.stationWeihuView.mas_right).offset(-40);
        make.height.equalTo(@64);
        make.left.equalTo(shuLineIcon.mas_right).offset(9);
        make.centerY.equalTo(self.stationWeihuView.mas_centerY);
    }];
    UIButton *rightBtn1 = [[UIButton alloc]init];
    
    [self.stationWeihuView addSubview:rightBtn1];
    [rightBtn1 addTarget:self action:@selector(weihuMethod) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@50);
        make.centerY.equalTo(self.stationWeihuView.mas_centerY);
        make.right.equalTo(self.stationWeihuView.mas_right);
    }];
    
    UIButton *rightBtn = [[UIButton alloc]init];
    [rightBtn setImage:[UIImage imageNamed:@"common_right"] forState:UIControlStateNormal];
    [self.stationWeihuView addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(weihuMethod) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@18);
        make.centerY.equalTo(self.stationWeihuView.mas_centerY);
        make.right.equalTo(self.stationWeihuView.mas_right).offset(-10);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.weihuTableView]) {
        return self.reportListArr.count;
    }
    return 0;
}

- (UITableView *)weihuTableView {
    
    if (!_weihuTableView) {
        _weihuTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _weihuTableView.delegate = self;
        _weihuTableView.dataSource = self;
        _weihuTableView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        _weihuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _weihuTableView.scrollEnabled = NO;
        
    }
    return _weihuTableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     if ([tableView isEqual:self.weihuTableView]) {
         if(self.reportListArr.count == 1) {
             return 64;
         }
        return 32;
    }
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  if ([tableView isEqual:self.weihuTableView]) {
        
      KG_RunWeiHuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunWeiHuCell"];
      if (cell == nil) {
          cell = [[KG_RunWeiHuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunWeiHuCell"];
      }
      cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      NSDictionary *dataDic = self.reportListArr[indexPath.row];
      cell.dataDic = dataDic;
      
      return cell;
  }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.weihuBlockMethod){
        self.weihuBlockMethod();
    }
}


- (void)weihuMethod {
    
    if(self.weihuBlockMethod){
        self.weihuBlockMethod();
    }
}
@end
