import std.meta;
import std.typecons;
import std.stdio;

class Pipeline(Traits) {
    Traits.TupleType data;
    this(Traits.Args args) {
        data = Traits.TupleType(args);
        writefln("Twoot");
        writefln("%s", data);
    }
}

struct Component {
}

struct Foo {
    Tuple!(int,int) xs;
    this(Tuple!(int,int) xs) {
        writefln("Foo ctor %s", xs);
        this.xs = xs;
    }
}

struct Bar {
    Tuple!(float,float) xs;
    this(Tuple!(float,float) xs) {
        writefln("Foo ctor %s", xs);
        this.xs = xs;
    }
}

void main() {
    struct Traits {
        alias TupleType = Tuple!(Foo,Bar);
        alias Args = Tuple!(Tuple!(int,int),
                            Tuple!(float,float));
    }
    alias PLT = Pipeline!Traits;

    PLT foo = new PLT( tuple( tuple(10,20), tuple(23.0f, 24.0f)) );
    auto xs = tuple( tuple(10,20), tuple(23.0f, 24.0f));
    auto xs2 = xs.expand;
    pragma(msg, "arr", typeof(xs));
    writefln("%s", foo.data[0]);
    
    template AppendFoo(TupleType) {
        pragma(msg, "AppendFoo ", TupleType);
        alias AppendFoo = Tuple!(Foo, TupleType.Types);
        pragma(msg, "AppendFooRet  ", AppendFoo);
    }

    alias OrigTypes = AliasSeq!( Tuple!(int, int), Tuple!(float,float));
    alias NewTypes = Tuple!(staticMap!(AppendFoo, OrigTypes));
    
    Foo f;
    pragma(msg, "NewTypes ", NewTypes);
    NewTypes s = tuple( tuple(f,1,1), tuple(f, 2.0, 3.2));
    // Bingo

    Tuple!(int,int,int) xs3 = tuple(1,2,3);
    writeln(xs3);
}
