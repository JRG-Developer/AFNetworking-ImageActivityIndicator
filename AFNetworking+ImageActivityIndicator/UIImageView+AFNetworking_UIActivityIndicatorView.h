//
//  UIImageView+AFNetworking_UIActivityIndicatorView.h
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

#import <AFNetworking/UIImageView+AFNetworking.h>

/**
 *  `UIImageView+AFNetworking_UIActivityIndicatorView` adds `usingActivityIndicatorStyle:` methods to AFNetworking to show an animated activity indicator view while the image view's image is loading.
 */
@interface UIImageView (AFNetworking_UIActivityIndicatorView)

/**
 *  This is the activity indicator view associated with the image view.
 *
 *  @return The activity indicator view (if set) or `nil`
 */
- (UIActivityIndicatorView *)activityIndicatorView;

/**
 *  This method sets the activity indicator view using objective-c runtime assocation.
 *
 *  @param activityIndicatorView The activity indicator view to be associated
 */
- (void)setActivityIndicatorView:(UIActivityIndicatorView *)activityIndicatorView;

/**
 *  Removes the activity indicator view, if one exists.
 */
- (void)removeActivityIndicatorView;

/**
 *  Cancels any executing image request operation and removes the activity indicator from the view, if these exist.
 */
- (void)cancelImageRequestOperationAndRemoveActivityIndicatorView;

/**
  *  Asynchronously downloads an image from the specified URL, and sets it once the request is finished. Any previous image request for the receiver will be cancelled.
 
 *  If the image is cached locally, the image is set immediately, otherwise an activity indicator view will be added as a subview of the image view, centered, start animating, and then the remote image will be set once the request is finished.
 
 *  By default, URL requests have an `Accept` header field value of "image / *", a cache policy of `NSURLCacheStorageAllowed` and a timeout interval of 30 seconds, and are set not handle cookies. To configure URL requests differently, yet still show an activity indicator, use `setImageWithURLRequest:usingActivityIndicatorStyle:success:failure:`
 *
 *  @param url   The URL used for the image request.
 *  @param style The style for the activity indicator
 */
- (void)setImageWithURL:(NSURL *)url usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style;

/**
 *   Asynchronously downloads an image from the specified URL request, and sets it once the request is finished. Any previous image request for the receiver will be cancelled.
 
  *  If the image is cached locally, the image is set immediately, otherwise the placeholder is shown and an activity indicator view will be added as a subview of the image view, centered, start animating, and then the remote image will be set once the request is finished.
 
 *  If a success block is specified, it is the responsibility of the block to set the image of the image view before returning. If no success block is specified, the default behavior of setting the image with `self.image = image` is applied.
 *
 *  @param urlRequest The URL request used for the image request.
 *  @param placeholderImage The image to be set initially, until the image request finishes. If `nil`, the image view will not change its image until the image request finishes.
 *  @param style The style for the activity indicator
 *  @param success A block to be executed when the image request operation finishes successfully. This block has no return value and takes three arguments: the request sent from the client, the response received from the server, and the image created from the response data of request. If the image was returned from cache, the request and response parameters will be `nil`.
 *  @param failure A block object to be executed when the image request operation finishes unsuccessfully, or that finishes successfully. This block has no return value and takes three arguments: the request sent from the client, the response received from the server, and the error object describing the network or parsing error that occurred.
 */
- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
   usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;

@end
