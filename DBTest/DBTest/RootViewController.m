//
//  RootViewController.m
//  DBTest
//
//  Created by Jinbo Lu on 2018/12/17.
//  Copyright © 2018 HangZhouSciener. All rights reserved.
//

#import "RootViewController.h"
#import "DBModel.h"

@interface RootViewController ()
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, weak) UILabel *totalDataLabel;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [DBModel pt_queryObjectWithKey:[DBModel pt_primaryKey] offset:6 limit:5 ascending:YES];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBModel *model = _dataArray[indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.idNumber;
    cell.backgroundColor = model.sex.boolValue ? UIColor.orangeColor : UIColor.whiteColor;
    cell.textLabel.textColor = model.sex.boolValue ? UIColor.whiteColor : UIColor.blackColor;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_headerView == nil) {
        CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
        [self addTotalDataLabel];
        [self addClickButton];
    }
    
    return _headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 100.f;
}

#pragma mark - Click

- (void)buttonClick:(UIButton *)button {
    switch (button.tag) {
        case 0://增加
        {
            long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
            NSMutableArray *addModelArray = @[].mutableCopy;
            for (NSInteger i = 0; i < 5; i++) {
                DBModel *model = [DBModel modelWithName:[NSString stringWithFormat:@"%ld",i] idNumber:[NSString stringWithFormat:@"%lld",timestamp + i]];
                [addModelArray addObject:model];
            }
            [DBModel pt_updateObjectArray:addModelArray];
            
        }
            break;
        case 1://修改
        {
            if (_dataArray.count >= 2) {
                DBModel *model0 = _dataArray[0];
                model0.sex = model0.sex.boolValue ? @"0" : @"1";
                DBModel *model1 = _dataArray[1];
                model1.sex = model1.sex.boolValue ? @"0" : @"1";
                
                [DBModel pt_updateObjectArray:@[model0,model1]];
            }
        }
            break;
        case 2://删除
            if (_dataArray.count) {
                DBModel *model0 = _dataArray[0];
                [DBModel pt_deleteObjectWithPrimaryKeyArray:@[model0.idNumber]];
            }
            break;
            
        default:
            break;
    }
    _dataArray = [DBModel pt_queryObjectAll];
    [self.tableView reloadData];
}


#pragma mark - Private
- (void)addTotalDataLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"当前数据：%ld",_dataArray.count];
    [_headerView addSubview:label];
    _totalDataLabel = label;
}

- (void)addClickButton {
    
    NSArray *titleArray = @[@"新增/5条",@"修改/2条",@"删除/1条"];
    for (NSInteger i = 0; i < titleArray.count; i++) {
        CGFloat buttonHeight = 30.f;
        CGFloat buttonWidth = 65.f;
        CGFloat space = (_headerView.frame.size.width - (titleArray.count * buttonWidth)) / (titleArray.count + 1);
        CGFloat y = _totalDataLabel.frame.origin.y + buttonHeight + 20;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((i + 1)*space + i*buttonWidth, y, buttonWidth, buttonHeight)];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.layer.borderColor = UIColor.orangeColor.CGColor;
        button.layer.borderWidth = 0.5;
        button.layer.cornerRadius = 4;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:button];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
