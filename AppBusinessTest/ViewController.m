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
#import "UIImage+Tools.h"

#define kDefaultCellID @"DefaultCell"
#define kImageSizeThreshold 500
#define kImageWidthHeight 60

@interface ViewController ()

@property (nonatomic, strong) NSURLSession *theSession;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSCache *cachedImages;
@property (nonatomic, strong) BiographyTableViewCell *prototypeCell;
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
            
            self.cachedImages = [[NSCache alloc] init];
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

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[BiographyTableViewCell class]])
    {
        BiographyTableViewCell *biogCell = (BiographyTableViewCell *)cell;
        
        Employee *anEmployee = self.dataSource[indexPath.row];
        
        if (anEmployee) {
            biogCell.nameLabel.text = anEmployee.empName;
            biogCell.roleLabel.text = anEmployee.empRole;
            biogCell.bioLabel.text = anEmployee.empBio;

        }
    }
}

#pragma mark tableview

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
    
    NSDictionary *attributes = @{NSFontAttributeName:self.prototypeCell.bioLabel.font};
    CGRect rect = [self.prototypeCell.bioLabel.text boundingRectWithSize:CGSizeMake(self.prototypeCell.bioLabel.frame.size.width, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    return rect.size.height + 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows = self.dataSource.count;
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BiographyTableViewCell *cell = (BiographyTableViewCell*)[self.theTable dequeueReusableCellWithIdentifier:kDefaultCellID];
    
    Employee *anEmployee = self.dataSource[indexPath.row];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    NSString *imageURL = anEmployee.empProfileImage;
    
    if ([imageURL length] > 0) {
        
        
        // would hash the string to be used as a key oridinarily but will just use string for test
        
        if ([self.cachedImages objectForKey:imageURL] != nil) {
            
            cell.profileImage.image = [self.cachedImages objectForKey:imageURL];
            
        } else {
        
            cell.profileImage.image = nil;
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            NSURLSessionDataTask *dataTask = [self.theSession dataTaskWithURL:[NSURL URLWithString:imageURL]
                                                 completionHandler:^(NSData *data, NSURLResponse *response,
                                                                     NSError *error) {
                                                     if (!error) {
                                                         
                                                         UIImage *image = [[UIImage alloc] initWithData:data];
                                                         
                                                         // resize image
                                                         
                                                         UIImage *imageForUse;
                                                         
                                                         if ((image.size.width > kImageSizeThreshold) || (image.size.height > kImageSizeThreshold) ) {
                                                             imageForUse = [UIImage resizeImage:image resizeSize:CGSizeMake(kImageWidthHeight, kImageWidthHeight)];
                                                         } else {
                                                             imageForUse = image;
                                                         }
                                                      
                                                         if (imageForUse) {
                                                             
                                                             [self.cachedImages setObject:imageForUse forKey:imageURL];
                                                             
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                                 
                                                                 BiographyTableViewCell *theCell = (BiographyTableViewCell*)[self.theTable cellForRowAtIndexPath:indexPath];

                                                                 theCell.profileImage.image = imageForUse;
                                                                 theCell.profileImage.layer.cornerRadius = theCell.profileImage.frame.size.width/2;
                                                                 theCell.profileImage.clipsToBounds = YES;
                                                             });
                                                         }
                                                     } else {
                                                         // HANDLE ERROR //
                                                     }
                                                 }];
        [dataTask resume];
        }
    }
    
    return cell;
    
}

- (BiographyTableViewCell *)prototypeCell
{
    if (!_prototypeCell)
    {
        _prototypeCell = [self.theTable dequeueReusableCellWithIdentifier:kDefaultCellID];
    }
    return _prototypeCell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

@end
