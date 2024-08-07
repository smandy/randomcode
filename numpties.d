import std.stdio;

private import derelict.sdl2.sdl;
private import derelict.opengl3.gl3;
private import derelict.opengl3.gl;
import std.datetime;

import core.memory : GC;

import std.math;
import dchip.all;
import std.conv;

pragma(lib, "DerelictSDL2.lib");
pragma(lib, "DerelictGL.lib");
pragma(lib, "DerelictGLU.lib");
pragma(lib, "DerelictUtil.lib");

const int Width=800, Height=1200;

auto numptyx = 0.0f;
auto numptyy = 0.0f;

const auto numptySize = 10;
const float starty = 0.0f;

SDL_Window   *window;
SDL_Renderer *renderer;

SDL_Point[5] points;
SDL_Point[2] points2;

const HeightOver2 = to!int(Height / 2.0);

auto SDL_Pointfac(T)( T x, T y, ref SDL_Point p) {
  p.x = to!int(x / 2.0);
  p.y = HeightOver2 - to!int(y / 2.0);
};

void drawSquare(T,U)( T p,U r) {
  //points.length = 0;
  SDL_Pointfac( p.x     , p.y , points[0]);
  SDL_Pointfac( p.x + r , p.y , points[1]);
  SDL_Pointfac( p.x + r , p.y +r, points[2] );
  SDL_Pointfac( p.x     , p.y +r, points[3] );
  SDL_Pointfac( p.x     , p.y , points[4]);
  SDL_RenderDrawLines(renderer, points.ptr, 5);
}

void drawLine(T)( ref T p) {
  SDL_Pointfac(p.lhs.x, p.lhs.y, points2[0]);
  SDL_Pointfac(p.rhs.x, p.rhs.y, points2[1]);
  SDL_RenderDrawLines(renderer, points2.ptr, 2);
}

void main() {
  writefln("Loading SDL");
 DerelictSDL2.load();
  writefln("Loading GL");
  DerelictGL.load();
  //writefln("Loading GLU");
  //DerelictGLU.load();
  //cpSpace *space = cpSpaceNew();
  if ( SDL_Init( SDL_INIT_VIDEO ) < 0 ) {
    writefln("It didn't work");
  }

  writefln("It worked");
  auto NULL = cast(void*)0;

  // /* Create a 640x480 OpenGL screen */
  // if ( SDL_SetVideoMode(Width, Height, 0, SDL_OPENGL) == NULL ) {
  //   writefln( "Unable to create OpenGL screen: %s\n", SDL_GetError());
  //   SDL_Quit();
  //   return;
  // }
  window = SDL_CreateWindow("Numpties", SDL_WINDOWPOS_CENTERED,
									 SDL_WINDOWPOS_CENTERED, Width / 2, Height / 2, SDL_WINDOW_SHOWN);
  renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);

  if (window == null){
    writeln( "CreateWindow");
    //TTF_Quit();
    SDL_Quit();
    return;
  }

  //auto glcontext = SDL_GL_CreateContext(window);


  //drawScene();
  writefln("About to mainloop\n");
  auto done    = false;
  auto keyDown = false;

  SDL_Event event;
  //int numptyx = 0;
  const float numptyDelta = 0.1f;

  cpSpace* space = cpSpaceNew();
  space.iterations = 10;
  space.gravity = cpv(0, -10);

  struct Pair(T) {
	 T lhs;
	 T rhs;
  }
  
  Pair!cpv[] pairs;
  void addPair( cpv x, cpv y) {
	 cpShape* ground = cpSegmentShapeNew(space.staticBody, x, y, 10.0f);
	 ground.e = 1.0f;
	 ground.u = 1.0f;
	 cpSpaceAddShape(space, ground);
	 pairs ~= Pair!cpv( x, y);
  }

  void doPair( double dy ) {
	 addPair( cpv(0   , 300 + dy)   , cpv( 500  , dy + 190));
	 addPair( cpv(800 , dy + 200)    , cpv(300  , dy + 80 ));
  }

  doPair(800);
  doPair(600);
  doPair(400);
  doPair(200);
  doPair(000);

  addPair( cpv( 50, 800), cpv(50,0));
  addPair( cpv( 750, 800), cpv(750,0));
  addPair( cpv( 0, 20), cpv(800,20));

  alias cpBody* cpBodyPtr;

  cpFloat radius = 3;
  cpFloat mass   = 15.0f;
  alias bodyType = typeof( cpBodyNew(mass, cpMomentForCircle(mass, 0.0f, radius, cpvzero) ));

  pragma( msg, bodyType);

  auto linked_workaround = typeid(cpBody).toString();
  
  bodyType[int] balls;
  int idx;

  int idx2 = 0;

  void addBall( double x, double y ) {
	 cpBody *bod = cpBodyNew(mass, cpMomentForCircle(mass, 0.0f, radius, cpvzero));
	 assert(bod);
	 bod.p = cpv(x, y);
	 bod.v = cpv(0, 0);
	 pragma(msg, typeof(bod));
	 balls[idx2++] = bod;
	 cpSpaceAddBody(space, bod);
	 cpShape* shape = cpSpaceAddShape(space, cpCircleShapeNew(bod, radius, cpvzero));
	 shape.e = 0.0f;
	 shape.u = 0.9f;
	 //return bod;
  }

  auto y = Height - 50;
  for( auto x = 50.0; x< 350; x += 1) {
	 addBall( x, y);
	 addBall( x, y+3);
	 addBall( x, y+6);

	 //y -= 1;
  }

  bool finished = false;
  auto cidx = 0L;

  GC.collect();
  GC.disable();


  auto last = TickDuration.from!"msecs"(0);
  StopWatch sw;
  sw.start;

  while ( !done ) {
    auto haveEvent = SDL_PollEvent(&event);
    immutable lfBump    = 0.001;
    immutable degBump   = 0.03;
	 auto nx = sw.peek();
	 //auto tick = (nx - last).msecs / 100.0;

	 auto tick = 0.1;

	 //writefln("Tick %s %s", tick , nx);
	 cpSpaceStep(space, tick);
	 last = nx;
	 if (haveEvent) {
		if ( event.type == SDL_QUIT ) {
		  done = true;
		}
		if ( event.key.keysym.sym == SDLK_ESCAPE ) {
		  done = 1;
		}
		if ( event.key.keysym.sym == SDLK_LEFT ) {
		  numptyx -= numptyDelta;
		}
		if ( event.key.keysym.sym == SDLK_RIGHT) {
		  numptyx += numptyDelta;
		}
		if ( event.key.keysym.sym == SDLK_UP ) {
		  numptyy += numptyDelta;
		} else if ( event.key.keysym.sym == SDLK_DOWN) {
		  numptyy -= numptyDelta;
		}
	 }

	 SDL_RenderClear(renderer);
	 foreach( ref Pair!cpv p ; pairs) {
		drawLine( p );
	 }
    //SDL_RenderPresent(renderer);
	 foreach( ref ball; balls ) {
	  	drawSquare( ball.p, radius);
	 }
    SDL_RenderPresent(renderer);
  }

  cpSpaceFree(space);
  SDL_Quit();
  return;
}
