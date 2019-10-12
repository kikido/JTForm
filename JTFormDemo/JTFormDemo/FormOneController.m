//
//  FormOneController.m
//  JTFormDemo
//
//  Created by dqh on 2019/6/12.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "FormOneController.h"

@interface NSDictionary (JTLog)
@end

@implementation NSDictionary (JTLog)
- (NSString *)description
{
    __block BOOL otherClass = false;
    [self.allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self js_otherClass:obj]) {
            otherClass = YES;
            *stop = YES;
        }
    }];
    NSString *jsonString;
    if (otherClass) {
        jsonString = [super description];
    } else {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (NSString *)debugDescription
{
    return [self description];
}

- (NSString *)descriptionWithLocale:(id)locale
{
    return [self description];
}

- (BOOL)js_otherClass:(id)object
{
    if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSIndexSet class]] || [object isKindOfClass:[NSNull class]]) {
        return NO;
    }
    return YES;
}
@end

@interface FormOneController () <UITextFieldDelegate>
@end

@implementation FormOneController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JTFormDescriptor *formDescriptor = [JTFormDescriptor formDescriptor];
    formDescriptor.addAsteriskToRequiredRowsTitle = YES;
    JTSectionDescriptor *section = nil;
    JTRowDescriptor *row = nil;
    
        
    section = [JTSectionDescriptor formSection];
    [formDescriptor addSection:section];
    
    
    row = [JTRowDescriptor rowDescriptorWithTag:@"01" rowType:JTFormRowTypeText title:@"Name"];
    row.placeHolder = [NSString stringWithFormat:@"请输入%@...", row.title];
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:@"收入" rowType:JTFormRowTypeInteger title:@"收入"];
    row.value = @"100";
    row.placeHolder = [NSString stringWithFormat:@"请输入%@...", row.title];
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:@"吃饭时间" rowType:JTFormRowTypePickerSelect title:@"吃饭时间"];
    row.selectorOptions = [JTOptionObject formOptionsObjectsWithValues:@[@1, @2, @3] displayTexts:@[@"早饭", @"午饭", @"晚饭"]];
    row.placeHolder = [NSString stringWithFormat:@"请输入%@...", row.title];
    [section addRow:row];

    row = [JTRowDescriptor rowDescriptorWithTag:@"交通方式" rowType:JTFormRowTypeAlertSelect title:@"交通方式"];
    row.selectorOptions = [JTOptionObject formOptionsObjectsWithValues:@[@1, @2, @3] displayTexts:@[@"自行车", @"高铁", @"汽车"]];
    row.placeHolder = [NSString stringWithFormat:@"请输入%@...", row.title];
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:@"出生日期" rowType:JTFormRowTypeDateInline title:@"出生日期"];
    row.placeHolder = [NSString stringWithFormat:@"请输入%@...", row.title];
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:@"欠款" rowType:JTFormRowTypeDecimal title:@"欠款"];
    row.placeHolder = [NSString stringWithFormat:@"请输入%@...", row.title];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    row.valueFormatter = formatter;
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:@"JTFormRowTypeSwitch" rowType:JTFormRowTypeSwitch title:@"JTFormRowTypeSwitch"];
    row.placeHolder = [NSString stringWithFormat:@"请输入%@...", row.title];
    row.value = @YES;
    [section addRow:row];

    section = [JTSectionDescriptor formSection];
    section.footerHeight = 12.;
    [formDescriptor addSection:section];

    row = [JTRowDescriptor rowDescriptorWithTag:@"欠款1" rowType:JTFormRowTypeDecimal title:@"欠款1"];
    row.placeHolder = [NSString stringWithFormat:@"请输入%@...", row.title];
    row.imageUrl = netImageUrl(30, 30);
    [section addRow:row];

    row = [JTRowDescriptor rowDescriptorWithTag:@"结婚日期" rowType:JTFormRowTypeDateInline title:@"结婚日期"];
    row.placeHolder = [NSString stringWithFormat:@"请输入%@...", row.title];
    [section addRow:row];

    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeSwitch rowType:JTFormRowTypeSwitch title:@"JTFormRowTypeSwitchJTFormRowTypeSwitchJTFormRowTypeSwitch"];
    row.placeHolder = [NSString stringWithFormat:@"请输入%@...", row.title];
    row.imageUrl = netImageUrl(30, 30);
    row.required = YES;
    [section addRow:row];
    
    
    JTForm *form = [[JTForm alloc] initWithDescriptor:formDescriptor];
    form.frame = CGRectMake(0, 0, kJTScreenWidth, kJTScreenHeight-64.);
    [self.view addSubview:form];
    self.form = form;
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kJTScreenWidth, 200)];
    
    ASNetworkImageNode *imageNode = [[ASNetworkImageNode alloc] init];
    imageNode.frame = CGRectMake(0, 0, 200, 200);
    imageNode.URL = netImageUrl(200, 200);
    [header addSubnode:imageNode];
    
    self.form.tableView.tableHeaderView = header;
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kJTScreenHeight- 64. -90., kJTScreenWidth, 90.)];
//    view.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:view];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
