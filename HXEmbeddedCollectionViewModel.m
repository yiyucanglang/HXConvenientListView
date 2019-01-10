//
//  HXEmbeddedCollectionViewModel.m
//  ShengXue
//
//  Created by 周义进 on 2018/12/30.
//  Copyright © 2018 DaHuanXiong. All rights reserved.
//

#import "HXEmbeddedCollectionViewModel.h"

@implementation HXEmbeddedCollectionViewModel
#pragma mark - Life Cycle
- (instancetype)init {
    if (self = [super init]) {
        self.viewClassName = @"HXEmbeddedCollectionView";
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.scrollEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
        self.customLayoutClass = [UICollectionViewFlowLayout class];
        self.contentInset = UIEdgeInsetsZero;
    }
    return self;
}

#pragma mark - System Method

#pragma mark - Public Method

#pragma mark - Private Method

#pragma mark - Delegate

#pragma mark - Setter And Getter
- (NSMutableArray *)sourceArray
{
    if (!_sourceArray)
    {
        _sourceArray = [NSMutableArray array];
    }
    return _sourceArray;
}

#pragma mark - Dealloc

@end
