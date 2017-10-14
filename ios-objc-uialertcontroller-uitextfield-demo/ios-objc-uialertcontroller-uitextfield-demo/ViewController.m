//
//  ViewController.m
//  ios-objc-uialertcontroller-uitextfield-demo
//
//  Created by OkuderaYuki on 2017/10/14.
//  Copyright © 2017年 OkuderaYuki. All rights reserved.
//

#import "ViewController.h"

#import "UIViewController+Alert.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *outputLabel;
@end

@implementation ViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - IBActions

- (IBAction)didTapShowAlertButton:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    [self showAlertWithTextfield:self.outputLabel.text
                     placeholder:@"テキストを入力してください。"
                      alertTitle:@"タイトル"
                    alertMessage:@"テキスト"
          textFieldTextDidChange:@selector(alertTextFieldTextDidChange:)
                 okActionHandler:^(NSString *outputText) {
                     weakSelf.outputLabel.text = outputText;
                 }];
}

#pragma mark - Selector

- (void)alertTextFieldTextDidChange:(NSNotification *)notification {
    UITextField *textField = notification.object;
    
    // 入力後の文字数が0より大きければ、AlertのOKボタンのenabled = YES
    // 0以下の場合は、AlertのOKボタンのenabled = NO
    NSUInteger textLength = textField.text.length;
    BOOL enabledAlertOKButton = textLength > 0;
    self.alertWithTextfield.actions.lastObject.enabled = enabledAlertOKButton;
}

@end
