#!/usr/bin/env rdmd

import std.stdio;
import std.string;
import std.range;
import std.algorithm;
import std.typecons;
import std.conv;

import goo;

void main( string[] args ) {
  writefln("%s\n", args.join(","));
  //writefln(" I am here ");
  writefln("%s\n", add(5,4) );
  writefln("%s\n", map!("a*a")(iota(1,10)));
  int[string] wc;
  auto f = File( args[1], "r");
  foreach ( string s ; lines(f) ) {
    foreach ( string word ; s.split() ) {
      writefln("s is  %s", word);

      if (word in wc) {
	wc[word] += 1;
      } else {
	wc[word] = 1;
      } 
    }
  };

  foreach (q,v ; wc ) {
    writefln( "%s %s" , q, v);
  };

  auto colors = ["foo" : 1 , 
		 "bar" : 2 ];

  foreach ( q,v ; colors ) { 
    writefln("%s %s", q, v);
  };

  //auto foos = map!("a")(wc);
  auto x = [ 1 : [ tuple( 3 , "foo" ), 
		   tuple( 5 , "goo" ),
		   tuple( 4 , "bar" )  ],
	     2 : [ tuple( 3 , "bar" )  ] ];
  writefln( "tup is %s %s" , x, typeof(x).stringof );
  foreach (q,v ; x ) {
    foreach ( tup ; v ) {
      writefln("%s has a tup of %s %s %s", q, tup, tup[0], tup[1]);
    };
  };
};
