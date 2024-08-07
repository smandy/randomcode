import std.math;

struct Mousey {
  static immutable float PI      = 3.14159;
  static immutable float HALF_PI = PI / 2.0;
  static immutable float DEGREE  = PI / 180.0;

  float direction;

  float x;
  float y;

  this(float x_, float y_, float direction_ = 0.0f ) {
    x = x_;
    y = y_;
    direction = direction_;
  }

  void move( float l ) {
    x += l * cos(direction);
    y += l * sin(direction);
  };

  void turn( float angle) {
    direction += angle;
  };

  float getX() { return x; };
  float getY() { return y; };
};
