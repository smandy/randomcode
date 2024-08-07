#!/usr/bin/env rdmd

import std.stdio : writeln, writefln;

struct Foo
{
    int data;

    this(int x)
    {
        data = x;
        writefln("Making a foo %s", data);
    }

    this(this)
    {
        writeln("Postblit");
    }

    ~this()
    {
        writefln("Foo %s destroyed", data);
    }
}

int foo(Foo x)
{
    writeln("here");
    return x.data;
}

int foo(ref Foo x)
{
    writeln("there");
    return x.data;
}

void main()
{
    auto x = Foo(5);
    auto y = foo(x);
    writeln(y);

    auto z = foo(Foo(5));
    writeln(z);

    writefln("End of scope");

    struct S
    {
    }

    void fun(S)
    {
        writeln("A");
    }

    void fun(ref const(S))
    {
        writeln("B");
    }

    fun(S()); // calls A
    S s;
    fun(s); // calls A

    const(S) t;
    fun(t); // calls B
    fun(const(S)()); // calls B
}
