//
//  SelectViewController.m
//  JTForm
//
//  Created by dqh on 2019/5/7.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "SelectViewController.h"
#import "JTTransform.h"

@interface SelectViewController ()

@end

@implementation SelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JTFormDescriptor *formDescriptor = [JTFormDescriptor formDescriptor];
    formDescriptor.addAsteriskToRequiredRowsTitle = YES;
    JTSectionDescriptor *section = nil;
    JTRowDescriptor *row = nil;
    
    
    #pragma mark - select
    
    section = [JTSectionDescriptor formSection];
    [formDescriptor addFormSection:section];
    
    NSArray *selectOptions = [JTOptionObject formOptionsObjectsWithValues:@[@1, @2, @3, @4] displayTexts:@[@"早饭", @"午饭", @"晚饭", @"名字很长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长"]];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypePushSelect rowType:JTFormRowTypePushSelect title:@"JTFormRowTypePushSelect"];
    row.selectorOptions = selectOptions;
    row.selectorTitle = @"吃饭";
    row.required = YES;
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeMultipleSelect rowType:JTFormRowTypeMultipleSelect title:@"JTFormRowTypeMultipleSelect"];
    row.selectorOptions = selectOptions;
    row.placeHolder = @"请选择吃饭类型...";
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeSheetSelect rowType:JTFormRowTypeSheetSelect title:@"JTFormRowTypeSheetSelect"];
    row.selectorOptions = selectOptions;
    row.image = [UIImage imageNamed:@"jt_money"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeAlertSelect rowType:JTFormRowTypeAlertSelect title:@"JTFormRowTypeAlertSelect"];
    row.selectorOptions = selectOptions;
    row.imageUrl = netImageUrl(30., 30.);
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypePickerSelect rowType:JTFormRowTypePickerSelect title:@"JTFormRowTypePickerSelect"];
    row.selectorOptions = selectOptions;
    row.value = [JTOptionObject formOptionsObjectWithValue:@2 displayText:@"午饭"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:@"0" rowType:JTFormRowTypePickerSelect title:@"短"];
    row.selectorOptions = selectOptions;
    row.value = [JTOptionObject formOptionsObjectWithValue:@2 displayText:@"午饭"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypePushButton rowType:JTFormRowTypePushButton title:@"JTFormRowTypePushButton"];
    row.action.rowBlock = ^(JTRowDescriptor * _Nonnull sender) {
        RootViewController *vc = [[RootViewController alloc] init];
        vc.title = @"do something";
        [self.navigationController pushViewController:vc animated:YES];
    };
    [section addFormRow:row];
    
    #pragma mark - value transformer
    section = [JTSectionDescriptor formSection];
    section.headerAttributedString = [NSAttributedString attributedStringWithString:@"value transformer" font:nil color:nil firstWordColor:nil];
    section.headerHeight = 30.;
    [formDescriptor addFormSection:section];

    row = [JTRowDescriptor formRowDescriptorWithTag:@"10" rowType:JTFormRowTypeMultipleSelect title:@"JTFormRowTypeMultipleSelect"];
    row.selectorOptions = selectOptions;
    row.valueTransformer = [JTTransform class];
    row.value = [JTOptionObject formOptionsObjectsWithValues:@[@1, @2] displayTexts:@[@"早饭", @"午饭"]];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:@"11" rowType:JTFormRowTypePickerSelect title:@"短"];
    row.selectorOptions = selectOptions;
    row.valueTransformer = [JTTransform class];
    row.value = [JTOptionObject formOptionsObjectWithValue:@2 displayText:@"午饭"];
    [section addFormRow:row];
    
    JTForm *form = [[JTForm alloc] initWithFormDescriptor:formDescriptor];
    form.frame = self.view.bounds;
    [self.view addSubview:form];
    self.form = form;
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
