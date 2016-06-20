//
//  YFKit.m
//  AuthorityOfCameraAndPhoto
//
//  Created by chenyufeng on 6/20/16.
//  Copyright © 2016 chenyufengweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFKit.h"
@import AVFoundation;

typedef void(^YFUIAlertControllerBlock)(UIAlertController *dialog,NSInteger buttonIndx);

@implementation YFKit

+ (BOOL)isCameraDenied
{
    AVAuthorizationStatus author = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (author == AVAuthorizationStatusRestricted || author == AVAuthorizationStatusDenied)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isCameraNotDetermined
{
    AVAuthorizationStatus author = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (author == AVAuthorizationStatusNotDetermined)
    {
        return YES;
    }
    return NO;
}



@end
