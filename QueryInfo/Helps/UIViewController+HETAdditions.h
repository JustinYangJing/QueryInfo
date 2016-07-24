//
//  UIViewController+HETAdditions.h
//  CLife
//
//  Created by JiangJun on 15/6/6.
//  Copyright (c) 2015年 HET. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BPushCallBack)(id result, NSError *error);
@interface UIViewController (HETAdditions)

- (void)transparentNavigationBar;
- (void)opaqueNavigationBar;

@end
