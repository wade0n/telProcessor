//
//  TelInputView.h
//  MyHome
//
//  Created by Дмитрий Калашников on 11/04/14.
//
//

#import <UIKit/UIKit.h>

@interface TelInputView : UIView <UIKeyInput>{
  
}

@property(nonatomic) BOOL isCodeFull;
@property(nonatomic) int codeLength;
@property(nonatomic, strong) IBOutlet UILabel *telLabel;
@property(nonatomic, strong) NSString *codeStr;


- (void)setUp;
@end
