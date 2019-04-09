//
//  HXBaseTableViewCellModel.h
//  ShengXue
//
//  Created by 周义进 on 2018/12/11.
//  Copyright © 2018 Sea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXViewConvenientProtocol.h"
#import "HXConvenientViewTool.h"
NS_ASSUME_NONNULL_BEGIN

@interface HXBaseConvenientViewModel < T > : NSObject<HXConvenientViewModelProtocol>

@property (nonatomic, strong) T customData;
@end

NS_ASSUME_NONNULL_END
