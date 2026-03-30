#version 330

uniform float u_Time;

//in vec3 a_Position;
//in float a_Mass;
//in vec2 a_Vel;
//in float a_RV;
//in float a_RV1;

layout(location = 0) in vec4 a_PosMass; 
layout(location = 1) in vec4 a_VelRV;
in float a_RV2;

vec3 a_Position = a_PosMass.xyz;
float a_Mass = a_PosMass.w;
vec2 a_Vel = a_VelRV.xy;
float a_RV = a_VelRV.z;
float a_RV1 = a_VelRV.w;

const float c_PI = 3.141592; 
const vec2 c_G = vec2(0, -9.8);

out float v_Grey;


void sin1() // ai�� ������µ� �� �ȵ��� ai �˸�û��;;
{
    float movement = mod(u_Time, 2.0); 

    vec4 newPosition = vec4(a_Position, 1.0);
    newPosition.x += movement;

    if (newPosition.x > 1.0) {
        newPosition.x -= 2.0;
    }

    newPosition.y += sin(u_Time * 5.0) * 0.5;

    gl_Position = newPosition;
}

void Basic()
{
    float t = mod(u_Time*10, 1.0);

	vec4 newPosition;
	newPosition = vec4(a_Position, 1);
	newPosition += vec4(-1 + t*2, 0.5*sin(t*2*3.141592), 0, 0);

	gl_Position = newPosition;
}

void circle()
{
    float t = mod(u_Time*10, 1.0);

    vec4 newPosition;
	newPosition.x = a_Position.x + cos(t*2*3.14)*0.5;
    newPosition.y = a_Position.y + sin(t*2*3.14)*0.5;
    newPosition.z = a_Position.z;
    newPosition.w = 1.0;

	gl_Position = newPosition;
}

void sangsang()
{
   float speed = u_Time * 10.0;
    float progress = mod(speed, 1.0);

    // 1. ���� �밢�� ��� (���� �� -> ������ �Ʒ�)
    vec2 startPos = vec2(-0.8, 0.8);
    vec2 endPos = vec2(0.8, -0.8);
    vec2 mainPath = mix(startPos, endPos, progress);

    // 2. �밢���� ������ ���� ���
    // �밢�� ������ (1, -1)�̹Ƿ�, ���� ������ (1, 1)�� �˴ϴ�.
    vec2 perpendicularDir = vec2(1.0, 1.0);

    // 3. ���� ���� ������� (���� �պ�)
    float zigzagSpeed = 50.0;
    float zigzagWidth = 0.3;
    float offset = sin(speed * zigzagSpeed) * zigzagWidth;

    // 4. ���� ��ġ: ���� ��� + ���� �պ� ������
    vec4 newPosition;
    newPosition.xy = mainPath + (perpendicularDir * offset);
    newPosition.z = a_Position.z;
    newPosition.w = 1.0;

    // ���� ������ �⺻ ��ġ(a_Position)�� ���� ������ ���� ����
    gl_Position = vec4(newPosition.xy + a_Position.xy, newPosition.z, 1.0);
}

void sangsang2(){
// ��ü ���� �ֱ� ����
    float speed = u_Time * 10.0;
    float progress = mod(speed, 1.0);

    // 1. X�� �̵�: ����(-0.8)���� ������(0.8)���� �����ϰ� ����
    float currentX = mix(-0.8, 0.8, progress);

    // 2. Y�� �̵�: �߷� �� ź�� ȿ��
    // mod�� �̿��� ƨ��� �ֱ⸦ ����ϴ� (��: �� �� �������� ���� 4�� ƨ��)
    float bounceCount = 3.0;
    float bounceProgress = mod(progress * bounceCount, 1.0);
    
    // ������ ����: y = 4 * height * t * (1 - t) 
    // �� ���� ����� abs�� Ȱ���ϸ� ƨ��� ����� ���ɴϴ�.
    float height = 0.6;
    float bounceY = 4.0 * height * bounceProgress * (1.0 - bounceProgress);
    
    // ��ü���� �ϰ� � + ƨ��� ���� ����
    // ��(0.8)���� �Ʒ�(-0.8)�� �������� �⺻ �࿡ bounceY�� ����
    float baseLineY = mix(0.5, -0.8, progress);
    float currentY = baseLineY + bounceY;

    vec4 newPosition;
    newPosition.x = a_Position.x + currentX;
    newPosition.y = a_Position.y + currentY;
    newPosition.z = a_Position.z;
    newPosition.w = 1.0;

    gl_Position = newPosition;
}

