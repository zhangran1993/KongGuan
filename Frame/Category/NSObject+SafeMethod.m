//
//  NSObject+SafeMethod.m
//  ylh-app-primary-ios
//
//  Created by 李春慧 on 2018/8/29.
//  Copyright © 2018年 巨商汇. All rights reserved.
//

#import "NSObject+SafeMethod.h"

@implementation NSObject (SafeMethod)

BOOL isSafeObj(id _Nullable anObject) {
    
    BOOL res = NO;
    
    if (anObject && ![anObject isKindOfClass:[NSNull class]] && ![anObject isEqual:[NSNull null]]) {
        res = YES;
    }
    
    return res;
}

BOOL isSafeArray(id _Nullable anObject) {
    
    BOOL res = NO;
    
    if (anObject && isSafeObj(anObject)) {
        
        if ([anObject isKindOfClass:[NSArray class]] || [anObject isKindOfClass:[NSMutableArray class]]) {
            
            res = YES;
            
        }
        
    }
    
    return res;
}

BOOL isSafeString(id _Nullable anObject) {
    
    BOOL res = NO;
    
    if (anObject && isSafeObj(anObject)) {
        
        if ([anObject isKindOfClass:[NSString class]] || [anObject isKindOfClass:[NSMutableString class]]) {
            
            NSString *stringTemp = [(NSString *)anObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            if ([stringTemp isEqualToString:@"<null>"] || [stringTemp isEqualToString:@"(null)"] || [stringTemp isEqualToString:@"null"]) {
                
                res = NO;
                
            } else {
                
                res = YES;
                
            }
            
        }
        
    }
    
    return res;
}

BOOL isNonemptyString(id _Nullable anObject) {
    
    BOOL res = NO;
    
    if (isSafeString(anObject)) {
        
        NSString *stringTemp = [(NSString *)anObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if (stringTemp.length) {
            
            res = YES;
            
        }
        
    }
    
    return res;
    
}

BOOL isSafeDictionary(id _Nullable anObject) {
    
    BOOL res = NO;
    
    if (anObject && isSafeObj(anObject)) {
        
        if ([anObject isKindOfClass:[NSDictionary class]] || [anObject isKindOfClass:[NSMutableDictionary class]]) {
            res = YES;
        }
    }
    
    return res;
}



NSString * _Nonnull safeString(id _Nullable anObject) {
    
    if (anObject && isNonemptyString(anObject)) {
        
        return [(NSString *)anObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
    } else if (anObject && isSafeObj(anObject)) {
        
        return [NSString stringWithFormat:@"%@", anObject];
        
    }
    
    return @"";
}


BOOL arrayHasData(id _Nullable anObject) {
    
    BOOL res = NO;
    
    if (anObject && isSafeArray(anObject)) {
        
        NSArray *array = anObject;
        
        if (array.count) {
            res = YES;
        }
        
    }
    
    return res;
}

@end
