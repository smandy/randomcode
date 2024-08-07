#!/usr/bin/env rdmd

import std.stdio;
import std.array;
import std.string;
import std.conv;

void main( string[] ) {
  writefln("Hello");
  auto f = File("/home/andy/andy.d");
  int[string] wc;
  foreach( s ; f.byLine() ) {
    writefln("Hello %s", s.strip() );
    foreach( word ; to!string(s.split()) ) {
      writefln("Word is %s", word);
      wc[word] += 1;
    }
  }
}
