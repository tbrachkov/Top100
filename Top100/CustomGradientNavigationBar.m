//
//  CustomGradientNavigationBar.m
//  Top100
//
//  Created by Todor Brachkov on 2/12/15.
//  Copyright (c) 2015 Todor Brachkov. All rights reserved.
//


#import "CustomGradientNavigationBar.h"
#import <QuartzCore/QuartzCore.h>

@interface CustomGradientNavigationBar ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation CustomGradientNavigationBar

static CGFloat const kDefaultOpacity = 0.5f;

- (void)setBarTintGradientColors:(NSArray *)barTintGradientColors
{
    if (self.gradientLayer == nil)
    {
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.opacity = self.translucent ? kDefaultOpacity : 1.0f;
    }
    
    NSMutableArray * colors = nil;
    if (barTintGradientColors != nil)
    {
        colors = [NSMutableArray arrayWithCapacity:[barTintGradientColors count]];
        
        
        [barTintGradientColors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
            if ([obj isKindOfClass:[UIColor class]])
            {
                [colors addObject:(id)[obj CGColor]];
            }
            else if ( CFGetTypeID( (__bridge void *)obj ) == CGColorGetTypeID() )
            {
                [colors addObject:obj];
            }
            else
            {
                @throw [NSException exceptionWithName:@"BarTintGraidentColorsError" reason:@"object in barTintGradientColors array is not a UIColor or CGColorRef" userInfo:nil];
            }
        }];
        
        if ( [self respondsToSelector:@selector(setBarTintColor:)] )
        {
            // iOS 7
            self.barTintColor = [UIColor lightGrayColor];
        }
        else
        {
            // iOS 6
            self.tintColor = [UIColor lightGrayColor];
            
            [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        }
    }
    
    self.gradientLayer.colors = colors;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ( self.gradientLayer != nil )
    {
        if ( floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 )
        {
            self.gradientLayer.startPoint = CGPointMake(0.0, 0.5);
            self.gradientLayer.endPoint = CGPointMake(1.0, 0.5);
            
            CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
            self.gradientLayer.frame = CGRectMake(0, 0 - statusBarHeight, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + statusBarHeight);
        }
        else
        {
            self.gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        }
        
        [self.layer insertSublayer:self.gradientLayer atIndex:1];
    }
}


@end