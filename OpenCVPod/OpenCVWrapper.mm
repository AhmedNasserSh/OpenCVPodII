//
//  OpenCVWrapper.m
//  OpenCvExample
//
//  Created by AHMED NASSER on 3/12/18.
//  Copyright © 2018 AHMED NASSER. All rights reserved.
//

#import "OpenCVWrapper.h"
#import <opencv2/videoio/cap_ios.h>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/objdetect.hpp>
#import "opencv2/highgui/highgui.hpp"
#import "opencv2/imgproc/imgproc.hpp"

#include <stdio.h>

using namespace std;
using namespace cv;
@interface OpenCVWrapper()<CvVideoCameraDelegate>{
    CvVideoCamera* videoCamera;
    cv::CascadeClassifier cascade;
    std::vector<cv::Rect> objects;
}

@end
@implementation OpenCVWrapper
-(void) prepareCamera:(UIImageView*)imageView {
    NSBundle *bundle = [NSBundle bundleForClass:[OpenCVWrapper class]];
    NSURL *url = [bundle URLForResource:@"Resources" withExtension:@"bundle"];
    NSBundle *fileBundle = [NSBundle bundleWithURL:url];
    
    NSString *path = [fileBundle pathForAuxiliaryExecutable:@"haarcascade_frontalface_alt.xml"];
    
    std::string cascade_path = (char *)[path UTF8String];
    if (!cascade.load(cascade_path)) {
        NSLog(@"Couldn't load haar cascade file.");
    }
    videoCamera = [[CvVideoCamera alloc] initWithParentView:imageView];
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront ;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    videoCamera.defaultFPS = 30;
    videoCamera.grayscaleMode = NO;
    videoCamera.delegate = self;
}
#pragma mark - Protocol CvVideoCameraDelegate
- (void)processImage:(cv::Mat &)image {
    
    
    
    cv::Mat grayMat;
    
    cv::cvtColor(image, grayMat, CV_BGR2GRAY);
    
    cv::equalizeHist(grayMat, grayMat);
    
    objects.clear();
    cascade.detectMultiScale(grayMat, objects,
                             4.6, 1,
                             CV_HAAR_SCALE_IMAGE,
                             cv::Size(40, 40));
    
    for(size_t i = 0; i < objects.size(); ++i) {
        cv::Point center;
        int radius;
        const cv::Rect& r = objects[i];
        center.x = cv::saturate_cast<int>((r.x + r.width*0.5));
        center.y = cv::saturate_cast<int>((r.y + r.height*0.5));
        radius = cv::saturate_cast<int>((r.width + r.height)*0.5);
        cv::circle(image, center, radius, cv::Scalar(80,80,255), 3, 8, 0 );
    }
}

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat {
    cvtColor(cvMat, cvMat, CV_BGR2RGB);
    cvtColor(cvMat, cvMat, CV_RGB2BGR);
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    
    CGColorSpaceRef colorSpace;
    CGBitmapInfo bitmapInfo;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
        bitmapInfo = kCGImageAlphaNone | kCGBitmapByteOrderDefault;
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
        bitmapInfo = kCGBitmapByteOrder32Little | (
                                                   cvMat.elemSize() == 3? kCGImageAlphaNone : kCGImageAlphaNoneSkipFirst
                                                   );
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(
                                        cvMat.cols,                 //width
                                        cvMat.rows,                 //height
                                        8,                          //bits per component
                                        8 * cvMat.elemSize(),       //bits per pixel
                                        cvMat.step[0],              //bytesPerRow
                                        colorSpace,                 //colorspace
                                        bitmapInfo,                 // bitmap info
                                        provider,                   //CGDataProviderRef
                                        NULL,                       //decode
                                        false,                      //should interpolate
                                        kCGRenderingIntentDefault   //intent
                                        );
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}
-(void)start{
    [videoCamera start];
}
@end

