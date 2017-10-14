//
//  ViewController.m
//  ios-objc-uialertcontroller-uitextfield-demo
//
//  Created by OkuderaYuki on 2017/10/14.
//  Copyright © 2017年 OkuderaYuki. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *centerTextField;
@property (nonatomic) UIAlertController *alert;
@end

@implementation ViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - IBActions

- (IBAction)didTapShowAlertButton:(UIButton *)sender {
    [self showAlertWithSavedText:self.centerTextField.text];
}

#pragma mark - Selector

- (void)alertTextFieldTextDidChange:(NSNotification *)notification {
    UITextField *textField = notification.object;
    
    // 入力後の文字数が0より大きければ、AlertのOKボタンのenabled = YES
    // 0以下の場合は、AlertのOKボタンのenabled = NO
    NSUInteger textLength = textField.text.length;
    BOOL enabledAlertOKButton = textLength > 0;
    self.alert.actions.lastObject.enabled = enabledAlertOKButton;
}

#pragma mark - Alert

- (void)showAlertWithSavedText:(NSString *)text {
    self.alert = [UIAlertController alertControllerWithTitle:@"タイトル"
                                                     message:@"メッセージ"
                                              preferredStyle:UIAlertControllerStyleAlert];
    
    // 1. Blocks（無名関数）の中で「self」にアクセスすると循環参照になるため弱参照のweakSelfを定義
    __weak typeof(self) weakSelf = self;
    
    [self.alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        // 「weakSelf」は弱参照のため循環参照にはならないが、nilになってしまう可能性がある
        // 2. 「weakSelf」がBlock内の処理実行中にnilになってしまうのを防ぐために「weakSelf」の強参照を持つ
        __strong typeof(self) strongSelf = weakSelf;
        
        // 3. 「strongSelf」を定義する前に「weakSelf」がnilになっていると、「strongSelf」もnilになるのでnilチェックをする
        if (!strongSelf) {
            return;
        }
        
        textField.placeholder = @"テキストを入力してください。";
        textField.text = text;
        
        // TextFieldに通知を登録
        [NSNotificationCenter.defaultCenter addObserver:strongSelf
                                               selector:@selector(alertTextFieldTextDidChange:)
                                                   name:UITextFieldTextDidChangeNotification
                                                 object:textField];
    }];
    
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        __strong typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        // Alert内のTextFieldがnilでなければ、ViewControllerのTextFieldにtextを渡す
        UITextField *alertTextField = strongSelf.alert.textFields.firstObject;
        if (alertTextField) {
            strongSelf.centerTextField.text = alertTextField.text;
        }
        
        // TextFieldに登録した通知を削除
        [NSNotificationCenter.defaultCenter removeObserver:alertTextField];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"キャンセル" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        __strong typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        UITextField *alertTextField = strongSelf.alert.textFields.firstObject;
        // TextFieldに登録した通知を削除
        [NSNotificationCenter.defaultCenter removeObserver:alertTextField];
    }];
    
    // 引数のtextの長さによって、OKボタンの初期状態を設定
    BOOL enabledOKButton = text && text.length > 0;
    okAction.enabled = enabledOKButton;
    
    [self.alert addAction:cancelAction];
    [self.alert addAction:okAction];
    [self presentViewController:self.alert animated:YES completion:nil];
}

@end
