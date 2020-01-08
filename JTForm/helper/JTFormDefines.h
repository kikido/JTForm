//
//  JTFromDefines.h
//  JTFormDemo
//
//  Created by dqh on 2020/1/6.
//  Copyright © 2020 dqh. All rights reserved.
//

#ifndef JTFromDefines_h
#define JTFromDefines_h

typedef NS_ENUM(NSUInteger, JTFormType) {
    /** UITableView 样式 */
    JTFormTypeTable = 1,
    
    /** 瀑布流样式，不需要设置 item size 的大小
     *
     * 该样式需要你手动设置 numberOfColumn，lineSpace，interItemSpace，sectionInsets。 item size 大小会自动计算
     */
    JTFormTypeCollectionColumnFlow,
    
    /** 类似于瀑布流，但 item 的 size 大小是固定值
     *
     * 该样式需要你手动设置 numberOfColumn，lineSpace，interItemSpace，sectionInsets，itmeSize
     */
    JTFormTypeCollectionColumnFixed,
    
    /** item szie 固定，不需要设置列数
     *
     * 该样式需要你手动设置 lineSpace，interItemSpace，sectionInsets，itmeSize。当一行铺不下时跳转到下一行
     */
    JTFormTypeCollectionFixed
};

typedef NS_ENUM(NSUInteger, JTFormScrollDirection) {
    JTFormScrollDirectionHorizontal,
    JTFormScrollDirectionVertical
};


#endif /* JTFromDefines_h */
