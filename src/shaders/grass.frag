#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// Input from tessellation evaluation shader
layout(location = 0) in vec3 fsNormal;
layout(location = 1) in float fsHeightRatio;

layout(location = 0) out vec4 outFragColor;

void main() {
    // Define grass color palette
    vec4 grassDark = vec4(0.0, 0.1, 0.0, 1.0);      // Dark green at base
    vec4 grassMid = vec4(0.0, 0.5, 0.0, 1.0);        // Mid green in middle
    vec4 grassLight = vec4(0.5, 0.8, 0.5, 1.0);      // Light green at tip
    
    // Calculate lighting based on surface normal
    vec3 upVector = vec3(0.0, 1.0, 0.0);
    float lightIntensity = abs(dot(upVector, fsNormal));
    
    // Blend between dark and light based on lighting
    vec4 litColor = mix(grassDark, grassLight, lightIntensity);
    
    // Blend between mid and light based on height along blade
    vec4 heightColor = mix(grassMid, grassLight, fsHeightRatio);
    
    // Combine lighting and height for final color
    outFragColor = mix(litColor, heightColor, 0.5);
}