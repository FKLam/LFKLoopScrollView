//
//  ViewController.m
//  LFKLoopScrollView
//
//  Created by kun on 16/8/6.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "ViewController.h"
#import "LFKLoopScrollView.h"

#define __LOADIMAGE(file, type) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:type]]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LFKLoopScrollView *loopScrollView = [[LFKLoopScrollView alloc] initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 240) intailTime:2.5 imageArray:[self loadData] didClickBlock:^(NSIndexPath *indexPath, UIImage *image) {
        NSLog(@"%@", indexPath);
    }];
    [self.view addSubview:loopScrollView];
}

// Demo 数据
- (NSArray *)loadData {
    NSArray *array = @[__LOADIMAGE(@"dota2_0", @"jpg"),
                       __LOADIMAGE(@"dota2_1", @"jpg"),
                       __LOADIMAGE(@"dota2_2", @"jpg"),
                       __LOADIMAGE(@"dota2_3", @"jpg")];
    return array;
}
@end
