import std.exception;
import std.traits;
import std.stdio;
import std.functional;
import std.algorithm;
import std.string;

template isPowerOfTwo(alias N) if ( isIntegral!(typeof(N)) ) {
    enum bool isPowerOfTwo = (N & (N - 1)) == 0;
};

template CircularBuffer(alias N, T, bool overwrite = true) if (isPowerOfTwo!N) {
    struct CircularBuffer {
        enum long MASK = N - 1;
        T[N] dat;
        long head, tail;

        ref T opIndex( long n ) {
            enforce( n >= head, format("Index out of bounds %s" , n ) );
            enforce( n <= tail, format("Index out of bounds %s" , n ) );
            return dat[n & MASK];
        }

        invariant() {
            //writefln("Checking invariants!");
            enforce( head - tail <= N);
            enforce( tail >= head );
        }

        @property bool empty() {
            return head==tail;
        }

        bool isFull() {
            //writefln("head %s tail%s N %s", head, tail, N);
            return tail - head == N;
        }

        int enqueue(T t) {
            static if ( overwrite) {
                if (isFull()) head++;
            } else {
                enforce(!isFull(), "Cant add to full queue");
            }
            dat[tail++ & MASK] = t;
            return 2;
        }

        @property T front() in {
            enforce(!empty , "Pop from empty queue");
        } body {
            return dat[head & MASK];
        }

        @property int size() {
            return cast(int)(tail - head);
        }

        T popFront() in {
            enforce(!empty, "Pop from empty queue");
        } body {
            T ret = front();
            head++;
            return ret;
        }

        void dump() {
            writefln("====================");
            for (int i=0;i<N;++i) {
                writefln( "%s : %s", i, dat[i]);
            }
            writeln("====================");
        }
    }
}

unittest {
    enum N = 16;
    enum OFFSET = 20;

    alias CircularBuffer!(N,int) Int16;
    //auto buf = new Int16(); /
    Int16 buf;
    for (int iters = 0;iters<10; ++ iters) {
        for (int i =0;i<N; ++i) {
            enforce( !buf.isFull());
            buf.enqueue( i + 20);
            enforce( !buf.empty);
            //buf.dump();
        }
        enforce(buf.isFull());
    
        for ( int i = 0;i<N;++i) {
            enforce(!buf.empty);
            auto x= buf.popFront();
            enforce( x == i + 20);
            enforce(!buf.isFull());
            //buf.dump();
        }
        enforce(buf.empty);
    }
    writeln("isIntgral 2 = ", isIntegral!string );

    auto x = [2,3].map!( (x) => {
            writefln("Queueing %s", x);
            return buf.enqueue(x);
        } )();
    writefln("X is %s", x);

    buf.enqueue(2);
    buf.enqueue(3);
    buf.dump();
    writeln();
    writefln("before sz is %s", buf.size);
    foreach( x2 ; buf) {
        writefln("x is %s", x2);
    }
    writefln("after sz is %s", buf.size);
}
