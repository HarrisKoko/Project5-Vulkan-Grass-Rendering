#version 450
#extension GL_ARB_separate_shader_objects : enable
layout(quads, equal_spacing, ccw) in;
layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

layout(location = 0) in vec3 teBasePos[];
layout(location = 1) in vec3 teBezierPt[];
layout(location = 2) in vec3 tePhysicsPt[];
layout(location = 3) in vec3 teUpDir[];
layout(location = 4) in float teBladeWidth[];

// TODO: Declare tessellation evaluation shader inputs and outputs
layout(location = 0) out vec3 fsNormal;
layout(location = 1) out float fsHeightRatio;

void main() {
    float u = gl_TessCoord.x * 1.5;
    float v = gl_TessCoord.y;
    vec3 basePos = teBasePos[0];
    vec3 bezierPt = teBezierPt[0];
    vec3 physicsPt = tePhysicsPt[0];
    vec3 upDir = teUpDir[0];
    float bladeWidth = teBladeWidth[0];
    
    // TODO: Use u and v to parameterize along the grass blade and output positions for each vertex of the grass blade
    vec3 posAlongHeight = mix(basePos, bezierPt, v);
    vec3 posAlongCurve = mix(posAlongHeight, mix(bezierPt, physicsPt, v), v);
    
    vec3 edgeLeft = posAlongCurve - bladeWidth * upDir;
    vec3 edgeRight = posAlongCurve + bladeWidth * upDir;
    
    float edgeBlend = u + 0.5 * v - u * v;
    vec3 finalPosition = mix(edgeLeft, edgeRight, edgeBlend);
    
    vec3 tangent = normalize(mix(bezierPt, physicsPt, v) - posAlongHeight);
    fsNormal = normalize(cross(tangent, upDir));
    
    fsHeightRatio = v;
    
    gl_Position = camera.proj * camera.view * vec4(finalPosition, 1.0);
}