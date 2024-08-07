import derelict.ode.ode;
import derelict.ode.types;
private import derelict.sdl2.sdl;
import std.traits;

import std.stdio;
pragma(lib, "DerelictODE.lib");

static dWorldID world;
static dSpaceID space;
static dBodyID bod;	
static dGeomID geom;	
static dMass m;
static dJointGroupID contactgroup;

enum Width = 800, Height = 600;
enum NUM_LINES = 128;

SDL_Window   *window;
SDL_Renderer *renderer;

struct PointBox {
  static PointBox factory() {
    PointBox ret;
    ret.b.x = 30;
    ret.c.x = 30;
    return ret;
  };

  this(this) {
    writeln("I've been copied!");
  };
  void setZ(float z) {
    a.y = cast(int)z;
    b.y = cast(int)z;
    c.y = cast(int)(z+30);
    d.y = cast(int)(z+30);
    e.y = cast(int)z;
  };
  SDL_Point a;
  SDL_Point b;
  SDL_Point c;
  SDL_Point d;
  SDL_Point e; // Copy of a - simpler than calling SDL twice!
};

template once( alias T ) if (isCallable!T) {
  bool fired = false;
  void once() {
    if (!fired) {
      T();
      fired = true;
    }
  };
};

extern( C ) void myFunc( void* ptr, dGeomID id1, dGeomID id2 ) nothrow {
  static auto called = false;
  try {
    once!( () { writefln("Callback!"); } )();
    once!( () { writefln("Another Callback!"); } )();
  } catch (Exception ex) {
    // NOOP
  };
};

void main () {
  DerelictODE.load();
  DerelictSDL2.load();

  writefln("Done");
  if ( SDL_Init( SDL_INIT_VIDEO ) < 0 ) {
    writefln("It didn't work");
  };
  window = SDL_CreateWindow("Lesson 6", SDL_WINDOWPOS_CENTERED,
			    SDL_WINDOWPOS_CENTERED, Width, Height, SDL_WINDOW_SHOWN);
  if (window == null){
    writeln( "CreateWindow");
    SDL_Quit();
    return;
  }

  renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
  if (renderer == null) {
    writeln( "CreateRenderer");
    //cleanup(window);
    SDL_Quit();
    return;
  }



  writeln("Woohoo");
  dInitODE();
  writeln("Init complete");
  world = dWorldCreate();
  space = dHashSpaceCreate (null);
  dWorldSetGravity (world,0,0,-0.2);
  dWorldSetCFM (world,1e-5);
  dCreatePlane (space,0,0,1,0);
  contactgroup = dJointGroupCreate (0);
  writeln("Bingo");
  bod  = dBodyCreate (world);
  geom = dCreateSphere (space,0.5);
  dMassSetSphere (&m,1,0.5);
  dBodySetMass (bod,&m);
  dGeomSetBody (geom,bod);

  writeln("Bing");
  // set initial position
  dBodySetPosition (bod,0,0,400);
  // run simulation

  auto pb = PointBox.factory();

  struct Foo {
    float x;
    float y;
    float z;
  };

  bool done = false;
  SDL_Event event;
  while( ! done ) {
    auto xs = cast(Foo*) dBodyGetPosition( bod );
    pb.setZ( xs.z );
    SDL_SetRenderDrawColor( renderer, 0, 0, 0, 0);
    SDL_RenderClear(renderer);
    SDL_SetRenderDrawColor( renderer, 0, 0, 255, 0);
    SDL_RenderDrawLines( renderer, cast(const SDL_Point*) &pb, 5);
    SDL_RenderPresent(renderer);
    dSpaceCollide (space, null, &myFunc);
    dWorldQuickStep (world,0.2);  
    dJointGroupEmpty (contactgroup);

    auto pos = dGeomGetPosition(geom);
    auto R   = dGeomGetRotation(geom);

    pragma(msg, typeof(pos) );
    pragma(msg, typeof(pos) );

    auto haveEvent = SDL_PollEvent(&event);
    if (haveEvent) {
      //writeln(event.type);
      if ( event.type == SDL_QUIT ) {
	done = true;
      }
    }
  }
  dJointGroupDestroy (contactgroup);
  dSpaceDestroy (space);
  dWorldDestroy (world);
  dCloseODE();
}
