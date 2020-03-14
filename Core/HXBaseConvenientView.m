//
//  HXBaseConvinienceView.m
//  ShengXue
//
//  Created by 周义进 on 2018/12/25.
//  Copyright © 2018 DaHuanXiong. All rights reserved.
//

#import "HXBaseConvenientView.h"
#import "HXConvenientViewTool.h"
#import <objc/runtime.h>

@interface HXBaseConvenientView()
@property (nonatomic, assign) BOOL actionSignalIsPassing;

@end

@implementation HXBaseConvenientView
@synthesize delegate  = _delegate;
@synthesize tap       = _tap;
@synthesize dataModel = _dataModel;
@synthesize containerTableViewCell = _containerTableViewCell;
@synthesize containerCollectionViewCell = _containerCollectionViewCell;
@synthesize containerHeaderFooterView = _containerHeaderFooterView;
@synthesize containerCollectionReusableView = _containerCollectionReusableView;
@synthesize viewIdentifier = _viewIdentifier;
@synthesize userInfo = _userInfo;

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addGestureRecognizer:self.tap];
        [self UIConfig];
    }
    return self;
}

#pragma mark - System Method
- (void)awakeFromNib {
    [super awakeFromNib];
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


- (void)actionTriggeredBy:(UIGestureRecognizer *)sender {
    NSInteger actionType;
    if ([sender isKindOfClass:[UIView class]]) {
        actionType = ((UIView *)sender).tag;
    }
    else {
        actionType = sender.view.tag;
    }
    [self updateActionType:actionType];
}

- (void)updateActionType:(NSInteger)actionType {
    [self updateActionType:actionType userInfo:nil];
}

- (void)updateActionType:(NSInteger)actionType userInfo:(NSDictionary *)userInfo {
    if (self.actionSignalIsPassing) {
        return;
    }
    self.actionSignalIsPassing = YES;
    
    if (self.actionHandleBlock) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[hxActionTypeKey] = @(actionType);
        [dic addEntriesFromDictionary:userInfo];
        self.actionHandleBlock(dic);
    }

    
    self.dataModel.actionType = actionType;
    if (!self.dataModel.delegate) {
        self.dataModel.delegate = self.delegate;
    }

    if (!self.dataModel) {//无model情况下
        SEL sel = NSSelectorFromString([[HXConvenientViewTool customMethodDicWithViewClassName:self.viewIdentifier delegate:self.delegate] objectForKey:@(actionType)]);
        if ([self.delegate respondsToSelector:sel]) {

            [self callTarget:self.delegate sel:sel model:self.dataModel view:self userInfo:userInfo];
            return;
        }
        
        BOOL canRespond = NO;
        //default call
        NSString *defaultHandleStr = [NSString stringWithFormat:@"handle%@Action:userInfo:", self.viewIdentifier];
        SEL defaultHandle = NSSelectorFromString(defaultHandleStr);
        if ([self.delegate respondsToSelector:defaultHandle]) {
            canRespond = YES;
        }
        
        NSString *secondDefaultHandleStr = [NSString stringWithFormat:@"handle%@Action:userInfo:view:", self.viewIdentifier];
        if ([self.delegate respondsToSelector:NSSelectorFromString(secondDefaultHandleStr)]) {
            defaultHandle = NSSelectorFromString(secondDefaultHandleStr);
            canRespond = YES;
        }
        
        if (canRespond) {


            NSMethodSignature *signature = [[self.delegate class] instanceMethodSignatureForSelector:defaultHandle];


            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self.delegate];

            [invocation setSelector:defaultHandle];
            [invocation setArgument:&actionType atIndex:2];
            [invocation setArgument:&userInfo atIndex:3];
            
            if (signature.numberOfArguments == 5) {
                [invocation setArgument:&self atIndex:4];
            }
            [invocation invoke];
        }
        
        self.actionSignalIsPassing = NO;
        return;
    }

    [self _notiDelegateWithUserInfo:userInfo];
    
    self.actionSignalIsPassing = NO;
}

- (void)modelSizeAssignment {
    [self setAvailableModelHeight];
}

- (void)setAvailableModelHeight {
}


- (void)showInView:(UIView *)targetView userInfo:(NSDictionary *)userInfo {
    [self showInView:targetView userInfo:userInfo completion:nil];
}

- (void)showInView:(UIView *)targetView userInfo:(NSDictionary *)userInfo completion:(HXConvenientViewActionHandleBlock)completion {
    self.userInfo = userInfo;
    self.actionHandleBlock = completion;

    [targetView addSubview:self];
       [self mas_makeConstraints:^(MASConstraintMaker *make) {
           make.edges.equalTo(targetView);
    }];

    //蒙层
    [self addSubview:self.alertMaskView];
    [self.alertMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self sendSubviewToBack:self.alertMaskView];

}

- (void)dismiss {
    [self dismissWithShouldSendingActionSignal:NO];
}

- (void)dismissWithShouldSendingActionSignal:(BOOL)send {
    if (send) {
        [self updateActionType:HXBaseConvenientViewActionType_Cancel];
    }
    [self removeFromSuperview];
    self.actionHandleBlock = nil;
}


#pragma mark - Private Method
- (void)_notiDelegateWithUserInfo:(NSDictionary *)userInfo {

    SEL sel = NSSelectorFromString(self.dataModel.delegateHandleMethodStr);
    if ([self.delegate respondsToSelector:sel]) {

        [self callTarget:self.delegate sel:sel model:self.dataModel view:self userInfo:userInfo];
        return;

    }

    NSString *customSwitchMethodStr = [NSString stringWithFormat:@"handleActionIn%@WithModel:view:", self.viewIdentifier];
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
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTriggeredBy:)];
    }
    return _tap;
}

- (id<HXConvenientViewDelegate>)delegate {
    if (!_delegate) {
        _delegate = (id<HXConvenientViewDelegate>)self.hx_ViewController;
    }
    return _delegate;
}

- (NSString *)viewIdentifier {
    if (!_viewIdentifier) {
        _viewIdentifier = NSStringFromClass([self class]);
    }
    return _viewIdentifier;
}


- (UIView *)alertMaskView {
    if (!_alertMaskView) {
        _alertMaskView = [[UIView alloc] init];
        _alertMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    return _alertMaskView;
}

- (UIView *)alertContentView {
    if (!_alertContentView) {
        _alertContentView = [[UIView alloc] init];
        _alertContentView.backgroundColor = [UIColor whiteColor];
    }
    return _alertContentView;
}


#pragma mark - Dealloc

@end

