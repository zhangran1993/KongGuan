//
//  AlarmUserItems.m
//  Frame
//
//  Created by hibayWill on 2018/5/8.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "AlarmUserItems.h"

@implementation AlarmUserItems



- (AlarmUserItems *)initWithDetailDic:(NSDictionary *)dic{
    @try {
        if (self == [super init]) {
            _id = [dic objectForKey:@"id"];
            _createTime = [[dic objectForKey:@"createTime"] doubleValue];
            _lastUpdateTime = [[dic objectForKey:@"lastUpdateTime"] doubleValue];
            _measureTagCode = [dic objectForKey:@"measureTagCode"] ;
            _realTimeValue = [[dic objectForKey:@"realTimeValue"] doubleValue];
            _stationCode = [dic objectForKey:@"stationCode"] ;
            _stationName = [dic objectForKey:@"stationName"] ;
            _engineRoomName = [dic objectForKey:@"engineRoomName"] ;
            _equipmentName = [dic objectForKey:@"equipmentName"] ;
            _tagName = [dic objectForKey:@"tagName"] ;
            _stationCode = [dic objectForKey:@"stationCode"] ;
            _name = [dic objectForKey:@"name"] ;
            _equipmentCode = [dic objectForKey:@"equipmentCode"] ;
            _equipmentGroup = [dic objectForKey:@"equipmentGroup"] ;
            _equipmentType = [dic objectForKey:@"equipmentType"] ;
            _type = [dic objectForKey:@"type"] ;
            _userAccount = [dic objectForKey:@"userAccount"] ;
            _name = [dic objectForKey:@"name"] ;
            _contactLevel = [dic objectForKey:@"contactLevel"] ;
            _tel = [dic objectForKey:@"tel"] ;
            _email = [dic objectForKey:@"email"] ;
            _remark = [dic objectForKey:@"remark"] ;
            _powerLevel = [dic objectForKey:@"powerLevel"] ;
            _engineRoomCode = [dic objectForKey:@"engineRoomCode"] ;
            _measureTagName = [dic objectForKey:@"measureTagName"] ;
            _realTimeValueAlias = [dic objectForKey:@"realTimeValueAlias"] ;
            _imgurls = [dic objectForKey:@"imgurls"] ;
            _createDate = [[dic objectForKey:@"createDate"] doubleValue];
            _hangupStatus = [[dic objectForKey:@"hangupStatus"] boolValue];
            
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



//@dynamic description;

//@synthesize description;


 @synthesize
 
 编译器期间，让编译器自动生成getter/setter方法。
 
 当有自定义的存或取方法时，自定义会屏蔽自动生成该方法
 @dynamic
 
 告诉编译器，不自动生成getter/setter方法，避免编译期间产生警告
 
 然后由自己实现存取方法
 
 
 */

@end
