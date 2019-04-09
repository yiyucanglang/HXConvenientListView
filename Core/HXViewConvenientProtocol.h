//
//  HXViewConvinienceProtocol.h
//  ShengXue
//
//  Created by 周义进 on 2018/12/25.
//  Copyright © 2018 Sea. All rights reserved.
//

#ifndef HXViewConvinienceProtocol_h
#define HXViewConvinienceProtocol_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Masonry/Masonry.h>

#if 0

#define HXLog(...) NSLog(@"%@",[NSString stringWithFormat:__VA_ARGS__])
#else
#define HXLog(...)

#endif

//common key
static NSString * const hxBackgroundColorKey = @"BackgroundColorKey";
static NSString * const hxImageKey   = @"ImageKey";
static NSString * const hxTitleKey   = @"TitleKey";
static NSString * const hxNameKey    = @"NameKey";
static NSString * const hxContentKey = @"ContentKey";
static NSString * const hxTimeKey    = @"TimeKey";

@protocol HXConvenientViewModelProtocol;
@protocol HXConvenientViewDelegate;

@protocol HXConvenientViewProtocol <NSObject>
@property (nonatomic, strong, readonly) id<HXConvenientViewModelProtocol> dataModel;
@property (nonatomic, weak) id<HXConvenientViewDelegate> delegate;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

- (void)UIConfig;

- (void)bindingModel:(id<HXConvenientViewModelProtocol>)dataModel;

- (void)updateActionType:(NSInteger)actionType;

- (void)updateActionType:(NSInteger)actionType userInfo:(NSDictionary *)userInfo;

@optional

- (void)setAvailableModelHeight;

@property (nonatomic, weak) UITableViewCell *containerTableViewCell;

@property (nonatomic, weak) UICollectionViewCell *containerCollectionViewCell;

@property (nonatomic, weak) UITableViewHeaderFooterView *containerHeaderFooterView;

@property (nonatomic, weak) UICollectionReusableView     *containerCollectionReusableView;

@end


@protocol HXConvenientViewModelProtocol <NSObject>
@property (nonatomic, copy) NSString     *viewClassName;
@property (nonatomic, assign) CGFloat     viewWidth;
@property (nonatomic, assign) CGFloat     viewHeight;
@property (nonatomic, weak) id<HXConvenientViewDelegate>         delegate;
@property (nonatomic, assign) NSInteger       actionType;
@property (nonatomic, assign) BOOL forbiddenCustomTap;
@property (nonatomic, strong) NSDictionary *userInfo;


@optional

/**
 配置代理对象指定delegate方法,不配置走<HXConvenientViewDelegate>方法
 @warning delegate方法必须包含两个参数，前一个model,后一个view
 */
@property (nonatomic, copy) NSString     *delegateHandleMethodStr;

//for expand
@property (nonatomic, weak) id                associatedObject;

//default:viewClassName
@property (nonatomic, copy) NSString *identifier;

//for UITableView
@property (nonatomic, assign) UITableViewCellSelectionStyle cellSelectionStyle;
@property (nonatomic, strong) NSIndexPath    *indexPath;
@property (nonatomic, assign) NSInteger       section;
@property (nonatomic, weak) UITableView      *tableView;

//for UICollectionView
@property (nonatomic, weak) UICollectionView      *collectionView;

+ (instancetype)model;

- (void)autoCalculateHeight;
@end

@protocol HXConvenientTableViewMultiSectionsProtocol <NSObject>
@property (nonatomic, strong) id<HXConvenientViewModelProtocol> headModel;

@property (nonatomic, strong) id<HXConvenientViewModelProtocol> footModel;

@property (nonatomic, strong) NSMutableArray<id<HXConvenientViewModelProtocol >> *rowsArr;

@property (nonatomic, assign) NSInteger       section;

+ (instancetype)model;

@end


@protocol HXConvenientViewDelegate <NSObject>

@optional
- (void)handleActionInView:(id<HXConvenientViewProtocol>)view
                     model:(id<HXConvenientViewModelProtocol>)model;

@end


#endif /* HXViewConvinienceProtocol_h */
