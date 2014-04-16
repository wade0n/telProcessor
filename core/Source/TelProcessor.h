//
//  TelProcessor.h
//  MyHome
//
//  Created by Дмитрий Калашников on 09/04/14.
//
//

#import <Foundation/Foundation.h>
#import "TelInputView.h"

@interface TelProcessor : NSObject <UIActionSheetDelegate, UITextInput>{
    NSMutableArray *_numbersArr;
    NSMutableArray *_numObjectsArr;
    
}
@property(nonatomic, strong) TelInputView *telView;
@property(nonatomic, strong) NSString *phoneMenuTitle;

@property(nonatomic, copy) void (^call)(NSString *numStr);
@property (nonatomic, copy) void (^fixNumers)(NSMutableArray *fixedNumbers);



- (NSMutableArray *)processNumbersArr:(NSArray *)numbersArr;
- (NSMutableArray *)processTextBlockWithSeparatedNumbers;
- (NSMutableArray *)proccesTextBlockWithTelephones:(NSString *)textBlock;

@end
