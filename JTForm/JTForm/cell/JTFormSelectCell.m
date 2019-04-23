//
//  JTFormSelectCell.m
//  JTForm
//
//  Created by dqh on 2019/4/23.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTFormSelectCell.h"
#import "JTOptionObject.h"
#import "JTFormSelectViewControllerDelegate.h"

@interface JTFormSelectCell ()
@property (nonatomic, strong) ASTextNode *contentNode;
@end

@implementation JTFormSelectCell

- (void)config
{
    [super config];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    _contentNode = [[ASTextNode alloc] init];
    _contentNode.layerBacked = YES;
}

- (void)update
{
    [super update];
    self.selectionStyle = self.rowDescriptor.disabled ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;

    BOOL required = self.rowDescriptor.required && self.rowDescriptor.sectionDescriptor.formDescriptor.addAsteriskToRequiredRowsTitle;
    self.titleNode.attributedText = [NSAttributedString
                                     attributedStringWithString:[NSString stringWithFormat:@"%@%@",required ? @"*" : @"", self.rowDescriptor.title]
                                     font:self.rowDescriptor.disabled ? [self formCellDisabledTitleFont] : [self formCellTitleFont]
                                     color:self.rowDescriptor.disabled ? [self formCellDisabledTitleColor] : [self formCellTitleColor]
                                     firstWordColor:required ? kJTFormRequiredCellFirstWordColor : nil];
    
    _contentNode.attributedText = [self cellDisplayContent];
    
}

- (void)formCellDidSelected
{
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypePushSelect] || [self.rowDescriptor.rowType isEqualToString:JTFormRowTypeMultipleSelect]) {
        UIViewController *controllerToPresent = self.viewController;
        if (controllerToPresent) {
            NSAssert([controllerToPresent conformsToProtocol:@protocol(JTFormSelectViewControllerDelegate)], @"viewcontroller should implement JTFormSelectViewControllerDelegate protocol");
            UIViewController<JTFormSelectViewControllerDelegate> *selectorViewController = (UIViewController<JTFormSelectViewControllerDelegate> *)controllerToPresent;
            selectorViewController.rowDescriptor = self.rowDescriptor;
            selectorViewController.title = self.rowDescriptor.selectorTitle;
            
            [self.viewController.navigationController pushViewController:selectorViewController animated:YES];
        }
        else if (self.rowDescriptor.selectorOptions) {
            JYFormOptionsViewController *optionViewController = [[JYFormOptionsViewController alloc] initWithStyle:UITableViewStyleGrouped
                                                                                                sectionHeaderTitle:nil
                                                                                                sectionFooterTitle:nil];
            optionViewController.rowDescriptor = self.rowDescriptor;
            optionViewController.form = self.form;
            optionViewController.title = self.rowDescriptor.selectorTitle;
            
            [[form formController].navigationController pushViewController:optionViewController animated:YES];
        }
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeSelectorActionSheet]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.rowDescriptor.selectorTitle
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alertController addAction:[UIAlertAction actionWithTitle:[NSString jy_localizedStringForKey:@"JYForm_Alert_Cancle"]
                                                            style:UIAlertActionStyleCancel
                                                          handler:nil]];
        __weak typeof(self) weakSelf = self;
        for (JYFormOptionsObject *option in self.rowDescriptor.selectorOptions) {
            NSString *optionTitle = [option displayText];
            if (self.rowDescriptor.valueTransformer) {
                NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
                NSValueTransformer * valueTransformer = [self.rowDescriptor.valueTransformer new];
                NSString * transformValue = [valueTransformer transformedValue:option.displayText];
                if (transformValue) {
                    optionTitle = transformValue;
                }
            }
            __strong typeof(weakSelf) strongSelf = self;
            [alertController addAction:[UIAlertAction actionWithTitle:optionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                strongSelf.rowDescriptor.value = option;
                [form reloadFormRow:strongSelf.rowDescriptor];
            }]];
        }
        [[form formController] presentViewController:alertController animated:YES completion:nil];
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeSelectorAlertView]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.rowDescriptor.selectorTitle
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:[NSString jy_localizedStringForKey:@"JYForm_Alert_Cancle"]
                                                            style:UIAlertActionStyleCancel
                                                          handler:nil]];
        __weak typeof(self) weakSelf = self;
        for (JYFormOptionsObject *option in self.rowDescriptor.selectorOptions) {
            NSString *optionTitle = [option displayText];
            if (self.rowDescriptor.valueFormatter) {
                NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
                NSValueTransformer * valueTransformer = [self.rowDescriptor.valueTransformer new];
                NSString * transformValue = [valueTransformer transformedValue:option.displayText];
                if (transformValue) {
                    optionTitle = transformValue;
                }
            }
            __strong typeof(weakSelf) strongSelf = self;
            [alertController addAction:[UIAlertAction actionWithTitle:optionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                strongSelf.rowDescriptor.value = option;
                [form reloadFormRow:strongSelf.rowDescriptor];
            }]];
        }
        [[form formController] presentViewController:alertController animated:YES completion:nil];
    }
    else if ([self.rowDescriptor.rowType isEqualToString:JYFormRowDescriptorTypeSelectorPickerView]) {
    }
    [form.tableView deselectRowAtIndexPath:[form.formDescriptor indexPathOfFormRow:self.rowDescriptor] animated:YES];
}

