//
//  PopularView.m
//  Frame
//
//  Created by centling on 2018/12/5.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "PopularView.h"
#import "UIView+LX_Frame.h"
#import "PopularCollectionViewCell.h"
#import "PopularModel.h"
static NSString *PopularCollectionViewCellID = @"PopularCollectionViewCellID";
@interface PopularView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSArray *modelArray;
@end

@implementation PopularView 
- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self setupUI];
    }
        return self;
}

- (void)refresh {
    [self.collectionView reloadData];
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < dataArray.count; i++) {
        PopularModel *model = [PopularModel new];
        model.name = dataArray[i];
        model.Checked = NO;
        [arr addObject:model];
    }
    self.modelArray = [arr copy];
    [self.collectionView reloadData];
}

- (void)setFrame {
    self.collectionView.frame = self.bounds;
}
- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.collectionView.frame = self.bounds;
    [self addSubview:self.collectionView];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PopularCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PopularCollectionViewCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.model = self.modelArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PopularModel *model = self.modelArray[indexPath.row];
    model.Checked = !model.Checked;
    [self clickCell:model.name isBool:model.Checked index:indexPath modelArray:self.modelArray];
    [self.collectionView reloadData];
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
//定义每个Section 的 margin (内容整体边距设置)//分别为上、左、下、右
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath   {
    return CGSizeMake((WIDTH_SCREEN-50)/4, 30);
}

- (void)clickCell:(NSString *)text isBool:(BOOL)isBool index:(NSIndexPath *)index modelArray:(NSArray *)modelArray{
    if ([self.delegate respondsToSelector:@selector(clickCell:isBool:index:modelArray:)]) {
        [self.delegate clickCell:text isBool:isBool index:index modelArray:modelArray];
    }
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset =UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.itemSize = CGSizeMake(100, 120);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.bounces = YES;
        _collectionView.scrollEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PopularCollectionViewCell class]) bundle:nil]  forCellWithReuseIdentifier:PopularCollectionViewCellID];
    }
    return _collectionView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
