//
//  RS_ConditionSearchView.m
//  ylh-app-primary-ios
//
//  Created by 王青森 on 2019/7/1.
//  Copyright © 2019 巨商汇. All rights reserved.
//

#import "RS_ConditionSearchView.h"
#import "RS_BottomButtonView.h"
#import "RS_ConditionSearchTableViewCell.h"


@interface RS_ConditionSearchView ()<UITableViewDataSource,UITableViewDelegate>

/** 灰色背景 */
@property (nonatomic, strong) UIButton *shadowButton;
/** 主视图 */
@property (nonatomic, strong) UIView *backView;
/** 顶部视图 */
@property (nonatomic, strong) UIView *headerView;
/** 筛选分组 */
@property (nonatomic, strong) UITableView *tableView;
/** 页面数据源 */
@property (nonatomic, strong) NSMutableArray *dataArrM;
/** 清空筛选/确定 */
@property (nonatomic, strong) RS_BottomButtonView *bottomView;
/** 时间选择控件 */
@property (nonatomic, strong) UIDatePicker *datePicker;
/** 区间-时间 */
@property (nonatomic, strong) RS_ConditionSearchModel *timeIntervalModel;

@property (nonatomic, copy) NSArray *saveArrM;

@end

@implementation RS_ConditionSearchView

- (instancetype)initWithCondition:(NSArray *)conditionDataArr {
    
    if (self = [super initWithFrame:UIScreen.mainScreen.bounds]) {
        self.conditionDataArr = conditionDataArr;
        [self initData];
        [self createSubviews];
    }
    return self;
}

- (void)initData {
    
    // 按.h文件中的注释构造数据源conditionDataArr
    self.dataArrM = [NSMutableArray array];
    for (NSDictionary *dic in _conditionDataArr) {
        RS_ConditionSearchModel *model = [[RS_ConditionSearchModel alloc] initWithDictionary:dic error:nil];
        [model calculateSize];
        [self.dataArrM addObject:model];
    }
}

