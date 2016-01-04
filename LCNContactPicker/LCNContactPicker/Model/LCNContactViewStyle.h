//
//  LCNContactViewStyle.h
//  LCNContactPicker
//
//  Created by 黄春涛 on 16/1/4.
//  Copyright © 2016年 黄春涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LCNContactViewStyle : NSObject

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) NSInteger fontSize;
@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat cornerRadius;

- (instancetype)initWithTextColor:(UIColor *)textColor
                         fontSize:(NSInteger)fontSize
                  backgroundColor:(UIColor *)backgroundColor
                      borderColor:(UIColor *)borderColor
                      borderWidth:(CGFloat)borderWidth
                     cornerRadius:(CGFloat)cornerRadius;

+ (instancetype) defaultStyle;

+ (instancetype) defaultSelectedStyle;

@end
