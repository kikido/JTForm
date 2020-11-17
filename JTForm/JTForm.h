//
//  JTForm.h
//  JTForm (https://github.com/kikido/JTForm)
//
//  Created by DuQianHang (https://github.com/kikido)
//  Copyright © 2019 dqh. All rights reserved.
//  Licensed under MIT: https://opensource.org/licenses/MIT
//
#import "JTFormDescriptor.h"
#import "JTSectionDescriptor.h"
#import "JTRowDescriptor.h"
#import "JTFormDefines.h"

NS_ASSUME_NONNULL_BEGIN

@class ASTableNode;
@class ASTableView;

extern NSString *const JTRowDescriptorErrorKey;

@interface JTForm : UIView
/**
 * JTForm 包含的 ASTableNode 实例
 *
 * Texture 将耗时的渲染解码操作放到后台线程中执行，已达到流畅的目的。
 * 你可以通过下面的网址了解更多：http://texturegroup.org/docs/getting-started.html
 */
@property (nonatomic, strong, readonly) ASTableNode *tableNode;

/**
 * 具有异步加载功能的 UITableView
 *
 * 推荐使用 ASTableNode 而不是 ASTableView
 */
@property (nonatomic, strong, readonly) ASTableView *tableView;


@property (nonatomic, strong, readonly) ASCollectionNode *collectionNode;

@property (nonatomic, strong, readonly) ASCollectionView *collectionView;

/**
 * 代理对象
 */
@property (nonatomic, weak) id<JTFormDelegate> delegate;

/**
 * 数据源，表描述
 */
@property (nonatomic, strong, readonly) JTFormDescriptor *formDescriptor;

/**
 * 创建一个 JTForm 实例
 *
 * @param formDescriptor 表描述。
 * @return JTForm实例。在调用这个方法之前，最好将
 * JTSectionDescriptor 和 JTRowDescriptor 添加到 JTFormDescriptor 中
 */
- (instancetype)initWithDescriptor:(JTFormDescriptor *)formDescriptor;

+ (instancetype)formWithDescriptor:(JTFormDescriptor *)formDescriptor;

/**
 * 用于生成实例
 *
 * @discuss 通过该方法，你可以使用 JTForm 创建 UICollectionView 而不仅仅是 UITableView
 */
- (instancetype)initWithDescriptor:(JTFormDescriptor *)formDescriptor formType:(JTFormType)formType;

+ (instancetype)formWithDescriptor:(JTFormDescriptor *)formDescriptor formType:(JTFormType)formType;

- (instancetype)initWithFrame:(CGRect)frame __unavailable;
- (instancetype)initWithCoder:(NSCoder *)aDecoder __unavailable;
- (instancetype)init __unavailable;
- (instancetype)new __unavailable;


//------------------------------
/// @name form value
///-----------------------------

/**
 * 单元行 value 的集合，其中key为单元行的 tag，value为单元行的 value
 *
 * @note: 1. 单元行的 value 为空(空字符串，空数组也算)时，字典中对应的 value 为 [nsnull null]
 *        2. 单元行的 tag 重复时，仅保存其中的一条
 *        3. 如果是选择项样式的单元行，value 为 JTOptionObject 类型。如果想 value 为 JTOptionObject.formValue，
 *           你可以使用 formHttpValues 方法来获取表单值
 *        4. 隐藏掉的单元行的 value 也会在字典中
 */
- (NSDictionary *)formValues;

/**
 * 单元行 value 的集合，其中key为单元行的 tag，value为单元行的 value
 *
 * @note 与上面方法 formValues 唯一不同的是：当单元行是选择项样式时，在字典中对应的 value 是`JTOptionObject.formValue`
 * @return 表单值
 */
- (NSDictionary *)formHttpValues;


//------------------------------
/// @name validate
///-----------------------------

/**
 * 验证表单中某一节的 value
 *
 * @discuss 会对该一节中所有的单元行进行验证
 * @param sectionDescriptor 节描述
 * @return 验证结果。如果验证通过则返回 nil，否则返回元素为 NSError 类型的数组
 */
- (nullable NSArray<NSError *> *)sectionValidationErrors:(JTSectionDescriptor *)sectionDescriptor;

/**
 * 对表单的 value 进行验证
 *
 * @discuss 会对表单中所有的单元行进行验证
 * @return 验证结果。如果验证通过则返回 nil，否则返回元素为 NSError 类型的数组
 */
- (NSArray<NSError *> *)formValidationErrors;

