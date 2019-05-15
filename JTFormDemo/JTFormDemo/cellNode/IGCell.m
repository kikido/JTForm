//
//  IGCell.m
//  JTForm
//
//  Created by dqh on 2019/5/9.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "IGCell.h"
#import "PhotoModel.h"
#import "UIImage+JTFormAdd.h"

#define HEADER_HEIGHT           50
#define USER_IMAGE_HEIGHT       30
#define HORIZONTAL_BUFFER       10
#define VERTICAL_BUFFER         5
#define FONT_SIZE               14

#define InsetForAvatar UIEdgeInsetsMake(HORIZONTAL_BUFFER, 0, HORIZONTAL_BUFFER, HORIZONTAL_BUFFER)
#define InsetForHeader UIEdgeInsetsMake(0, HORIZONTAL_BUFFER, 0, HORIZONTAL_BUFFER)
#define InsetForFooter UIEdgeInsetsMake(VERTICAL_BUFFER, HORIZONTAL_BUFFER, VERTICAL_BUFFER, HORIZONTAL_BUFFER)

NSString *const JTFormRowTypeIGCell = @"JTFormRowTypeIGCell";

@implementation IGCell
{
    JTNetworkImageNode  *_userAvatarImageNode;
    JTNetworkImageNode  *_photoImageNode;
    ASTextNode          *_userNameLabel;
    ASTextNode          *_photoLocationLabel;
    ASTextNode          *_photoTimeIntervalSincePostLabel;
    ASTextNode          *_photoLikesLabel;
    ASTextNode          *_photoDescriptionLabel;
}

+ (void)load
{
    [[JTForm cellClassesForRowTypes] setObject:self forKey:JTFormRowTypeIGCell];
}

- (void)config
{
    [super config];
    _userAvatarImageNode     = [[JTNetworkImageNode alloc] init];
    [_userAvatarImageNode setImageModificationBlock:^UIImage *(UIImage *image) {
        return [image makeCircularImageWithSize:CGSizeMake(USER_IMAGE_HEIGHT, USER_IMAGE_HEIGHT)];
    }];
    
    _photoImageNode          = [[JTNetworkImageNode alloc] init];
    _photoImageNode.layerBacked = YES;
    
    _userNameLabel                  = [[ASTextNode alloc] init];
    
    _photoLocationLabel      = [[ASTextNode alloc] init];
    _photoLocationLabel.maximumNumberOfLines = 1;
    
    _photoTimeIntervalSincePostLabel      = [[ASTextNode alloc] init];
    _photoTimeIntervalSincePostLabel.layerBacked      = YES;
    
    _photoLikesLabel      = [[ASTextNode alloc] init];
    _photoLikesLabel.layerBacked      = YES;
    
    _photoDescriptionLabel      = [[ASTextNode alloc] init];
    _photoDescriptionLabel.layerBacked      = YES;
    _photoDescriptionLabel.maximumNumberOfLines = 3;

}

- (void)update
{
    [super update];
    
    PhotoModel *mode = (PhotoModel *)self.rowDescriptor.mode;
    
    _userAvatarImageNode.URL = mode.ownerUserProfile.userPicURL;
    _photoImageNode.URL      = mode.URL;

    _userNameLabel.attributedText = [NSAttributedString attributedStringWithString:mode.ownerUserProfile.username font:[UIFont systemFontOfSize:14.] color:[UIColor blackColor] firstWordColor:nil];
    _photoLocationLabel.attributedText = [NSAttributedString attributedStringWithString:mode.location font:[UIFont systemFontOfSize:14.] color:[UIColor blackColor] firstWordColor:nil];
    
    _photoTimeIntervalSincePostLabel.attributedText = [NSAttributedString attributedStringWithString:mode.uploadDateString font:[UIFont systemFontOfSize:14.] color:[UIColor blackColor] firstWordColor:nil];
    _photoLikesLabel.attributedText = [NSAttributedString attributedStringWithString:[NSString stringWithFormat:@"♥︎ %lu likes", (unsigned long)mode.likesCount] font:[UIFont systemFontOfSize:14.] color:[UIColor blackColor] firstWordColor:nil];
    _photoDescriptionLabel.attributedText = [NSAttributedString attributedStringWithString:[NSString stringWithFormat:@"%@ %@", mode.ownerUserProfile.username, mode.descriptionText] font:[UIFont systemFontOfSize:14.] color:[UIColor blackColor] firstWordColor:nil];
    
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    NSMutableArray *headerChildren = [NSMutableArray array];
    NSMutableArray *verticalChildren = [NSMutableArray array];
    
    // Header
    ASStackLayoutSpec *headerStack = [ASStackLayoutSpec horizontalStackLayoutSpec];
    headerStack.alignItems = ASStackLayoutAlignItemsCenter;
    
    // Avatar Image, with inset - first thing in the header stack.
    _userAvatarImageNode.style.preferredSize = CGSizeMake(USER_IMAGE_HEIGHT, USER_IMAGE_HEIGHT);
    [headerChildren addObject:[ASInsetLayoutSpec insetLayoutSpecWithInsets:InsetForAvatar child:_userAvatarImageNode]];
    
    // 用户名 User Name and Photo Location stack is next
    ASStackLayoutSpec *userPhotoLocationStack = [ASStackLayoutSpec verticalStackLayoutSpec];
    userPhotoLocationStack.style.flexShrink = 1.0;
    [headerChildren addObject:userPhotoLocationStack];
    
    // Setup the inside of the User Name and Photo Location stack.
    _userNameLabel.style.flexShrink = 1.0;
    [userPhotoLocationStack setChildren:@[_userNameLabel]];
    
    if (_photoLocationLabel.attributedText) {
        _photoLocationLabel.style.flexShrink = 1.0;
        [userPhotoLocationStack setChildren:[userPhotoLocationStack.children arrayByAddingObject:_photoLocationLabel]];
    }
    
    // Add a spacer to allow a flexible space between the User Name / Location stack, and the Timestamp.
    ASLayoutSpec *spacer = [ASLayoutSpec new];
    spacer.style.flexGrow = 1.0;
    [headerChildren addObject:spacer];
    
    // Photo Timestamp Label.
    _photoTimeIntervalSincePostLabel.style.spacingBefore = HORIZONTAL_BUFFER;
    [headerChildren addObject:_photoTimeIntervalSincePostLabel];
    
    // Add all of the above items to the horizontal header stack
    headerStack.children = headerChildren;
    
    // Create the last stack before assembling everything: the Footer Stack contains the description and comments.
    ASStackLayoutSpec *footerStack = [ASStackLayoutSpec verticalStackLayoutSpec];
    footerStack.spacing = VERTICAL_BUFFER;
    footerStack.children = @[_photoLikesLabel, _photoDescriptionLabel];
    
    // Main Vertical Stack: contains header, large main photo with fixed aspect ratio, and footer.
    ASStackLayoutSpec *verticalStack = [ASStackLayoutSpec verticalStackLayoutSpec];
    
    [verticalChildren addObject:[ASInsetLayoutSpec insetLayoutSpecWithInsets:InsetForHeader child:headerStack]];
    [verticalChildren addObject:[ASRatioLayoutSpec ratioLayoutSpecWithRatio :1.0            child:_photoImageNode]];
    [verticalChildren addObject:[ASInsetLayoutSpec insetLayoutSpecWithInsets:InsetForFooter child:footerStack]];
    
    verticalStack.children = verticalChildren;
    
    return verticalStack;
}

@end
