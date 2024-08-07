#!/usr/bin/env rdmd

import std.stdio;

void binaryWrite(T,U)(ref T f, ref U u) {
    f.rawWrite( (&u)[0..1]);
}

void main() {
    auto f = File("/tmp/foo.dat", "w");
    ulong myLong1 = 21;
    ulong myLong2 = 22;
    uint  myInt   = 23;
    int   myInt2  = -20;

    for(int i = 0;i<100;++i) {
        myLong1 = i;
        myLong2 = i+ 20;
        myInt  = i * 2;
        myInt2 = -i * i;
        
        f.binaryWrite( myLong1);
        f.binaryWrite( myLong2);
        f.binaryWrite( myInt);
        f.binaryWrite( myInt2);
    }
}
