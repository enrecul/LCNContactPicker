//
//  LCNTextField.m
//  LCNContactPicker
//
//  Created by 黄春涛 on 16/1/4.
//  Copyright © 2016年 黄春涛. All rights reserved.
//

#import "LCNTextField.h"
#import "LCNContactModel.h"

@interface LCNTextField ()

@end

@implementation LCNTextField

@dynamic delegate;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)textFieldTextDidChanged:(NSNotification *)notification{
    if (notification.object == self) {
        if ([self.delegate respondsToSelector:@selector(LCNTextFieldDidChange:)]) {
            [self.delegate LCNTextFieldDidChange:self];
        }
    }
}

-(void)deleteBackward{
    //text为空时，回删
    if (self.text.length == 0) {
        if ([self.delegate respondsToSelector:@selector(LCNTextfieldDeleteBackwardWithEmpty:)]) {
            [self.delegate LCNTextfieldDeleteBackwardWithEmpty:self];
        }
    }
    [super deleteBackward];
}

@end
