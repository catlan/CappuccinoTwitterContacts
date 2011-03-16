@import <Foundation/CPObject.j>

@import <LPKit/LPKit.j>
@import <EKShakeAnimation/EKShakeAnimation.j>
@import <EKActivityIndicatorView/EKActivityIndicatorView.j>


@implementation CPALoginViewController : CPViewController
{
    CPView                  loginView;
    CPTextField             userLable;
    CPTextField             userTextField;
    EKActivityIndicatorView activityIndicator;
    CPCheckBox              rememberCheckBox;
    CPButton                preButton;
}

- (id)init
{
    if (self = [super init])
    {
    }
    return self;
}

- (void)loadView
{
	var contentView = [[CPView alloc] initWithFrame:CGRectMake(0,0,330,190)];
    [contentView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    
    
	loginView = [[CPView alloc] initWithFrame:CGRectMake(5,5,320,180)];
    [loginView setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
    [contentView addSubview:loginView];
    
    userLable = [CPTextField labelWithTitle:@"Welcome!"];
    [userLable setFrame:CGRectMake(0, 20, 320, 30)];
	[userLable setFont:[CPFont boldSystemFontOfSize:20]];
	[userLable setTextColor:[CPColor colorWithHexString:@"ccc"]];
	[userLable setValue:CPCenterTextAlignment forThemeAttribute:@"alignment"];
    [loginView addSubview:userLable];
        
    userTextField = [CPTextField textFieldWithStringValue:"" placeholder:"Twitter Screenname" width:100];
    [userTextField setFrame:CGRectMake(60, 55, 200, 30)];
    [loginView addSubview:userTextField];
    
    activityIndicator = [[EKActivityIndicatorView alloc] initWithFrame:CGRectMake(265, 61, 18, 18)];
	[loginView addSubview:activityIndicator];
    
    rememberCheckBox = [CPCheckBox checkBoxWithTitle:@"Remember me"];
    [rememberCheckBox setFrame:CGRectMake(64, 90, 130, 24)];
    [loginView addSubview:rememberCheckBox];
    	
            
    preButton = [CPButton buttonWithTitle:@"Sign In"];
    [preButton setFrame:CGRectMake(197, 90, 60, 24)];
    [preButton setAction:@selector(loginAction:)];
    [preButton setTarget:self];
    [preButton setKeyEquivalent:CPNewlineCharacter]
    [loginView addSubview:preButton];
    	
    [self setView:contentView];
   
}

- (void)setControlsEnabled:(BOOL)isEnabled
{
    [userTextField setEnabled:isEnabled];
    [rememberCheckBox setEnabled:isEnabled];
    [preButton setEnabled:isEnabled];
    if (!isEnabled)
        [activityIndicator startAnimating];
    else
        [activityIndicator stopAnimating];
    [activityIndicator setHidden:isEnabled];
}

- (void)loginAction:(id)sender
{
    [self setControlsEnabled:NO];
    
    var url = "http://api.twitter.com/1/users/show.json?screen_name="+[userTextField stringValue]; 
	var request = [CPURLRequest requestWithURL: url];
    var connection = [CPJSONPConnection sendRequest:request callback:"callback" delegate:self];
}

/* CPURLConnection Delegate */

- (void)connection:(CPJSONPConnection)aConnection didReceiveData:(CPString)data
{
    [self setControlsEnabled:YES];
    
	//var myJSObject = JSON.parse(data);
	var myJSObject = data;
	if (myJSObject) {
        if (myJSObject.error == "Not found") {
            var animation = [[EKShakeAnimation alloc] initWithView:loginView];
            [userLable setStringValue:@"Couldn't find user."];
            return;
        }
        //if (myJSObject["protected"])
        //    [userLable setStringValue:@"Currently not working with protected profiles."];
        
        if ([rememberCheckBox state] == CPOnState)
            [[LPCookieController sharedCookieController] setValue:[userTextField stringValue] forKey:@"screenname"];
            
        [[[CPApplication sharedApplication] delegate] applicationDidFinishLogin:[userTextField stringValue]];
	}
}

- (void)connection:(CPJSONPConnection)connection didFailWithError:(id)error
{
    [self setControlsEnabled:YES];
    
    if (error == 404) 
        [userLable setStringValue:@"Couldn't find user."];
    else
        [userLable setStringValue:error];
}

- (void)connectionDidFinishLoading:(CPJSONPConnection)aConnection {
}

@end