//
//  ContactView.m
//  LCNContactPicker
//
//  Created by 黄春涛 on 15/12/31.
//  Copyright © 2015年 黄春涛. All rights reserved.
//

#import "LCNContactView.h"
#import "LCNContactModel.h"

#define BACKGROUND_COLOR [UIColor colorWithRed:0.9 green:0.91 blue:0.925 alpha:1]

static const CGFloat kHorizontalPadding = 3;
static const CGFloat kVerticalPadding = 3;

@interface LCNContactView()

@property (nonatomic, assign) CGFloat MaxWidth;//最大限制宽度
@property (nonatomic, assign) CGFloat MinWidth;//最小限制宽度

@property (nonatomic, strong) LCNContactViewStyle *defaultStyle;
@property (nonatomic, strong) LCNContactViewStyle *defaultSelectedStyle;

@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UIButton *tagBtn;

@end

@implementation LCNContactView


- (instancetype)initWithContactModel:(LCNContactModel *)model{
    return [self initWithContactModel:model
                      defaultStyle:[LCNContactViewStyle defaultStyle]
              defaultSelectedStyle:[LCNContactViewStyle defaultSelectedStyle]];
}

- (instancetype)initWithContactModel:(LCNContactModel *)model defaultStyle:(LCNContactViewStyle *)style defaultSelectedStyle:(LCNContactViewStyle *)selectedStyle{
    self = [super init];
    if (self) {
        _model = model;
        _defaultStyle = style;
        _defaultSelectedStyle = selectedStyle;
        [self setup];
    }
    return self;
}

-(void)setup{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContactView)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
    
    _MaxWidth = [UIScreen mainScreen].bounds.size.width/2;
    _MinWidth = 2 * kHorizontalPadding + 20;
    
    _tagLabel = [UILabel new];
    _tagLabel.numberOfLines = 1;
    _tagLabel.backgroundColor = [UIColor clearColor];
    _tagLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _tagLabel.textAlignment = NSTextAlignmentCenter;
    _tagLabel.text = _model.contactName;
    
    _tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tagBtn setBackgroundColor:[UIColor clearColor]];
    [_tagBtn setTitle:@"✕" forState:UIControlStateNormal];
    [_tagBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_tagBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_tagLabel];
    [self addSubview:_tagBtn];
    
    [self setStyle:self.defaultStyle];

    [_tagLabel sizeToFit];
    CGRect labelFrame = _tagLabel.frame;
    labelFrame.origin.x = kHorizontalPadding;
    labelFrame.origin.y = kVerticalPadding;
    
    CGFloat labelMaxWidth = _MaxWidth - 2*kHorizontalPadding;
    CGFloat labelMinWidth = 20;
    
    if (labelMinWidth < labelMaxWidth) {
        if (labelFrame.size.width < labelMinWidth) {
            labelFrame.size.width = labelMinWidth;
        }
        if (labelFrame.size.width > labelMaxWidth) {
            labelFrame.size.width = labelMaxWidth;
        }
    }
    self.tagLabel.frame = labelFrame;
    
    _tagBtn.frame = CGRectMake(labelFrame.origin.x + labelFrame.size.width, kVerticalPadding, labelFrame.size.height, labelFrame.size.height);
    
    self.frame = CGRectMake(0, 0, 2*kHorizontalPadding + labelFrame.size.width + _tagBtn.frame.size.width, 2*kVerticalPadding + labelFrame.size.height);
    
}

- (void)setStyle:(LCNContactViewStyle *)style{
    
    _tagLabel.font = [UIFont systemFontOfSize: style.fontSize];
    _tagLabel.textColor = style.textColor;
    self.backgroundColor = style.backgroundColor;
    self.layer.cornerRadius = style.cornerRadius;
    self.layer.borderWidth = style.borderWidth;
    self.layer.borderColor = style.borderColor.CGColor;
}

#pragma mark - Target & Action
-(void)tapContactView{
    if ([self.delegate respondsToSelector:@selector(selectedContactView:)]) {
        [self.delegate selectedContactView:self];
    }
}

-(void)delete:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(deleteContactView:)]) {
        [self.delegate deleteContactView:self];
    }
}

@end
