//
//  HXConvenientViewTool.h
//  ShengXue
//
//  Created by 周义进 on 2018/12/28.
//  Copyright © 2018 DaHuanXiong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HXBaseConvenientViewModel;
@interface HXConvenientViewTool : NSObject

//color = defaultSeperatorColor;hegight = 20;view:HXBaseSeperatorView
+ (HXBaseConvenientViewModel *)seperatorModel;

+ (HXBaseConvenientViewModel *)seperatorModelWithColor:(UIColor *)seperatorColor height:(CGFloat)height viewClassName:(NSString *)viewClassName;

//you should call this at the app launch default:rgba(244,245,247,1)
+ (void)setDefaultSeperatorColor:(UIColor *)seperatorColor;


//config  customHandleMethod in view's delegate
+ (void)configCustomMethodDic:(NSDictionary *)dic delegate:(id)delegate viewClassName:(NSString *)viewClassName;

+ (NSDictionary *)customMethodDicWithViewClassName:(NSString *)viewClassName delegate:(id)delegate;

+ (void)removeCustomMethodDicWithDelegate:(id)delegate;

@end

NS_ASSUME_NONNULL_END
