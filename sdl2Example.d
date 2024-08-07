
private import derelict.sdl2.sdl;
private import derelict.opengl3.gl;

import std.stdio;
import std.math;

pragma(lib, "DerelictUtil.lib");
pragma(lib, "DerelictSDL2.lib");
pragma(lib, "DerelictGL3.lib");


/* A simple function that prints a message, the error code returned by SDL,
 *  * and quits the application */
void sdldie(const char *msg)
{
    writefln("%s: %s", msg, SDL_GetError());
    SDL_Quit();
}

  const float PI      = 3.14159;
  const float HALF_PI = PI / 2.0;
  const float DEGREE  = PI / 180.0;
const float PI_OVER_360 = PI / 360;

void BuildPerspProjMat(float *m, float fov, float aspect, 
float znear, float zfar)
{
  //auto ret = malloc( 16 * sizeof(float) );

  float xymax = znear * tan(fov * PI_OVER_360);
  float ymin = -xymax;
  float xmin = -xymax;

  float width = xymax - xmin;
  float height = xymax - ymin;

  float depth = zfar - znear;
  float q = -(zfar + znear) / depth;
  float qn = -2 * (zfar * znear) / depth;

  float w = 2 * znear / width;
  w = w / aspect;
  float h = 2 * znear / height;

  m[0]  = w;
  m[1]  = 0;
  m[2]  = 0;
  m[3]  = 0;

  m[4]  = 0;
  m[5]  = h;
  m[6]  = 0;
  m[7]  = 0;

  m[8]  = 0;
  m[9]  = 0;
  m[10] = q;
  m[11] = -1;

  m[12] = 0;
  m[13] = 0;
  m[14] = qn;
  m[15] = 0;

}
 
void checkSDLError(int line = -1)
{
	const char *error = SDL_GetError();
	if (*error != '\0')
	{
		writefln("SDL Error: %s\n", error);
		if (line != -1)
			writefln(" + line: %s\n", line);
		SDL_ClearError();
	}
}

    SDL_Window *mainwindow; /* Our window handle */
    SDL_GLContext maincontext; /* Our opengl context handle */


void doAndyStuff() {
  writefln("Woohoo");
  glMatrixMode(GL_MODELVIEW); //Switch to the drawing perspective
  glLoadIdentity(); //Reset the drawing perspective

  glColor3f(1.0f, 0.5f, 0.5f);

   glTranslatef(-1.5f,0.0f,-6.0f);               // Move Left 1.5 Units And Into The Screen 6.0

   glBegin(GL_TRIANGLES);                  // Drawing Using Triangles
      glVertex3f( 0.0f, 1.0f, 0.0f);            // Top
      glVertex3f(-1.0f,-1.0f, 0.0f);            // Bottom Left
      glVertex3f( 1.0f,-1.0f, 0.0f);            // Bottom Right
   glEnd();


  glBegin( GL_LINE_STRIP );
  glVertex3f( -1.0f, -1.0f, -5.0f);
  glVertex3f(  1.0f, -1.0f, -5.0f);
  glVertex3f(  1.0f,  1.0f, -5.0f);
  glVertex3f( -1.0f,  1.0f, -5.0f);
  glVertex3f( -1.0f, -1.0f, -5.0f);
  glEnd();
};

 
/* Our program's entry point */
void  main()
{
  writefln("Fo far so good");
  writefln("Loading SDL");
  DerelictSDL2.load();
  writefln("Loading GL3");
  DerelictGL.load();
  
 
    if (SDL_Init(SDL_INIT_VIDEO) < 0) /* Initialize SDL's Video subsystem */
        sdldie("Unable to initialize SDL"); /* Or die on error */
 
    /* Request opengl 3.2 context.
 *      * SDL doesn't have the ability to choose which profile at this time of writing,
 *           * but it should default to the core profile */
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 2);
  writefln("Go good");
 
    /* Turn on double buffering with a 24bit Z buffer.
 *      * You may need to change this to 16 or 32 for your system */
    SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
    SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);
 
    /* Create our window centered at 512x512 resolution */
    mainwindow = SDL_CreateWindow("Foobar", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
        512, 512, SDL_WINDOW_OPENGL | SDL_WINDOW_SHOWN);
    if (!mainwindow) /* Die if creation failed */
        sdldie("Unable to create window");
 
    checkSDLError(__LINE__);
 
    /* Create our opengl context and attach it to our window */
    maincontext = SDL_GL_CreateContext(mainwindow);
    checkSDLError(__LINE__);
 
 
    /* This makes our buffer swap syncronized with the monitor's vertical refresh */
    SDL_GL_SetSwapInterval(1);
 
    /* Clear our buffer with a red background */
    glClearColor ( 1.0, 0.0, 0.0, 1.0 );
    glClear ( GL_COLOR_BUFFER_BIT );
    /* Swap our back buffer to the front */
    SDL_GL_SwapWindow(mainwindow);


    doAndyStuff();

    /* Wait 2 seconds */
    SDL_Delay(2000);
 
    /* Same as above, but green */
    glClearColor ( 0.0, 1.0, 0.0, 1.0 );
    glClear ( GL_COLOR_BUFFER_BIT );
    SDL_GL_SwapWindow(mainwindow);
    SDL_Delay(2000);
 
    /* Same as above, but blue */
    glClearColor ( 0.0, 0.0, 1.0, 1.0 );
    glClear ( GL_COLOR_BUFFER_BIT );
    SDL_GL_SwapWindow(mainwindow);
    SDL_Delay(2000);
 
    /* Delete our opengl context, destroy our window, and shutdown SDL */
    SDL_GL_DeleteContext(maincontext);
    SDL_DestroyWindow(mainwindow);
    SDL_Quit();
    return;
}

