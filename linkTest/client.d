import std.stdio;

import std.conv;
import std.string;
import api;

extern(C) int cb( meta *ptr, const char *msg) {
  writefln("woohoo %s %s", to!string(msg), ptr.x);
  return 10;
};

void main() {
  auto s = meta(10);
  writefln("Meta is %s", s);
  auto order = "foo";
  sendOrder( &s, cast(const char *)order.toStringz(), &cb);
  writefln("Meta is %s", s);
}
	     