//
//  HXBaseConvenientMultiSectionModel.m
//  ShengXue
//
//  Created by 周义进 on 2018/12/26.
//  Copyright © 2018 DaHuanXiong. All rights reserved.
//

#import "HXBaseConvenientMultiSectionModel.h"

@implementation HXBaseConvenientMultiSectionModel
@synthesize headModel        = _headModel;
@synthesize footModel        = _footModel;
@synthesize rowsArr          = _rowsArr;
@synthesize section          = _section;
@synthesize tableView        = _tableView;
@synthesize collectionView   = _collectionView;
#pragma mark - Life Cycle
+ (instancetype)model {
    return [[[self class] alloc] init];
}
#pragma mark - System Method

#pragma mark - Public Method

#pragma mark - Private Method

#pragma mark - Delegate

#pragma mark - Setter And Getter
- (NSMutableArray<id<HXConvenientViewModelProtocol>> *)rowsArr {
    if (!_rowsArr) {
        _rowsArr = [[NSMutableArray alloc] init];
    }
    return _rowsArr;
}

#pragma mark - Dealloc

@end
