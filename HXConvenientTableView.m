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
    
//    [self printSel:aSelector];
    
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

- (void)printSel:(SEL)sel {
//    NSString *selStr = NSStringFromSelector(sel);
//    if([self.middleMan respondsToSelector:sel]) {
//        HXLog(@"call method:%@", selStr);
//    }
}

@end

@interface HXConvenientTableView()
<
    UITableViewDataSource,
    UITableViewDelegate
>
@property (nonatomic, strong) HXTableViewPropertyInterceptor *delegateInterceptor;

@property (nonatomic, strong) id<UITableViewDelegate> innerDelegate;

@property (nonatomic, strong) id<UITableViewDataSource> innerDatasource;

@property (nonatomic, strong) HXTableViewPropertyInterceptor *datasourceInterceptor;
@end

@implementation HXConvenientTableView
#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.innerDelegate = (id<UITableViewDelegate>)[NSObject new];
        self.innerDatasource = (id<UITableViewDataSource>)[NSObject new];
        self.dataSource = self.innerDatasource;
        self.delegate   = self.innerDelegate;
    }
    return self;
}

#pragma mark - System Method
- (void)setDataSource:(id<UITableViewDataSource>)dataSource {
    self.datasourceInterceptor.originalReceiver = dataSource;
    [super setDataSource:(id<UITableViewDataSource>)self.datasourceInterceptor];
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate {
    self.delegateInterceptor.originalReceiver = delegate;
    [super setDelegate:(id<UITableViewDelegate>)self.delegateInterceptor];
}

- (void)setEstimatedRowHeight:(CGFloat)estimatedRowHeight {
    HXLog(@"-------------------set estimatedRowHeight");
    [super setEstimatedRowHeight:estimatedRowHeight];
}

#pragma mark - Public Method
- (void)reloadData {
    HXLog(@"---------------call reloaddata");
    [super reloadData];
}

#pragma mark - Private Method
- (BOOL)multiSection {
    if (self.sourceArr.count && [self.sourceArr[0] conformsToProtocol:@protocol(HXConvenientTableViewMultiSectionsProtocol)]) {
        return YES;
    }
    return NO;
}

#pragma mark Assist Method
- (NSInteger)sectionNum {
    if (self.multiSection) {
        return self.sourceArr.count;
    }
    return 1;
}

- (NSInteger)rowNumAtIndex:(NSInteger)index {
    if (self.multiSection) {
        id<HXConvenientTableViewMultiSectionsProtocol> model = self.sourceArr[index];
        return model.rowsArr.count;
    }
    return self.sourceArr.count;
}

- (id<HXConvenientViewModelProtocol>)rowModelAtIndexPath:(NSIndexPath *)indexPath {
    if (self.multiSection) {
        id<HXConvenientTableViewMultiSectionsProtocol> model = self.sourceArr[indexPath.section];
        return  model.rowsArr[indexPath.row];
    }
    return self.sourceArr[indexPath.row];
}

- (id<HXConvenientViewModelProtocol>)sectionModelAtSection:(NSInteger)section head:(BOOL)head {
    if (self.multiSection) {
        if (self.sourceArr.count > section) {
            id<HXConvenientTableViewMultiSectionsProtocol> model = self.sourceArr[section];
            if (head) {
                return model.headModel;
            }
            return model.footModel;
        }
    }
    return nil;
}



#pragma mark - Delegate
#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    HXLog(@"------------------- numberOfSectionsInTableView");
    return [self sectionNum];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HXLog(@"------------------- numberOfRowsInSection");
    return [self rowNumAtIndex:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXLog(@"------------------- cellForRowAtIndexPath: section:%@ row:%@",@(indexPath.section), @(indexPath.row));
    return [self hx_cellWithIndexPath:indexPath dataModel:[self rowModelAtIndexPath:indexPath] containerCellClass:self.cellContainerClass];
}

#pragma UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self hx_headerFooterViewWithSection:section model:[self sectionModelAtSection:section head:YES] containerHeaderFooterViewClass:self.headFooterContainerClass];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self hx_headerFooterViewWithSection:section model:[self sectionModelAtSection:section head:NO] containerHeaderFooterViewClass:self.headFooterContainerClass];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [self rowModelAtIndexPath:indexPath].viewHeight;
    HXLog(@"------rowheight:%@------------- height:%@", @(self.rowHeight), @(height));
    
    if (height <= 0) {
        return self.rowHeight;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat height = [self sectionModelAtSection:section head:YES].viewHeight;
    
    if (height <= 0 && self.sectionHeaderHeight > 0) {
        return self.sectionHeaderHeight;
    }
    return MAX(height, 0.01);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    CGFloat height = [self sectionModelAtSection:section head:NO].viewHeight;
    
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
