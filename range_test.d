#!/usr/bin/env rdmd

import std.stdio;
import std.range : iota;
import std.array;
import std.traits;

struct It(T) if (__traits(isIntegral,T)) {
    T made;
    
    T front() {
        return made;
    }
    
    bool empty() {
        //writefln("Empty");
        return made > 5;
    }

    @safe void popFront() {
        ++made;
    }
}

struct It2(T) if (__traits(isIntegral,T)) {
    int opApply(int delegate(ref int) operations) {
        for(int i= 0;i<10;++i) {
            operations(i);
        }
        return 0;
    }
}

void main() {
    It!int my_it;
    It!int my_it2;

    writefln( "%s", my_it2.array());
    // foreach( x ; my_it) {
    //     writefln("%s", x);
    // }
    // writefln( "%s", iota(0,5));
    It2!int x2;
    foreach( x ; x2) {
        writefln("bazoo %s", x);
    }

    It2!int x3;
    writefln("%s", x3.array);
    
}
