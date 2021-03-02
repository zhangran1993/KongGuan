//
//  KG_RunManagerDetailModel.h
//  Frame
//
//  Created by zhangran on 2021/2/19.
//  Copyright © 2021 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface handoverPositionInfoModel : NSObject

@property (nonatomic,assign)      BOOL      enableGenerate;              //当前能否点击生成运行报告。
//如果具有生成运行报告的权限，并且没有生成运行报告，则为true。
@property (nonatomic,assign)      BOOL      enableHandover;  //当前是否可点击交班，运行报告详情页是否可点击
//如果已经生成了运行报告，并且已经接班了，则为true。点击后，直接进行交班操作。
//如果已经生成运行报告，但是尚未接班即finishSucceed为false，则为true。点击后，提示用户先去接班。
//如果没有生成运行报告即runReportId为空，enableHandover则为true。点击后，提示用户生成运行报告。
@property (nonatomic,assign)      BOOL      finishHandover;              //是否已经完成交班
@property (nonatomic,assign)      BOOL      finishSucceed;               //是否已经完成接班
@property (nonatomic,assign)      BOOL      generateAuth;                 //是否具有生成运行报告的权限
@property (nonatomic,copy)      NSString   *positionCode;     //值班岗位编码
@property (nonatomic,copy)      NSString   *runReportId;              //运行报告的id
@property (nonatomic,copy)      NSString   *startOnDutyDay;//当前岗位开始值班的时间，用来作为生成运行报告的开始时间
@property (nonatomic,copy)      NSString   *stationCode;     //值班范围编码
@property (nonatomic,copy)      NSString   *stationName;     //值班范围名称
@property (nonatomic,copy)      NSString   *typeCode;     //值班类型
@end

@interface succeedPositionInfoModel : NSObject
@property (nonatomic,copy)      NSString   *typeCode;             //值班类型
@property (nonatomic,copy)      NSString   *positionCode;         //值班岗位编码
@property (nonatomic,copy)      NSString   *stationCode;          //值班范围编码
@property (nonatomic,copy)      NSString   *stationName;          //值班范围名称
@property (nonatomic,copy)      NSString   *runReportId;          //运行报告的id
@property (nonatomic,assign)      BOOL finishSucceed;        //是否已经完成接班
@property (nonatomic,assign)      BOOL   enableSucceed;        //当前是否可接班




@end


@interface KG_RunManagerDetailModel : NSObject

//如果运行报告尚为生成即runReportId为空，则为true，前台提示用户生成运行报告。
//如果运行报告已经生成，并且尚为完成接班，则为true。如果已经接班完成，则为false。
@property (nonatomic,assign)      BOOL enableGenerateGlobal;             //是否可生成运行报告
@property (nonatomic,assign)      BOOL enableSucceedGlobal;              //是否可接班
@property (nonatomic,assign)      BOOL enableHandoverGlobal;            //是否可交班
@property (nonatomic,strong)    NSArray    <handoverPositionInfoModel*>*handoverPositionInfo;                //岗位交班信息
@property (nonatomic,strong)    NSArray    <succeedPositionInfoModel*> *succeedPositionInfo;                 //岗位接班信息

@end




NS_ASSUME_NONNULL_END
