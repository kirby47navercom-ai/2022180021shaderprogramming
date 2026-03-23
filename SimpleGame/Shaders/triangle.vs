#version 330
//mod(a,b) a를 b로 나눈 나머지
//sin(t * 3.141592 * 2.0) 라디안 * 파이/2
//gl_Position GL 내부에서 정한 출력 변수
in vec3 a_Position;
in float a_Mass;
in vec3 a_Vel;

const float c_PI = 3.141592;
const vec2 c_G = vec2(0,-9.8);

uniform vec4 u_Trans;
uniform float u_Time;


void Basic()
{
	float t = mod(u_Time*10,1.0f); //0~1
	vec4 newPosition;
	newPosition.x = a_Position.x+t;
	newPosition.y = a_Position.y + sin(t * 3.141592 * 2.0);
	newPosition.z = a_Position.z;
	gl_Position = newPosition;
	
}
void Sin2()
{
	float t = mod(u_Time*10,2.0f); //0~1
	vec4 newPosition;
	newPosition.x = a_Position.x+t-1.f;
	newPosition.y = a_Position.y + sin(t * 3.141592 * 1.0)*0.5f;
	newPosition.z = a_Position.z;
	gl_Position = newPosition;
	
}
void Sin3()
{
	float t = mod(u_Time*10,2.0f); //0~1
	vec4 newPosition;
	newPosition.x = a_Position.x+t-1.f;
	newPosition.y = a_Position.y + sin(t * 3.141592 * 2.0)*0.5f;
	newPosition.z = a_Position.z;
	gl_Position = newPosition;
	
}
void Sin4()
{
	float t = mod(u_Time*10,2.0f); //0~1
	vec4 newPosition;
	newPosition.x = a_Position.x + cos(t * 3.141592 * 2.0)*0.5;
	newPosition.y = a_Position.y + sin(t * 3.141592 * 2.0)*0.5;
	newPosition.z = a_Position.z;
	gl_Position = newPosition;
	
}
void Sin5()
{
	// 1. 시간 흐름 만들기 (하트를 그리는 속도)
    float t = u_Time * 10.0;

    // 2. 하트 모양을 그리는 마법의 수학 공식! (위치 계산)
    // X축: sin을 세 번 곱해서 하트의 볼록한 윗부분과 뾰족한 아래쪽을 만듭니다.
    float x = 16.0 * sin(t) * sin(t) * sin(t);
    
    // Y축: cos 여러 개를 섞어서 하트 특유의 굴곡을 섬세하게 깎아냅니다.
    float y = 13.0 * cos(t) - 5.0 * cos(2.0 * t) - 2.0 * cos(3.0 * t) - cos(4.0 * t);

    // 3. 도화지에 들어가도록 크기 줄이기
    // 공식대로 그리면 너무 거대해서 화면 밖으로 나가버려요. 0.04를 곱해서 작게 만듭니다.
    float scale = 0.04;

    // 4. 두근두근 심장 박동 효과 넣기!
    // 시간에 따라 1.0을 기준으로 크기가 아주 살짝 커졌다 작아졌다 반복하게 합니다.
    float heartbeat = 1.0 + 0.15 * sin(u_Time * 8.0);

    // 5. 원래 꼭짓점 위치에 하트 궤적(x, y)과 박동(heartbeat)을 곱해서 더해줍니다.
    vec4 newPosition = vec4(a_Position, 1.0);
    newPosition.x = a_Position.x + (x * scale * heartbeat);
    
    // 하트가 화면 한가운데 오도록 Y축으로 아주 살짝(0.1) 올려줍니다.
    newPosition.y = a_Position.y + (y * scale * heartbeat) + 0.1; 
    newPosition.z = a_Position.z;

    // 6. 완성된 위치 전달!
    gl_Position = newPosition;
	
}

//시험에 나올 수 도 잇음
void Falling(){
	float t =mod(u_Time,1.0);
	float tt = t*t;
	float vx = a_Vel.x;
	float vy = a_Vel.y;
	float initPosX=a_Position.x+cos(vx*c_PI*2);
	float initPosY=a_Position.y+sin(vy*c_PI*2);
	vec4 newPos;
	newPos.x=initPosX;
	newPos.y=initPosY+ vy*t+ tt*c_G.y*0.5;
	newPos.z=0;
	newPos.w=1;
	gl_Position = newPos;

}
void Falling2(){
float t =mod(u_Time,1.0);
	float tt = t*t;
	float vx = a_Vel.x;
	float vy = a_Vel.y;
	vec4 newPos;
	newPos.x=a_Position.x+ vx*t+ tt*c_G.x*0.5;
	newPos.y=a_Position.y+ vy*t+ tt*c_G.y*0.5;
	newPos.z=0;
	newPos.w=1;
	gl_Position = newPos;

}

