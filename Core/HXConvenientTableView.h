//
//  HXConvinenceTableView.h
//  ShengXue
//
//  Created by 周义进 on 2018/12/25.
//  Copyright © 2018 Sea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXViewConvenientProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXConvenientTableView : UITableView
/**
 this must set before delegate or datasource set
 default: UITableViewCell
 */
@property (nonatomic, strong) Class cellContainerClass;
//as above default: UITableViewHeaderFooterView
@property (nonatomic, strong) Class headFooterContainerClass;

@property (nonatomic, strong) NSMutableArray *sourceArr;

//attention: below property must set before delegate set
@property (nonatomic, assign) BOOL openEstimatedCellHeight;

@end

NS_ASSUME_NONNULL_END
