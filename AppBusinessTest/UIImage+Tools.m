//
//  UIImage+Tools.m
//  AppBusinessTest
//
//  Created by paul calver on 23/04/2014.
//  Copyright (c) 2014 paul calver. All rights reserved.
//

#import "UIImage+Tools.h"

@implementation UIImage (Tools)

+ (UIImage *)resizeImage:(UIImage *)orginalImage resizeSize:(CGSize)size
{
	CGFloat actualHeight = orginalImage.size.height;
	CGFloat actualWidth = orginalImage.size.width;
	if(actualWidth <= size.width && actualHeight<=size.height)
	{
		return orginalImage;
	}
	float oldRatio = actualWidth/actualHeight;
	float newRatio = size.width/size.height;
	if(oldRatio < newRatio)
	{
		oldRatio = size.height/actualHeight;
		actualWidth = oldRatio * actualWidth;
		actualHeight = size.height;
	}
	else
	{
		oldRatio = size.width/actualWidth;
		actualHeight = oldRatio * actualHeight;
		actualWidth = size.width;
	}
	CGRect rect = CGRectMake(0.0,0.0,actualWidth,actualHeight);
	UIGraphicsBeginImageContext(rect.size);
	[orginalImage drawInRect:rect];
	orginalImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return orginalImage;
}

@end
