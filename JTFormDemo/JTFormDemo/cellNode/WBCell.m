//
//  WBCell.m
//  JTFormDemo
//
//  Created by dqh on 2019/5/17.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "WBCell.h"
#import "WBMode.h"
#import "UIImage+JTFormAdd.h"
#import "NSAttributedString+YYText.h"
#import "YYText.h"
#import <UIButton+WebCache.h>
#import <UIImageView+WebCache.h>
#import "NSObject+YYModel.h"


/*
 
 用户信息   status.user
 文本      status.text
 图片      status.pics
 转发      status.retweetedStatus
 文本      status.retweetedStatus.user + status.retweetedStatus.text
 图片      status.retweetedStatus.pics
 卡片      status.retweetedStatus.pageInfo
 卡片      status.pageInfo
 Tip      status.tagStruct
 
 1.根据 urlStruct 中每个 URL.shortURL 来匹配文本，将其替换为图标+友好描述
 2.根据 topicStruct 中每个 Topic.topicTitle 来匹配文本，标记为话题
 2.匹配 @用户名
 4.匹配 [表情]
 
 一条里，图片|转发|卡片不能同时存在，优先级是 转发->图片->卡片
 如果不是转发，则显示Tip
 
 
 文本
 文本 图片/卡片
 文本 Tip
 文本 图片/卡片 Tip
 
 文本 转发[文本]  /Tip
 文本 转发[文本 图片] /Tip
 文本 转发[文本 卡片] /Tip
 
 话题                                 #爸爸去哪儿#
 电影 timeline_card_small_movie       #冰雪奇缘[电影]#
 图书 timeline_card_small_book        #纸牌屋[图书]#
 音乐 timeline_card_small_music       #Let It Go[音乐]#
 地点 timeline_card_small_location    #理想国际大厦[地点]#
 股票 timeline_icon_stock             #腾讯控股 kh00700[股票]#
 */


// 宽高
#define kWBCellTopMargin 8      // cell 顶部灰色留白
#define kWBCellTitleHeight 36   // cell 标题高度 (例如"仅自己可见")
#define kWBCellPadding 12       // cell 内边距
#define kWBCellPaddingText 10   // cell 文本与其他元素间留白
#define kWBCellPaddingPic 4     // cell 多张图片中间留白
#define kWBCellProfileHeight 56 // cell 名片高度
#define kWBCellCardHeight 70    // cell card 视图高度
#define kWBCellNamePaddingLeft 14 // cell 名字和 avatar 之间留白
#define kWBCellContentWidth (kScreenWidth - 2 * kWBCellPadding) // cell 内容宽度
#define kWBCellNameWidth (kScreenWidth - 110) // cell 名字最宽限制

#define kWBCellTagPadding 8         // tag 上下留白
#define kWBCellTagNormalHeight 16   // 一般 tag 高度
#define kWBCellTagPlaceHeight 24    // 地理位置 tag 高度

#define kWBCellToolbarHeight 35     // cell 下方工具栏高度
#define kWBCellToolbarBottomMargin 2 // cell 下方灰色留白

// 字体 应该做成动态的，这里只是 Demo，临时写死了。
#define kWBCellNameFontSize 16      // 名字字体大小
#define kWBCellSourceFontSize 12    // 来源字体大小
#define kWBCellTextFontSize 17      // 文本字体大小
#define kWBCellTextFontRetweetSize 16 // 转发字体大小
#define kWBCellCardTitleFontSize 16 // 卡片标题文本字体大小
#define kWBCellCardDescFontSize 12 // 卡片描述文本字体大小
#define kWBCellTitlebarFontSize 14 // 标题栏字体大小
#define kWBCellToolbarFontSize 14 // 工具栏字体大小

// 颜色
#define kWBCellNameNormalColor UIColorHex(333333) // 名字颜色
#define kWBCellNameOrangeColor UIColorHex(f26220) // 橙名颜色 (VIP)
#define kWBCellTimeNormalColor UIColorHex(828282) // 时间颜色
#define kWBCellTimeOrangeColor UIColorHex(f28824) // 橙色时间 (最新刷出)

