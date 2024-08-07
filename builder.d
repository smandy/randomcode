#!/usr/bin/env rdmd

import std.stdio;
import std.process;
import std.string;
import std.algorithm;

void main() {
  writefln("In main!");
  auto libs = ["tcpOpts"];
  auto dynamic = [ "rt", "phobos2", "pthread", "m"];
  auto progs = [ "client" : ["tcpOpts"], 
		 "server" : ["tcpOpts"] ];
  buildLibs(libs);
  buildProgs(progs, dynamic);
};

void buildProgs( string[][string] progs , string[] dynamicLibs) {
  writeln("In buildprogs " , progs);
  foreach( string prog, string[] depLibs; progs) {
    buildLibs( [prog], false );
    string libDecls    = dynamicLibs.map!( q{ format("-l%s", a) } ).join(" ");
    string staticDecls = depLibs.map!(libForName).join(" ");
    writeln(libDecls);
    string buildCmd = "gcc -o %s -m32 %s %s" .format( prog, libDecls, staticDecls); 
    writeln(buildCmd);
  };
};

string libForName( string s ) { return "lib%s.o".format( s ); };

void buildLibs(string[] libs, bool makeLibs = true) {
  foreach( string lib ; libs ) {
    auto objName = libForName(lib);
    auto srcName = "%s.d".format(lib);
    auto libName = "%s.a".format(lib);
    auto cmd = "dmd -I. -c -of%s %s".format( objName, srcName);
    writefln(cmd);
    shell(cmd);
    if ( makeLibs) {
      auto libCmd = "ar rc %s %s".format( libName, objName);
      writefln(libCmd);
      shell(libCmd);
      auto ranLib = "ranlib %s".format( libName);
      writefln(ranLib);
      shell(ranLib);
    }
  };
};

