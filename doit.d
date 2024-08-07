#!/usr/bin/env rdmd

import std.stdio;
import std.file;

void main(string[] args) {
  writeln(args);
  writeln( dirEntries(args[1], SpanMode.shallow));
};