#define kWBCellTextNormalColor UIColorHex(333333) // 一般文本色
#define kWBCellTextSubTitleColor UIColorHex(5d5d5d) // 次要文本色
#define kWBCellTextHighlightColor UIColorHex(527ead) // Link 文本色
#define kWBCellTextHighlightBackgroundColor UIColorHex(bfdffe) // Link 点击背景色
#define kWBCellToolbarTitleColor UIColorHex(929292) // 工具栏文本色
#define kWBCellToolbarTitleHighlightColor UIColorHex(df422d) // 工具栏文本高亮色

#define kWBCellBackgroundColor UIColorHex(f2f2f2)    // Cell背景灰色
#define kWBCellHighlightColor UIColorHex(f0f0f0)     // Cell高亮时灰色
#define kWBCellInnerViewColor UIColorHex(f7f7f7)   // Cell内部卡片灰色
#define kWBCellInnerViewHighlightColor  UIColorHex(f0f0f0) // Cell内部卡片高亮时灰色
#define kWBCellLineColor [UIColor colorWithWhite:0.000 alpha:0.09] //线条颜色

#define kWBLinkHrefName @"href" //NSString
#define kWBLinkURLName @"url" //WBURL
#define kWBLinkTagName @"tag" //WBTag
#define kWBLinkTopicName @"topic" //WBTopic
#define kWBLinkAtName @"at" //NSString

#define USER_IMAGE_HEIGHT 40.

NSString *const JTFormRowTypeWBCell = @"JTFormRowTypeWBCell";

/**
 微博的文本中，某些嵌入的图片需要从网上下载，这里简单做个封装
 */
@interface WBTextImageViewAttachment : YYTextAttachment
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, assign) CGSize size;
@end

@implementation WBTextImageViewAttachment {
    UIImageView *_imageView;
}
- (void)setContent:(id)content {
    _imageView = content;
}
- (id)content {
    /// UIImageView 只能在主线程访问
    if (pthread_main_np() == 0) return nil;
    if (_imageView) return _imageView;
    
    /// 第一次获取时 (应该是在文本渲染完成，需要添加附件视图时)，初始化图片视图，并下载图片
    /// 这里改成 YYAnimatedImageView 就能支持 GIF/APNG/WebP 动画了
    _imageView = [UIImageView new];
    [_imageView sd_setImageWithURL:_imageURL placeholderImage:nil];
    
    CGRect frame = _imageView.frame;
    frame.size = _size;
    _imageView.frame = frame;
    
    return _imageView;
}
@end


@interface WBCell ()

/** 顶部灰色 */
@property (nonatomic, strong) ASDisplayNode *topNode;

@property (nonatomic, strong) JTNetworkImageNode *avatarView;
@property (nonatomic, strong) JTNetworkImageNode *avatarBadgeView;
@property (nonatomic, strong) ASTextNode *nameLabel;
@property (nonatomic, strong) ASTextNode *sourceLabel;
@property (nonatomic, strong) ASTextNode *contentLabel;
@property (nonatomic, strong) NSArray<JTNetworkImageNode *> *pics;

@property (nonatomic, strong) ASDisplayNode *retweetedNode;
@property (nonatomic, strong) ASTextNode *retweeted_contentLabel;
@property (nonatomic, strong) NSMutableArray<JTNetworkImageNode *> *retweeted_pics;


@property (nonatomic, strong) ASButtonNode *retweetedButton;
@property (nonatomic, strong) ASButtonNode *commentButton;
@property (nonatomic, strong) ASButtonNode *likeButton;

@end

@implementation WBCell

+ (void)load
{
    [[JTForm cellClassesForRowTypes] setObject:self forKey:JTFormRowTypeWBCell];
}

- (void)config
{
    [super config];
    
    _topNode = [[ASDisplayNode alloc] init];
    _topNode.backgroundColor = kWBCellBackgroundColor;
    
    _avatarView = [[JTNetworkImageNode alloc] init];
    [_avatarView setImageModificationBlock:^UIImage * _Nullable(UIImage * _Nonnull image, ASPrimitiveTraitCollection traitCollection) {
        return [image makeCircularImageWithSize:CGSizeMake(USER_IMAGE_HEIGHT, USER_IMAGE_HEIGHT)];
    }];
    _avatarBadgeView = [[JTNetworkImageNode alloc] init];
    [_avatarBadgeView setImageModificationBlock:^UIImage * _Nullable(UIImage * _Nonnull image, ASPrimitiveTraitCollection traitCollection) {
        return [image makeCircularImageWithSize:CGSizeMake(14., 14.)];
    }];
    
    _nameLabel = [[ASTextNode alloc] init];
    _nameLabel.layerBacked = YES;
    _nameLabel.maximumNumberOfLines = 1;
    
    _retweeted_contentLabel = [[ASTextNode alloc] init];
    
    _sourceLabel = [[ASTextNode alloc] init];
    _contentLabel = [[ASTextNode alloc] init];
    _retweetedNode = [[ASDisplayNode alloc] init];
    
    _retweetedButton = [[ASButtonNode alloc] init];
    _commentButton = [[ASButtonNode alloc] init];
    _likeButton = [[ASButtonNode alloc] init];
    
    _retweeted_pics = @[].mutableCopy;
}

