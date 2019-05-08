//
//  TextViewController.m
//  JTForm
//
//  Created by dqh on 2019/5/6.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "TextViewController.h"

@implementation TextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    JTFormDescriptor *formDescriptor = [JTFormDescriptor formDescriptor];
    formDescriptor.addAsteriskToRequiredRowsTitle = YES;
    JTSectionDescriptor *section = nil;
    JTRowDescriptor *row = nil;
    
    
    #pragma mark - float text
    
    section = [JTSectionDescriptor formSection];
    section.headerAttributedString = [NSAttributedString attributedStringWithString:@"float text" font:nil color:nil firstWordColor:nil];
    section.headerHeight = 30.;
    [formDescriptor addFormSection:section];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeFloatText rowType:JTFormRowTypeFloatText title:@"测试"];
    row.required = YES;
    [section addFormRow:row];
    
    #pragma mark - formatter
    
    section = [JTSectionDescriptor formSection];
    section.headerAttributedString = [NSAttributedString attributedStringWithString:@"formatter" font:nil color:nil firstWordColor:nil];
    section.headerHeight = 30.;
    [formDescriptor addFormSection:section];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:@"20" rowType:JTFormRowTypeNumber title:@"百分比"];
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
    row.valueFormatter = numberFormatter;
    row.value = @(100);
    row.required = YES;
    row.image = [UIImage imageNamed:@"jt_money"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:@"21" rowType:JTFormRowTypeNumber title:@"人民币"];
    NSNumberFormatter *numberFormatter1 = [NSNumberFormatter new];
    numberFormatter1.numberStyle = NSNumberFormatterCurrencyStyle;
    row.valueFormatter = numberFormatter1;
    row.value = @(100);
    row.required = YES;
    row.image = [UIImage imageNamed:@"jt_money"];
    [section addFormRow:row];
    
    row  = [JTRowDescriptor formRowDescriptorWithTag:@"22" rowType:JTFormRowTypeNumber title:@"缓存"];
    row.valueFormatter = [NSByteCountFormatter new];
    row.imageUrl = netImageUrl(30., 30.);
    row.value = @(102404);
    [section addFormRow:row];
    
    #pragma mark - common
    
    section = [JTSectionDescriptor formSection];
    section.headerAttributedString = [NSAttributedString attributedStringWithString:@"common" font:nil color:nil firstWordColor:nil];
    section.headerHeight = 30.;
    [formDescriptor addFormSection:section];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeName rowType:JTFormRowTypeName title:@"JTFormRowTypeName"];
    row.placeHolder = @"请输入姓名...";
    row.required = YES;
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeEmail rowType:JTFormRowTypeEmail title:@"JTFormRowTypeEmail"];
    row.required = YES;
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeNumber rowType:JTFormRowTypeNumber title:@"JTFormRowTypeNumber"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeInteger rowType:JTFormRowTypeInteger title:@"JTFormRowTypeInteger"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeDecimal rowType:JTFormRowTypeDecimal title:@"JTFormRowTypeDecimal"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypePhone rowType:JTFormRowTypePhone title:@"JTFormRowTypePhone"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypePassword rowType:JTFormRowTypePassword title:@"JTFormRowTypePassword"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeName rowType:JTFormRowTypeName title:@"JTFormRowTypeName"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeURL rowType:JTFormRowTypeURL title:@"JTFormRowTypeURL"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:@"0" rowType:JTFormRowTypeName title:@"标题很长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:@"1" rowType:JTFormRowTypeName title:@"JTFormRowTypeName"];
    row.value = @"内容很长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长";
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeTextView rowType:JTFormRowTypeTextView title:@"JTFormRowTypeTextView"];
    row.image = [UIImage imageNamed:@"jt_money"];
    row.value = @"niadadadadnniadadadadnniadadadadnniadadadadnniadadadadnniadadadadnniadadadadnniadadadadnniadadadadnniadadadadnniadadadadnvniadadadadn";
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:@"2" rowType:JTFormRowTypeName title:@"短"];
    row.value = @"内容很长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长";
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeInfo rowType:JTFormRowTypeInfo title:@"JTFormRowTypeInfo"];
    row.value = @"知识测试一下";
    [section addFormRow:row];
    
    
    JTForm *form = [[JTForm alloc] initWithFormDescriptor:formDescriptor];
    form.frame = self.view.bounds;
    [self.view addSubview:form];
    self.form = form;
}

@end
