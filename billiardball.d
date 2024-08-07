import std.stdio;

private import derelict.sdl2.sdl;

template BilliardBall( int WIDTH, 
                       int HEIGHT,
                       int BORDER ) {
    struct BilliardBall {
        enum MINX = BORDER;
        enum MAXX = WIDTH - BORDER;
        enum MINY = BORDER;
        enum MAXY = HEIGHT - BORDER;

        Coord!(MINX, MAXX) x;
        Coord!(MINY, MAXY) y;

        @property SDL_Point point() {
            SDL_Point ret = { x.d, y.d};
            return ret;
        }

        void tick() {
            x.tick();
            y.tick();
        };

        @disable this();

        this( int x0, int y0, int vx, int vy) {
            x.d = x0;
            x.v = vx;
            y.d = y0;
            y.v = vy;
        };

        template Coord(alias MIN, alias MAX) {
            struct Coord {
                int d;
                int v;

                void tick() {
                    d += v;
                    if ( d > MAX || d < MIN) {
                        v = -v;
                    }
                }
            }
        }
    }
}

unittest {
    auto bb = new BilliardBall!( 800,600, 3)(400, 300, 4,-3);
    writeln( bb.point);
    for ( int i =0;i<200;++i) {
        bb.tick();
        writefln( "%s %s", i, bb.point);
    }
}
