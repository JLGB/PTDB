//
//  DBModel.m
//  DBTest
//
//  Created by Jinbo Lu on 2018/6/13.
//  Copyright © 2018年 HangZhouSciener. All rights reserved.
//

#import "PersonDBModel.h"

@implementation PersonDBModel

+ (NSString *)pt_primaryKey{
    return @"idNumber";
}

+ (NSArray *)pt_newKeyArray{
    return @[@"age"];
}

+ (PersonDBModel *)modelWithName:(NSString *)name idNumber:(NSString *)idNumber{
    PersonDBModel *model = [PersonDBModel new];
    model.name = name;
    model.idNumber = idNumber;
    return model;
}

@end
