
![](https://img.shields.io/badge/plateform-iOS9.0%2B-orange.svg)
![](https://img.shields.io/badge/language-OC-orange.svg)

![](https://img.shields.io/badge/pod-0.0.1-blue.svg)
![](https://img.shields.io/badge/license-MIT-green.svg)

`JTForm`是一个能快速搭建流畅复杂表单的库，灵感来自于[XLForm](https://github.com/xmartlabs/XLForm)与[Texture](https://github.com/TextureGroup/Texture)。JTForm能帮助你像html一样创建表单。不同于`XLForm`是一个`UIViewController`的子类，`JTForm`是`UIView`的子类，也就是说，你可以像使用UIView一样使用JTForm，应用范围更广，更方便。JTForm也可以用来创建列表(例如demo里的微博以及ig列表)，而不仅仅是表单。

JTForm使用`Texture`完成视图的布局与加载，所以集成了Texture的优点：异步渲染，极度流畅。使用 JTForm，你可以忘记使用 UITableView 时需要注意的东西：高度设置，单元行复用等。当然 Texture 也存在一些问题，为了避免`ASTableNode`重载时图片闪烁的问题，自定义了`JTNetworkImageNode`代替`ASNetworkImageNode`。

下面是demo运行在公司老旧设备5s的截图，可以看到fps基本保持在60左右。

![fps基本保持在60](https://ws2.sinaimg.cn/large/006tNc79ly1g325b2cv3cg30a00dce84.gif)
![text输入表单](https://i.loli.net/2019/05/15/5cdbdf7c76a0541205.gif)

### 安装

- 使用cocoapods：`pod 'JTForm', '~> 0.0.1'`
- 手动导入。JTForm 还依赖下面几个库:Texture, SDWebImage

### 注意事项

- 如果自带的单元行样式满足不了需求，你需要自定义单元行，这时候你需要了解一些[Texture](https://github.com/TextureGroup/Texture)的相关知识。
- 你可能需要类似`‎IQKeyboardManager`的第三方来帮助管理键盘弹起


### 简单使用

![简单的表单1](https://i.loli.net/2019/05/15/5cdbdf7c76a0541205.gif)

这个例子可以在 demo 中找到。
下面是构建该表单一部分的代码以及注释

```
    // 创建表描述
    JTFormDescriptor *formDescriptor = [JTFormDescriptor formDescriptor];
    // 是否在必填行的title前面添加一个红色的*
    formDescriptor.addAsteriskToRequiredRowsTitle = YES;
    JTSectionDescriptor *section = nil;
    JTRowDescriptor *row = nil;
    
    #pragma mark - float text

    // 创建节描述
    section = [JTSectionDescriptor formSection];
    // 为 section 创建 header title，需要手动设置 height
    section.headerAttributedString = [NSAttributedString jt_attributedStringWithString:@"float text" font:nil color:nil firstWordColor:nil];
    section.headerHeight = 30.;
    [formDescriptor addSection:section];
    
    // 创建行描述
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeFloatText rowType:JTFormRowTypeFloatText title:@"测试"];
    // 是否为必录行
    row.required = YES;
    [section addRow:row];
    
    #pragma mark - formatter
    
    row = [JTRowDescriptor rowDescriptorWithTag:@"20" rowType:JTFormRowTypeNumber title:@"百分比"];
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
    // valueFormatter 属性用来将文本转换成另一个格式的文本
    // 这里valueFormatter的作用是将数字转换成百分数，例如10->1000%
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
    
    row = [JTRowDescriptor rowDescriptorWithTag:JTFormRowTypeName 
rowType:JTFormRowTypeName title:@"JTFormRowTypeName"];
    // 占位符
    row.placeHolder = @"请输入姓名...";
    row.required = YES;
    [section addRow:row];
   
    // 创建 JTForm，formDescriptor 不能为空
    JTForm *form = [[JTForm alloc] initWithDescriptor:formDescriptor];
    form.frame = CGRectMake(0, 0, kJTScreenWidth, kJTScreenHeight-64.);
    [self.view addSubview:form];
    self.form = form;

```
### 行描述 JTRowDescriptor

行描述`JTRowDescriptor`是单元行的数据源，我们通过修改 JTRowDescriptor 来控制单元行的行为，例如：是否显示，是否可编辑，高度，标题，是否必录，占位符。
下面是JTRowDescriptor的主要属性和常用方法

#### configMode

JTFormConfigMode 类型，用来配置单元行的 UI，下面是 JTFormConfigMode 属性介绍
- titleColor：标题颜色
- contentColor：详情颜色
- placeHolderColor：占位符颜色
- disabledTitleColor：禁用时标题颜色
- disabledContentColor：禁用时详情颜色
- backgroundColor：背景颜色
- titleFont：标题字体 
- contentFont：详情字体
- placeHlderFont：占位符字体
- disabledTitleFont：禁用时标题字体
- disabledContentFont：禁用时详情字体

`JTSectionDescriptor`和`JTFormDescriptor`同样具有 configMode 属性，作用相同。优先级JTRowDescriptor > JTSectionDescriptor > JTFormDescriptor

当你自定义单元行时，为了表单样式的整齐协调，你可以使用 JTBaseCell 的以下方法，这些方法会根据单元行的状态 disabled/enabled 返回相应的 color，font
```
- (UIColor *)cellTitleColor;

- (UIColor *)cellContentColor;

- (UIColor *)cellPlaceHolerColor;

- (UIFont *)cellTitleFont;

- (UIFont *)cellContentFont;

- (UIFont *)cellPlaceHolerFont;

- (UIFont *)cellDisabledContentFont;

- (UIColor *)cellBackgroundColor;

```

#### image & imageUrl
用于加载图片，样式类似于UITableViewCell的imageView。image应用于静态图片，imageUrl用于加载网络图片。
![](https://i.loli.net/2019/11/01/p539Yac4FbrOeqI.jpg)

#### rowType
创建表单时，根据`rowType`来创建不同类型的单元行。目前自带的`rowType`都已经添加到了`[JTForm cellClassesForRowTypes]`字典中，其中`rowType`为key，`value`为单元行类型Class。

当你自定义单元行时，你需要在`+ (void)load`方法中，将相应的 rowType 以及对应的 Class 添加到`[JTForm cellClassesForRowTypes]`字典中。

#### tag

每一个表单，都有一个字典类型的属性 allRowsByTag 来根据 tag 来管理单元行。
当添加单元行时，若 tag 不为空，则将其添加到字典 allRowsByTag 中，其中key为tag，value为行描述；若 tag 为空，则不添加。

如果创建表单时有多个行描述tag值一样的话，字典中将只会保存最后添加进去的JTRowDescriptor。

在表单中，你根据tag值找到相对应的行描述，所以需要保持 tag 的唯一性。

#### height

该属性控制着单元行高度。默认值为`JTFormUnspecifiedCellHeight`，即不指定高度(自动布局)。

你可以通过以下方法来设置单元行高度：
1. JTRowDescriptor 的 height 属性
2. JTBaseCellDelegate 的方法`+ (CGFloat)formCellHeightForRowDescriptor:(JTRowDescriptor *)row;`
3. 自动调节高度

优先级 1 > 2 > 3

#### action

使用方法：
```
    row = [JTRowDescriptor rowDescriptorWithTag:@"1" rowType:JTFormRowTypePushButton title:@"select"];
    row.action.rowBlock = ^(JTRowDescriptor * _Nonnull sender) {
        SelectViewController *vc = [[SelectViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };
    [section addRow:row];

```
上面的 rowBlock 将会在单元行被点击后执行。
如果单元行上多个控件有响应事件时，可以先使用`- (JTBaseCell *)cellInForm;`得到当前的单元行 cell，然后用`[cell.button addTarget:self action:action forControlEvents:UIControlEvents]`添加响应事件。

#### hidden & disabled

hidden：bool值，控制隐藏或者显示当前单元行
disabled：bool值，控制当前单元行是否接受响应事件

当你给该属性给定一个值后，单元行会动态的改变 UI。
`JTSectionDescriptor`和`JTFormDescriptor` 同样具有这些属性，作用相同。优先级JTRowDescriptor > JTSectionDescriptor > JTFormDescriptor

#### cellConfigAfterUpdate & cellConfigWhenDisabled & cellConfigAtConfigure & cellDataDictionary

- cellConfigAfterUpdate：配置cell，在 update 方法执行后使用
- cellConfigWhenDisabled：配置cell，当 update 方法执行后，且 disabled 属性为Yes时被使用
- cellConfigAtConfigure：配置cell，在 config 执行后，update 执行前调用
- cellDataDictionary：预留，可以用来储存数据

#### text

文本方面的属性比较多，统一放到这里讲

- valueFormatter：文本格式转换，可以将数据格式化为一种易读的格式。NSFormatter 是一个抽象类，我们只使用它的子类，类似`NSDateFormatter`和`NSNumberFormatter`
- placeHolder：占位符，当value为空时显示该内容 (适用于自带的所有单元行)
- maxNumberOfCharacters：文本类单元行能输入最大字符数
- `- (nullable NSString *)displayTextValue;`:在未编辑状态时，详情的显示内容
- `- (nullable NSString *)editTextValue;`：在编辑状态时，详情的显示内容

#### 验证器

使用验证器来对单元行的值进行验证。例如，表单中有一行是输入身份证号的，你可以添加一个自定义的验证器来验证身份证号格式是否正确。自定义验证器需要实现`JTFormValidateProtocol`里面的方法。
你可以通过`- (void)addValidator:(nonnull id<JTFormValidateProtocol>)validator`添加一个或多个验证器，验证器的作用是对单元行的值进行验证，来判断是否符合你的要求，例如：身份证格式，密码的复杂程度，字数长度等。使用方法`- (void)removeValidator:(nonnull id<JTFormValidateProtocol>)validator`或者`- (void)removeAllValidators`移除验证器

### 单元行类型

#### 文本类

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

- JTFormRowTypePushSelect：push 到另一个 UIViewController 中，单选
- JTFormRowTypeMultipleSelect：push 到另一个 UIViewController 中，多选
- JTFormRowTypeSheetSelect：使用 UIAlertControllerStyleActionSheet 样式的 UIAlertController来选择，单选
- JTFormRowTypeAlertSelect：使用 UIAlertControllerStyleAlert 样式的 UIAlertController来选择，单选
- JTFormRowTypePickerSelect：使用 UIPicker 来选择，单选

选择项通常会拥有一个展示文本，一个是代表 value 的 id。例如在选择汽车型号的时候，我们看到的是不同汽车型号的文本，当你选中之后传给后台的是代表该型号的 id。

在选择类的单元行中，我们使用的选择项类型是`JTOptionObject`，主要由两个属性`formDisplayText`和`formValue`，含义顾名思义。
固定的选择项可以赋值给 JTRowDescriptor 的`selectorOptions`属性，选择之后，单元行的 value 是`JTOptionObject`类型(单选)或者为`NSArray<JTOptionObject *> *`类型(多选)。

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

单元行的基类，自定义单元行的话需要继承它。`JTBaseCell`里面的属性和方法都比较简单，下面简单说明一下：

#### config

初始化控件，在这个方法里只需要创建需要的控件，但不需要为控件添加内容，因为这个时候并没有添加进去数据源`JTRowDescriptor`。在生命周期内该方法只会被调用一次，除非调用`JTRowDescriptor`的方法`reloadCellWithNewRowType`，该方法会更换单元行样式并重新加载控件。
子类中实现时需要调用`[super config]`

#### update

更新视图内容，在生命周期中会被多次调用。在这个方法中，我们可以为已经创建好的控件添加内容。
子类中实现时需要调用`[super update]`

#### 其它

- `- (BOOL)cellCanBecomeFirstResponder`
指示单元行是否能够成为第一响应者, 默认返回NO

- `- (BOOL)cellBecomeFirstResponder`
单元行成为第一响应者


- `- (void)cellHighLight`
单元行成为第一响应者

- `- (void)cellUnHighLight`
单元行 resign 第一响应者



### 自定义单元行
当你自定义单元行时，需要继承 JTBaseCell。且必须重写下面几个方法

以 demo 中自定义的单元行`IGCell`为例。

#### 1. + (void)load

首先，你需要一个 rowType 来代表该行。然后在`+ (void)load`方法中`[[JTForm cellClassesForRowTypes] setObject:self forKey:JTFormRowTypeIGCell];`将rowType与单元行关联起来。
```
+ (void)load {
    [[JTForm cellClassesForRowTypes] setObject:self forKey:JTFormRowTypeIGCell];
}
```

#### 2. - (void)config

```
- (void)config {
  [super config];  
  // 你的代码
}
```
在这里你可以创建好控件，但不需要为控件添加内容。注意需要调用`[super config];`。

#### 3. - (void)update

```
- (void)update {
  [super update];  
  // 你的代码
}
```
在这个方法中，我们可以为已经创建好的内容添加内容。。注意需要调用`[super update];`

#### 4. - (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize

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

你可以通过`JTForm`的`- (NSDictionary *)formValues`方法获取表单值。如果设置了验证器或者有必填项，可以先调用`- (NSArray<NSError *> *)formValidationErrors`来获取错误集合，再获取表单值进行其它操作。

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


#### 如何自定义类似于 JTFormRowTypeDateInline 的内联行

要创建类似`JTFormRowTypeDateInline`的内联行，就意味着需要自定义两种单元行。拿JTFormRowTypeDateInline 举个例子，A：JTFormDateCell，B：JTFormDateInlineCell。当你选中A时，B显示出来，再选中A，B消失。

详情请参考 JTFormDateInlineCell 文件