#pragma mark - helper

- (NSAttributedString *)cellDisplayContent
{
    BOOL noValue = false;
    NSString *displayContent = nil;
    
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeMultipleSelect]) {
        // 没有值
        if (!self.rowDescriptor.value || [self.rowDescriptor.value count] == 0) {
            noValue = YES;
            displayContent = self.rowDescriptor.placeHolder;
        } else {
            if (self.rowDescriptor.valueTransformer) {
                // 有值，有‘valueTransformer’
                NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
                NSValueTransformer *valueTransformer = [[self.rowDescriptor.valueTransformer alloc] init];
                displayContent = [valueTransformer transformedValue:[self.rowDescriptor.value valueData]];
            } else {
                // 有值，没有‘valueTransformer’
                NSMutableArray *descriptionArray = @[].mutableCopy;
                for (NSInteger i = 0; i < [self.rowDescriptor.value count]; i++) {
                    JTOptionObject *selectObject = self.rowDescriptor.value[i];
                    [descriptionArray addObject:[selectObject displayText]];
                }
                displayContent = [descriptionArray componentsJoinedByString:@", "];
            }
        }
    } else {
        if (!self.rowDescriptor.value) {
            noValue = YES;
            displayContent = self.rowDescriptor.placeHolder;
        } else {
            if (self.rowDescriptor.valueTransformer) {
                NSAssert([self.rowDescriptor.valueTransformer isSubclassOfClass:[NSValueTransformer class]], @"valueTransformer is not a subclass of NSValueTransformer");
                NSValueTransformer *valueTransformer = [self.rowDescriptor.valueTransformer new];
                displayContent = [valueTransformer transformedValue:[self.rowDescriptor.value valueData]];
            } else {
                displayContent = [self.rowDescriptor.value displayText];
            }
        }
    }
    if (displayContent.length == 0) {
        return nil;
    }
    
    UIFont *font =
    noValue
    ? ([self formCellPlaceHlderFont])
    : (self.rowDescriptor.disabled ? [self formCellDisabledContentFont] : [self formCellContentFont]);
    UIColor *color =
    noValue
    ? ([self formCellPlaceHolderColor])
    : (self.rowDescriptor.disabled ? [self formCellDisabledContentColor] : [self formCellContentColor]);
    
    return [NSAttributedString attributedStringWithString:displayContent font:font color:color firstWordColor:nil];
}



@end
