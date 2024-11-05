#version 300 es
precision mediump float;

uniform sampler2D u_texture;
in vec2 v_texCoord;

out vec4 fragColor;

void main() {
  vec4 color = texture(u_texture, v_texCoord);
  float gray = (color.r + color.g + color.b) / 3.0;
  fragColor = vec4(gray, gray, gray, color.a);
}
