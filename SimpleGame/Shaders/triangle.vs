#version 330
//mod(a,b) a를 b로 나눈 나머지
//sin(t * 3.141592 * 2.0) 라디안 * 파이/2
//gl_Position GL 내부에서 정한 출력 변수
in vec3 a_Position;
in float a_Mass;
in vec2 a_Vel;

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

void main(){
	gravity();

}
