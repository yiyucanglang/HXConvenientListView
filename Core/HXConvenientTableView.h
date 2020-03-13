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

/**
允许(id<HXConvenientViewModelProtocol>)和(id<HXConvenientTableViewMultiSectionsProtocol>) 混用
混用时tableView会自动转换成多section数据源模式，混用时id<HXConvenientViewModelProtocol>对象的indexPath.row = 0, section = index of sourceArr。
*/
@property (nonatomic, strong) NSMutableArray *sourceArr;

//Attention: this property must set before delegate set
@property (nonatomic, assign) BOOL openEstimatedCellHeight;

@end

NS_ASSUME_NONNULL_END
