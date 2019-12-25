//
//  Patroltems.m
//  Frame
//
//  Created by hibayWill on 2018/3/29.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "Patroltems.h"

@implementation Patroltems

- (Patroltems *)initWithDetailDic:(NSDictionary *)dic{
    @try {
        if (self == [super init]) {
            _tid = [[dic objectForKey:@"tid"] intValue];
            _createTime = [[dic objectForKey:@"createTime"] doubleValue];
            _lastUpdateTime = [[dic objectForKey:@"lastUpdateTime"] doubleValue];
            _patrolTime = [[dic objectForKey:@"patrolTime"] doubleValue];
            _id = [dic objectForKey:@"id"] ;
            _patrolName = [dic objectForKey:@"patrolName"] ;
            _result = [dic objectForKey:@"result"] ;
            _stationCode = [dic objectForKey:@"stationCode"] ;
            _stationName = [dic objectForKey:@"stationName"] ;
            _specialName = [dic objectForKey:@"specialName"] ;
            _status = [dic objectForKey:@"status"] ;
            _typeCode = [dic objectForKey:@"typeCode"] ;
            _specialCode = [dic objectForKey:@"specialCode"] ;
            _typeName = [dic objectForKey:@"typeName"] ;
            _name = [dic objectForKey:@"name"] ;
            _operatorId = [dic objectForKey:@"operatorId"] ;
            _patrolCode = [dic objectForKey:@"patrolCode"] ;
            _code = [dic objectForKey:@"code"] ;
            _tagValue = [dic objectForKey:@"tagValue"] ;
            _title = [dic objectForKey:@"title"] ;
            _type = [dic objectForKey:@"type"] ;
            _value = [dic objectForKey:@"value"] ;
            _address = [dic objectForKey:@"address"] ;
            _airport = [dic objectForKey:@"airport"] ;
            _alias = [dic objectForKey:@"alias"] ;
            _picture = [dic objectForKey:@"picture"] ;
            _post = [dic objectForKey:@"post"] ;
            _imgurls = [dic objectForKey:@"imgurls"] ;
            _message = [dic objectForKey:@"message"] ;
            _sendtime = [dic objectForKey:@"sendtime"] ;
            _faceurl = [dic objectForKey:@"faceurl"] ;
            _desc = [dic objectForKey:@"description"] ;
            
            /*
            
            NSTimeInterval time = [[dic objectForKey:@"senddate"] doubleValue];
            NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
            NSDateFormatter *formatter = [NSDateFormatter new];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";//@"2008-4-24 16:30:15"
            _newsdate = [formatter stringFromDate:detaildate];
              */
        }
        return self;
    }
    @catch (NSException *exception) {
        NSLog(@"异常%@",exception);
    }
    @finally {
    }
}


//@dynamic description;

//@synthesize description;

/*
 @synthesize
 
 编译器期间，让编译器自动生成getter/setter方法。
 
 当有自定义的存或取方法时，自定义会屏蔽自动生成该方法
 @dynamic
 
 告诉编译器，不自动生成getter/setter方法，避免编译期间产生警告
 
 然后由自己实现存取方法
 
 
 */

@end
