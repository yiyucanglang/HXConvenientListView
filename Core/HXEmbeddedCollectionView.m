//
//  HXEmbeddedCollectionView.m
//  ShengXue
//
//  Created by 周义进 on 2018/12/30.
//  Copyright © 2018 DaHuanXiong. All rights reserved.
//

#import "HXEmbeddedCollectionView.h"
#import "HXEmbeddedCollectionViewModel.h"

@interface HXEmbeddedCollectionView()

@end


#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wprotocol"
@implementation HXEmbeddedCollectionView
#pragma clang diagnostic pop


#pragma mark - Life Cycle

#pragma mark - System Method
- (void)layoutSubviews {
    if (self.frame.size.width == self.dataModel.tableView.frame.size.width) {
        [self.collectionView reloadData];
    }
    else if(self.frame.size.width == self.dataModel.collectionView.frame.size.width) {
        [self.collectionView reloadData];
    }
    [super layoutSubviews];
    
}

#pragma mark - Public Method
- (void)bindingModel:(HXEmbeddedCollectionViewModel *)dataModel {
    [super bindingModel:dataModel];
    self.backgroundColor = dataModel.backgroundColor;
    [self configCollectionViewWithModel:dataModel];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    self.collectionView.sourceArr = dataModel.sourceArray;
    
    if (self.frame.size.width == self.dataModel.tableView.frame.size.width) {
        [self.collectionView reloadData];
    }
    else if(self.frame.size.width == self.dataModel.collectionView.frame.size.width) {
        [self.collectionView reloadData];
    }

    if(CGPointEqualToPoint(dataModel.contentOffset, CGPointZero)) {
        self.collectionView.contentOffset = CGPointMake(-dataModel.contentInset.left, -dataModel.contentInset.top);
    }
    else {
        self.collectionView.contentOffset = dataModel.contentOffset;
    }
    
    dataModel.embeddedCollectionView = self.collectionView;
}

#pragma mark - Private Method
- (void)configCollectionViewWithModel:(HXEmbeddedCollectionViewModel *)dataModel {
    if (!self.collectionView) {
        
        UICollectionViewFlowLayout *layout = [[dataModel.customLayoutClass alloc] init];
        self.collectionView = [[HXConvenientCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    if (dataModel.outerHighPriorityGestureRecognizerRelativeToCollectionViewPanGes) {
        [self.collectionView.panGestureRecognizer requireGestureRecognizerToFail:dataModel.outerHighPriorityGestureRecognizerRelativeToCollectionViewPanGes];
    }
    
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.scrollDirection         = dataModel.scrollDirection;
    layout.minimumLineSpacing      = dataModel.minimumLineSpacing;
    layout.minimumInteritemSpacing = dataModel.minimumInteritemSpacing;
    self.collectionView.showsHorizontalScrollIndicator = dataModel.showsHorizontalScrollIndicator;
    self.collectionView.showsVerticalScrollIndicator = dataModel.showsVerticalScrollIndicator;
    self.collectionView.pagingEnabled = dataModel.pagingEnabled;
    self.collectionView.scrollEnabled = dataModel.scrollEnabled;
    self.collectionView.contentInset = dataModel.contentInset;
}

#pragma mark - Delegate
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    ((HXEmbeddedCollectionViewModel *)self.dataModel).contentOffset = scrollView.contentOffset;
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        ((HXEmbeddedCollectionViewModel *)self.dataModel).contentOffset = scrollView.contentOffset;
    }
}


#pragma mark - Setter And Getter

#pragma mark - Dealloc


@end
