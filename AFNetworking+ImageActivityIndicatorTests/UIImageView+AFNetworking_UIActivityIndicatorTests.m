//
//  UIImageView+AFNetworking_UIActivityIndicatorTests.m
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

// Test Class
#import "UIImageView+AFNetworking_UIActivityIndicatorView.h"

// Collaborators
#import "Test_UIImageView.h"

// Test Support
#import <XCTest/XCTest.h>

#define EXP_SHORTHAND YES
#import <Expecta/Expecta.h>

#import <OCMock/OCMock.h>

@interface UIImageView (PrivateMethods)
- (void)af_addActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle)style;
@end

@interface UIImageView_AFNetworking_UIActivityIndicatorTests : XCTestCase
@end

@implementation UIImageView_AFNetworking_UIActivityIndicatorTests
{
  Test_UIImageView *sut;

  NSURL *expectedURL;
  UIActivityIndicatorViewStyle style;
  
  id activityIndicatorMock;
  id partialMock;
}

#pragma mark - Test Lifecycle

- (void)setUp
{
  [super setUp];
  sut = [[Test_UIImageView alloc] init];
  
  expectedURL = [NSURL URLWithString:@"http://example.com"];
  style = UIActivityIndicatorViewStyleGray;
}

- (void)tearDown
{
  [activityIndicatorMock stopMocking];
  [partialMock stopMocking];
  [super tearDown];
}

#pragma mark - Given

- (void)givenPartialMock
{
  partialMock = OCMPartialMock(sut);
}

- (NSUInteger)expectedAutoresizingMask
{
  return UIViewAutoresizingFlexibleTopMargin  | UIViewAutoresizingFlexibleBottomMargin |
         UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
}

- (void)givenMockActivityIndicator
{
  activityIndicatorMock = OCMClassMock([UIActivityIndicatorView class]);
  [sut setActivityIndicatorView:activityIndicatorMock];
}

#pragma mark - When

- (void)whenSetImageWithExpectedURLAndStyle
{
  [sut setImageWithURLRequest:[NSURLRequest requestWithURL:expectedURL]
             placeholderImage:nil
  usingActivityIndicatorStyle:style
                      success:nil
                      failure:nil];
}

#pragma mark - Activity Indicator - Tests

- (void)testSetsAndReturnsAssociatedActivityIndicator
{
  // given
  UIActivityIndicatorView *expected = [[UIActivityIndicatorView alloc] init];
  
  // when
  [sut setActivityIndicatorView:expected];
  UIActivityIndicatorView *actual = [sut activityIndicatorView];
  
  // then
  expect(expected).to.equal(actual);
}

- (void)test___removeActivityIndicatorView___removesActivityIndicator
{
  // given
  [self givenPartialMock];
  [self givenMockActivityIndicator];
  
  // when
  [partialMock removeActivityIndicatorView];
  
  // then
  [[activityIndicatorMock verify] removeFromSuperview];
}

- (void)test___removeActivityIndicatorView___nilsActivityIndicator
{
  // given
  [self givenPartialMock];
  [self givenMockActivityIndicator];
  
  // when
  [partialMock removeActivityIndicatorView];
  
  // then
  [[partialMock verify] setActivityIndicatorView:nil];
}

- (void)test___cancelImageRequestOperationAndRemoveActivityIndicatorView___cancelsRequest
{
  // given
  [self givenPartialMock];
  
  // when
  [partialMock cancelImageRequestOperationAndRemoveActivityIndicatorView];
  
  // then
  [[partialMock verify] cancelImageDownloadTask];
}

- (void)test___cancelImageRequestOperationAndRemoveActivityIndicatorView___calls____removeActivityIndicatorViewView
{
  // given
  [self givenPartialMock];
  [self givenMockActivityIndicator];
  
  // when
  [partialMock cancelImageRequestOperationAndRemoveActivityIndicatorView];
  
  // then
  [[partialMock verify] removeActivityIndicatorView];  
}

#pragma mark - Set Image With URL - Tests

