//
//  LongLegHelper.m
//  OpenGL_ES_Filter_04
//
//  Created by tlab on 2020/8/31.
//  Copyright © 2020 yuanfangzhuye. All rights reserved.
//

#import "LongLegHelper.h"

@implementation LongLegHelper

//将一个顶点着色器和一个片段着色器挂载到一个着色器程序上，并返回程序的 id
+ (GLuint)programWithShaderName:(NSString *)shaderName {
    
    //1.编译两个着色器
    GLuint vertexShader = [self compileShaderWithName:shaderName type:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShaderWithName:shaderName type:GL_FRAGMENT_SHADER];
    
    //2.加载 shader 到 program 上
    GLuint program = glCreateProgram();
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);
    
    //3.链接 program
    glLinkProgram(program);
    
    //4.检查链接是否成功
    GLint linkSuccess;
    glGetProgramiv(program, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar message[256];
        glGetProgramInfoLog(program, sizeof(message), 0, &message[0]);
        NSString *messageString = [NSString stringWithUTF8String:message];
        NSAssert(NO, @"program 链接失败：%@", messageString);
        exit(1);
    }
    
    return program;
}

//编译一个 shader，并返回 shader 的 id
+ (GLuint)compileShaderWithName:(NSString *)name type:(GLenum)shaderType {
    
    //查找 shader 文件，根据不同的类型确定后缀名
    NSString *shaderPath = [[NSBundle mainBundle] pathForResource:name ofType:shaderType == GL_VERTEX_SHADER ? @"vsh" : @"fsh"];
    NSError *error;
    NSString *shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSAssert(NO, @"读取 shader 失败");
        exit(1);
    }
    
    //创建一个 shader 对象
    GLuint shader = glCreateShader(shaderType);
    
    //获取 shader 的内容
    const char *shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = (int)[shaderString length];
    glShaderSource(shader, 1, &shaderStringUTF8, &shaderStringLength);
    
    //编译shader
    glCompileShader(shader);
    
    //查询 shader 是否编译成功
    GLint compileSuccess;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar message[256];
        glGetShaderInfoLog(shader, sizeof(message), 0, &message[0]);
        NSString *messageString = [NSString stringWithUTF8String:message];
        NSAssert(NO, @"shader 编译失败：%@", messageString);
        exit(1);
    }
    
    return shader;
}

@end
