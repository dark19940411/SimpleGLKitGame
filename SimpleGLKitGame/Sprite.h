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

- (id)initWithFile:(NSString *) fileName effect:(GLKBaseEffect *)effect;
- (void)render;

@end