//시험 만약 initPosX initPosY를 주고 원 주위로 내려오라고 할때
void gravity(){
	// 각 네모마다 속도가 다르므로, 바닥에 닿는 시간도 다르게 보이게 합니다.
    // mod를 사용해 0~2초 사이를 무한 반복하게 설정
    float t = mod(u_Time + a_Vel.x * 10.0, 2.0); 
	float vx = a_Vel.x;
	float vy = a_Vel.y;
    float initPosX=a_Position.x+cos(vx*c_PI*2);
	float initPosY=a_Position.y+sin(vx*c_PI*2);
    vec4 newPos;
    // X축: 처음 위치 + 속도 * 시간
    newPos.x =initPosX;
    // Y축: 처음 위치 + 속도 * 시간 + (1/2 * 중력 * 시간^2)
    newPos.y = initPosY + a_Vel.y * t + 0.5 * c_G.y * t * t;
    newPos.z = 0.0;
    newPos.w = 1.0;

    gl_Position = newPos;
}
void Falling3(){
	float newTime = u_Time-a_Vel.x;
	
	if(newTime>0){
	float t = mod(newTime , 2.0); 
	float vx = a_Vel.x;
	float vy = a_Vel.y;
    float initPosX=a_Position.x+cos(vx*c_PI*2);
	float initPosY=a_Position.y+sin(vx*c_PI*2);
    vec4 newPos;
    // X축: 처음 위치 + 속도 * 시간
    newPos.x =initPosX;
    // Y축: 처음 위치 + 속도 * 시간 + (1/2 * 중력 * 시간^2)
    newPos.y = initPosY + a_Vel.y * t + 0.5 * c_G.y * t * t;
    newPos.z = 0.0;
    newPos.w = 1.0;
	gl_Position = newPos;
	}
	else{
	gl_Position=vec4(-100,-100,0,1);
	}

    
}

float pseudoRandom(float n){
	return fract(sin(n)*43758.5453123);
}
void Falling4(){
	float newTime = u_Time-a_Vel.z;
	float scale = a_Vel.z;
	if(newTime>0){
	float t = mod(newTime , 1.0); 
	float vx = a_Vel.x;
	float vy = a_Vel.y;
    float initPosX=a_Position.x*a_Vel.z+cos(vx*c_PI*2);
	float initPosY=a_Position.y*a_Vel.z+sin(vx*c_PI*2);
    vec4 newPos;
    // X축: 처음 위치 + 속도 * 시간
    newPos.x =initPosX;
    // Y축: 처음 위치 + 속도 * 시간 + (1/2 * 중력 * 시간^2)
    newPos.y = initPosY + 0.5 * c_G.y * t * t;
    newPos.z = 0.0;
    newPos.w = 1.0;
	gl_Position = newPos;
	}
	else{
	gl_Position=vec4(-100,-100,0,1);
	}

    
}
void GalaxySupernova() {
    // 1. 우주의 시간 (빅뱅과 블랙홀 흡수를 반복하는 주기)
    // 0~2.0 사이를 반복하며, 폭발과 수축의 기준이 됩니다.
    float t = mod(u_Time * 0.3, 2.0); 

    // 2. 파티클 고유의 위치 세팅 (a_Vel을 활용한 랜덤 분포)
    // a_Vel.x (-1.0 ~ 1.0)를 이용해 360도(4파이) 무작위 각도 배정
    float angle = a_Vel.x * c_PI * 4.0; 
    
    // a_Vel.z (0.0 ~ 1.0)를 이용해 중심으로부터의 무작위 거리 배정
    float radius = a_Vel.z * 1.8;       

    // 3. 소용돌이 마법 (안쪽에 있는 별일수록 더 빨리 돕니다!)
    // 거리가 가까울수록 회전 속도가 기하급수적으로 빨라집니다.
    float swirl = angle + u_Time * (2.0 / (radius + 0.2));

    // 4. 빅뱅과 블랙홀 마법 (sin 함수로 부드러운 팽창과 수축)
    // t가 1.0일 때 가장 크게 팽창하고, 0.0이나 2.0일 때 한 점으로 모입니다.
    float expansion = sin(t * c_PI);

    // 5. 최종 위치 계산 (원운동 공식 적용)
    // a_Vel.y를 곱해줘서 별들마다 퍼져나가는 궤도 크기를 다르게 만듭니다.
    float currentRadius = radius * expansion * (a_Vel.y + 0.5);
    float posX = cos(swirl) * currentRadius;
    float posY = sin(swirl) * currentRadius;

    // 6. 네모 크기 조절 (멀리 날아갈수록, 팽창할수록 크기가 커집니다)
    float scale = a_Vel.z * expansion * 0.8;

    vec4 newPos;
    // a_Position에 스케일을 곱해 네모 크기를 정하고, 소용돌이 위치를 더합니다.
    newPos.x = (a_Position.x * scale) + posX;
    newPos.y = (a_Position.y * scale) + posY;
    newPos.z = 0.0;
    newPos.w = 1.0;

    gl_Position = newPos;
}
void main(){
	GalaxySupernova();

}
