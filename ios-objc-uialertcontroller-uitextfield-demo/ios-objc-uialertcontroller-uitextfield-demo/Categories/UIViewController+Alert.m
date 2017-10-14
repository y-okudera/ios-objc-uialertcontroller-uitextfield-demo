//
//  UIViewController+Alert.m
//  ios-objc-uialertcontroller-uitextfield-demo
//
//  Created by OkuderaYuki on 2017/10/14.
//  Copyright © 2017年 OkuderaYuki. All rights reserved.
//

#import "UIViewController+Alert.h"

typedef void (^AlertActionHandler)(UIAlertAction *action);

@implementation UIViewController (Alert)

const void *alertWithTextfieldKey = @"alertWithTextfield";
@dynamic alertWithTextfield;

#pragma mark - Setter
- (void)setAlertWithTextfield:(UIAlertController *)alertWithTextfield {
    objc_setAssociatedObject(self,
                             alertWithTextfieldKey,
                             alertWithTextfield,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Getter

- (UIAlertController *)alertWithTextfield {
    return  objc_getAssociatedObject(self, alertWithTextfieldKey);
}

#pragma mark - Category Methods

- (void)showAlertWithTextfield:(NSString *)defaultText
                   placeholder:(NSString *)placeholder
                    alertTitle:(NSString *)alertTitle
                  alertMessage:(NSString *)alertMessage
        textFieldTextDidChange:(SEL)aSelector
               okActionHandler:(OKActionHandler)okActionHandler {
    
    self.alertWithTextfield = [UIAlertController alertControllerWithTitle:alertTitle
                                                                  message:alertMessage
                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    __weak typeof(self) weakSelf = self;
    [self.alertWithTextfield addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        __strong typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        textField.placeholder = placeholder;
        textField.text = defaultText;
        
        // TextFieldに通知を登録
        [NSNotificationCenter.defaultCenter addObserver:strongSelf
                                               selector:aSelector
                                                   name:UITextFieldTextDidChangeNotification
                                                 object:textField];
    }];
    
    // OKタップ時の処理
    AlertActionHandler okHandler = ^(UIAlertAction *action) {
        
        __strong typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        UITextField *alertTextField = strongSelf.alertWithTextfield.textFields.firstObject;
        okActionHandler(alertTextField.text);
        [NSNotificationCenter.defaultCenter removeObserver:alertTextField];
    };
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:okHandler];
    
    // キャンセルタップ時の処理
    AlertActionHandler cancelHandler = ^(UIAlertAction *action) {
        __strong typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        UITextField *alertTextField = strongSelf.alertWithTextfield.textFields.firstObject;
        // TextFieldに登録した通知を削除
        [NSNotificationCenter.defaultCenter removeObserver:alertTextField];
    };
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"キャンセル"
                                                           style:UIAlertActionStyleCancel
                                                         handler:cancelHandler];
    
    // 引数のtextの長さによって、OKボタンの初期状態を設定
    BOOL enabledOKButton = defaultText && defaultText.length > 0;
    okAction.enabled = enabledOKButton;
    
    [self.alertWithTextfield addAction:cancelAction];
    [self.alertWithTextfield addAction:okAction];
    [self presentViewController:self.alertWithTextfield animated:YES completion:nil];
}
@end
