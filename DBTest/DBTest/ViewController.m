//
//  ViewController.m
//  DBTest
//
//  Created by Jinbo Lu on 2018/6/13.
//  Copyright © 2018年 HangZhouSciener. All rights reserved.
//

#import "ViewController.h"
#import "DBModel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIStepper *setper;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)insertData:(int)value{
    NSDate *date1 = [NSDate date];
    
    NSMutableArray *modelArray = @[].mutableCopy;
    
    for (NSInteger i = 0; i < 100; i++) {//可以通过增加 遍历的次数，查看数据库批量存储的效率
        DBModel *model = [DBModel new];
        model.idNumber = [NSString stringWithFormat:@"%d",value];
        model.name = [NSString stringWithFormat:@"jack - %ld",i];
        model.fater = @"james";
        model.mother = @"lucy";
        model.age = @"18";
        model.address = @"杭州市 余杭区 文一西路 淘宝（西溪园区）";
        
        [modelArray addObject:model];
    }
   
    [DBModel pt_updateObjectArray:modelArray completion:^(BOOL success, NSError *error) {
        NSLog(@"%f",[[NSDate date] timeIntervalSinceNow]-[date1 timeIntervalSinceNow]);
    }];
    _label.text = [NSString stringWithFormat:@"%ld",[DBModel pt_queryObjectAll].count];
}

- (IBAction)action:(UIStepper *)sender {
    [self insertData:(sender.value)];
}

- (IBAction)switchAction:(id)sender {
    _label.text = [NSString stringWithFormat:@"%lu",(unsigned long)[DBModel pt_queryObjectAll].count];
}



@end
