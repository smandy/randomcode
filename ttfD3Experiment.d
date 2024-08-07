import std.stdio;

private import derelict.sdl2.ttf;;
private import derelict.sdl2.sdl;

import std.math;
import std.string;

// A few problems foing from SDL 1.2 -> SDL2.0
// http://forums.libsdl.org/viewtopic.php?t=9163&sid=23359eedacf25591f8fe7c3423342de4
// http://wiki.libsdl.org/moin.fcg/MigrationGuide 
// "You update the physical screen using SDL_RenderPresent, which replaces SDL_Flip and SDL_UpdateRects. " 
// "SDL_SetVideoMode from 1.2 is now just a compatibility function, you will not use it anymore. You can use SDL_GetWindowSurface to get a 1.2 style surface for a window if necessary. " 
// On 6/12/2013 7:15 AM, arif wrote: 

//pragma(lib, "Derelict2SDLttf.lib");
pragma(lib, "Derelict2Util.lib");
pragma(lib, "Derelict2SDL.lib");
//pragma(lib, "DerelictGL.lib");
//pragma(lib, "DerelictGLU.lib");

const int Width=800, Height=600;
SDL_Window   *window;
SDL_Renderer *renderer;

SDL_Point[] lines = [ { 0,0 }, {0,0} ];

void drawScene(float degreeOffset,float lengthFraction) {
  static bool havePrinted = false;
  static int i = 0L;
  static TTF_Font* font  = null;
  static SDL_Rect myRect;

  if (font==null) {
    font = TTF_OpenFont("/usr/share/fonts/truetype/liberation/LiberationMono-Regular.ttf", 14);
  };
  // auto col  = SDL_MapRGB(window.format, 0 ,0   ,0);
  // auto col2 = SDL_MapRGB(window.format, 0 ,255 ,255);
  // auto col3 = SDL_MapRGB(window.format, 0 ,255 ,0);
  SDL_Color col3 = { 0, 0, 0 };
  SDL_RenderClear(renderer);
  SDL_SetRenderDrawColor( renderer, 0, 0, 0, 255);
  static char buf[30];
  const char *fmt = "i is %d";
  
  //writefln("Font is %s", font);
  SDL_Color foregroundColor = { 255, 255, 255 }; 
  SDL_Color backgroundColor = { 0, 0, 255 };

  static SDL_Color cyan  = { 0   , 255 , 255 };
  static SDL_Color red   = { 255 ,   0 ,   0 };
  static SDL_Color green = { 0   , 255 ,   0 };

  SDL_Surface* textSurface = TTF_RenderText_Solid(font, "This is mytext.", red);
  auto texture = SDL_CreateTextureFromSurface(renderer, textSurface);
  auto h0 = textSurface.h;
  auto w = textSurface.w * 2;

  SDL_Rect dest = { 0, 0, textSurface.w, textSurface.h};
  SDL_RenderCopy(renderer, texture, null, &dest);
  SDL_FreeSurface( textSurface );
  void doPrint(string s) {
    if ( !havePrinted ) {
      writefln(s);
    };
  };
  
  auto h = h0;
  SDL_SetRenderDrawColor( renderer, 0, 255, 0, 255);
  for (int j = i+40;i<j;++i) {
    //writefln("Calling printf");
    sprintf( buf.ptr, fmt, i);
    //writefln("called");
    auto surf2 = TTF_RenderText_Solid(font, buf.ptr, cyan);
    scope(exit) SDL_FreeSurface( surf2);
    myRect.x = cast(short)  0;
    myRect.y = cast(short)  h;
    myRect.w = cast(ushort) surf2.w;
    myRect.h = cast(ushort) surf2.h;
    h += surf2.h;

    auto surface = TTF_RenderText_Solid(font, buf.ptr, cyan);
    scope(exit) SDL_FreeSurface(surface);
      
    auto texture2 = SDL_CreateTextureFromSurface(renderer, surface);
    scope(exit) SDL_DestroyTexture(texture2);
    
    SDL_RenderCopy( renderer, texture2, null, &myRect);
    havePrinted = true;
    lines[0].x = 0;
    lines[0].y = 0;
    lines[1].x = cast(int)(4 * surf2.w * lengthFraction);
    lines[1].y = h;
    // SDL_Color c = { 0, 255,0 };
    SDL_RenderDrawLines( renderer, lines.ptr, 2);
  };

  SDL_SetRenderDrawColor( renderer, 0, 0, 0, 255);
  //SDL_Point[] myPoints = [ { 0,0}, {myRect.w, myRect.h}];
  h = h0;
  SDL_SetRenderDrawColor( renderer, 0, 255, 255, 255);
  for (int j = i+40;i<j;++i) {
    sprintf( buf.ptr, fmt, i);
    auto surf2 = TTF_RenderText_Solid(font, buf.ptr, green);
    scope(exit) SDL_FreeSurface( surf2 );
    auto texture2 = SDL_CreateTextureFromSurface( renderer, surf2);
    scope(exit) SDL_DestroyTexture(texture2);
    myRect.x = cast(short)  w;
    myRect.y = cast(short)  h;
    myRect.w = cast(ushort) surf2.w;
    myRect.h = cast(ushort) surf2.h;
    lines[0].x = w;
    lines[0].y = 0;
    lines[1].x = 2 * (w + surf2.w);
    lines[1].y = h;
    SDL_RenderDrawLines( renderer, lines.ptr, 2);
    SDL_RenderCopy( renderer, texture2, null, &myRect);
    //SDL_DestroyTexture( texture2);
    h += surf2.h;
    havePrinted = true;
  };
  SDL_SetRenderDrawColor( renderer, 0, 0, 0, 255);
  SDL_RenderPresent(renderer);
}

void main() {
  writefln("Loading SDLttf");
  DerelictSDL2ttf.load();

  writefln("Loading SDL");
  DerelictSDL2.load();

  writefln("Done");
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

  window = SDL_CreateWindow("Lesson 6", SDL_WINDOWPOS_CENTERED,
			    SDL_WINDOWPOS_CENTERED, Width, Height, SDL_WINDOW_SHOWN);
  if (window == null){
    writeln( "CreateWindow");
    TTF_Quit();
    SDL_Quit();
    return;
  }

  renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
  if (renderer == null) {
    writeln( "CreateRenderer");
    //cleanup(window);
    TTF_Quit();
    SDL_Quit();
    return;
  }

  /* Loop, drawing and checking events */
  writefln("Calling initgl\n");
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

    if (haveEvent) {
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
    }
  }
  SDL_Quit();
  return;
};