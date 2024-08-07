#!/usr/bin/env rdmd

import std.stdio;
import std.format;
import std.array;

struct Foo
{
    string first;
    string last;
    void doit()
    {
        // writefln("Woot");
    }
}

template get_pod_member(T, string member)
{
    enum the_member = __traits(getMember, T.init, member);
    enum sizeOf = the_member.sizeof;
    enum alignOf = the_member.alignof;
    enum typeOf = typeof(the_member).stringof;
    enum ident = __traits(identifier, the_member);
    enum get_pod_member = format("%s %s %s %s %s", typeOf,sizeOf, alignOf, member, ident);
}

template dumpType(T, string member)
{
    //enum isFunction = __traits(isStaticFunction, mixin("%s.%s".format(T.stringof, member)));
    //enum x = get_pod_member!(T, member);
    static if (__traits(compiles, get_pod_member!(T, member)))
    {
        enum dumpType = get_pod_member!(T, member);
    }
    else
    {
        enum dumpType = "%s Its a function ".format(member);
    }
}

string d_to_ice(T)()
{
    string[] ret;
    foreach (member; __traits(derivedMembers, T))
    {
        ret ~= dumpType!(T, member);
    }
    return ret.join("\n");
}

void main()
{
    writefln("%s", d_to_ice!Foo);
}
