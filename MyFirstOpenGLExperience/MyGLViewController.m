//
//  MyGLViewController.m
//  MyFirstOpenGLExperience
//
//  Created by Руслан Федоров on 4/18/12.
//  Copyright (c) 2012 MIPT iLab. All rights reserved.
//

#import "MyGLViewController.h"

@interface MyGLViewController (){
	GLfloat _colors[3];
	GLboolean _increasing[3];
}
@property (strong, nonatomic) EAGLContext *context;
@end

@implementation MyGLViewController
@synthesize context=_context;

- (IBAction)updateColor:(id)sender{
	_colors[[sender tag]]=[(NSNumber*)[sender valueForKey:@"value"] floatValue];
	for (UIControl *ptr in [[self view]subviews]) {
		if ([ptr respondsToSelector:NSSelectorFromString(@"value")])
			[ptr setValue:[NSNumber numberWithFloat:_colors[[ptr tag]]] forKey:@"value"];
		else if ([ptr respondsToSelector:NSSelectorFromString(@"setText:")]) {
			[(UILabel*)ptr setText:[NSString stringWithFormat:@"%.2f",_colors[[ptr tag]]]];
		}
	}
	
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
	if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
	GLKView *view = (GLKView *)self.view;
    view.context = self.context;
	for (int i=0;i<3;++i)
		_colors[i]=0.5;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    self.context = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
	
    glClearColor(_colors[0], _colors[1], _colors[2], 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
	
}

- (void)update {
	
}

@end
