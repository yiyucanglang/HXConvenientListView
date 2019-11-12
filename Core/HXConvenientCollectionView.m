//
//  HXConvenientCollectionView.m
//  ShengXue
//
//  Created by 周义进 on 2018/12/30.
//  Copyright © 2018 DaHuanXiong. All rights reserved.
//

#import "HXConvenientCollectionView.h"
#import "NSObject+HXListConvenient.h"

@interface HXCollectionViewPropertyInterceptor : NSObject
@property (nonatomic, weak) id originalReceiver;
@property (nonatomic, weak) HXConvenientCollectionView *middleMan;
@end

@implementation HXCollectionViewPropertyInterceptor

#pragma mark - System Method
- (BOOL)respondsToSelector:(SEL)aSelector {
    
    if ([NSStringFromSelector(aSelector) containsString:@"collectionView:layout:"] && self.middleMan.ignoreTheDefaultProxyMethodForUICollectionViewDelegateFlowLayout) {
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
    NSMethodSignature *signature = [HXCollectionViewPropertyInterceptor instanceMethodSignatureForSelector:@selector(crashProtectCollectCrashMessages:)];
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

@interface HXConvenientCollectionView()
<
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>
@property (nonatomic, strong) HXCollectionViewPropertyInterceptor *delegateInterceptor;
@property (nonatomic, strong) HXCollectionViewPropertyInterceptor *datasourceInterceptor;

@end

@implementation HXConvenientCollectionView
#pragma mark - Life Cycle

#pragma mark - System Method
- (void)setDataSource:(id<UICollectionViewDataSource>)dataSource {
    self.datasourceInterceptor.originalReceiver = dataSource;
    [super setDataSource:(id<UICollectionViewDataSource>)self.datasourceInterceptor];
}

- (void)setDelegate:(id<UICollectionViewDelegate>)delegate {
    self.delegateInterceptor.originalReceiver = delegate;
    [super setDelegate:(id<UICollectionViewDelegate>)self.delegateInterceptor];
}

#pragma mark - Public Method
- (void)reloadData {
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
        if ([model respondsToSelector:@selector(setSection:)]) {
            model.section = index;
        }
        if ([model respondsToSelector:@selector(setCollectionView:)]) {
            model.collectionView = self;
        }

    
        return model.rowsArr.count;
    }
    return self.sourceArr.count;
}

- (id<HXConvenientViewModelProtocol>)rowModelAtIndexPath:(NSIndexPath *)indexPath {
    if (self.multiSection) {
        id<HXConvenientTableViewMultiSectionsProtocol> model = self.sourceArr[indexPath.section];
        return  model.rowsArr[indexPath.item];
    }
    return self.sourceArr[indexPath.item];
}

- (id<HXConvenientViewModelProtocol>)sectionModelAtSection:(NSInteger)section kind:(NSString *)kind {
    if (self.multiSection) {
        if (self.sourceArr.count > section) {
            id<HXConvenientTableViewMultiSectionsProtocol> model = self.sourceArr[section];
            if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
                return model.headModel;
            }
            return model.footModel;
        }
    }
    return nil;
}



#pragma mark - Delegate
#pragma UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self sectionNum];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self rowNumAtIndex:section];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self hx_cellForItemAtIndexPath:indexPath dataModel:[self rowModelAtIndexPath:indexPath] containerCellClass:self.cellContainerClass];
}


#pragma UITableViewDelegate
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    return [self hx_viewForSupplementaryElementOfKind:kind atIndexPath:indexPath dataModel:[self sectionModelAtSection:indexPath.section kind:kind] containerReusableViewClass:self.reusableViewContainerClass];
}

#pragma mark -UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    id<HXConvenientViewModelProtocol> model = [self rowModelAtIndexPath:indexPath];
    if (model.viewHeight <= 0) {
        return ((UICollectionViewFlowLayout *)self.collectionViewLayout).itemSize;
    }
    return CGSizeMake(model.viewWidth, model.viewHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    id<HXConvenientViewModelProtocol> model = [self sectionModelAtSection:section kind:UICollectionElementKindSectionHeader];
    return CGSizeMake(model.viewWidth, model.viewHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    id<HXConvenientViewModelProtocol> model = [self sectionModelAtSection:section kind:UICollectionElementKindSectionFooter];
    return CGSizeMake(model.viewWidth, model.viewHeight);
}

#pragma mark - Setter And Getter
- (HXCollectionViewPropertyInterceptor *)delegateInterceptor {
    if (!_delegateInterceptor) {
        _delegateInterceptor = [[HXCollectionViewPropertyInterceptor alloc] init];
        _delegateInterceptor.middleMan = self;
    }
    return _delegateInterceptor;
}

- (HXCollectionViewPropertyInterceptor *)datasourceInterceptor {
    if (!_datasourceInterceptor) {
        _datasourceInterceptor = [[HXCollectionViewPropertyInterceptor alloc] init];
        _datasourceInterceptor.middleMan = self;
    }
    return _datasourceInterceptor;
}

- (Class)cellContainerClass {
    if (!_cellContainerClass) {
        _cellContainerClass = [UICollectionViewCell class];
    }
    return _cellContainerClass;
}

- (Class)reusableViewContainerClass {
    if (!_reusableViewContainerClass) {
        _reusableViewContainerClass = [UICollectionReusableView class];
    }
    return _reusableViewContainerClass;
}

- (NSMutableArray *)sourceArr {
    if (!_sourceArr) {
        _sourceArr = [[NSMutableArray alloc] init];
    }
    return _sourceArr;
}
@end
