//
//  UIImage+HETJPGAdditions.m
//  CLife
//
//  Created by JiangJun on 15/7/21.
//  Copyright (c) 2015年 HET. All rights reserved.
//

#import "UIImage+HETJPGAdditions.h"

@implementation UIImage (HETJPGAdditions)
+ (UIImage*) jgcLoadPNGorJPGImageWithName:(NSString*)name {
    
    UIImage * value;
    NSString *path = [[NSBundle mainBundle] pathForResource:[name stringByDeletingPathExtension] ofType:[name pathExtension]];
    if (!path) {
        
        NSString *scale = @"";
        
        if ((NSUInteger)[UIScreen mainScreen].scale == 2){
            
            scale = @"@2x";
        }
        else if ((NSUInteger)[UIScreen mainScreen].scale == 3){
            scale = @"@3x";
        }
        
        
        path = [[NSBundle mainBundle] pathForResource:[[name stringByDeletingPathExtension] stringByAppendingString: scale] ofType:[name pathExtension]];
    }
    
    if (path) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        value = [UIImage imageWithData: data];
    }

    return value;
}
@end
