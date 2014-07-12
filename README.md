## AFNetworking + ImageActivityIndicator

`AFNetworking+ImageActivityIndicator` makes it easy to show an activity indicator while an image view's image is loading using `AFNetworking`.

### Installation with CocoaPods

The easiest way to add `AFNetworking+ImageActivityIndicator` to your project is using <a href="http://cocoapods.org">CocoaPods</a>. Simply add the following to your Podfile:

`pod 'AFNetworking+ImageActivityIndicator', '~> 1.0'`

Then run `pod install` as you normally would.

### Manual Installation

Alternatively, you can manually include `AFNetworking+ImageActivityIndicator` in your project by doing the following:

1) Clone this repo locally onto your computer, or press `Download ZIP` to simply download the latest `master` commit.

2) Drag the `AFNetworking+ImageActivityIndicator` folder into your project, making sure `Copy items into destination group's folder (if needed)` is checked.

3) Add <a href="https://github.com/AFNetworking/AFNetworking">AFNetworking 2.x</a> to your project (it's a dependency of this library).

### How to Use

`AFNetworking+ImageActivityIndicator` is designed to make showing an activity indicator while an image is loading use `AFNetworking` very easy:

1) Add `#import <AFNetworking+ImageActivityIndicator/AFNetworking+ImageActivityIndicator.h>` wherever you need to show an activity indicator view while an image is loading using `AFNetworking`.

(Or just use `#import "AFNetworking+ImageActivityIndicator.h"` if you're not using CocoaPods / feeling adventurous.)

2) Call any of the new `~ usingActivityIndicatorStyle:` methods. In example,

    UIImageView *imageView = // ... get/create the image view
    [imageView setImageWithURL:[NSURL URLWithString:@"http://example.com"]
    usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
3) Not sure how a method is supposed to work? 

See `UIImageView+AFNetworking_UIActivityIndicatorView.h` for in-line documentation comments (or search <a href="http://cocoadocs.org">CocoaDocs</a> for `AFNetworking+ImageActivityIndicator` for a browser-friendly version of the documentation).

### Contributing

Patches and feature additions are welcome!

To contribute:

1) Open a new issue and propose your change- before writing code- to make sure the open source community agrees it's needed.

Make sure to include your rationale for why this change is needed (especially for new method/feature additions).

2) Fork this repo.

3) Make your changes.

4) Write unit tests for your changes (as needed). If possible, a TDD approach is best!

If you've never written unit tests before, that's okay!

You can learn by checking out Jon Reid's (<a href="https://twitter.com/qcoding">@qcoding</a>) excellent <a href="http://qualitycoding.org">website</a>, including a <a href="http://qualitycoding.org/unit-testing">section just about unit testing</a>.

4) Write in-line documentation comments for your property/method additions.

This project is part of the CocoaPods specs repo, which includes appledoc-parsed documentation hosted for each pod on CocoaDocs.

If you're not familar with appledoc, check out Mattt Thompson's (<a href="https://twitter.com/mattt">@matt</a>) introductory <a href="http://nshipster.com/documentation">post about it</a>.

5) Submit a pull request, referencing your original issue from (1) above.

6) Last but not least, sit back and enjoy your awesomeness in helping make your fellow developers' lives a bit easier!

## LICENSE

Like `AFNetworking`, `AFNetworking+ImageActivityIndicator` is released under the MIT License. See the `LICENSE` file for more details.