- (void)update
{
    [super update];

    
    WBStatus *mode = (WBStatus *)self.rowDescriptor.mode;
    _avatarView.URL = mode.user.avatarLarge;
    _avatarView.style.preferredSize = CGSizeMake(USER_IMAGE_HEIGHT, USER_IMAGE_HEIGHT);
    _avatarBadgeView.style.preferredSize = CGSizeMake(14., 14.);
    
    switch (mode.user.verifiedType) {
        case WBUserVerifyTypeStandard:
            _avatarBadgeView.image = [self findImageByName:@"avatar_vip"];
            break;
        case WBUserVerifyTypeClub:
            _avatarBadgeView.hidden = NO;
            _avatarBadgeView.image = [self findImageByName:@"avatar_grassroot"];
        default:
            _avatarBadgeView.hidden = YES;
            break;
    }
    
    _nameLabel.attributedText = [self attributedStringWithString:mode.user.screenName font:[UIFont systemFontOfSize:kWBCellNameFontSize] color:mode.user.mbrank > 0 ? kWBCellNameOrangeColor : kWBCellNameNormalColor];
    
    _sourceLabel.attributedText = [self layoutSource];
    
    _contentLabel.attributedText = [self _textWithStatus:mode
                                               isRetweet:NO
                                                fontSize:kWBCellTextFontSize
                                               textColor:kWBCellTextNormalColor];
    
    [_retweetedNode addSubnode:_retweeted_contentLabel];
    _retweetedNode.backgroundColor = kWBCellBackgroundColor;
    
    if (mode.pics) {
        NSInteger pics = self.retweeted_pics.count;
        while (pics != mode.pics.count || pics < 0) {
            if (pics < mode.pics.count) {
                JTNetworkImageNode *imageNode = [[JTNetworkImageNode alloc] init];
                [self.retweeted_pics addObject:imageNode];
                pics++;
                [_retweetedNode addSubnode:imageNode];
            } else {
                [self.retweeted_pics removeLastObject];
                pics--;
            }
        }
        [mode.pics enumerateObjectsUsingBlock:^(WBPicture * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            JTNetworkImageNode *imageNode = self.retweeted_pics[idx];
            imageNode.style.preferredSize = CGSizeMake(obj.bmiddle.width, obj.bmiddle.height);
            NSLog(@"url = %@", obj.bmiddle.url);
            imageNode.URL = obj.large.url;
        }];
    }
    
    _retweeted_contentLabel.attributedText = [self _textWithStatus:mode
                                                         isRetweet:YES
                                                          fontSize:kWBCellTextFontRetweetSize
                                                         textColor:kWBCellTextSubTitleColor];
    
    __weak typeof(self) weakSelf = self;
    [_retweetedNode setLayoutSpecBlock:^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        ASStackLayoutSpec *h1;
        if (strongSelf.retweeted_pics.count != 0) {
            NSMutableArray *aa = @[].mutableCopy;
            [strongSelf.retweeted_pics enumerateObjectsUsingBlock:^(JTNetworkImageNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ASRatioLayoutSpec *ra = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:1. child:obj];
                [aa addObject:ra];
            }];
            h1 = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:10. justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:strongSelf.retweeted_pics];
            h1.flexWrap = ASStackLayoutFlexWrapWrap;
        }
        if (h1) {
            ASStackLayoutSpec *v1 = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:10. justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:@[strongSelf.retweeted_contentLabel, h1]];
            return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(kWBCellPadding, kWBCellPadding, kWBCellPadding, kWBCellPadding) child:v1];
        } else {
            return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(kWBCellPadding, kWBCellPadding, kWBCellPadding, kWBCellPadding) child:strongSelf.retweeted_contentLabel];
        }
    }];
    

    _retweetedButton.imageNode.image = [self findImageByName:@"timeline_icon_retweet"];
    _commentButton.imageNode.image = [self findImageByName:@"timeline_icon_comment"];
    _likeButton.imageNode.image = [self findImageByName:@"timeline_icon_unlike"];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    // <header
    // <user
    _sourceLabel.maximumNumberOfLines = 1;
    _nameLabel.maximumNumberOfLines = 1;
    _sourceLabel.style.flexShrink = 1.;
    _nameLabel.style.flexShrink = 1.;
    
    ASStackLayoutSpec *vStack1 = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:5. justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStart children:@[_nameLabel, _sourceLabel]];
    vStack1.style.flexShrink = 1.;
    
    ASStackLayoutSpec *user = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:kWBCellNamePaddingLeft justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[_avatarView, vStack1]];
    user.style.flexShrink = 1.;
    // </use
    
    ASStackLayoutSpec *vStack2 = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:kWBCellPaddingText justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:@[user, _contentLabel]];

    ASInsetLayoutSpec *header = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(kWBCellPadding, kWBCellPadding, kWBCellPadding, kWBCellPadding) child:vStack2];
    // </header
    
    // footer
    ASStackLayoutSpec *footer_hStack1 = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:5. justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsStart children:@[_retweetedButton, _commentButton, _likeButton]];
    footer_hStack1.style.flexShrink = 1.;
    
    self.retweetedNode.style.flexShrink = 1.;
    // content
    ASStackLayoutSpec *content = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:10. justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:@[header, self.retweetedNode, footer_hStack1]];
    
    return content;
}

