//
//  RTagCloudView.h
//  RTagCloudView
//
//  Created by rickytan on 12-5-28.
//  Copyright (c) 2012年 rickytan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class RTagCloudView;

@protocol RTagCloudViewDatasource <NSObject>
@required
- (NSInteger)numberOfTags:(RTagCloudView*)tagCloud;
- (NSString*)RTagCloudView:(RTagCloudView*)tagCloud tagNameOfIndex:(NSInteger)index;
@optional
- (UIColor*)RTagCloudView:(RTagCloudView*)tagCloud tagColorOfIndex:(NSInteger)index;
- (UIFont*)RTagCloudView:(RTagCloudView *)tagCloud tagFontOfIndex:(NSInteger)index;
@end

@protocol RTagCloudViewDelegate <NSObject>
@optional
- (void)RTagCloudView:(RTagCloudView*)tagCloud didTapOnTagOfIndex:(NSInteger)index;

@end

@interface RTagCloudView : UIView
{
    CGFloat                         _radius;
    CGFloat                         _speedX,_speedY;
    
    CGFloat                         sa,sb,sc,ca,cb,cc;
    
    NSInteger                       _numberOfTags;
    NSMutableArray                 *_tabLabels;
    
    NSTimer                        *_timer;
    BOOL                            _active;
    
}

@property (nonatomic, retain) id<RTagCloudViewDatasource> dataSource;
@property (nonatomic, retain) id<RTagCloudViewDelegate> delegate;

- (void)reloadData;

@end
