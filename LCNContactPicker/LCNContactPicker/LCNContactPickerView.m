//
//  ContactPickerView.m
//  LCNContactPicker
//
//  Created by 黄春涛 on 15/12/31.
//  Copyright © 2015年 黄春涛. All rights reserved.
//

#import "LCNContactPickerView.h"
#import "LCNContactView.h"
#import "LCNTextField.h"
#import "LCNContactViewStyle.h"


static const CGFloat kVerticalPadding = 3;
static const CGFloat kHorizontalPadding = 3;

@interface LCNContactPickerView()<ContactViewDelegate,LCNTextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *contactViewArray;///<ContactView
@property (nonatomic, strong) NSMutableArray *contactArray;///<ContactModel

@property (nonatomic, strong) LCNContactView *lastAddedContactView;
@property (nonatomic, strong) LCNContactView *lastSelectedContactView;
@property (nonatomic, assign) CGFloat lineHight;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) LCNTextField *textField;

@property (nonatomic, strong) LCNContactViewStyle *defaultStyle;
@property (nonatomic, strong) LCNContactViewStyle *defaultSelectedStyle;

@end

@implementation LCNContactPickerView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //行高
        LCNContactModel *model = [LCNContactModel new];
        model.contactName = @"18867103612";
        model.contact = @"18867103612";
        LCNContactView *tmpView = [[LCNContactView alloc] initWithContactModel:model];
        self.lineHight = tmpView.frame.size.height + 2 * kVerticalPadding;
        
        //输入框最短宽度，小于最小宽度时，换行放置
        if (!self.minTextFieldWidth) {
            self.minTextFieldWidth = 50;
        }
        
        if (!self.maxLineNumber) {
            self.maxLineNumber = 5;
        }
        
        //控件最低高度为一行高度
        CGRect viewFrame = self.frame;
        if (viewFrame.size.height < self.lineHight) {
            viewFrame.size.height = self.lineHight;
            self.frame = viewFrame;
        }
        
        //控件外边框，方便观察
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        
        self.defaultStyle = [LCNContactViewStyle defaultStyle];
        self.defaultSelectedStyle = [LCNContactViewStyle defaultSelectedStyle];
        
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"init error" reason:@"please use initWithFrame" userInfo:nil];
    return [self initWithFrame:CGRectZero];
}

-(void)setup{
    //初始化数据源
    self.contactViewArray = [NSMutableArray array];
    self.contactArray = [NSMutableArray array];
    
    //布局ScrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.scrollView.scrollsToTop = NO;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.scrollView];
    
    
    self.textField = [[LCNTextField alloc] initWithFrame:CGRectMake(kHorizontalPadding, kVerticalPadding, self.frame.size.width - 2 * kHorizontalPadding, self.lineHight - 2 * kVerticalPadding)];
    self.textField.delegate = self;
    [self.scrollView addSubview:self.textField];
}

- (void)addWithContactModel:(LCNContactModel *)model{
    if (!model.contactName ) return;
    if (!model.contact) model.contact = model.contactName;
    
    LCNContactView *contactVeiw = [[LCNContactView alloc] initWithContactModel:model
                                                                  defaultStyle:self.defaultStyle
                                                          defaultSelectedStyle:self.defaultSelectedStyle];
    contactVeiw.delegate = self;
    
    //布局contactView
    if (!self.lastAddedContactView) {
        //首次添加ContactView
        CGRect frame = contactVeiw.frame;
        frame.origin.x = kHorizontalPadding;
        frame.origin.y = kVerticalPadding;
        contactVeiw.frame = frame;
    }
    else{
        CGRect lastAddedFrame = self.lastAddedContactView.frame;
        CGRect currentFrame = contactVeiw.frame;
        CGRect viewFrame = self.frame;
        
        //判断contactView能否放置在当前行
        if ((viewFrame.size.width - lastAddedFrame.origin.x - lastAddedFrame.size.width - kHorizontalPadding) > currentFrame.size.width) {
            //在同一行布局contactView
            currentFrame.origin.x = lastAddedFrame.origin.x + lastAddedFrame.size.width + 2 * kHorizontalPadding;
            currentFrame.origin.y = lastAddedFrame.origin.y;
            contactVeiw.frame = currentFrame;
        }
        else{
            //换行布局contactView
            currentFrame.origin.x = kHorizontalPadding;
            currentFrame.origin.y = lastAddedFrame.origin.y + self.lineHight;
            contactVeiw.frame = currentFrame;
        }
        
    }
    
    self.lastAddedContactView = contactVeiw;
    
    [self reSizingTextField];
    
    [self.scrollView addSubview:contactVeiw];
    
    //调整Frame,ScrollViewFrame
    [self reSizeingFrame];

    
    //添加至数据源
    [self.contactArray addObject:model];
    [self.contactViewArray addObject:contactVeiw];
    
}

