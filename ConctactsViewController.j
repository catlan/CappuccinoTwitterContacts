@import <Foundation/CPObject.j>

@import <LPKit/LPKit.j>
@import <LPKit/LPMultiLineTextField.j>


@implementation CPAConctactsViewController : CPViewController
{
    CPArray					dataSourceRows;
    CPDictionary            sortedDict;                 
    CPTableView				theTableView;
    CPString                screenname;
    
    CPView                  rightView;
    CPImageView             avatarImageView;
    CPTextField             nameTextField;
    CPTextField             screennameTextField;
    CPTextField             locationTextField;
    LPAnchorButton          urlTextField;
    LPMultiLineTextField    descriptionTextField;
}

- (id)init
{
    if (self = [super init])
    {
        screenname = "catlan";
        sortedDict = [CPMutableDictionary dictionary];
    }
    return self;
}

- (void)loadView
{
	dataSourceRows = [CPMutableArray array];
	
	var contentView = [[CPView alloc] initWithFrame:CGRectMake(0,0,700,400)];
    [contentView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    
    var headerView = [[CPView alloc] initWithFrame:CGRectMake(0,0,700,70)];
    [headerView setAutoresizingMask:CPViewWidthSizable];
	[headerView setBackgroundColor:[CPColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1.0]];
	[contentView addSubview:headerView];

	var iconView = [[CPImageView alloc] initWithFrame:CGRectMake(5,6,59,61)];
	var iconPath = [[CPBundle mainBundle] pathForResource:@"TweetContacts.png"];
	[iconView setImage:[[CPImage alloc] initWithContentsOfFile:iconPath]];
	[headerView addSubview:iconView];
	
	var headerTextField = [[CPTextField alloc] initWithFrame:CGRectMake(74,22,200,30)];
	[headerTextField setFont:[CPFont boldSystemFontOfSize:20]];
	[headerTextField setTextColor:[CPColor colorWithHexString:@"ccc"]];
	[headerTextField setStringValue:@"Tweet Contacts"];
	[headerView addSubview:headerTextField];
	
	var anchorButton = [LPAnchorButton buttonWithTitle:@"Logout "+screenname];
    [anchorButton setAutoresizingMask:CPViewMinXMargin];

    // We want to the underline only when hovering
    [anchorButton setUnderlineMask:LPAnchorButtonHoverUnderline];

    // Set the colors
    [anchorButton setTextColor:[CPColor colorWithHexString:@"ccc"]];
    [anchorButton setTextHoverColor:[CPColor colorWithHexString:@"aaa"]];

    // Set the target & action just like a CPButton
    [anchorButton setTarget:self];
    [anchorButton setAction:@selector(didClickAnchorButton:)];
    [anchorButton setCenter:CGPointMake(600, 35)];
	[headerView addSubview:anchorButton];
	
	var verticalSplitter = [[CPSplitView alloc] initWithFrame:CGRectMake(0,70,700,330)];
	[verticalSplitter setDelegate:self];
	[verticalSplitter setVertical:YES]; 
	[verticalSplitter setIsPaneSplitter:YES];
	[verticalSplitter setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable ]; 

    
	var rightContainerView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 350, 330)];
	[rightContainerView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable ];
	[rightContainerView setBackgroundColor:[CPColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
	
	rightView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 350, 330)];
	[rightView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable ];
	[rightView setBackgroundColor:[CPColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
	[rightView setHidden:YES];
	[rightContainerView addSubview:rightView];
	
	avatarImageView = [[CPImageView alloc] initWithFrame:CGRectMake(90,40,48,48)];
	[rightView addSubview:avatarImageView];
	
	nameTextField = [[CPTextField alloc] initWithFrame:CGRectMake(149,40,700,30)];
	[nameTextField setFont:[CPFont boldSystemFontOfSize:20]];
	[nameTextField setTextColor:[CPColor colorWithHexString:@"333"]];
	[rightView addSubview:nameTextField];
	
	screennameTextField = [[CPTextField alloc] initWithFrame:CGRectMake(149,65,700,30)];
	[screennameTextField setFont:[CPFont systemFontOfSize:13]];
	[screennameTextField setTextColor:[CPColor colorWithHexString:@"333"]];
	[rightView addSubview:screennameTextField];
	
	var locationLabelTextField = [[CPTextField alloc] initWithFrame:CGRectMake(50,120,100,30)];
	[locationLabelTextField setFont:[CPFont boldSystemFontOfSize:13]];
	[locationLabelTextField setTextColor:[CPColor colorWithHexString:@"333"]];
	[locationLabelTextField setValue:CPRightTextAlignment forThemeAttribute:@"alignment"];
	[locationLabelTextField setStringValue:@"Location:"];
	[rightView addSubview:locationLabelTextField];
	
	locationTextField = [[CPTextField alloc] initWithFrame:CGRectMake(150,120,700,30)];
	[locationTextField setFont:[CPFont systemFontOfSize:13]];
	[locationTextField setTextColor:[CPColor colorWithHexString:@"333"]];
	[rightView addSubview:locationTextField];
	
	var urlLabelTextField = [[CPTextField alloc] initWithFrame:CGRectMake(50,140,100,30)];
	[urlLabelTextField setFont:[CPFont boldSystemFontOfSize:13]];
	[urlLabelTextField setTextColor:[CPColor colorWithHexString:@"333"]];
	[urlLabelTextField setValue:CPRightTextAlignment forThemeAttribute:@"alignment"];
	[urlLabelTextField setStringValue:@"Web:"];
	[rightView addSubview:urlLabelTextField];
	
	urlTextField = [LPAnchorButton buttonWithTitle:""];
	[urlTextField setFrame:CGRectMake(152,142,700,30)];
    [urlTextField setUnderlineMask:LPAnchorButtonHoverUnderline];
	[urlTextField setFont:[CPFont systemFontOfSize:13]];
    [urlTextField setTextColor:[CPColor colorWithHexString:@"1C4FAD"]];
    [urlTextField setTextHoverColor:[CPColor colorWithHexString:@"1C4FAD"]];
    [urlTextField setTarget:self];
    [urlTextField setAction:@selector(didClickAnchorButton:)];
	[rightView addSubview:urlTextField];
	
	var descLabelTextField = [[CPTextField alloc] initWithFrame:CGRectMake(50,160,100,30)];
	[descLabelTextField setFont:[CPFont boldSystemFontOfSize:13]];
	[descLabelTextField setTextColor:[CPColor colorWithHexString:@"333"]];
	[descLabelTextField setValue:CPRightTextAlignment forThemeAttribute:@"alignment"];
	[descLabelTextField setStringValue:@"Bio:"];
	[rightView addSubview:descLabelTextField];
	
	descriptionTextField = [[LPMultiLineTextField alloc] initWithFrame:CGRectMake(150,160,200,170)];
	[descriptionTextField setFont:[CPFont systemFontOfSize:13]];
	[descriptionTextField setTextColor:[CPColor colorWithHexString:@"333"]];
	[rightView addSubview:descriptionTextField];
	
	
    var scroll = [[CPScrollView alloc] initWithFrame:CGRectMake(0,0,200,400)];
    [scroll setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [scroll setHasHorizontalScroller:NO];
	
	theTableView = [[CPTableView alloc] initWithFrame:CGRectMakeZero()];
	[theTableView setDataSource:self];
	[theTableView setDelegate:self];
    [theTableView setUsesAlternatingRowBackgroundColors:YES];
    [theTableView setColumnAutoresizingStyle:CPTableViewUniformColumnAutoresizingStyle];
	//[[theTableView cornerView] setBackgroundColor:headerColor];
	
	
    var column = [[CPTableColumn alloc] initWithIdentifier:"0"];
    [[column headerView] setStringValue:"Name"];
    //[[column headerView] sizeToFit];
    //var columnHeaderView = [column headerView];
	//var headerColor = [CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:[CPTableView class]] pathForResource:@"Aristo.blend/Resources/button-bezel-center.png"]]];
    //[columnHeaderView setBackgroundColor:headerColor];
    [column setWidth:250];
    [column setResizingMask:CPTableColumnAutoresizingMask];
    [theTableView addTableColumn:column];
    
    [scroll setDocumentView:theTableView];
    

	[verticalSplitter addSubview:scroll];
	[verticalSplitter addSubview:rightContainerView];
    
    [contentView addSubview:verticalSplitter];
    
    [self setView:contentView];
    
     
    var url = "http://api.twitter.com/1/statuses/friends.json?screen_name="+screenname; 
	var request = [CPURLRequest requestWithURL: url];
    var connection = [CPURLConnection connectionWithRequest:request delegate:self];
   
}

- (void)setItems:(JSObject)myJSObject {
	if (myJSObject) {
        var nameDescriptor = [[CPSortDescriptor alloc] initWithKey:@"lastComponent" ascending:YES];
        var sortDescriptors = [CPArray arrayWithObject:nameDescriptor];

		
		for(var i=0; i<myJSObject.length; i++)
		{
			var item = myJSObject[i];
    		
    		var nameComponents = [item.name componentsSeparatedByString:" "];
    		var lastComponent = [[nameComponents lastObject] uppercaseString];
    		var firstLetter = [lastComponent substringToIndex:1];
    		
    		var rangeInAlphabet = [@"ABCDEFGHIJKLMNOPQRSTUVWXYZ" rangeOfString:firstLetter];
    		if (rangeInAlphabet.location == CPNotFound)
    		  firstLetter = "•";
    		  
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
		
		var aSortedArray = [CPMutableArray array];
		var allKeys = [[sortedDict allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
		for(var i=0; i<[allKeys count]; i++)
		{
    		var firstLetter = [allKeys objectAtIndex:i];
            [aSortedArray addObject:[CPString stringWithString:firstLetter]];
            var aGroup = [sortedDict objectForKey:firstLetter];
            var aSortedGroupd = [aGroup sortedArrayUsingDescriptors:sortDescriptors];
            
            for(var groupIndex=0; groupIndex<[aSortedGroupd count]; groupIndex++)
            {
                [aSortedArray addObject:[aSortedGroupd objectAtIndex:groupIndex]];
            }
		}
		
		dataSourceRows = aSortedArray;
		
    	[theTableView reloadData];
	}
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
	} else if ([tableColumn identifier] == "1") {
		return [dataSourceRows objectAtIndex:row].price;
	} else if ([tableColumn identifier] == "2") {
		return "";
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
        
        
        var avatarImage = [[CPImage alloc] initWithContentsOfFile:item.profile_image_url];
        [avatarImageView setImage:avatarImage];
        [nameTextField setStringValue:item.name];
        [screennameTextField setStringValue:"@"+item.screen_name];
        
        if (item.location)
            [locationTextField setStringValue:item.location];
        else
            [locationTextField setStringValue:@"-"];
        
        if (item.url)
            [urlTextField setTitle:item.url];
        else
            [urlTextField setTitle:@"-"];
        [urlTextField setEnabled:(item.url)];
        
        if (item.description)
            [descriptionTextField setStringValue:item.description];
        else
            [descriptionTextField setStringValue:@"-"];
        console.log(item);
    }
    else
    {
    
    }
    [rightView setHidden:(row == CPNotFound)];
}

/* CPURLConnection Delegate */

- (void)connection:(CPURLConnection)aConnection didReceiveData:(CPString)data {
	var myJSObject = JSON.parse(data);
	
	if (myJSObject)
		[self setItems:myJSObject];
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

@end