/**
 * 在当前的视图控制器内显示 error 信息
 *
 * 当 JTForm 不在当前的视图层级时调用该方法无效
 * @param error 错误信息
 */
- (void)showFormValidationError:(NSError *)error;

/**
 * 在当前的视图控制器内显示 error 信息
 *
 * 当 JTForm 不在当前的视图层级时调用该方法无效
 * @param error 错误信息
 * @param title 自定义标题
 */
- (void)showFormValidationError:(NSError *)error withTitle:(NSString*)title;


//------------------------------
/// @name row types
///-----------------------------

/**
 * 单元行样式字典。其中 key 为 JTFormRowType 类型，value 为 JTBaseCell 的子类 Class
 *
 * @discuss 更多 JTFormRowType 信息请查阅 JTRowDescriptor.h
 * @note 当你自定义单元行时，请你在对应 Class 的 +(void)load 方法内，
 * 以同样的对应关系 rowType -> cell class 保存到该字典中
 *
 @return 单元行样式字典
 */
+ (NSMutableDictionary *)cellClassesForRowTypes;

/**
 * 关联单元行样式集合
 *
 * @discuss 该字典的映射关系:【单元行样式 rowType -> 被关联单元行样式 rowType】。顾名思义，即一种单元行对应着另一种样式的单元行。
 * 举个例子：
 * 有单元行 a，被关联单元行 b。 当 a 成为第一响应者(first responder)后，表单会在 a 后面添加关联单元行 b；当 a 放弃第一响应者后，
 * 关联单元行 b 从表单中移除。在 JTForm 中，JTFormRowTypeDateInline 即是拥有关联单元行的类型。
 * 当你自定义自己的关联单元行样式时，请在 +load 方法中将对应的数据保存到 inlineRowTypesForRowTypes 字典中。
 *
 * @return 字典集合
 */
+ (NSMutableDictionary *)inlineRowTypesForRowTypes;

/**
 * 确保单元行在视图内可见
 *
 * @discuss 当你自定义内联行时，新添加进去的内联行在当前视图界面可能不能完全显示出来，
 * 你可以使用这个方法来避免这种情况
 *
 * @param rowDescriptor 行描述
 */
- (void)ensureRowIsVisible:(JTRowDescriptor *)rowDescriptor;


//------------------------------
/// @name row
///-----------------------------

/**
 * 在表单最后面添加单元行
 *
 * @param row 行描述
 */
- (void)addRow:(JTRowDescriptor *)row;

/**
 * 在表单最后面添加一些单元行
 *
 * @param rows 行描述
 */
- (void)addRows:(NSArray<JTRowDescriptor *> *)rows;

/**
 * 在指定位置插入单元行
 *
 * @param rows 行描述数组
 * @param indexPath 索引位置
 */
- (void)addRows:(NSArray<JTRowDescriptor *> *)rows atIndexPath:(NSIndexPath *)indexPath;

/**
 * 在某单元行前面添加新的单元行
 *
 * @param rows 行描述
 * @param beforeRow 行描述，对应的单元行需要已经在 form 中了，否则新的单元行将添加到 form 最前面
 */
-(void)addRows:(NSArray<JTRowDescriptor *> *)rows beforeRow:(JTRowDescriptor *)beforeRow;

/**
 * 在某单元行后面添加新的单元行
 *
 * @param rows 行描述
 * @param afterRow 行描述，对应的单元行需要已经在 form 中了，否则新的单元行将添加到 form 最后面
 */
- (void)addRows:(NSArray<JTRowDescriptor *> *)rows afterRow:(JTRowDescriptor *)afterRow;

/**
 * 在某单元行前面添加新的单元行
 *
 * @param rows 行描述
 * @param beforeRowTag 根据该 tag 找到相应的单元行，如果该单元行不存在则将添加到 form 最前面
 */
- (void)addRows:(NSArray<JTRowDescriptor *> *)rows beforeRowWithTag:(id<NSCopying>)beforeRowTag;

/**
 * 在某单元行后面添加新的单元行
 *
 * @param rows 行描述
 * @param afterRowTag 根据该 tag 找到相应的单元行，如果该单元行不存在则将添加到 form 最后面
 */
- (void)addRows:(NSArray<JTRowDescriptor *> *)rows afterRowWithTag:(id<NSCopying>)afterRowTag;

/**
 * 移除单元行
 *
 * @param row 行描述
 */
-(void)removeRow:(JTRowDescriptor *)row;

