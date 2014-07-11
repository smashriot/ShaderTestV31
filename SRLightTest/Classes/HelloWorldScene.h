// -----------------------------------------------------------------------
//  HelloWorldScene.h
//  SRLightTest - Blur and Lighting Shader Test for Cocos2d v3.1
//
//  Created by Jesse Ozog on 2014/07/10.
//  Copyright SmashRiot, LLC 2014. All rights reserved.
//
// * "THE BEER-WARE LICENSE" (Revision 42):
// * Jesse Ozog <capsaic@SmashRiot.com> wrote this file. As long as you retain this notice you
// * can do whatever you want with this stuff. If we meet some day, and you think
// * this stuff is worth it, you can buy me a beer in return. Jesse Ozog
// -------------------------------------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using Cocos2D v3
#import "cocos2d.h"
#import "cocos2d-ui.h"

// lighting defines
#define LIGHTING_INTENSITY 1.75
#define LIGHTING_INTENSITY_STEP 0.0055
#define LIGHTING_FALLOFF 0.00005
#define LIGHTING_FALLOFF_STEP 0.0000001
#define LIGHTING_FRAMES 300

// sprite is 50x50. ipad is 1024x768 = 20.5x15.4 tiles
#define TILES_HIGH 16
#define TILES_WIDE 21
#define TILE_IMAGE @"Icon-Small-50.png"
#define TILE_IMAGE_WIDTH 50
#define TILE_IMAGE_HEIGHT 50

// show progress: 2014-07-10 21:24:48.007 SRLightTest[71207:90b] lightPosUpdate: LightPos[270,202], Falloff[0.00005790], Intensity[1.316]
#define LIGHT_DEBUG TRUE

// -----------------------------------------------------------------------
// -----------------------------------------------------------------------
@interface HelloWorldScene : CCScene
{
    CGPoint lightPos;
    float lightFalloff;
    float lightIntensity;
    CCNode *background;
    CCSprite *lightSprite;
}

// -----------------------------------------------------------------------
// -----------------------------------------------------------------------
+ (HelloWorldScene *)scene;
-(id)init;
-(void) dealloc;
-(void) lightPosUpdate:(float) dt;

@end