# PTDB
###【安装】
        pod 'PTDB'

###【使用示列】
1.模型对象继承 PTDBModel，*模型对象的属性必须全是string类型*

``` 
@interface PersonModel : PTDBModel

@property (nonatomic, strong) NSString *idNumber;
@property (nonatomic, strong) NSString *name;
@end 
```
2.配置 模型对象

``` 
#import "PersonDBModel.h"

@implementation PersonDBModel
/*
 *必须
 *重写父类的该方法，返回模型的一个属性 作为表字段的主键
 *如 idNumber 字段表示PersonDBModel的唯一值，所有的模型实例的该值都不可能重复
 */
+ (NSString *)pt_primaryKey{
    return @"idNumber";
}

/*
 *可选 
 *重写父类的该方法，数据库新增的字段需要在该方法中返回 
 *如 PersonDBModel 新增了属性 ‘age’ 和 ‘gender’
 */
+ (NSArray *)pt_newKeyArray{
    return @[@"age",@"gender"];
}
@end
``` 

3.使用

```
3.1 增、改数据

+ (void)pt_updateObjectArray:(NSArray<PTDBModel *> *)array


//新增
- (void)addData{
    long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
    NSMutableArray *addModelArray = @[].mutableCopy;
    for (NSInteger i = 0; i < 5; i++) {
        PersonDBModel *model = [PersonDBModel modelWithName:[NSString stringWithFormat:@"%ld",i] idNumber:[NSString stringWithFormat:@"%lld",timestamp + i]];
        model.age = [NSString stringWithFormat:@"%ld",_addClickCount];
        [addModelArray addObject:model];
    }
    [PersonDBModel pt_updateObjectArray:addModelArray];
}

//修改
- (void)updateData{
    PersonDBModel *model = _dataArray[0];
    model.sex = model.sex.boolValue ? @"0" : @"1";
    [PersonDBModel pt_updateObjectArray:@[model]];
}

3.2 删除

+ (void)pt_deleteObjectWithPrimaryKeyArray:(NSArray<NSString *> *)array

- (void)deleteData{
    PersonDBModel *model0 = _dataArray[0];
    [PersonDBModel pt_deleteObjectWithPrimaryKeyArray:@[model0.idNumber]];
}

3.3 查询
+ (NSArray *)pt_fetchObjectAll;
+ (instancetype)pt_fetchObjectWithPrimaryKey:primaryKey;
+ (NSArray *)pt_fetchObjectWithKey:(NSString *)key value:(NSString *)value;
+ (NSArray *)pt_fetchObjectWithKey:(NSString *)key offset:(NSInteger)offset limit:(NSInteger)limit ascending:(BOOL)ascending;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //查找所有人
    _dataArray = [PersonDBModel pt_fetchObjectAll];
    //查找所有名字为 jack 的人
    
    _dataArray = [PersonDBModel pt_fetchObjectWithKey:@"name" value:@"jack"];
    
    //查找 以年龄为排序 以升序的方式 从第0位开始 取前20条数据
    _dataArray = [PersonDBModel pt_fetchObjectWithKey:@"age" offset:0 limit:20 ascending:YES];
    
    //查找 idNumber 为 330127199100998888 的某个人
    PersonDBModel *someBody = [PersonDBModel pt_fetchObjectWithPrimaryKey:@"330127199100998888"];

}

```  

 


