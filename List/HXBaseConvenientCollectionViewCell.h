//
//  SXBaseConvenientCollectionViewCell.h
//  ShengXue
//
//  Created by 周义进 on 2018/12/30.
//  Copyright © 2018 DaHuanXiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXViewConvenientProtocol.h"

//customSwitchMethod = [NSString stringWithFormat:@"handleActionIn%@WithModel:view:", NSStringFromClass([self class])];

/*
 Attention:触发delegate方法顺序说明 假设下面call的方法delegate都已实现
 
 call  data.model.delegateHandleMethodStr
 call  customSwitchMethod
 call  <HXConvenientViewDelegate>
 
 */

NS_ASSUME_NONNULL_BEGIN

@interface HXBaseConvenientCollectionViewCell : UICollectionViewCell<HXConvenientViewProtocol>

@property (nonatomic, strong) NSString     *viewIdentifier;


- (void)bindingModel:(id<HXConvenientViewModelProtocol>)dataModel;
@end

NS_ASSUME_NONNULL_END
