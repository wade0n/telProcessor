//
//  TelProcessor.m
//  MyHome
//
//  Created by Дмитрий Калашников on 09/04/14.
//
//

#import "TelProcessor.h"
#import "TelNumberProcessed.h"
#import "CXAlertView.h"
#import "Wabbly.h"

#define NUMBER_LENGTH 11
#define CURRENT_COUNTRY_CODE 7
#define CURRENT_LOCAL_COUNTRY_CODE 8

@implementation TelProcessor



-(id)init{
    self = [super init];
    if (self) {
        _numObjectsArr = [NSMutableArray new];
        _numbersArr = [NSMutableArray new];
        self.phoneMenuTitle = NSLocalizedStringFromTable(@"Telephone numbers:", @"telProcessor", @"");
        _telView = [WAUtility loadNibNamed:@"telProc" ofClass:[TelInputView class]];
        
    }
    return self;
}

- (NSMutableArray *)processNumbersArr:(NSArray *)numbersArr{
    NSMutableArray *fidedNumbers = [NSMutableArray new];

    [self cleanUp];
    
    if (numbersArr && numbersArr.count) {
        
        for (NSString *numStr in numbersArr) {
            if (numStr && [numStr isKindOfClass:[NSString class]]) {
                [_numbersArr addObject:numStr];
                NSString * strippedNumber = [numStr stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [numStr length])];
                if (strippedNumber.length <= NUMBER_LENGTH) {
                    if (strippedNumber.length == NUMBER_LENGTH) {
                        if ([[strippedNumber substringToIndex:1] isEqualToString:[NSString stringWithFormat:@"%i",CURRENT_LOCAL_COUNTRY_CODE]] || [[strippedNumber substringToIndex:1] isEqualToString:[NSString stringWithFormat:@"%i",CURRENT_COUNTRY_CODE]]) {
                            strippedNumber = [NSString stringWithFormat:@"+%i%@",CURRENT_COUNTRY_CODE,[strippedNumber substringFromIndex:1]];
                            [self generateNumWithFixedStr:strippedNumber fixed:YES];
                        }else{
                            [self generateNumWithFixedStr:strippedNumber fixed:NO];
                        }
                    }else if (strippedNumber.length == NUMBER_LENGTH-1){
                        strippedNumber = [NSString stringWithFormat:@"+%i%@",CURRENT_COUNTRY_CODE,strippedNumber];
                        [self generateNumWithFixedStr:strippedNumber fixed:YES];
                    }
                    else {
                        [self generateNumWithFixedStr:strippedNumber fixed:NO];
                    }
                }
                else{
                     [self generateNumWithFixedStr:strippedNumber fixed:NO];
                }
            }
        }
    }
    else{
        NSLog(@"empty or nil array input - %@",numbersArr);
    }
    
    
    [self showCallMenu:_numbersArr];
    
    return fidedNumbers;
}

- (void)generateNumWithFixedStr:(NSString *)numStr fixed:(BOOL)isFixed{
    TelNumberProcessed *numObj = [[TelNumberProcessed alloc] init];
    numObj.numberStr = [NSString stringWithString:numStr];
    numObj.isFixed = isFixed;
    
    if (numStr.length > NUMBER_LENGTH+1) {
        numObj.isAbleFixed = NO;
    }
    else
        numObj.isAbleFixed = YES;
    
    [_numObjectsArr addObject:numObj];
}

- (void)addCode:(NSString *)codeStr toTel:(TelNumberProcessed *)telObj{
    if (codeStr && codeStr.length) {
        telObj.numberStr = [NSString stringWithFormat:@"+%i%@%@",CURRENT_COUNTRY_CODE, codeStr, telObj.numberStr];
        if (telObj.numberStr.length == 11) {
            telObj.isFixed = YES;
        }
        if (_fixNumers) {
            NSMutableArray *fixedNumbers = [NSMutableArray new];
            for( TelNumberProcessed *num  in _numObjectsArr) {
                [fixedNumbers addObject:num.numberStr];
            }
            _fixNumers(fixedNumbers);
        }
    }
}


