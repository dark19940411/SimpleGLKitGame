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
@property(strong) GLKBaseEffect *effect;
@property(strong) Sprite *player;
@property(strong) NSMutableArray *children;
@property(assign) float timeSinceLastSpawn;
@property(strong) NSMutableArray *projectiles;
@property(strong) NSMutableArray *targets;
@property(assign) int targetsDestroyed;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!self.context) {
        NSLog(@"Failed to create OpenGL ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    [EAGLContext setCurrentContext:self.context];
    
    _effect = [[GLKBaseEffect alloc] init];
    GLKMatrix4 projectionMatirx = GLKMatrix4MakeOrtho(0, screenSize.width, 0, screenSize.height, -1024, 1024);
    _effect.transform.projectionMatrix = projectionMatirx;
    
    _player = [[Sprite alloc] initWithFile:@"Player.png" effect:_effect];
    _player.position = GLKVector2Make(_player.contentSize.width / 2, screenSize.height / 2);
    
    _children = [NSMutableArray array];
    [_children addObject:_player];
//    _player.moveVelocity = GLKVector2Make(50, 50);
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    _projectiles = [NSMutableArray array];
    _targets = [NSMutableArray array];
}

- (void)handleTapFrom:(id)sender {
    UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
    
    CGPoint touchLocation = [tapRecognizer locationInView:tapRecognizer.view];
    touchLocation = CGPointMake(touchLocation.x, 320 - touchLocation.y);
    
    GLKVector2 target = GLKVector2Make(touchLocation.x, touchLocation.y);
    GLKVector2 offset = GLKVector2Subtract(target, _player.position);
    
    GLKVector2 nomalizedOffset = GLKVector2Normalize(offset);
    
    static float POINTS_PER_SECOND = 480;
    GLKVector2 moveVelocity = GLKVector2MultiplyScalar(nomalizedOffset, POINTS_PER_SECOND);
    
    Sprite *sprite = [[Sprite alloc] initWithFile:@"Projectile.png" effect:_effect];
    sprite.position = _player.position;
    sprite.moveVelocity = moveVelocity;
    [_children addObject:sprite];
    
    [_projectiles addObject:sprite];
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(1, 1, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    for (Sprite *sprite in _children) {
        [sprite render];
    }
}

- (void)addTarget {
    Sprite *target = [[Sprite alloc] initWithFile:@"Target.png" effect:_effect];
    [_children addObject:target];
    
    int minY = target.contentSize.height / 2;
    int maxY = 320 - target.contentSize.height / 2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    target.position = GLKVector2Make(480, actualY);
    
    int minVelocity = 480.0 / 4.0;
    int maxVelocity = 480.0 / 2.0;
    int rangeVelocity = maxVelocity - minVelocity;
    int actualVelocity = (arc4random() % rangeVelocity) + minVelocity;
    
    target.moveVelocity = GLKVector2Make(-actualVelocity, 0);
    
    [_targets addObject:target];
}

- (void)update{
    NSMutableArray *projectilesToDelete = [NSMutableArray array];
    for (Sprite *projectile in _projectiles) {
        NSMutableArray *targetsToDelete = [NSMutableArray array];
        for (Sprite *target in _targets) {
            if (CGRectIntersectsRect(projectile.boundingBox, target.boundingBox)) {
                [targetsToDelete addObject:target];
            }
        }
        for (Sprite *target in targetsToDelete) {
            [_targets removeObject:target];
            [_children removeObject:target];
            _targetsDestroyed++;
        }
        
        if (targetsToDelete.count > 0) {
            [projectilesToDelete addObject:projectile];  //?????????????????不懂
        }
    }
    
    for (Sprite *projectile in projectilesToDelete) {
        [_projectiles removeObject:projectile];
        [_children removeObject:projectile];
    }
    
    _timeSinceLastSpawn += self.timeSinceLastUpdate;
    if (_timeSinceLastSpawn > 1.0) {
        _timeSinceLastSpawn = 0;
        [self addTarget];
    }
    for (Sprite *sprite in _children) {
        [sprite update:self.timeSinceLastUpdate];
    }
}
@end
