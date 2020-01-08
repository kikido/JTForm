//
//  CollectionViewController3.m
//  JTFormDemo
//
//  Created by dqh on 2020/1/8.
//  Copyright © 2020 dqh. All rights reserved.
//

#import "CollectionViewController3.h"
#import "ImageCell.h"

@interface CollectionViewController3 ()

@end

@implementation CollectionViewController3

- (void)OrientationDidChange
{
    self.form.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *button02 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button02 setTitle:@"方向" forState:UIControlStateNormal];
    [button02 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button02 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button02 sizeToFit];
    UIBarButtonItem *item02 = [[UIBarButtonItem alloc] initWithCustomView:button02];
    self.navigationItem.rightBarButtonItems = @[item02];

    // 监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    JTFormDescriptor *formDescriptor = [JTFormDescriptor formDescriptor];
    formDescriptor.itmeSize = CGSizeMake(100., 100.);
    formDescriptor.interItemSpace = 10.;
    formDescriptor.lineSpace = 15.;
    formDescriptor.numberOfColumn = 2;
    formDescriptor.scrollDirection = JTFormScrollDirectionVertical;
    formDescriptor.sectionInsets = UIEdgeInsetsMake(15., 15., 15., 15.);
    JTSectionDescriptor *section = nil;
    JTRowDescriptor *row = nil;
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kJTScreenWidth, 30.)];
    header.backgroundColor = UIColor.redColor;
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kJTScreenWidth, 30.)];
    footer.backgroundColor = UIColor.greenColor;

    section = [JTSectionDescriptor formSection];
    section.headerHeight = 30.;
    section.footerHeight = 30.;
    section.headerView = header;
    section.footerView = footer;
    [formDescriptor addSection:section];
    
    NSUInteger kNumberOfImages = 14;
    for (NSUInteger idx = 0; idx < kNumberOfImages; idx++) {
        NSString *name = [NSString stringWithFormat:@"image_%lu.jpg", (unsigned long)idx];
        row = [JTRowDescriptor rowDescriptorWithTag:name rowType:JTFormRowTypeCollectionImageCell title:nil];
        row.image = [UIImage imageNamed:name];
        [section addRow:row];
    }
    
    section = [JTSectionDescriptor formSection];
    section.headerHeight = 44.;
    section.footerHeight = 44.;
    section.headerAttributedString = [NSAttributedString jt_attributedStringWithString:@"Header 2" font:[UIFont systemFontOfSize:15.] color:UIColor.grayColor];
    section.footerAttributedString = [NSAttributedString jt_attributedStringWithString:@"Footer 2" font:[UIFont systemFontOfSize:15.] color:UIColor.grayColor];
    [formDescriptor addSection:section];
    
    for (NSUInteger idx = 0; idx < kNumberOfImages; idx++) {
        NSString *name = [NSString stringWithFormat:@"image_%lu.jpg", (unsigned long)idx];
        row = [JTRowDescriptor rowDescriptorWithTag:name rowType:JTFormRowTypeCollectionImageCell title:nil];
        row.image = [UIImage imageNamed:name];
        [section addRow:row];
    }
    
    JTForm *form = [[JTForm alloc] initWithDescriptor:formDescriptor formType:JTFormTypeCollectionFixed];
    form.frame = CGRectMake(0, 0, kJTScreenWidth, kJTScreenHeight-64.);
    [self.view addSubview:form];
    self.form = form;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.form.frame = self.view.bounds;
}

- (void)buttonAction:(UIButton *)sender
{
    UIAlertController *alertController;;
    alertController = [UIAlertController alertControllerWithTitle:nil message:@"方向" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"JTFormScrollDirectionVertical" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.form.formDescriptor.scrollDirection = JTFormScrollDirectionVertical;
        [self.form.collectionNode relayoutItems];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"JTFormScrollDirectionHorizontal" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.form.formDescriptor.scrollDirection = JTFormScrollDirectionHorizontal;
        [self.form.collectionNode relayoutItems];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
