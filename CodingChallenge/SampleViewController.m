//
//  ViewController.m
//  CodingChallenge
//
//  Created by Ravi Tega Koluguri on 3/24/14.
//  Copyright (c) 2014 Ravi Tega Koluguri. All rights reserved.
//

#import "SampleViewController.h"
#import "ModelObject.h"
#import "CustomCell.h"

@interface ViewController ()

@property (nonatomic,strong) NSMutableArray *result;
@property (nonatomic) BOOL isSearching;
@property (nonatomic,strong) NSMutableArray *filteredList;
@property (nonatomic,strong) NSMutableArray *list;

-(void) configureData;
-(void) fetchedData:(NSData *)responseData;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomCell"
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"CustomCell"];
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CustomCell"];
    
    self.isSearching = NO;
    self.filteredList = [[NSMutableArray alloc]init];
    self.list = [[NSMutableArray alloc]init];
    _searchDisplay.delegate = self;
    [self configureData];
    //[self loadObjects];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearching) {
        return [self.filteredList count];
    }
    else{
    return [self.result count];
    }
}
- (UITableViewCell*)tableView:(UITableView*)aTableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    static NSString *sampleTableViewCell = @"CustomCell";
    CustomCell *cell = [aTableView dequeueReusableCellWithIdentifier:sampleTableViewCell];
    if (aTableView == self.searchDisplayController.searchResultsTableView){
        ModelObject *object = [self.filteredList objectAtIndex:indexPath.row];
        cell.description.text = object.title;
        cell.text.text = object.detailText;
        [cell.imageView setImage:object.castImage];
        return cell;
    }
    else{
    ModelObject *object = [self.result objectAtIndex:indexPath.row];
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:object.url]];
    result = [UIImage imageWithData:data];
    object.castImage = result;
//    __weak CustomCell *weakCell = cell;
//    NSURL *url = [NSURL URLWithString:object.url];
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//    [cell.imageView setImageWithURLRequest:urlRequest
//                               placeholderImage:nil
//                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//                                            weakCell.imageView.image = image;
//                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//                                            NSLog(@"Failed to download image: %@", error);
//                                        }];
    cell.description.text = object.title;
    cell.text.text = object.detailText;
    [cell.imageView setImage:object.castImage];
    return cell;
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    ModelObject *object = [self.result objectAtIndex:indexPath.row];
    MFMailComposeViewController *email = [[MFMailComposeViewController alloc] init];
    email.mailComposeDelegate = self;
    
    [email setSubject:object.title];
    
    [email setMessageBody:object.detailText isHTML:YES];
    
    [self presentViewController:email animated:YES completion:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78.0;
}
-(void) configureData{
    NSData* data = [NSData dataWithContentsOfURL:
                    [NSURL URLWithString:@"http://www.nousguideinc.com/43254235dsffds34f/8y39485y.json"]];
    [self performSelectorOnMainThread:@selector(fetchedData:)
                           withObject:data waitUntilDone:YES];
    
}
-(void) fetchedData:(NSData *)responseData{
    NSError *e = nil;
    NSDictionary *cast = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&e];
    self.result = [[NSMutableArray alloc]init];
    NSArray *castArray = [cast objectForKey:@"cast"];
    NSLog(@"%@",[castArray objectAtIndex:0]);
    for (NSDictionary *dictionary in castArray) {
        ModelObject *object = [[ModelObject alloc]init];
        object.title = [dictionary objectForKey:@"titleText"];
        object.detailText = [dictionary objectForKey:@"detailText"];
        object.url = [dictionary objectForKey:@"imageURL"];
        [self.result addObject:object];
    }
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)filterListForSearchText:(NSString *)searchText{
    [self.filteredList removeAllObjects];
    for (ModelObject *object in self.result) {
        NSString * string =   [object.title stringByAppendingString:object.detailText];
        NSRange nameRange = [ string rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (nameRange.location != NSNotFound) {
            [self.filteredList addObject:object];
        }
    }
    
}
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    //When the user taps the search bar, this means that the controller will begin searching.
    self.isSearching = YES;
}
-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    //When the user taps the Cancel Button, or anywhere aside from the view.
    self.isSearching = NO;
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterListForSearchText:searchString];
    [self.searchDisplayController.searchResultsTableView reloadData];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

@end
