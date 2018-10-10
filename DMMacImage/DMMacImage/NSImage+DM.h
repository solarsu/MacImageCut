//
//  NSImage+DM.h
//  DMMacImage
//
//  Created by lbq on 2018/4/23.
//  Copyright © 2018年 lbq. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (DM)

/**
 类似UIImage contentMode 的AspectFit 的效果
 
 @param targetSize 目标限定区域
 @param transparent 带有透明背景 YES时 图片的size == targetsize 带有透明背景
 NO 时 图片的size不一定等于targetsize 不会带多余的透明背景
 @return 裁剪后的图片
 */
- (NSImage *)scaleAspectFitToSize:(CGSize)targetSize transparent:(BOOL)transparent;

/**
 类似UIImage contentMode 的AspectFill 的效果
 
 @param targetSize 目标限定区域
 @param clipsToBounds 返回的图片是否是裁剪过后的
 @return 裁剪后的图片
 */
- (NSImage *)scaleAspectFillToSize:(CGSize)targetSize clipsToBounds:(BOOL)clipsToBounds;

- (NSImage *)scaleAspectFillToSize:(CGRect)corpRect;
@end
