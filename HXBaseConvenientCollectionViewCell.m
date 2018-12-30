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
    self.dataModel.actionType = actionType;
    if (!self.dataModel.delegate) {
        self.dataModel.delegate = self.delegate;
    }
    [self notiDelegate];
}

- (void)setAvailableModelHeight {
}

#pragma mark - Private Method

- (void)tapClick:(UITapGestureRecognizer *)tap {
    [self updateActionType:0];
}

- (void)notiDelegate {
    SEL sel = NSSelectorFromString(self.dataModel.delegateHandleMethodStr);
    if ([self.delegate respondsToSelector:sel]) {
        
        [self callTarget:self.delegate sel:sel model:self.dataModel view:self];
        return;
        
    }
    
    NSString *customSwitchMethodStr = [NSString stringWithFormat:@"handleActionIn%@WithModel:view:", NSStringFromClass([self class])];
    sel = NSSelectorFromString(customSwitchMethodStr);
    if ([self.delegate respondsToSelector:sel]) {
        
        [self callTarget:self.delegate sel:sel model:self.dataModel view:self];
        return;
        
    }
    
    if ([self.delegate respondsToSelector:@selector(handleActionInView:model:)]) {
        [self.delegate handleActionInView:self model:self.dataModel];
    }
    
}

#pragma mark tool
- (void)callTarget:(id)target sel:(SEL)sel model:(id)model view:(UIView *)view {
    NSMethodSignature *signature = [[target class] instanceMethodSignatureForSelector:sel];
    if (signature.numberOfArguments != 4) {
        NSString *errorDes = [NSString stringWithFormat:@"%@代理对象自定义代理方法参数设置错误", NSStringFromClass([self class])];
        NSAssert(0, errorDes);
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:target];
    [invocation setSelector:sel];
    [invocation setArgument:&model atIndex:2];
    [invocation setArgument:&view atIndex:3];
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
