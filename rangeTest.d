#!/usr/bin/env rdmd

import std.range;
import std.algorithm;

import std.stdio;

struct MyRangeExp {
  struct Range {
	 int i = 20;

	 bool empty() {
		return i>50;
	 }; 

	 @property ref auto front() {
		return i;
	 }; 
	 
	 void popFront() {
		++i;
	 };
  }

  auto range() {
	 return Range();
  };
}

void main() {
  MyRangeExp r;
  foreach( x ; r.range) {
	 writefln( "%s", x);
  }

  auto r1 = r.range;
  auto r2 = r.range;

  r1.popFront();
  writefln( "%s", zip( r1, cycle(r2)));
};




