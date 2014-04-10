//
//  ViewController.m
//  AppBusinessTest
//
//  Created by paul calver on 10/04/2014.
//  Copyright (c) 2014 paul calver. All rights reserved.
//

#import "ViewController.h"
#import "DataManager.h"

#define kDefaultCellID @"DefaultCell"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows = self.dataSource.count;
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.theTable dequeueReusableCellWithIdentifier:kDefaultCellID];
    /*
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLSessionDataTask *dataTask = [_session dataTaskWithURL:url
                                             completionHandler:^(NSData *data, NSURLResponse *response,
                                                                 NSError *error) {
                                                 if (!error) {
                                                     UIImage *image = [[UIImage alloc] initWithData:data];
                                                     photo.thumbNail = image;
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                         cell.thumbnailImage.image = photo.thumbNail;
                                                     });
                                                 } else {
                                                     // HANDLE ERROR //
                                                 }
                                             }];
    [dataTask resume];
    */
    
    return cell;
    
}

@end
