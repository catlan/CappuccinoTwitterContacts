@import <Foundation/CPObject.j>

@import <LPKit/LPKit.j>
@import <EKGradientView/EKGradientView.j>
@import <EKActivityIndicatorView/EKActivityIndicatorView.j>


@implementation CPAConctactsViewController : CPViewController
{
    CPString                screenname;
    id                      currentCursor;
    
    CPArray					dataSourceRows;
    CPDictionary            sortedDict;
    
    CPTextField             searchTextField;
    CPScrollView            scroll;
    CPTableView				theTableView;
    BOOL                    statusBarHidden;
    CPView                  statusView;
    EKActivityIndicatorView activityIndicator;
    
    CPView                  rightView;
    CPImage                 avatarImage;
    CPImageView             avatarImageView;
    CPTextField             nameTextField;
    LPAnchorButton          screennameTextField;
    CPTextField             locationTextField;
    LPAnchorButton          urlTextField;
    LPMultiLineTextField    descriptionTextField;
}

- (id)initWithScreenname:(CPString)aScreenname
{
    if (self = [super init])
    {
        screenname = aScreenname;
        currentCursor = @"-1";
        sortedDict = [CPMutableDictionary dictionary];
        statusBarHidden = YES;
    }
    return self;
}

- (void)loadView
{
	dataSourceRows = [CPMutableArray array];
	
	var contentView = [[CPView alloc] initWithFrame:CGRectMake(0,0,700,400)];
    [contentView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    
    var headerView = [[EKGradientView alloc] initWithFrame:CGRectMake(0,0,700,70)];
    [headerView setAutoresizingMask:CPViewWidthSizable];
	[headerView setColor2:[CPColor colorWithRed:111.0/255.0 green:111.0/255.0 blue:111.0/255.0 alpha:1.0]];
	[headerView setColor1:[CPColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]];
	[contentView addSubview:headerView];

	var iconView = [[CPImageView alloc] initWithFrame:CGRectMake(5,6,59,61)];
	var iconPath = [[CPBundle mainBundle] pathForResource:@"TweetContacts.png"];
	[iconView setImage:[[CPImage alloc] initWithContentsOfFile:iconPath]];
	[headerView addSubview:iconView];
	
	var headerTextField = [[CPTextField alloc] initWithFrame:CGRectMake(74, 12, 200, 30)];
	[headerTextField setFont:[CPFont boldSystemFontOfSize:20]];
	[headerTextField setTextColor:[CPColor colorWithHexString:@"E8E8E8"]];
    [headerTextField setTextShadowColor:[CPColor colorWithHexString:@"2B2B2B"]];
    [headerTextField setTextShadowOffset:CGSizeMake(0,1)]; 
	[headerTextField setStringValue:@"Contacts for Twitter"];
	[headerView addSubview:headerTextField];
	
	var catlanButton = [LPAnchorButton buttonWithTitle:@"Developed by @catlan"];
    [catlanButton setFrame:CGRectMake(74, 40, 200, 30)];
    [catlanButton setUnderlineMask:LPAnchorButtonHoverUnderline];
    [catlanButton setTextColor:[CPColor colorWithHexString:@"ccc"]];
    [catlanButton setTextHoverColor:[CPColor colorWithHexString:@"aaa"]];
    [catlanButton setTarget:self];
    [catlanButton setAction:@selector(openCatlanTwitterProfile:)];
	[headerView addSubview:catlanButton];
	
	var anchorButton = [LPAnchorButton buttonWithTitle:@"Logout "+screenname];
    [anchorButton setAutoresizingMask:CPViewMinXMargin];
    [anchorButton setUnderlineMask:LPAnchorButtonHoverUnderline];
    [anchorButton setTextColor:[CPColor colorWithHexString:@"ccc"]];
    [anchorButton setTextHoverColor:[CPColor colorWithHexString:@"aaa"]];
    [anchorButton setTarget:self];
    [anchorButton setAction:@selector(logoutAction:)];
    [anchorButton setCenter:CGPointMake(600, 35)];
	[headerView addSubview:anchorButton];
	
	var verticalSplitter = [[CPSplitView alloc] initWithFrame:CGRectMake(0,70,700,330)];
	[verticalSplitter setDelegate:self];
	[verticalSplitter setVertical:YES]; 
	[verticalSplitter setIsPaneSplitter:YES];
	[verticalSplitter setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable ]; 

    
	var rightContainerView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 480, 330)];
	[rightContainerView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable ];
	[rightContainerView setBackgroundColor:[CPColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
	
	rightView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 480, 330)];
	[rightView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable ];
	[rightView setBackgroundColor:[CPColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
	[rightView setHidden:YES];
	[rightContainerView addSubview:rightView];
	
	avatarImageView = [[CPImageView alloc] initWithFrame:CGRectMake(90,40,48,48)];
	[rightView addSubview:avatarImageView];
	
	nameTextField = [[CPTextField alloc] initWithFrame:CGRectMake(149,40,300,30)];
	[nameTextField setFont:[CPFont boldSystemFontOfSize:20]];
	[nameTextField setTextColor:[CPColor colorWithHexString:@"333"]];
	[nameTextField setSelectable:YES];
	[rightView addSubview:nameTextField];
	
	screennameTextField = [LPAnchorButton buttonWithTitle:""];
	[screennameTextField setFrame:CGRectMake(152,67,300,30)];
    [screennameTextField setUnderlineMask:LPAnchorButtonHoverUnderline];
	[screennameTextField setFont:[CPFont systemFontOfSize:13]];
    [screennameTextField setTextColor:[CPColor colorWithHexString:@"1C4FAD"]];
    [screennameTextField setTextHoverColor:[CPColor colorWithHexString:@"1C4FAD"]];
    [screennameTextField setTarget:self];
    [screennameTextField setAction:@selector(openTwitterProfile:)];
	[rightView addSubview:screennameTextField];
	
	var locationLabelTextField = [[CPTextField alloc] initWithFrame:CGRectMake(50,120,100,30)];
	[locationLabelTextField setFont:[CPFont boldSystemFontOfSize:13]];
	[locationLabelTextField setTextColor:[CPColor colorWithHexString:@"333"]];
	[locationLabelTextField setValue:CPRightTextAlignment forThemeAttribute:@"alignment"];
	[locationLabelTextField setStringValue:@"Location:"];
	[rightView addSubview:locationLabelTextField];
	
	locationTextField = [[CPTextField alloc] initWithFrame:CGRectMake(150,120,300,30)];
	[locationTextField setFont:[CPFont systemFontOfSize:13]];
	[locationTextField setTextColor:[CPColor colorWithHexString:@"333"]];
	[locationTextField setSelectable:YES];
	[rightView addSubview:locationTextField];
	
	var urlLabelTextField = [[CPTextField alloc] initWithFrame:CGRectMake(50,140,100,30)];
	[urlLabelTextField setFont:[CPFont boldSystemFontOfSize:13]];
	[urlLabelTextField setTextColor:[CPColor colorWithHexString:@"333"]];
	[urlLabelTextField setValue:CPRightTextAlignment forThemeAttribute:@"alignment"];
	[urlLabelTextField setStringValue:@"Web:"];
	[rightView addSubview:urlLabelTextField];
	
	urlTextField = [LPAnchorButton buttonWithTitle:""];
	[urlTextField setFrame:CGRectMake(152,142,300,30)];
    [urlTextField setUnderlineMask:LPAnchorButtonHoverUnderline];
	[urlTextField setFont:[CPFont systemFontOfSize:13]];
    [urlTextField setTextColor:[CPColor colorWithHexString:@"1C4FAD"]];
    [urlTextField setTextHoverColor:[CPColor colorWithHexString:@"1C4FAD"]];
    [urlTextField setTarget:self];
    [urlTextField setAction:@selector(openProfileURLAction:)];
	[rightView addSubview:urlTextField];
	
	var descLabelTextField = [[CPTextField alloc] initWithFrame:CGRectMake(50,160,100,30)];
	[descLabelTextField setFont:[CPFont boldSystemFontOfSize:13]];
	[descLabelTextField setTextColor:[CPColor colorWithHexString:@"333"]];
	[descLabelTextField setValue:CPRightTextAlignment forThemeAttribute:@"alignment"];
	[descLabelTextField setStringValue:@"Bio:"];
	[rightView addSubview:descLabelTextField];
	
	descriptionTextField = [[CPTextField alloc] initWithFrame:CGRectMake(150, 160, 200, 100)];
	[descriptionTextField setFont:[CPFont systemFontOfSize:13]];
	[descriptionTextField setTextColor:[CPColor colorWithHexString:@"333"]];
	[descriptionTextField setLineBreakMode:CPLineBreakByWordWrapping]; 
	[descriptionTextField setSelectable:YES];
	[rightView addSubview:descriptionTextField];
	
	tweetTextField = [[CPTextField alloc] initWithFrame:CGRectMake(90, 260, 260, 70)];
	[tweetTextField setFont:[CPFont systemFontOfSize:13]];
	[tweetTextField setTextColor:[CPColor colorWithHexString:@"333"]];
	[tweetTextField setLineBreakMode:CPLineBreakByWordWrapping]; 
	[tweetTextField setSelectable:YES];
	[rightView addSubview:tweetTextField];
	
	
	var leftContainerView = [[CPView alloc] initWithFrame:CGRectMake(0,0,220,400)];
    [leftContainerView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    
    var searchView = [[EKGradientView alloc] initWithFrame:CGRectMake(0, 0, 220, 40)];
    [searchView setAutoresizingMask:CPViewWidthSizable];
	[searchView setColor1:[CPColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
	[searchView setColor2:[CPColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
    [leftContainerView addSubview:searchView];
    
    searchTextField = [CPTextField roundedTextFieldWithStringValue:"" placeholder:"Search" width:210];
    [searchTextField setAutoresizingMask:CPViewWidthSizable];
    [searchTextField setCenter:[searchView center]];
    [searchTextField setDelegate:self];
    [searchView addSubview:searchTextField];
    
    var searchBorderLine = [[CPView alloc] initWithFrame:CGRectMake(0, 39, 220, 1)];
    [searchBorderLine setAutoresizingMask:CPViewWidthSizable];
	[searchBorderLine setBackgroundColor:[CPColor colorWithRed:165.0/255.0 green:165.0/255.0 blue:165.0/255.0 alpha:1.0]];
    [searchView addSubview:searchBorderLine];
	
	
    scroll = [[CPScrollView alloc] initWithFrame:CGRectMake(0, 40, 220, 360)];
    [scroll setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [scroll setHasHorizontalScroller:NO];
    [leftContainerView addSubview:scroll];
	
	theTableView = [[CPTableView alloc] initWithFrame:CGRectMake(0, 0, 220-15, 360)];
    [scroll setDocumentView:theTableView];
	[theTableView setDataSource:self];
	[theTableView setDelegate:self];
    [theTableView setHeaderView:nil];
    [theTableView setCornerView:nil];
    [theTableView setUsesAlternatingRowBackgroundColors:YES];
    [theTableView setColumnAutoresizingStyle:CPTableViewUniformColumnAutoresizingStyle];
    var column = [[CPTableColumn alloc] initWithIdentifier:"0"];
    //[[column headerView] setStringValue:"Name"];
    [column setWidth:220-20];
    [column setResizingMask:CPTableColumnAutoresizingMask];
    [theTableView addTableColumn:column];
    
    statusView = [[EKGradientView alloc] initWithFrame:CGRectMake(0, 400, 220, 40)];
    [statusView setAutoresizingMask:CPViewMinYMargin|CPViewWidthSizable];
	[statusView setColor1:[CPColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
	[statusView setColor2:[CPColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
    [leftContainerView addSubview:statusView];
    
    activityIndicator = [[EKActivityIndicatorView alloc] initWithFrame:CGRectMake(15, 11, 18, 18)];
	[statusView addSubview:activityIndicator];
    
	var statusLabel = [[CPTextField alloc] initWithFrame:CGRectMake(40, 11, 140, 30)];
	[statusLabel setFont:[CPFont boldSystemFontOfSize:13]];
	[statusLabel setTextColor:[CPColor colorWithHexString:@"333"]];
	[statusLabel setStringValue:@"Load Contacts..."];
	[statusView addSubview:statusLabel];
    
	[verticalSplitter addSubview:leftContainerView];
	[verticalSplitter addSubview:rightContainerView];
    //[verticalSplitter setPosition:201 ofDividerAtIndex:0];
    
    [contentView addSubview:verticalSplitter];
    
    [self setView:contentView];
    

}

- (void) viewDidLoad
{
}

- (void)loadContacts
{
    if (statusBarHidden)
        [self setStatusBarHidden:NO];
        
    var url = "http://api.twitter.com/1/statuses/friends.json?screen_name="+screenname+"&cursor="+currentCursor; 
	var request = [CPURLRequest requestWithURL: url];
    var connection = [CPJSONPConnection sendRequest:request callback:"callback" delegate:self];
   
}

- (void)setStatusBarHidden:(BOOL)flag
{
    statusBarHidden = flag;
    if (statusBarHidden)
        [activityIndicator stopAnimating];
    else
        [activityIndicator startAnimating];
    
    var aFrame1 = [scroll frame];
    aFrame1.size.height += (flag) ? 40 : -40;
    var aFrame2 = [statusView frame];
    aFrame2.origin.y += (flag) ? 40 : -40;
    
    var animation = [[CPViewAnimation alloc] initWithViewAnimations:[
		[CPDictionary dictionaryWithJSObject:{
			CPViewAnimationTargetKey:scroll, 
			CPViewAnimationStartFrameKey:[scroll frame],
			CPViewAnimationEndFrameKey:aFrame1
		}],
		[CPDictionary dictionaryWithJSObject:{
			CPViewAnimationTargetKey:statusView, 
			CPViewAnimationStartFrameKey:[statusView frame],
			CPViewAnimationEndFrameKey:aFrame2
		}]
	]];
	[animation setAnimationCurve:CPAnimationLinear];
	[animation setDuration:0.5];
	[animation startAnimation];
}

- (void)logoutAction:(id)sender
{
    [[LPCookieController sharedCookieController] removeValueForKey:@"screenname"];
    [[[CPApplication sharedApplication] delegate] applicationDidFinishLogout];
}

- (void)openCatlanTwitterProfile:(id)sender
{
    [self openURL:@"http://twitter.com/catlan"];
}

- (void)openTwitterProfile:(id)sender
{
    [self openURL:"http://twitter.com/" + [[screennameTextField title] substringFromIndex:1]];
}

- (void)openProfileURLAction:(id)sender
{
    [self openURL:[urlTextField title]];
}

- (void)openURL:(CPString)anURL
{
    window.open(anURL, "_blank", "menubar=yes,location=yes,resizable=yes,scrollbars=yes,status=no");
}

- (void)setItems:(JSObject)myJSObject {
	if (myJSObject) {
        if(myJSObject.next_cursor) {
            currentCursor = myJSObject.next_cursor;
            [self loadContacts];
        } else {
            [self setStatusBarHidden:YES];
        }
		
        //console.log(myJSObject);
		for(var i=0,count=myJSObject.users.length; i<count; i++)
		{
			var item = myJSObject.users[i];
    		
    		var nameComponents = [item.name componentsSeparatedByString:" "];
    		var lastComponent;// = [[nameComponents lastObject] uppercaseString];
    		var firstLetter;// = [lastComponent substringToIndex:1];
    		
    		for (var nameComponentIndex=[nameComponents count]-1; nameComponentIndex>=0; nameComponentIndex--)
    		{
                lastComponent = [[nameComponents objectAtIndex:nameComponentIndex] uppercaseString];
                firstLetter = [lastComponent substringToIndex:1];
                var rangeInAlphabet = [@"ABCDEFGHIJKLMNOPQRSTUVWXYZ" rangeOfString:firstLetter];
                if (rangeInAlphabet.location == CPNotFound && nameComponentIndex == 0)
                    firstLetter = "•";
                else if (rangeInAlphabet.location != CPNotFound)
                    break;
            }
    		  
    		var aGroup = [sortedDict objectForKey:firstLetter];
    		if (!aGroup) {
                 aGroup = [CPMutableArray array];
                 [sortedDict setObject:aGroup forKey:firstLetter];
            }
            
            var itemDict = [CPMutableDictionary dictionary];
            [itemDict setObject:item forKey:"data"];
            [itemDict setObject:lastComponent forKey:"lastComponent"];
    		[aGroup addObject:itemDict];
            
		}
		
		[self reloadData]
	}
}

- (void)reloadData
{
    var isSearching = ([searchTextField stringValue] != "");
    var searchString = [[searchTextField stringValue] uppercaseString];
    var nameDescriptor = [[CPSortDescriptor alloc] initWithKey:@"lastComponent" ascending:YES];
    var sortDescriptors = [CPArray arrayWithObject:nameDescriptor];
    var aSortedArray = [CPMutableArray array];
    var allKeys = [[sortedDict allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    for(var i=0; i<[allKeys count]; i++)
    {
        var firstLetter = [allKeys objectAtIndex:i];
        if (!firstLetter) {
            console.log("WTF? i=="+i+" [allKeys count]=="+[allKeys count]);
            continue;
        }
        var aGroup = [sortedDict objectForKey:firstLetter];
        var aSortedGroupd = [aGroup sortedArrayUsingDescriptors:sortDescriptors];
        var groupStartPosition = [aSortedArray count];
        var isGroupEmpty = YES;
            
        for(var groupIndex=0; groupIndex<[aSortedGroupd count]; groupIndex++)
        {
            var item = [aSortedGroupd objectAtIndex:groupIndex];
            if (isSearching) {
                var uppercaseName = [item objectForKey:@"uppercaseName"];
                if (!uppercaseName) {
                    uppercaseName = [[item objectForKey:@"data"].name uppercaseString];
                    [item setObject:uppercaseName forKey:@"uppercaseName"];
                }
                var range = [uppercaseName rangeOfString:searchString];
                if (range.location == CPNotFound)
                    continue;
            }
            [aSortedArray addObject:item];
            isGroupEmpty = NO;
        }
        
        if (!isGroupEmpty)
            [aSortedArray insertObject:[CPString stringWithString:firstLetter] atIndex:groupStartPosition];
    }
		
    dataSourceRows = aSortedArray;
    //console.log("dataSourceRows=="+[dataSourceRows count]);
		
    [theTableView reloadData];
}

/* TableView DataSource */

- (int)numberOfRowsInTableView:(CPTableView)tableView
{
    return [dataSourceRows count];
}

- (id)tableView:(CPTableView)tableView objectValueForTableColumn:(CPTableColumn)tableColumn row:(int)row
{
    if ([tableColumn identifier] == "0") {
        var item = [dataSourceRows objectAtIndex:row];
        if ([item isMemberOfClass:[CPString class]]) {
            return item;
        } else {
            return [item objectForKey:"data"].name;    
        }
	} else {
		return "WRONG";
	}
	
}

- (BOOL)tableView:(CPTableView)aTableView isGroupRow:(int)row
{
    var item = [dataSourceRows objectAtIndex:row];
    return ([item isMemberOfClass:[CPString class]]);
}

- (BOOL)tableView:(CPTableView)aTableView shouldSelectRow:(int)row
{
    var item = [dataSourceRows objectAtIndex:row];
    return (![item isMemberOfClass:[CPString class]]);
}

/* TableView Delegate */

- (void)tableViewSelectionDidChange:(CPNotification)aNotification
{
    var row = [[theTableView selectedRowIndexes] firstIndex];
    if (row != CPNotFound)
    {
        var item = [[dataSourceRows objectAtIndex:row] objectForKey:"data"];
        
        
        var anAvatarImage = [[CPImage alloc] initWithContentsOfFile:item.profile_image_url];
        [anAvatarImage setDelegate:self];
        if ([anAvatarImage loadStatus] == CPImageLoadStatusCompleted)
            [avatarImageView setImage:anAvatarImage];
        else
            [avatarImageView setImage:nil];
        avatarImage = anAvatarImage;
        
        [nameTextField setStringValue:item.name];
        [screennameTextField setTitle:"@"+item.screen_name];
        [screennameTextField sizeToFit];
        
        if (item.location)
            [locationTextField setStringValue:item.location];
        else
            [locationTextField setStringValue:@"-"];
        
        if (item.url) {
            [urlTextField setTitle:item.url];
            [urlTextField sizeToFit];
        } else {
            [urlTextField setTitle:@"-"];
        }
        [urlTextField setEnabled:(item.url)];
        
        var text = (item.description) ? item.description : @"-";
        [descriptionTextField setStringValue:text];
        var aSize1 = [text sizeWithFont:[descriptionTextField font] inWidth:200];
        var aFrame1 = [descriptionTextField frame];
        aSize1.height += 10;
        aFrame1.size = aSize1;
        [descriptionTextField setFrame:aFrame1];
        
        text = (item.status) ? item.status.text : @"";
        [tweetTextField setStringValue:text];
        var aSize2 = [text sizeWithFont:[tweetTextField font] inWidth:280];
        var aFrame2 = [tweetTextField frame];
        aSize2.height += 10;
        aFrame2.size = aSize2;
        aFrame2.origin.y = aFrame1.origin.y + aFrame1.size.height + 20;
        [tweetTextField setFrame:aFrame2];
    }
    else
    {
    
    }
    
    if ([rightView isHidden] != (row == CPNotFound)) {
        var animation = [[CPViewAnimation alloc] initWithViewAnimations:[
            [CPDictionary dictionaryWithJSObject:{
                CPViewAnimationTargetKey:rightView, 
                CPViewAnimationEffectKey: (row == CPNotFound) ? CPViewAnimationFadeOutEffect : CPViewAnimationFadeInEffect
            }],
        ]];
        [animation setAnimationCurve:CPAnimationLinear];
        [animation setDuration:0.3];
        [animation startAnimation];
	
        [rightView setHidden:(row == CPNotFound)];
    }
}

/* CPURLConnection Delegate */

- (void)connection:(CPURLConnection)aConnection didReceiveData:(CPString)data {
	var myJSObject = data;//JSON.parse(data);
	
	if (myJSObject)
		[self setItems:myJSObject];
}

- (void)connection:(CPURLConnection)connection didFailWithError:(id)error
{
    [self loadContacts];
}

- (void)connectionDidFinishLoading:(CPURLConnection)aConnection {
}

/* CPSplitView Delegate */

- (int)splitView:(CPSplitView)splitView constrainMinCoordinate:(int)minCoord ofSubviewAt:(int)index
{
    if (index == 0)
    {
        return 200;
    }
    else
    {
        return minCoord;
    }
}

- (int)splitView:(CPSplitView)splitView constrainMaxCoordinate:(int)minCoord ofSubviewAt:(int)index
{
    if (index == 0)
    {
        var rect = [[self view] frame];
        return rect.size.width / 2;
    }
    else
    {
        return minCoord;
    }
}

/* CPSplitView Delegate */

- (void)imageDidLoad:(CPImage)anImage
{
    if (avatarImage == anImage)
        [avatarImageView setImage:anImage];
}

/* CPTextField Delegate */

- (void)controlTextDidChange:(id)aTextField
{
    [theTableView deselectAll]
    [self reloadData];
}

- (void)controlTextDidEndEditing:(id)aTextField
{

}


@end