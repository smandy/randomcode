#!/usr/bin/env rdmd

import std.exception;

import std.stdio;
import std.conv;
import std.string;

// test me with something like --> rdmd -version=expandFront -unittest --main circularArray.d 

class CircularArray(T) {
  T[] ts;

  long head = 0;
  long tail = 0;

  int mask;

  this( int capacity ) {
    enforce( (capacity & (capacity-1))==0, "needs to be pow2");
    ts = new T[capacity];
    head = capacity / 2;
    tail = capacity / 2;
    setMask(capacity - 1);
  };

  void setMask( int mask) {
    writefln("mask is %010b", mask);
    this.mask = mask;
  };

  @property int size() {
    return cast(int)(tail - head);
  };

  T get(int idx) {
    ulong loc = (head + idx) & mask;
    return ts[loc];
  };

  void ensureCapacity() {
    if (size==ts.length) {
      writefln("Doubling %s %s -> %s", this.toString(), ts.length, ts.length * 2);
      T[] newTs;
      newTs.reserve(ts.length * 2);
      auto toWrite = ts.length - (head & mask);
      writefln("toWrite is %s %s", toWrite, ts);

      newTs ~= ts[(head & mask)..ts.length];
      newTs ~= ts[0..(tail & mask)];
      newTs.length *= 2;
      enforce( newTs.length == ts.length * 2, format("Dodgy ops! %s vs %s", newTs.length, ts.length) );
      writefln("before %s", ts);
      writefln("after %s", newTs);
      ts = newTs;
      setMask( cast(int)(ts.length - 1));
      auto tmp = size;
      head = ts.length;
      tail = ts.length + tmp;
      writefln("After doubling this is %s", this.toString());
    };
  };

  void insertAt(int idx, T t) {
    ensureCapacity();
    auto mid = size==0 ? 0 : idx / size;
    if ( idx <= mid ) {
      foreach( i; head..(head + idx )) {
	ts[(i-1) & mask] = ts[i & mask];
      };
      head--;
    } else {
      foreach_reverse( i ; head+idx..tail) {
	ts[(i+1) & mask] = ts[i & mask];
      };
      tail++;
    };
    ts[(head+idx) & mask] = t;
  };

  override string toString() {
    T[] ret;
    foreach(i ; 0..size() ) {
      ret ~= get(i);
    };
    return format("sz=%s items=%s h=%s t=%s", 
		  size(), 
		  to!string(ret), 
		  head, 
		  tail);
  };

  void expand() {
    ts.length *= 2;
  };

};

version = expandFront;
version = expandBack;
version = insertFront;
version = insertBack;
version = insertMid;

version (insertFront) unittest {
  writefln("\n\nInsertFront");
  auto foo = new CircularArray!int(32);
  foreach( i ; 0..20) {
    foo.insertAt(0, i);
    writefln("i=%s foos=%s", i, foo);
  };
};


version (insertBack) unittest {
  writefln("\n\nInsertBack");
  auto foo = new CircularArray!int(32);
  foreach( i ; 0..20) {
    foo.insertAt(i, i);
    writefln("i=%s foos=%s", i, foo);
  };
};

version (insertMid) unittest {
  writefln("\n\nInsertMid");
  auto foo = new CircularArray!int(32);
  foreach( i ; 0..20) {
    auto mid = i == 0 ? 0 : i / 2;
    foo.insertAt(mid, i);
    writefln("i=%s mid=%s foos=%s", i, mid, foo);
  };
};

version (expandFront) unittest {
  writefln("\n\nExpandFront");
  auto foo = new CircularArray!int(2);
  foreach(i ; 0..20) {
    foo.insertAt(0, i+20);
    writefln("i=%s foos=%s", i, foo);
  };
}

version (expandBack) unittest {
    writefln("\n\nExpandback");
    auto foo = new CircularArray!int(2);
    foreach(i ; 0..20) {
      foo.insertAt(i, i+200);
      writefln("i=%s foos=%s", i, foo);
    };
}


