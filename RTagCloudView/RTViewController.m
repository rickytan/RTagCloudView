//
//  RTViewController.m
//  RTagCloudView
//
//  Created by  on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RTViewController.h"

@implementation RTViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    RTagCloudView *tagCloud = [[RTagCloudView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    tagCloud.dataSource = self;
    [self.view addSubview:tagCloud];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)numberOfTags:(RTagCloudView *)tagCloud
{
    return 32;
}

- (NSString*)RTagCloudView:(RTagCloudView *)tagCloud
            tagNameOfIndex:(NSInteger)index
{
    return [NSString stringWithFormat:@"Tag of %d",index];
}

- (UIColor*)RTagCloudView:(RTagCloudView *)tagCloud tagColorOfIndex:(NSInteger)index
{
    UIColor *colors[] = {
        [UIColor redColor],
        [UIColor yellowColor],
        [UIColor blueColor],
        [UIColor orangeColor],
        [UIColor blackColor],
        [UIColor purpleColor],
        [UIColor greenColor]
    };
    return colors[index%7];
}

@end
