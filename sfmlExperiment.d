
import derelict.sfml.system;
import std.stdio;

pragma(lib, "DerelictSFMLSystem.lib");

/// export LD_LIBRARY_PATH=/home/andy/build/SFML-1.6/CSFML/lib

void main()
{

  DerelictSFMLSystem.load();

  auto clock = sfClock_Create();

  writefln("Clock is %s", sfClock_GetTime(clock));
  
    // sf::Clock Clock;
    // while (Clock.GetElapsedTime() < 5.f)
    // {
    //     std::cout << Clock.GetElapsedTime() << std::endl;
    //     sf::Sleep(0.5f);
    // }

    // return 0;
}
