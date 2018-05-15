//
//  OpenCVWrapper.h
//  OpenCvExample
//
//  Created by AHMED NASSER on 3/12/18.
//  Copyright © 2018 AHMED NASSER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface OpenCVWrapper : NSObject  
-(void) prepareCamera:(UIImageView*)imageView;
-(void) start;
@property(nonatomic,strong) UIImageView* faceImage;
@end
