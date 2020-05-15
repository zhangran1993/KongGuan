//
//  RS_CollectionAlignmentFlowLayout.m
//  ylh-app-primary-ios
//
//  Created by 王青森 on 2019/6/10.
//  Copyright © 2019 巨商汇. All rights reserved.
//

#import "RS_CollectionAlignmentFlowLayout.h"

@interface RS_CollectionAlignmentFlowLayout ()

@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attributesArray;

@end

@implementation RS_CollectionAlignmentFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    [self.attributesArray removeAllObjects];
    //遍历分区
    for (int sectionIndex = 0; sectionIndex < self.collectionView.numberOfSections; ++sectionIndex) {
        //添加item属性
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:sectionIndex];
        for (int rowIndex = 0; rowIndex < itemCount; ++rowIndex) {
            // 创建位置
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:rowIndex inSection:sectionIndex];
            // 获取indexPath位置上cell对应的布局属性
            UICollectionViewLayoutAttributes * attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attributesArray addObject:attrs];
        }
    }
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *headerAttrs = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
    headerAttrs.frame = CGRectZero;
    return headerAttrs;
}

// 返回indexPath位置cell对应的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGSize cellSize = [self.alignmentDelegate collectionViewSizeForItemAtIndexPath:indexPath];
    CGPoint startPoint = CGPointZero;
    
    if (self.cellAlignmentType == RS_CollectionCellAlignmentTypeLeft){
        // 左对齐
        if (indexPath.row > 0){
            UICollectionViewLayoutAttributes *prevLayoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section]];
            if (self.attributesArray.count > indexPath.row - 1) {
                prevLayoutAttributes = self.attributesArray[indexPath.row -1];
            }
            if (CGRectGetMaxX(prevLayoutAttributes.frame) + cellSize.width + self.cellAlignmentSpace < self.collectionViewContentSize.width){
                startPoint = CGPointMake(CGRectGetMaxX(prevLayoutAttributes.frame) + self.cellAlignmentSpace, prevLayoutAttributes.frame.origin.y);
            } else {
                startPoint = CGPointMake(0, CGRectGetMaxY(prevLayoutAttributes.frame) + self.minimumLineSpacing); // 垂直间距
            }
        } else {
            startPoint = CGPointMake(0, 0);
        }
        
    } else if (self.cellAlignmentType == RS_CollectionCellAlignmentTypeRight) {
        //右对齐
        if (indexPath.row > 0){
            UICollectionViewLayoutAttributes *prevLayoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section]];
            if (self.attributesArray.count > indexPath.row - 1) {
                prevLayoutAttributes = self.attributesArray[indexPath.row -1];
            } if (cellSize.width + self.cellAlignmentSpace < prevLayoutAttributes.frame.origin.x) {
                startPoint = CGPointMake(prevLayoutAttributes.frame.origin.x - self.cellAlignmentSpace - cellSize.width, prevLayoutAttributes.frame.origin.y);
            } else {
                startPoint = CGPointMake(self.collectionViewContentSize.width - cellSize.width, CGRectGetMaxY(prevLayoutAttributes.frame) + self.minimumLineSpacing);
            }
        } else {
            // 默认两边对齐
            startPoint = CGPointMake(self.collectionViewContentSize.width - cellSize.width, 0);
        }
    }
    
    layoutAttributes.frame = CGRectMake(startPoint.x, startPoint.y, cellSize.width, cellSize.height);
    
    return layoutAttributes;
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    return self.attributesArray;
}


- (NSMutableArray<UICollectionViewLayoutAttributes *> *)attributesArray {
    
    if (!_attributesArray) {
        _attributesArray = [NSMutableArray array];
    }
    
    return _attributesArray;
}


@end
