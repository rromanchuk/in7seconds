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
#import "Match+REST.h"
#import "CurrentUserChatCell.h"
#import "OtherUserChatCell.h"

#import "RestMessage.h"
#import "AppDelegate.h"

#import "UserProfileViewController.h"
#import <ViewDeck/IIViewDeckController.h>

// views
#import "NoChatsView.h"
@interface CommentViewController ()
@property (strong, nonatomic) NoChatsView *noResultsFooterView;
@property (nonatomic) BOOL beganUpdates;
@property (strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray *oneLiners;

@end

@implementation CommentViewController {
    NSDateFormatter *_df;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder])
    {
        self.noResultsFooterView = (NoChatsView *)[[NSBundle mainBundle] loadNibNamed:@"NoChatsView" owner:self options:nil][0];
        //self.noResultsFooterView.feedEmptyLabel.text = NSLocalizedString(@"FEED_IS_EMPTY", @"Empty feed");
        self.oneLiners = @[@"Можно начать просто с 'Как дела?'",
                               @"Когда нечего сказать, начни с 'Привет :)'",
                               @"Давай, напиши уже что-нибудь",
                               @"Одна маленькая фраза для человека, огромный скачек для ваших отношений",
                               @"Сделай комплимент, например о фотографии",
                               @"Первая фраза всегда самая сложная, начни с 'Привет'",
                               @"У вас будут прекрасные детки :)",
                               @"Обещайте не спорить, на кого больше будет похож ваш ребенок",
                               @"Давай, скажи 'Привет'",
                               @"Вы совпали! Значит между вами уже что-то есть...",
                               @"Скорее пиши сообщение, а то твоя пара совпадет с кем-нибудь другим",
                               @"Скорее пиши сообщение, вы уже нравитесь друг другу, так чего боятся",
                               @"'Привет' – отличное начало диалога",
                               @"И кто из вас положит начало этим отношениям? Пиши скорее!",
                               @"Совпадение есть, теперь осталось просто сказать 'Привет'",
                               @"Потом будешь хвастаться, что твое сообщение было первым",
                               @"Совпадение есть, теперь дело за малым! Напиши сообщение! Сейчас!",
                               @"Пиши сообщение! Сейчас! Потом будет поздно",
                               @"Просто напиши 'Привет!' Сейчас!",
                               @"Видишь вот это поле снизу? Напиши туда что-нибудь!",
                               @"Если не спросить, ответ всегда будет 'Нет!'",
                               @"Вау, вы нравитесь друг другу! Может напишешь что-нибудь?",
                               @"Мир стареет каждую секунду твоих раздумий. Пиши скорее!",
                               @"Если просто смотреть на экран ничего не произойдет... Напиши что-нибудь!",
                               @"Вау, вы нравитесь друг другу! Может напишешь что-нибудь?",
                               @"Мир стареет каждую секунду твоих раздумий. Пиши скорее!",
                               @"Если просто смотреть на экран ничего не произойдет... Напиши что-нибудь!",
                               @"Вы отлично смотритесь вместе!",
                               @"Будешь гуглить вступительную фразу или сразу напишешь?",
                               @"Диалоги сами собой не начинаются",
                               @"Они наверняка в живую смотрятся лучше чем на фото!",
                               @"Тебе что, язык откусили? Пиши уже!",
                               @"Стесняешься? А не надо!",
                               @"Твои дни одиночества закончатся, как только напишешь 'Привет!'",
                               @"Покажи пример хорошего воспитания. Напиши 'Привет!'",
                               @"Скажи спасибо, ведь тебя только что выбрали :)",
                               @"Тебе нужно особое приглашение? Пиши скорее!",
                               @"Сделай это!",
                               @"Три тысячи чертей, ты напишешь сообщение или нет?",
                               @"Кто молчит в чате – тот Филипп Киркоров",
                               @"У тебя руки связаны, что написать не можешь или что?",
                               @"Прекрати это скуку! Пиши немедленно!",
                               @"Какой твой самый большой секрет?",
                               @"И чего же ты ждешь? Пиши!",
                               @"Зачем тебе вообще телефон если ты ничего не пишешь?",
                               @"Если не напишешь сообщение в течении следующих 20 секунд, мы тебя найдем"
                               ];
    }
    return self;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"UserProfileFromChat"]) {
        UserProfileViewController *vc = (UserProfileViewController *)segue.destinationViewController;
        vc.managedObjectContext = self.managedObjectContext;
        vc.currentUser = self.currentUser;
        vc.otherUser = self.otherUser;
        vc.canRate = NO;

    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.noResultsFooterView.profilePhoto setCircleWithUrl:self.otherUser.photoUrl];

    
    self.viewDeckController.rightSize = 0;
    self.navigationController.navigationBarHidden = NO;
    [self setupFooterView];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        self.navigationItem.leftBarButtonItems = @[[UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"back_button"] target:self action:@selector(back)]];
    } else {
        // Load resources for iOS 7 or later
        //self.navigationController.navigationBar.backItem.ti
//self.navigationController.navigationBar.tintColor = RGBCOLOR(148, 153, 156);
    }
    
    ProfilePhotoView *profilePhoto = [[ProfilePhotoView alloc] initWithFrame:CGRectMake(0, 0, 27, 27)];
    [profilePhoto setCircleWithUrl:self.otherUser.photoUrl];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithView:profilePhoto target:self action:@selector(didTapProfilePhotoRightButton:)];
    
    self.title = self.otherUser.firstName;
    

    _df = [[NSDateFormatter alloc] init];
    [_df setDateFormat:@"HH:mm"];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.navigationController.view.layer setCornerRadius:0.0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [self setupFetchedResultsController];
    [self checkNoResults];
    //[self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];

}

