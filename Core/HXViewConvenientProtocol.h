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

#pragma mark -Convenient Key
static NSString * const hxBackgroundColorKey = @"BackgroundColorKey";
static NSString * const hxImageKey           = @"ImageKey";
static NSString * const hxTitleKey           = @"TitleKey";
static NSString * const hxNameKey            = @"NameKey";
static NSString * const hxContentKey         = @"ContentKey";
static NSString * const hxNoteKey            = @"NoteKey";
static NSString * const hxTimeKey            = @"TimeKey";
static NSString * const hxURLKey             = @"URLKey";
static NSString * const hxFileKey            = @"FileKey";
static NSString * const hxCustomKey          = @"CustomKey";
static NSString * const hxModelKey           = @"Model";
static NSString * const hxDataKey            = @"Data";
static NSString * const hxUserInfoKey        = @"UserInfo";
static NSString * const hxMessageKey         = @"Message";
static NSString * const hxActionTypeKey      = @"ActionType";

#pragma mark -
@protocol HXConvenientViewModelProtocol;
@protocol HXConvenientViewDelegate;

@protocol HXConvenientViewProtocol <NSObject>
@property (nonatomic, strong, readonly) id<HXConvenientViewModelProtocol> dataModel;
@property (nonatomic, weak) id<HXConvenientViewDelegate> delegate;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong, nullable) NSDictionary *userInfo;

- (void)UIConfig;

- (void)bindingModel:(id<HXConvenientViewModelProtocol>)dataModel;

- (void)updateActionType:(NSInteger)actionType;

- (void)updateActionType:(NSInteger)actionType userInfo:(NSDictionary *)userInfo;

@optional
- (void)modelSizeAssignment;

- (void)setAvailableModelHeight __attribute__((deprecated("modelSizeAssignment instead.")));

@property (nonatomic, weak) UITableViewCell *containerTableViewCell;

@property (nonatomic, weak) UICollectionViewCell *containerCollectionViewCell;

@property (nonatomic, weak) UITableViewHeaderFooterView *containerHeaderFooterView;

@property (nonatomic, weak) UICollectionReusableView     *containerCollectionReusableView;

/**
 default: NSStringFromClass([self class])
 */
@property (nonatomic, strong) NSString     *viewIdentifier;

@end


@protocol HXConvenientViewModelProtocol <NSObject>
@property (nonatomic, copy) NSString     *viewClassName;
@property (nonatomic, assign) CGFloat     viewWidth;
@property (nonatomic, assign) CGFloat     viewHeight;
@property (nonatomic, weak) id<HXConvenientViewDelegate>         delegate;
@property (nonatomic, assign) NSInteger       actionType;
@property (nonatomic, assign) BOOL forbiddenCustomTap;
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, assign, readonly) BOOL isSectionModel;

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

//read property
@property (nonatomic, strong) NSIndexPath    *indexPath;
@property (nonatomic, assign) NSInteger       section DEPRECATED_ATTRIBUTE;
@property (nonatomic, weak) UITableView      *tableView;

//for UICollectionView
@property (nonatomic, weak) UICollectionView      *collectionView;

@property (nonatomic, weak) UIView                *associatedView;//uiew or cell 

+ (instancetype)model;

- (void)calculateSize;

- (void)calculateSizeWithReferenceFrame:(CGRect)referenceFrame;

- (void)autoCalculateHeight __attribute__((deprecated("calculateSize instead.")));

- (void)autoCalculateHeightWithSpecificFrame:(CGRect)frame __attribute__((deprecated("calculateSizeWithReferenceFrame instead.")));
@end

#pragma mark -
@protocol HXConvenientTableViewMultiSectionsProtocol <NSObject>
@property (nonatomic, strong, nullable) id<HXConvenientViewModelProtocol>        headModel;
@property (nonatomic, strong, nullable) id<HXConvenientViewModelProtocol>        footModel;
@property (nonatomic, strong) NSMutableArray<id<HXConvenientViewModelProtocol>> *rowsArr;
@property (nonatomic, assign, readonly) BOOL isSectionModel;

@optional
@property (nonatomic, assign) NSInteger            section;
@property (nonatomic, weak) UITableView           *tableView;
@property (nonatomic, weak) UICollectionView      *collectionView;
+ (instancetype)model;
@end

#pragma mark -
@protocol HXConvenientViewDelegate <NSObject>

@optional
- (void)handleActionInView:(id<HXConvenientViewProtocol>)view
                     model:(id<HXConvenientViewModelProtocol>)model;

@end


#endif /* HXViewConvinienceProtocol_h */
