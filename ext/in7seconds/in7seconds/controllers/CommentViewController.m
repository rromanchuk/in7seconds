//
//  CommentViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/6/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "CommentViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PrivateMessage+REST.h"
#import "Thread+REST.h"
#import "Match+REST.h"
#import "CurrentUserChatCell.h"
#import "OtherUserChatCell.h"

#import "RestMessage.h"
#import "RestThread.h"
#import "AppDelegate.h"

#import "UserProfileViewController.h"

// views
#import "NoChatsView.h"
@interface CommentViewController ()
@property (strong, nonatomic) NoChatsView *noResultsFooterView;
@property (nonatomic) BOOL beganUpdates;
@property (strong) Thread *thread;
@property (strong) UIRefreshControl *refreshControl;

@end

@implementation CommentViewController {
    NSDateFormatter *_df;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder])
    {
        self.noResultsFooterView = (NoChatsView *)[[NSBundle mainBundle] loadNibNamed:@"NoChatsView" owner:self options:nil][0];
        //self.noResultsFooterView.feedEmptyLabel.text = NSLocalizedString(@"FEED_IS_EMPTY", @"Empty feed");
    }
    return self;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"UserProfile"]) {
        UserProfileViewController *vc = (UserProfileViewController *)segue.destinationViewController;
        vc.managedObjectContext = self.managedObjectContext;
        vc.currentUser = self.currentUser;
        vc.otherUser = self.otherUser;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupFooterView];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"back_icon"] target:self action:@selector(back)];
    self.title = self.otherUser.fullName;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    [self fetchResults:nil];

    _df = [[NSDateFormatter alloc] init];
    [_df setDateFormat:@"dd-MM-yyyy, HH:mm"];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.navigationController.view.layer setCornerRadius:0.0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
    self.thread = self.otherUser.thread;
    if (self.thread) {
        [self setupFetchedResultsController];
    }
    
    [self checkNoResults];
}

