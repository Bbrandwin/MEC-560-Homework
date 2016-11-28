#ifndef __MY_STRUCT_H__
#define __MY_STRUCT_H__

#include <stdint.h>

/* 
  This next lines declare the structure.
  the packed and aligned attributes make sure the structure
  is aligned to 8 bit boundaries.
  
  Take into account this silicon includes a 32 bit processor.
*/
typedef struct my_struct {
  float   accXData;
  float   accYData;
  float   accZData;

  float   GVector[3];
  float   pitchData;
  float   rollData;

  //uint8_t   Count;
} my_struct_t  __attribute__ ((packed, aligned (1)));


#endif  /* __MY_STRUCT_H__*/

