//
//  Sprite.h
//  SimpleGLKitGame
//
//  Created by Turtleeeeeeeeee on 15/11/4.
//  Copyright © 2015年 SCNU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Sprite : NSObject

@property(assign) GLKVector2 position;
@property(assign) CGSize contentSize;
@property(assign) GLKVector2 moveVelocity;

- (id)initWithFile:(NSString *) fileName effect:(GLKBaseEffect *)effect;
- (void)render;
- (void)update:(float)dt;

@end
