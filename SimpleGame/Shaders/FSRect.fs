#version 330

layout(location=0) out vec4 FragColor;
in vec2 v_Tex;

uniform vec4 u_Color;

void main()
{
	if(v_Tex.x<0.5){
		FragColor = vec4(0);
	}
	else FragColor = vec4(1);
	FragColor = vec4(sin(v_Tex.x*3.14),sin(v_Tex.y*3.14),0,1);

}
