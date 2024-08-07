#!/usr/bin/env rdmd

import std.stdio;
import core.thread;

long getCount()
{
  // asm
  // 	 {	naked	;
  // 		rdtsc	;
  // 		ret	;
  // 	}
  asm
	 {	
		rdtsc	;
		mov hiword, edx;
		mov loword, eax;
	}

  return hiword << 32 + loword;

}


void main() {
  while(true) {
	 writefln("%s", getCount());
	 Thread.sleep( dur!"seconds"(1));
  }
};