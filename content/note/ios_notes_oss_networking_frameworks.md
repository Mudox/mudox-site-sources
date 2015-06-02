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

## 1.1 With ASIHTTPRequest

Create & configure request object and emit request.

1. create `ASIHTTPRequest` isntance with an `NSURL`.

2. choose and set response handling scheme. `ASIHTTPRequest` provides 4 ways to handle responses:

    + __delegation__,  implement the following methods (usually the first 2
       are all you need) in your delegate objects, they will be called in some
       queue when events arrive.

    ```objc
    // These are the default delegate methods for request status
    // You can use different ones by setting didStartSelector / didFinishSelector / didFailSelector
    - (void)requestFinished:   (ASIHTTPRequest *)request;
    - (void)requestFailed:     (ASIHTTPRequest *)request;

    - (void)requestStarted:    (ASIHTTPRequest *)request;

    - (void)request:           (ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders;
    - (void)request:           (ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL;
    - (void)requestRedirected: (ASIHTTPRequest *)request;

    // When a delegate implements this method, it is expected to process all incoming data itself
    // This means that responseData / responseString / downloadDestinationPath etc are ignored
    // You can have the request call a different method by setting didReceiveDataSelector
    - (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data;
    ```

    + __target + selector pattern__, you are free to implement, in one delegate
       obect, more than one methods for a given event and name them
       arbitrarily.

    ```objc
    @property (assign) SEL didStartSelector;
    @property (assign) SEL didFinishSelector;
    @property (assign) SEL didFailSelector;
    ```

    + __block__,  you get a succinct codebase, but should be aware of
       retain-circle issue. usually the first 2 are all you need.

    ```objc
    - (void)setCompletionBlock:                (ASIBasicBlock) aCompletionBlock;
    - (void)setFailedBlock:                    (ASIBasicBlock) aFailedBlock;

    - (void)setStartedBlock:                   (ASIBasicBlock) aStartedBlock;
    - (void)setHeadersReceivedBlock:           (ASIHeadersBlock) aReceivedBlock;
    - (void)setBytesReceivedBlock:             (ASIProgressBlock) aBytesReceivedBlock;
    - (void)setBytesSentBlock:                 (ASIProgressBlock) aBytesSentBlock;
    - (void)setDownloadSizeIncrementedBlock:   (ASISizeBlock) aDownloadSizeIncrementedBlock;
    - (void)setUploadSizeIncrementedBlock:     (ASISizeBlock) anUploadSizeIncrementedBlock;
    - (void)setDataReceivedBlock:              (ASIDataBlock) aReceivedBlock;
    - (void)setAuthenticationNeededBlock:      (ASIBasicBlock) anAuthenticationBlock;
    - (void)setProxyAuthenticationNeededBlock: (ASIBasicBlock) aProxyAuthenticationBlock;
    - (void)setRequestRedirectedBlock:         (ASIBasicBlock) aRedirectBlock;
    ```

    + __subclassing__  subclass `ASIHTTPRequest`, and overwrite following methods, which is very rare occassion.

    ```objc
    - (void)requestFinished:(ASIHTTPRequest *)request
    - (void)requestFailed:(ASIHTTPRequest *)request
    ```

3. start loading by invoking:

```objc
-(void)startSynchronous
-(void)startAsynchronous
  ```

### 1.1.1 Using delegation

```objc
// step #1
// initialize a instance of ASIHTTPRequest instance
ASIHTTPRequest *request = [ASIHTTPRequest requestWithURLtrURL];

// step #2
// set delegate & selectors if you choose the target-selecors pattern
// or set blocks
// set other reqeust attributes such as progress watch, cache ...
request.delegate = self;

// step #3
// start this request operation
[request startAsynchronous];
```

Implement delegate methods to participate in the loading process, you choose
the delegation pattern.

1. implement `requestFinished:` delegate methods to fetch response content.

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
```

2. implement `requestFailed:` delegate methods to handle failure.

```objc
// reqeust failed
- (void)requestFailed: (ASIHTTPRequest *)request
{
  NSLog(@"ERROR: %@", [request.error localizedDescription]);
}
```


Another alternative mentioned above is the target-selector pattern: setting
selectors for success & fail handling respectively.

```objc
  [request setDidFinishSelector:@selector(requestDone:)];
  [request setDidFailSelector:@selector(requestWentWrong:)];
```

If you set completion selectors like above, your delegate's completion methods
will be ignored.

### 1.1.2 Using blocks

```objc
// step #1
//   create request instance

  // use keyword __block to make 'request' variable capturable and modifiable by blocks following
  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];

