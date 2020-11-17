//
//  TextViewController.m
//  JTForm
//
//  Created by dqh on 2019/5/6.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "TextViewController.h"
#import <Texture/AsyncDisplayKit/AsyncDisplayKit.h>

@interface TextViewController()
@end

@implementation TextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    JTFormDescriptor *formDescriptor = [JTFormDescriptor formDescriptor];
    JTFormDescriptor *formDescriptor = [JTFormDescriptor formDescriptor];
    formDescriptor.addAsteriskToRequiredRowsTitle = YES;
    JTSectionDescriptor *section = nil;
    JTRowDescriptor *row = nil;
    ASCellNode *node;
    
    #pragma mark - float text
    
    section = [JTSectionDescriptor formSection];
    section.headerAttributedString = [NSAttributedString jt_attributedStringWithString:@"float text" font:nil color:nil firstWordColor:nil];
    section.headerHeight = 30.;
    [formDescriptor addSection:section];
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeFloatText rowType:JTFormRowTypeFloatText title:@"测试"];
    row.placeHolder = [NSString stringWithFormat:@"请输入%@...", row.title];
    row.required = YES;
    [section addRow:row];
    
    #pragma mark - formatter
    
//    section = [JTSectionDescriptor formSection];
//    section.headerAttributedString = [NSAttributedString jt_attributedStringWithString:@"formatter" font:nil color:nil firstWordColor:nil];
//    section.headerHeight = 30.;
//    [formDescriptor addSection:section];
    
    row = [JTRowDescriptor rowDescriptorWithTag:@"20" rowType:JTFormRowTypeNumber title:@"百分比"];
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
    row.valueFormatter = numberFormatter;
    row.value = @(100);
    row.required = YES;
    row.image = [UIImage imageNamed:@"jt_money"];
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:@"21" rowType:JTFormRowTypeNumber title:@"人民币"];
    NSNumberFormatter *numberFormatter1 = [NSNumberFormatter new];
    numberFormatter1.numberStyle = NSNumberFormatterCurrencyStyle;
    row.valueFormatter = numberFormatter1;
    row.value = @(100);
    row.required = YES;
    row.image = [UIImage imageNamed:@"jt_money"];
    [section addRow:row];
    
    row  = [JTRowDescriptor rowDescriptorWithTag:@"22" rowType:JTFormRowTypeNumber title:@"缓存"];
    row.valueFormatter = [NSByteCountFormatter new];
    row.imageUrl = netImageUrl(30., 30.);
    row.value = @(102404);
    [section addRow:row];
    
    #pragma mark - common
        
    section = [JTSectionDescriptor formSection];
    section.headerAttributedString = [NSAttributedString jt_attributedStringWithString:@"float text" font:nil color:nil firstWordColor:nil];
    section.headerHeight = 30.;
    [formDescriptor addSection:section];

    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeName rowType:JTFormRowTypeName title:@"JTFormRowTypeName"];
    row.placeHolder = @"请输入姓名...";
    row.required = YES;
    [section addRow:row];
//    [row cellForDescriptor].accessibilityLabel = @"JTFormRowTypeName";
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeEmail rowType:JTFormRowTypeEmail title:@"JTFormRowTypeEmail"];
    row.required = YES;
    [section addRow:row];
    [row cellForDescriptor].accessibilityLabel = @"JTFormRowTypeEmail";

    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeNumber rowType:JTFormRowTypeNumber title:@"JTFormRowTypeNumber"];
    [section addRow:row];
    node = (ASCellNode *)[row cellForDescriptor];
    [row cellForDescriptor].accessibilityLabel = @"JTFormRowTypeNumber";

    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeInteger rowType:JTFormRowTypeInteger title:@"JTFormRowTypeInteger"];
    [section addRow:row];
    [row cellForDescriptor].accessibilityLabel = @"JTFormRowTypeInteger";

    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeDecimal rowType:JTFormRowTypeDecimal title:@"JTFormRowTypeDecimal"];
    [section addRow:row];
    [row cellForDescriptor].accessibilityLabel = @"JTFormRowTypeDecimal";

    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypePhone rowType:JTFormRowTypePhone title:@"JTFormRowTypePhone"];
    [section addRow:row];
    [row cellForDescriptor].accessibilityLabel = @"JTFormRowTypePhone";

    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypePassword rowType:JTFormRowTypePassword title:@"JTFormRowTypePassword"];
    [section addRow:row];
    [row cellForDescriptor].accessibilityLabel = @"JTFormRowTypePassword";

    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeName rowType:JTFormRowTypeName title:@"JTFormRowTypeName"];
    [section addRow:row];
    [row cellForDescriptor].accessibilityLabel = @"JTFormRowTypeName";

    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeURL rowType:JTFormRowTypeURL title:@"JTFormRowTypeURL"];
    [section addRow:row];
    [row cellForDescriptor].accessibilityLabel = @"JTFormRowTypeURL"; 

    section = [JTSectionDescriptor formSection];
    section.headerAttributedString = [NSAttributedString jt_attributedStringWithString:@"float text" font:nil color:nil firstWordColor:nil];
    section.headerHeight = 30.;
    [formDescriptor addSection:section];

    
    row = [JTRowDescriptor rowDescriptorWithTag:@"0" rowType:JTFormRowTypeName title:@"标题很长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长"];
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:@"1" rowType:JTFormRowTypeName title:@"JTFormRowTypeName"];
    row.value = @"内容很长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长";
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeTextView rowType:JTFormRowTypeTextView title:@"JTFormRowTypeTextView"];
    row.image = [UIImage imageNamed:@"jt_money"];
    row.value = nil;
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeTextView rowType:JTFormRowTypeTextView title:@"JTFormRowTypeTextView"];
    row.placeHolder = @"请输入...";
    row.value = @"dmdd";
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:@"2" rowType:JTFormRowTypeName title:@"短"];
    row.value = @"内容很长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长";
    [section addRow:row];
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeLongInfo rowType:JTFormRowTypeLongInfo title:@"JTFormRowTypeLongInfo"];
    row.value = @"内容很长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长";
    [section addRow:row];
    
    
    JTForm *form = [[JTForm alloc] initWithDescriptor:formDescriptor formType:1];
    form.frame = CGRectMake(0, 0, kJTScreenWidth, kJTScreenHeight-64.);
    [self.view addSubview:form];
    self.form = form;
}

@end
