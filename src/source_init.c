// RegisteringDynamic Symbols

#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>


#define CALLDEF(name, n)  {#name, (DL_FUNC) &name, n}

static const R_CallMethodDef R_CallDef[] = {
  CALLDEF(printf, 1),
  {NULL, NULL, 0}
};
void R_init_testproject(DllInfo* info) {
  R_registerRoutines(info,  NULL,R_CallDef, NULL, NULL);
  R_useDynamicSymbols(info, TRUE);
  //R_useDynamicSymbols(info, FALSE);
  R_forceSymbols(info, TRUE);
 
  }

