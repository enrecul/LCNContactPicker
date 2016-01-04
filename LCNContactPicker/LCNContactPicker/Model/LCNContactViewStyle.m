//
//  LCNContactViewStyle.m
//  LCNContactPicker
//
//  Created by 黄春涛 on 16/1/4.
//  Copyright © 2016年 黄春涛. All rights reserved.
//

#import "LCNContactViewStyle.h"
#define BACKGROUND_COLOR [UIColor colorWithRed:0.9 green:0.91 blue:0.925 alpha:1]


@implementation LCNContactViewStyle

- (instancetype)initWithTextColor:(UIColor *)textColor
                         fontSize:(NSInteger)fontSize
                  backgroundColor:(UIColor *)backgroundColor
                      borderColor:(UIColor *)borderColor
                      borderWidth:(CGFloat)borderWidth
                     cornerRadius:(CGFloat)cornerRadius{
    
    if (self = [super init]) {
        _textColor = textColor;
        _fontSize = fontSize;
        _backgroundColor = backgroundColor;
        _borderColor = borderColor;
        _borderWidth = borderWidth;
        _cornerRadius = cornerRadius;
    }
    return self;
}

+ (instancetype) defaultStyle{
    LCNContactViewStyle *style = [LCNContactViewStyle new];
    style.textColor = [UIColor blackColor];
    style.fontSize = [UIFont systemFontSize];
    style.backgroundColor = BACKGROUND_COLOR;
    
    style.borderColor = BACKGROUND_COLOR;
    style.borderWidth = 0;
    style.cornerRadius = 5;
    
    return style;
    
}

+ (instancetype) defaultSelectedStyle{
    LCNContactViewStyle *style = [LCNContactViewStyle new];
    style.textColor = BACKGROUND_COLOR;
    style.fontSize = [UIFont systemFontSize];
    style.backgroundColor = [UIColor blackColor];
    
    style.borderColor = BACKGROUND_COLOR;
    style.borderWidth = 1;
    style.cornerRadius = 5;
    
    return style;
}

@end
