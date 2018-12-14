//
//  PTDBModel.h
//  PTDB
//
//  Created by Jinbo Lu on 2018/12/13.
//  Copyright © 2018 HangZhouSciener. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PTDBModel : NSObject
/**
 *作为主键
 * 子类必须重载该方法
 */
+ (NSString *)pt_primaryKey;

/**
 * 数据库新增字段 新增的字段必须在该方法返回
 * 如果需要兼容 数据库 子类必须重载该方法
 */
/** */
+ (NSArray *)pt_newKeys;

/**修改 、新增*/
+ (void)pt_updateObjectArray:(NSArray *)array completion:(void(^)(BOOL success,NSError *error))completion;

/**
 *删除单个数据
 *通过主键的值 删除
 */
+ (void)pt_deleteObjectWithPrimaryValue:(NSString *)primaryValue;
/**
 *删除全部数据
 */
+ (void)pt_deleteObjectAll;

/** 查询 */
+ (NSArray *)pt_queryObjectAll;
+ (instancetype)pt_queryObjectWithPrimaryValue:(NSString *)primaryValue;
+ (NSArray *)pt_queryObjectWithKey:(NSString *)key value:(NSString *)value;
@end

NS_ASSUME_NONNULL_END