- (void)test___setImageWithURL_usingActivityIndicatorStyle___givenNilUrl_nils_imageViewImage
{
  // given
  [self givenPartialMock];
  OCMExpect([(UIImageView *)partialMock setImage:nil]);

  [[partialMock reject] setImageWithURLRequest:OCMOCK_ANY
                              placeholderImage:OCMOCK_ANY
                                       success:OCMOCK_ANY
                                       failure:OCMOCK_ANY];
  
  // when
  [sut setImageWithURL:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  
  // then
  OCMVerifyAll(partialMock);
}

- (void)test___setImageWithURL_usingActivityIndicatorStyle___callsMethodWithAdditionalParameters
{
  // given
  [self givenPartialMock];
  
  NSURLRequest *request = [NSURLRequest requestWithURL:expectedURL];
  OCMExpect([partialMock setImageWithURLRequest:request
                              placeholderImage:nil
                   usingActivityIndicatorStyle:style
                                       success:nil
                                       failure:nil]);
  
  // when
  [partialMock setImageWithURL:expectedURL usingActivityIndicatorStyle:style];
  
  // then
  OCMVerifyAll(partialMock);
}

- (void)testDoesNotShowActivityIndicatorIfURLRequestURLIsNil {
  
  // given
  [self givenPartialMock];
  NSURLRequest *request = [NSURLRequest new];
  
  [[[partialMock reject] ignoringNonObjectArgs] af_addActivityIndicatorWithStyle:0];
  
  // when
  [sut setImageWithURLRequest:request
             placeholderImage:nil
  usingActivityIndicatorStyle:style
                      success:nil
                      failure:nil];
  
  // then
  OCMVerifyAll(partialMock);
}

- (void)testAddsActivityIndicatorToView
{
  // when
  [self whenSetImageWithExpectedURLAndStyle];
  
  // then
  UIActivityIndicatorView *indicator = [sut activityIndicatorView];

  expect(indicator).notTo.beNil();
  expect(indicator.activityIndicatorViewStyle).to.equal(style);
  expect(indicator.autoresizingMask).to.equal([self expectedAutoresizingMask]);
  expect(indicator.center).to.equal(sut.center);
  
  expect([indicator superview]).will.beIdenticalTo(sut);
  expect([indicator isAnimating]).will.beTruthy();
}

- (void)testSuccessRemovesActivityIndicatorFromImageView
{
  // given
  [self givenMockActivityIndicator];
  
  // when
  [self whenSetImageWithExpectedURLAndStyle];
  
  // then
  expect(sut.test_successBlock).toNot.beNil();
  sut.test_successBlock(nil, nil, nil);
  
  [[activityIndicatorMock verify] removeFromSuperview];
}

- (void)testSuccessNilsActivityIndicator
{
  // given
  [self givenMockActivityIndicator];
  
  // when
  [self whenSetImageWithExpectedURLAndStyle];
  
  // then
  expect(sut.test_successBlock).toNot.beNil();
  sut.test_successBlock(nil, nil, nil);
  
  expect([sut activityIndicatorView]).to.beNil();
}

- (void)testSuccessCallsSuccessBlock
{
  // given
  __block BOOL successBlockCalled = NO;
  
  // when
  [sut setImageWithURLRequest:[NSURLRequest requestWithURL:expectedURL]
             placeholderImage:nil
  usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray
                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                        successBlockCalled = YES;
                      } failure:nil];
  
  // then
  expect(sut.test_successBlock).toNot.beNil();
  sut.test_successBlock(nil, nil, nil);
  
  expect(successBlockCalled).to.beTruthy();
}

- (void)testSuccessDoesNotSetImageIfHasSuccessBlock
{
  // when
  [sut setImageWithURLRequest:[NSURLRequest requestWithURL:expectedURL]
             placeholderImage:nil
  usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray
                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                        // empty by intention
                      } failure:nil];
  
  // then
  expect(sut.test_successBlock).toNot.beNil();
  sut.test_successBlock(nil, nil, [[UIImage alloc] init]);
  
  expect(sut.image).to.beNil();
}

- (void)testSuccessSetsImageIfDoesNotHaveSuccessBlock
{
  // when
  [self whenSetImageWithExpectedURLAndStyle];
  
  // then
  expect(sut.test_successBlock).toNot.beNil();
  sut.test_successBlock(nil, nil, [[UIImage alloc] init]);
  
  expect(sut.image).toNot.beNil();
}

- (void)testFailureRemovesActivityIndicator
{
  // given
  [self givenMockActivityIndicator];
  
  // when
  [self whenSetImageWithExpectedURLAndStyle];
  
  // then
  expect(sut.test_failureBlock).toNot.beNil();
  sut.test_failureBlock(nil, nil, nil);
 
  [[activityIndicatorMock verify] removeFromSuperview];
}

- (void)testFailureNilsActivityIndicator
{
  // given
  [self givenMockActivityIndicator];
  
  // when
  [self whenSetImageWithExpectedURLAndStyle];
  
  // then
  expect(sut.test_failureBlock).toNot.beNil();
  sut.test_failureBlock(nil, nil, nil);
  
  expect([sut activityIndicatorView]).to.beNil();
}

- (void)testFailureCallsFailureBlock
{
  // given
  __block BOOL failureBlockCalled = NO;
  
  // when
  [sut setImageWithURLRequest:[NSURLRequest requestWithURL:expectedURL]
             placeholderImage:nil
  usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray
   success:nil failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
     failureBlockCalled = YES;
   }];
  
  // then
  expect(sut.test_failureBlock).toNot.beNil();
  sut.test_failureBlock(nil, nil, nil);
  
  expect(failureBlockCalled).to.beTruthy();
}

@end
