//
//  TelInputView.m
//  MyHome
//
//  Created by Дмитрий Калашников on 11/04/14.
//
//

#import "TelInputView.h"

@implementation TelInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setUp{
    _codeStr = @"";
    isCodeFull = NO;
    self.codeLength = 3;
    [self becomeFirstResponder];
}
#pragma mark UIKeyInput
- (UIKeyboardType)keyboardType {
    return UIKeyboardTypeNumberPad;
}
- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)insertText:(NSString *)text{
    int x = [_telLabel.text rangeOfString:@"_"].location;
    int bracketPos = [_telLabel.text rangeOfString:@"("].location;
    if (!isCodeFull) {
        if (x > 0) {
            NSRange rang = {x,1};
            
            
            if (x-1 <= bracketPos) {
                NSRange rang = {x,1};
                _telLabel.text = [_telLabel.text stringByReplacingCharactersInRange:rang  withString:text];
            }else{
                x--;
                NSRange rang = {x,2};
                _telLabel.text = [_telLabel.text stringByReplacingCharactersInRange:rang  withString:text];
            }
            
            _codeStr =  [_codeStr stringByAppendingString:text];
            if (_codeStr.length == self.codeLength) {
                isCodeFull = YES;
            }
        }

    }
}

- (void)deleteBackward{
    if (_codeStr.length) {
        int x = [_telLabel.text rangeOfString:@"_"].location;
        int bracketPos = [_telLabel.text rangeOfString:@"("].location;
        
        if ((x-1 <= bracketPos) && (x > 0)) {
            NSRange rang = {x,1};
            _telLabel.text = [_telLabel.text stringByReplacingCharactersInRange:rang  withString:@"_"];
            
        }else{
            if (x < 0) {
                x = [_telLabel.text rangeOfString:@")"].location-1;
            }
            else{
                x = [_telLabel.text rangeOfString:@"_"].location-2;
            }
        
            NSRange rang = {x,1};
            _telLabel.text = [_telLabel.text stringByReplacingCharactersInRange:rang  withString:@" _"];
        }
    
        _codeStr =  [_codeStr substringToIndex:_codeStr.length-1];
        isCodeFull = NO;
    }
    
}

@end
