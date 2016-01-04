//
//  ContactPickerView.h
//  LCNContactPicker
//
//  Created by 黄春涛 on 15/12/31.
//  Copyright © 2015年 黄春涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCNContactModel.h"
#import "LCNTextField.h"
@class LCNContactPickerView;
@class LCNContactView;
@class LCNContactViewStyle;


@protocol  LCNContactPickerViewDelegate <NSObject>

- (void)LCNContactPickerTextViewDidChange:(NSString *)textViewText;
- (void)LCNContactPickerDidRemoveContact:(id)contact;
- (void)LCNContactPickerDidResize:(LCNContactPickerView *)contactPickerView;
- (BOOL)LCNContactPickerTextFieldShouldReturn:(LCNTextField *)textField;

- (void)LCNContactPickerDidSelectedContactView:(LCNContactView *)contactView;

@end


@interface LCNContactPickerView : UIView

@property (nonatomic, strong) id<LCNContactPickerViewDelegate> delegate;

/**
 *  输入框最小布局宽度(默认长度为50)
 */
@property (nonatomic, assign) CGFloat minTextFieldWidth;

/**
 *  控件行数限制(默认行数为5行)
 */
@property (nonatomic, assign) NSInteger maxLineNumber;


/**
 *  增加Contact
 *
 *  @param contact
 *  @param name 不可为空
 */
- (void)addContact:(id)contact withDisplayName:(NSString *)name;

/**
 *  增加Contact 同时定制ContactView样式
 *
 *  @param contact
 *  @param name
 *  @param defaultStyle         默认样式
 *  @param defaultSelectedStyle 默认选中样式
 */
- (void)addContact:(id)contact withDisplayName:(NSString *)name defaultStyle:(LCNContactViewStyle *)defaultStyle defaultSelectedStyle:(LCNContactViewStyle *)defaultSelectedStyle;

/**
 *  移除所有Contact
 */
- (void)removeAllContact;

@end