- (UIImage *)findImageByName:(NSString *)imageName
{
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ResourceWeibo" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:path];
    });
    imageName = [imageName stringByAppendingString:[NSString stringWithFormat:@"/@%@x", @([UIScreen mainScreen].scale)]];
    NSString *path = [bundle pathForResource:imageName ofType:@"png"];
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

- (NSAttributedString *)attributedStringWithString:(NSString *)string font:(nullable UIFont *)font color:(nullable UIColor *)color
{
    if (!string) {
        return nil;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    if (!font) {
        font = [UIFont systemFontOfSize:16.];
    }
    if (string) {
        NSDictionary *attributes = @{
                                     NSForegroundColorAttributeName: color ? : [UIColor blackColor],
                                     NSFontAttributeName: font,
                                     };
        attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString addAttributes:attributes range:NSMakeRange(0, string.length)];
    }
    
    return attributedString;
}

- (NSAttributedString *)layoutSource
{
    WBStatus *mode = (WBStatus *)self.rowDescriptor.mode;
    
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
    });
    
    NSMutableAttributedString *sourceText = [NSMutableAttributedString new];
    NSString *createTime = [formatter stringFromDate:mode.createdAt];
    
    // 时间
    if (createTime.length) {
        NSMutableAttributedString *timeText = [[NSMutableAttributedString alloc] initWithString:createTime];
        [timeText yy_appendString:@"  "];
        timeText.yy_font = [UIFont systemFontOfSize:kWBCellSourceFontSize];
        timeText.yy_color = kWBCellTimeNormalColor;
        [sourceText appendAttributedString:timeText];
    }
    
    // 来自 XXX
    if (mode.source.length) {
        // <a href="sinaweibo://customweibosource" rel="nofollow">iPhone 5siPhone 5s</a>
        static NSRegularExpression *hrefRegex, *textRegex;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            hrefRegex = [NSRegularExpression regularExpressionWithPattern:@"(?<=href=\").+(?=\" )" options:kNilOptions error:NULL];
            textRegex = [NSRegularExpression regularExpressionWithPattern:@"(?<=>).+(?=<)" options:kNilOptions error:NULL];
        });
        NSTextCheckingResult *hrefResult, *textResult;
        NSString *href = nil, *text = nil;
        hrefResult = [hrefRegex firstMatchInString:mode.source options:kNilOptions range:NSMakeRange(0, mode.source.length)];
        textResult = [textRegex firstMatchInString:mode.source options:kNilOptions range:NSMakeRange(0, mode.source.length)];
        if (hrefResult && textResult && hrefResult.range.location != NSNotFound && textResult.range.location != NSNotFound) {
            href = [mode.source substringWithRange:hrefResult.range];
            text = [mode.source substringWithRange:textResult.range];
        }
        if (href.length && text.length) {
            NSMutableAttributedString *from = [NSMutableAttributedString new];
            [from yy_appendString:[NSString stringWithFormat:@"来自 %@", text]];
            from.yy_font = [UIFont systemFontOfSize:kWBCellSourceFontSize];
            from.yy_color = kWBCellTimeNormalColor;
            if (mode.sourceAllowClick > 0) {
                NSRange range = NSMakeRange(3, text.length);
                [from yy_setColor:kWBCellTextHighlightColor range:range];
                YYTextBackedString *backed = [YYTextBackedString stringWithString:href];
                [from yy_setTextBackedString:backed range:range];
                
                YYTextBorder *border = [YYTextBorder new];
                border.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
                border.fillColor = kWBCellTextHighlightBackgroundColor;
                border.cornerRadius = 3;
                YYTextHighlight *highlight = [YYTextHighlight new];
                if (href) highlight.userInfo = @{kWBLinkHrefName : href};
                [highlight setBackgroundBorder:border];
                [from yy_setTextHighlight:highlight range:range];
            }
            
            [sourceText appendAttributedString:from];
        }
    }
    return sourceText;
}

