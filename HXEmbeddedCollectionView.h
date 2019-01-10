//
//  HXEmbeddedCollectionView.h
//  ShengXue
//
//  Created by 周义进 on 2018/12/30.
//  Copyright © 2018 DaHuanXiong. All rights reserved.
//

#import "HXBaseConvenientView.h"
#import "HXConvenientCollectionView.h"
NS_ASSUME_NONNULL_BEGIN

@interface HXEmbeddedCollectionView : HXBaseConvenientView
<
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
@property (nonatomic, strong) HXConvenientCollectionView *collectionView;
@end

NS_ASSUME_NONNULL_END
