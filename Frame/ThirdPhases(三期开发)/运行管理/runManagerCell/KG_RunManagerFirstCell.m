//
//  KG_RunManagerFirstCell.m
//  Frame
//
//  Created by zhangran on 2020/6/4.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RunManagerFirstCell.h"
#import "KG_StationReportCell.h"
@interface KG_RunManagerFirstCell ()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong)  UIView    *stationReportView;//台站任务提醒
@property (nonatomic, strong)  UITableView *reportTableView;//1
@end

@implementation KG_RunManagerFirstCell

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
    
  
    
}
- (void)setStationTaskInfoArr:(NSArray *)stationTaskInfoArr {
    _stationTaskInfoArr = stationTaskInfoArr;
    //第一个
    [self setUpStationReportView];
}
//台站任务提醒
- (void)setUpStationReportView {
    [self.stationReportView removeFromSuperview];
    self.stationReportView = nil;
    self.stationReportView = [[UIView alloc]init];
    [self addSubview:self.stationReportView];
    if (self.stationTaskInfoArr.count == 0) {
        [self.stationReportView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(16);
            make.right.equalTo(self.mas_right).offset(-16);
            make.top.equalTo(self.mas_top);
            make.height.equalTo(@(53+44));
        }];
    }else {
        if (self.stationTaskInfoArr.count >=3) {
            [self.stationReportView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(16);
                make.right.equalTo(self.mas_right).offset(-16);
                make.top.equalTo(self.mas_top);
                make.height.equalTo(@(53+96));
            }];
            
        }else {
            
            [self.stationReportView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(16);
                make.right.equalTo(self.mas_right).offset(-16);
                make.top.equalTo(self.mas_top);
                make.height.equalTo(@(53+(32 *self.stationTaskInfoArr.count) ));
            }];
        }
        
    }
    
    
    UIView *topView = [[UIView alloc]init];
    [self.stationReportView addSubview:topView];
    topView.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stationReportView.mas_left);
        make.right.equalTo(self.stationReportView.mas_right);
        make.top.equalTo(self.stationReportView.mas_top);
        make.height.equalTo(@44);
    }];
    topView.layer.cornerRadius = 8;
    topView.layer.masksToBounds = YES;
    
    UILabel *promptLabel = [[UILabel alloc]init];
    [topView addSubview:promptLabel];
    promptLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    promptLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    promptLabel.textAlignment = NSTextAlignmentLeft;
    promptLabel.text = @"台站任务提醒";
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).offset(16);
        make.top.equalTo(topView.mas_top);
        make.bottom.equalTo(topView.mas_bottom);
        make.width.equalTo(@100);
    }];
    
    UIButton *totalBtn = [[UIButton alloc]init];
    [totalBtn setImage:[UIImage imageNamed:@"white_jiantou"] forState:UIControlStateNormal];
    [totalBtn setTitle:@"查看全部" forState:UIControlStateNormal];
    [topView addSubview:totalBtn];
    [totalBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 77, 0, 0)];
    [totalBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    totalBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [totalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView.mas_right).offset(-20);
        make.width.equalTo(@90);
        make.height.equalTo(topView.mas_height);
        make.centerY.equalTo(topView.mas_centerY);
    }];
    [totalBtn addTarget:self action:@selector(watahTotalMethod) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.stationTaskInfoArr.count == 0) {
        
        UIView *noDataView = [[UIView alloc]init];
        [self.stationReportView addSubview:noDataView];
        noDataView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.stationReportView.mas_left);
            make.right.equalTo(self.stationReportView.mas_right);
            make.height.equalTo(@58);
            make.top.equalTo(self.stationReportView.mas_top).offset(44);
        }];
        
        UILabel *noDataLabel = [[UILabel alloc]init];
        [noDataView addSubview:noDataLabel];
        noDataLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
        noDataLabel.font = [UIFont systemFontOfSize:14];
        noDataLabel.textAlignment = NSTextAlignmentCenter;
        noDataLabel.text = @"当前暂无任务";
        [noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(noDataView.mas_left);
            make.right.equalTo(noDataView.mas_right);
            make.top.equalTo(noDataView.mas_top);
            make.bottom.equalTo(noDataView.mas_bottom);
        }];
    }else {
        [self.stationReportView addSubview:self.reportTableView];
        NSInteger tableHeight = 96;
        if (self.stationTaskInfoArr.count >=3) {
            tableHeight = 96;
        }else {
            tableHeight = self.stationTaskInfoArr.count *32;
        }
        [self.reportTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.stationReportView.mas_left);
            make.right.equalTo(self.stationReportView.mas_right);
            make.top.equalTo(self.stationReportView.mas_top).offset(53);
            make.height.equalTo(@(tableHeight));
        }];
        [self.reportTableView reloadData];
    }
    
    UIImageView *bgImage1 = [[UIImageView alloc]init];
    [self.stationReportView addSubview:bgImage1];
    bgImage1.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    
    
    [bgImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stationReportView.mas_left);
        make.right.equalTo(self.stationReportView.mas_right);
        make.top.equalTo(self.stationReportView.mas_top).offset(35);
        make.height.equalTo(@18);
    }];
    
    UIImageView *bgImage = [[UIImageView alloc]init];
    [self.stationReportView addSubview:bgImage];
    bgImage.image = [UIImage imageNamed:@"run_longCircle"];
    //    bgImage.contentMode = UIViewContentModeScaleAspectFill;
    
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stationReportView.mas_left);
        make.right.equalTo(self.stationReportView.mas_right);
        make.top.equalTo(self.stationReportView.mas_top).offset(35);
        make.height.equalTo(@18);
    }];
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:self.reportTableView]) {
        KG_StationReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_StationReportCell"];
        if (cell == nil) {
            cell = [[KG_StationReportCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_StationReportCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dataDic = self.stationTaskInfoArr[indexPath.row];
        cell.dataDic = dataDic;
        
        return cell;
    }
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.reportTableView]) {
        return self.stationTaskInfoArr.count;
    }
    return 0;
}


- (UITableView *)reportTableView {
    if (!_reportTableView) {
        _reportTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _reportTableView.delegate = self;
        _reportTableView.dataSource = self;
        _reportTableView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        _reportTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _reportTableView.scrollEnabled = NO;
         _reportTableView.layer.cornerRadius = 8;
         _reportTableView.layer.masksToBounds = YES;
         
    }
    return _reportTableView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.reportTableView]) {
        return 32;
    }
    return 50;
}

- (void)watahTotalMethod {
    
    if (self.watchTotal) {
        self.watchTotal();
    }
}

@end
