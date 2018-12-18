//
//  DBModel.h
//  DBTest
//
//  Created by Jinbo Lu on 2018/6/13.
//  Copyright © 2018年 HangZhouSciener. All rights reserved.
//

#import "PTDB.h"

@interface PersonDBModel : PTDBModel
@property (nonatomic, strong) NSString *idNumber;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *age;

+ (PersonDBModel *)modelWithName:(NSString *)name idNumber:(NSString *)idNumber;
@end