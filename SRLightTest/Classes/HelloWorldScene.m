// -----------------------------------------------------------------------
//  HelloWorldScene.m
//  SRLightTest - Blur and Lighting Shader Test for Cocos2d v3.1
//
//  Created by Jesse Ozog on 2014/07/10.
//  Copyright SmashRiot, LLC 2014. All rights reserved.
//
// https://github.com/cocos2d/cocos2d-iphone/wiki/Cocos2D-3.1-Alpha-Notes
//
// * "THE BEER-WARE LICENSE" (Revision 42):
// * Jesse Ozog <capsaic@SmashRiot.com> wrote this file. As long as you retain this notice you
// * can do whatever you want with this stuff. If we meet some day, and you think
// * this stuff is worth it, you can buy me a beer in return. Jesse Ozog
// -----------------------------------------------------------------------

#import "HelloWorldScene.h"
#import "CCNode_Private.h" /// this allows for setting the CCNode.shader

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation HelloWorldScene
{
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene
{
    return [[self alloc] init];
}


// -------------------------------------------------------------------------------------------------
// https://github.com/cocos2d/cocos2d-iphone/issues/631
// -------------------------------------------------------------------------------------------------
-(id) init;
{
	if( (self=[super init]) ) {
        
        // the v2.x method was to use a CCSpriteBatchNode and add all the sprites to it, which created
        // a set of quads corresponding to each sprite and then applied the CCSpriteBatchNode.shaderProgram
        // to those quads.
        //
        // The v3.1-3.x method is to use a CCNode (which replaces the deprecated CCSpriteBatchNode) as the
        // intelligent batcher for the sprites.  However, best I can tell is that adding a shader to the CCNode
        // does not actually do anything. The node (from my limited investigation) is not cascading the shader
        // to the child nodes. thus, all of the child nodes need to have the shader applied to them directly.
        // I have not done any performance testing on this setup.
        
        // CCNode - this is the batch node for all the sprites
        background = [CCNode node];
        [background setPosition:ccp(0,0)];
        [background setAnchorPoint:ccp(0,0)];
        [self addChild: background]; // add the batch node to the scene
        
        // set lighting defaults using globals for ease of shader illustration
        lightPos = ccp(0,0);
        lightFalloff = LIGHTING_FALLOFF;
        lightIntensity = LIGHTING_INTENSITY;
        
        // lighting sprite - this simply shows the position of light source
        lightSprite = [CCSprite spriteWithImageNamed:TILE_IMAGE];
        [lightSprite setPosition:ccp(0,0)];
        [lightSprite setAnchorPoint:ccp(0,0)];
        [lightSprite setColor:CCColor.redColor];
        [lightSprite setZOrder:1000];
        [background addChild:lightSprite];
        
        // setup the global shader uniforms that are passed to all shaders.
        // In this case, we need a light position, a light falloff, and a light intensity
        [CCDirector sharedDirector].globalShaderUniforms[@"u_lightPosition"] = [NSValue valueWithGLKVector4:GLKVector4Make(lightPos.x, lightPos.y, 0.0f, 0.0f)];
        [CCDirector sharedDirector].globalShaderUniforms[@"u_lightFalloff"] = [NSNumber numberWithFloat:lightFalloff];
        [CCDirector sharedDirector].globalShaderUniforms[@"u_lightIntensity"] = [NSNumber numberWithFloat:lightIntensity];
        
        // going to tile the screens using the cococs icon.  the shader will be applied to each sprite,
        // and each sprite is going to have another uniform that is specific to it.
        for (int y=0; y<TILES_HIGH; y++){
            for (int x=0; x<TILES_WIDE; x++){
                CCSprite *tileSprite = [CCSprite spriteWithImageNamed:TILE_IMAGE];
                [tileSprite setPosition:ccp(x*TILE_IMAGE_WIDTH,y*TILE_IMAGE_HEIGHT)];
                [tileSprite setAnchorPoint:ccp(0,0)];
                [tileSprite setZOrder:0];
                // this loads the shader from the LightingBlurShader.vsh and LightingBlurShader.fsh files
                [tileSprite setShader:[CCShader shaderNamed:@"LightingBlurShader"]];
                // and set the u_spritePosition uniform with a value specific to this sprite.
                tileSprite.shaderUniforms[@"u_spritePosition"] = [NSValue valueWithGLKVector4:GLKVector4Make(tileSprite.position.x, tileSprite.position.y, 0.0f, 0.0f)];
                [background addChild:tileSprite];
                tileSprite = nil;
            }
        }
        
        // update light pos 30x sec
        [self schedule:@selector(lightPosUpdate:) interval:0.033333];
	}
	return self;
}

// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
-(void) dealloc;
{
}


// -------------------------------------------------------------------------------------------------
// this updates the 3 global shader uniforms with new values corresponding to the light
// -------------------------------------------------------------------------------------------------
-(void) lightPosUpdate:(float) dt;
{
    // move light across background diagonally in LIGHTING_FRAMES steps
    CGSize size = [[CCDirector sharedDirector] viewSize];
    lightPos.x += size.width / LIGHTING_FRAMES;
    lightPos.y += size.height / LIGHTING_FRAMES;
    
    // wrap back to 0,0 after it goes off the screen
    if (lightPos.x > size.width && lightPos.y > size.height){
        lightPos.x -= size.width;
        lightPos.y -= size.height;
        
        // reset intensity
        lightFalloff = LIGHTING_FALLOFF;
        lightIntensity = LIGHTING_INTENSITY;
    }
    
    // move the sprite
    lightSprite.position = lightPos;
    
    // move light across background diagonally from bottom left to top right
    [CCDirector sharedDirector].globalShaderUniforms[@"u_lightPosition"] = [NSValue valueWithGLKVector4:GLKVector4Make(lightPos.x, lightPos.y, 0.0f, 0.0f)];
    
    // increasing falloff makes the light drop to darkness faster
    lightFalloff += LIGHTING_FALLOFF_STEP;
    [CCDirector sharedDirector].globalShaderUniforms[@"u_lightFalloff"] = [NSNumber numberWithFloat:lightFalloff];
    
    // decreasing the intensity makes the center spot less bright
    lightIntensity -= LIGHTING_INTENSITY_STEP;
    [CCDirector sharedDirector].globalShaderUniforms[@"u_lightIntensity"] = [NSNumber numberWithFloat:lightIntensity];
    
    // show values if debugging
    if (LIGHT_DEBUG) NSLog(@"lightPosUpdate: LightPos[%1.0f,%1.0f], Falloff[%1.8f], Intensity[%1.3f]", lightPos.x, lightPos.y, lightFalloff, lightIntensity);
}

@end