//
//  ASPAppDelegate.h
//  MyFirstOpenGLExperience
//
//  Created by Руслан Федоров on 3/31/12.
//  Copyright (c) 2012 MIPT iLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

//Отписались, что мы отвечаем требованиям протокола GLKViewDelegate
@interface ASPAppDelegate : UIResponder <UIApplicationDelegate,GLKViewDelegate,GLKViewControllerDelegate>{
	GLfloat _curRed;
	GLboolean _increasing;
}

@property (strong, nonatomic) UIWindow *window;

@end
