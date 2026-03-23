#include "stdafx.h"
#include "Renderer.h"
#define ㅇㅅㅇ 1000
default_random_engine dre;
uniform_real_distribution<float>urd{ 0.0,1.0 };
Renderer::Renderer(int windowSizeX, int windowSizeY)
{
	Initialize(windowSizeX, windowSizeY);
}


Renderer::~Renderer()
{
}

void Renderer::Initialize(int windowSizeX, int windowSizeY)
{
	//Set window size
	m_WindowSizeX = windowSizeX;
	m_WindowSizeY = windowSizeY;

	//Load shaders
	m_SolidRectShader = CompileShaders("./Shaders/SolidRect.vs", "./Shaders/SolidRect.fs");
	//Load shaders
	m_TriangleShader = CompileShaders("./Shaders/triangle.vs", "./Shaders/triangle.fs");
	
	//Create VBOs
	CreateVertexBufferObjects();

	if (m_SolidRectShader > 0 && m_VBORect > 0)
	{
		m_Initialized = true;
	}
}

bool Renderer::IsInitialized()
{
	return m_Initialized;
}

//void Renderer::CreateVertexBufferObjects()
//{
//	float rect[]
//		=
//	{
//		-1.f / m_WindowSizeX, -1.f / m_WindowSizeY, 0.f, -1.f / m_WindowSizeX, 1.f / m_WindowSizeY, 0.f, 1.f / m_WindowSizeX, 1.f / m_WindowSizeY, 0.f, //Triangle1
//		-1.f / m_WindowSizeX, -1.f / m_WindowSizeY, 0.f,  1.f / m_WindowSizeX, 1.f / m_WindowSizeY, 0.f, 1.f / m_WindowSizeX, -1.f / m_WindowSizeY, 0.f, //Triangle2
//	};
//
//	glGenBuffers(1, &m_VBORect);
//	glBindBuffer(GL_ARRAY_BUFFER, m_VBORect);
//	glBufferData(GL_ARRAY_BUFFER, sizeof(rect), rect, GL_STATIC_DRAW);
//
//	float centerX = 0;
//	float centerY = 0;
//	float vx = 1;
//	float vy = 1;
//	float size = 0.1;
//	float mass = 1;
//	float triangle[]
//		=
//	{
//		centerX - size/2,centerY - size / 2,0,
//		mass,vx,vy,//v0
//		centerX + size / 2,centerY - size / 2,0,
//		mass,vx,vy,//v1
//		centerX + size / 2,centerY + size / 2,0,
//		mass,vx,vy,//v2
//
//		centerX - size / 2,centerY - size / 2,0,
//		mass,vx,vy,
//		centerX + size / 2,centerY + size / 2,0,
//		mass,vx,vy,
//		centerX - size / 2,centerY + size / 2,0,
//		mass,vx,vy
//	};
//	glGenBuffers(1, &m_TriangleVBO);
//	glBindBuffer(GL_ARRAY_BUFFER, m_TriangleVBO);
//	glBufferData(GL_ARRAY_BUFFER,sizeof(triangle),triangle,GL_STATIC_DRAW);//데이터 올리는건 대부분 동기화가 되야됨 보통은 동기
//}
float velocities[ㅇㅅㅇ * 3]; // 100명분의 (x속도, y속도)
void Renderer::CreateVertexBufferObjects() {
	// 1. 네모 모양 데이터 (기존과 동일)

	float rect[] = {
		-0.05f, -0.05f, 0.0f,  0.05f, -0.05f, 0.0f,  0.05f,  0.05f, 0.0f,
		-0.05f, -0.05f, 0.0f,  0.05f,  0.05f, 0.0f, -0.05f,  0.05f, 0.0f
	};
	glGenBuffers(1, &m_VBORect);
	glBindBuffer(GL_ARRAY_BUFFER, m_VBORect);
	glBufferData(GL_ARRAY_BUFFER, sizeof(rect), rect, GL_STATIC_DRAW); 

		// 2. 100개의 랜덤 속도 데이터 만들기
	for (int i = 0; i < ㅇㅅㅇ; i++) {
		velocities[i * 3] = ((rand() % 200) - 100) / 100.0f; // X속도: -1.0 ~ 1.0 랜덤
		velocities[i * 3 + 1] = (rand() % 100) / 50.0f;       // Y속도: 0.0 ~ 2.0 랜덤
		velocities[i * 3 + 2] = urd(dre);       // Y속도: 0.0 ~ 2.0 랜덤
	}
	for (int i = 0; i < 25; i++) {
		float a = urd(dre);
		/*velocities[i * 3 + 2] = a;
		velocities[i * 3 + 5] = a;
		velocities[i * 3 + 8] = a;
		velocities[i * 3 + 11] = a;*/
	}

	glGenBuffers(1, &m_VelVBO);
	glBindBuffer(GL_ARRAY_BUFFER, m_VelVBO);
	glBufferData(GL_ARRAY_BUFFER, sizeof(velocities), velocities, GL_STATIC_DRAW);
}

