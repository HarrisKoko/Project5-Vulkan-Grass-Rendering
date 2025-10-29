#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 1, binding = 0) uniform ModelBufferObject {
    mat4 model;
};

// TODO: Declare vertex shader inputs and outputs
// Blade data from vertex buffer
layout(location = 0) in vec4 basePosition;      // v0: position + direction
layout(location = 1) in vec4 bezierControl;     // v1: bezier point + height
layout(location = 2) in vec4 physicsGuide;      // v2: physics guide + width
layout(location = 3) in vec4 bladeUpVector;     // up: up vector + stiffness

// Pass blade data to tessellation control shader
layout(location = 0) out vec3 tcBasePos;
layout(location = 1) out vec3 tcBezierPt;
layout(location = 2) out vec3 tcPhysicsPt;
layout(location = 3) out vec3 tcUpDir;
layout(location = 4) out float tcBladeWidth;

out gl_PerVertex {
    vec4 gl_Position;
};

void main() {
    // Transform base position to world space
    gl_Position = model * basePosition;
    
    // Pass blade geometry to next stage
    tcBasePos = vec3(model * vec4(basePosition.xyz, 1.0));
    tcBezierPt = vec3(model * vec4(bezierControl.xyz, 1.0));
    tcPhysicsPt = vec3(model * vec4(physicsGuide.xyz, 1.0));
    
    // Extract width and calculate up direction from stiffness value
    tcBladeWidth = physicsGuide.w;
    tcUpDir = normalize(vec3(
        bladeUpVector.w * cos(basePosition.w),
        0.0,
        bladeUpVector.w * sin(basePosition.w)
    ));
}