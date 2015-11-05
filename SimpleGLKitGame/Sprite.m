//
//  Sprite.m
//  SimpleGLKitGame
//
//  Created by Turtleeeeeeeeee on 15/11/4.
//  Copyright © 2015年 SCNU. All rights reserved.
//

#import "Sprite.h"

typedef struct {
    CGPoint geometryVertex;
    CGPoint textureVertex;
}TexturedVertex;

typedef struct {
    TexturedVertex bl;
    TexturedVertex br;
    TexturedVertex tl;
    TexturedVertex tr;
}TexturedQuad;

@interface Sprite ()

@property (strong)GLKBaseEffect *effect;
@property (assign)TexturedQuad quad;
@property (strong)GLKTextureInfo *textureInfo;

@end

@implementation Sprite

- (id)initWithFile:(NSString *)fileName effect:(GLKBaseEffect *)effect {
    if (self = [super init]) {
        _effect = effect;
        
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithBool:YES],
                                GLKTextureLoaderOriginBottomLeft,
                                nil];
        
        NSError *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        
        _textureInfo = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
        if (_textureInfo == nil) {
            NSLog(@"Error loading file: %@", [error localizedDescription]);
            return nil;
        }
        // Set up Textured Quad...
        TexturedQuad newQuad;
        newQuad.bl.geometryVertex = CGPointMake(0, 0);
        newQuad.br.geometryVertex = CGPointMake(_textureInfo.width, 0);
        newQuad.tl.geometryVertex = CGPointMake(0, _textureInfo.height);
        newQuad.tr.geometryVertex = CGPointMake(_textureInfo.width, _textureInfo.height);
        
        newQuad.bl.textureVertex = CGPointMake(0, 0);
        newQuad.br.textureVertex = CGPointMake(1, 0);
        newQuad.tl.textureVertex = CGPointMake(0, 1);
        newQuad.tr.textureVertex = CGPointMake(1, 1);
        _quad = newQuad;
    }
    return self;
}

- (void)render {
    _effect.texture2d0.name = _textureInfo.name;
    _effect.texture2d0.enabled = YES;
    
    [_effect prepareToDraw];
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    
    long offset = (long)&_quad;    //迷之C！
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void *)(offset + offsetof(TexturedVertex, geometryVertex)));
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void *)(offset + offsetof(TexturedVertex, textureVertex)));
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

@end
