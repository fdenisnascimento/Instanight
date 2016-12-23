//
//  Extras.h
//  Badaloo
//
//  Created by Denis Nascimento on 2/12/15.
//  Copyright (c) 2015 Denis Nascimento. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIImage (Extras)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end