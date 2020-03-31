//
//  StationItems.m
//  Frame
//
//  Created by hibayWill on 2018/3/16.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "StationItems.h"
#import "FrameBaseRequest.h"

@implementation StationItems

- (StationItems *)initWithDetailDic:(NSDictionary *)dic{
    @try {
        if (self == [super init]) {
            _id = [dic objectForKey:@"id"] ;
            _address = [dic objectForKey:@"address"] ;
            _airport = [dic objectForKey:@"airport"] ;
            _alarmDisplay = [dic objectForKey:@"alarmDisplay"] ;
            _alias = [dic objectForKey:@"alias"] ;
            _category = [dic objectForKey:@"category"] ;
            _code = [dic objectForKey:@"code"] ;
            _stationCode = [dic objectForKey:@"stationCode"] ;
            _name = [dic objectForKey:@"name"] ;
            _stationName = [dic objectForKey:@"stationName"] ;
            _level = [dic objectForKey:@"level"] ;
            _desc = [dic objectForKey:@"description"] ;
            _lastUpdateTime = [dic objectForKey:@"lastUpdateTime"] ;
            _latitude = [dic objectForKey:@"latitude"] ;
            _longitude = [dic objectForKey:@"longitude"] ;
            _status = [dic objectForKey:@"status"] ;
            _nearField = [dic objectForKey:@"nearField"] ;
            _name = [dic objectForKey:@"name"] ;
            _operatorId = [dic objectForKey:@"operatorId"] ;
            _code = [dic objectForKey:@"code"] ;
            _NowStatus = [dic objectForKey:@"NowStatus"] ;
            _AirConditionNum = [dic objectForKey:@"AirConditionNum"] ;
            _airTagList = [dic objectForKey:@"airTagList"] ;
            _picture = [dic objectForKey:@"picture"] ;
            //double pointNum = [[dic objectForKey:@"points"] doubleValue];
            _points = [dic objectForKey:@"points"];//[NSString stringWithFormat:@"%.1f",pointNum];//[[dic objectForKey:@"points"] floatValue];
            _createTime = [[dic objectForKey:@"createTime"] longValue];
            _realTimeValue = [[dic objectForKey:@"realTimeValue"] intValue];
            _PatrolTime =  [FrameBaseRequest getDateByTimesp:[[dic objectForKey:@"time"] doubleValue] dateType:@"YYYY-MM-dd"];
            
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
/*
*/
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
+ (NSDictionary *)mj_replacedKeyFromPropertyName

{

    return @{@"points":@"value" , @"stationName":@"name"};

}
@end