- (void)reSizeingFrame{
    CGRect viewFrame = self.frame;
    CGFloat newHeight = self.textField.frame.origin.y + self.textField.frame.size.height + kVerticalPadding;
    
    if (self.maxLineNumber != 0 && newHeight > self.maxLineNumber * self.lineHight) {
        viewFrame.size.height = self.maxLineNumber * self.lineHight;
    }
    else{
        viewFrame.size.height = newHeight;
    }
    self.frame = viewFrame;
    
    if ([self.delegate respondsToSelector:@selector(LCNContactPickerDidResize:)]) {
        [self.delegate LCNContactPickerDidResize:self];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, newHeight);
        CGPoint point = CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
        self.scrollView.contentOffset = point;
    }];
}

- (void)reSizingTextField{
    CGRect viewFrame = self.frame;
    CGRect lastContactViewFrame =  self.lastAddedContactView.frame;
    CGRect textFieldFrame = self.textField.frame;
    
    //布局textField
    if ((viewFrame.size.width - lastContactViewFrame.origin.x - lastContactViewFrame.size.width - kHorizontalPadding) > self.minTextFieldWidth) {
        //在同一行布局textField
        textFieldFrame.origin.x = lastContactViewFrame.origin.x + lastContactViewFrame.size.width + 2 * kHorizontalPadding;
        textFieldFrame.origin.y = lastContactViewFrame.origin.y ? lastContactViewFrame.origin.y:kVerticalPadding;
        textFieldFrame.size.width = viewFrame.size.width - lastContactViewFrame.origin.x - lastContactViewFrame.size.width - 3 *kHorizontalPadding;
        self.textField.frame = textFieldFrame;
    }
    else{
        //换行布局textField
        textFieldFrame.origin.x = kHorizontalPadding;
        textFieldFrame.origin.y = lastContactViewFrame.origin.y + self.lineHight;
        textFieldFrame.size.width = viewFrame.size.width - 2 * kHorizontalPadding;
        self.textField.frame = textFieldFrame;
    }
}


#pragma mark - ContactViewDelegate
-(void)selectedContactView:(LCNContactView *)contactView{
    
    [self.textField resignFirstResponder];
    [self.lastSelectedContactView setStyle:self.defaultStyle];
    
    if ([self.delegate respondsToSelector:@selector(LCNContactPickerDidSelectedContactView:)]) {
        [self.delegate LCNContactPickerDidSelectedContactView:contactView];
    }
    
    self.lastSelectedContactView = contactView;
    [self.lastSelectedContactView setStyle:self.defaultSelectedStyle];
    
    //ContactView
    if ([contactView isKindOfClass:[LCNContactView class]]) {
        [UIView animateWithDuration:0.3 animations:^{
            [contactView setTransform:CGAffineTransformMakeScale(1.1f, 1.1f)];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                [contactView setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];

            }];
        }];
    }
}

