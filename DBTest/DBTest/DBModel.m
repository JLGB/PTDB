//
//  DBModel.m
//  DBTest
//
//  Created by Jinbo Lu on 2018/6/13.
//  Copyright © 2018年 HangZhouSciener. All rights reserved.
//

#import "DBModel.h"

@implementation DBModel

+ (NSString *)pt_primaryKey{
    return @"idNumber";
}

+ (NSArray *)pt_newKeys{
    return @[@"age"];
}

+ (DBModel *)modelWithName:(NSString *)name idNumber:(NSString *)idNumber{
    DBModel *model = [DBModel new];
    model.name = name;
    model.idNumber = idNumber;
    return model;
}

@end
