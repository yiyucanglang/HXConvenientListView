//
//  HXConvinenceTableView.m
//  ShengXue
//
//  Created by 周义进 on 2018/12/25.
//  Copyright © 2018 Sea. All rights reserved.
//

#import "HXConvenientTableView.h"
#import "NSObject+HXListConvenient.h"

@interface HXTableViewPropertyInterceptor : NSObject
@property (nonatomic, weak) id originalReceiver;
@property (nonatomic, weak) HXConvenientTableView *middleMan;
@end

@implementation HXTableViewPropertyInterceptor

#pragma mark - System Method
- (BOOL)respondsToSelector:(SEL)aSelector {
    
    if ([NSStringFromSelector(aSelector) containsString:@"heightForRow"] && self.middleMan.openEstimatedCellHeight) {
        return [super respondsToSelector:aSelector];
    }
    
    if ([self.originalReceiver respondsToSelector:aSelector]) {
        return YES;
    }
    if ([self.middleMan respondsToSelector:aSelector]) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
    
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    
    if ([self.originalReceiver respondsToSelector:aSelector]) {
        return self.originalReceiver;
    }
    if ([self.middleMan respondsToSelector:aSelector]) {
        return self.middleMan;
    }
    return self.originalReceiver;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    
    NSString *methodName =NSStringFromSelector(aSelector);
    if ([methodName hasPrefix:@"_"]) {//对私有方法不进行crash日志采集操作
        return nil;
    }
    NSString *crashMessages = [NSString stringWithFormat:@"crashProtect: [%@ %@]: unrecognized selector sent to instance",self,NSStringFromSelector(aSelector)];
    NSMethodSignature *signature = [HXTableViewPropertyInterceptor instanceMethodSignatureForSelector:@selector(crashProtectCollectCrashMessages:)];
    [self crashProtectCollectCrashMessages:crashMessages];
    return signature;//对methodSignatureForSelector 进行重写，不然不会调用forwardInvocation方法
    
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    //将此方法进行重写，在里这不进行任何操作，屏蔽会产生crash的方法调用
}


#pragma mark - Private
- (void)crashProtectCollectCrashMessages:(NSString *)crashMessage{
    
    HXLog(@"%@",crashMessage);
    
}


@end

@interface HXConvenientTableView()
<
    UITableViewDataSource,
    UITableViewDelegate
>
@property (nonatomic, strong) HXTableViewPropertyInterceptor *delegateInterceptor;

@property (nonatomic, strong) HXTableViewPropertyInterceptor *datasourceInterceptor;
@property (nonatomic, assign) BOOL multiSectionsFlag;

@end

@implementation HXConvenientTableView
#pragma mark - Life Cycle

#pragma mark - System Method
- (void)setDataSource:(id<UITableViewDataSource>)dataSource {
    self.datasourceInterceptor.originalReceiver = dataSource;
    [super setDataSource:(id<UITableViewDataSource>)self.datasourceInterceptor];
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate {
    self.delegateInterceptor.originalReceiver = delegate;
    [super setDelegate:(id<UITableViewDelegate>)self.delegateInterceptor];
}

- (void)reloadData {
    self.multiSectionsFlag = NO;
    NSInteger num = 0;
    for (id<HXConvenientTableViewMultiSectionsProtocol> item in self.sourceArr) {
        if (item.isSectionModel) {
            num++;
        }
        else {
            num--;
        }
    }
    if (abs(num) != self.sourceArr.count || num > 0) {
        self.multiSectionsFlag = YES;
    }
    
    [super reloadData];
}

#pragma mark - Public Method


#pragma mark - Private Method

#pragma mark Assist Method
- (id<HXConvenientViewModelProtocol>)_rowModelAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = 0;
    if (self.multiSectionsFlag) {
        
        id<HXConvenientTableViewMultiSectionsProtocol> model = self.sourceArr[indexPath.section];
        if (model.isSectionModel) {
            if ([model respondsToSelector:@selector(setSection:)]) {
                model.section = index;
            }
            if ([model respondsToSelector:@selector(setTableView:)]) {
                model.tableView = self;
            }
            return model.rowsArr[indexPath.row];
        }
        return (id<HXConvenientViewModelProtocol>)model;
    }
    
    return self.sourceArr[indexPath.row];
    
}

- (id<HXConvenientViewModelProtocol>)_sectionModelAtSection:(NSInteger)section head:(BOOL)head {
    
    if (self.sourceArr.count <= section) {
        return nil;
    }
    id<HXConvenientTableViewMultiSectionsProtocol> model = self.sourceArr[section];
    
    if (model.isSectionModel) {
            if (head) {
                return model.headModel;
            }
            return model.footModel;
    }
    return nil;
}




#pragma mark - Delegate
#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.multiSectionsFlag) {
        return self.sourceArr.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.multiSectionsFlag) {
        return self.sourceArr.count;
    }
    
    id<HXConvenientTableViewMultiSectionsProtocol> model = self.sourceArr[section];
    
    if (model.isSectionModel) {
        return model.rowsArr.count;
    }
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self hx_cellWithIndexPath:indexPath dataModel:[self _rowModelAtIndexPath:indexPath] containerCellClass:self.cellContainerClass];
}

#pragma UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self hx_headerFooterViewWithSection:section model:[self _sectionModelAtSection:section head:YES] containerHeaderFooterViewClass:self.headFooterContainerClass];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self hx_headerFooterViewWithSection:section model:[self _sectionModelAtSection:section head:NO] containerHeaderFooterViewClass:self.headFooterContainerClass];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = [self _rowModelAtIndexPath:indexPath].viewHeight;
    if (height <= 0) {
        return self.rowHeight;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat height = [self _sectionModelAtSection:section head:YES].viewHeight;
    
    if (height <= 0 && self.sectionHeaderHeight > 0) {
        return self.sectionHeaderHeight;
    }
    return MAX(height, 0.01);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    CGFloat height = [self _sectionModelAtSection:section head:NO].viewHeight;
    
    if (height <= 0 && self.sectionFooterHeight > 0) {
        return self.sectionFooterHeight;
    }
    return MAX(height, 0.01);
}

#pragma mark - Setter And Getter
- (HXTableViewPropertyInterceptor *)delegateInterceptor {
    if (!_delegateInterceptor) {
        _delegateInterceptor = [[HXTableViewPropertyInterceptor alloc] init];
        _delegateInterceptor.middleMan = self;
    }
    return _delegateInterceptor;
}

- (HXTableViewPropertyInterceptor *)datasourceInterceptor {
    if (!_datasourceInterceptor) {
        _datasourceInterceptor = [[HXTableViewPropertyInterceptor alloc] init];
        _datasourceInterceptor.middleMan = self;
    }
    return _datasourceInterceptor;
}

- (Class)cellContainerClass {
    if (!_cellContainerClass) {
        _cellContainerClass = [UITableViewCell class];
    }
    return _cellContainerClass;
}

- (Class)headFooterContainerClass {
    if (!_headFooterContainerClass) {
        _headFooterContainerClass = [UITableViewHeaderFooterView class];
    }
    return _headFooterContainerClass;
}

- (NSMutableArray *)sourceArr {
    if (!_sourceArr) {
        _sourceArr = [[NSMutableArray alloc] init];
    }
    return _sourceArr;
}

#pragma mark - Dealloc
@end
