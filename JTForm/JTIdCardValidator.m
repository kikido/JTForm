//
//  JTIdCardValidator.m
//  JTForm
//
//  Created by dqh on 2019/5/9.
//  Copyright © 2019 dqh. All rights reserved.
//

#import "JTIdCardValidator.h"
#import "JTRowDescriptor.h"

@implementation JTIdCardValidator

- (JTFormValidateObject *)isValid:(JTRowDescriptor *)rowDescriptor
{
    NSString *errorMsg = @"身份证号码格式错误";
    if (![rowDescriptor.value isKindOfClass:[NSString class]]) {
        return [JTFormValidateObject formValidateObjectWithErrorMsg:errorMsg valid:NO];
    }
    NSString *identityCard = [NSString stringWithFormat:@"%@",rowDescriptor.value   ];
    //判断是否为空
    if (identityCard==nil||identityCard.length <= 0) {
        NSString *errorMsg = @"请输入身份证号码";
        return [JTFormValidateObject formValidateObjectWithErrorMsg:errorMsg valid:NO];
    }
    //判断是否是18位，末尾是否是x
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if(![identityCardPredicate evaluateWithObject:identityCard]){
        return [JTFormValidateObject formValidateObjectWithErrorMsg:errorMsg valid:NO];
    }
    //判断生日是否合法
    NSRange range = NSMakeRange(6,8);
    NSString *datestr = [identityCard substringWithRange:range];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone =  [NSTimeZone timeZoneWithName:@"UTC"];
    [formatter setDateFormat : @"yyyyMMdd"];
    if([formatter dateFromString:datestr]==nil){
        return [JTFormValidateObject formValidateObjectWithErrorMsg:errorMsg valid:NO];
    }
    
    //判断校验位
    if(identityCard.length==18)
    {
        NSArray *idCardWi= @[ @"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2" ]; //将前17位加权因子保存在数组里
        NSArray * idCardY=@[ @"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2" ]; //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        int idCardWiSum=0; //用来保存前17位各自乖以加权因子后的总和
        for(int i=0;i<17;i++){
            idCardWiSum+=[[identityCard substringWithRange:NSMakeRange(i,1)] intValue]*[idCardWi[i] intValue];
        }
        
        int idCardMod=idCardWiSum%11;//计算出校验码所在数组的位置
        NSString *idCardLast=[identityCard substringWithRange:NSMakeRange(17,1)];//得到最后一位身份证号码
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2){
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]){
                return nil;
            }else{
                return [JTFormValidateObject formValidateObjectWithErrorMsg:errorMsg valid:NO];
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast intValue]==[idCardY[idCardMod] intValue]){
                return nil;
            }else{
                return [JTFormValidateObject formValidateObjectWithErrorMsg:errorMsg valid:NO];
            }
        }
    }
    return [JTFormValidateObject formValidateObjectWithErrorMsg:errorMsg valid:NO];
}

@end
