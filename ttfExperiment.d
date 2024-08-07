import std.stdio;

private import derelict.sdl.sdl;
private import derelict.opengl.gl;
private import derelict.opengl.glu;
private import derelict.sdl.ttf;;


import std.math;
import std.string;

pragma(lib, "DerelictUtil.lib");
pragma(lib, "DerelictSDL.lib");
pragma(lib, "DerelictGL.lib");
pragma(lib, "DerelictGLU.lib");
pragma(lib, "DerelictSDLttf.lib");

const int Width=800, Height=600;
SDL_Surface *screen;

void drawScene(float degreeOffset,float lengthFraction) {
  static bool havePrinted = false;
  static int i = 0L;
  static TTF_Font* font  = null;
  static SDL_Rect myRect;

  if (font==null) {
    font = TTF_OpenFont("/usr/share/fonts/truetype/liberation/LiberationMono-Regular.ttf", 14);
  };
  auto col  = SDL_MapRGB(screen.format, 0 ,0   ,0);
  auto col2 = SDL_MapRGB(screen.format, 0 ,255 ,255);
  auto col3 = SDL_MapRGB(screen.format, 0 ,255 ,0);

  //SDL_Color col3 = { 0, 255, 255 };
  SDL_FillRect(screen,null,col);
  static char buf[30];
  const char *fmt = "i is %d";
  
  //writefln("Font is %s", font);
  SDL_Color foregroundColor = { 255, 255, 255 }; 
  SDL_Color backgroundColor = { 0, 0, 255 };

  SDL_Color cyan  = { 0 , 255, 255 };
  SDL_Color green = { 0 , 255, 0   };

  SDL_Surface* textSurface = TTF_RenderText_Solid(font, "This is mytext.", foregroundColor);
  auto h0 = textSurface.h;
  auto w = textSurface.w * 2;
  
  //auto w = textSurface.w;
  SDL_BlitSurface(textSurface,null,screen,null);
  SDL_FreeSurface(textSurface);

  void doPrint(string s) {
    if (!havePrinted) {
      writefln(s);
    };
  };
  
  auto h = h0;
  for (int j = i+40;i<j;++i) {
    //writefln("Calling printf");
    sprintf( buf.ptr, fmt, i);
    //writefln("called");
    auto surf2 = TTF_RenderText_Solid(font, buf.ptr, cyan);
    scope(exit) {
      SDL_FreeSurface( surf2);
    };
    myRect.x = cast(short)  0;
    myRect.y = cast(short)  h;
    myRect.w = cast(ushort) surf2.w;
    myRect.h = cast(ushort) surf2.h;
    h += surf2.h;
    SDL_BlitSurface( surf2, null, screen,&myRect);
    havePrinted = true;
  };

  //SDL_Point[] myPoints = [ { 0,0}, {myRect.w, myRect.h}];
  h = h0;
  for (int j = i+40;i<j;++i) {
    sprintf( buf.ptr, fmt, i);
    auto surf2 = TTF_RenderText_Solid(font, buf.ptr, green);
    scope(exit) {
      SDL_FreeSurface( surf2 );
    };
    myRect.x = cast(short)  w;
    myRect.y = cast(short)  h;
    myRect.w = cast(ushort) surf2.w;
    myRect.h = cast(ushort) surf2.h;
    // SDL_RenderDrawLines(screen,
    // 			myPoints.ptr,
    // 			1);
    h += surf2.h;
    SDL_BlitSurface( surf2, null, screen,&myRect);
    havePrinted = true;
  };

  //writeln("Boom");
  SDL_Flip(screen);
  //SDL_GL_SwapBuffers();
}