- (NSMutableAttributedString *)_textWithStatus:(WBStatus *)status
                                     isRetweet:(BOOL)isRetweet
                                      fontSize:(CGFloat)fontSize
                                     textColor:(UIColor *)textColor
{
    if (!status) return nil;
    
    NSMutableString *string = status.text.mutableCopy;
    if (string.length == 0) return nil;
    if (isRetweet) {
        NSString *name = status.user.name;
        if (name.length == 0) {
            name = status.user.screenName;
        }
        if (name) {
            NSString *insert = [NSString stringWithFormat:@"@%@:",name];
            [string insertString:insert atIndex:0];
        }
    }
    // 字体
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = kWBCellTextHighlightBackgroundColor;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    text.yy_font = font;
    text.yy_color = textColor;
    
    // 根据 urlStruct 中每个 URL.shortURL 来匹配文本，将其替换为图标+友好描述
    for (WBURL *wburl in status.urlStruct) {
        if (wburl.shortURL.length == 0) continue;
        if (wburl.urlTitle.length == 0) continue;
        NSString *urlTitle = wburl.urlTitle;
        if (urlTitle.length > 27) {
            urlTitle = [[urlTitle substringToIndex:27] stringByAppendingString:YYTextTruncationToken];
        }
        NSRange searchRange = NSMakeRange(0, text.string.length);
        do {
            NSRange range = [text.string rangeOfString:wburl.shortURL options:kNilOptions range:searchRange];
            if (range.location == NSNotFound) break;
            
            if (range.location + range.length == text.length) {
                if (status.pageInfo.pageID && wburl.pageID &&
                    [wburl.pageID isEqualToString:status.pageInfo.pageID]) {
                    if ((!isRetweet && !status.retweetedStatus) || isRetweet) {
                        if (status.pics.count == 0) {
                            [text replaceCharactersInRange:range withString:@""];
                            break; // cut the tail, show with card
                        }
                    }
                }
            }
            
            if ([text yy_attribute:YYTextHighlightAttributeName atIndex:range.location] == nil) {
                
                // 替换的内容
                NSMutableAttributedString *replace = [[NSMutableAttributedString alloc] initWithString:urlTitle];
                if (wburl.urlTypePic.length) {
                    // 链接头部有个图片附件 (要从网络获取)
                    NSURL *picURL = [self defaultURLForImageURL:wburl.urlTypePic];
                    NSAttributedString *pic = [self _attachmentWithFontSize:fontSize imageURL:wburl.urlTypePic shrink:YES];
                    [replace insertAttributedString:pic atIndex:0];
                }
                replace.yy_font = font;
                replace.yy_color = kWBCellTextHighlightColor;
                
                // 高亮状态
                YYTextHighlight *highlight = [YYTextHighlight new];
                [highlight setBackgroundBorder:highlightBorder];
                // 数据信息，用于稍后用户点击
                highlight.userInfo = @{kWBLinkURLName : wburl};
                [replace yy_setTextHighlight:highlight range:NSMakeRange(0, replace.length)];
                
                // 添加被替换的原始字符串，用于复制
                YYTextBackedString *backed = [YYTextBackedString stringWithString:[text.string substringWithRange:range]];
                [replace yy_setTextBackedString:backed range:NSMakeRange(0, replace.length)];
                
                // 替换
                [text replaceCharactersInRange:range withAttributedString:replace];
                
                searchRange.location = searchRange.location + (replace.length ? replace.length : 1);
                if (searchRange.location + 1 >= text.length) break;
                searchRange.length = text.length - searchRange.location;
            } else {
                searchRange.location = searchRange.location + (searchRange.length ? searchRange.length : 1);
                if (searchRange.location + 1>= text.length) break;
                searchRange.length = text.length - searchRange.location;
            }
        } while (1);
    }
    
    // 根据 topicStruct 中每个 Topic.topicTitle 来匹配文本，标记为话题
    for (WBTopic *topic in status.topicStruct) {
        if (topic.topicTitle.length == 0) continue;
        NSString *topicTitle = [NSString stringWithFormat:@"#%@#",topic.topicTitle];
        NSRange searchRange = NSMakeRange(0, text.string.length);
        do {
            NSRange range = [text.string rangeOfString:topicTitle options:kNilOptions range:searchRange];
            if (range.location == NSNotFound) break;
            
            if ([text yy_attribute:YYTextHighlightAttributeName atIndex:range.location] == nil) {
                [text yy_setColor:kWBCellTextHighlightColor range:range];
                
                // 高亮状态
                YYTextHighlight *highlight = [YYTextHighlight new];
                [highlight setBackgroundBorder:highlightBorder];
                // 数据信息，用于稍后用户点击
                highlight.userInfo = @{kWBLinkTopicName : topic};
                [text yy_setTextHighlight:highlight range:range];
            }
            searchRange.location = searchRange.location + (searchRange.length ? searchRange.length : 1);
            if (searchRange.location + 1>= text.length) break;
            searchRange.length = text.length - searchRange.location;
        } while (1);
    }
    
    // 匹配 @用户名
    NSArray *atResults = [[self regexAt] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
    for (NSTextCheckingResult *at in atResults) {
        if (at.range.location == NSNotFound && at.range.length <= 1) continue;
        if ([text yy_attribute:YYTextHighlightAttributeName atIndex:at.range.location] == nil) {
            [text yy_setColor:kWBCellTextHighlightColor range:at.range];
            
            // 高亮状态
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBackgroundBorder:highlightBorder];
            // 数据信息，用于稍后用户点击
            highlight.userInfo = @{kWBLinkAtName : [text.string substringWithRange:NSMakeRange(at.range.location + 1, at.range.length - 1)]};
            [text yy_setTextHighlight:highlight range:at.range];
        }
    }
    
    // 匹配 [表情]
    NSArray<NSTextCheckingResult *> *emoticonResults = [[self regexEmoticon] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
    NSUInteger emoClipLength = 0;
    for (NSTextCheckingResult *emo in emoticonResults) {
        if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
        NSRange range = emo.range;
        range.location -= emoClipLength;
        if ([text yy_attribute:YYTextHighlightAttributeName atIndex:range.location]) continue;
        if ([text yy_attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
        NSString *emoString = [text.string substringWithRange:range];
        NSString *imagePath = [self emoticonDic][emoString];
        UIImage *image = [self imageWithPath:imagePath];
        if (!image) continue;
        
        NSAttributedString *emoText = [NSAttributedString yy_attachmentStringWithEmojiImage:image fontSize:fontSize];
        [text replaceCharactersInRange:range withAttributedString:emoText];
        emoClipLength += range.length - 1;
    }
    
    return text;
}

- (NSURL *)defaultURLForImageURL:(id)imageURL {
    /*
     微博 API 提供的图片 URL 有时并不能直接用，需要做一些字符串替换：
     http://u1.sinaimg.cn/upload/2014/11/04/common_icon_membership_level6.png //input
     http://u1.sinaimg.cn/upload/2014/11/04/common_icon_membership_level6_default.png //output
     
     http://img.t.sinajs.cn/t6/skin/public/feed_cover/star_003_y.png?version=2015080302 //input
     http://img.t.sinajs.cn/t6/skin/public/feed_cover/star_003_os7.png?version=2015080302 //output
     */
    
    if (!imageURL) return nil;
    NSString *link = nil;
    if ([imageURL isKindOfClass:[NSURL class]]) {
        link = ((NSURL *)imageURL).absoluteString;
    } else if ([imageURL isKindOfClass:[NSString class]]) {
        link = imageURL;
    }
    if (link.length == 0) return nil;
    
    if ([link hasSuffix:@".png"]) {
        // add "_default"
        if (![link hasSuffix:@"_default.png"]) {
            NSString *sub = [link substringToIndex:link.length - 4];
            link = [sub stringByAppendingFormat:@"_default.png"];
        }
    } else {
        // replace "_y.png" with "_os7.png"
        NSRange range = [link rangeOfString:@"_y.png?version"];
        if (range.location != NSNotFound) {
            NSMutableString *mutable = link.mutableCopy;
            [mutable replaceCharactersInRange:NSMakeRange(range.location + 1, 1) withString:@"os7"];
            link = mutable;
        }
    }
    
    return [NSURL URLWithString:link];
}

- (NSAttributedString *)_attachmentWithFontSize:(CGFloat)fontSize imageURL:(NSString *)imageURL shrink:(BOOL)shrink {
    /*
     微博 URL 嵌入的图片，比临近的字体要小一圈。。
     这里模拟一下 Heiti SC 字体，然后把图片缩小一下。
     */
    CGFloat ascent = fontSize * 0.86;
    CGFloat descent = fontSize * 0.14;
    CGRect bounding = CGRectMake(0, -0.14 * fontSize, fontSize, fontSize);
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(ascent - (bounding.size.height + bounding.origin.y), 0, descent + bounding.origin.y, 0);
    CGSize size = CGSizeMake(fontSize, fontSize);
    
    if (shrink) {
        // 缩小~
        CGFloat scale = 1 / 10.0;
        contentInsets.top += fontSize * scale;
        contentInsets.bottom += fontSize * scale;
        contentInsets.left += fontSize * scale;
        contentInsets.right += fontSize * scale;
        contentInsets = UIEdgeInsetPixelFloor(contentInsets);
        size = CGSizeMake(fontSize - fontSize * scale * 2, fontSize - fontSize * scale * 2);
        size = CGSizePixelRound(size);
    }
    
    YYTextRunDelegate *delegate = [YYTextRunDelegate new];
    delegate.ascent = ascent;
    delegate.descent = descent;
    delegate.width = bounding.size.width;
    
    WBTextImageViewAttachment *attachment = [WBTextImageViewAttachment new];
    attachment.contentMode = UIViewContentModeScaleAspectFit;
    attachment.contentInsets = contentInsets;
    attachment.size = size;
    attachment.imageURL = [self defaultURLForImageURL:imageURL];
    
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    [atr yy_setTextAttachment:attachment range:NSMakeRange(0, atr.length)];
    CTRunDelegateRef ctDelegate = delegate.CTRunDelegate;
    [atr yy_setRunDelegate:ctDelegate range:NSMakeRange(0, atr.length)];
    if (ctDelegate) CFRelease(ctDelegate);
    
    return atr;
}

- (NSRegularExpression *)regexAt {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 微博的 At 只允许 英文数字下划线连字符，和 unicode 4E00~9FA5 范围内的中文字符，这里保持和微博一致。。
        // 目前中文字符范围比这个大
        regex = [NSRegularExpression regularExpressionWithPattern:@"@[-_a-zA-Z0-9\u4E00-\u9FA5]+" options:kNilOptions error:NULL];
    });
    return regex;
}

- (NSRegularExpression *)regexEmoticon {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[[^ \\[\\]]+?\\]" options:kNilOptions error:NULL];
    });
    return regex;
}