- (void)checkNoResults {
    if ([[self.fetchedResultsController fetchedObjects] count] == 0) {
        self.tableView.tableFooterView = self.noResultsFooterView;
    } else {
        self.tableView.tableFooterView = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.commentView resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PrivateMessage"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"thread = %@", self.thread];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}


- (void)setupFooterView {
    //UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - 20, self.view.frame.size.width, 40.0)];
    //view.clipsToBounds = NO;
    
    self.footerView.opaque = YES;
    self.footerView.backgroundColor = RGBCOLOR(239.0, 239.0, 239.0);
    [self.footerView.layer setMasksToBounds:NO];
    //[self.footerView.layer setBorderColor: [[UIColor redColor] CGColor]];
    //[self.footerView.layer setBorderWidth: 1.0];
    [self.footerView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.footerView.layer setShadowOffset:CGSizeMake(0, 0)];
    [self.footerView.layer setShadowRadius:2.0];
    [self.footerView.layer setShadowOpacity:0.65 ];
    [self.footerView.layer setShadowPath:[[UIBezierPath bezierPathWithRect:self.footerView.bounds ] CGPath ] ];
    HPGrowingTextView *textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(15.0, 5.0, 245, 32.0)];
    textView.delegate = self;
    textView.backgroundColor = [UIColor whiteColor];
    self.commentView = textView;
    self.commentView.layer.masksToBounds = YES;
    self.commentView.layer.cornerRadius = 5.0;
    self.commentView.text = NSLocalizedString(@"Написать комментарий", nil);
    self.commentView.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    self.commentView.textColor = RGBCOLOR(127, 127, 127);
    [self.commentView.layer setBorderColor:RGBCOLOR(233, 233, 233).CGColor];
    [self.commentView.layer setBorderWidth:1.0];
    [self.commentView.layer setShadowOffset:CGSizeMake(0, 0)];
    [self.commentView.layer setShadowOpacity:1 ];
    [self.commentView.layer setShadowRadius:4.0];
    [self.commentView.layer setShadowColor:RGBCOLOR(233, 233, 233).CGColor];
    [self.commentView.layer setShadowPath:[[UIBezierPath bezierPathWithRect:self.commentView.bounds ] CGPath ] ];
    [self.footerView addSubview:textView];
    
    UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    enterButton.frame = CGRectMake(275.0, 5, 36, 31.0);
    [enterButton setImage:[UIImage imageNamed:@"enter-button.png"] forState:UIControlStateNormal];
    [enterButton addTarget:self action:@selector(didAddComment:event:) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:enterButton];
}

#pragma mark - UITableViewDelegate methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrivateMessage *message = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (![message.isFromSelf boolValue]) {
        OtherUserChatCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"OtherUserChatCell"];
        [cell.blueBubble setMessage:message.message];
        [cell.profileImage setImageWithURL:[NSURL URLWithString:self.otherUser.photoUrl]];
        cell.dateLabel.text = [_df stringFromDate:message.createdAt];
        cell.profileImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapProfilePhoto:)];
        [cell.profileImage addGestureRecognizer:tg];
        return cell;
    } else {
        CurrentUserChatCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CurrentUserChatCell"];
        [cell.whiteBubble setMessage:message.message];
        cell.dateLabel.text = [_df stringFromDate:message.createdAt];
        [cell.profilePhoto setImageWithURL:[NSURL URLWithString:self.currentUser.photoUrl]];        
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestMessage *message = [self.fetchedResultsController objectAtIndexPath:indexPath];
    CGSize size = [message.message sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:15] constrainedToSize:CGSizeMake(245 - 25, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    DLog(@"height will be")
    //return exptectedSize.height + 20;
    return size.height + 20 + 20;
}


#pragma mark - HPGrowingTextView delegate methods
-(void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height {
    DLog(@"new height is %f old height is %f", height, self.footerView.frame.size.height);
    if(height < 50)
        height = 50.0;
    [self.footerView setFrame:CGRectMake(self.footerView.frame.origin.x, self.footerView.frame.origin.y - (height - self.footerView.frame.size.height ), self.footerView.frame.size.width, height)];
}

-(void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView {
    if ([self.commentView.text isEqualToString:NSLocalizedString(@"Написать комментарий", nil)]) {
        self.commentView.text = @"";
    }
    DLog(@"did begin editing");
}



- (void)keyboardWillHide:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self setViewMovedUp:NO kbSize:kbSize.height];
    
    if ([[self.fetchedResultsController fetchedObjects] count] > 0) {
        int index = [[self.fetchedResultsController fetchedObjects] count];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index-1 inSection:0];
        CGRect lastRowRect = [self.tableView rectForRowAtIndexPath:indexPath];
        CGFloat contentHeight = lastRowRect.origin.y + lastRowRect.size.height;
        //[self.tableView setContentSize:CGSizeMake(self.tableView.frame.size.width, contentHeight)];
    }
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    DLog(@"keyboard shown");
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    //[self.tableView setContentOffset:CGPointMake(0.0, kbSize.height + 100.0)];
    [self setViewMovedUp:YES kbSize:kbSize.height];
    
    if ([[self.fetchedResultsController fetchedObjects] count] > 0) {
        int index = [[self.fetchedResultsController fetchedObjects] count];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index-1 inSection:0];
        CGRect lastRowRect = [self.tableView rectForRowAtIndexPath:indexPath];
        CGFloat contentHeight = lastRowRect.origin.y + lastRowRect.size.height + kbSize.height;
        //[self.tableView setContentSize:CGSizeMake(self.tableView.frame.size.width, contentHeight)];
    }
}

-(void)setViewMovedUp:(BOOL)movedUp kbSize:(float)kbSize
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.footerView.frame;
    if (movedUp)
    {
        DLog(@"KEYBOARD SHOWN AND MOVING UP ORIGIN %f", kbSize);
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kbSize;
        //[self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y + kbSize)];
        [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - kbSize)];
        //rect.size.height += kbSize;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kbSize;
        [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height + kbSize)];
        //[self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y - kbSize)];
        //rect.size.height -= kbSize;
    }
    self.footerView.frame = rect;
    
    
    NSIndexPath *path = [self.fetchedResultsController indexPathForObject:[[self.fetchedResultsController fetchedObjects] lastObject]];
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [UIView commitAnimations];
}



