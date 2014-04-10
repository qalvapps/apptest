//
//  ViewController.m
//  AppBusinessTest
//
//  Created by paul calver on 10/04/2014.
//  Copyright (c) 2014 paul calver. All rights reserved.
//

#import "ViewController.h"
#import "DataManager.h"
#import "BiographyTableViewCell.h"
#import "Employee.h"

#define kDefaultCellID @"DefaultCell"

@interface ViewController ()

@property (nonatomic, strong) NSURLSession *theSession;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableDictionary *cachedImages;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    
    self.theSession = session;
    
    [[DataManager sharedDataManager] fetchWithCompletion:^(NSArray *employees, NSError *error) {
        
        if (!error) {
            NSLog(@"employees %@",employees);
            
            self.cachedImages = [NSMutableDictionary dictionary];
            self.dataSource = [NSMutableArray arrayWithArray:[employees copy]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.theTable reloadData];
            });
        }
    }];
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
    
    BiographyTableViewCell *cell = (BiographyTableViewCell*)[self.theTable dequeueReusableCellWithIdentifier:kDefaultCellID];
    
    Employee *anEmployee = self.dataSource[indexPath.row];
    
    if (anEmployee) {
        cell.nameLabel.text = anEmployee.empName;
        cell.roleLabel.text = anEmployee.empRole;
        cell.bioLabel.text = anEmployee.empBio;
    }
    
    NSString *imageURL = anEmployee.empProfileImage;
    
    if ([imageURL length] > 0) {
        
        if (self.cachedImages[imageURL] != nil) {
            
            cell.profileImage.image = self.cachedImages[imageURL];
            
        } else {
        
            cell.profileImage.image = nil;
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            NSURLSessionDataTask *dataTask = [self.theSession dataTaskWithURL:[NSURL URLWithString:imageURL]
                                                 completionHandler:^(NSData *data, NSURLResponse *response,
                                                                     NSError *error) {
                                                     if (!error) {
                                                         
                                                         UIImage *image = [[UIImage alloc] initWithData:data];
                                                         
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                             cell.profileImage.image = image;
                                                             
                                                             self.cachedImages[imageURL] = image;
                                                             
                                                         });
                                                     } else {
                                                         // HANDLE ERROR //
                                                     }
                                                 }];
        [dataTask resume];
        }
    }
    
    return cell;
    
}

@end
