//
//  HETActionSheet.h
//  HETPublicSDK_Core
//
//  Created by tl on 16/2/27.
//  Copyright © 2016年 HET. All rights reserved.
// 

#import <UIKit/UIKit.h>

@interface HETActionSheet : UIView

+(instancetype)sheetCancelTitile:(NSString *)cancelTitle otherTitles:(NSArray<NSString *> *)titles;

-(void)showInView:(UIView *)view click:(void (^)(NSInteger index))click;
@end
