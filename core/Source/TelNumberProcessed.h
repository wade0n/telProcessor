//
//  TelNumberProcessed.h
//  MyHome
//
//  Created by Дмитрий Калашников on 09/04/14.
//
//

#import <Foundation/Foundation.h>

@interface TelNumberProcessed : NSObject

@property(nonatomic, strong) NSString *numberStr;
@property(nonatomic, strong) NSString *showNumberStr;
@property(nonatomic) BOOL isFixed;
@property(nonatomic) BOOL isAbleFixed;

@end
