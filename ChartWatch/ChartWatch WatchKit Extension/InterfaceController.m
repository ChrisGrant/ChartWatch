//
//  InterfaceController.m
//  ChartWatch WatchKit Extension
//
//  Copyright (c) 2014 Scott Logic Ltd. All rights reserved.
//

#import "InterfaceController.h"

@interface InterfaceController() <NSFilePresenter>

@property (weak, nonatomic) IBOutlet WKInterfaceImage *imageView;
@property (strong, nonatomic) NSURL *chartImageFileURL;

@end

@implementation InterfaceController

- (instancetype)init {
    self = [super init];
    if (self) {
        NSFileManager *defaultManager = [NSFileManager defaultManager];
        NSURL *baseUrl = [defaultManager containerURLForSecurityApplicationGroupIdentifier:@"group.ShareAlike"];
        self.chartImageFileURL = [baseUrl URLByAppendingPathComponent:@"chartImageData.png"
                                                          isDirectory:NO];
        
        [NSFileCoordinator addFilePresenter:self];
    }
    return self;
}

- (NSURL *)presentedItemURL {
    return self.chartImageFileURL;
}

- (NSOperationQueue *)presentedItemOperationQueue {
    return [NSOperationQueue mainQueue];
}

- (void)presentedItemDidChange {
    [self updateImage];
}

- (void)willActivate {
    [self updateImage];
}

- (void)updateImage {
    NSError *error;
    if (![self.chartImageFileURL checkResourceIsReachableAndReturnError:&error]) {
        NSLog(@"Chart image not available at %@. Error: %@", self.chartImageFileURL, error.debugDescription);
        return;
    }
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.chartImageFileURL]];
    [self.imageView setImage:image];
}

@end
