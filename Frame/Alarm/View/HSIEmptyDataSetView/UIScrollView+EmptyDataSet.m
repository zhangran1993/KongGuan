//
//  UIScrollView+EmptyDataSet.m
//  HiSmartInternational
//
//  Created by Seas Cheng on 2018/7/9.
//  Copyright © 2018年 Hisense. All rights reserved.
//

#import "UIScrollView+EmptyDataSet.h"
#import <objc/runtime.h>
static const void * _Nonnull kEmptyDataSetDelegate = "emptyDataSetDelegate";
static const void * _Nonnull kEmptyDataSetView = "emptyDataSetView";

@interface WeakObjectContainer : NSObject

@property (nonatomic, readonly, weak) id weakObject;
- (instancetype)initWithWeakObject:(id)object;

@end


@interface UIScrollView ()



@end

@implementation UIScrollView (EmptyDataSet)

@dynamic emptyDataSetDelegate;

static NSMutableDictionary *_impLookupTable;
static NSString *const HSISwizzleInfoPointerKey = @"pointer";
static NSString *const HSISwizzleInfoOwnerKey = @"owner";
static NSString *const HSISwizzleInfoSelectorKey = @"selector";

- (void)setEmptyDataSetDelegate:(id<EmptyDataSetDelegate>)emptyDataSetDelegate{
    if (!emptyDataSetDelegate) {
        [self.emptyDataSetView removeFromSuperview];
    }
    [self swizzingReloadData];
    objc_setAssociatedObject(self, kEmptyDataSetDelegate, [[WeakObjectContainer alloc] initWithWeakObject:emptyDataSetDelegate], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<EmptyDataSetDelegate>)emptyDataSetDelegate{
    WeakObjectContainer *container = objc_getAssociatedObject(self, kEmptyDataSetDelegate);
    return container.weakObject;
}

- (void)setEmptyDataSetView:(HSIEmptyDataSetView *)emptyDataSetView{
    objc_setAssociatedObject(self, kEmptyDataSetView, emptyDataSetView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (HSIEmptyDataSetView *)emptyDataSetView{
    HSIEmptyDataSetView *emptyDataSetView = objc_getAssociatedObject(self, kEmptyDataSetView);
    if (!emptyDataSetView) {
        UINib *nib = [UINib nibWithNibName:@"HSIEmptyDataSetView" bundle:nil];
        emptyDataSetView = [[nib instantiateWithOwner:nib options:nil] firstObject];
//        [self clearEmptyDataSetView:emptyDataSetView];
        [self setEmptyDataSetView:emptyDataSetView];
    }
    [self clearEmptyDataSetView:emptyDataSetView];
    if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(imageForEmptyDataSet:)]) {
        UIImage *image = [self.emptyDataSetDelegate imageForEmptyDataSet:self];
        if (image) {
            emptyDataSetView.imageView.image = image;
        }
    }
    
    if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(tipsForEmptyDataSet:)]) {
        emptyDataSetView.tipsLabel.hidden = NO;
        NSAttributedString *tips = [self.emptyDataSetDelegate tipsForEmptyDataSet:self];
        if (tips.length > 0) {
            emptyDataSetView.imageView.hidden = NO;
            emptyDataSetView.tipsLabel.attributedText = tips;
        }
    }
    
    if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(buttonTitleForEmptyDataSet:forState:)]) {
        NSAttributedString *buttonTitle = [self.emptyDataSetDelegate buttonTitleForEmptyDataSet:self forState:UIControlStateNormal];
        if (buttonTitle.length > 0) {
            emptyDataSetView.button.hidden = NO;
            [emptyDataSetView.button setAttributedTitle:buttonTitle forState:UIControlStateNormal];
            emptyDataSetView.button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
            emptyDataSetView.button.titleLabel.numberOfLines = 0;
            emptyDataSetView.button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [emptyDataSetView.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return emptyDataSetView;
}

- (void)buttonClick:(UIButton *)button{
    if (self.emptyDataSetDelegate && [self.emptyDataSetDelegate respondsToSelector:@selector(emptyDataSet:didTapButton:)]) {
        [self.emptyDataSetDelegate emptyDataSet:self didTapButton:button];
    }
}


/// Return current items count in dataSource
- (NSInteger)itemsCount{
    NSInteger itemsCount = 0;
    if (![self respondsToSelector:@selector(dataSource)]) {
        return itemsCount;
    }
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        id <UITableViewDataSource> dataSource = tableView.dataSource;
        NSInteger sections = 1;
        if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
            sections = [dataSource numberOfSectionsInTableView:tableView];
        }
        if (dataSource && [dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
            for (NSInteger section = 0; section < sections; section++) {
                itemsCount += [dataSource tableView:tableView numberOfRowsInSection:section];
            }
        }
    }else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        id <UICollectionViewDataSource> dataSource = collectionView.dataSource;
        NSInteger sections = 1;
        if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
            sections = [dataSource numberOfSectionsInCollectionView:collectionView];
        }
        if (dataSource && [dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
            for (NSInteger section = 0; section < sections; section++) {
                itemsCount += [dataSource collectionView:collectionView numberOfItemsInSection:section];
            }
        }
    }
    return itemsCount;
}

