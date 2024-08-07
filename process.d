#!/usr/bin/env rdmd

struct Foo(alias Prev, alias Next) {
    void receiveFromLeft() {
    };
};

struct Bar(alias Prev, alias Next) {
    void sendToRight(alias Message, alias Context)(ref Message msg, ref Context context) {
    };
};

struct Component(T) {
};

template(typename TS...) Chain {
};

void main() {

};


