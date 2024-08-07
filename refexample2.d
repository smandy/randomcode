import std.stdio;

void f(int* a){
    writeln("A");
}
void f(const(int)* b){
    writeln("B");
}

void main(){
    f(new immutable(int)); // guess what this prints. :)
}
