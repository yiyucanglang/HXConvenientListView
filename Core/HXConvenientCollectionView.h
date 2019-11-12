//
//  HXConvenientCollectionView.h
//  ShengXue
//
//  Created by 周义进 on 2018/12/30.
//  Copyright © 2018 DaHuanXiong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXConvenientCollectionView : UICollectionView

/**
 this must set before delegate or datasource set
 default: UICollectionViewCell
 */
@property (nonatomic, strong) Class cellContainerClass;
//as above default: UICollectionReusableView
@property (nonatomic, strong) Class reusableViewContainerClass;

@property (nonatomic, strong) NSMutableArray *sourceArr;

/**
 忽略控件默认实现的UICollectionViewDelegateFlowLayout协议的方法，this must set before set datasource and delegate
 */
@property (nonatomic, assign) BOOL ignoreTheDefaultProxyMethodForUICollectionViewDelegateFlowLayout;
@end

NS_ASSUME_NONNULL_END
