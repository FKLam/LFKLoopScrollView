//
//  LFKLoopScrollView.h
//  LFKLoopScrollView
//
//  Created by kun on 16/8/6.
//  Copyright © 2016年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LFKLoopScrollViewClickBlock)(NSIndexPath *indexPath, UIImage *image);

@interface LFKLoopScrollView : UIView
- (instancetype)initWithFrame:(CGRect)frame intailTime:(CGFloat)intailTime imageArray:(NSArray *)imageArray didClickBlock:(LFKLoopScrollViewClickBlock)didClickBlock;
@end
