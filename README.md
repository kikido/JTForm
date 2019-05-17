



![](https://img.shields.io/badge/plateform-iOS9.0%2B-orange.svg)
![](https://img.shields.io/badge/language-OC-orange.svg)

![](https://img.shields.io/badge/pod-0.0.1-blue.svg)
![](https://img.shields.io/badge/license-MIT-green.svg)

`JTForm`是一个能简单快速的搭建流畅复杂表单的库，灵感来自于[XLForm](https://github.com/xmartlabs/XLForm)与[Texture](https://github.com/TextureGroup/Texture)。JTForm能帮助你像html一样创建表单。不同于`XLForm`是一个`UIViewController`的子类，`JTForm`是`UIView`的子类，也就是说，你可以像使用UIView一样使用JTForm，应用范围更广，更方便。JTForm也可以用来创建列表，而不仅仅是表单。

JTForm使用`Texture`完成视图的布局与加载，所以集成了Texture的优点：异步渲染，极度流畅。使用JTForm，你可以忘记许多原生控件时需要注意的东西：高度设置，单元行复用等。为了避免`ASTableNode`重载时图片闪烁的问题，自定义了`JTNetworkImageNode`代替`ASNetworkImageNode`。

下面是demo运行在公司老旧设备5s的截图，可以看到fps基本保持在60左右。

![fps基本保持在60](https://ws2.sinaimg.cn/large/006tNc79ly1g325b2cv3cg30a00dce84.gif)
![text输入表单](https://i.loli.net/2019/05/15/5cdbdf7c76a0541205.gif)



### 安装

- 使用cocoapods：`pod 'JTForm', '~> 0.0.1'`

### 注意事项

- 如果库自带的单元行满足不了需求，需要自定义单元行的时候，需要了解[Texture](https://github.com/TextureGroup/Texture)的相关知识。
- 如果你的项目中有类似`‎IQKeyboardManager`的第三方，请在使用JTForm的时候禁用他们，不然会跟库的键盘弹起相冲突。如果你想禁用JTForm的键盘弹起，你可以设置`JTForm`的属性`showInputAccessoryView`为NO


### 简单使用

![简单的表单1](https://i.loli.net/2019/05/15/5cdbdf7c76a0541205.gif)


下面是构建该表单一部分的代码以及注释

```
// 构建表描述
JTFormDescriptor *formDescriptor = [JTFormDescriptor formDescriptor];
// 是否在必填行的title前面添加一个红色的*
formDescriptor.addAsteriskToRequiredRowsTitle = YES;
JTSectionDescriptor *section = nil;
JTRowDescriptor *row = nil;
       
#pragma mark - float text
// 创建节描述    
section = [JTSectionDescriptor formSection];
// 为section创建header title，目前需要手动输入header view的height
section.headerAttributedString = [NSAttributedString attributedStringWithString:@"float text" font:nil color:nil firstWordColor:nil];
// 目前需要手动输入header view的height，不然是默认值，可能会出现排版显示问题
section.headerHeight = 30.;
// 将节描述添加到表描述中
[formDescriptor addFormSection:section];
    
// 创建行描述，rowType为必填项，创建单元行时根据rowType来选择创建不同的单元行    
row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeFloatText rowType:JTFormRowTypeFloatText title:@"测试"];
// 是否必填
row.required = YES;
// 将行描述添加到表描述中
[section addFormRow:row];
    
#pragma mark - formatter
    
row = [JTRowDescriptor formRowDescriptorWithTag:@"20" rowType:JTFormRowTypeNumber title:@"百分比"];
NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
// 添加valueFormatter，是NSFormatter的子类，能将value转换成不同的文本。常用的有nsdateformatter
// 这里valueFormatter的作用是将数字转换成百分数，例如10->1000%
row.valueFormatter = numberFormatter;
row.value = @(100);
row.required = YES;
// 在title前面添加图片
row.image = [UIImage imageNamed:@"jt_money"];
[section addFormRow:row];
    
row = [JTRowDescriptor formRowDescriptorWithTag:@"21" rowType:JTFormRowTypeNumber title:@"人民币"];
NSNumberFormatter *numberFormatter1 = [NSNumberFormatter new];
numberFormatter1.numberStyle = NSNumberFormatterCurrencyStyle;
// 这里valueFormatter的作用是将数字转换成货币，例如10->￥10
row.valueFormatter = numberFormatter1;
row.value = @(100);
row.required = YES;
row.image = [UIImage imageNamed:@"jt_money"];
[section addFormRow:row];
       
#pragma mark - common
 
    
row = [JTRowDescriptor formRowDescriptorWithTag:JTFormRowTypeName rowType:JTFormRowTypeName title:@"JTFormRowTypeName"];
// 占位符
row.placeHolder = @"请输入姓名...";
// 赋值
row.value = @"djdjd";
row.required = YES;
[section addFormRow:row];

// 创建JTForm，formDescriptor不能为空
JTForm *form = [[JTForm alloc] initWithFormDescriptor:formDescriptor];
form.frame = CGRectMake(0, 0, kJTScreenWidth, kJTScreenHeight-64.);
[self.view addSubview:form];
self.form = form;
```
### 行描述 JTRowDescriptor

行描述`JTRowDescriptor`是单元行的数据源，我们通过修改行描述来控制着单元行的行为，例如：是否显示，是否可编辑，高度。
下面是JTRowDescriptor的主要属性和常用方法

#### configMode

配置模型。
- titleColor：标题颜色
- contentColor：详情颜色
- placeHolderColor：占位符颜色
- disabledTitleColor：禁用时标题颜色
- disabledContentColor：禁用时详情颜色
- bgColor：控件背景颜色
- titleFont：标题字体 
- contentFont：详情字体
- placeHlderFont：占位符字体
- disabledTitleFont：禁用时标题字体
- disabledContentFont：禁用时详情字体

`JTSectionDescriptor`和`JTFormDescriptor`同样具有这些属性，作用也类似。优先级JTRowDescriptor > JTSectionDescriptor > JTFormDescriptor


#### image & imageUrl
用于加载图片，样式类似于UITableViewCell的imageView。image应用于静态图片，imageUrl用于加载网络图片。

#### rowType
创建表单时，根据`rowType`来创建不同类型的单元行。目前库自带的`rowType`都已经添加到了`[JTForm cellClassesForRowTypes]`字典中，其中`rowType`为key，单元行类型Class为value。在创建时单元行时，你就可以通过字典根据`rowType`得到相应单元行的Class。

所以当你自定义单元行时，你需要在`+ (void)load`中，将相应的rowType以及对应的Class添加到`[JTForm cellClassesForRowTypes]`字典中。

#### tag
nullable，若不为空，表单将其添加到字典中，其中key为tag，value为`JTRowDescriptor`实例。所以如果创建表单时有多个行描述tag值一样的话，字典中将只会保存最后添加进去的JTRowDescriptor。

你可以在表单中，根据tag值找到相对应的行描述。且在获取整个表单值的时候也会派上用场。

#### height

该属性控制着单元行高度。默认值为`JTFormUnspecifiedCellHeight`，即不指定高度(自动调节高度)。

单元行高度的优先级：
- JTRowDescriptor的height属性
- JTBaseCellDelegate的方法`+ (CGFloat)formCellHeightForRowDescriptor:(JTRowDescriptor *)row;`
- 自动调节高度

#### action

响应事件，目前仅用于点击单元行。如果单元行上有多个控件有响应事件时，建议使用`- (JTBaseCell *)cellInForm;`得到当前的单元行cell，然后用`[cell.button addTarget:self action:action forControlEvents:UIControlEvents]`添加响应事件。

#### hidden & disabled

hidden：bool值，控制隐藏或者显示当前单元行
disabled：bool值，控制当前单元行是否接受响应事件

`JTSectionDescriptor`和`JTFormDescriptor`同样具有这些属性，作用也类似。优先级JTRowDescriptor > JTSectionDescriptor > JTFormDescriptor

#### cellConfigAfterUpdate & cellConfigWhenDisabled & cellConfigAtConfigure & cellDataDictionary

- cellConfigAfterUpdate：配置cell，在‘update’方法后使用
- cellConfigWhenDisabled：配置cell，当'update'方法后，且disabled属性为Yes时被使用
- cellConfigAtConfigure：配置cell，当cell调用config之后，update方法之前调用
- cellDataDictionary：预留，你可以选择使用时机

#### text

文本方面的，属性比较多，统一放到这里讲

- valueFormatter：文本格式转换，可以将数据格式化为一种易读的格式。‘NSFormatter’是一个抽象类，我们只使用它的子类，类似'NSDateFormatter'和‘NSNumberFormatter’
- placeHolder：占位符，当value为空时显示该内容
- maxNumberOfCharacters：文本类单元行能输入最大字符数
- `- (nullable NSString *)displayContentValue;`:在未编辑状态时，详情的显示内容
- `- (nullable NSString *)editTextValue;`：在编辑状态时，详情的显示内容

#### 验证器

你可以通过`- (void)addValidator:(nonnull id<JTFormValidateProtocol>)validator;`添加一个或多个验证器，验证器的作用是对单元行的值进行验证，来判断是否符合你的要求，例如：身份证格式，密码的复杂程度，字数长度等。

当然，除了库自带的验证器外，你可以自定义自己的验证器，注意需要实现代理`JTFormValidateProtocol`。

### 单元行类型

#### 文本类

- JTFormRowTypeFloatText
- JTFormRowTypeText
- JTFormRowTypeName
- JTFormRowTypeEmail
- JTFormRowTypeNumber
- JTFormRowTypeInteger
- JTFormRowTypeDecimal
- JTFormRowTypePassword
- JTFormRowTypePhone
- JTFormRowTypeURL
- JTFormRowTypeTextView
- JTFormRowTypeInfo

主要的区别是键盘不同，需要注意的是：`JTFormRowTypeTextView`和`JTFormRowTypeInfo`是`textview`，而其它几种是`textfield`。

![text](https://ws1.sinaimg.cn/large/006tNc79ly1g338qy6tc3g30a00dckjl.gif)

#### select类

- JTFormRowTypePushSelect

push到另一个vc中，仅可选择一个

- JTFormRowTypeMultipleSelect

push到另一个vc中，可选择多个

- JTFormRowTypeSheetSelect

UIAlertController，样式为UIAlertControllerStyleActionSheet

- JTFormRowTypeAlertSelect

UIAlertController，样式为UIAlertControllerStyleAlert

- JTFormRowTypePickerSelect

类似于弹出键盘，inputview为UIPickeraaa


选择项通常会拥有一个展示文本，一个是代表value的id。例如你在选择汽车型号的时候，展示给你的是不同汽车的型号的文本，当你选中之后传给后台的是代表该型号的文本。

在选择类的单元行中，我们使用的选择项类型是`JTOptionObject`，主要由两个属性`formDisplayText`和`formValue`，含义顾名思义。选择项可以通过`selectorOptions`赋值得到，在单元行选中之后，单元行的value也是`JTOptionObject`类型(单选)或者为`NSArray<JTOptionObject *> *`类型(多选)，你可以使用NSObject类目方法`- (id)cellValue;`得到value。

#### date类

- JTFormRowTypeDate
- JTFormRowTypeTime
- JTFormRowTypeDateTime
- JTFormRowTypeCountDownTimer
- JTFormRowTypeDateInline

除了`JTFormRowTypeDateInline`，其余集中的区别只是`UIDatePicker`中`timeStyle`和`timeStyle`的区别。`JTFormRowTypeDateInline`的效果如下：

![JTFormRowTypeDateInline](https://ws1.sinaimg.cn/large/006tNc79ly1g339l0w8gdg30a00dcwph.gif)

#### 其它

- JTFormRowTypeSwitch
- JTFormRowTypeCheck
- JTFormRowTypeStepCounter
- JTFormRowTypeSegmentedControl
- JTFormRowTypeSlider

具体样式可以看demo

### JTBaseCell

单元行的基类，如果你需要自定义单元行的话需要继承它。`JTBaseCell`里面的属性和方法都比较简单，需要注意的是`JTBaseCellDelegate`，下面来我来说明一下它的几个方法：

#### config

required。初始化控件，在这个方法里只需要创建需要的控件，但不需要为控件添加内容，因为这个时候并没有添加进去数据源`JTRowDescriptor`。在生命周期内该方法只会被调用一次，除非调用`JTRowDescriptor`的方法`reloadCell`，该方法会重新创建单元行。

子类中实现时需要调用`[super config]`

#### update

required。更新视图内容，在生命周期中会被多次调用。在这个方法中，我们可以为已经创建好的内容添加内容。

子类中实现时需要调用`[super update]`

#### 其它
> 剩下的几个方法都是@optional

- `+ (CGFloat)formCellHeightForRowDescriptor:(JTRowDescriptor *)row`

指定单元行的高度

- `- (BOOL)formCellCanBecomeFirstResponder`

指示单元行是否能够成为第一响应者, 默认返回NO

- `- (BOOL)formCellBecomeFirstResponder`

单元行成为第一响应者

- `- (BOOL)formCellResignFirstResponder`

单元行放弃第一响应者

- `- (void)formCellDidSelected`

当前的单元行被选中了

- `- (NSString *)formDescriptorHttpParameterName`

为单元行设置一个参数名称。若不为空，当调用`JTFormDescriptor`的方法`httpParameters`返回的表单字典中，key为该参数名称，value为JTRowDescriptor的value。


- `- (void)formCellHighlight`

单元行高亮

- `- (void)formCellUnhighlight`

单元行不高亮



### 自定义单元行

以demo中我自定义的单元行`IGCell`为例。

#### + (void)load

首先，你需要一个rowType来代表该行。然后在`+ (void)load`方法中`[[JTForm cellClassesForRowTypes] setObject:self forKey:JTFormRowTypeIGCell];`将rowType与单元行关联起来。

#### config

```
- (void)config
{
  [super config];  
  // 你的代码
}
```
在这里你可以创建好控件，但不需要为控件添加内容。注意需要调用`[super config];`。

#### update

```
- (void)update
{
  [super update];  
  // 你的代码
}
```
在这个方法中，我们可以为已经创建好的内容添加内容。。注意需要调用`[super update];`

#### layoutSpecThatFits

`- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize`。在这个方法中，你需要创建好布局。对此，你需要额外学习`Texture`(原AsyncDisplayKit)的布局系统。

### 表单行为控制

#### hidden

当表单完成之后，你可以通过改变`JTRowDescriptor`,`JTSectionDescriptor`,`JTFormDescriptor` hidden的值来隐藏或者显示相应的单元行，单元节，表单。

#### disabled

你可以通过改变`JTRowDescriptor`,`JTSectionDescriptor`,`JTFormDescriptor` disabled的值来决定相应的单元行，单元节，表单是否可以被编辑。

#### delete row

```
    JTSectionDescriptor *section = [JTSectionDescriptor formSection];
    section.sectionOptions = JTFormSectionOptionCanDelete;
```
你可以这样创建节描述，就可以让单元节具有删除单元行功能。



### FAQ

#### 如何给section自定义 header/footer

你也可以通过设置`JTSectionDescriptor`的`headerHieght`和`headerView`或者`footerHieght`和`footerView`属性来自定义header/footer。目前需要手动设置高度...

#### 如何拿到表单的值

你可以通过`JTForm`的`- (NSDictionary *)formValues`获取表单值。如果设置了验证器或者有必填项，可以先调用`- (NSArray<NSError *> *)formValidationErrors`来获取错误集合，再获取表单值进行其它操作。

#### 如何给日期行设置最大，最小日期

你可以通过下面的代码这样设置，虽然丑陋，但是能用...

```
[row.cellConfigAtConfigure setObject:[NSDate date] forKey:@"minimumDate"];
[row.cellConfigAtConfigure setObject:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*3)] forKey:@"maximumDate"];
```

#### 如何改变cell的高度

单元行高度的优先级：
- JTRowDescriptor的height属性
- JTBaseCellDelegate的方法`+ (CGFloat)formCellHeightForRowDescriptor:(JTRowDescriptor *)row;`
- 根据布局来生成高度


#### 如何自定义类似于JTFormRowTypeDateInline的内联行

如果你想要创建类似`JTFormRowTypeDateInline`的内联行，就意味着你需要自定义两种单元行。拿JTFormRowTypeDateInline举个例子，A：JTFormDateCell，B：JTFormDateInlineCell。当你选中A时，B显示出来，再选中A，B消失。

- 首先，创建两种单元行A, B
- B在`load`方法中，还需要额外添加`[[JTForm inlineRowTypesForRowTypes] setObject: A.rowType forKey:B.rowType]`
- 剩下的操作为以下代码，你可以照着写。这里简单说明以下，当你选择A时，会调用`formCellCanBecomeFirstResponder`和`formCellBecomeFirstResponder`方法。随后调用`canBecomeFirstResponder`和`becomeFirstResponder`，注意这里必须调用super的方法，不然当前单元行无法成为第一响应者。在`becomeFirstResponder`中，我们创建B，并且添加到A后面。


```
- (BOOL)formCellCanBecomeFirstResponder
{
    return [self canBecomeFirstResponder];
}

- (BOOL)formCellBecomeFirstResponder
{
    if ([self isFirstResponder]) {
        return [self resignFirstResponder];
    }
    return [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    [super canBecomeFirstResponder];
    return !self.rowDescriptor.disabled;
}

- (BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];

    NSIndexPath *currentIndexPath = [self.rowDescriptor.sectionDescriptor.formDescriptor indexPathForRowDescriptor:self.rowDescriptor];
    JTSectionDescriptor *section = [self.rowDescriptor.sectionDescriptor.formDescriptor.formSections objectAtIndex:currentIndexPath.section];
    JTRowDescriptor *inlineRow = [JTRowDescriptor formRowDescriptorWithTag:nil rowType:JTFormRowTypeInlineDatePicker title:nil];
    JTFormDateInlineCell *inlineCell = (JTFormDateInlineCell *)[inlineRow cellInForm];

    NSAssert([inlineCell conformsToProtocol:@protocol(JTFormInlineCellDelegate)], @"inline cell must conform to protocol 'JTFormInlineCellDelegate'");
    inlineCell.connectedRowDescriptor = self.rowDescriptor;

    [section addFormRow:inlineRow afterRow:self.rowDescriptor];
    [self.findForm ensureRowIsVisible:inlineRow];

    BOOL result = [super becomeFirstResponder];
    if (result) {
        [self.findForm beginEditing:self.rowDescriptor];
    }
    return result;
}

- (BOOL)canResignFirstResponder
{
    BOOL result = [super canResignFirstResponder];
    return result;
}

- (BOOL)resignFirstResponder
{
    BOOL result = [super resignFirstResponder];
    if ([self.rowDescriptor.rowType isEqualToString:JTFormRowTypeDateInline]) {
        NSIndexPath *currentIndexPath = [self.rowDescriptor.sectionDescriptor.formDescriptor indexPathForRowDescriptor:self.rowDescriptor];
        NSIndexPath *nextRowPath = [NSIndexPath indexPathForRow:currentIndexPath.row + 1 inSection:currentIndexPath.section];
        JTRowDescriptor *inlineRow = [self.rowDescriptor.sectionDescriptor.formDescriptor formRowAtIndex:nextRowPath];
        if ([inlineRow.rowType isEqualToString:JTFormRowTypeInlineDatePicker]) {
            [self.rowDescriptor.sectionDescriptor removeFormRow:inlineRow];
        }
    }
    return result;
}
```


