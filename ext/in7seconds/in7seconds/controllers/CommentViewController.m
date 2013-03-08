//
//  CommentViewController.m
//  in7seconds
//
//  Created by Ryan Romanchuk on 3/6/13.
//  Copyright (c) 2013 Ryan Romanchuk. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()

@end

@implementation CommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


#pragma mark - UITableViewDelegate methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSString *identifier = @"NewCommentCell";
//    NewCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil) {
//        cell = [[NewCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    
//    if ([cell.profilePhotoView.gestureRecognizers count] == 0) {
//        UITapGestureRecognizer *tapProfile = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didPressProfilePhoto:)];
//        [cell.profilePhotoView addGestureRecognizer:tapProfile];
//    }
//    
//    cell.profilePhotoView.tag = indexPath.row;
//    
//    
//    cell.timeInWordsLabel.backgroundColor = [UIColor backgroundColor];
//    cell.userCommentLabel.backgroundColor = [UIColor backgroundColor];
//    Comment *comment = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    cell.nameLabel.text = comment.user.fullName;
//    cell.userCommentLabel.text = comment.comment;
//    
//    //cell.userCommentLabel.backgroundColor = [UIColor yellowColor];
//    //ALog(@"string is %@", fullString);
//    CGSize expectedCommentLabelSize = [comment.comment sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0] constrainedToSize:CGSizeMake(COMMENT_LABEL_WIDTH, CGFLOAT_MAX)];
//    int height = MAX(expectedCommentLabelSize.height, 25);
//    [cell.userCommentLabel setFrame:CGRectMake(cell.userCommentLabel.frame.origin.x, cell.userCommentLabel.frame.origin.y, COMMENT_LABEL_WIDTH, height)];
//    
//    
//    
//    ALog(@"recomed: %f,%f  actual: %f,%f", expectedCommentLabelSize.height, expectedCommentLabelSize.width, cell.userCommentLabel.frame.size.height, cell.userCommentLabel.frame.size.width);
//    cell.timeInWordsLabel.text = [comment.createdAt distanceOfTimeInWords];
//    
//    [cell.timeInWordsLabel sizeToFit];
//    [cell.timeInWordsLabel setFrame:CGRectMake(cell.userCommentLabel.frame.origin.x, (cell.userCommentLabel.frame.origin.y + cell.userCommentLabel.frame.size.height) + 2.0, cell.timeInWordsLabel.frame.size.width, cell.timeInWordsLabel.frame.size.height + 4.0)];
//    [cell.profilePhotoView setProfileImageForUser:comment.user];
//    
//    return cell;
}

#warning add constants
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    Comment *comment = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    DLog(@"COMMENT IS %@", comment.comment);
//    UILabel *sampleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, COMMENT_LABEL_WIDTH, CGFLOAT_MAX)];
//    sampleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
//    sampleLabel.text = [NSString stringWithFormat:@"%@", comment.comment];
//    
//    CGSize expectedCommentLabelSize = [sampleLabel.text sizeWithFont:sampleLabel.font
//                                                   constrainedToSize:CGSizeMake(COMMENT_LABEL_WIDTH, CGFLOAT_MAX)                                                       lineBreakMode:UILineBreakModeWordWrap];
//    
//    
//    DLog(@"Returning expected height of %f", expectedCommentLabelSize.height);
//    int totalHeight;
//    totalHeight = 24 + expectedCommentLabelSize.height + 2 + 16 + 6;;
//    
//    DLog(@"total height %d", totalHeight);
//    return totalHeight;
    
}




- (void)keyboardWillHide:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
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
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
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


@end