#pragma mark - User actions
- (IBAction)didAddComment:(id)sender event:(UIEvent *)event {
    [self.commentView resignFirstResponder];
    NSString *comment = self.commentView.text;
    if (comment.length == 0 || [comment isEqualToString:NSLocalizedString(@"Написать комментарий", nil)]) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Упс, ты забыл ввести текст сообщения.", @"User pressed submit with no comment given")];
        return;
    }
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Отсылаю сообщение...", nil) maskType:SVProgressHUDMaskTypeGradient];
    [RestMessage sendMessageTo:self.otherUser withMessage:comment onLoad:^(RestMessage *restMessage) {
        [SVProgressHUD dismiss];
        PrivateMessage *privateMessage = [PrivateMessage privateMessageWithRestMessage:restMessage inManagedObjectContext:self.managedObjectContext];
        [self.thread addMessagesObject:privateMessage];
        [self saveContext];
        [self checkNoResults];
        self.commentView.text = nil;
    } onError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    
}


#pragma mark - Fetching

- (void)performFetch
{
    if (self.fetchedResultsController) {
        if (self.fetchedResultsController.fetchRequest.predicate) {
            if (self.debug) NSLog(@"[%@ %@] fetching %@ with predicate: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName, self.fetchedResultsController.fetchRequest.predicate);
        } else {
            if (self.debug) NSLog(@"[%@ %@] fetching all %@ (i.e., no predicate)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName);
        }
        NSError *error;
        [self.fetchedResultsController performFetch:&error];
        if (error) NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
    } else {
        if (self.debug) NSLog(@"[%@ %@] no NSFetchedResultsController (yet?)", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    }
    [self.tableView reloadData];
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)newfrc
{
    NSFetchedResultsController *oldfrc = _fetchedResultsController;
    if (newfrc != oldfrc) {
        _fetchedResultsController = newfrc;
        newfrc.delegate = self;
        if ((!self.title || [self.title isEqualToString:oldfrc.fetchRequest.entity.name]) && (!self.navigationController || !self.navigationItem.title)) {
            self.title = newfrc.fetchRequest.entity.name;
        }
        if (newfrc) {
            if (self.debug) NSLog(@"[%@ %@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), oldfrc ? @"updated" : @"set");
            [self performFetch];
        } else {
            if (self.debug) NSLog(@"[%@ %@] reset to nil", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
            [self.tableView reloadData];
        }
    }
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.fetchedResultsController sections][section] numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [[self.fetchedResultsController sections][section] name];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController sectionIndexTitles];
}


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext) {
        [self.tableView beginUpdates];
        self.beganUpdates = YES;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    {
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    {
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeMove:
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (self.beganUpdates) [self.tableView endUpdates];
}

- (void)endSuspensionOfUpdatesDueToContextChanges
{
    _suspendAutomaticTrackingOfChangesInManagedObjectContext = NO;
}

- (void)setSuspendAutomaticTrackingOfChangesInManagedObjectContext:(BOOL)suspend
{
    if (suspend) {
        _suspendAutomaticTrackingOfChangesInManagedObjectContext = YES;
    } else {
        [self performSelector:@selector(endSuspensionOfUpdatesDueToContextChanges) withObject:0 afterDelay:0];
    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([_managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
    
    AppDelegate *sharedAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [sharedAppDelegate writeToDisk];
}


- (void)fetchResults:(id)refreshControl {
    [self.managedObjectContext performBlock:^{
        [RestThread loadThreadWithUser:self.otherUser onLoad:^(RestThread *restThread) {
            ALog(@"rest thread %@", restThread);
            if (restThread) {
                self.thread = [Thread threadWithRestThread:restThread inManagedObjectContext:self.managedObjectContext];
                [self.currentUser addThreadsObject:self.thread];
                NSError *error;
                [self.managedObjectContext save:&error];
                
                AppDelegate *sharedAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [sharedAppDelegate writeToDisk];
            }
            
            if (!self.fetchedResultsController) {
                [self setupFetchedResultsController];
            }
            [self checkNoResults];
                        
            [refreshControl endRefreshing];
        } onError:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            [refreshControl endRefreshing];
        }];

    }];
}

- (IBAction)didTapProfilePhoto:(id)sender {
    NSInteger row = ((UITapGestureRecognizer *)sender).view.tag;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    Match *match = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"UserProfile" sender:match];
    
}
@end