- (void)createSubviews {
    
    self.backgroundColor = [UIColor clearColor];
    
    _shadowButton = [UIButton new];
    [self addSubview:_shadowButton];
    _shadowButton.frame = self.bounds;
    _shadowButton.backgroundColor = RGBA(0, 0, 0, 0.4);
    _shadowButton.alpha = 0;
    [_shadowButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    _backView = [UIView new];
    [self addSubview:_backView];
    _backView.frame = CGRectMake(self.width, 0, 325, self.height);
    _backView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    
    [self createHeaderView];
    [self createTableView];
    [self createBottomView];
}

// 标题视图
- (void)createHeaderView {
    
    _headerView = [UIView new];
    [_backView addSubview:_headerView];
    _headerView.frame = CGRectMake(0, 0, _backView.width, NAVIGATIONBAR_HEIGHT);
    _headerView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [UIImageView new];
    [_headerView addSubview:imageView];
    imageView.sd_layout.xIs(10).bottomSpaceToView(_headerView, 14).widthIs(18).heightIs(15.5);
    imageView.image = [UIImage imageNamed:@""];
    
    UIButton *closeButton = [UIButton new];
    [_headerView addSubview:closeButton];
    closeButton.sd_layout.rightSpaceToView(_headerView, 0).centerYEqualToView(imageView).widthIs(33).heightIs(37);
    [closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    UILabel *titleLabel = [UILabel new];
    [_headerView addSubview:titleLabel];
    titleLabel.sd_layout.leftSpaceToView(imageView, 5.5).centerYEqualToView(imageView).rightSpaceToView(closeButton, 10).heightIs(14);
    titleLabel.text = @"筛选条件";
    titleLabel.font = FONT_MIDEUM(14);
    titleLabel.textColor = [UIColor colorWithHexString:@"#888888"];
}

// 筛选条件视图
- (void)createTableView {
    
    CGFloat height = self.height - _headerView.bottom - 5 - 45 - TABBAR_HEIGHT;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _headerView.bottom + 5, _backView.width, height) style:UITableViewStyleGrouped];
    [_backView addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 45;
    _tableView.estimatedSectionFooterHeight = 0.5;
}

- (void)createBottomView {
    
    _bottomView = [[RS_BottomButtonView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) items:@[@"清空筛选",@"确定"]];
    _bottomView.leftButton.sd_layout.widthIs(150);
    _bottomView.rightButton.sd_layout.xIs(150).widthIs(175);
    [_bottomView.leftButton setTitleColor:[UIColor colorWithHexString:@"#555555"] forState:UIControlStateNormal];
    _bottomView.leftButton.titleLabel.font = FONT_MIDEUM(16);
    _bottomView.rightButton.backgroundColor = [UIColor colorWithHexString:@"#EA3425"];
    _bottomView.rightButton.titleLabel.font = FONT_MIDEUM(16);
    [_backView addSubview:_bottomView];
    weakify(self);
    [_bottomView setDidClickButton:^(RS_BottomButtonType type) {
        strongify(self);
        if (type == RS_BottomButtonTypeLeft) {
            [self reloadData];
        } else {
           
            if (self.didSelectItemHandler) {
                self.didSelectItemHandler(self.resultArray);
            }
            if (self.resultArray.count) {
                self.saveArrM = self.dataArrM;
            }
            [self hide];
        }
    }];
    
    UIView *line = [UIView new];
    [_bottomView addSubview:line];
    line.frame = CGRectMake(0, 0, _bottomView.width, 0.5);
    line.backgroundColor = [UIColor colorWithHexString:@"#D7D7D7"];
}

#pragma mark - PrivateMethod
- (void)showTimeChooseView:(RS_ConditionSearchModel *)sectionModel {
    
    _timeIntervalModel = sectionModel;
    
    UIButton *shadowButton = [UIButton new];
    [[UIApplication sharedApplication].keyWindow addSubview:shadowButton];
    shadowButton.frame = UIScreen.mainScreen.bounds;
    shadowButton.alpha = 0;
    [shadowButton addTarget:self action:@selector(hideDatePicker) forControlEvents:UIControlEventTouchUpInside];
    shadowButton.backgroundColor = RGBA(0, 0, 0, 0.5);
    
    _datePicker = [[UIDatePicker alloc] init];
    [shadowButton addSubview:_datePicker];
   
    [_datePicker show];
    
    [UIView animateWithDuration:0.25 animations:^{
        shadowButton.alpha = 1.0;
        self.datePicker.transform = CGAffineTransformMakeTranslation(0, -360);
    }];
}

- (void)hideDatePicker {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.datePicker.superview.alpha = 0;
        self.datePicker.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self.datePicker.superview removeFromSuperview];
    }];
}

- (void)packUp:(UIButton *)button {
    
    RS_ConditionSearchModel *sectionModel = self.dataArrM[button.tag];
    sectionModel.packUp = @(!sectionModel.isPackUp.boolValue);
    [_tableView reloadData];
    [UIView animateWithDuration:0.25 animations:^{
        button.imageView.transform = sectionModel.isPackUp.boolValue ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformIdentity;
    }];
}

// 点击确定的回调数据
- (NSArray *)resultArray {
    
    NSMutableArray *resultArrM = [NSMutableArray array];
    for (RS_ConditionSearchModel *model in self.dataArrM) {
        NSMutableArray *itemArrM = [NSMutableArray array];
        switch (model.sectionType.integerValue) {
            case RS_ConditionSearchSectionTypeNormal:
            case RS_ConditionSearchSectionTypeAdjustText:
                for (int i = 0; i < model.itemArrM.count; ++i) {
                    RS_ConditionSearchItemModel *itemModel = model.itemArrM[i];
                    if (itemModel.isSelected) {
                        [itemArrM addObject:@(i)];
                    }
                }
                break;
            case RS_ConditionSearchSectionTypeInterval:
                [itemArrM addObject:safeString(model.intervalStart)];
                [itemArrM addObject:safeString(model.intervalEnd)];
                break;
            case RS_ConditionSearchSectionTypeToSecondView:
                break;
            default:
                break;
        }
        [resultArrM addObject:itemArrM];
    }
    return [resultArrM copy];
}

- (void)reloadData {
    
    [self initData];
    [self.tableView reloadData];
}

