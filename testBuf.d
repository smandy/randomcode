import std.stdio;
import ringbuffer;

void main() {
  struct Point { 
    int x; 
    int y; 
  };

  struct Line { 
    Point p1; 
    Point p2;
  };

  auto x = new CircularBuffer!(16,Line);

  Line myLine  = { { 2, 3 }, { 4 , 5 } };
  Line myLine2 = { { 6, 7 }, { 8 , 9 } };

  //writeln(myLine);
  x.enqueue( myLine);
  x.enqueue( myLine2);

  writeln( x.pop());
  writeln( x.pop());
};