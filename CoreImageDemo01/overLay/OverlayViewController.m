//
//  OverlayViewController.m
//  CoreImageDemo01
//
//  Created by zx on 9/26/16.
//  Copyright © 2016 z2xy. All rights reserved.
//

#import "OverlayViewController.h"
#import "OverLayDetailViewController.h"

@interface OverlayViewController ()
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation OverlayViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataArray = @[
                       @"CIAdditionCompositing",
                       @"CIColorBlendMode",
                       @"CIColorBurnBlendMode",
                       @"CIColorDodgeBlendMode",
                       @"CIDarkenBlendMode",
                       @"CIDifferenceBlendMode",
                       @"CIDivideBlendMode",
                       @"CIExclusionBlendMode",
                       @"CIHardLightBlendMode",
                       @"CIHueBlendMode",
                       @"CILightenBlendMode",
                       @"CILinearBurnBlendMode",
                       @"CILinearDodgeBlendMode",
                       @"CILuminosityBlendMode",
                       @"CIMaximumCompositing",
                       @"CIMinimumCompositing",
                       @"CIMultiplyBlendMode",
                       @"CIMultiplyCompositing",
                       @"CIOverlayBlendMode",
                       @"CIPinLightBlendMode",
                       @"CISaturationBlendMode",
                       @"CIScreenBlendMode",
                       @"CISoftLightBlendMode",
                       @"CISourceAtopCompositing",
                       @"CISourceInCompositing",
                       @"CISourceOutCompositing",
                       @"CISourceOverCompositing",
                       @"CISubtractBlendMode",
                       ];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];

    //可以直接从图片组合操作分类得到所有的滤镜的名称.
    NSArray *filters = [CIFilter filterNamesInCategory:@"CICategoryCompositeOperation"];
    NSLog(@"count: filters=%zd\tself.dateArray=%zd",filters.count,self.dataArray.count);
    NSLog(@"filters=%@\nself.dateArray=%@",filters,self.dataArray);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SettingsCellIdentifier = @"testingCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SettingsCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SettingsCellIdentifier];
    }

    NSString *filterName = self.dataArray[indexPath.row];
    NSString *filterDisplayName = [CIFilter localizedNameForFilterName:filterName];

    cell.textLabel.text = filterName;
    cell.detailTextLabel.text = filterDisplayName;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    OverLayDetailViewController *vc = [[OverLayDetailViewController alloc]init];
    NSString *filterName = self.dataArray[indexPath.row];
    vc.filterName = filterName;
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

@end
