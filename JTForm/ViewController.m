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
        
//    section = [JTSectionDescriptor formSection];
//    [formDescriptor addFormSection:section];
//
//    row = [JTRowDescriptor formRowDescriptorWithTag:@"01" rowType:JTFormRowTypeDefault title:@"标题1"];
//    row.value = @"哈哈哈哈哈哈";
//    [section addFormRow:row];
//
//    row = [JTRowDescriptor formRowDescriptorWithTag:@"02" rowType:JTFormRowTypeDefault title:@"标题2"];
//    row.value = @"哈哈哈哈哈哈";
//    [section addFormRow:row];
//
//    row = [JTRowDescriptor formRowDescriptorWithTag:@"03" rowType:JTFormRowTypeDefault title:@"标题3"];
//    row.value = @"哈哈哈哈哈哈";
//    [section addFormRow:row];
//
//    row = [JTRowDescriptor formRowDescriptorWithTag:@"04" rowType:JTFormRowTypeDefault title:@"标题4"];
//    row.value = @"哈哈哈哈哈哈";
//    [section addFormRow:row];
//
//    row = [JTRowDescriptor formRowDescriptorWithTag:@"05" rowType:JTFormRowTypeDefault title:@"标题5"];
//    row.value = @"哈哈哈哈哈哈";
//    [section addFormRow:row];
//
//    row = [JTRowDescriptor formRowDescriptorWithTag:@"06" rowType:JTFormRowTypeDefault title:@"标题6"];
//    row.value = @"哈哈哈哈哈哈";
//    [section addFormRow:row];
    
    section = [JTSectionDescriptor formSection];
    [formDescriptor addFormSection:section];
    for (NSInteger i = 0; i < 6; i++) {
        row = [JTRowDescriptor formRowDescriptorWithTag:@(i+1).description rowType:JTFormRowTypeText title:@"kittens"];
//        row.value = @"哈哈哈哈哈咔咔咔咔咔咔哈哈哈哈哈咔咔咔咔咔咔哈哈哈哈哈咔咔咔咔咔咔哈哈哈哈哈咔咔咔咔咔咔哈哈哈哈哈咔咔咔咔咔咔哈哈哈哈哈咔咔咔咔咔咔哈哈哈哈哈咔咔咔咔咔咔哈哈哈哈哈咔咔咔咔咔咔";
        [section addFormRow:row];
    }
    
    JTForm *form = [[JTForm alloc] initWithFormDescriptor:formDescriptor];
    form.frame = self.view.bounds;
//    form.frame = CGRectMake(0, 0, 200, 500);
    [self.view addSubview:form];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}




@end
