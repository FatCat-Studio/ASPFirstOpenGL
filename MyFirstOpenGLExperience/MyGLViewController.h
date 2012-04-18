//
//  MyGLViewController.h
//  MyFirstOpenGLExperience
//
//  Created by Руслан Федоров on 4/18/12.
//  Copyright (c) 2012 MIPT iLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
@interface MyGLViewController : GLKViewController 
@property () IBOutlet NSArray *colors;
@property (weak, nonatomic) IBOutlet UIProgressView *redPV;
@property (weak, nonatomic) IBOutlet UIProgressView *greenPV;
@property (weak, nonatomic) IBOutlet UIProgressView *bluePV;



@end
