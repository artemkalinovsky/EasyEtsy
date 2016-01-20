//
//  SearchViewController.m
//  EasyEtsy
//
//  Created by Artem Kalinovsky on 26/08/2015.
//  Copyright (c) 2015 Artem Kalinovsky. All rights reserved.
//

#import "SearchViewController.h"
#import "ListingCategory.h"
#import "EtsyWebServiceAPI.h"
#import "Constants.h"
#import "SearchResultsViewController.h"

@interface SearchViewController () <UISearchBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property(weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property(weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property(strong, nonatomic) NSArray *listingCategories;
@property(assign, nonatomic) NSUInteger selectedListingCategoryIndex;

@end

@implementation SearchViewController

- (NSArray *)listingCategories {
    if (!_listingCategories) {
        _listingCategories = [[NSArray alloc] init];
    }
    return _listingCategories;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    __weak typeof(self) weakSelf = self;
    [[EtsyWebServiceAPI sharedManager] fetchDataForAPIModelName:APIModelNameCategory
                                                     parameters:nil
                                                     completion:^(NSArray *categories, NSError *error) {
                                                         if (!error && categories) {
                                                             weakSelf.listingCategories = categories;
                                                             [weakSelf.pickerView reloadAllComponents];
                                                         } else {
                                                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                             message:error.localizedDescription
                                                                                                            delegate:self
                                                                                                   cancelButtonTitle:@"OK"
                                                                                                   otherButtonTitles:nil];
                                                             [alert show];
                                                         }
                                                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    ListingCategory *listingCategory = self.listingCategories[(NSUInteger) row];
    return listingCategory.categoryLongName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedListingCategoryIndex = (NSUInteger) row;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.listingCategories.count;
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:toSearchResultsSegue]) {
        if (!self.searchBar.text || [self.searchBar.text isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                            message:@"Add some keywords"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:toSearchResultsSegue]) {
        ListingCategory *selectedListingCategory = self.listingCategories[self.selectedListingCategoryIndex];
        SearchResultsViewController *destinationVC = segue.destinationViewController;
        destinationVC.searchParams = @{@"category" : selectedListingCategory.categoryName, @"keywords" : self.searchBar.text};
    }
}

#pragma mark - IBActions

- (IBAction)tapOnSubmitButton:(UIButton *)sender {
}

@end
