//
//  HXEmbeddedCollectionViewModel.h
//  ShengXue
//
//  Created by 周义进 on 2018/12/30.
//  Copyright © 2018 DaHuanXiong. All rights reserved.
//

#import "HXBaseConvenientViewModel.h"
#import "HXEmbeddedCollectionView.h"
NS_ASSUME_NONNULL_BEGIN

@interface HXEmbeddedCollectionViewModel : HXBaseConvenientViewModel

@property (nonatomic, strong) NSMutableArray *sourceArray;

@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

@property (nonatomic, assign) UIEdgeInsets contentInset;

/**
 default UICollectionViewScrollDirectionHorizontal
 */
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

@property (nonatomic, assign) CGPoint  contentOffset;

@property (nonatomic, assign) BOOL     pagingEnabled;
@property (nonatomic, assign) BOOL     showsHorizontalScrollIndicator;
@property (nonatomic, assign) BOOL     showsVerticalScrollIndicator;
@property (nonatomic, assign) BOOL     scrollEnabled;
@property (nonatomic, strong) UIColor *backgroundColor;

//default:UICollectionViewFlowLayout
@property (nonatomic, strong) Class    customLayoutClass;

@property (nonatomic, assign) BOOL ignoreTheDefaultProxyMethodForUICollectionViewDelegateFlowLayout DEPRECATED_ATTRIBUTE;

@property (nonatomic, weak) UICollectionView      *embeddedCollectionView;

@property (nonatomic, weak) UIGestureRecognizer *outerHighPriorityGestureRecognizerRelativeToCollectionViewPanGes;
@end

NS_ASSUME_NONNULL_END
