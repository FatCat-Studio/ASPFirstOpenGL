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
@dynamic colors;
@synthesize redPV = _redPV;
@synthesize greenPV = _greenPV;
@synthesize bluePV = _bluePV;

- (NSArray*)colors{
	NSMutableArray *colors=[NSMutableArray arrayWithCapacity:3];
	for (int i=0; i<3; ++i){
		[colors addObject:[NSNumber numberWithFloat:_colors[i]]];
	}
	return colors;
}

- (void)setColors:(NSArray *)colors{
	for (int i=0; i<3; ++i){
		_colors[i]=[(NSNumber*)[colors objectAtIndex:i] floatValue];
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
		_colors[i]=(rand() % 10) / 10.0;
}

- (void)viewDidUnload
{
	[self setRedPV:nil];
	[self setGreenPV:nil];
	[self setBluePV:nil];
    [super viewDidUnload];
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    self.context = nil;}

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
	for (int i=0;i<3;++i){
		if (_increasing[i])
			_colors[i] += 1.0 * self.timeSinceLastUpdate;
		else
			_colors[i] -= 1.0 * self.timeSinceLastUpdate;
		if (_colors[i]>=1.0){
			_colors[i]=1.0;
			_increasing[i]=NO;
		}
		if (_colors[i]<=0.0){
			_colors[i]=0.0;
			_increasing[i]=YES;
		}
	}
	_redPV.progress=_colors[0];
	_greenPV.progress=_colors[1];
	_bluePV.progress=_colors[2];
}

@end