- (NSDictionary *)emoticonDic {
    static NSMutableDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *emoticonBundlePath = [[NSBundle mainBundle] pathForResource:@"EmoticonWeibo" ofType:@"bundle"];
        dic = [self _emoticonDicFromPath:emoticonBundlePath];
    });
    return dic;
}

- (UIImage *)imageWithPath:(NSString *)path {
    if (!path) return nil;
    UIImage *image;
    if ([self pathScale:path] == 1) {
        // 查找 @2x @3x 的图片
        NSArray *scales = [self preferredScales];
        for (NSNumber *scale in scales) {
            image = [UIImage imageWithContentsOfFile:[self stringByAppendingPathScale:scale.floatValue string:path]];
            if (image) break;
        }
    } else {
        image = [UIImage imageWithContentsOfFile:path];
    }
    return image;
}

- (NSString *)stringByAppendingPathScale:(CGFloat)scale string:(NSString *)string {
    if (fabs(scale - 1) <= __FLT_EPSILON__ || string.length == 0 || [string hasSuffix:@"/"]) return string.copy;
    NSString *ext = string.pathExtension;
    NSRange extRange = NSMakeRange(string.length - ext.length, 0);
    if (ext.length > 0) extRange.location -= 1;
    NSString *scaleStr = [NSString stringWithFormat:@"@%@x", @(scale)];
    return [string stringByReplacingCharactersInRange:extRange withString:scaleStr];
}

