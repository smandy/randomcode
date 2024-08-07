import std.stdio;
import std.string;
import std.conv;
import derelict.sdl2.sdl;
import derelict.opengl3.gl3;

pragma(lib, "DerelictUtil.lib");
pragma(lib, "DerelictSDL2.lib");
pragma(lib, "DerelictGL3.lib");

SDL_Window *win;
SDL_GLContext context;
int w=800, h=600;
bool running=true;
int shader = 0;
uint vao=0, vbo=0;

bool loadLibs(){
try{
                DerelictSDL2.load();
        }catch(Exception e){
                writeln("Error loading SDL2 lib");
  return false;
        }
        try{
                DerelictGL3.load();
        }catch(Exception e){
                writeln("Error loading GL3 lib");
                return false;
        }
return true;
}
bool initSDL(){
         if(SDL_Init(SDL_INIT_VIDEO) < 0){
                 writefln("Error initializing SDL");
                 return false;
        }
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 2);
        SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
        SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);

        win=SDL_CreateWindow("3Doodle", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, w, h, SDL_WINDOW_OPENGL |
                                                                                                SDL_WINDOW_SHOWN);
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
bool initGL(){
        glClearColor(0.0, 0.0, 0.0, 1.0);
        glViewport(0, 0, w, h);
        return true;
}
bool initShaders(){
        const string vshader="
                #version 330
                layout(location = 0) in vec4 pos;
                void main(void)
                {
                        gl_Position = pos;
                }
        ";
        const string fshader="
                #version 330
                void main(void)
                {
                        gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
                }
        ";
  
         shader=glCreateProgram();
        if(shader == 0){
                  writeln("Error: GL did not assigh main shader program id");
                  return false;
        }

        int vshad=glCreateShader(GL_VERTEX_SHADER);
        const char *vptr=toStringz(vshader);
        glShaderSource(vshad, 1, &vptr, null);
        glCompileShader(vshad);
        int status, len;
        glGetShaderiv(vshad, GL_COMPILE_STATUS, &status);
        if(status==GL_FALSE){
          glGetShaderiv(vshad, GL_INFO_LOG_LENGTH, &len);
          char[] error=new char[len];
          glGetShaderInfoLog(vshad, len, null, cast(char*)error);
          writeln(error);
          return false;
        }

        int fshad=glCreateShader(GL_FRAGMENT_SHADER);
        const char *fptr=toStringz(fshader);
        glShaderSource(fshad, 1, &fptr, null);
        glCompileShader(fshad);
        glGetShaderiv(vshad, GL_COMPILE_STATUS, &status);
        if(status==GL_FALSE){
          glGetShaderiv(fshad, GL_INFO_LOG_LENGTH, &len);
          char[] error=new char[len];
          glGetShaderInfoLog(fshad, len, null, cast(char*)error);
          writeln(error);
          return false;
        }

        glAttachShader(shader, vshad);
        glAttachShader(shader, fshad);
        glLinkProgram(shader);
        glGetShaderiv(shader, GL_LINK_STATUS, &status);
        if(status==GL_FALSE){
          glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &len);
          char[] error=new char[len];
          glGetShaderInfoLog(shader, len, null, cast(char*)error);
          writeln(error);
          return false;
        }

        return true;
}
bool initVAO(){
        const float[] v = [ 0.75f, 0.75f, 0.0f, 1.0f,
                                                                0.75f, -0.75f, 0.0f, 1.0f,
                                                           -0.75f, -0.75f, 0.0f, 1.0f];

        glGenVertexArrays(1, &vao);
        if(vao<1){
          writeln("Error: GL failed to assign vao id");
          return false;
        }

        glBindVertexArray(vao);
        glGenBuffers(1, &vbo);
        if(vbo<1){
          writeln("Error: GL failed to assign vbo id");
          return false;
        }

        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glBufferData(GL_ARRAY_BUFFER, v.length * GL_FLOAT.sizeof, &v, GL_STATIC_DRAW);
        glEnableVertexAttribArray(0);
        glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 0, null);
  
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindVertexArray(0);
        return true;
}

void drawVao(){
        glUseProgram(shader);
        glBindVertexArray(vao);
        glDrawArrays(GL_TRIANGLES, 0, 6);
        glBindVertexArray(0);
        glUseProgram(0);
}
void drawVbo(){
        glUseProgram(shader);
        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glEnableVertexAttribArray(0);
        glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 0, null);
        glDrawArrays(GL_TRIANGLES, 0, 6);

        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glUseProgram(0);
}

int main()
{
        writeln("Load libs: ", loadLibs());
        writeln("Init sdl: ", initSDL());
        writeln("Init gl: ", initGL());
        writeln("Init shaders: ", initShaders());
        writeln("Init vao: ", initVAO());
  
        while(running){
                SDL_Event e;
                        while(SDL_PollEvent(&e)){
                                switch(e.type){
                                case SDL_KEYDOWN:
                                running=false;
                                break;
                                default:
                                break;
                           }
                  }

                glClear(GL_COLOR_BUFFER_BIT);
  
                //drawVao();
                drawVbo();
  
                SDL_GL_SwapWindow(win);
         }

        SDL_GL_DeleteContext(context);
        SDL_DestroyWindow(win);
        SDL_Quit();

        return 0;
}