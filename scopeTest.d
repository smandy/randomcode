import std.stdio;

void funcall() {
  writeln("Entering funcall");
  scope(exit) writefln("Exiting funcall");
};

void main() {
  scope(exit) writeln("Exit outer");
  { scope(exit) writeln("Exit inner"); }
  funcall();
  { scope(exit) writefln("Exit inner2"); }
};