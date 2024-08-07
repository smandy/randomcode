#!/usr/bin/env rdmd

import std.stdio;

auto voldemort(string x) {
    struct s {
        string name;
    }
    s ret = {"woohoo"};
    return ret;
}

pragma(msg, "voldemort is ", typeof(voldemort));

void main() {
    float a = 1_000_000_000;
    // writefln("%s" , a + 35 - a );
    // writefln("%s" , 1.0 / 0.0 );
    auto x = voldemort("Woohoo");
    writefln("%s", x.name);
    
    int[5] arr;
    void[5] arr2 = void;
    struct fun(T) {
        T fun ;
        string bar = "foot";
    }
    auto x2 = fun!int();
    writeln(x2.bar);
    writeln(x2);
    writefln( "%s", size_t.sizeof);
}



