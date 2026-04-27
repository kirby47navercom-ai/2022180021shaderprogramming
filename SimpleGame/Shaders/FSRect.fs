#version 330

layout(location=0) out vec4 FragColor;
in vec2 v_Tex;
in float v_Time;
const float c_PI=3.141592;
//const vec4 c_Points[2] = vec4[2](vec4(0.5,0.5,0,0.5),vec4(0.5,0.7,0.5,1));
uniform vec4 u_Color;
uniform vec4 u_Points[500];

void simple(){
	if(v_Tex.x<0.5){
		FragColor = vec4(0);
	}
	else FragColor = vec4(1);
	//FragColor = vec4(sin(v_Tex.x*3.14),sin(v_Tex.y*3.14),0,1);
}
//이렇게하면 하얀색이었다가 검정색이 됨
//abs를 하면 양수가 되어 하얀색이 됨
//더하는 것은 그림을 더하는 것이다
//곱하는 것은 색깔을 곱하기
//
void Line(){
	//v_Tex.x 가 가로줄 ,v_Tex.y는 세로줄

	float periodx = v_Tex.x*c_PI*10;
	float periody = v_Tex.y*c_PI*10;
	//pow 16 하면 얇아짐
	float valuex = pow(abs(cos(periodx)),16);
	float valuey = pow(abs(cos(periody)),16);
	FragColor = vec4(max(valuex,valuey));
}
//사선으로 만드는 거 많이 해보기 시험에 나올만함
void Line2(){
	
	float trans = c_PI/2;
	float periodx = (v_Tex.x*c_PI*2-trans)*5;
	float periody = (v_Tex.y*c_PI*2-trans)*5;
	
	//float valuex = pow(abs(sin(periodx+periody)),16); 사선나옴
	float valuex = pow(abs(sin(periodx)),16);
	float valuey = pow(abs(sin(periody)),16);
	FragColor = vec4(valuex+valuey);
}

void Circle(){
	
	vec2 one=vec2(0.5,0.5);
	vec2 two=v_Tex;
	//if(distance(two,one)>0.49&&distance(two,one)<0.5) 하면 둘레 생김
	float d = distance(two,one);
	float width =0.01;
	float radius =0.5;
	if(d>radius-width&&d<radius)//if(d>radius)
	FragColor = vec4(1);
	else FragColor = vec4(0);

	//FragColor= vec4(distance(two,one)); 이러면 가운제로 흩뿌려짐

}
void Circles(){
	
	vec2 one=vec2(0.5,0.5);
	vec2 two=v_Tex;
	//if(distance(two,one)>0.49&&distance(two,one)<0.5) 하면 둘레 생김
	float d = distance(two,one);
	float width =0.01;
	float radius =0.5;
	
	FragColor = vec4(pow(abs(sin(d*2*c_PI*5-v_Time*20)),16));
	

}

//점점 어두워짐
//물방울 처럼 어두워지게 하는거
void wave(){
	
	vec2 one=vec2(0.5,0.5);
	vec2 two=v_Tex;
	//if(distance(two,one)>0.49&&distance(two,one)<0.5) 하면 둘레 생김
	float d = distance(two,one);
	float width =0.01;
	float radius =0.5;
	//float range=0.2;

	float newTime = fract(v_Time);
	//점점 어두워짐 생기면서
	float oneminus = 1-newTime;
	float range = newTime/5;

	float r= 1/range * clamp(range-d,0,1);
	FragColor = vec4(pow(abs(sin(d*2*c_PI*10-v_Time*20)),16)*r*oneminus);

}
/*
void wave2(){
	float accum;
	for(int i=0;i<2;++i){
		vec2 one=c_Points[i].xy;
		vec2 two=v_Tex;
		//if(distance(two,one)>0.49&&distance(two,one)<0.5) 하면 둘레 생김
		float d = distance(two,one);
		float width =0.01;
		float radius =0.5;
		//float range=0.2;

		float newTime = fract(v_Time);
		//점점 어두워짐 생기면서
		float oneminus = 1-newTime;
		float range = newTime/5;

		float r= 1/range * clamp(range-d,0,1);
		float gray  =pow(abs(sin(d*2*c_PI*10-v_Time*20)),16)*r*oneminus;
		accum += gray;
	}
	
	FragColor = vec4(accum);

}
void wave3(){
	float accum;
	for(int i=0;i<2;++i){
		vec2 one=c_Points[i].xy;
		vec2 two=v_Tex;
		//if(distance(two,one)>0.49&&distance(two,one)<0.5) 하면 둘레 생김
		float d = distance(two,one);
		float width =0.01;
		float radius =0.5;
		//float range=0.2;

		float sTime = c_Points[i].z;
		float newTime = v_Time - sTime;
		if(newTime>0){
		float t= fract(newTime);
		//점점 어두워짐 생기면서
		float oneminus = 1-t;
		float range = t/5;

		float fade= 1/range * clamp(range-d,0,1);
		float gray  =pow(abs(sin(d*2*c_PI*10-v_Time*20)),16)*fade*oneminus;
		accum += gray;
		}
	}
	
	FragColor = vec4(accum);

}
void wave4(){
	float accum;
	for(int i=0;i<2;++i){
		vec2 one=c_Points[i].xy;
		vec2 two=v_Tex;
		//if(distance(two,one)>0.49&&distance(two,one)<0.5) 하면 둘레 생김
		float d = distance(two,one);
		float width =0.01;
		float radius =0.5;
		//float range=0.2;

		float sTime = c_Points[i].z;
		float lTime = c_Points[i].w;
		float newTime = v_Time - sTime;
		if(newTime>0){
		float t= fract(newTime/lTime);
		float oneminus = 1-t;
		t=t*lTime;
		//점점 어두워짐 생기면서
		float range = t/5;

		float fade= 1/range * clamp(range-d,0,1);
	
		 float gray  =pow(abs(sin(d*2*c_PI*10-t*30)),16)*fade*oneminus;
	
		accum += gray;
		}
	}
	
	FragColor = vec4(accum);

}
*/
void wave5(){
	float accum;
	for(int i=0;i<500;++i){
		vec2 one=u_Points[i].xy;
		vec2 two=v_Tex;
		//if(distance(two,one)>0.49&&distance(two,one)<0.5) 하면 둘레 생김
		float d = distance(two,one);
		float width =0.01;
		float radius =0.5;
		//float range=0.2;

		float sTime = u_Points[i].z;
		float lTime = u_Points[i].w;
		float newTime = v_Time - sTime;
		if(newTime>0){
		float t= fract(newTime/lTime);
		float oneminus = 1-t;
		t=t*lTime;
		//점점 어두워짐 생기면서
		float range = t/5;

		float fade= 1/range * clamp(range-d,0,1);
	
		 float gray  =pow(abs(sin(d*2*c_PI*50-t*30)),16)*fade*oneminus;
	
		accum += gray;
		}
	}
	
	FragColor = vec4(accum);

}

