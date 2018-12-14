//
//  DBModel.h
//  DBTest
//
//  Created by Jinbo Lu on 2018/6/13.
//  Copyright © 2018年 HangZhouSciener. All rights reserved.
//

#import "PTDB.h"

@interface DBModel : PTDBModel
@property (nonatomic, strong) NSString *idNumber;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *borthday;
@property (nonatomic, strong) NSString *fater;
@property (nonatomic, strong) NSString *mother;
@property (nonatomic, strong) NSString *address;
@end
