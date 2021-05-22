#include "Keypad.h"

extern int i,j,flag;
extern int b0,b1,b2;
extern char ch[];
extern int nu[16];

char F1(int num){
    for (i=0;i<16;i++){
        if (num==nu[i]){
            return ch[i];
        }
    }    
}

int start(){
        PORTD.0=0;
        PORTD.1=1;
        PORTD.4=1;
        PORTD.5=1;
        if (b0==1 || b1==1 || b2==1)
        return 14;
        //////--------------
        PORTD.0=1;
        PORTD.1=0;
        PORTD.4=1;
        PORTD.5=1;
        if (b0==1 || b1==1 || b2==1)
        return 13;
        //////--------------
        PORTD.0=1;
        PORTD.1=1;
        PORTD.4=0;
        PORTD.5=1;
        if (b0==1 || b1==1 || b2==1)
        return 11;
        //////--------------
        PORTD.0=1;
        PORTD.1=1;
        PORTD.4=1;
        PORTD.5=0;
        if (b0==1 || b1==1 || b2==1)
        return 7;
        

}


void Fj(int j){
      if (j>=0){
            i=0;
            i=j;
            j=-1;
      }
      delay_ms(5);
}

void Fch(int count){
        flag=0;
        if (count==14){
            if (b0==1 && b1==1){
                j=flag;
                b0=0;
                b1=0;
                Fj(j);
                return;
            }
            else if (b0==1){
                j=flag+1;
                b0=0;
                Fj(j);
                return;
            }
            else if (b1==1){
                j=flag+2;
                b1=0;
                Fj(j);
                return;
            }
            else if (b2==1){
                j=flag+3;
                b2=0;
                Fj(j);
                return;
            }
        }
        
        else if (count==13){
            flag=4;
            if (b0==1 && b1==1){
                j=flag;
                b0=0;
                b1=0;
                Fj(j);
                return;
            }
            else if (b0==1){
                j=flag+1;
                b0=0;
                Fj(j);
                return;
            }
            else if (b1==1){
                j=flag+2;
                b1=0;
                Fj(j);
                return;
            }
            else if (b2==1){
                j=flag+3;
                b2=0;
                Fj(j);
                return;
            }
        }
        else if (count==11){
            flag=8;
            if (b0==1 && b1==1){
                j=flag;
                b0=0;
                b1=0;
                Fj(j);
                return;
            }
            else if (b0==1){
                j=flag+1;
                b0=0;
                Fj(j);
                return;
            }
            else if (b1==1){
                j=flag+2;
                b1=0;
                Fj(j);
                return;
            }
            else if (b2==1){
                j=flag+3;
                b2=0;
                Fj(j);
                return;
            }
        }
        
        else if (count==7){
            flag=12;
            if (b0==1 && b1==1){
                j=flag;
                b0=0;
                b1=0;
                Fj(j);
                return;
            }
            else if (b0==1){
                j=flag+1;
                b0=0;
                Fj(j);
                return;
            }
            else if (b1==1){
                j=flag+2;
                b1=0;
                Fj(j);
                return;
            }
            else if (b2==1){
                j=flag+3;
                b2=0;
                Fj(j);
                return;
            }
        }
}