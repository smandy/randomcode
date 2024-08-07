#!/usr/bin/env rdmd

inout(int)  doit( inout int x) {
    return x + 10;
   };

void main() {
    const(const(int)) x = 10;
    immutable(const(int)) y = 10;
    pragma(msg, typeof(doit(x)));
    pragma(msg, typeof(doit(y)));
};
