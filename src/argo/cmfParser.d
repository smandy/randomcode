#!/usr/bin/env rdmd

import std.stdio;
import std.array;
import std.typecons;
import std.algorithm;

import std.string : format;

Tuple!(char[], char[]) splitEqual( char[] s ) {
  return tuple(s, s);
};

enum ResponseType { INVALID, ACK, FILL, REJECT, DONEFORDAY, CANCELLED };

immutable auto HAVE_TYPE        = 1 << 0;
immutable auto HAVE_ID          = 1 << 1;
immutable auto HAVE_LASTSHARES  = 1 << 2;
immutable auto HAVE_LASTPX      = 1 << 3;
immutable auto REJECT_PRESENCE = HAVE_LASTPX | HAVE_LASTSHARES | HAVE_TYPE;

// pragma(msg, format("id = %s", HAVE_ID) );
// pragma(msg, format("ls = %s", HAVE_LASTSHARES ) );
// pragma(msg, format("reject = %s", REJECT_PRESENCE));

class Response {
  long          timeStamp;
  ResponseType  responseType;
  int           lastShares;
  double        lastPx;
  string        orderId;
  string        origOrderId;
};
 
Response parseRaw( char[] line) {
  //writefln("Parse %s sw=%s ew=%s", line,line[0], line[$-1] );
  auto bits = line.split(":");
  Response response = new Response();
  foreach ( bit ; bits ) {
    auto splitPoint = bit.countUntil('=');
    //writefln("%s %s", bit , splitPoint);
    auto tag   = bit[0..splitPoint];
    auto value = bit[splitPoint+1..$];
    switch (tag) {
    case "mt" : {
      writefln("Woohoo got message type %s" , value); 
      switch (value) {
      case "f" : {
        writefln("Fill");
        response.responseType = ResponseType.FILL;
        break;
      };
      case "o" : {
        writefln("Ack");
        response.responseType = ResponseType.ACK;
        break;
      };
      case "j" : {
        writefln("Reject");
        response.responseType = ResponseType.REJECT;
        break;
      };
      case "x" : {
        writefln("Cancelled");
        response.responseType = ResponseType.CANCELLED;
        break;
      };
      default:
        break;
      };
      break;
    };
    default:
      break;
    };
  };
  return response;
};  

void main( string[] args ) {
  //writefln("Woohoo");
  auto fn = "/home/andy/Downloads/20100505_prodWavestream_0.cmf";
  auto i = 0;
  auto lines = 0;
  auto f = File(fn);

  auto wellKnownTypes = [ResponseType.ACK, ResponseType.CANCELLED];

  foreach ( line ; f.byLine() ) {
    if (i == 10) break;
    if (line[0..4]==">>> " ) {
      auto rest = line[4..$]; 
      auto resp = parseRaw( rest[rest.countUntil(':')+1..$-1] );
      writefln("Parsing.. %s %s", lines, resp.responseType);
      if ( wellKnownTypes.countUntil(resp.responseType) == -1 ) {
        writefln("Type is %s", resp.responseType);
        i += 1;
      }
    };
    lines += 1;
  };
};