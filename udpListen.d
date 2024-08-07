#!/usr/bin/env rdmd

import std.stdio;
import std.socket;
import std.conv;

void main() {
    char[1024] buf;
    
    auto listener = new UdpSocket();
    auto address = new InternetAddress( "239.255.1.2", 2055 );
    
    listener.bind(address);
    //listener.listen(10);
    while (true) {
        auto x = listener.receive( buf );
        writefln("Got %s %s", x, buf[0..x]);
    };
};
