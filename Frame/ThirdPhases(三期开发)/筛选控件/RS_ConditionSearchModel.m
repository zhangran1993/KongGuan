//
//  RS_ConditionSearchModel.m
//  ylh-app-primary-ios
//
//  Created by 王青森 on 2019/7/1.
//  Copyright © 2019 巨商汇. All rights reserved.
//

#import "RS_ConditionSearchModel.h"

@implementation RS_ConditionSearchItemModel

- (instancetype)init {
    
    if (self = [super init]) {
        /** 默认设置 */
        self.width = 304.5 / 3.0; // cell宽
        self.height = 40.0;       // cell高
    }
    return self;
}

@end

@implementation RS_ConditionSearchModel

- (instancetype)init {
    
    if (self = [super init]) {
        /** 默认设置 */
        self.sectionName = @"";
        self.sectionType = @(RS_ConditionSearchSectionTypeNormal);
        self.intervalIsInput = @(YES); // 区间为输入
        self.allowMutiSelect = @(YES); // 允许多选
        self.allowPackUp = @(YES);     // 允许收起
        self.packUp = @(YES);          // 默认收起
        self.rowForPackUp = @(2);      // 收起后保留两行
    }
    return self;
}

- (void)calculateSize {
    
    switch (self.sectionType.integerValue) {
        case RS_ConditionSearchSectionTypeNormal:{
            self.row = (self.itemArrM.count + 2) / 3;
            self.height = self.row * 40;
            break;
        }
        case RS_ConditionSearchSectionTypeAdjustText:{
            self.row = 1;
            CGFloat rowWidth = 0.0;
            for (RS_ConditionSearchItemModel *itemModel in self.itemArrM) {
                CGFloat width = [NSString sizeForString:safeString(itemModel.itemName) font:Font(13) width:0 height:13].width;
                width += (26 + 20);
                itemModel.width = MAX(width > 305 ? 305 : width, 304.5 / 3.0);
                rowWidth += itemModel.width;
                if (rowWidth > 305) {
                    rowWidth = width + 10;
                    self.row++;
                }
            }
            self.height = self.row * 40;
            break;
        }
        case RS_ConditionSearchSectionTypeInterval:{
            self.height = 45;
            self.row = 1;
            break;
        }
        case RS_ConditionSearchSectionTypeToSecondView:{
            self.height = 0;
            self.row = 0;
            break;
        }
    }
}

#pragma mark - Getter
- (CGFloat)height {
    
    if (self.allowPackUp.boolValue) {
        if (self.isPackUp.boolValue) {
            switch (self.sectionType.integerValue) {
                case RS_ConditionSearchSectionTypeNormal:
                case RS_ConditionSearchSectionTypeAdjustText:
                    return self.rowForPackUp.integerValue * 40;
                case RS_ConditionSearchSectionTypeInterval:
                case RS_ConditionSearchSectionTypeToSecondView:
                    return 0;
            }
        }
    }
    return _height;
}

- (NSNumber *)isAllowPackUp {
    
    if (_allowPackUp.boolValue) {
        // 类型为normal或adjustText时，当且仅当允许收起且选项行数多于收起后保留的行数时返回true
        switch (self.sectionType.integerValue) {
            case RS_ConditionSearchSectionTypeNormal:
            case RS_ConditionSearchSectionTypeAdjustText:
                return @(self.row > self.rowForPackUp.integerValue);
        }
    }
    return _allowPackUp;
}

@end
