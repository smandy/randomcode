// gdc -o dsfml dsfml.d -I/home/.../Derelict2/import -L/home/.../Derelict2/lib -ldl -lDerelictSFMLGraphics -lDerelictSFMLWindow -lDerelictSFMLSystem -lDerelictUtil

import derelict.sfml.graphics;
import derelict.sfml.window;
import derelict.sfml.system;

int main()
{   
   DerelictSFMLGraphics.load();
   DerelictSFMLWindow.load();
   DerelictSFMLSystem.load();
   
   sfEvent event;
   sfWindowSettings Setting = {24,8,0};
   sfVideoMode Mode = {800,600,32};
   
   sfRenderWindow *App = sfRenderWindow_Create(Mode,"SFML Graphics",sfResize|sfClose,Setting);
   
   //sfShape *ball = sfShape_CreateCircle(50,50,10,sfColor(0,150,0),2,sfColor(150,0,0));
   //sfShape_SetPosition(ball,50,50);
   
   auto x = 50,y = 50;

   while(App.sfRenderWindow_IsOpened())
   {
      while(App.sfRenderWindow_GetEvent(&event))
      {
         if(event.Type == sfEvtClosed)
         {
            App.sfRenderWindow_Close();
            break;
         }
      }
      sfShape *ball = sfShape_CreateCircle(x,y,10,sfColor_FromRGBA(0,150,0,255),2,sfColor_FromRGBA(0,0,0,255));
      sfRenderWindow_Clear(App,sfColor(0,0,100));
      sfRenderWindow_DrawShape(App,ball);
      sfRenderWindow_Display(App);
      x += 2;
      y += 2;
      sfSleep(.002);
   };
   
   return 0;
}