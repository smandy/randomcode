import std.getopt;
import std.stdio;

struct opts {
  string host = "localhost";
  ushort port = 1067;

  string name = "";
};

// Baz
opts getOpts( string[] args ) {
  opts ret;
  getopt(args,
	 "host|h", &ret.host,
	 "port|p", &ret.port,
	 "name|n", &ret.name);
  writefln("Opts are %s", ret);
  return ret;
};