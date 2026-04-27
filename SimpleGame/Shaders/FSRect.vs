#version 330

in vec3 a_Pos;
in vec2 a_Tex;
uniform float u_Time;
out vec2 v_Tex;
out float v_Time;

void main()
{

	v_Tex = a_Tex;
	v_Time = u_Time;
	vec4 newPosition;
	newPosition = vec4(a_Pos,1);
	gl_Position = newPosition;
}
