#!/usr/bin/env rdmd

import std.stdio;
import std.socket;
import core.thread;

import core.time : dur, Duration;

void main() {
    ubyte[1024] buf;
    
    auto sender = new UdpSocket();
    //auto address = new InternetAddress( "239.255.1.2", 2055);
    auto address = new InternetAddress( "127.0.0.1", 2055);

    
    sender.connect(address);
    //sender.listen(10);

    auto msg = "Hello World!";
    while (true) {
        auto x = sender.send( msg);
        writefln("Sent %s", x);
        Thread.sleep(dur!"msecs"(500));
    };
};
