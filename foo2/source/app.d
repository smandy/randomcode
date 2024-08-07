import std.stdio;
import std.range;

void main()
{
	writeln("This is a fast turnaround");
	foreach( q,v ; iota(0,10).map!"a*a*a"().array) {
	  writefln( "%s %s", q,v);
	}
}
