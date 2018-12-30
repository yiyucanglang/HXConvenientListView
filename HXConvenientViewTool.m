//
//  HXConvenientViewTool.m
//  ShengXue
//
//  Created by 周义进 on 2018/12/28.
//  Copyright © 2018 DaHuanXiong. All rights reserved.
//

#import "HXConvenientViewTool.h"
#import "HXBaseConvenientViewModel.h"

@implementation HXConvenientViewTool

#pragma mark - Life Cycle
static UIColor              *defaultSeperatorColor;
static NSMutableDictionary  *customMethodDic;
+(void)initialize {
    
    if (!defaultSeperatorColor) {
        defaultSeperatorColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:247/255.0 alpha:1];
    }
    if (!customMethodDic) {
        customMethodDic = [NSMutableDictionary dictionary];
    }
}
#pragma mark - System Method

#pragma mark - Public Method
+ (HXBaseConvenientViewModel *)seperatorModel {
    return [self seperatorModelWithColor:defaultSeperatorColor height:20 viewClassName:@"HXBaseSeperatorView"];
}

+ (HXBaseConvenientViewModel *)seperatorModelWithColor:(UIColor *)seperatorColor height:(CGFloat)height viewClassName:(nonnull NSString *)viewClassName{
    HXBaseConvenientViewModel *model = [HXBaseConvenientViewModel model];
    model.userInfo = @{hxBackgroundColorKey : seperatorColor?:defaultSeperatorColor};
    model.viewClassName = viewClassName;
    model.viewHeight    = height;
    return model;
}

+ (void)setDefaultSeperatorColor:(UIColor *)seperatorColor {
    if (seperatorColor) {
        defaultSeperatorColor = seperatorColor;
    }
}

+ (void)configCustomMethodDic:(NSDictionary *)dic delegate:(id)delegate viewClassName:(NSString *)viewClassName {
    @synchronized (self) {
        if (!delegate) {
            return;
        }
        NSString *key = [NSString stringWithFormat:@"%p_%@",delegate, viewClassName];
        customMethodDic[key] = dic;
    }
}

+ (void)removeCustomMethodDicWithDelegate:(id)delegate {
    @synchronized (self) {
        NSString *p = [NSString stringWithFormat:@"%p", delegate];
        NSArray *keys = customMethodDic.allKeys;
        for (NSString *item in keys) {
            if ([item containsString:p]) {
                [customMethodDic removeObjectForKey:item];
                return;
            }
        }
    }
}

+ (NSDictionary *)customMethodDicWithViewClassName:(NSString *)viewClassName delegate:(id)delegate {
    NSString *key = [NSString stringWithFormat:@"%p_%@",delegate, viewClassName];
    return customMethodDic[key];
}

#pragma mark - Private Method

#pragma mark - Delegate

#pragma mark - Setter And Getter

#pragma mark - Dealloc
@end
