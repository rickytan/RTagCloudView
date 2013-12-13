//
//  RTagCloudView.m
//  RTagCloudView
//
//  Created by rickytan on 12-5-28.
//  Copyright (c) 2012年 rickytan. All rights reserved.
//

#import "RTagCloudView.h"

@interface RTagCloudView ()
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, strong) UILabel *selectedLabel;
- (void)calAngleWithX:(CGFloat)x y:(CGFloat)y z:(CGFloat)z;
- (void)repositionAll;
- (void)update;
@end

@implementation RTagCloudView
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _numberOfTags = 0;
        _tabLabels = [[NSMutableArray alloc] initWithCapacity:10];
        _radius = 120;
        
        CATransform3D tran = CATransform3DIdentity;
        tran.m34 = -1.0/1000;
        self.layer.sublayerTransform = tran;
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)layoutSubviews
{
    
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UIView *view in _tabLabels) {
        if (CGRectContainsPoint(view.frame, point))
            return view;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    self.startPoint = [touch locationInView:self];
    if ([[touch view] isKindOfClass:[UILabel class]] && [touch view].alpha > 0.8f) {
        self.selectedLabel = (UILabel*)[touch view];
        return;
    }
    
    _active = YES;
    CGPoint loc = [touch locationInView:self];
    _speedY = -(loc.x - self.frame.size.width/2) / 20;
    _speedX = (loc.y - self.frame.size.height/2) / 20;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self];
    _speedY = -(loc.x - self.frame.size.width/2) / 20;
    _speedX = (loc.y - self.frame.size.height/2) / 20;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    if ([[touch view] isKindOfClass:[UILabel class]] && [touch view].alpha > 0.8f) {
        CGPoint endPoint = [touch locationInView:self];
        CGFloat distance = sqrtf((endPoint.x - self.startPoint.x) * (endPoint.x - self.startPoint.x)
                                 + (endPoint.y - self.startPoint.y) * (endPoint.y - self.startPoint.y));
        CGFloat kValidDistance = 5.f;
        if (distance < kValidDistance && [touch view] == self.selectedLabel) {
            if ([self.delegate respondsToSelector:@selector(RTagCloudView:didTapOnTagOfIndex:)]) {
                NSUInteger index = [_tabLabels indexOfObject:[touch view]];
                [self.delegate RTagCloudView:self didTapOnTagOfIndex:index];
            }
        }
    }
    
    self.selectedLabel = nil;
    _active = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    _active = NO;
}

#pragma mark - getter/setter

- (void)setDataSource:(id<RTagCloudViewDatasource>)dataSource
{
    if (_dataSource != dataSource) {
        //    [_dataSource release];
        //    _dataSource = [dataSource retain];
        _dataSource = dataSource;
        [self reloadData];
    }
}

#pragma mark - PrivateMethods

- (void)calAngleWithX:(CGFloat)x y:(CGFloat)y z:(CGFloat)z
{
    static const CGFloat dtor = M_PI / 180.0f;
    
    sa = sinf(x*dtor);
    ca = cosf(x*dtor);
    sb = sinf(y*dtor);
    cb = cosf(y*dtor);
    sc = sinf(z*dtor);
    cc = cosf(z*dtor);
}

- (void)repositionAll
{
    [UIView beginAnimations:@"startup" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    for (int i=0; i<_numberOfTags; i++) {
        CGFloat phi = acosf((2.0f*(i+1)-1) / _numberOfTags - 1);
        CGFloat theta = sqrtf(_numberOfTags*M_PI)*phi;
        CGFloat tx = _radius*sinf(phi)*cosf(theta);
        CGFloat ty = _radius*sinf(phi)*sinf(theta);
        CGFloat tz = _radius*cosf(phi);
        UILabel *label = (UILabel*)[_tabLabels objectAtIndex:i];
        label.layer.transform = CATransform3DMakeTranslation(tx, ty, tz);
    }
    [UIView commitAnimations];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0/30
                                              target:self
                                            selector:@selector(update)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)update
{
    CGFloat a = 0,b = 0;
    if (_active) {
        a = _speedX;
        b = _speedY;
    }
    else {
        a = _speedX * 0.92;
        b = _speedY * 0.92;
    }
    _speedX = a;
    _speedY = b;
    
    
    [self calAngleWithX:a y:b z:0];
    
    for (int i=0; i<_numberOfTags; i++) {
        UILabel *lable = (UILabel*)[_tabLabels objectAtIndex:i];
        CATransform3D t = lable.layer.transform;
        CGFloat rx1 = t.m41;
        CGFloat ry1 = t.m42 * ca + t.m43 * (-sa);
        CGFloat rz1 = t.m42 * sa + t.m43 * ca;
        
        CGFloat rx2 = rx1 * cb + rz1 * sb;
        CGFloat ry2 = ry1;
        CGFloat rz2 = rx1 * (-sb) + rz1 * cb;
        
        CGFloat rx3 = rx2 * cc + ry2 * (-sc);
        CGFloat ry3 = rx2 * sc + ry2 * cc;
        CGFloat rz3 = rz2;
        
        
        lable.layer.transform = CATransform3DMakeTranslation(rx3, ry3, rz3);
        
        CGFloat alpha = 0.2+0.4*(rz3 + _radius)/_radius;
        lable.layer.opacity = alpha;
    }
}

#pragma mark - Methods

- (void)reloadData
{
    [_timer invalidate];
    _timer = nil;
    
    _numberOfTags = [self.dataSource numberOfTags:self];
    
    CGSize size = self.bounds.size;
    __block CGPoint center = CGPointMake(size.width/2, size.height/2);
    [UIView animateWithDuration:_tabLabels.count>0?0.35:0.0
                     animations:^{
                         [_tabLabels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                             UILabel *lable = (UILabel*)obj;
                             lable.alpha = 0;
                             lable.center = center;
                         }];
                     }
                     completion:^(BOOL finished) {
                         [_tabLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
                         
                         NSInteger append = _numberOfTags - _tabLabels.count;
                         for (int i=0; i<append; i++) {
                             UILabel *lbl = [[UILabel alloc] init];
                             lbl.backgroundColor = [UIColor clearColor];
                             [_tabLabels addObject:lbl];
                             [self addSubview:lbl];
                         }
                         
                         for (int i=0; i<_numberOfTags; i++) {
                             UILabel *label = (UILabel*)[_tabLabels objectAtIndex:i];
                             label.text = [self.dataSource RTagCloudView:self
                                                          tagNameOfIndex:i];
                             if ([self.dataSource respondsToSelector:@selector(RTagCloudView:tagColorOfIndex:)])
                                 label.textColor = [self.dataSource RTagCloudView:self
                                                                  tagColorOfIndex:i];
                             if ([self.dataSource respondsToSelector:@selector(RTagCloudView:tagFontOfIndex:)]) {
                                 label.font = [self.dataSource RTagCloudView:self tagFontOfIndex:i];
                             }
                             [label sizeToFit];
                             label.center = center;
                         }
                         
                         [self repositionAll];
                     }];
}

@end