/**
 * 移除一些单元行
 *
 * @param rows 行描述数组
 */
-(void)removeRows:(NSArray<JTRowDescriptor *> *)rows;

/**
 * 在表单指定位置移除单元行
 *
 * @param indexPath 表单中的索引位置
 */
- (void)removeRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 * 移除单元行
 *
 * @param tag 对应单元行的 tag
 */
-(void)removeRowByTag:(id<NSCopying>)tag;

/**
 * 根据 tag 查找相应单元行
 *
 * @param tag 单元行的 tag
 * @return 行描述
 */
- (nullable JTRowDescriptor *)findRowByTag:(id<NSCopying>)tag;

/**
 * 根据给定索引查找相应的单元行
 *
 * @param indexPath 给定的索引位置
 * @return 行描述。如果索引超出表单范围，则返回 nil
 */
- (JTRowDescriptor *)rowAtIndexPath:(NSIndexPath *)indexPath;

/**
 * 根据 tag 查找对应单元行的 value
 *
 * @param tag 单元行的 tag
 * @return 单元行的 value。如果是选择项样式的单元行，那么返回值是选择项的 formValue
 */
- (nullable id)findRowValueByTag:(id<NSCopying>)tag;

/**
 * 查找给定单元行在表单中的索引位置
 *
 * @param rowDescriptor 行描述
 * @return 单元行的索引位置，如果不在表单范围内则返回 nil
 */
- (nullable NSIndexPath *)indexPathForRow:(JTRowDescriptor *)rowDescriptor;

/**
 * 隐藏/显示 单元行
 *
 * @discuss 调用该方法后无需手动刷新，即能改变 UI
 * @note 如果只需要隐藏/显示一条单元行，可以直接设置其行描述的 hidden 属性
 *
 * @param hidden YES表示隐藏，否则为显示
 * @param tags 单元行对应的tag
 */
- (void)setRowsHidden:(BOOL)hidden byTags:(NSArray<id<NSCopying>> *)tags;

/**
 * 设置单元行的可编辑状态
 *
 * @param disabled YES表示禁用，NO表示可以编辑
 * @param tags 单元行对应的tag
 */
- (void)setRowsDisabled:(BOOL)disabled byTags:(NSArray<id<NSCopying>> *)tags;

/**
 * 设置单元行是否为必录项
 *
 * @note 调用该方法会自动更新单元行的 UI
 *
 * @param required YES表示为必录项，NO表示非必录项
 * @param tags 单元行对应的tag
 */
- (void)setRowsRequired:(BOOL)required byTags:(NSArray<id<NSCopying>> *)tags;

/**
 * 设置单元行的 value
 *
 * @note 调用该方法会自动更新单元行的 UI，次方法会触发 KVO
 *
 * @param value 单元行的值
 * @param tag 单元行对应的tag
 */
- (void)manualSetRowValue:(nullable id)value byTag:(id<NSCopying>)tag;

/**
 * 刷新单元行的 UI
 *
 * @param tags 单元行对应的tag
 */
- (void)updateRowsByTags:(NSArray<id<NSCopying>> *)tags;

/**
 * 刷新单元行的 UI
 *
 * @param rowDescriptor 行描述
 */
- (void)updateRow:(JTRowDescriptor *)rowDescriptor;

/**
 * 刷新表单的 UI
 *
 * @discuss 你可以在例如改变了字体大小的场景下使用该方法
 */
- (void)updateAllRows;

/**
 * 重新加载单元行
 *
 * @note 使用该方法将重新创建单元行里面的视图控件
 *
 * @param rowDescriptors 行描述
 */
- (void)reloadRows:(NSArray <JTRowDescriptor *>*)rowDescriptors;

/**
 * 重新生成表单所有单元行上的视图控件
 *
 * @note 开销较大
 */
- (void)reloadForm;


//------------------------------
/// @name section
///-----------------------------

/**
 * 在表单上添加节
 *
 * @param section 节描述
 */
- (void)addSection:(JTSectionDescriptor *)section;

/**
 * 在表单上添加一些节
 *
 * @param sections 节描述数组
 */
- (void)addSections:(NSArray<JTSectionDescriptor *> *)sections;

/**
 * 在表单上指定位置添加节
 *
 * @param sections 节描述
 * @param index 在表单中的索引位置
 */
- (void)addSections:(NSArray<JTSectionDescriptor *> *)sections atIndex:(NSInteger)index;

