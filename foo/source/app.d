import std.stdio;

import mousey;

private import derelict.sdl2.sdl;
//private import derelict.opengl3.gl;

import std.math;
import std.conv;

pragma(lib, "DerelictUtil.lib");
pragma(lib, "DerelictSDL2.lib");
//pragma(lib, "DerelictGL3.lib");
//pragma(lib, "DerelictGLU.lib");

const int Width=800, Height=600;

SDL_Window   *window;
SDL_Renderer *renderer;

void drawScene(float degreeOffset,float lengthFraction) {
  SDL_SetRenderDrawColor( renderer, 0, 0, 0, 0);
  SDL_RenderClear(renderer);
  SDL_SetRenderDrawColor( renderer, 0, 255, 255, 255);
  drawVortex(degreeOffset, lengthFraction);
}

SDL_Point[] points;

void drawVortex(float degreeOffset, float lengthFraction) {
  float l = Height;
  auto m = Mousey(0,0, 0.0f);
  points.length = 0;
  while( l > 0.05 ) {
	 points ~= SDL_Point(to!int(m.getX()), to!int(m.getY()));
    m.move( l );
    m.turn( Mousey.HALF_PI + degreeOffset * Mousey.DEGREE);
    l *= lengthFraction;
  }
  SDL_RenderDrawLines( renderer, points.ptr, to!int(points.length));
  SDL_RenderPresent(renderer);
};
  

void InitGL(int Width, int Height)
{
  window = SDL_CreateWindow("Vortex", SDL_WINDOWPOS_CENTERED,
			    SDL_WINDOWPOS_CENTERED, Width, Height, SDL_WINDOW_SHOWN);
  if (window == null){
    writeln( "CreateWindow");
    //TTF_Quit();
    SDL_Quit();
    return;
  }
  renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
}

void main() {
  writefln("Loading SDL");
  DerelictSDL2.load();

  if ( SDL_Init( SDL_INIT_VIDEO ) < 0 ) {
    writefln("It didn't work");
  }

  writefln("It worked");
  auto NULL = cast(void*)0;

  /* Loop, drawing and checking events */
  writefln("Calling initgl\n");
  InitGL(Width, Height);
  writefln("About to mainloop\n");
  auto done = false;
  float degreeOffset = 2.0f;
  float lengthFraction = 0.98;

  auto keyDown = false;

  void delegate() functor = delegate () {};

  SDL_Event event;
  while ( !done ) {
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
		  //writefln("Left");
		  functor = delegate() { degreeOffset += degBump; };
      }
      if ( event.key.keysym.sym == SDLK_RIGHT) {
		  //writefln("Right");
		  functor = delegate() { degreeOffset -= degBump; };
      }
      if ( event.key.keysym.sym == SDLK_UP ) {
		  functor = delegate() {
			 float newFract = lengthFraction + lfBump; 
			 lengthFraction = newFract < 1.0 ? newFract : lengthFraction;
		  };
      } else if ( event.key.keysym.sym == SDLK_DOWN) {
		  functor = delegate() {
			 lengthFraction -= lfBump;
		  };
      }
    } else if ( event.type == SDL_KEYUP ) {
      keyDown = false;
    }

    if (keyDown) {
      functor();
    }

    drawScene( degreeOffset, lengthFraction);
  }
  SDL_Quit();
  return;
};