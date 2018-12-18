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
/*
 *必须
 *重写父类的该方法，返回模型的一个属性 作为表字段的主键
 *如 idNumber 字段表示PersonDBModel的唯一值，所有的模型实例的该值都不可能重复
 */
+ (NSString *)pt_primaryKey;

/*
 *可选
 *重写父类的该方法，数据库新增的字段需要在该方法中返回
 *如 PersonDBModel 新增了属性 ‘age’ 和 ‘gender’
 */
+ (NSArray *)pt_newKeyArray;

/**修改 、新增*/
+ (void)pt_updateObjectArray:(NSArray<PTDBModel *> *)array;

/**删除多个数据 *array 主键*/
+ (void)pt_deleteObjectWithPrimaryKeyArray:(NSArray<NSString *> *)array;
/** 删除全部数据 */
+ (void)pt_deleteObjectAll;

/** 查询 */
+ (NSArray *)pt_fetchObjectAll;
+ (instancetype)pt_fetchObjectWithPrimaryKey:(NSString *)primaryKey;
+ (NSArray *)pt_fetchObjectWithKey:(NSString *)key value:(NSString *)value;
+ (NSArray *)pt_fetchObjectWithKey:(NSString *)key offset:(NSInteger)offset limit:(NSInteger)limit ascending:(BOOL)ascending;
@end

NS_ASSUME_NONNULL_END
