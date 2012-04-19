//
//  MyGLViewController.m
//  MyFirstOpenGLExperience
//
//  Created by Руслан Федоров on 4/18/12.
//  Copyright (c) 2012 MIPT iLab. All rights reserved.
//

#import "MyGLViewController.h"
#define PREFERED_FPS 60
@interface MyGLViewController (){
	GLfloat _colors[3];
	GLboolean _increasing[3];
	GLuint _vertexBuffer;
	GLuint _indexBuffer;
	float _rotation;
}
@property (strong, nonatomic) GLKBaseEffect *effect;
@property (strong, nonatomic) EAGLContext *context;
@end

@implementation MyGLViewController
@synthesize FPS = _FPS;
@synthesize context=_context;
@synthesize effect = _effect;
//Структура для хранения вершин
typedef struct {
    float Position[3];
    float Color[4];
} Vertex;
//Собственно вершины наших треугольников, они же вершины квадрата
const Vertex Vertices[] = {
    {{1, -1, 0}, {1, 0, 0, 1}},
    {{1, 1, 0}, {0, 1, 0, 1}},
    {{-1, 1, 0}, {0, 0, 1, 1}},
    {{-1, -1, 0}, {0, 0, 0, 1}}
};
//Собственно перечисление вершин для двух треугольников
const GLubyte Indices[] = {
    0, 1, 2,
    2, 3, 0
};
#pragma mark Loading
- (void)setupGL {
	//Выставляем рандомные цвета на фон
	for (int i=0;i<3;++i)
		_colors[i]=(rand() % 10) / 10.0;
	//Создаем контекст второй версии OpenGLES2
	self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
	if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
	//Задаем нашему вью наш контекст
	((GLKView *)self.view).context=_context;
	//Выставляем наш контекст текущим
    [EAGLContext setCurrentContext:_context];
	//Задаем желаемый фреймрейт
	self.preferredFramesPerSecond=PREFERED_FPS;
	//Создаем себе помошника. Он будет думать над шейдерами вместо нас
	self.effect=[[GLKBaseEffect alloc]init];
	//Генерируем буфер в соответствующую переменную
    glGenBuffers(1, &_vertexBuffer);
	//Байндим GL_ARRAY_BUFFER на нашу буфферную переменную
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
	//Заполняем наш буфер данными вершин
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
	//Аналогично для индексов
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
	//Считаем аспект, создаем проэкторную матрицу (тупо говоря камеру) и назначаем ее нашему помошнику
	float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
	GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 4.0f, 10.0f);    
	self.effect.transform.projectionMatrix = projectionMatrix;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//Дергаем инициализацию опенгл
	[self setupGL];
}
#pragma mark Unloading
- (void)tearDownGL {
	//Убиваем буффера и пошника
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_indexBuffer);
	self.effect=nil;
	//Убиваем контекст
	if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
	self.context = nil;
}
- (void)viewDidUnload {
	//Убиваем опенгл
	[self tearDownGL];
	[self setFPS:nil];
    [super viewDidUnload];
}
#pragma mark -
#pragma mark Stuff
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark Drawing
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
	//Рисуем! :)
	//Выставляем цвет очистки и чистим
    glClearColor(_colors[0], _colors[1], _colors[2], 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
	//Выставляем буффера. Впринципе это уже было сделано, но вдруг.
	glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
	//Дергаем инфу к рисованию
	glEnableVertexAttribArray(GLKVertexAttribPosition);        
	glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Position));
	glEnableVertexAttribArray(GLKVertexAttribColor);
	glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Color));
	[self.effect prepareToDraw];
	//Ну, рисуем! :)
	glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
}
- (void)update {
	//Обновляем цвета
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
	//Делаем матрицу, на 6 пунктов отодвигаем (иначе не видно)
	GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -6.0f);   
	//Совершаем поворот
	if (_rotation>=360)
		_rotation -= 360;
	_rotation += 90 * self.timeSinceLastUpdate;
	//Рожаем матрицу поворота
	modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(_rotation), 0, 0, 1);
	//Поворачиваем
	self.effect.transform.modelviewMatrix = modelViewMatrix;
	[_FPS setText:[NSString stringWithFormat:@"%d",[self framesPerSecond]]];
}
#pragma Mark Interactions
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"timeSinceLastUpdate: %f", self.timeSinceLastUpdate);
	NSLog(@"timeSinceLastDraw: %f", self.timeSinceLastDraw);
	NSLog(@"timeSinceFirstResume: %f", self.timeSinceFirstResume);
	NSLog(@"timeSinceLastResume: %f", self.timeSinceLastResume);
    self.paused = !self.paused;
}

@end