// setp #2
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

## 1.2 With AFNetworking

1. create a manager instance.

    the `AFHTTPRequestOperationManager` class holds settings globally for
    subsequently created request operation instances.

2. invode GET method & set everything in just one call.

```objc
AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
[manager GET:@"http://example.com/resources.json"
  parameters:nil
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
             }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
             }
];
```

## 1.3 With Alamofire

Just one call (actually a line of method chaining).

```swift
Alamofire.request(.GET, "http://httpbin.org/get", parameters: ["foo": "bar"])
         .response { (request, response, data, error) in
                     println(request)
                     println(response)
                     println(error)
                   }
```

# Use Case #2 - Simple POST Request

## With ASIHTTPRequest

Same as the above, excepts:

You should initialize a instance of `ASIFormDataRequest` instead of
`ASIHTTPRequest`, which provide a bunch of extra methods to help you with
composing form data body.

Set `setRequestMethod:` to `"POST"`, which is inherited from `ASIHTTPRequest`.

For request header, you can call `addRequestHeader: value:` to customize request header.

For request body, you can either set it manually using `ASIHTTPRequest`'s methods:

```objc
- (void)setPostBody:(NSMutableData)data
- (void)appendPostData:(NSData *)data;            // body data kept in memory
- (void)appendPostDataFromFile:(NSString *)file;  // streamed from disk, suite for large content uploading
```

or using `ASIFormDataRequest`s dedicated methods to compose request body:

```objc
// Using application/x-www-form-urlencoded Content-Type
- (void)setPostValue:(id <NSObject>)value forKey:(NSString *)key;
- (void)addPostValue:(id <NSObject>)value forKey:(NSString *)key;

// Using multipart/form-data Content-Type
- (void)addFile:(NSString *)filePath forKey:(NSString *)key;
- (void)addFile:(NSString *)filePath withFileName:(NSString *)fileName andContentType:(NSString *)contentType forKey:(NSString *)key;
- (void)setFile:(NSString *)filePath forKey:(NSString *)key;
- (void)setFile:(NSString *)filePath withFileName:(NSString *)fileName andContentType:(NSString *)contentType forKey:(NSString *)key;

- (void)addData:(NSData *)data forKey:(NSString *)key;
- (void)addData:(id)data withFileName:(NSString *)fileName andContentType:(NSString *)contentType forKey:(NSString *)key;
- (void)setData:(NSData *)data forKey:(NSString *)key;
- (void)setData:(id)data withFileName:(NSString *)fileName andContentType:(NSString *)contentType forKey:(NSString *)key;
```

# Use Case #3 - Downlaod Task

## 3.1 With ASIHTTPRequest

After creating an ASIHTTPRequest instance

+ set `setDownlaodDestinationPath`

+ set `temporaryFileDownloadPath`

+ set `allowResumeForFileDownloads` to YES, which

> tells ASIHTTPRequest not to delete partial downloads, and allows it to use an
> existing file to resume a download. Defaults to NO.

The names are very clarifying.

# Use Case #4 - Progress Watching

## 4.1 With ASIHTTPRequest

First of all, set `showAccurateProgress` proeprty to `YES`, otherwise it would
only notify you when a request is finished.

For simple use case, just set a `UIProgressView` instance as the
`ASIHTTPRequest`'s dowloadProgressDelegate.

```objc
// on ASI request object

setDownloadProgressDelegate:
setUploadProgressDelegate:

// on delegate implement ...

// for most cases
- (void)setProgress:(float)newProgress;
```

Implement `setProgress:` delegate methods to report the download progress, if
you want.

```objc
- (void)setProgress: (float)newProgress
{
  // average download speed in bytes/second
  unsigned long byte = [ASIHTTPRequest averageBandwidthUsedPerSecond];

  // current completion percent (between 0.0 ~ 1.0) from argument:
  newProgress;
}

@end
```

If you need more detail. `ASIProgressDelegate` protocol provides following
methods for you to implement, whose name is rather clarifying.

```objc
- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes;

- (void)request:(ASIHTTPRequest *)request didSendBytes:(long long)bytes;

- (void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength;

- (void)request:(ASIHTTPRequest *)request incrementUploadSizeBy:(long long)newLength;
```

If you ask for more details, `ASIHTTPRequest` provides.

# Framework Office Documentation

1. [ASIHTTPRequest](http://allseeing-i.com/ASIHTTPRequest/How-to-use)

2. [AFNetworking](http://cocoadocs.org/docsets/AFNetworking/2.5.3/)

3. [Alamofire](https://github.com/Alamofire/Alamofire)
