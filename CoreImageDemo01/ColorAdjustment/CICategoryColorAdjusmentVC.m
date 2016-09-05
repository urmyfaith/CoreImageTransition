//
//  CICategoryColorAdjusmentVC.m
//  CoreImageDemo01
//
//  Created by zx on 9/5/16.
//  Copyright © 2016 z2xy. All rights reserved.
//

#import "CICategoryColorAdjusmentVC.h"
#import "CICategoryColorAdjustmentBaseVC.h"

@interface CICategoryColorAdjusmentVC ()

@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation CICategoryColorAdjusmentVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataArray = @[
                       @{
                           @"filterName":@"CIColorControls",
                            @"description":@"亮度-饱和度-对比度",
                           },
                       @{
                           @"description":@"midtone brightness",
                           @"filterName":@"CIGammaAdjust",
                           },
                       @{
                           @"description":@"Changes the overall hue, or tint, of the source pixels.",
                           @"filterName":@"CIHueAdjust",
                           },
                       @{
                           @"description":@"Adjusts the saturation of an image while keeping pleasing skin tones.",
                           @"filterName":@"CIVibrance",
                           },
                       @{
                           @"description":@"Blurs an image using a box-shaped convolution kernel.",
                           @"filterName":@"CIBoxBlur",
                           },
                       @{
                           @"description":@" Blurs an image using a disc-shaped convolution kernel.",
                           @"filterName":@"CIDiscBlur",
                           },
                       @{
                           //高斯模糊效果好,速度快,不卡顿,不会出现内存问题
                           @"description":@"Spreads source pixels by an amount specified by a Gaussian distribution.",
                           @"filterName":@"CIGaussianBlur",
                           },
                       @{
                           //锐化
                           @"description":@"Reduces noise using a threshold value to define what is considered noise.",
                           @"filterName":@"CINoiseReduction",
                           },
                       @{
                           //
                           @"description":@"Simulates the effect of zooming the camera while capturing the image.",
                           @"filterName":@"CIZoomBlur",
                           },
                       @{
                           //
                           @"description":@"Remaps red, green, and blue color components to the number of brightness values you specify for each color component.",
                           @"filterName":@"CIColorPosterize",
                           },

                       ];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];

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
    cell.textLabel.text = [self.dataArray[indexPath.row] objectForKey:@"filterName"];
    cell.detailTextLabel.text = [self.dataArray[indexPath.row] objectForKey:@"description"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    CICategoryColorAdjustmentBaseVC *vc = [[CICategoryColorAdjustmentBaseVC alloc]init];
    NSString *filterName = self.dataArray[indexPath.row][@"filterName"];
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