- (CGFloat)pathScale:(NSString *)string
{
    if (string.length == 0 || [string hasSuffix:@"/"]) return 1;
    NSString *name = string.stringByDeletingPathExtension;
    __block CGFloat scale = 1;
    [self enumerateRegexMatches:@"@[0-9]+\\.?[0-9]*x$" string:name options:NSRegularExpressionAnchorsMatchLines usingBlock: ^(NSString *match, NSRange matchRange, BOOL *stop) {
        scale = [match substringWithRange:NSMakeRange(1, match.length - 2)].doubleValue;
    }];
    return scale;
}

- (void)enumerateRegexMatches:(NSString *)regex
                       string:(NSString *)string
                      options:(NSRegularExpressionOptions)options
                   usingBlock:(void (^)(NSString *match, NSRange matchRange, BOOL *stop))block {
    if (regex.length == 0 || !block) return;
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:nil];
    if (!regex) return;
    [pattern enumerateMatchesInString:string options:kNilOptions range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        block([string substringWithRange:result.range], result.range, stop);
    }];
}

- (NSArray *)preferredScales {
    static NSArray *scales;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat screenScale = [UIScreen mainScreen].scale;
        if (screenScale <= 1) {
            scales = @[@1,@2,@3];
        } else if (screenScale <= 2) {
            scales = @[@2,@3,@1];
        } else {
            scales = @[@3,@2,@1];
        }
    });
    return scales;
}