void InitGL(int Width, int Height)
{
  writefln("viewport");
  glViewport(0, 0, Width, Height);
  writefln("clear color");
  glClearColor(0.0f, 0.0f, 0.0f, 0.0f);		// This Will Clear The Background Color To Black
  writefln("depth");
  glClearDepth(1.0);				// Enables Clearing Of The Depth Buffer
  writefln("depth");
  glDepthFunc(GL_LESS);				// The Type Of Depth Test To Do
  writefln("enable");
  glEnable(GL_DEPTH_TEST);			// Enables Depth Testing
  writefln("shademodel");
  glShadeModel(GL_SMOOTH);			// Enables Smooth Color Shading
  writefln("matrixmode");
  glMatrixMode(GL_PROJECTION);
  writefln("loadident");
  glLoadIdentity();				// Reset The Projection Matrix
  writefln("perspective");

  GLfloat xfloat = cast(GLfloat)Width;
  GLfloat yfloat = cast(GLfloat)Height;

  auto ratio = xfloat/ yfloat;
  writefln(" xfloat = %s yfloat=%s %s %s\n", xfloat, yfloat, typeid( xfloat), typeid(yfloat) );
  writefln("ratio %s %s\n", ratio, typeid(ratio));
  gluPerspective(45.0f,ratio, 0.1f,100.0f);	// Calculate The Aspect Ratio Of The Window
  writefln("matrixmode");
  glMatrixMode(GL_MODELVIEW);
}

void main() {
  writefln("Loading SDL");
  DerelictSDL.load();

  writefln("Loading SDLttf");
  DerelictSDLttf.load();

  writefln("Loading GL");
  DerelictGL.load();
  writefln("Loading GLU");
  DerelictGLU.load();

  if ( SDL_Init( SDL_INIT_VIDEO ) < 0 ) {
    writefln("It didn't work");
  };

  TTF_Init();
  //writefln("Making my font");
  //TTF_Font* font = TTF_OpenFont("/usr/share/fonts/truetype/liberation/LiberationMono-Regular.ttf", 12);
  // SDL_Color foregroundColor = { 255, 255, 255 }; 
  // SDL_Color backgroundColor = { 0, 0, 255 };
  // SDL_Surface* textSurface = TTF_RenderText_Shaded(font, "This is mytext.", foregroundColor, backgroundColor);

  writefln("It worked");
  auto NULL = cast(void*)0;

  /* Create a 640x480 OpenGL screen */
  if ( ( screen = SDL_SetVideoMode(Width, Height, 0, 0) ) == NULL ) {
    writefln( "Unable to create OpenGL screen: %s\n", SDL_GetError());
    SDL_Quit();
    return;
  }

  /* Set the title bar in environments that support it */
  SDL_WM_SetCaption("Vortex", "Foo"); 

  /* Loop, drawing and checking events */
  writefln("Calling initgl\n");

  InitGL(Width, Height);
  drawScene(2.0f, 0.98);

  writefln("About to mainloop\n");
  auto done = false;
  float degreeOffset = 2.0f;
  float lengthFraction = 0.98;

  auto keyDown = false;

  void delegate() functor = delegate () {};

  SDL_Event event;
  while ( !done ) {
    /* This could go in a separate function */
    //cout << event.type << endl;
    //SDL_WaitEvent(&event);
    drawScene( degreeOffset, lengthFraction);

    auto haveEvent = SDL_PollEvent(&event);
    immutable lfBump    = 0.001;
    immutable degBump   = 0.03;

    if ( event.type == SDL_QUIT ) {
      done = 1;
    }
    if ( event.type == SDL_KEYDOWN ) {
      keyDown = true;
      if ( event.key.keysym.sym == SDLK_ESCAPE ) {
	functor = delegate() { done = 1;  };
      }
      if ( event.key.keysym.sym == SDLK_LEFT ) {
	functor = delegate() { degreeOffset += degBump; };
      };
      if ( event.key.keysym.sym == SDLK_RIGHT) {
	functor = delegate() { degreeOffset -= degBump; };
      };
      if ( event.key.keysym.sym == SDLK_UP ) {
	functor = delegate() {
	  float newFract = lengthFraction + lfBump; 
	  lengthFraction = newFract < 1.0 ? newFract : lengthFraction;
	};
      } else if ( event.key.keysym.sym == SDLK_DOWN) {
	functor = delegate() {
	  lengthFraction -= lfBump;
	};
      };
    } else if ( event.type == SDL_KEYUP ) {
      keyDown = false;
    };

    if (keyDown) {
      functor();
    };

    drawScene( degreeOffset, lengthFraction);
  }
  SDL_Quit();
  return;
};