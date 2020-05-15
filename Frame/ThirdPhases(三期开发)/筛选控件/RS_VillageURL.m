//
//  RS_VillageURL.m
//  ylh-app-primary-ios
//
//  Created by 王青森 on 2019/5/27.
//  Copyright © 2019 巨商汇. All rights reserved.
//

#import "RS_VillageURL.h"

// 通过memberId或者小区村名称查询商家下的常用小区
NSString  * const RS_URL_MemberVillageSearchVillage = @"api/page/member/village/search-village";

// 调用海尔查询接口显示小区村信息
NSString * const RS_URL_SearchVillageForHaier = @"api/page/member/village/serch-village-for-haier";

// 调用海尔查询接口显示小区村信息
NSString * const RS_URL_MemberVillageDeleteVillage = @"api/page/member/village/delete-village-by-id";

// 常用小区村添加小区村
NSString * const RS_URL_MemberVillageInsertVillage = @"api/page/member/village/insert-village";

// 常用小区村编辑小区村
NSString * const RS_URL_MemberVillageUpdateVillage = @"api/page/member/village/update-village";

// 获取商家默认地址
NSString * const RS_URL_MemberVillageDefaultAddress = @"v2//portal/rest/settings/query-company-msg.ajax";