- (NSMutableArray *)proccesTextBlockWithTelephones:(NSString *)textBlock{
    
    NSMutableArray *returnArr = [NSMutableArray new];
    if (textBlock && textBlock.length) {
        NSMutableString *phonesMut = [textBlock mutableCopy];
        NSString *separator = @"|";
        [phonesMut replaceOccurrencesOfString:@"," withString:separator options:NSCaseInsensitiveSearch range:NSMakeRange(0, phonesMut.length)];
        [phonesMut replaceOccurrencesOfString:@";" withString:separator options:NSCaseInsensitiveSearch range:NSMakeRange(0, phonesMut.length)];
        NSArray *phonesSeparated = [phonesMut componentsSeparatedByString:separator];
        
        returnArr = [self processNumbersArr:phonesSeparated];
    }
    
    return returnArr;
}
- (NSString *)formTelInputStr:(NSString *)telNum{
    NSString *returnStr = [NSString stringWithFormat:@"+%i",CURRENT_COUNTRY_CODE];
    if (telNum && telNum.length) {
        
        int telLength = (int)telNum.length;
        int regionLength = NUMBER_LENGTH - telLength-1;
        NSString *dashes = @"";
        NSString *localNum = @"";
        for (int i = 0; i < regionLength; i++) {
            dashes = [dashes stringByAppendingString:@"_"];
        
            if (i < regionLength -1) {
                dashes = [dashes stringByAppendingString:@" "];
            }
        }
        if (regionLength == 3) {
            NSRange firstRange = {3,2};
            NSRange secondRange = {5,2};
            localNum = [NSString stringWithFormat:@"%@-%@-%@",[telNum substringToIndex:3],[telNum substringWithRange:firstRange],[telNum substringWithRange:secondRange]];
        }
        else if (regionLength == 4){
            NSRange firstRange = {2,2};
            NSRange secondRange = {4,2};
            localNum = [NSString stringWithFormat:@"%@-%@-%@",[telNum substringToIndex:2],[telNum substringWithRange:firstRange],[telNum substringWithRange:secondRange]];
        }
        else if (regionLength == 5){
            NSRange firstRange = {3,2};
            localNum = [NSString stringWithFormat:@"%@-%@",[telNum substringToIndex:3],[telNum substringWithRange:firstRange]];
        }
        returnStr = [NSString stringWithFormat:@"%@ (%@) %@",returnStr,dashes,localNum];
    }
    
    return returnStr;
}
- (void)showCallMenu:(NSMutableArray *)phones{

    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    for (NSString *ph in phones) {
        if ((ph && ph.length)) {
            [popupQuery addButtonWithTitle:ph];
        }
    }
    
    [popupQuery addButtonWithTitle:NSLocalizedStringFromTable(@"Cancel", @"telProcessor",@"")];
    popupQuery.title = self.phoneMenuTitle;
    popupQuery.cancelButtonIndex = popupQuery.numberOfButtons -1;
    [popupQuery showInView:[UIApplication   sharedApplication].keyWindow];
}

- (void)cleanUp{
    [_numbersArr removeAllObjects];
    [_numObjectsArr removeAllObjects];
}

- (void)dialNumber:(NSString *)dial{
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", dial]];
    [[UIApplication sharedApplication] openURL:telURL];
    if (_call) {
        _call(dial);
    }

}
#pragma mark Action Sheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex < actionSheet.numberOfButtons-1) {
        
        
        TelNumberProcessed *telProc = [_numObjectsArr objectAtIndex:buttonIndex];
        
        
        if (telProc.isFixed) {
            [self dialNumber:telProc.numberStr];
        }
        else{
            
            _telView.telLabel.text = [self formTelInputStr:telProc.numberStr];
            
            CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Input region code to call:", @"telProcessor",@"")
                                                            contentView:_telView cancelButtonTitle:nil];
            
           
            alertView.willShowHandler = ^(CXAlertView *alertView) {
                NSLog(@"%@, willShowHandler", alertView);
               [_telView setUp];
            };
            alertView.didShowHandler = ^(CXAlertView *alertView) {
                NSLog(@"%@, didShowHandler", alertView);
            };
            alertView.willDismissHandler = ^(CXAlertView *alertView) {
                NSLog(@"%@, willDismissHandler", alertView);
            };
            alertView.didDismissHandler = ^(CXAlertView *alertView) {
                NSLog(@"%@, didDismissHandler", alertView);
            };
            
            alertView.customButtonColor = [UIColor colorWithRed:248.0f/255.0f green:79.0f/255.0f blue:77.0f/255.0f alpha:1.0];
            alertView.cancelButtonColor = [UIColor colorWithRed:53.0f/255.0f green:160.0f/255.0f blue:35.0f/255.0f alpha:1.0];
            alertView.buttonColor = [UIColor redColor];
            [alertView setTitleFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0f]];
            TelProcessor *selfCaptured = self;
            
            [alertView addButtonWithTitle:NSLocalizedStringFromTable(@"Cancel", @"telProcessor",@"") type:CXAlertViewButtonTypeCustom handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                [_telView resignFirstResponder];
                [alertView dismiss];
                [selfCaptured showCallMenu:_numbersArr];
            }];
            
            [alertView addButtonWithTitle:NSLocalizedStringFromTable(@"Call", @"telProcessor",@"") type:CXAlertViewButtonTypeCancel handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                [_telView resignFirstResponder];
                [alertView dismiss];
                [selfCaptured addCode:_telView.codeStr toTel:telProc];
                
                [selfCaptured dialNumber:telProc.numberStr];
            }];
            
            [alertView showButtonLine];
            [alertView show];
            [_telView setUp];
            
            
            if ([[UIScreen mainScreen] bounds].size.height == 480.0f) {
                alertView.alertWindow.center = CGPointMake(alertView.center.x, alertView.center.y-44*2);
            }else{
                alertView.alertWindow.center = CGPointMake(alertView.center.x, alertView.center.y-44);
            }

        }
        
        
    }
}

@end
