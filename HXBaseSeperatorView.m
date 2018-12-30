//
//  HXBaseSeperatorView.m
//  ShengXue
//
//  Created by 周义进 on 2018/12/28.
//  Copyright © 2018 DaHuanXiong. All rights reserved.
//

#import "HXBaseSeperatorView.h"

@implementation HXBaseSeperatorView
- (void)bindingModel:(id<HXConvenientViewModelProtocol>)dataModel {
    self.backgroundColor = dataModel.userInfo[hxBackgroundColorKey];
}
@end
