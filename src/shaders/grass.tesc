#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(vertices = 4) out;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// Receive blade data from vertex shader
layout(location = 0) in vec3 tcBasePos[];
layout(location = 1) in vec3 tcBezierPt[];
layout(location = 2) in vec3 tcPhysicsPt[];
layout(location = 3) in vec3 tcUpDir[];
layout(location = 4) in float tcBladeWidth[];

// TODO: Declare tessellation control shader inputs and outputs
// Pass blade data to tessellation evaluation shader
layout(location = 0) out vec3 teBasePos[];
layout(location = 1) out vec3 teBezierPt[];
layout(location = 2) out vec3 tePhysicsPt[];
layout(location = 3) out vec3 teUpDir[];
layout(location = 4) out float teBladeWidth[];

in gl_PerVertex {
    vec4 gl_Position;
} gl_in[];

out gl_PerVertex {
    vec4 gl_Position;
} gl_out[];

void main() {
	// Don't move the origin location of the patch
    gl_out[gl_InvocationID].gl_Position = gl_in[gl_InvocationID].gl_Position;
	
	// TODO: Write any shader outputs
    // Pass blade geometry data to evaluation shader
    teBasePos[gl_InvocationID] = tcBasePos[gl_InvocationID];
    teBezierPt[gl_InvocationID] = tcBezierPt[gl_InvocationID];
    tePhysicsPt[gl_InvocationID] = tcPhysicsPt[gl_InvocationID];
    teUpDir[gl_InvocationID] = tcUpDir[gl_InvocationID];
    teBladeWidth[gl_InvocationID] = tcBladeWidth[gl_InvocationID];
    
	// TODO: Set level of tessellation
    // Calculate tessellation levels based on distance to camera
    float distToCamera = length(tcBasePos[gl_InvocationID] - inverse(camera.view)[3].xyz);
    float tessLevel = 4.0;
    
    if (distToCamera < 2.0)
        tessLevel = 32.0;
    else if (distToCamera < 4.0)
        tessLevel = 24.0;
    else if (distToCamera < 6.0)
        tessLevel = 20.0;
    else if (distToCamera < 8.0)
        tessLevel = 16.0;
    else if (distToCamera < 12.0)
        tessLevel = 14.0;
    else if (distToCamera < 16.0)
        tessLevel = 12.0;
    else if (distToCamera < 20.0)
        tessLevel = 10.0;
    else if (distToCamera < 24.0)
        tessLevel = 8.0;
    else if (distToCamera < 28.0)
        tessLevel = 6.0;
    else if (distToCamera < 32.0)
        tessLevel = 4.0;
    else
        tessLevel = 2.0;
    
    gl_TessLevelInner[0] = tessLevel;
    gl_TessLevelInner[1] = tessLevel;
    gl_TessLevelOuter[0] = tessLevel;
    gl_TessLevelOuter[1] = tessLevel;
    gl_TessLevelOuter[2] = tessLevel;
    gl_TessLevelOuter[3] = tessLevel;
}