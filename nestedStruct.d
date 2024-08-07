#!/usr/bin/env rdmd

import std.stdio;
import std.traits;
import std.conv;
import std.algorithm;
import std.functional;
import std.range;

align(1) struct BidAskChange {
  int    messageType;     
  int    securityId;
  long   timeStamp;
  long   bidQty;
  double bidPrice;
  long   askQty;
  double askPrice;
};

pragma(msg, "Size is ", BidAskChange.sizeof);
static assert (BidAskChange.sizeof == 48);

void dumpType(T, string member)() {
  auto val = T.init;
  auto sizeOf  = __traits(getMember, val, member).sizeof;
  auto alignOf = __traits(getMember, val, member).alignof;
  auto offsetOf = __traits(getMember, val, member).offsetof;
  auto stringof = typeof(__traits(getMember, val, member)).stringof;
  writefln("%15s %4s align=%s stringof=%8s offset=%s", member, sizeOf, alignOf, stringof, offsetOf);
};
  
void dumpInfo(T)()  {
  foreach(member ; __traits(derivedMembers, T)) {
    dumpType!( T, member);
  }
};

void main() {

  dumpInfo!BidAskChange;
};