import std.stdio;

private import derelict.sdl2.sdl;
private import derelict.opengl3.gl3;
private import derelict.opengl3.gl;

pragma(lib, "DerelictSDL2.lib");
pragma(lib, "DerelictGL.lib");
pragma(lib, "DerelictGLU.lib");
pragma(lib, "DerelictUtil.lib");

/* A simple function that prints a message, the error code returned by SDL,
 * and quits the application */
void sdldie(const char *msg)
{
    writefln("%s: %s\n", msg, SDL_GetError());
    SDL_Quit();
    //exit(1);
}
 
 
void checkSDLError(int line = -1)
{
	const char *error = SDL_GetError();
	if (*error != '\0')
	{
		writefln("SDL Error: %s\n", error);
		if (line != -1)
			printf(" + line: %i\n", line);
		SDL_ClearError();
	}
}
 
 
/* Our program's entry point */
int main(string[] args)
{

  writefln("Loading SDL");
  DerelictSDL2.load();
  writefln("Loading GL");
  DerelictGL.load();


    SDL_Window *mainwindow; /* Our window handle */
    SDL_GLContext maincontext; /* Our opengl context handle */
 
	 writefln("woot");

    if (SDL_Init(SDL_INIT_VIDEO) < 0) /* Initialize SDL's Video subsystem */
        writefln("Unable to initialize SDL"); /* Or die on error */
 
	 writefln("woot");
    /* Request opengl 3.2 context.
     * SDL doesn't have the ability to choose which profile at this time of writing,
     * but it should default to the core profile */
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 2);
 
    /* Turn on double buffering with a 24bit Z buffer.
     * You may need to change this to 16 or 32 for your system */
    SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
    SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);
 
	 writefln("woot");
    /* Create our window centered at 512x512 resolution */
    mainwindow = SDL_CreateWindow("Woot", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
        512, 512, SDL_WINDOW_OPENGL | SDL_WINDOW_SHOWN);
    if (!mainwindow) /* Die if creation failed */
        sdldie("Unable to create window");
 
    checkSDLError(__LINE__);
 
    /* Create our opengl context and attach it to our window */
    maincontext = SDL_GL_CreateContext(mainwindow);
    checkSDLError(__LINE__);
 
 
	 writefln("woot");
    /* This makes our buffer swap syncronized with the monitor's vertical refresh */
    SDL_GL_SetSwapInterval(1);
 
    /* Clear our buffer with a red background */
    glClearColor ( 1.0, 0.0, 0.0, 1.0 );
    glClear ( GL_COLOR_BUFFER_BIT );
    /* Swap our back buffer to the front */
    SDL_GL_SwapWindow(mainwindow);
    /* Wait 2 seconds */
    SDL_Delay(2000);
 
	 writefln("woot");
    /* Same as above, but green */
    glClearColor ( 0.0, 1.0, 0.0, 1.0 );
    glClear ( GL_COLOR_BUFFER_BIT );



    SDL_GL_SwapWindow(mainwindow);
    SDL_Delay(2000);
 
    /* Same as above, but blue */
    glClearColor ( 0.0, 0.0, 1.0, 1.0 );
    glClear ( GL_COLOR_BUFFER_BIT );
	 glColor3f( 1.0, 0.0, 0.0);
	 glBegin( GL_LINE_STRIP );
	 glVertex3f( 0.0f, 0.0f, 0.0f);
	 glVertex3f(  1.0f, -1.0f, -5.0f);
	 glVertex3f(  1.0f,  1.0f, -5.0f);
	 glVertex3f( -1.0f,  1.0f, -5.0f);
	 glVertex3f( -1.0f, -1.0f, -5.0f);
	 glVertex3f( 100.0f, 100.0f, 0.0f);
	 glVertex3f( -100.0f, -100.0f, 0.0f);
	 glEnd();

    SDL_GL_SwapWindow(mainwindow);
    SDL_Delay(2000);
 
	 writefln("woot");
    /* Delete our opengl context, destroy our window, and shutdown SDL */
    SDL_GL_DeleteContext(maincontext);
    SDL_DestroyWindow(mainwindow);
    SDL_Quit();
 
    return 0;
}