void Renderer::AddShader(GLuint ShaderProgram, const char* pShaderText, GLenum ShaderType)
{
	//쉐이더 오브젝트 생성
	GLuint ShaderObj = glCreateShader(ShaderType);

	if (ShaderObj == 0) {
		fprintf(stderr, "Error creating shader type %d\n", ShaderType);
	}

	const GLchar* p[1];
	p[0] = pShaderText;
	GLint Lengths[1];
	Lengths[0] = strlen(pShaderText);
	//쉐이더 코드를 쉐이더 오브젝트에 할당
	glShaderSource(ShaderObj, 1, p, Lengths);

	//할당된 쉐이더 코드를 컴파일
	glCompileShader(ShaderObj);

	GLint success;
	// ShaderObj 가 성공적으로 컴파일 되었는지 확인
	glGetShaderiv(ShaderObj, GL_COMPILE_STATUS, &success);
	if (!success) {
		GLchar InfoLog[1024];

		//OpenGL 의 shader log 데이터를 가져옴
		glGetShaderInfoLog(ShaderObj, 1024, NULL, InfoLog);
		fprintf(stderr, "Error compiling shader type %d: '%s'\n", ShaderType, InfoLog);
		printf("%s \n", pShaderText);
	}

	// ShaderProgram 에 attach!!
	glAttachShader(ShaderProgram, ShaderObj);
}

bool Renderer::ReadFile(char* filename, std::string *target)
{
	std::ifstream file(filename);
	if (file.fail())
	{
		std::cout << filename << " file loading failed.. \n";
		file.close();
		return false;
	}
	std::string line;
	while (getline(file, line)) {
		target->append(line.c_str());
		target->append("\n");
	}
	return true;
}