void Sin(){
	
	vec2 one=vec2(0.5,0.5);
	vec2 two=v_Tex;
	//if(distance(two,one)>0.49&&distance(two,one)<0.5) 하면 둘레 생김
	float d = sin(v_Tex.y*2*c_PI);
	float width =0.01;
	float radius =0.5;
	if(sin(v_Tex.x*2*c_PI*5)*0.5>v_Tex.y-0.5-0.01&&sin(v_Tex.x*2*c_PI*5)*0.5<v_Tex.y-0.5+0.01)
	FragColor = vec4(1);
	else
	FragColor = vec4(0);
}
void Flag()
{
	float amp = 0.5;	// 증폭
	float speed = 10;    // 속도
	float sinInput = v_Tex.x * c_PI * 2 - v_Time * speed;
	float sinValue = v_Tex.x * amp * (((sin(sinInput) + 1) / 2) - 0.5) + 0.5;	// 사인 곡선을 센터로 이동시키기 위한 계산식
	float fWidth = 0.2;
	float width = 0.5 * mix(1, fWidth, v_Tex.x);// 깃발의 폭
	float grey = 0;
	if(v_Tex.y < sinValue + width / 2 && v_Tex.y > sinValue - width / 2)
	{
		grey = 1;
	}
	else
	{
		grey = 0;
		discard;    // 브랜치
	}
	FragColor = vec4(grey);
}

void Flame()
{
	float amp = 0.5;	// 증폭
	float speed = 10;    // 속도
	float newY = 1 -v_Tex.y;	// y축을 뒤집어서 불꽃이 위로 올라가는 효과
	float sinInput = newY * c_PI * 2 - v_Time * speed;
	float sinValue = newY * amp * (((sin(sinInput) + 1) / 2) - 0.5) + 0.5;	// 사인 곡선을 센터로 이동시키기 위한 계산식
	float fWidth = 0.0;
	float width = 0.5 * mix(fWidth, 1, newY);// 깃발의 폭
	float grey = 0;
	if(v_Tex.x < sinValue + width / 2 && v_Tex.x > sinValue - width / 2)
	{
		grey = 1;
	}
	else
	{
		grey = 0;
		discard;    // 브랜치
	}
	FragColor = vec4(grey);
}
void test(){
	float a;
	vec2 dx =vec2(0.5,0.5);
	
	//if(distance(dx,v_Tex)>0.49&&distance(dx,v_Tex)<0.5)
	//FragColor=vec4(1);
	//else FragColor = vec4(0);

	for(int i=0;i<500;++i){
	vec2 one=u_Points[i].xy;
		vec2 two=v_Tex;
		//if(distance(two,one)>0.49&&distance(two,one)<0.5) 하면 둘레 생김
		float d = distance(two,one);
		float width =0.01;
		float radius =0.5;
		//float range=0.2;

		float sTime = u_Points[i].z;
		float lTime = u_Points[i].w;
		float newTime = v_Time - sTime;
		if(newTime>0){
		float t= fract(newTime/lTime);
		float oneminus = 1-t;
		t=t*lTime;
		//점점 어두워짐 생기면서
		float range = t/5;

		float fade= 1/range * clamp(range-d,0,1);
	
		 float gray  =pow(abs(sin(d*2*c_PI*50-t*30)),16)*fade*oneminus;
		a+=gray;
		}
	}
	FragColor = vec4(a);
}
void main()
{
	Flame();

}
