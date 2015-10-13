//
//  UIImageView+AFNetworking_UIActivityIndicator.m
//  AFNetworking+ImageActivityIndicator
//
//  Created by Joshua Greene on 7/11/14.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "UIImageView+AFNetworking_UIActivityIndicatorView.h"
#import <objc/runtime.h>

static char AF_UIActivityIndicatorKey;

@implementation UIImageView (AFNetworking_UIActivityIndicatorView)

#pragma mark - Object Association

- (UIActivityIndicatorView *)activityIndicatorView
{
  return (UIActivityIndicatorView *)objc_getAssociatedObject(self, &AF_UIActivityIndicatorKey);
}

- (void)setActivityIndicatorView:(UIActivityIndicatorView *)activityIndicatorView {
  objc_setAssociatedObject(self, &AF_UIActivityIndicatorKey, activityIndicatorView, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - Cancel Request

- (void)cancelImageRequestOperationAndRemoveActivityIndicatorView
{
  [self cancelImageRequestOperation];
  [self removeActivityIndicatorView];
}

- (void)removeActivityIndicatorView
{
  UIActivityIndicatorView *activityIndicator = [self activityIndicatorView];
  
  if (!activityIndicator) {
    return;
  }
  
  [activityIndicator removeFromSuperview];
  [self setActivityIndicatorView:nil];
}

#pragma mark - Set Image With URL

- (void)setImageWithURL:(NSURL *)url usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style
{
  [self setImageWithURLRequest:[NSURLRequest requestWithURL:url]
              placeholderImage:nil
   usingActivityIndicatorStyle:style
                       success:nil
                       failure:nil];
}

- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
   usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
  if (urlRequest.URL == nil) {
    self.image = nil;
    return;
  }
  
  [self af_addActivityIndicatorWithStyle:style];
  
  __weak UIImageView *weakSelf = self;
  
  [self setImageWithURLRequest:urlRequest
              placeholderImage:placeholderImage
                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
    
    __strong UIImageView *strongSelf = weakSelf;
    
    [strongSelf removeActivityIndicatorView];
    
    if (success) {
      success(request, response, image);

    } else {
      strongSelf.image = image;
    }
    
  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {

    __strong typeof(weakSelf) strongSelf = weakSelf;
    [strongSelf removeActivityIndicatorView];
    
    if (failure) {
      failure(request, response, error);
    }
  }];
}

#pragma mark - Private Helpers

- (void)af_addActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle)style
{
  UIActivityIndicatorView *activityIndicator = [self activityIndicatorView];
  
  if (!activityIndicator) {
    
    activityIndicator = [self af_createActivityIndicatorWithStyle:style];
    [self setActivityIndicatorView:activityIndicator];
    
    if ([NSThread isMainThread]) {
      [self addSubview:activityIndicator];
      [activityIndicator startAnimating];
      
    } else {
      dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self addSubview:activityIndicator];
        [activityIndicator startAnimating];
      });
    }
    return;
  }
  
  if ([NSThread isMainThread]) {
    [activityIndicator startAnimating];
    
  } else {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
      [activityIndicator startAnimating];
    });
  }
}

- (UIActivityIndicatorView *)af_createActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle)style
{
  UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
  activityIndicator.userInteractionEnabled = NO;
  activityIndicator.center = self.center;
  activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin  | UIViewAutoresizingFlexibleBottomMargin |
  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
  
  return activityIndicator;
}

@end