/**
 * 在指定节前面添加新的节
 *
 * @param sections 新添加节的节描述
 * @param beforeSection 表单中已存在的节
 */
- (void)addSections:(NSArray<JTSectionDescriptor *> *)sections beforeSection:(JTSectionDescriptor *)beforeSection;

/**
 * 在指定节后面添加新的节
 *
 * @param sections 新添加节的节描述
 * @param afterSection 表单中已存在的节
 */
- (void)addSections:(NSArray<JTSectionDescriptor *> *)sections afterSection:(JTSectionDescriptor *)afterSection;

/**
 * 在表单中移除节
 *
 * @param section 需要移除节的节描述
 */
- (void)removeSection:(JTSectionDescriptor *)section;

/**
 * 在表单中移除一些节
 *
 * @param sections 节描述数组
 */
- (void)removeSections:(NSArray<JTSectionDescriptor *> *)sections;

/**
 * 移除表单中某个位置的节
 *
 * @param index 需要移除节的索引位置
 */
- (void)removeSectionAtIndex:(NSUInteger)index;

/**
 * 移除某些索引位置上的节
 *
 * @param indexSet 节的索引集合
 */
- (void)removeSectionsAtIndexes:(NSIndexSet *)indexSet;

/**
 * 查找节在表单中的索引位置
 *
 * @param sectionDescriptor 节描述
 * @return 节在表单中的索引位置。如果没有出现在表单中，则返回 NSNotFound
 */
- (NSUInteger)indexOfSection:(JTSectionDescriptor *)sectionDescriptor;

/**
 * 根据给定索引查找相应的节
 *
 * @param index 给定的索引位置
 * @return 节描述。如果索引超出了表单范围，则返回 nil
 */
- (nullable JTSectionDescriptor *)sectionAtIndex:(NSUInteger)index;


//------------------------------
/// @name edit text
///-----------------------------

/**
 * 询问是否可以进入编辑状态
 *
 * @note textField 和 editableTextNode 只能存在一个为空时另一个不为空一种状态
 *
 * @param row 单元行
 * @param textField UITextField 实例，可能为空
 * @param editableTextNode ASEditableTextNode 实例，可能为空
 * @return 是否能进入编辑状态
 */
- (BOOL)textTypeRowShouldBeginEditing:(JTRowDescriptor *)row
                            textField:(nullable UITextField *)textField
                    editableTextNode:(nullable ASEditableTextNode *)editableTextNode;

/**
 * 已经开始进入编辑状态
 *
 * @note textField 和 editableTextNode 只能存在一个为空时另一个不为空一种状态
 *
 * @param row 单元行
 * @param textField UITextField 实例，可能为空
 * @param editableTextNode ASEditableTextNode 实例，可能为空
 */
- (void)textTypeRowDidBeginEditing:(JTRowDescriptor *)row
                         textField:(nullable UITextField *)textField
                  editableTextNode:(nullable ASEditableTextNode *)editableTextNode;


/**
 *  在编辑时是否用指定文本替换掉某一个范围的文本
 *
 *  * @note textField 和 editableTextNode 只能存在一个为空时另一个不为空一种状态
 *
 * @param range 范围
 * @param text 替换的文本
 * @param row 行描述
 * @param textField UITextField 实例，可能为空
 * @param editableTextNode ASEditableTextNode 实例，可能为空
 * @return 能否替换
 */
- (BOOL)textTypeRowShouldChangeTextInRange:(NSRange)range
                           replacementText:(NSString *)text
                             rowDescriptor:(JTRowDescriptor *)row
                                 textField:(nullable UITextField *)textField
                          editableTextNode:(nullable ASEditableTextNode *)editableTextNode;

/**
 * 结束编辑状态
 *
 * @note textField 和 editableTextNode 只能存在一个为空时另一个不为空一种状态
 *
 * @param row 单元行
 * @param textField UITextField 实例，可能为空
 * @param editableTextNode ASEditableTextNode 实例，可能为空
 */
- (void)textTypeRowDidEndEditing:(JTRowDescriptor *)row
                       textField:(nullable UITextField *)textField
                editableTextNode:(nullable ASEditableTextNode *)editableTextNode;

/**
 * 单元行开始进入编辑状态
 *
 * @param row 单元行
 */
- (void)beginEditing:(JTRowDescriptor *)row;

/**
 * 单元行结束进入编辑状态
 *
 * @param row 单元行
 */
- (void)endEditing:(JTRowDescriptor *)row;

@end

NS_ASSUME_NONNULL_END
