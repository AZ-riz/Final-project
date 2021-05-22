#include "LCD.h"
#include "MPX4.h"
#include "Keypad.h"

char ch[]="978A645B312CEF0D",ch01,ch10;
int nu[16]={0x09,0x07,0x08,0x0A,0x06,0x04,0x05,0x0B,0x03,0x01,0x02,0x0C,0x0E,0x0F,0x00,0x0D};




int count=-1,n1,n2,n3,n4;
int tempZF_Z=0,tempZF_F=0,tempFZ_Z=0,tempFZ_F=0;
int ZF=0x0F,FZ=0x1E,MAX=0x00,MIN=0xFF,flagFZ=0,flagZF=0;
int b0=0,b1=0,b2=0;
int i=-1,j=-1,flag,x=0,y=0,k=0;
int r1=0,r0=0;
int ra1=0,ra0=0,rf=0,t=0;
int len=0,boo1=0;

/////////////main///////////
void main(void)
{
lcd_init(16);
GICR=(1<<INT0 | 1<<INT1 | 1<<INT2);
MCUCR=(1<<ISC00) | (1<<ISC01 | 1<<ISC10) | (1<<ISC11);
MCUSR=(1<<ISC2);
GIFR=(1<<INTF0 | 1<<INTF1 | 1<<INTF2);
DDRA=0xff;
DDRB.4=1;
DDRB.5=1;
DDRB.6=1;
DDRB.7=1;
DDRD=0B00110011;
DDRC=0xff;
PORTD.2=1;
PORTD.3=1;
PORTD.6=1;
PORTD.7=1;
#asm("sei")

    while (1)
    {   
        t+=1;
        while(r1==0){
            if (boo1==0){
            count=start();
                if(b1==1 || b0==1 || b2==1)
                    Fch(count);
                if (i>=0){
                    show(i);
                    ra1=nu[i];
                    i=-1;
                    r1=1;
                }
                count=-1;
            }
            else if (boo1==1){
            count=-1;
            i=-1;
            boo1=0;
            }
            else if (boo1==2){
            count=-1;
            i=-1;
            boo1=0;
           
            }
        }
       /////ragham 10 
       while(r0==0){
       count=start();
            if(b1==1 || b0==1 || b2==1)
                Fch(count);
            if (i>=0){
                show(i);
                ra0=nu[i];
                r0=1;
                i=-1;
            }
       count=-1;
       }
       //////ragham 01
       if(r1==1 && r0==1){
            tempZF_Z=ZF/16;
            tempZF_F=ZF%16;
            tempFZ_F=FZ/16;
            tempFZ_Z=FZ%16;
            
            if (ra1 % 2 == 0 && ra1 >= tempZF_Z){
                if (ra0 % 2 == 1 && ra0 <= tempZF_F){
                    rf=0;
                    rf=ra1*16;
                    rf=rf + ra0;
                    ZF=rf;
                    flagZF=1;
                        
                           
                }
            }
            else if (ra1 % 2 == 1 && ra1 >= tempFZ_F){
                if (ra0 % 2 == 0 && ra0 <= tempFZ_Z){
                    rf=0;
                    rf=ra1*16;
                    rf=rf+ra0;
                    FZ=rf;
                    flagFZ=1;
                }
            }
            rf=0;
            rf=ra1*16;
            rf=rf+ra0;
            if (rf > MAX){
            MAX=rf;
            }
            if (rf<MIN){
            MIN=rf;
            }
       }
       ///////ZF & FZ & MAX & MIN 
       if(r1==1 && r0==1){
            r1=0;
            r0=0;
            lcd_gotoxy(x,y);
            lcd_putchar('-');
            if (x==15 && y==1){
                lcd_clear();
                y=-1;
                x=0;
            }
            if (x==15){
                x=-1;
                y+=1;
            }
            x++;
            delay_ms(100); 
            }
        if (t>=4)
        delay_ms(300);    
        if (PIND.6==0){
            lcd_clear();
            x=0;
            y=0;
            if(flagZF==1){
            sh_FZ(ZF);
            x++; 
            }
            else{
            lcd_gotoxy(x,y);
            lcd_puts("None");
            x+=4;
            }
            lcd_putchar('-');
            x++;
            if(flagFZ==1){
            sh_FZ(FZ);
            x++;
            }
            else{
            lcd_gotoxy(x,y);
            lcd_puts("None");
            x+=4;
            }
            boo1=2;
            lcd_gotoxy(x,y);
            lcd_putchar('/');
            x++;
                
        }
        if (t>=4)
        delay_ms(300);
        if(PIND.7==0){
        
            DDRC =0xff;
            DDRB = 0XF0 ;
            PORTB = 0;
            
            first_show(MIN,MAX);
            counter(MIN,MAX);
            
            PORTB = 0XF4;
            MIN=0XFF;
            MAX=0X00;
            lcd_clear();
            x=0;
            y=0;
            if(boo1!=2)
            boo1=1;
            
        }
            
        
    }
}

