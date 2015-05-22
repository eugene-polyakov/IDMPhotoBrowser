//
//  IDMZoomingScrollView.m
//  IDMPhotoBrowser
//
//  Created by Michael Waterfall on 14/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import "IDMZoomingScrollView.h"
#import "IDMPhotoBrowser.h"
#import "IDMPhoto.h"

// Declare private methods of browser
@interface IDMPhotoBrowser ()
- (UIImage *)imageForPhoto:(id<IDMPhoto>)photo;
- (void)cancelControlHiding;
- (void)hideControlsAfterDelay;
- (void)toggleControls;
@end

@implementation IDMZoomingScrollView

- (id)initWithPhotoBrowser:(IDMPhotoBrowser *)browser {
    if ((self = [super initWithPhotoBrowser:browser])) {
        // Delegate

        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenBound.size.width;
        CGFloat screenHeight = screenBound.size.height;
        
        if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft ||
            [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
            screenWidth = screenBound.size.height;
            screenHeight = screenBound.size.width;
        }
        
        // Progress view
        _progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake((screenWidth-35.)/2., (screenHeight-35.)/2, 35.0f, 35.0f)];
        [_progressView setProgress:0.0f];
        _progressView.tag = 101;
        _progressView.thicknessRatio = 0.1;
        _progressView.roundedCorners = NO;
        _progressView.trackTintColor    = browser.trackTintColor    ? self.photoBrowser.trackTintColor    : [UIColor colorWithWhite:0.2 alpha:1];
        _progressView.progressTintColor = browser.progressTintColor ? self.photoBrowser.progressTintColor : [UIColor colorWithWhite:1.0 alpha:1];
        [self addSubview:_progressView];
        
    }
    
    return self;
}

#pragma mark - Image

// Get and display image
- (void)displayImage {
	if (self.photo && self.photoImageView.image == nil) {
		// Reset
		self.maximumZoomScale = 1;
		self.minimumZoomScale = 1;
		self.zoomScale = 1;
        
		self.contentSize = CGSizeMake(0, 0);
		
		// Get image from browser as it handles ordering of fetching
		UIImage *img = [self.photoBrowser imageForPhoto:_photo];
		if (img) {
            // Hide ProgressView
            //_progressView.alpha = 0.0f;
            [_progressView removeFromSuperview];
            
            // Set image
			self.photoImageView.image = img;
			self.photoImageView.hidden = NO;
            
            // Setup photo frame
			CGRect photoImageViewFrame;
			photoImageViewFrame.origin = CGPointZero;
			photoImageViewFrame.size = img.size;
            
			self.photoImageView.frame = photoImageViewFrame;
			self.contentSize = photoImageViewFrame.size;

			// Set zoom to minimum zoom
			[self setMaxMinZoomScalesForCurrentBounds];
        } else {
			// Hide image view
			self.photoImageView.hidden = YES;
            
            _progressView.alpha = 1.0f;
		}
        
		[self setNeedsLayout];
	}
}

- (void)setProgress:(CGFloat)progress forPhoto:(IDMPhoto*)photo {
    IDMPhoto *p = (IDMPhoto*)self.photo;

    if ([photo.photoURL.absoluteString isEqualToString:p.photoURL.absoluteString]) {
        if (_progressView.progress < progress) {
            [_progressView setProgress:progress animated:YES];
        }
    }
}

// Image failed so just show black!
- (void)displayImageFailure {
    [_progressView removeFromSuperview];
}


@end
