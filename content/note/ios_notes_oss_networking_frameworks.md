
+++
date = "2015-05-05T01:06:23+08:00"
draft = true
title = "iOS NOTES - NETWORKING OPEN SOURCE FRAMEWORKS"

tags      = ["Cocoa", "AppDev", "Networking"]
languages = ["Swift", "ObjC"]
platforms = ["MacOS", "iOS"]
+++

Here records the simple usage that I learned from the 3 well-known open source
networking frameworks:

1. [ASIHTTPRequest](http://allseeing-i.com/ASIHTTPRequest/) written in Objective-C language

2. [AFNetworking](https://github.com/AFNetworking/AFNetworking)  written in Objective-C language

3. [Alamofire](https://github.com/Alamofire/Alamofire) written in Swift Language

All example below are run asynchronously.
<!--more-->

# Use Case #1 - Simple GET Request

## With ASIHTTPRequest

### Using delegation

Create & configure request object and emit request.

1. Define a long-standing reference somewhere, e.g. as a property of you view
   controller class.

1. Initialize the `ASIHTTPRequest` instance with target URL string (make sure
   it properly encoded).

1. set progress feedback settings if you want them.

1. set delegate and emit the request.

```objc
- (IBAction)grabSomethingInBackground: (id)sender {
// step #1
//   use Url string to initialize a instance of ASIHTTPRequest instance

  NSString *strURL = @"...."
  // better call this method to ensure string is properly encoded.
  strURL = [strURL stringByAddingPercentEscapesUsingEncodingSUTF8StringEncoding];
  // request instance should stand as long as possible to cover the whole fetching process
  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURLtrURL];

// step #2 (optional)
//   get download progress feedback

  request.downloadProgressDelegate = self;
  request.showAccurateProgress = YES;
  [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator: YES];

// step #3
// set delegate & emit request ansynchronously

  request.delegate = self;
  [request startAsynchronous];
}
```

Implement delegate methods to handle results (succeed or fail).

1. implement `requestFinished:` delegate methods to fetch response content.

1. implement `requestFailed:` delegate methods to handle failure.

1. implement `setProgress:` delegate methods to report the download progress.

```objc
#pragma mark - ASIHTTPRequestDelegate
// request succeeded
- (void)requestFinished: (ASIHTTPRequest *)request
{
  // fetch response content as NSData
  NSData *data = [request responseData];

  // fetch response content as NSString
  NSString *str = [request responseString];
}

// reqeust failed
- (void)requestFailed: (ASIHTTPRequest *)request
{
    NSLog(@"ERROR: %@", [request.error localizedDescription]);
}

#pragma mark - ASIProgressDelegate
- (void)setProgress: (float)newProgress
{
  // average download speed in bytes/second
  unsigned long byte = [ASIHTTPRequest averageBandwidthUsedPerSecond];

  // current completion percent (between 0.0 ~ 1.0) from argument:
  newProgress;
}

@end

```

Another alternative is to set selectors for success & fail handling respectively.

```objc
  [request setDidFinishSelector:@selector(requestDone:)];
  [request setDidFailSelector:@selector(requestWentWrong:)];
```

If you set completion selectors like above, your delegate's completion methods
will be ignored.

### Using blocks

```objc
- (IBAction)grabSomethingInBackground: (id)sender
{
// step #1
//   create request instance
  NSString *strURL = @"...."
  strURL = [strURL stringByAddingPercentEscapesUsingEncodingSUTF8StringEncoding];

  // use keyword __block to make 'request' variable capturable and modifiable by blocks following
  __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];

// setp #2 -
//   set blocks instead of delegate to handle results

   [request setCompletionBlock:^{
      // fetching text data thought captured 'request' object
      NSString *responseString = [request responseString];

      // fetching binary data thought captured 'request' object
      NSData *responseData = [request responseData];
   }];

   [request setFailedBlock:^{
      NSError *error = [request error];
   }];

  [request startAsynchronous];
}
```

## With AFNetworking

## With Alamofire

# Use Case #2 - Simple POST Request

## With ASIHTTPRequest

Same as the 'Simle GET Request' above, excepts:

+ You should initialize a instance of ASIFormDataRequest instead of
  ASIHTTPRequest.

+ You set `setRequestMethod:` with `POST` parameter to switch to POST request
  type.

+ You should call `addRequestHeader:` methods to add at least `Content-Type`
  field.

+ You should put the query string in URL string into the HTTP request body by
  calling `setPostBody` method, either in URL query string form or JSON form.

```objc
// use Url string to initialize a instance of ASIFormDataRequest

  NSString *strURL = @"...";
  // better call this method to ensure string is properly encoded.
  NSURL *strURL = strURL stringByAddingPercentEscapesUsingEncoding: SUTF8StringEncoding];

// set request methods to 'POST'

  [self.formRequest setRequestMethod: "POST"];

// add http pack header & body respectively

  self.formRequest = [ASIFormDataRequest requestWithURL: strURL];
  [self.formRequest addRequestHeader: "Content-Type" value: "application/x-www-form-urlencoded"];

  // body string in URL query string format
  NSMutableData *body = [@"type=focus-c" dataUsingEncoding: SUTF8StringEncoding];

  // body string in JSON format
  // NSMutableData *body = [@"p={\"a\": ,\"b\": }" dataUsingEncoding: SUTF8StringEncoding];;

  [self.formRequest setPostBody: NSMutableData*)[body dataUsingEncoding: SUTF8StringEncoding]];

// set delegate & emit request ansynchronously

  [self.formRequest setDelegate: elf];
  [self.formRequest startAsynchronous];
```

# Framework Office Documentation

1. [ASIHTTPRequest](http://allseeing-i.com/ASIHTTPRequest/How-to-use)

2. [AFNetworking](http://cocoadocs.org/docsets/AFNetworking/2.5.3/)

3. [Alamofire](https://github.com/Alamofire/Alamofire)

