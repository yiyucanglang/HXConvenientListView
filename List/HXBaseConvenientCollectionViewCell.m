//
//  HXBaseConvenientCollectionViewCell.m
//  ShengXue
//
//  Created by 周义进 on 2018/12/30.
//  Copyright © 2018 DaHuanXiong. All rights reserved.
//

#import "HXBaseConvenientCollectionViewCell.h"

@implementation HXBaseConvenientCollectionViewCell
@synthesize delegate  = _delegate;
@synthesize tap       = _tap;
@synthesize dataModel = _dataModel;

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addGestureRecognizer:self.tap];
        [self UIConfig];
    }
    return self;
}

#pragma mark - System Method
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView addGestureRecognizer:self.tap];
    [self UIConfig];
}

#pragma mark - Public Method
- (void)UIConfig {
    
}

- (void)bindingModel:(id<HXConvenientViewModelProtocol>)dataModel {
    _dataModel       = dataModel;
    self.tap.enabled = !dataModel.forbiddenCustomTap;
    if (dataModel.delegate) {
        self.delegate = dataModel.delegate;
    }
    [self setAvailableModelHeight];
}

- (void)updateActionType:(NSInteger)actionType {
    [self updateActionType:actionType userInfo:nil];
}

- (void)updateActionType:(NSInteger)actionType userInfo:(NSDictionary *)userInfo {
    
    self.dataModel.actionType = actionType;
    if (!self.dataModel.delegate) {
        self.dataModel.delegate = self.delegate;
    }
    [self notiDelegateWithUserInfo:userInfo];
}

- (void)setAvailableModelHeight {
}

#pragma mark - Private Method

- (void)tapClick:(UITapGestureRecognizer *)tap {
    [self updateActionType:0];
}

- (void)notiDelegateWithUserInfo:(NSDictionary *)userInfo {
    
    SEL sel = NSSelectorFromString(self.dataModel.delegateHandleMethodStr);
    if ([self.delegate respondsToSelector:sel]) {
        
        [self callTarget:self.delegate sel:sel model:self.dataModel view:self userInfo:userInfo];
        return;
        
    }
    
    NSString *customSwitchMethodStr = [NSString stringWithFormat:@"handleActionIn%@WithModel:view:", NSStringFromClass([self class])];
    sel = NSSelectorFromString(customSwitchMethodStr);
    if ([self.delegate respondsToSelector:sel]) {
        
        [self callTarget:self.delegate sel:sel model:self.dataModel view:self userInfo:nil];
        return;
        
    }
    
    
    
    if ([self.delegate respondsToSelector:@selector(handleActionInView:model:)]) {
        [self.delegate handleActionInView:self model:self.dataModel];
    }
    
}

#pragma mark tool
- (void)callTarget:(id)target sel:(SEL)sel model:(id)model view:(UIView *)view userInfo:(NSDictionary *)userInfo {
    
    NSMethodSignature *signature = [[target class] instanceMethodSignatureForSelector:sel];
    
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:target];
    
    [invocation setSelector:sel];
    if (signature.numberOfArguments == 4) {
        [invocation setArgument:&model atIndex:2];
        [invocation setArgument:&view atIndex:3];
    }
    else if (signature.numberOfArguments == 3) {
        [invocation setArgument:&userInfo atIndex:2];
    }
    
    [invocation invoke];
}


- (UIViewController *)hx_ViewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - Delegate

#pragma mark - Setter And Getter
- (UITapGestureRecognizer *)tap {
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    }
    return _tap;
}

- (id<HXConvenientViewDelegate>)delegate {
    if (!_delegate) {
        _delegate = (id<HXConvenientViewDelegate>)self.hx_ViewController;
    }
    return _delegate;
}

#pragma mark - Dealloc

@end
