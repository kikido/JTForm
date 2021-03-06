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
    [formDescriptor addSection:section];

    NSDate *now = [[NSDate alloc] init];

    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeDate rowType:JTFormRowTypeDate title:@"JTFormRowTypeDate"];
    row.value = now;
    [section addRow:row];

    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeTime rowType:JTFormRowTypeTime title:@"JTFormRowTypeTime"];
    row.value = now;
    [section addRow:row];

    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeDateTime rowType:JTFormRowTypeDateTime title:@"JTFormRowTypeDateTime"];
    row.value = now;
    [section addRow:row];

    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeCountDownTimer rowType:JTFormRowTypeCountDownTimer title:@"JTFormRowTypeCountDownTimer"];
    row.value = now;
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:@"00" rowType:JTFormRowTypeDate title:@"短"];
    row.placeHolder = @"请选择日期";
    row.image = [UIImage imageNamed:@"jt_money"];
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:@"01" rowType:JTFormRowTypeDate title:@"短"];
    row.placeHolder = @"请选择日期";
    row.image = [UIImage imageNamed:@"jt_money"];
    row.imageUrl = netImageUrl(30., 30.);
    [section addRow:row];
    
    #pragma mark - date inline
    
    section = [JTSectionDescriptor formSection];
    section.headerAttributedString = [NSAttributedString jt_attributedStringWithString:@"date inline" font:nil color:nil firstWordColor:nil];
    section.headerHeight = 30.;
    [formDescriptor addSection:section];
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeDateInline rowType:JTFormRowTypeDateInline title:@"JTFormRowTypeDateInline"];
    [section addRow:row];

    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeTimeInline rowType:JTFormRowTypeTimeInline title:@"JTFormRowTypeTimeInline"];
    [section addRow:row];

    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeDateTimeInline rowType:JTFormRowTypeDateTimeInline title:@"JTFormRowTypeDateTimeInline"];
    [section addRow:row];

    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeCountDownTimerInline rowType:JTFormRowTypeCountDownTimerInline title:@"JTFormRowTypeCountDownTimerInline"];
    [section addRow:row];

    
    #pragma mark - formatter
    
    section = [JTSectionDescriptor formSection];
    section.headerAttributedString = [NSAttributedString jt_attributedStringWithString:@"formatter\n\niOS14 之后，若想使用可以自定义 formatter 的选择行，建议使用 inline 行，或者您可以修改代码，将 JTFormRowTypeDate 对应的单元行替换成 JTFormDateCell" font:nil color:nil firstWordColor:nil];
    section.headerHeight = 120.;
    [formDescriptor addSection:section];
    
    NSDateFormatter *dateFormatter;
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeDate rowType:JTFormRowTypeDateInline title:@"JTFormRowTypeDateInline"];
    row.value = now;
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    row.valueFormatter = dateFormatter;
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeTime rowType:JTFormRowTypeTimeInline title:@"JTFormRowTypeTimeInline"];
    row.value = now;
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh小时 mm分";
    row.valueFormatter = dateFormatter;
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeDateTime rowType:JTFormRowTypeDateTimeInline title:@"JTFormRowTypeDateTimeInline"];
    row.value = now;
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    row.valueFormatter = dateFormatter;
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeCountDownTimer rowType:JTFormRowTypeCountDownTimerInline title:@"JTFormRowTypeCountDownTimerInline"];
    row.value = now;
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm";
    row.valueFormatter = dateFormatter;
    [section addRow:row];
        
    JTForm *form = [[JTForm alloc] initWithDescriptor:formDescriptor];
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
