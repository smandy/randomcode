import std.stdio;
private import derelict.sdl2.sdl;
private import derelict.opengl3.gl;

import std.math;

pragma(lib, "DerelictUtil.lib");
pragma(lib, "DerelictSDL2.lib");
pragma(lib, "DerelictGL.lib");

int w=800, h=600;
int flags=SDL_WINDOW_OPENGL | SDL_WINDOW_BORDERLESS | SDL_WINDOW_SHOWN;
SDL_Window *win;
SDL_GLContext context;


struct Mousey {
  const float PI      = 3.14159;
  const float HALF_PI = PI / 2.0;
  const float DEGREE  = PI / 180.0;

  float direction;

  float x;
  float y;

  this(float x_, float y_, float direction_ = 0.0f ) {
    x = x_;
    y = y_;
    direction = direction_;
  }

  void move( float l ) {
    x += l * cos(direction);
    y += l * sin(direction);
  };

  void turn( float angle) {
    direction += angle;
  };

  float getX() { return x; };
  float getY() { return y; };
};


void drawScene(float degreeOffset,float lengthFraction) {
  //Clear information from last draw
  writefln("draw Scene");
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  glMatrixMode(GL_MODELVIEW); //Switch to the drawing perspective
  glLoadIdentity(); //Reset the drawing perspective

  glBegin( GL_LINE_STRIP );
  glVertex3f( -1.0f, -1.0f, -5.0f);
  glVertex3f(  1.0f, -1.0f, -5.0f);
  glVertex3f(  1.0f,  1.0f, -5.0f);
  glVertex3f( -1.0f,  1.0f, -5.0f);
  glVertex3f( -1.0f, -1.0f, -5.0f);
      
  glEnd();
  glBegin( GL_LINE_STRIP );
  drawVortex(degreeOffset, lengthFraction);
  glEnd();

  //cout << "Drawing scene " << endl;
  //glBindVertexArray(0);
  //glUseProgram(0);
     
  SDL_GL_SwapWindow(win); //Send the 3D scene to the screen
}

void drawVortex(float degreeOffset, float lengthFraction) {
  float l = 2.0;
  auto m = Mousey(-1.0f, -1.0f, 0.0f);
  while( l > 0.05 ) {
    //writeln( " mousey loop");
    glVertex3f( m.getX(), m.getY(), -3.0f);
    m.move( l );
    m.turn( Mousey.HALF_PI + degreeOffset * Mousey.DEGREE);
    l *= lengthFraction;
  };
};


void main() {
  writefln("Loading SDL");
  DerelictSDL2.load();
  writefln("Loading GL");
  DerelictGL.load();

  if ( SDL_Init( SDL_INIT_VIDEO ) < 0 ) {
    writefln("It didn't work");
  };
  writefln("It worked");
  SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 2);
  SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 2);
  SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
  SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 8);
  
  writefln("It worked");
  win=SDL_CreateWindow("3Doodle", SDL_WINDOWPOS_CENTERED,
		       SDL_WINDOWPOS_CENTERED, w, h, flags);
  context = SDL_GL_CreateContext(win);

  SDL_GL_SetSwapInterval(1);
	
  glClearColor(0.0, 0.0, 0.0, 1.0);
  glViewport(0, 0, w, h);


  writefln("Woohoo");
  if(!win){
    writefln("Error creating SDL window");
    SDL_Quit();
    return;
  }
  
  context=SDL_GL_CreateContext(win);
  //SDL_GL_SetSwapInterval(1);
  
  glViewport(0, 0, w,h);
  glClearColor(0.0f, 0.0f, 0.0f, 0.0f);		// This Will Clear The Background Color To Black
  glClearDepth(1.0);				// Enables Clearing Of The Depth Buffer
  glDepthFunc(GL_LESS);				// The Type Of Depth Test To Do
  glEnable(GL_DEPTH_TEST);			// Enables Depth Testing
  glShadeModel(GL_SMOOTH);			// Enables Smooth Color Shading

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();				// Reset The Projection Matrix
  glMatrixMode(GL_MODELVIEW);
  
  bool done = false;
  float degreeOffset = 2.0f;
  float lengthFraction = 0.98;

  while (!done) {
    writefln("Main loop");
    SDL_Event event;
    //cout << event.type << endl;

    glClear(GL_COLOR_BUFFER_BIT);

    drawScene( degreeOffset, lengthFraction);
    SDL_WaitEvent(&event);
  };
     DerelictGL.reload();

     return;
};