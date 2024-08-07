#!/usr/bin/env rdmd

import std.stdio;

struct MyKlass(T) {
  T a;
  T b;
	// Trivial change
}

void main() {
  writefln("Hello world3");
  MyKlass!int x = { 2,3 };
  MyKlass!float x2 = { 2.2,3.0 };
  MyKlass!string x3 = { "foo", "bar"};
  writefln(" x is %s\n %s\n %s\n", x, x2, x3);
}