-(void)deleteContactView:(LCNContactView *)contactView{
    
    NSMutableArray *deletedArray = [NSMutableArray array];
    
    for (NSInteger i = self.contactViewArray.count - 1; i >= 0; i--) {
        if (self.contactViewArray[i] == contactView) {
            [contactView removeFromSuperview];
            [self.contactViewArray removeObjectAtIndex:i];
            //删除数据源
            [self.contactArray removeObjectAtIndex:i];
            
            if ([self.delegate respondsToSelector:@selector(LCNContactPickerDidRemoveContact:)]) {
                [self.delegate LCNContactPickerDidRemoveContact:contactView.model.contact];
            }
            
            if (i > 0) {
                self.lastAddedContactView = self.contactViewArray[i-1];
            }
            else{
                self.lastAddedContactView = nil;
            }
            [self reSizingTextField];
            break;
        }
        else{
            [deletedArray insertObject:self.contactViewArray[i] atIndex:0];
            [self.contactViewArray[i] removeFromSuperview];
            [self.contactViewArray removeObjectAtIndex:i];            
        }
    }
    
    //重新添加删除点后的contactView
    for (LCNContactView *deletedContactView in deletedArray) {
        [self addWithContactModel:deletedContactView.model];
    }
    
    self.lastAddedContactView = [self.contactViewArray lastObject];
}

#pragma mark - LCNTextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.lastSelectedContactView) {
        [self.lastSelectedContactView setStyle:self.defaultStyle];
        self.lastSelectedContactView = nil;
    }
}

- (void)LCNTextFieldDidChange:(LCNTextField *)textField{
    if ([self.delegate respondsToSelector:@selector(LCNContactPickerTextViewDidChange:)]) {
        NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self.delegate LCNContactPickerTextViewDidChange:text];
    }
}

-(BOOL)textFieldShouldReturn:(LCNTextField *)textField{
    if (textField.text.length > 0) {
        if ([self.delegate respondsToSelector:@selector(LCNContactPickerTextFieldShouldReturn:)]) {
            [self.delegate LCNContactPickerTextFieldShouldReturn:self.textField];
        }
    }
    return YES;
}

-(void)LCNTextfieldDeleteBackwardWithEmpty:(UITextField *)textField{
    
    if ([self.delegate respondsToSelector:@selector(LCNContactPickerDidRemoveContact:)]) {
        [self.delegate LCNContactPickerDidRemoveContact:[self.contactArray lastObject]];
    }
    
    [self.contactArray removeLastObject];
    [self.contactViewArray.lastObject removeFromSuperview];
    [self.contactViewArray removeLastObject];
    
    self.lastAddedContactView = [self.contactViewArray lastObject];
    [self reSizingTextField];
    [self reSizeingFrame];
}


#pragma mark - Public Function
- (void)addContact:(id)contact withDisplayName:(NSString *)name{
    if (!name) return;
    
    LCNContactModel *model = [LCNContactModel new];
    model.contact = contact;
    model.contactName = name;
    
    [self addWithContactModel:model];
    
}

- (void)addContact:(id)contact
   withDisplayName:(NSString *)name
      defaultStyle:(LCNContactViewStyle *)defaultStyle
defaultSelectedStyle:(LCNContactViewStyle *)defaultSelectedStyle{
    
    LCNContactModel *model = [LCNContactModel new];
    model.contact = contact;
    model.contactName = name;
    
    self.defaultStyle = defaultStyle;
    self.defaultSelectedStyle = defaultSelectedStyle;
    
    [self addWithContactModel:model];
    
}


- (void)removeAllContact{
    
    for (LCNContactView *contactView in self.contactViewArray) {
        [contactView removeFromSuperview];
    }
    [self.contactViewArray removeAllObjects];
    [self.contactArray removeAllObjects];
    self.lastSelectedContactView = nil;
    self.lastAddedContactView = nil;
    
    [self reSizingTextField];
    [self reSizeingFrame];
    
}

@end













