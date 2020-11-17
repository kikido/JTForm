//
//  CollectionView.m
//  JTFormDemo
//
//  Created by dqh on 2019/12/19.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "CollectionViewController.h"
#import "ImageCell.h"

@interface CollectionViewController ()
@end

@implementation CollectionViewController

- (void)OrientationDidChange
{
    self.form.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button01 = [UIButton buttonWithType:UIButtonTypeCustom];
    button01.tag = 10;
    [button01 setTitle:@"其它" forState:UIControlStateNormal];
    [button01 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button01 addTarget:self action:@selector(otherAction) forControlEvents:UIControlEventTouchUpInside];
    [button01 sizeToFit];
    UIBarButtonItem *item01 = [[UIBarButtonItem alloc] initWithCustomView:button01];
    
    UIButton *button02 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button02 setTitle:@"方向" forState:UIControlStateNormal];
    [button02 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button02 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button02 sizeToFit];
    UIBarButtonItem *item02 = [[UIBarButtonItem alloc] initWithCustomView:button02];
    self.navigationItem.rightBarButtonItems = @[item01, item02];

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
    
    JTForm *form = [[JTForm alloc] initWithDescriptor:formDescriptor formType:JTFormTypeCollectionColumnFlow];
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

- (void)otherAction
{
//    self.form.collectionNode.view;
//    self.form.formDescriptor
//    JTForm
}

@end
