//
//  DateViewController.m
//  JTForm
//
//  Created by dqh on 2019/5/7.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "DateViewController.h"

@interface DateViewController ()

@end

@implementation DateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JTFormDescriptor *formDescriptor = [JTFormDescriptor formDescriptor];
    formDescriptor.addAsteriskToRequiredRowsTitle = YES;
    JTSectionDescriptor *section = nil;
    JTRowDescriptor *row = nil;
    
    
#pragma mark - date
    
    section = [JTSectionDescriptor formSection];
    
    [formDescriptor addFormSection:section];

    NSDate *now = [[NSDate alloc] init];

    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeDate rowType:JTFormRowTypeDate title:@"JTFormRowTypeDate"];
    row.value = now;
    [section addFormRow:row];

    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeTime rowType:JTFormRowTypeTime title:@"JTFormRowTypeTime"];
    row.value = now;
    [section addFormRow:row];

    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeDateTime rowType:JTFormRowTypeDateTime title:@"JTFormRowTypeDateTime"];
    row.value = now;
    [section addFormRow:row];

    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeCountDownTimer rowType:JTFormRowTypeCountDownTimer title:@"JTFormRowTypeCountDownTimer"];
    row.value = now;
    [section addFormRow:row];

    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeDateInline rowType:JTFormRowTypeDateInline title:@"JTFormRowTypeDateInline"];
    row.value = now;
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:@"00" rowType:JTFormRowTypeDate title:@"短"];
    row.placeHolder = @"请选择日期";
    row.image = [UIImage imageNamed:@"jt_money"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:@"01" rowType:JTFormRowTypeDate title:@"短"];
    row.placeHolder = @"请选择日期";
    row.image = [UIImage imageNamed:@"jt_money"];
    row.imageUrl = netImageUrl(30., 30.);
    [section addFormRow:row];
    
    #pragma mark - formatter
    
    section = [JTSectionDescriptor formSection];
    section.headerAttributedString = [NSAttributedString attributedStringWithString:@"formatter" font:nil color:nil firstWordColor:nil];
    section.headerHeight = 30.;
    [formDescriptor addFormSection:section];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeDate rowType:JTFormRowTypeDate title:@"JTFormRowTypeDate"];
    row.value = now;
    row.valueFormatter = dateFormatter;
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeTime rowType:JTFormRowTypeTime title:@"JTFormRowTypeTime"];
    row.value = now;
    row.valueFormatter = dateFormatter;
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeDateTime rowType:JTFormRowTypeDateTime title:@"JTFormRowTypeDateTime"];
    row.value = now;
    row.valueFormatter = dateFormatter;
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeCountDownTimer rowType:JTFormRowTypeCountDownTimer title:@"JTFormRowTypeCountDownTimer"];
    row.value = now;
    row.valueFormatter = dateFormatter;
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeDateInline rowType:JTFormRowTypeDateInline title:@"JTFormRowTypeDateInline"];
    row.value = now;
    row.valueFormatter = dateFormatter;
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
