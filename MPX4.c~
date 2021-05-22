#include "MPX4.h"

 int numbers[16]={
                   0X3F , 0X06 , 0X5B , 0X4F , 
                   0X66 , 0X6D , 0X7D , 0X07 , 
                   0X7F , 0X6F , 0X77 , 0X7C ,
                   0X39 , 0X5E , 0X79 , 0X71
                 };  

int digit[4]= {112,176,208,224};
int i1,j1;

//////////////////////////////////////
void counter(int first, int last)
{   

    for(i1 = first ; i1<=last ; i1++)
    {  j1=0;
    
       while(j1<25){  
          j1++; 
          PORTB = digit[0];
          PORTC=numbers[i1%16];
          delay_ms(2); 
         
          PORTB = digit[1];
          PORTC=numbers[i1/16]; 
          delay_ms(2);
         }
        
    }

}

//////////////////////////////////////////
void first_show(int first , int last)
{
  int show = last;
  int a = 0;
    
    j1=0;
    
    while(j1<40){  
       j1++; 
         for(i1=0 ; i1<4 ; i1++){
         
            PORTB = digit[i1];
            PORTC=numbers[show%16]; 
            show/=16;
            delay_ms(2);
             
            if(show==0 && a)
            {
              show=last; 
              a = 0;
            }  
            
            if(show==0 &&!a)
            {   
              show=first; 
              a = 1;
            }
         
         }
    } 

}