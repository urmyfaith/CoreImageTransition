//
//  ThirdTableViewController.m
//  CoreImageDemo01
//
//  Created by zx on 9/2/16.
//  Copyright © 2016 z2xy. All rights reserved.
//

#import "ThirdTableViewController.h"


#import "FaceDetectViewController.h"
#import "AutoEnchanceViewController.h"
#import "CIColorInvertViewController.h"
#import "ChromaKeyFilterVC.h"

@interface ThirdTableViewController ()
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation ThirdTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataArray = @[
                       @{
                           @"title":@"人脸检测",
                           @"vcName":@"FaceDetectViewController"
                           },
                       @{
                           @"title":@"自动增强",
                           @"vcName":@"AutoEnchanceViewController",
                           },
                       @{
                           @"title":@"自定义滤镜-翻转颜色",
                           @"vcName":@"CIColorInvertViewController",
                           },
                       @{
                           @"title":@"自定义滤镜-cobe",
                           @"vcName":@"ChromaKeyFilterVC",
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SettingsCellIdentifier];
    }
    cell.textLabel.text = [self.dataArray[indexPath.row] objectForKey:@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *vcName = self.dataArray[indexPath.row][@"vcName"];

    id vc = [[NSClassFromString(vcName) alloc] init];
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
