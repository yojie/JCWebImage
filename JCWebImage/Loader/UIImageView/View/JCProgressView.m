//
//  JCProgressView.m
//  JCWorks
//
//  Created by Jai on 2018/7/10.
//  Copyright © 2018年 Jai Chow. All rights reserved.
//

#import "JCProgressView.h"

@interface JCProgressView ()

@property (nonatomic, strong) UILabel * progressLabel;
@property (nonatomic, strong) CAShapeLayer * progressLayer;
@property (nonatomic, assign) CGFloat current;

@end

@implementation JCProgressView

#pragma mark - init
- (void)awakeFromNib {
	[super awakeFromNib];
	[self jc_setup];
}

- (instancetype)init {
	return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self jc_setup];
	}
	return self;
}

#pragma mark - setup
- (void)jc_setup {
	[self jc_setupViews];
}

- (void)jc_setupViews {
	[self addSubview:self.progressLabel];
	[self.layer addSublayer:self.progressLayer];
}

#pragma mark - getter/setter
- (UILabel *)progressLabel {
	if (!_progressLabel) {
		_progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, JCDimmerProgress, JCDimmerProgress)];
		_progressLabel.font = [UIFont systemFontOfSize:10.0f];
		_progressLabel.textColor = [UIColor whiteColor];
		_progressLabel.text = @"0%";
		_progressLabel.backgroundColor = [UIColor clearColor];
		_progressLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _progressLabel;
}

- (CAShapeLayer *)progressLayer {
	if (!_progressLayer) {
		_progressLayer = [CAShapeLayer layer];
		
		CGFloat radius = JCDimmerProgress*0.5f;
		UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:-M_PI_2 endAngle:270*M_PI/180.0f clockwise:YES];
		_progressLayer.path = path.CGPath;
		
		_progressLayer.strokeColor = [UIColor whiteColor].CGColor;
		_progressLayer.lineWidth = 2.0f;
		_progressLayer.lineCap = kCALineCapRound;
		_progressLayer.fillColor = nil;//[UIColor clearColor].CGColor;
		
		_progressLayer.strokeStart = 0.0f;
		_progressLayer.strokeEnd = 0.0f;
	}
	return _progressLayer;
}

- (void)setProgress:(CGFloat)progress {
	self.current = _progress;
	
	_progress = progress;
	
	[self jc_labelAnmation];
	[self jc_layerAnimation];
}

#pragma mark - animations
- (void)jc_labelAnmation {
	NSInteger progress = (NSInteger)(self.current*100), end = (NSInteger)(self.progress*100);
	if (progress > end) {
		self.hidden = YES;
		return;
	}
	self.current += 0.01;
	self.progressLabel.text = [NSString stringWithFormat:@"%ld%%", (NSInteger)(progress)];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self jc_labelAnmation];
	});
}

- (void)jc_layerAnimation {
	CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
	animation.toValue = @(self.progress);
	animation.duration = 1.0f;
	[self.progressLayer addAnimation:animation forKey:@"progress"];
	
	self.progressLayer.strokeEnd = self.progress;
}

#pragma mark - layout
- (void)layoutSubviews {
	self.progressLayer.frame = self.bounds;
}

@end


















