// floor UIEdgeInset for pixel-aligned
static inline UIEdgeInsets UIEdgeInsetPixelFloor(UIEdgeInsets insets) {
    insets.top = CGFloatPixelFloor(insets.top);
    insets.left = CGFloatPixelFloor(insets.left);
    insets.bottom = CGFloatPixelFloor(insets.bottom);
    insets.right = CGFloatPixelFloor(insets.right);
    return insets;
}

static inline CGFloat CGFloatPixelFloor(CGFloat value) {
    CGFloat scale = YYScreenScale();
    return floor(value * scale) / scale;
}

CGFloat YYScreenScale() {
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    return scale;
}

static inline CGSize CGSizePixelRound(CGSize size) {
    CGFloat scale = YYScreenScale();
    return CGSizeMake(round(size.width * scale) / scale,
                      round(size.height * scale) / scale);
}

- (NSMutableDictionary *)_emoticonDicFromPath:(NSString *)path {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    WBEmoticonGroup *group = nil;
    NSString *jsonPath = [path stringByAppendingPathComponent:@"info.json"];
    NSData *json = [NSData dataWithContentsOfFile:jsonPath];
    if (json.length) {
        group = [WBEmoticonGroup modelWithJSON:json];
    }
    if (!group) {
        NSString *plistPath = [path stringByAppendingPathComponent:@"info.plist"];
        NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        if (plist.count) {
            group = [WBEmoticonGroup modelWithJSON:plist];
        }
    }
    for (WBEmoticon *emoticon in group.emoticons) {
        if (emoticon.png.length == 0) continue;
        NSString *pngPath = [path stringByAppendingPathComponent:emoticon.png];
        if (emoticon.chs) dic[emoticon.chs] = pngPath;
        if (emoticon.cht) dic[emoticon.cht] = pngPath;
    }
    
    NSArray *folders = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    for (NSString *folder in folders) {
        if (folder.length == 0) continue;
        NSDictionary *subDic = [self _emoticonDicFromPath:[path stringByAppendingPathComponent:folder]];
        if (subDic) {
            [dic addEntriesFromDictionary:subDic];
        }
    }
    return dic;
}
@end
