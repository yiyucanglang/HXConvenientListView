//
//  HXBaseConvinienceView.h
//  ShengXue
//
//  Created by 周义进 on 2018/12/25.
//  Copyright © 2018 DaHuanXiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXViewConvenientProtocol.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark -CodeSnippet
/*
#pragma mark <#ViewClass#>
- (void)handle<#ViewClass#>Action:(NSInteger)actionType userInfo:(NSDictionary *)userInfo view:(<#ViewClass#> *)view {
    <#begin#>
}

#pragma mark <#ViewClass#>
-(void)handleActionIn<#ViewClass#>WithModel:(<#ModelClass#> *)model view:(<#ViewClass#> *)view {
    <#begin#>
}
*/


typedef NS_ENUM(NSInteger, HXBaseConvenientViewActionType) {
    HXBaseConvenientViewActionType_Cancel = -1000,
};


typedef void(^HXConvenientViewActionHandleBlock)(NSDictionary * _Nullable userInfo);


@interface HXBaseConvenientView : UIView<HXConvenientViewProtocol>

@property (nonatomic, strong) NSString     *viewIdentifier;

@property (nonatomic, strong) UIView *alertMaskView;
@property (nonatomic, strong) UIView *alertContentView;

/// 注意循环引用问题
@property (nonatomic, copy, nullable) HXConvenientViewActionHandleBlock actionHandleBlock;


- (void)bindingModel:(id<HXConvenientViewModelProtocol>)dataModel;


/// 事件触发
/// @param sender Button Or UIGestureRecognizer
- (void)actionTriggeredBy:(id)sender;

- (void)showInView:(UIView *)targetView userInfo:(NSDictionary * _Nullable)userInfo;

- (void)showInView:(UIView *)targetView
          userInfo:(NSDictionary * _Nullable)userInfo
        completion:(HXConvenientViewActionHandleBlock _Nullable)completion;


- (void)dismiss;

- (void)dismissWithShouldSendingActionSignal:(BOOL)send;

@end

NS_ASSUME_NONNULL_END
