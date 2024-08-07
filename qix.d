import std.stdio;

private import derelict.sdl2.ttf;;
private import derelict.sdl2.sdl;

import std.math;
import std.string;
import std.traits;
import std.conv;

import ringbuffer;
import billiardball;

pragma(lib, "Derelict2Util.lib");
pragma(lib, "Derelict2SDL.lib");

enum Width = 800, Height = 600;
enum NUM_LINES = 128;

SDL_Window   *window;
SDL_Renderer *renderer;

struct PointBox {
    SDL_Point a;
    SDL_Point b;
    SDL_Point c;
    SDL_Point d;
    SDL_Point e; // Copy of a - simpler than calling SDL twice!
}

CircularBuffer!(NUM_LINES,PointBox) linebuf;

alias BilliardBall!(Width, Height, 3) BB;

BB az = BB(10 , 10 ,  3 , -2 );
BB bz = BB(10 , 10 , -7 , 1  );
BB cz = BB(200, 5  ,  3 , 6  );
BB dz = BB(2  , 8  ,  2 , 7  );

enum startColor = SDL_Color(0 , 255 , 255 );
enum endColor   = SDL_Color(0, 0 ,   0 );

SDL_Color[] morphColors(int N, 
                        const SDL_Color startColor, 
                        const SDL_Color endColor ) {
    SDL_Color[] ret = new SDL_Color[N];
    auto dr = ( endColor.r - startColor.r ) / cast(float)(N-1);
    auto dg = ( endColor.g - startColor.g ) / cast(float)(N-1);
    auto db = ( endColor.b - startColor.b ) / cast(float)(N-1);
    for (int i = 0;i<N;++i) {
        ret[i].r = cast(ubyte)(startColor.r + dr * i);
        ret[i].g = cast(ubyte)(startColor.g + dg * i);
        ret[i].b = cast(ubyte)(startColor.b + db * i);
    }
    return ret;
}

static {
    SDL_Color[] colors = morphColors( NUM_LINES, 
                                      endColor, 
                                      startColor );
}

void drawScene(float degreeOffset,float lengthFraction) {
    static bool havePrinted = false;
    static int i = 0L;
    static TTF_Font* font  = null;

    static SDL_Rect myRect;
    static int numLines = 0;

    if (font==null) {
        font = TTF_OpenFont("/usr/share/fonts/truetype/liberation/LiberationMono-Regular.ttf", 14);
    }

    PointBox pp;

    pp.a = az.point;
    pp.b = bz.point;
    pp.c = cz.point;
    pp.d = dz.point;
    pp.e = az.point; // Close the triangle!

    //writefln("adding %s %s", az.point, bz.point);
    az.tick();
    bz.tick();
    cz.tick();
    dz.tick();
    linebuf.enqueue( pp );

    SDL_SetRenderDrawColor( renderer, 0, 0, 0, 0);
    SDL_RenderClear(renderer);
    SDL_SetRenderDrawColor( renderer, 0, 255, 0, 255);
    //writefln( "%s %s", linebuf.head, linebuf.tail);

    int ci=0;
    long idx = linebuf.head;
    while( idx < linebuf.tail) {
        SDL_SetRenderDrawColor( renderer, 
                                colors[ci].r, 
                                colors[ci].g, 
                                colors[ci].b, 0);
        SDL_RenderDrawLines( renderer, cast(const SDL_Point*) (&linebuf[idx]), 5);
        ci++;
        idx++;
    }
    SDL_RenderPresent(renderer);
}

void main() {
    writefln("colors are %s", colors);

    writefln("Loading SDLttf");
    DerelictSDL2ttf.load();

    writefln("Loading SDL");
    DerelictSDL2.load();

    writefln("Done");
    if ( SDL_Init( SDL_INIT_VIDEO ) < 0 ) {
        writefln("It didn't work");
    }

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

        immutable lfBump    = 0.001;
        immutable degBump   = 0.03;

        auto haveEvent = SDL_PollEvent(&event);
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
                }
                if ( event.key.keysym.sym == SDLK_RIGHT) {
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
        }
    }
    SDL_Quit();
    return;
};


