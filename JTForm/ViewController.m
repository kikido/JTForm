//
//  ViewController.m
//  JTForm
//
//  Created by dqh on 2019/4/8.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "ViewController.h"
#import "JTForm.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JTFormDescriptor *formDescriptor = [JTFormDescriptor formDescriptor];
    JTSectionDescriptor *section = nil;
    JTRowDescriptor *row = nil;
    
    #pragma mark - text field
    
    section = [JTSectionDescriptor formSection];
    [formDescriptor addFormSection:section];
    
    extern NSString *const JTFormRowTypeName;
    extern NSString *const JTFormRowTypeEmail;
    extern NSString *const JTFormRowTypeNumber;
    extern NSString *const JTFormRowTypeInteger;
    extern NSString *const JTFormRowTypeDecimal;
    extern NSString *const JTFormRowTypePassword;
    extern NSString *const JTFormRowTypePhone;
    extern NSString *const JTFormRowTypeURL;
    extern NSString *const JTFormRowTypeTextView;
    
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeName rowType:JTFormRowTypeName title:@"name"];
    row.value = @"adadandandjaaaaaadadandandjaaaaaadadandandjaaaaaadadandandjaaaaaadadandandjaaaaaadadandandjaaaaaadadandandjaaaaaadadandandjaaaaaadadandandjaaaaaadadandandjaaaaaadadandandjaaaaaadadandandjaaaaa";
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeEmail rowType:JTFormRowTypeEmail title:@"email"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeNumber rowType:JTFormRowTypeNumber title:@"number"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeInteger rowType:JTFormRowTypeInteger title:@"integer"];
    row.valueFormatter = [NSByteCountFormatter new];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeDecimal rowType:JTFormRowTypeDecimal title:@"decimal"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypePassword rowType:JTFormRowTypePassword title:@"password"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypePhone rowType:JTFormRowTypePhone title:@"phone"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeName rowType:JTFormRowTypeName title:@"name"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeURL rowType:JTFormRowTypeURL title:@"url"];
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeTextView rowType:JTFormRowTypeTextView title:@"JTFormRowTypeTextView"];
    row.value = @"niadadadadnniadadadadnniadadadadnniadadadadnniadadadadnniadadadadnniadadadadnniadadadadnniadadadadnniadadadadnniadadadadnvniadadadadn";
    [section addFormRow:row];
    
    row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeInfo rowType:JTFormRowTypeInfo title:@"JTFormRowTypeInfo"];
    row.value = @"niadadadadnniadadadadnniadadadadnniadadadadnniadadadadnniadadadadnniadadadadnniadadadadnniadadadadnniadadadadnniadadadadnvniadadadadn";
    [section addFormRow:row];

    
    JTForm *form = [[JTForm alloc] initWithFormDescriptor:formDescriptor];
    form.frame = self.view.bounds;
//    form.frame = CGRectMake(0, 0, 200, 500);
    [self.view addSubview:form];
    
    
    [self test];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)test
{
    NSString *a = @"1";
    NSNumber *b = @1;
    
    BOOL result = [a isEqual:b];
    NSLog(@"result = %d", result);
}


@end
