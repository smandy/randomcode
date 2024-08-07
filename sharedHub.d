module ShaderHub;

import std.stdio;
import std.string;
import derelict.opengl3.gl3;

class ShaderHub{
    private bool ok=true;
    private GLuint shad=0, vshad=0, fshad=0;
    private int voff=0;
    private GLuint vbo=0, vao=0;
    const float[] v = [ 0.75f, 0.75f, 0.0f, 1.0f,
                        0.75f, -0.75f, 0.0f, 1.0f,
                        -0.75f, -0.75f, 0.0f, 1.0f];

    public this(){
        immutable string vshader = `
#version 330
layout(location = 1) in vec4 pos;
void main(void)
{
    gl_Position = pos;
}
`;

        immutable string fshader = `
#version 330
void main(void)
{
    gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
}
`;

        shad=glCreateProgram();
        if(shad==0){
            writeln("Error: GL did not assigh main shader program id");
            ok=false;
        }

        vshad=glCreateShader(GL_VERTEX_SHADER);
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
            ok=false;
        }

        fshad=glCreateShader(GL_FRAGMENT_SHADER);
        const char *fptr=toStringz(fshader);
        glShaderSource(fshad, 1, &fptr, null);
        glCompileShader(fshad); 
        glGetShaderiv(vshad, GL_COMPILE_STATUS, &status);
        if(status==GL_FALSE){
            glGetShaderiv(fshad, GL_INFO_LOG_LENGTH, &len);
            char[] error=new char[len];
            glGetShaderInfoLog(fshad, len, null, cast(char*)error);
            writeln(error);
            ok=false;
        }

        glAttachShader(shad, vshad);
        glAttachShader(shad, fshad);
        glLinkProgram(shad);
        glGetShaderiv(shad, GL_LINK_STATUS, &status);
        if(status==GL_FALSE){
            glGetShaderiv(shad, GL_INFO_LOG_LENGTH, &len);
            char[] error=new char[len];
            glGetShaderInfoLog(shad, len, null, cast(char*)error);
            writeln(error);
            ok=false;
        }


        glGenVertexArrays(1, &vao);
        if(vao<1){
            writeln("Error: GL failed to assign vao id");
            ok=false;
        }
        glBindVertexArray(vao);

        glGenBuffers(1, &vbo);
        if(vbo<1){
            writeln("Error: GL failed to assign vbo id");
            ok=false;
        }
        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glBufferData(GL_ARRAY_BUFFER, v.length * GL_FLOAT.sizeof, &v[0],     GL_STATIC_DRAW);
        glEnableVertexAttribArray(1);
        glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 0, cast(void*)voff);    

        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindVertexArray(0);   
    }

    public void draw(){
        glUseProgram(shad);

        writeln(glGetAttribLocation(shad, "pos"));//prints 1

        glBindVertexArray(vao); 
        glDrawArrays(GL_TRIANGLES, 0, 6);       
        glBindVertexArray(0);


        glUseProgram(0);
    }
}    