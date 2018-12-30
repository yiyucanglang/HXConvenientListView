//
//  UITableViewCell+HXInit.m
//  ShengXue
//
//  Created by 周义进 on 2018/12/11.
//  Copyright © 2018 Sea. All rights reserved.
//

#import "NSObject+HXListConvenient.h"

@implementation NSObject (HXListConvenient)
- (UIView *)hx_createViewWithNibName:(NSString *)nibName {
    UIView *view;
    @try {
        view = [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] firstObject];
    } @catch (NSException *exception) {
        view =  nil;
    }
    return view;
}

- (NSString *)hx_identifierWithModel:(id<HXConvenientViewModelProtocol>)model {
    if (model.identifier.length) {
        return model.identifier;
    }
    return model.viewClassName;
}

@end

@implementation UITableView (HXListConvenient)
#pragma mark - Life Cycle

#pragma mark - System Method

#pragma mark - Public Method
- (UITableViewCell *)hx_cellWithIndexPath:(NSIndexPath *)indexPath dataModel:(id<HXConvenientViewModelProtocol>)model {
    return [self hx_cellWithIndexPath:indexPath dataModel:model containerCellClass:[UITableViewCell class]];
}

- (UITableViewCell *)hx_cellWithIndexPath:(NSIndexPath *)indexPath dataModel:(id<HXConvenientViewModelProtocol>)model containerCellClass:(Class)containerCellClass {
    if(!model) {
        return nil;
    }
    Class viewClass = NSClassFromString(model.viewClassName);
    if ([model respondsToSelector:@selector(setTableView:)]) {
        model.tableView = self;
    }
    if ([model respondsToSelector:@selector(setIndexPath:)]) {
        model.indexPath = indexPath;
    }
    
    
    if ([viewClass isSubclassOfClass:[UITableViewCell class]]) {
        id<HXConvenientViewProtocol> cell = [self dequeueReusableCellWithIdentifier:[self hx_identifierWithModel:model]];
        if (!cell) {
            cell = (id<HXConvenientViewProtocol>)[self hx_createViewWithNibName:model.viewClassName];
            if (!cell) {
                cell = (id<HXConvenientViewProtocol>)[((UITableViewCell *)[viewClass alloc]) initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self hx_identifierWithModel:model]];
            }
        }
        
        ((UITableViewCell *)cell).selectionStyle = model.cellSelectionStyle;
        
        [cell bindingModel:model];
        return (UITableViewCell *)cell;
    }
    
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:[self hx_identifierWithModel:model]];
    if (!cell) {
        cell = [((UITableViewCell *)[containerCellClass alloc]) initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self hx_identifierWithModel:model]];
    }
    cell.selectionStyle = model.cellSelectionStyle;
    UIView *content = [cell.contentView viewWithTag:95278888];
    if (content == nil)
    {
        content = [self hx_createViewWithNibName:model.viewClassName];
        if(content == nil)
            content = [[viewClass alloc] init];
        [cell.contentView addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
        content.tag   = 95278888;
    }
    [((id<HXConvenientViewProtocol>)content) bindingModel:model];
    return cell;
}

- (UITableViewHeaderFooterView *)hx_headerFooterViewWithSection:(NSInteger)section model:(id<HXConvenientViewModelProtocol>)model {
    return [self hx_headerFooterViewWithSection:section model:model containerHeaderFooterViewClass:[UITableViewHeaderFooterView class]];
}

- (UITableViewHeaderFooterView *)hx_headerFooterViewWithSection:(NSInteger)section model:(id<HXConvenientViewModelProtocol>)model containerHeaderFooterViewClass:(Class)containerHeaderFooterViewClass {
    if(!model) {
        return nil;
    }
    Class viewClass = NSClassFromString(model.viewClassName);
    if ([model respondsToSelector:@selector(setTableView:)]) {
        model.tableView = self;
    }
    if ([model respondsToSelector:@selector(setSection:)]) {
        model.section = section;
    }
    
    if ([viewClass isSubclassOfClass:[UITableViewHeaderFooterView class]]) {
        id<HXConvenientViewProtocol> view = [self dequeueReusableHeaderFooterViewWithIdentifier:[self hx_identifierWithModel:model]];
        if (!view) {
            view = (id<HXConvenientViewProtocol>)[self hx_createViewWithNibName:model.viewClassName];
            if (!view) {
                view = (id<HXConvenientViewProtocol>)[((UITableViewHeaderFooterView *)[viewClass alloc]) initWithReuseIdentifier:[self hx_identifierWithModel:model]];
            }
        }
        model.tableView = self;
        model.section = section;
        [view bindingModel:model];
        return (UITableViewHeaderFooterView *)view;
    }
    
    UITableViewHeaderFooterView *view = [self dequeueReusableHeaderFooterViewWithIdentifier:[self hx_identifierWithModel:model]];
    if (!view) {
        view = [((UITableViewHeaderFooterView *)[containerHeaderFooterViewClass alloc]) initWithReuseIdentifier:[self hx_identifierWithModel:model]];
    }
    UIView *content = [view.contentView viewWithTag:95278888];
    if (content == nil)
    {
        content = [self hx_createViewWithNibName:model.viewClassName];
        if(content == nil)
            content = [[viewClass alloc] init];
        [view.contentView addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view.contentView);
        }];
        content.tag   = 95278888;
    }
    [((id<HXConvenientViewProtocol>)content) bindingModel:model];
    return view;
}


#pragma mark - Private Method

