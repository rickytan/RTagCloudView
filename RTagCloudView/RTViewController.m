//
//  RTViewController.m
//  RTagCloudView
//
//  Created by rickytan on 12-5-28.
//  Copyright (c) 2012年 rickytan. All rights reserved.
//

#import "RTViewController.h"


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
    tagCloud.backgroundColor = [UIColor clearColor];
    tagCloud.center = CGPointMake(self.view.bounds.size.width /2, self.view.bounds.size.height / 2);
    tagCloud.dataSource = self;
    tagCloud.delegate = self;
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

#pragma mark - RTagCloudViewDatasource

- (NSString*)RTagCloudView:(RTagCloudView *)tagCloud
            tagNameOfIndex:(NSInteger)index
{
    return [NSString stringWithFormat:@"Tag of %d",index];
}

- (UIFont*)RTagCloudView:(RTagCloudView *)tagCloud
          tagFontOfIndex:(NSInteger)index
{
    UIFont *fonts[] = {
        [UIFont systemFontOfSize:14.f],
        [UIFont systemFontOfSize:16.f],
        [UIFont systemFontOfSize:18.f],
        [UIFont systemFontOfSize:20.f],
        [UIFont systemFontOfSize:22.f],
        [UIFont systemFontOfSize:24.f],
        [UIFont systemFontOfSize:26.f]
    };
    return fonts[index%7];
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

#pragma mark - RTagCloudViewDelegate

- (void)RTagCloudView:(RTagCloudView*)tagCloud didTapOnTagOfIndex:(NSInteger)index
{
    UILabel* resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 200.f, 30.f)];
    resultLabel.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.8f];
    resultLabel.textAlignment = NSTextAlignmentCenter;
    resultLabel.textColor = [UIColor whiteColor];
    resultLabel.center = CGPointMake(self.view.bounds.size.width /2, 50.f);
    [self.view addSubview:resultLabel];
    
    resultLabel.text = [NSString stringWithFormat:@"Tag of %d", index];
    [resultLabel performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0f];
}

@end