//
//  PTDBModel.m
//  PTDB
//
//  Created by Jinbo Lu on 2018/12/13.
//  Copyright © 2018 HangZhouSciener. All rights reserved.
//

#import "PTDBModel.h"
#import <FMDB/FMDB.h>
#import <objc/runtime.h>

static FMDatabaseQueue *_dataQueue;

@implementation PTDBModel

+ (NSString *)t_name{
    return [NSString stringWithFormat:@"t_%@",NSStringFromClass(self)];
}

+ (NSString *)pt_primaryKey{return nil;}

+ (NSArray *)pt_newKeys{
    return nil;
}

+ (void)setupTable{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
    NSString *t_name = [self t_name];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dataQueue = [FMDatabaseQueue databaseQueueWithPath:[NSString stringWithFormat:@"%@/%@.db",documentPath,@"pt_db"]];
    });
    
    [_dataQueue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL isExsitTable = false;
        {//Determine if the table already exists
            NSString *sql = [NSString stringWithFormat:@"select count(*) as 'count' from sqlite_master where type ='table' and name = '%@'", t_name];
            FMResultSet *resultSet = [db executeQuery:sql];
            if ([resultSet next]) {
                NSInteger count = [resultSet intForColumn:@"count"];
                isExsitTable = count != 0;
            }
            [resultSet close];
        }
        
        if (isExsitTable == false) {//create table
            NSArray *properties = [self properties];
            NSMutableString *tempKeysString = @"".mutableCopy;
            for (NSString *propertie in properties) {
                [tempKeysString appendString:[NSString stringWithFormat:@"%@ text,",propertie]];
            }
            NSString *keysString = [tempKeysString substringToIndex:tempKeysString.length - 1];
            
            NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ (%@);",t_name,keysString];
            [db executeUpdate:sql];
        }else{
            /*** if add new key to table,just do like this */
            for (NSString *key in [self pt_newKeys]) {
                if (![db columnExists:key inTableWithName:t_name]) {
                    NSString *alterSql = [NSString stringWithFormat:@"alter table %@ add %@ text",t_name,key];
                    [db executeUpdate:alterSql];
                }
            }
        }
    }];
}


+ (void)pt_updateObjectArray:(NSArray<PTDBModel *> *)array{
    [self setupTable];
    [_dataQueue inDatabase:^(FMDatabase * _Nonnull db) {
        [db beginTransaction];
        
        {// delete local extist data
            NSMutableString *tempValuesString = @"".mutableCopy;
            for (NSObject *obj in array) {
                [tempValuesString appendString:[NSString stringWithFormat:@"'%@',",[obj valueForKey:[self pt_primaryKey]]]];
            }
            NSString *valuesString = [tempValuesString substringToIndex:tempValuesString.length - 1];
            NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@ in (%@);",[self t_name],[self pt_primaryKey],valuesString];
            BOOL success = [db executeUpdate:sql];
            NSLog(@"删除：%@=%@   %@",[self pt_primaryKey],valuesString,success ? @"成功":@"失败");
        }
        
        //insert new data
        [array enumerateObjectsUsingBlock:^(NSObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableString *tempKeysString = @"".mutableCopy;
            NSMutableString *tempValuesString = @"".mutableCopy;
            for (NSString *property in [self properties]) {
                [tempKeysString appendString:[NSString stringWithFormat:@"'%@',",property]];
                
                NSString *value = [obj valueForKey:property] ?: @"";
                [tempValuesString appendString:[NSString stringWithFormat:@"'%@',",value]];
            }
            NSString *keysString = [tempKeysString substringToIndex:tempKeysString.length - 1];
            NSString *valuesString = [tempValuesString substringToIndex:tempValuesString.length - 1];
            NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@) values (%@);",[self t_name],keysString,valuesString];
            BOOL success = [db executeUpdate:sql];
            NSLog(@"插入：%@   %@",[self pt_primaryKey],success ? @"成功":@"失败");
        }];
        [db commit];
        
        NSLog(@"线程：%@ 队列：%@",[NSThread currentThread],dispatch_get_current_queue());
    }];
    [_dataQueue close];
}