- (void)checkNoResults {
    if ([[self.fetchedResultsController fetchedObjects] count] == 0) {
        self.tableView.tableFooterView = self.noResultsFooterView;
        NSUInteger randomIndex = arc4random() % [self.oneLiners count];
        self.noResultsFooterView.messageLabel.text = self.oneLiners[randomIndex];
    } else {
        self.tableView.tableFooterView = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.commentView resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate writeToDisk];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:@"Chat Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PrivateMessage"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"withMatch == %@", self.otherUser];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}


- (void)setupFooterView {
        
    self.footerView.opaque = YES;
    [self.footerView.layer setMasksToBounds:NO];
    //[self.footerView.layer setBorderColor: [[UIColor redColor] CGColor]];
    //[self.footerView.layer setBorderWidth: 1.0];
    [self.footerView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.footerView.layer setShadowOffset:CGSizeMake(0, 0)];
    [self.footerView.layer setShadowRadius:2.0];
    [self.footerView.layer setShadowOpacity:0.65 ];
    [self.footerView.layer setShadowPath:[[UIBezierPath bezierPathWithRect:self.footerView.bounds ] CGPath ] ];
    HPGrowingTextView *textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(15.0, 5.0, 220, 50.0)];
    textView.delegate = self;
    textView.backgroundColor = [UIColor whiteColor];
    self.commentView = textView;
    //self.commentView.layer.masksToBounds = YES;
    //self.commentView.layer.cornerRadius = 5.0;
    self.commentView.text = NSLocalizedString(@"Написать комментарий", nil);
    self.commentView.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    self.commentView.textColor = RGBCOLOR(127, 127, 127);
    //[self.commentView.layer setBorderColor:RGBCOLOR(233, 233, 233).CGColor];
    //[self.commentView.layer setBorderWidth:1.0];
    //[self.commentView.layer setShadowOffset:CGSizeMake(0, 0)];
    //[self.commentView.layer setShadowOpacity:1 ];
    //[self.commentView.layer setShadowRadius:4.0];
    //[self.commentView.layer setShadowColor:RGBCOLOR(233, 233, 233).CGColor];
    //[self.commentView.layer setShadowPath:[[UIBezierPath bezierPathWithRect:self.commentView.bounds ] CGPath ] ];
    [self.footerView addSubview:textView];
    
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        enterButton.frame = CGRectMake(275.0, 5, 36, 31.0);
        [enterButton setImage:[UIImage imageNamed:@"enter-button"] forState:UIControlStateNormal];
        [enterButton addTarget:self action:@selector(didAddComment:event:) forControlEvents:UIControlEventTouchUpInside];
        [self.footerView addSubview:enterButton];

    } else {
        // Load resources for iOS 7 or later
        [self.sendButton addTarget:self action:@selector(didAddComment:event:) forControlEvents:UIControlEventTouchUpInside];

    }

}

#pragma mark - UITableViewDelegate methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrivateMessage *message = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if (![message.isFromSelf boolValue]) {
        OtherUserChatCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"OtherUserChatCell"];
        cell.otherUserText.text = message.message;
        cell.timeLabel.text = [_df stringFromDate:message.createdAt];
        cell.otherUserText.layer.cornerRadius = 20;
//        UITapGestureRecognizer *tg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapProfilePhoto:)];
//        [cell.profileImage addGestureRecognizer:tg];
        return cell;
    } else {
        CurrentUserChatCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CurrentUserChatCell"];
        cell.currentUserText.text = message.message;
        cell.currentUserText.layer.cornerRadius = 20;
        cell.timeLabel.text = [_df stringFromDate:message.createdAt];
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestMessage *message = [self.fetchedResultsController objectAtIndexPath:indexPath];
    CGSize size = [message.message sizeWithFont:[UIFont fontWithName:@"Helvetica-Light" size:17] constrainedToSize:CGSizeMake(280 - 25, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
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
        ALog(@"created at %@", restMessage.createdAt);
        [SVProgressHUD dismiss];
        PrivateMessage *privateMessage = [PrivateMessage privateMessageWithRestMessage:restMessage inManagedObjectContext:self.managedObjectContext];
        [self.otherUser addPrivateMessagesObject:privateMessage];
        [self.currentUser addPrivateMessagesObject:privateMessage];
        [self.managedObjectContext save:nil];
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

- (void)fetchResults {
    
//    NSManagedObjectContext *loadMessagesContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
//    loadMessagesContext.parentContext = self.managedObjectContext;
//    
//    [loadMessagesContext performBlock:^{
//        [RestMessage loadThreadWithUser:self.otherUser.externalId onLoad:^(NSSet *messages) {
//            for (RestMessage *restMessage in messages) {
//                [PrivateMessage privateMessageWithRestMessage:restMessage inManagedObjectContext:loadMessagesContext];
//            }
//            [loadMessagesContext save:nil];
//                
//            
//            [self.managedObjectContext performBlock:^{
//                [self.managedObjectContext save:nil];
//                if (!self.fetchedResultsController) {
//                    [self setupFetchedResultsController];
//                }
//                [self checkNoResults];
//                
//            }];
//            
//           
//                        
//        } onError:^(NSError *error) {
//            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//        }];
//
//    }];
}

- (IBAction)didTapProfilePhoto:(id)sender {
    NSInteger row = ((UITapGestureRecognizer *)sender).view.tag;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    Match *match = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"UserProfileFromChat" sender:match];
    
}

- (IBAction)didTapProfilePhotoRightButton:(id)sender {
    [self performSegueWithIdentifier:@"UserProfileFromChat" sender:self.otherUser];
    
}
@end
