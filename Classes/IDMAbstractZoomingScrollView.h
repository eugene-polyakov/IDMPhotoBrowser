//
//  IDMZoomingScrollView.h
//  IDMPhotoBrowser
//
//  Created by Michael Waterfall on 14/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDMPhotoProtocol.h"
#import "IDMTapDetectingImageView.h"
#import "IDMTapDetectingView.h"

@class IDMPhotoBrowser, IDMPhoto, IDMCaptionView;

@interface IDMAbstractZoomingScrollView : UIScrollView <UIScrollViewDelegate, IDMTapDetectingImageViewDelegate, IDMTapDetectingViewDelegate> {
    
    IDMPhotoBrowser *__weak _photoBrowser;
    id<IDMPhoto> _photo;
    
    // This view references the related caption view for simplified handling in photo browser
    IDMCaptionView *_captionView;
    
    IDMTapDetectingView *_tapView; // for background taps
}

@property (nonatomic, weak) IDMPhotoBrowser *photoBrowser;
@property (nonatomic, strong) IDMTapDetectingImageView *photoImageView;
@property (nonatomic, strong) IDMCaptionView *captionView;
@property (nonatomic, strong) id<IDMPhoto> photo;

- (id)initWithPhotoBrowser:(IDMPhotoBrowser *)browser;
- (void)setMaxMinZoomScalesForCurrentBounds;
- (void)displayImage;
- (void)displayImageFailure;
- (void)prepareForReuse;
- (void)display;

@end
