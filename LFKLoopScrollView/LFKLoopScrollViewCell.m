//
//  LFKLoopScrollViewCell.m
//  LFKLoopScrollView
//
//  Created by kun on 16/8/6.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "LFKLoopScrollViewCell.h"

@interface LFKLoopScrollViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end
@implementation LFKLoopScrollViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if ( self )
    {
        [self.contentView addSubview:self.imageView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self.contentView addSubview:self.imageView];
    }
    return self;
}
- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    [self layoutIfNeeded];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}

- (UIImageView *)imageView
{
    if ( !_imageView )
    {
        _imageView = [[UIImageView alloc] init];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _imageView;
}
@end
