import std.stdio;
import derelict.sdl2.sdl;
import derelict.opengl3.gl3;

import EventHub;
import ExposeApp;

pragma(lib, "DerelictUtil.lib");
pragma(lib, "DerelictSDL2.lib");
pragma(lib, "DerelictGL3.lib");


class App{
    private ExposeApp funcPtrs;
    private EventHub ehub;
    private SDL_Window *win;
    private SDL_GLContext context;
    private int w=600, h=480, fov=55;
    private bool running=true;

    public this(){
         if(!initSDL()){
            writeln("Error initializing SDL");
            SDL_Quit();
        }
        initGL();

        funcPtrs=new ExposeApp();
        funcPtrs.stop=&stopLoop;
        funcPtrs.grabMouse=&grabMouse;
        funcPtrs.releaseMouse=&releaseMouse;
        ehub=new EventHub(funcPtrs);


        while(running){
            glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

            ehub.tick();

            SDL_GL_SwapWindow(win);
        }


        SDL_GL_DeleteContext(context);
        SDL_DestroyWindow(win);
        SDL_Quit();
    }

    private void stopLoop(){
        running=false;
    }
    private void grabMouse(){
        SDL_ShowCursor(SDL_DISABLE);
        SDL_SetWindowGrab(win, SDL_TRUE);
    }
    private void releaseMouse(){
        SDL_ShowCursor(SDL_ENABLE);
        SDL_SetWindowGrab(win, SDL_FALSE);
    }
    private bool initSDL(){
        if(SDL_Init(SDL_INIT_VIDEO)< 0){
            writefln("Error initializing SDL");
            SDL_Quit();
            return false;
        }

        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 2);
        SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
        SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);

        win=SDL_CreateWindow("3Doodle", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,     w, h, SDL_WINDOW_OPENGL | SDL_WINDOW_SHOWN);
        if(!win){
            writefln("Error creating SDL window");
            SDL_Quit();
            return false;
        }

        context=SDL_GL_CreateContext(win);
        SDL_GL_SetSwapInterval(1);

        DerelictGL3.reload();

        return true;
    }
    private void initGL(){
        resize(w, h);

        glEnable(GL_DEPTH_TEST);
        glEnable(GL_CULL_FACE);

        glDepthFunc(GL_LEQUAL);

        glClearColor(0.0, 0.0, 0.0, 1.0);
        glClearDepth(1.0);

        glCullFace(GL_BACK);
        glFrontFace(GL_CCW);

    }
    private void resize(int w, int h){
        //this will contain the makings of the projection matrix, which we go into next tut
        glViewport(0, 0, w, h);
    }
}


void main(){
    try{
        DerelictSDL2.load();
    }catch(Exception e){
        writeln("Error loading SDL2 lib");
    }
    try{
        DerelictGL3.load();
    }catch(Exception e){
        writeln("Error loading GL3 lib");
    }

    App a=new App();
}