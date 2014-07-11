// -------------------------------------------------------------------------------------------------
//  ** LIGHT+BLUR VERTEX SHADER
//  LightingBlurShader.vsh
//  SRLightTest - Blur and Lighting Shader Test for Cocos2d v3.1
//
//  Created by Jesse Ozog on 2014/07/10.
//  Copyright SmashRiot, LLC 2014. All rights reserved.
//
// * "THE BEER-WARE LICENSE" (Revision 42):
// * Jesse Ozog <capsaic@SmashRiot.com> wrote this file. As long as you retain this notice you
// * can do whatever you want with this stuff. If we meet some day, and you think
// * this stuff is worth it, you can buy me a beer in return. Jesse Ozog
//
// For default uniforms/attributes, see Shaders: https://github.com/cocos2d/cocos2d-iphone/issues/631
// cc_Position which is equivalent to v2.x: a_Position * u_MVPMatrix: http://forum.cocos2d-swift.org/t/ccshader-issue/13581
// -------------------------------------------------------------------------------------------------

// there is a default set of uniforms and attributes (e.g. cc_Position), see link above.

// additional uniforms passed in each frame
uniform vec4 u_spritePosition;   // this is a sprite specific uniform
uniform vec4 u_lightPosition;    // this is a global uniform
uniform float u_lightFalloff;    // this is a global uniform
uniform float u_lightIntensity;  // this is a global uniform

// text coords for blur
varying lowp vec2 v_textCoordL;
varying lowp vec2 v_textCoordR;

void main(){
	gl_Position = cc_Position; // this is already in eye space
    
    // calc light dist
    // this isn't working like it did in v2.x.  The cc_Position is already transformed to eyespace.
    // should do the same with u_lightPosition, instead for now i'm using the tile and light worldspace dist.
    //mediump float lightDistance = distance(cc_Position, u_lightPosition);  // this isn't working, need to transform lightPos
    // alternatively, pass the world space of sprite and light and figure out the distance between them.
    // using world space changes the falloff/intensity values vs those used in eyespace
    mediump float lightDistance = distance(u_spritePosition, u_lightPosition);
    
    // falloff 0.00005 = dark, 0.000005 = light.
    lowp float lightValue = (1.0 / (1.0 + (u_lightFalloff * lightDistance * lightDistance)));
    
    // set frag color with lighting
    cc_FragColor = vec4(cc_Color.rgb * (lightValue * u_lightIntensity), cc_Color.a);
    
    // coordinates
	cc_FragTexCoord1 = cc_TexCoord1;
	cc_FragTexCoord2 = cc_TexCoord2;
    // this 0.00390625 is a current texel size. calculate it and set instead of hard coding as a magic number.
    // 256px sprite sheet texel size is 1/256px = 0.00390625..
    v_textCoordL = vec2(cc_TexCoord1.x-0.00390625, cc_TexCoord1.y);
    v_textCoordR = vec2(cc_TexCoord1.x+0.00390625, cc_TexCoord1.y);
}