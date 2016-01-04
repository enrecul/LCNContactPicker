//
//  ContactModel.h
//  LCNContactPicker
//
//  Created by 黄春涛 on 15/12/31.
//  Copyright © 2015年 黄春涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCNContactModel : NSObject

@property (nonatomic, strong) NSString *contactName;//ContactView显示的文字
@property (nonatomic, strong) id contact;//与ContactView绑定的数据源

@end
