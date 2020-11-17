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
    [formDescriptor addSection:section];
    
    NSArray *selectOptions = [JTOptionObject optionObjectsWithOptionValues:@[@1, @2, @3, @4] optionTexts:@[@"早饭", @"午饭", @"晚饭", @"名字很长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长"]];
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypePushSelect rowType:JTFormRowTypePushSelect title:@"JTFormRowTypePushSelect"];
    row.selectorOptions = selectOptions;
    row.selectorTitle = @"吃饭";
    row.required = YES;
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeMultipleSelect rowType:JTFormRowTypeMultipleSelect title:@"JTFormRowTypeMultipleSelect"];
    row.selectorOptions = selectOptions;
    row.placeHolder = @"请选择吃饭类型...";
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeSheetSelect rowType:JTFormRowTypeSheetSelect title:@"JTFormRowTypeSheetSelect"];
    row.selectorOptions = selectOptions;
    row.image = [UIImage imageNamed:@"jt_money"];
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeAlertSelect rowType:JTFormRowTypeAlertSelect title:@"JTFormRowTypeAlertSelect"];
    row.selectorOptions = selectOptions;
    row.imageUrl = netImageUrl(31., 31.);
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypePickerSelect rowType:JTFormRowTypePickerSelect title:@"JTFormRowTypePickerSelect"];
    row.selectorOptions = selectOptions;
    row.value = [JTOptionObject optionsObjectWithOptionValue:@2 optionText:@"午饭"];
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:@"0" rowType:JTFormRowTypePickerSelect title:@"短"];
    row.selectorOptions = selectOptions;
    row.value = [JTOptionObject optionsObjectWithOptionValue:@2 optionText:@"午饭"];
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypePushButton rowType:JTFormRowTypePushButton title:@"JTFormRowTypePushButton"];
    row.action.rowBlock = ^(JTRowDescriptor * _Nonnull sender) {
        RootViewController *vc = [[RootViewController alloc] init];
        vc.title = @"do something";
        [self.navigationController pushViewController:vc animated:YES];
    };
    [section addRow:row];
    
    #pragma mark - value transformer
    section = [JTSectionDescriptor formSection];
    section.headerAttributedString = [NSAttributedString jt_attributedStringWithString:@"value transformer" font:nil color:nil firstWordColor:nil];
    section.headerHeight = 30.;
    [formDescriptor addSection:section];

    row = [JTRowDescriptor rowDescriptorWithTag:@"10" rowType:JTFormRowTypeMultipleSelect title:@"JTFormRowTypeMultipleSelect"];
    row.selectorOptions = selectOptions;
    row.valueTransformer = [JTTransform class];
    row.value = [JTOptionObject optionObjectsWithOptionValues:@[@1, @2] optionTexts:@[@"早饭", @"午饭"]];
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:@"11" rowType:JTFormRowTypePickerSelect title:@"短"];
    row.selectorOptions = selectOptions;
    row.valueTransformer = [JTTransform class];
    row.value = [JTOptionObject optionsObjectWithOptionValue:@2 optionText:@"午饭"];
    [section addRow:row];
    
    JTForm *form = [[JTForm alloc] initWithDescriptor:formDescriptor];
    form.frame = self.view.bounds;
    [self.view addSubview:form];
    self.form = form;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        JTRowDescriptor *r = [JTRowDescriptor rowDescriptorWithTag:@"01" rowType:JTFormRowTypeDate title:@"测试 1"];
        [self.form addRow:r];
    });
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