#pragma mark - Delegate

#pragma mark - Setter And Getter

#pragma mark - Dealloc

@end

@implementation UICollectionView (HXListConvenient)
- (UICollectionViewCell *)hx_cellForItemAtIndexPath:(NSIndexPath *)indexPath dataModel:(id<HXConvenientViewModelProtocol>)model {
    return [self hx_cellForItemAtIndexPath:indexPath dataModel:model containerCellClass:[UICollectionViewCell class]];
}

- (UICollectionViewCell *)hx_cellForItemAtIndexPath:(NSIndexPath *)indexPath dataModel:(id<HXConvenientViewModelProtocol>)model containerCellClass:(Class)containerCellClass {
    
    if(!model) {
        return nil;
    }
    
    Class viewClass = NSClassFromString(model.viewClassName);
    if ([model respondsToSelector:@selector(setCollectionView:)]) {
        model.collectionView = self;
    }
    if ([model respondsToSelector:@selector(setIndexPath:)]) {
        model.indexPath = indexPath;
    }
    
    [self registerCellWithModel:model containerCellClass:containerCellClass];
    
    UICollectionViewCell <HXConvenientViewProtocol> *cell = [self dequeueReusableCellWithReuseIdentifier:[self hx_identifierWithModel:model] forIndexPath:indexPath];
    
    if ([viewClass isSubclassOfClass:[UICollectionViewCell class]]) {
        
        [cell bindingModel:model];
        return (UICollectionViewCell *)cell;
    }
    
    
    
    UIView *content = [cell.contentView viewWithTag:95278888];
    if (content == nil)
    {
        content = [self hx_createViewWithNibName:model.viewClassName];
        if(content == nil)
            content = [[viewClass alloc] init];
        [cell.contentView addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
        content.tag   = 95278888;
    }
    [((id<HXConvenientViewProtocol>)content) bindingModel:model];
    return cell;
}

- (UICollectionReusableView *)hx_viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath dataModel:(id<HXConvenientViewModelProtocol>)model {
    return [self hx_viewForSupplementaryElementOfKind:kind atIndexPath:indexPath dataModel:model containerReusableViewClass:[UICollectionReusableView class]];
}

- (UICollectionReusableView *)hx_viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath dataModel:(nonnull id<HXConvenientViewModelProtocol>)model containerReusableViewClass:(nonnull Class)containerReusableViewClass {
    
    if(!model) {
        return nil;
    }
    
    Class viewClass = NSClassFromString(model.viewClassName);
    if ([model respondsToSelector:@selector(setCollectionView:)]) {
        model.collectionView = self;
    }
    if ([model respondsToSelector:@selector(setIndexPath:)]) {
        model.indexPath = indexPath;
    }
    
    [self registerReusableViewWithModel:model kind:kind containerReusableViewClass:containerReusableViewClass];
    
    UICollectionReusableView <HXConvenientViewProtocol> *cell = [self dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self hx_identifierWithModel:model] forIndexPath:indexPath];
    
    if ([viewClass isSubclassOfClass:[UICollectionReusableView class]]) {
        
        [cell bindingModel:model];
        return cell;
    }
    
    
    UIView *content = [cell viewWithTag:95278888];
    if (content == nil)
    {
        content = [self hx_createViewWithNibName:model.viewClassName];
        if(content == nil)
            content = [[viewClass alloc] init];
        [cell addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell);
        }];
        content.tag   = 95278888;
    }
    [((id<HXConvenientViewProtocol>)content) bindingModel:model];
    return cell;
}

#pragma mark -Private
- (BOOL)nibFileExitWihtNibName:(NSString *)nibName {
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"];
    if (nibPath.length) {
        return YES;
    }
    return NO;
}

- (void)registerCellWithModel:(id<HXConvenientViewModelProtocol>)model
               containerCellClass:(Class)containerCellClass {
    
    Class viewClass = NSClassFromString(model.viewClassName);
    
    if ([viewClass isSubclassOfClass:[UICollectionViewCell class]]) {
        
        if ([self nibFileExitWihtNibName:model.viewClassName]) {
            [self registerNib:[UINib nibWithNibName:model.viewClassName bundle:nil] forCellWithReuseIdentifier:[self hx_identifierWithModel:model]];
        }
        else {
            [self registerClass:viewClass forCellWithReuseIdentifier:[self hx_identifierWithModel:model]];
        }
    }
    else {
        [self registerClass:containerCellClass forCellWithReuseIdentifier:[self hx_identifierWithModel:model]];
    }
    
}

- (void)registerReusableViewWithModel:(id<HXConvenientViewModelProtocol>)model
                                     kind:(NSString *)kind
               containerReusableViewClass:(Class)reusableViewClass {
    
    Class viewClass = NSClassFromString(model.viewClassName);
    
    if ([viewClass isSubclassOfClass:[UICollectionReusableView class]]) {
        
        if ([self nibFileExitWihtNibName:model.viewClassName]) {
            [self registerNib:[UINib nibWithNibName:model.viewClassName bundle:nil] forSupplementaryViewOfKind:kind withReuseIdentifier:[self hx_identifierWithModel:model]];
        }
        else {
            [self registerClass:viewClass forSupplementaryViewOfKind:kind withReuseIdentifier:[self hx_identifierWithModel:model]];
        }
    }
    else {
        [self registerClass:reusableViewClass forSupplementaryViewOfKind:kind withReuseIdentifier:[self hx_identifierWithModel:model]];
    }
    
}

@end
