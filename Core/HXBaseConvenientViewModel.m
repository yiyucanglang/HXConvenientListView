//
//  HXBaseTableViewCellModel.m
//  ShengXue
//
//  Created by 周义进 on 2018/12/11.
//  Copyright © 2018 Sea. All rights reserved.
//

#import "HXBaseConvenientViewModel.h"

@implementation HXBaseConvenientViewModel
@synthesize actionType = _actionType;
@synthesize delegate   = _delegate;
@synthesize forbiddenCustomTap = _forbiddenCustomTap;
@synthesize userInfo   = _userInfo;
@synthesize viewClassName = _viewClassName;
@synthesize viewHeight = _viewHeight;
@synthesize viewWidth  = _viewWidth;

@synthesize delegateHandleMethodStr   = _delegateHandleMethodStr;
@synthesize associatedObject = _associatedObject;
@synthesize identifier = _identifier;
@synthesize cellSelectionStyle  = _cellSelectionStyle;
@synthesize indexPath   = _indexPath;
@synthesize section     = _section;
@synthesize tableView   = _tableView;
@synthesize collectionView   = _collectionView;
@synthesize customData    = _customData;
@synthesize associatedView    = _associatedView;

#pragma mark - Life Cycle
- (instancetype)init {
    if (self = [super init]) {
        self.viewWidth = [UIScreen mainScreen].bounds.size.width;
    }
    return self;
}

#pragma mark - System Method

#pragma mark - Public Method
+ (instancetype)model {
    return [[[self class] alloc] init];
}

- (void)autoCalculateHeight {
    
    [self autoCalculateHeightWithSpecificFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
}

- (void)autoCalculateHeightWithSpecificFrame:(CGRect)frame {
    
    self.viewHeight = 0;
    
    static id<HXConvenientViewProtocol> view;
    Class class = NSClassFromString(self.viewClassName);
    if (!view || ![view isKindOfClass:class]) {
        view = [[NSClassFromString(self.viewClassName) alloc] initWithFrame:frame];
    }
    [view bindingModel:self];
}

#pragma mark - Private Method

#pragma mark - Delegate

#pragma mark - Setter And Getter

- (NSString *)delegateHandleMethodStr {
    if (_delegateHandleMethodStr.length) {
        return _delegateHandleMethodStr;
    }
    return   [[HXConvenientViewTool customMethodDicWithViewClassName:self.viewClassName delegate:self.delegate] objectForKey:@(self.actionType)];
}

#pragma mark - Dealloc

@end