#pragma mark - PublicMethod
- (void)show {
    if (self.saveArrM.count) {
        [self.dataArrM removeAllObjects];
        [self.dataArrM addObjectsFromArray:self.saveArrM];
        [self.tableView reloadData];
    }else {
        if (self.dataArrM.count) {
            for (RS_ConditionSearchModel *model in self.dataArrM) {
                for (RS_ConditionSearchItemModel  *detailmodel in model.itemArrM) {
                    detailmodel.selected = NO;
                }
            }
            [self.tableView reloadData];
        }
       
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowButton.alpha = 1.0;
        self.backView.transform = CGAffineTransformMakeTranslation(-325, 0);
    }];
   
}

- (void)hide {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowButton.alpha = 0;
        self.backView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Setter
- (void)setConditionDataArr:(NSArray *)conditionDataArr {
    
    _conditionDataArr = conditionDataArr;
    [self reloadData];
}

#pragma mark - DoubleWYLDatePickerViewDelegate
- (void)datePickerViewSaveBtnClickDelegate:(NSDictionary *)timer {
    
    _timeIntervalModel.intervalStart = safeString(timer[@"StartTime"]);
    _timeIntervalModel.intervalEnd = safeString(timer[@"EndTime"]);
    [_tableView reloadData];
    [self hideDatePicker];
}

- (void)datePickerViewCancelBtnClickDelegate {
    
    [self hideDatePicker];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArrM.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    RS_ConditionSearchModel *sectionModel = self.dataArrM[section];
    if (sectionModel.allowPackUp.boolValue) {
        if (sectionModel.isPackUp.boolValue) {
            if (sectionModel.sectionType.integerValue == RS_ConditionSearchSectionTypeInterval) {
                return 0;
            }
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RS_ConditionSearchTableViewCell *cell = [RS_ConditionSearchTableViewCell new];
    if (indexPath.section < self.dataArrM.count) {
        RS_ConditionSearchModel *sectionModel = self.dataArrM[indexPath.section];
        cell.model = sectionModel;
        [cell setIntervalTextFieldEditingChanged:^(NSString * _Nonnull text, RS_ConditionSearchIntervalType type) {
            if (type == RS_ConditionSearchIntervalTypeStart) {
                sectionModel.intervalStart = safeString(text);
            } else {
                sectionModel.intervalEnd = safeString(text);
            }
        }];
        [cell setIntervalTextFieldClick:^(RS_ConditionSearchIntervalType type) {
            [self showTimeChooseView:sectionModel];
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RS_ConditionSearchModel *model = self.dataArrM[indexPath.section];
    return model.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [UIView new];
    headerView.frame = CGRectMake(0, 0, _backView.width, 45);
    
    if (section >= self.dataArrM.count) {
        return headerView;
    }
    
    RS_ConditionSearchModel *sectionModel = self.dataArrM[section];
    headerView.frame = CGRectMake(0, 0, _backView.width, 45);
    headerView.backgroundColor = [UIColor whiteColor];
    
    // 标题
    UILabel *itemLabel = [UILabel new];
    [headerView addSubview:itemLabel];
    itemLabel.frame = CGRectMake(10, 0, 180, 45);
    itemLabel.text = sectionModel.sectionName;
    itemLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    itemLabel.font = FONT_MIDEUM(14);
    
    // 收起展开按钮
    if (sectionModel.isAllowPackUp.boolValue) {
        UIButton *packUpButton = [UIButton new];
        [headerView addSubview:packUpButton];
        packUpButton.sd_layout.rightSpaceToView(headerView, 5).yIs(0).widthIs(27).heightIs(45);
        [packUpButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        packUpButton.tag = section;
        [packUpButton addTarget:self action:@selector(packUp:) forControlEvents:UIControlEventTouchUpInside];
        if (sectionModel.isPackUp.boolValue) {
            packUpButton.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        }
    }
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView = [UIView new];
    footerView.frame = CGRectMake(0, 10, _backView.width, 10.5);
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [UIView new];
    [footerView addSubview:line];
    line.frame = CGRectMake(0, 10, _backView.width, 0.5);
    line.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10.5;
}

@end
