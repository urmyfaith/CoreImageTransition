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
typedef void (^BlockAction)(void);


@interface ThirdTableViewController ()
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation ThirdTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    __weak typeof(self) weakSelf = self;
    self.dataArray = @[
                       @{
                           @"title":@"人脸检测",
                           @"action":^(void ){
                               FaceDetectViewController *vc = [[FaceDetectViewController alloc] init];
                               [weakSelf.navigationController pushViewController:vc animated:YES];
                           }
                        },
                       @{
                           @"title":@"自动增强",
                           @"action":^(void ){
                               AutoEnchanceViewController *vc = [[AutoEnchanceViewController alloc] init];
                               [weakSelf.navigationController pushViewController:vc animated:YES];
                           }
                           },
                       @{
                           @"title":@"自定义滤镜-翻转颜色",
                           @"action":^(void ){
                               CIColorInvertViewController *vc = [[CIColorInvertViewController alloc] init];
                               [weakSelf.navigationController pushViewController:vc animated:YES];
                           }
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
    BlockAction action = self.dataArray[indexPath.row][@"action"];
    if (action) {
        action();
    }
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
