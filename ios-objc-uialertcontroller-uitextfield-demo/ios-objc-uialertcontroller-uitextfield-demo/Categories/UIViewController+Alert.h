//
//  UIViewController+Alert.h
//  ios-objc-uialertcontroller-uitextfield-demo
//
//  Created by OkuderaYuki on 2017/10/14.
//  Copyright © 2017年 OkuderaYuki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef void (^OKActionHandler)(NSString *outputText);

@interface UIViewController (Alert)
@property (nonatomic) UIAlertController *alertWithTextfield;
- (void)showAlertWithTextfield:(NSString *)defaultText
                   placeholder:(NSString *)placeholder
                    alertTitle:(NSString *)alertTitle
                  alertMessage:(NSString *)alertMessage
        textFieldTextDidChange:(SEL)aSelector
               okActionHandler:(OKActionHandler)okActionHandler;
@end
