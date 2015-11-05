//
//  MainViewController.m
//  SimpleGLKitGame
//
//  Created by Turtleeeeeeeeee on 15/11/4.
//  Copyright © 2015年 SCNU. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@property(strong, nonatomic) EAGLContext *context;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!self.context) {
        NSLog(@"Failed to create OpenGL ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    [EAGLContext setCurrentContext:self.context];
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
}

- (void)update{
    
}
@end