float pseudoRandom(float n){
    return fract(sin(n) * 43758.5453123);
}

//void falling()
//{
//    float newTime = u_Time - a_RV1;
//    if(newTime > 0){
//        float t =  mod(newTime, 1.0);
//        float tt = t*t;
//        float vx = a_Vel.x;
//        float vy = a_Vel.y;
//        float initPosX = a_Position.x + cos(a_RV * c_PI) * 0.7;
//        float initPosY = a_Position.y + sin(a_RV * c_PI) * 0.7;
//
//        vec4 newPos;
//        newPos.x = initPosX + vx * t + 0.5 * c_G.x * tt;
//        newPos.y = initPosY + vy * t + 0.5 * c_G.y * tt;
//        newPos.z = 0;
//        newPos.w = 1;
//
//        gl_Position = newPos;
//    }
//    else {
//        gl_Position = vec4(-2.0, -2.0, 0.0, 1.0); // ȭ�� ������ ����
//    }
//}

void falling()
{
    float newTime = u_Time - a_RV1*3; 
    if(newTime > 0){ 
        float lifeTime = a_RV2 + 0.5;
        //float scale = pseudoRandom(a_RV1);
        float t = mod(newTime, lifeTime)/lifeTime; 
        float tt = t * t; 
        float scale = lifeTime - t;
        
        float initPosX = a_Position.x * scale + cos(a_RV * c_PI) * 0.7; 
        float initPosY = a_Position.y * scale + sin(a_RV * c_PI) * 0.7; 

        vec4 newPos;
        //newPos.x = initPosX + a_Vel.x * t + 0.5 * c_G.x * tt; 
        newPos.x = initPosX; 
        newPos.y = initPosY + a_Vel.y * t + 0.5 * c_G.y * tt; 
        newPos.z = 0;
        newPos.w = 1;
        gl_Position = newPos; 
    }
    else {
        gl_Position = vec4(-2.0, -2.0, 0.0, 1.0);
    }
}

void Thrust()
{
    float newTime = u_Time - a_RV1;
    if(newTime >0){
        float t = mod(newTime, 1.0);
        float ampScale = 0.5-t*0.5;
        float amp = (a_RV-0.5)*2;
        float period = pseudoRandom(a_RV2);
        float sizeScale = t*2;

	    vec4 newPosition;
	    newPosition.x = a_Position.x * sizeScale - 1 + 2 * t;
        newPosition.y = a_Position.y * sizeScale + amp * ampScale * sin(t*2*period*c_PI);
        newPosition.z = a_Position.z;
        newPosition.w = 1.0;
        gl_Position = newPosition;
        v_Grey = 1-t;
    }
    else{
        gl_Position = vec4(10000);
    }
}
void space()
// 우주최강 양현빈 전용 빅뱅 마법! (새 변수 추가 절대 없음)

{
    // 1. 기존 변수 u_Time과 랜덤 변수 a_RV를 재활용해 파티클마다 다른 폭발 타이밍 생성
    float t = mod(u_Time * 0.5 + a_RV, 2.0); 
    
    // 2. c_PI를 이용해 0에서 커졌다가 다시 0으로 줄어드는 팽창 효과 (빅뱅)
    float expansion = sin(t * c_PI); 

    // 3. 기존 랜덤 변수 a_RV1과 a_RV2를 '각도'와 '반지름'으로 취급하는 마법! 
    // 안쪽에 있을수록(a_RV2가 작을수록) 빛의 속도로 미친 듯이 회전합니다.
    float angle = a_RV1 * c_PI * 10.0 + u_Time * (3.0 / (a_RV2 + 0.1));
    float radius = a_RV2 * 1.5 * expansion;

    // 4. 기존 a_Position을 변형시켜 우주 소용돌이 위치 지정 [cite: 3]
    vec4 newPosition = vec4(a_Position, 1.0);
    newPosition.x = (a_Position.x * expansion) + cos(angle) * radius;
    newPosition.y = (a_Position.y * expansion) + sin(angle) * radius;
    newPosition.z = a_Position.z;
    
    gl_Position = newPosition;

    // 5. 핵심 트릭: 기존 회색조 변수 v_Grey에 '팽창도(0~1)'를 담아서 몰래 넘깁니다! ]
    v_Grey = expansion;

}
void main()
{
	space();
}