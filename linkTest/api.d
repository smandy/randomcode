

extern(C)  {

  struct meta {
    int x;
  };

  int  gwCallback(  meta *ptr, const char *msg);
  
  int sendOrder( meta *ptr, const char * order, int function(meta *, const char *));
};