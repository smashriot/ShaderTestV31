// -------------------------------------------------------------------------------------------------
//  ** LIGHT+BLUR FRAGMENT SHADER
//  LightingBlurShader.fsh
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
// -------------------------------------------------------------------------------------------------

// there is a default set of uniforms and attributes (e.g. cc_MainTexture), see link above.

// passed from vertex shader
varying lowp vec2 v_textCoordL;
varying lowp vec2 v_textCoordR;

void main(){
    // sample texture at coordinate
    lowp vec4 fragColor = texture2D(cc_MainTexture, cc_FragTexCoord1);
    
    // sample texture Left and Right of coordinate and take the one that is greater
    lowp vec4 fragBlur = max(texture2D(cc_MainTexture, v_textCoordL), texture2D(cc_MainTexture, v_textCoordR));
    
    // set the color to fragment tint color * native fragment color
    gl_FragColor = vec4(cc_FragColor.rgb * (fragColor.rgb + fragBlur.rgb), fragColor.a);
}