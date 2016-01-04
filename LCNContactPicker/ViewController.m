//
//  ViewController.m
//  LCNContactPicker
//
//  Created by 黄春涛 on 15/12/31.
//  Copyright © 2015年 黄春涛. All rights reserved.
//

#import "ViewController.h"
#import "LCNContactPickerView.h"

@interface ViewController ()<LCNContactPickerViewDelegate>

@property (nonatomic, strong) LCNContactPickerView *contactPickerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contactPickerView = [[LCNContactPickerView alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40, 0)];
    self.contactPickerView.delegate = self;
    [self.view addSubview:self.contactPickerView];
}


#pragma mark - LCNContactPickerViewDelegate

- (void)LCNContactPickerTextViewDidChange:(NSString *)textViewText{
    NSLog(@">>>>>TextChanged:%@",textViewText);
}

- (void)LCNContactPickerDidRemoveContact:(id)contact{
    NSLog(@">>>>>ContactRemoved");
}

- (void)LCNContactPickerDidResize:(LCNContactPickerView *)contactPickerView{
    NSLog(@">>>>>ResizeViewHeight:%f",contactPickerView.frame.size.height);
}

- (BOOL)LCNContactPickerTextFieldShouldReturn:(LCNTextField *)textField{
    NSString *displayName = textField.text;
    [self.contactPickerView addContact:displayName withDisplayName:displayName];
    textField.text = @"";
    return YES;
}

- (void)LCNContactPickerDidSelectedContactView:(LCNContactView *)contactView{
    NSLog(@">>>>>ContactView  selected");
}
@end