//
//  RS_CollectionAlignmentFlowLayout.h
//  ylh-app-primary-ios
//
//  Created by 王青森 on 2019/6/10.
//  Copyright © 2019 巨商汇. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,RS_CollectionCellAlignmentType) {
    RS_CollectionCellAlignmentTypeDefault = 0, // 默认两边对齐
    RS_CollectionCellAlignmentTypeLeft,        // 左对齐
    RS_CollectionCellAlignmentTypeRight        // 右对齐
};

@protocol  RS_CollectionCellAlignmentFlowLayoutDelegate<NSObject>

@required

- (CGSize)collectionViewSizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface RS_CollectionAlignmentFlowLayout : UICollectionViewFlowLayout

@property(nonatomic, weak) id <RS_CollectionCellAlignmentFlowLayoutDelegate> alignmentDelegate;

@property(nonatomic, assign) RS_CollectionCellAlignmentType cellAlignmentType;
@property(nonatomic, assign) CGFloat cellAlignmentSpace;

@end

NS_ASSUME_NONNULL_END