GLuint Renderer::CompileShaders(char* filenameVS, char* filenameFS)
{
	GLuint ShaderProgram = glCreateProgram(); //빈 쉐이더 프로그램 생성

	if (ShaderProgram == 0) { //쉐이더 프로그램이 만들어졌는지 확인
		fprintf(stderr, "Error creating shader program\n");
	}

	std::string vs, fs;

	//shader.vs 가 vs 안으로 로딩됨
	if (!ReadFile(filenameVS, &vs)) {
		printf("Error compiling vertex shader\n");
		return -1;
	};

	//shader.fs 가 fs 안으로 로딩됨
	if (!ReadFile(filenameFS, &fs)) {
		printf("Error compiling fragment shader\n");
		return -1;
	};

	// ShaderProgram 에 vs.c_str() 버텍스 쉐이더를 컴파일한 결과를 attach함
	AddShader(ShaderProgram, vs.c_str(), GL_VERTEX_SHADER);

	// ShaderProgram 에 fs.c_str() 프레그먼트 쉐이더를 컴파일한 결과를 attach함
	AddShader(ShaderProgram, fs.c_str(), GL_FRAGMENT_SHADER);

	GLint Success = 0;
	GLchar ErrorLog[1024] = { 0 };

	//Attach 완료된 shaderProgram 을 링킹함
	glLinkProgram(ShaderProgram);

	//링크가 성공했는지 확인
	glGetProgramiv(ShaderProgram, GL_LINK_STATUS, &Success);

	if (Success == 0) {
		// shader program 로그를 받아옴
		glGetProgramInfoLog(ShaderProgram, sizeof(ErrorLog), NULL, ErrorLog);
		std::cout << filenameVS << ", " << filenameFS << " Error linking shader program\n" << ErrorLog;
		return -1;
	}

	glValidateProgram(ShaderProgram);
	glGetProgramiv(ShaderProgram, GL_VALIDATE_STATUS, &Success);
	if (!Success) {
		glGetProgramInfoLog(ShaderProgram, sizeof(ErrorLog), NULL, ErrorLog);
		std::cout << filenameVS << ", " << filenameFS << " Error validating shader program\n" << ErrorLog;
		return -1;
	}

	glUseProgram(ShaderProgram);
	std::cout << filenameVS << ", " << filenameFS << " Shader compiling is done.";

	return ShaderProgram;
}
float gTime = 0;
//void Renderer::DrawTriangle()
//{
//
//	gTime += 0.01f;
//	//Program select
//	glUseProgram(m_TriangleShader);
//
//	int uTime = glGetUniformLocation(m_TriangleShader,
//		"u_Time");
//	glUniform1f(uTime, gTime);
//
//	int attribPosition = glGetAttribLocation(m_TriangleShader, "a_Position");
//	int attribMass = glGetAttribLocation(m_TriangleShader, "a_Mass");
//	int attribVel = glGetAttribLocation(m_TriangleShader, "a_Vel");
//
//	glEnableVertexAttribArray(attribPosition);
//	glEnableVertexAttribArray(attribMass);
//	glEnableVertexAttribArray(attribVel);
//	
//	glBindBuffer(GL_ARRAY_BUFFER, m_TriangleVBO);
//	glVertexAttribPointer(attribPosition, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), 0);//뒤에 두자리중 왼쪽것은 스트라이드임
//
//	glBindBuffer(GL_ARRAY_BUFFER, m_TriangleVBO);
//	glVertexAttribPointer(attribMass, 1, GL_FLOAT, GL_FALSE, 6*sizeof(float), (GLvoid*)(sizeof(float)*3));//뒤에 두자리중 왼쪽것은 스트라이드임
//	//4개씩 넘어가야 새로운게 나오므로 4*sizeof(float)를함
//	//두번째는 몇개씩 읽을지
//	glBindBuffer(GL_ARRAY_BUFFER, m_TriangleVBO);
//	glVertexAttribPointer(attribVel, 2, GL_FLOAT, GL_FALSE,6 * sizeof(float), (GLvoid*)(sizeof(float) * 4));
//
//	glDrawArrays(GL_TRIANGLES, 0, 6);
//
//}
void Renderer::DrawTriangle() {
	gTime += 0.03f;
	//Program select
	glUseProgram(m_TriangleShader);// 2. 랜덤 속도 연결 (a_Vel)
	int uTime = glGetUniformLocation(m_TriangleShader,"u_Time");
	glUniform1f(uTime, gTime);

	

		// 1. 모양 연결 (a_Position)
		int posLoc = glGetAttribLocation(m_TriangleShader, "a_Position");
	glEnableVertexAttribArray(posLoc);
	glBindBuffer(GL_ARRAY_BUFFER, m_VBORect);
	glVertexAttribPointer(posLoc, 3, GL_FLOAT, GL_FALSE, 0, 0);

	// 2. 랜덤 속도 연결 (a_Vel)
	int velLoc = glGetAttribLocation(m_TriangleShader, "a_Vel");
	glEnableVertexAttribArray(velLoc);
	glBindBuffer(GL_ARRAY_BUFFER, m_VelVBO);
	glVertexAttribPointer(velLoc, 3, GL_FLOAT, GL_FALSE, 0, 0);

	// 이 함수가 핵심! "속도 데이터는 네모 1개(인스턴스)마다 다음 칸으로 넘어가라"는 뜻입니다.
	glVertexAttribDivisor(velLoc, 1);

	// 3. 100개 그리기 명령
	glDrawArraysInstanced(GL_TRIANGLES, 0, 6, ㅇㅅㅇ);
}

void Renderer::GetGLPosition(float x, float y, float *newX, float *newY)
{
	*newX = x * 2.f / m_WindowSizeX;
	*newY = y * 2.f / m_WindowSizeY;
}