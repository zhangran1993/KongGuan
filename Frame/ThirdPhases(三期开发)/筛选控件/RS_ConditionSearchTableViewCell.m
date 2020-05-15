//
//  RS_ConditionSearchTableViewCell.m
//  ylh-app-primary-ios
//
//  Created by 王青森 on 2019/7/1.
//  Copyright © 2019 巨商汇. All rights reserved.
//

#import "RS_ConditionSearchTableViewCell.h"
#import "RS_ConditionSearchCell.h"
#import "RS_CollectionAlignmentFlowLayout.h"

@interface RS_ConditionSearchTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate,RS_CollectionCellAlignmentFlowLayoutDelegate,UITextFieldDelegate>

/** 筛选选项 */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 区间背景 */
@property (nonatomic, strong) UIView *intervalBackView;
/** 区间起始 */
@property (nonatomic, strong) UITextField *startTextField;
/** 区间结束 */
@property (nonatomic, strong) UITextField *endTextField;

@end

@implementation RS_ConditionSearchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubviewsView];
    }
    return self;
}

- (void)createSubviewsView {
    
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.clipsToBounds = YES;
}

// 常规选项
- (void)createCollectionView {
    
    RS_CollectionAlignmentFlowLayout *flowLayout = [RS_CollectionAlignmentFlowLayout new];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.alignmentDelegate = self;
    flowLayout.cellAlignmentType = RS_CollectionCellAlignmentTypeLeft;
    flowLayout.cellAlignmentSpace = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, 305, _model.height) collectionViewLayout:flowLayout];
    [self.contentView addSubview:_collectionView];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:RS_ConditionSearchCell.class forCellWithReuseIdentifier:NSStringFromClass(RS_ConditionSearchCell.class)];
    _collectionView.scrollEnabled = NO;
}

// 区间输入
- (void)createIntervalView {
    
    _intervalBackView = [UIView new];
    [self.contentView addSubview:_intervalBackView];
    _intervalBackView.frame = CGRectMake(10, 0, 305, 40);
    _intervalBackView.backgroundColor = [UIColor whiteColor];
    
    _startTextField = [self intervalTextField];
    _startTextField.frame = CGRectMake(10, 5, 130, 30);
    NSString *startStr = _model.itemArrM.count > 0 ? safeString([_model.itemArrM.firstObject itemName]) : @"";
    _startTextField.attributedPlaceholder = [NSString attributedPlaceholder:startStr color:LCColor(@"#888888") font:Font(14)];
    _startTextField.text = safeString(_model.intervalStart);
    _startTextField.tag = RS_ConditionSearchIntervalTypeStart;
    
    UIView *line = [UIView new];
    [_intervalBackView addSubview:line];
    line.frame = CGRectMake(147.5, 19, 10, 2);
    line.backgroundColor = LCColor(@"#888888");
    
    _endTextField = [self intervalTextField];
    _endTextField.frame = CGRectMake(165, 5, 130, 30);
    NSString *endStr = _model.itemArrM.count > 1 ? safeString([_model.itemArrM[1] itemName]) : @"";
    _endTextField.attributedPlaceholder = [NSString attributedPlaceholder:endStr color:LCColor(@"#888888") font:Font(14)];
    _endTextField.text = safeString(_model.intervalEnd);
    _endTextField.tag = RS_ConditionSearchIntervalTypeEnd;
}

- (UITextField *)intervalTextField {
    
    UITextField *textField = [UITextField new];
    [_intervalBackView addSubview: textField];
    textField.textColor = LCColor(@"#222222");
    textField.font = Font(14);
    textField.textAlignment = NSTextAlignmentCenter;
    textField.backgroundColor = LCColor(@"#F2F2F2");
    textField.delegate = self;
    [textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    textField.clipsToBounds = YES;
    textField.layer.cornerRadius = 15;
    
    return textField;
}

- (void)setModel:(RS_ConditionSearchModel *)model {
    
    _model = model;
    
    switch (model.sectionType.integerValue) {
        case RS_ConditionSearchSectionTypeNormal:
            [self createCollectionView];
            break;
        case RS_ConditionSearchSectionTypeAdjustText:
            [self createCollectionView];
            break;
        case RS_ConditionSearchSectionTypeInterval:
            [self createIntervalView];
            break;
        case RS_ConditionSearchSectionTypeToSecondView:
            break;
    }
}

- (void)textChanged:(UITextField *)textField {
    
    if (self.intervalTextFieldEditingChanged) {
        self.intervalTextFieldEditingChanged(textField.text, textField.tag);
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:_startTextField] || [textField isEqual:_endTextField]) {
        if (_model.intervalIsInput.boolValue) {
            return YES;
        } else {
            if (self.intervalTextFieldClick) {
                self.intervalTextFieldClick(textField.tag);
            }
            return NO;
        }
    } else {
        return YES;
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _model.itemArrM.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RS_ConditionSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(RS_ConditionSearchCell.class) forIndexPath:indexPath];
    if (indexPath.row < _model.itemArrM.count) {
        cell.model = _model.itemArrM[indexPath.row];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RS_ConditionSearchItemModel *itemModel = _model.itemArrM[indexPath.row];
    if (_model.isAllowMutiSelect.boolValue) {
        itemModel.selected = !itemModel.isSelected;
        [_collectionView reloadData];
    } else {
        for (RS_ConditionSearchItemModel *model in _model.itemArrM) {
            model.selected = NO;
        }
        itemModel.selected = YES;
        [_collectionView reloadData];
    }
}

#pragma mark - RS_CollectionCellAlignmentFlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RS_ConditionSearchItemModel *itemModel = _model.itemArrM[indexPath.row];
    return CGSizeMake(itemModel.width, itemModel.height);
}

- (CGSize)collectionViewSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RS_ConditionSearchItemModel *itemModel = _model.itemArrM[indexPath.row];
    return CGSizeMake(itemModel.width, itemModel.height);
}


@end
