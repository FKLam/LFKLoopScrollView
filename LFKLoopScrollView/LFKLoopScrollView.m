//
//  LFKLoopScrollView.m
//  LFKLoopScrollView
//
//  Created by kun on 16/8/6.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "LFKLoopScrollView.h"
#import "LFKLoopScrollViewCell.h"

static NSString *cellIdentify = @"cellIdentify";

@interface LFKLoopScrollView () <UICollectionViewDelegate, UICollectionViewDataSource>
/**
 *  显示图片的容器view
 */
@property (nonatomic, strong) UICollectionView *contentCollectionView;
/**
 *  容器的瀑布流显示方式
 */
@property (nonatomic, strong) UICollectionViewFlowLayout *contentLayout;
@property (nonatomic, strong) UIPageControl *pageControl;
/**
 *  定时器
 */
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, weak) LFKLoopScrollViewClickBlock didClickBlock;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) CGFloat intailTime;
@end

@implementation LFKLoopScrollView

- (instancetype)initWithFrame:(CGRect)frame intailTime:(CGFloat)intailTime imageArray:(NSArray *)imageArray didClickBlock:(LFKLoopScrollViewClickBlock)didClickBlock {
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self addSubview:self.contentCollectionView];
        [self addSubview:self.pageControl];
        _imageArray = [self reSetImageArray:imageArray];
        _didClickBlock = didClickBlock;
        self.pageControl.numberOfPages = _imageArray.count - 2;
        _currentPage = 1;
        _intailTime = intailTime;
        [_contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        [self loadTimer];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LFKLoopScrollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentify forIndexPath:indexPath];
    UIImage *image = self.imageArray[indexPath.item];
    cell.image = image;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.didClickBlock )
    {
        self.didClickBlock(indexPath, self.imageArray[indexPath.item]);
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self reloadItemAction:scrollView];
    [self loadTimer];
}
/**
 *  拖拽停止后，对特殊情况做些处理
 *
 *  @param scrollView 当前图片滚动的view
 */
- (void)reloadItemAction:(UIScrollView *)scrollView {
    // 计算scrollView的偏移量，并赋值给记录显示当前页面的变量
    self.currentPage = scrollView.contentOffset.x / ([UIScreen mainScreen].bounds.size.width);
    NSInteger toItem = 0;
    // 如果偏移量为0，就是在第0张图片上，迅速无动画地显示倒数第2张
    if ( self.currentPage == 0 ) {
        toItem = self.imageArray.count - 2;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:toItem inSection:0];
        [self.contentCollectionView scrollToItemAtIndexPath:indexPath
                                            atScrollPosition:UICollectionViewScrollPositionNone
                                                    animated:NO];
        self.currentPage = toItem;
    }
    // 如果是最后一张，就是显示第1张
    else if (self.currentPage == self.imageArray.count - 1) {
        toItem = 1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:toItem inSection:0];
        [self.contentCollectionView scrollToItemAtIndexPath:indexPath
                                            atScrollPosition:UICollectionViewScrollPositionNone
                                                    animated:NO];
        self.currentPage = toItem;
    }
    // 更新页面控件的当前点
    self.pageControl.currentPage = self.currentPage - 0.5;
}
- (NSArray *)reSetImageArray:(NSArray *)imageArray
{
    if ( nil == imageArray || 0 == [imageArray count] )
        return nil;
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:imageArray];
    [tempArray addObject:imageArray.firstObject];
    [tempArray insertObject:imageArray.lastObject atIndex:0];
    return tempArray;
}
- (void)loadTimer
{
    if ( !self.timer )
    {
        [self.timer invalidate];
        self.timer = [NSTimer timerWithTimeInterval:self.intailTime target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}
/**
 *  下一张图片
 */
- (void)timeChange
{
    // 已经显示了倒数第2张
    if ( self.currentPage == self.imageArray.count - 2 )
    {
        // 迅速切换到第0张
        NSInteger toItem = 0;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:toItem inSection:0];
        [self.contentCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        self.currentPage = toItem;
    }
    // 动画滚动到第1张
    self.currentPage++;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentPage inSection:0];
    [self.contentCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    // 更新页面控制器的当前选择点
    self.pageControl.currentPage = self.currentPage - 1;
}
- (UICollectionView *)contentCollectionView
{
    if ( !_contentCollectionView )
    {
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.contentLayout];
        _contentCollectionView.dataSource = self;
        _contentCollectionView.delegate = self;
        [_contentCollectionView registerClass:[LFKLoopScrollViewCell class] forCellWithReuseIdentifier:cellIdentify];
        [_contentCollectionView setBackgroundColor:[UIColor whiteColor]];
        _contentCollectionView.showsVerticalScrollIndicator = NO;
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        _contentCollectionView.pagingEnabled = YES;
        _contentCollectionView.bounces = NO;
        _contentCollectionView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
    }
    return _contentCollectionView;
}
- (UICollectionViewFlowLayout *)contentLayout
{
    if ( !_contentLayout )
    {
        _contentLayout = [[UICollectionViewFlowLayout alloc] init];
        _contentLayout.itemSize = self.bounds.size;
        _contentLayout.minimumLineSpacing = 0;
        _contentLayout.minimumInteritemSpacing = 0;
        _contentLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _contentLayout;
}
- (UIPageControl *)pageControl
{
    if ( !_pageControl )
    {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 100) / 2.0, self.bounds.size.height - 40, 100, 40)];
        _pageControl.pageIndicatorTintColor = [UIColor purpleColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}
@end