+ (void)pt_deleteObjectWithPrimaryKey:primaryKey{
    [self setupTable];
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@ in ('%@');",[self t_name],[self pt_primaryKey],primaryKey];
    [_dataQueue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL success = [db executeUpdate:sql];
        NSLog(@"删除：%@：%@  %@",[self pt_primaryKey],primaryKey,success ? @"成功":@"失败");
    }];
    [_dataQueue close];
}

+ (void)pt_deleteObjectWithPrimaryKeyArray:(NSArray<NSString *> *)array{
    [self setupTable];
    NSMutableString *tempValueCondition = @"".mutableCopy;
    for (NSString *value in array) {
        [tempValueCondition appendFormat:@"'%@',",value];
    }
    NSString *valueCondition = [tempValueCondition substringWithRange:NSMakeRange(0, tempValueCondition.length-1)];
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@ in (%@);",[self t_name],[self pt_primaryKey],valueCondition];
    [_dataQueue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL success = [db executeUpdate:sql];
        NSLog(@"删除：%@：%@  %@",[self pt_primaryKey],valueCondition,success ? @"成功":@"失败");
    }];
    [_dataQueue close];
}

+ (void)pt_deleteObjectAll{
    [self setupTable];
    NSString *sql = [NSString stringWithFormat:@"delete from %@;",[self t_name]];
    [_dataQueue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL success = [db executeUpdate:sql];
        NSLog(@"删除：%@：",success ? @"成功":@"失败");
    }];
    [_dataQueue close];
}

+ (NSArray *)pt_queryObjectWithKey:(NSString *)key value:(NSString *)value{
    [self setupTable];
    NSArray *array = [self executeQueryKey:key value:value];
    [_dataQueue close];
    return array;
}

+ (NSArray *)pt_queryObjectWithKey:(NSString *)key offset:(NSInteger)offset limit:(NSInteger)limit ascending:(BOOL)ascending{
    [self setupTable];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ order by %@ %@ limit %ld,%ld",[self t_name],key,ascending ? @"asc" : @"desc",offset,limit];
    NSArray *array = [self executeQuerySql:sql];
    [_dataQueue close];
    return array;
}

+ (instancetype)pt_queryObjectWithPrimaryKey:primaryKey{
    NSArray *array = [self pt_queryObjectWithKey:[self pt_primaryKey] value:primaryKey];
    return array.count ? array.firstObject : nil;
}

+ (NSArray *)pt_queryObjectAll{
    [self setupTable];
    NSString *sql = [NSString stringWithFormat:@"select * from %@",[self t_name]];
    NSArray *array = [self executeQuerySql:sql];
    [_dataQueue close];
    return array;
}
#pragma mark - Private

+ (NSArray *)executeQueryKey:(NSString *)key value:(NSString *)value{
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@';",[self t_name],key,value];
    return  [self executeQuerySql:sql];
}

+ (NSArray *)executeQuerySql:(NSString *)sql{
    __block NSMutableArray *array = @[].mutableCopy;
    [_dataQueue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            NSArray *columnKeyArray = result.columnNameToIndexMap.allKeys;
            NSArray *propertyKeyArray = [self properties];
            
            NSObject *object = [self new];
            for (NSString *columnKey in columnKeyArray) {
                NSString *value = [result stringForColumn:columnKey];
                if (!value) continue;
                for (NSString *propertyKey in propertyKeyArray) {
                    if ([propertyKey compare:columnKey options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame) {
                        [object setValue:value forKey:propertyKey];
                    }
                }
            }
            [array addObject:object];
        }
        [result close];
    }];
    return array;
}

+ (NSArray *)properties{
    u_int count;
    objc_property_t *properties = class_copyPropertyList(self, &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}

@end
