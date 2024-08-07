#!/usr/bin/env rdmd

import std.stdio;
import std.string;

string handle( string s) {
    return "void handle" ~ s ~ "() { writefln(\"Hello " ~ s ~ "\"); }";
}

mixin template addOne(T) {
    T add( T t) {
        return t + 1;
    }
}

struct Foo {
    mixin(handle("foo"));
    mixin(handle("goo"));

    mixin addOne!int;
    mixin addOne!float;
    mixin addOne!double;
}

void main() {
    Foo x;
    x.handlefoo();
    x.handlegoo();
    
    writefln("int is %s", x.add(1));
    writefln("float is %s", x.add(1.0f));
    writefln("double is %s", x.add(1.0));
}
