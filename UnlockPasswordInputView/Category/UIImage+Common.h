//
//  UIImage+Common.h
//  Tristan
//
//  Created by Tristan on 16/8/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Common)

+ (UIImage *) imageCircleWithColor: (UIColor *) color frame:(CGRect)aFrame;
+(UIImage *)imageWithColor:(UIColor *)aColor;
+(UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame;
-(UIImage*)scaledToSize:(CGSize)targetSize;
-(UIImage*)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality;

- (UIImage *)roundedCornerImageWithCornerRadius:(CGFloat)cornerRadius;

#pragma mark 返回拉伸好的图片
+ (UIImage *)resizeImage:(NSString *)imgName;

- (UIImage *)resizeImage;

+(UIImage *) imagePathed:(NSString*)imageName;

@end
