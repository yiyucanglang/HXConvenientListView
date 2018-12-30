//
//  UITableViewCell+HXInit.h
//  ShengXue
//
//  Created by 周义进 on 2018/12/11.
//  Copyright © 2018 Sea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXViewConvenientProtocol.h"
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HXListConvenient)
- (UIView *)hx_createViewWithNibName:(NSString *)nibName;
@end

@interface UITableView (HXListConvenient)
//containerCellClass:UITableViewCell
- (UITableViewCell *)hx_cellWithIndexPath:(NSIndexPath *)indexPath dataModel:(id<HXConvenientViewModelProtocol>)model;

//containerHeaderFooterViewClass:UITableViewHeaderFooterView
- (UITableViewHeaderFooterView *)hx_headerFooterViewWithSection:(NSInteger)section model: (id<HXConvenientViewModelProtocol>)model;


- (UITableViewCell *)hx_cellWithIndexPath:(NSIndexPath *)indexPath dataModel:(id<HXConvenientViewModelProtocol>)model containerCellClass:(Class)containerCellClass;

- (UITableViewHeaderFooterView *)hx_headerFooterViewWithSection:(NSInteger)section model: (id<HXConvenientViewModelProtocol>)model containerHeaderFooterViewClass:(Class)containerHeaderFooterViewClass;
@end

@interface UICollectionView (HXListConvenient)

//containerCellClass:UICollectionViewCell
- (UICollectionViewCell *)hx_cellForItemAtIndexPath:(NSIndexPath *)indexPath dataModel:(id<HXConvenientViewModelProtocol>)model;

//containerReusableViewClass:UICollectionReusableView
- (UICollectionReusableView *)hx_viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath dataModel:(id<HXConvenientViewModelProtocol>)model;


- (UICollectionViewCell *)hx_cellForItemAtIndexPath:(NSIndexPath *)indexPath dataModel:(id<HXConvenientViewModelProtocol>)model containerCellClass:(Class)containerCellClass;

- (UICollectionReusableView *)hx_viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath dataModel:(id<HXConvenientViewModelProtocol>)model containerReusableViewClass:(Class)containerReusableViewClass;

@end

NS_ASSUME_NONNULL_END
