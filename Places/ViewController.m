//
//  ViewController.m
//  Places
//
//  Created by azat on 28/11/15.
//  Copyright © 2015 azat. All rights reserved.
//

#import "ViewController.h"
#import "PLCGoogleMapService.h"
#import "PLCPlaceMapper.h"
#import "PLCPlace.h"
#import <MBProgressHUD.h>
#import <SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController ()
{
    NSMutableArray *placeArray;
    PLCGoogleMapService *service;
   // PLCPlace *place;
}
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    placeArray = [NSMutableArray new];
    
    self.searchingTF.delegate = self;
   service = [[PLCGoogleMapService alloc]init];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableViewDelegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [placeArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    
   UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    PLCPlace *placeFeed = placeArray[indexPath.row];
    cell.textLabel.text = placeFeed.name;
    
    if (!placeFeed.image) {
        [self loadImageOfPlace:placeFeed cell:cell];
    }
    else{
        cell.imageView.image = placeFeed.image;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.imageView.clipsToBounds = YES;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;

}

#pragma mark Custom methods
- (void)loadImageOfPlace:(PLCPlace *)place cell:(UITableViewCell*)currentCell{
    if (place.imageURL) {
        [service getplacesImages:place.imageURL success:^(UIImage *image) {
            place.image = image;
            
            NSIndexPath *indexPath = [self.tableView indexPathForCell:currentCell];
            
            NSArray* rowsToReload = [NSArray arrayWithObjects:indexPath, nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
                
            });
            
        } failure:^(NSError *error) {
            [self errorAlertShow];
        }];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            place.image = [UIImage imageNamed:@"noimage.png"];
           
            NSIndexPath *indexPath = [self.tableView indexPathForCell:currentCell];
            
            NSArray* rowsToReload = [NSArray arrayWithObjects:indexPath, nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
                
            });

        });
        
    }
}

- (void)errorAlertShow{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Error" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark TextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark ButtonsAction
- (IBAction)findButtonDidPressed:(id)sender {
    [placeArray removeAllObjects];
    [self.searchingTF resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        [service getPlacesByText:self.searchingTF.text success:^(NSArray*array) {
            placeArray = [NSMutableArray arrayWithArray:array];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } failure:^(NSError *error) {
            [self errorAlertShow];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

            [self.tableView reloadData];
            
        });
    });
   
    
   
}

@end
