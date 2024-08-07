#!/usr/bin/env rdmd

import core.memory;
import std.stdio;
import core.stdc.stdlib;

struct Foo {
  void *mem;

  @disable this();

  this(int x) {
	 mem = malloc(x);
	 writefln("Created mem %s", mem);
  };

  ~this() {
	 writefln("Freeing mem %s", mem);
	 free(mem);
  };
};

void main() {
  auto f = Foo(1024);
};