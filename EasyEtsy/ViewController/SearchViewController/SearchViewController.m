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

@interface SearchViewController () <UISearchBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) NSArray *listingCategories;

@end

@implementation SearchViewController

- (NSArray *)listingCategories {
    if (!_listingCategories) {
        _listingCategories = [[NSArray alloc]init];
    }
    return _listingCategories;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    __weak typeof(self) weakSelf = self;
    [[EtsyWebServiceAPI sharedManager] fetchListingCategoriesWithCompletion:^(NSArray *categories, NSError *error) {
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

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    ListingCategory *listingCategory = self.listingCategories[(NSUInteger) row];
    return listingCategory.categoryLongName;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.listingCategories.count;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

#pragma mark - IBAction

- (IBAction)tapOnSubmitButton:(UIButton *)sender {

}

@end