/// Hide all views in emptyDataSetView
- (void)clearEmptyDataSetView: (HSIEmptyDataSetView *)emptyDataSetView{
    emptyDataSetView.imageView.hidden = YES;
    emptyDataSetView.tipsLabel.hidden = YES;
    emptyDataSetView.button.hidden = YES;
}

/// New reloadData method
- (void)hsi_reloadData{
    //    [self hsi_reloadData];
    NSInteger itemsCount = [self itemsCount];
    if (itemsCount > 0) {
        [self.emptyDataSetView removeFromSuperview];
    }else{
        self.emptyDataSetView.frame = CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN-SAFE_TAB_HEIGHT-SAFE_TOP_HEIGHT+44);
        [self insertSubview:self.emptyDataSetView atIndex:0];
    }
}

/// Swizzing origin reloadData with hsi_reloadData
- (void)swizzingReloadData {
    SEL originalSelector = @selector(reloadData);
    if (!_impLookupTable) {
        _impLookupTable = [[NSMutableDictionary alloc] initWithCapacity:3];
    }
    
    for (NSDictionary *info in [_impLookupTable allValues]) {
        Class class = [info objectForKey:HSISwizzleInfoOwnerKey];
        NSString *selectorName = [info objectForKey:HSISwizzleInfoSelectorKey];
        
        if ([selectorName isEqualToString:NSStringFromSelector(originalSelector)]) {
            if ([self isKindOfClass:class]) {
                return;
            }
        }
    }
    
    Class baseClass = hsi_baseClassToSwizzleForTarget(self);
    NSString *key = hsi_implementationKey(baseClass, originalSelector);
    NSValue *impValue = [[_impLookupTable objectForKey:key] valueForKey:HSISwizzleInfoPointerKey];
    
    if (impValue || !key || !baseClass) {
        return;
    }
    Method method = class_getInstanceMethod(baseClass, originalSelector);
    IMP hsi_newImplementation = method_setImplementation(method, (IMP)hsi_original_implementation);
    NSDictionary *swizzledInfo = @{HSISwizzleInfoOwnerKey: baseClass,
                                   HSISwizzleInfoSelectorKey: NSStringFromSelector(originalSelector),
                                   HSISwizzleInfoPointerKey: [NSValue valueWithPointer:hsi_newImplementation]};
    
    [_impLookupTable setObject:swizzledInfo forKey:key];
}

NSString *hsi_implementationKey(Class class, SEL selector) {
    if (!class || !selector) {
        return nil;
    }
    NSString *className = NSStringFromClass([class class]);
    NSString *selectorName = NSStringFromSelector(selector);
    return [NSString stringWithFormat:@"%@_%@",className,selectorName];
}

Class hsi_baseClassToSwizzleForTarget(id target) {
    if ([target isKindOfClass:[UITableView class]]) {
        return [UITableView class];
    }
    else if ([target isKindOfClass:[UICollectionView class]]) {
        return [UICollectionView class];
    }
    else if ([target isKindOfClass:[UIScrollView class]]) {
        return [UIScrollView class];
    }
    return nil;
}

void hsi_original_implementation(id self, SEL _cmd) {
    Class baseClass = hsi_baseClassToSwizzleForTarget(self);
    NSString *key = hsi_implementationKey(baseClass, _cmd);
    
    NSDictionary *swizzleInfo = [_impLookupTable objectForKey:key];
    NSValue *impValue = [swizzleInfo valueForKey:HSISwizzleInfoPointerKey];
    
    IMP impPointer = [impValue pointerValue];
    [self hsi_reloadData];
    if (impPointer) {
        ((void(*)(id,SEL))impPointer)(self,_cmd);
    }
}


@end

@implementation WeakObjectContainer
- (instancetype)initWithWeakObject:(id)object{
    self = [super init];
    if (self) {
        _weakObject = object;
    }
    return self;
}

@end

