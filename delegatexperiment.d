#!/usr/bin/env rdmd

import std.stdio;

int useIt( int function(int,int) f ) {
    return f(2,3);
};

int mult(int x, int y) {
    return x * y;
}

void main() {
    auto x = (int x, int y) => x * y;
    auto x2 = (int x, int y) {
                              return x + y;
    };
    pragma(msg, typeof(x));
    writefln( "%s", useIt( x ));
    writefln( "%s", useIt( x2 ));
};
 
