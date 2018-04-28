/*****************************************************
Chip type               : ATmega64A
Program type            : Application
AVR Core Clock frequency: 16,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 1024
*****************************************************/

#include <mega64a.h>
#include <delay.h>

#define A           (PINE.5==1)
#define LEFT        (PIND.5==0)
#define RIGHT       (PIND.4==0)
#define TASK_MAX    300
#define REF_PLUS    PORTD&=~(1<<7);
#define REF_MINUS   PORTD|=(1<<7);
#define FEED_MAX    999
#define FEED_MIN    0
#define FEED_UP     (PIND.2==0)
#define FEED_DOWN   (PIND.3==0)
#define FEED_STEP   10 
#define JOG_PLUS    (PIND.0==0)
#define JOG_MINUS   (PIND.1==0)
#define JOG_RAPID   (PIND.6==0)
#define SPEED_RAPID 512
#define SPEED_WORK  256


static flash unsigned char digit[]={
    0b00111111, //0
    0b00000110, //1
    0b01011011, //2
    0b01001111, //3
    0b01100110, //4
    0b01101101, //5
    0b01111101, //6
    0b00000111, //7
    0b01111111, //8
    0b01101111  //9
};
char enable = 0;
float set_position = 0;
long int current_position = 0; 
float feed = 0;
eeprom int feed_eep;


void sem_seg(int a);//show feed value
void init(void);
interrupt [EXT_INT4] void ext_int4_isr(void);//set position from spindel's encoder
interrupt [EXT_INT6] void ext_int6_isr(void);//current position from axis's encoder
void move(long int task);
void buttons(void);


void main(void)
{
    init();
    feed = feed_eep/100;
    sem_seg(feed_eep);
    
    while(1)
    {   
        if(LEFT || RIGHT){
            enable = 1;                    
            while(LEFT || RIGHT){
                move(set_position - current_position);
                buttons();            
            }     
            move(0);
            enable = 0;
            delay_ms(100);
            current_position = 0;         
            set_position = 0;
        }
        
        if(JOG_PLUS || JOG_MINUS){
            #asm("cli")
            if(JOG_PLUS){
                REF_PLUS
            }else {
                REF_MINUS
            }
            while(JOG_PLUS || JOG_MINUS){
                if(JOG_RAPID){
                    move(SPEED_RAPID);
                }else {
                    move(SPEED_WORK);
                }
            }              
            current_position = 0;         
            set_position = 0;  
            #asm("sei")
        }
        
        buttons();               
        move(set_position - current_position);
    }
}
//----------------------------------------------------
//
//----------------------------------------------------
void buttons(void)
{
    static float feed_show = 0;
    static char num = 1;
    if(num){
        feed_show = feed_eep;
        num = 0;
    }
    
    if(FEED_UP){
        feed_show += FEED_STEP;
        if(feed_show>FEED_MAX)
            feed_show = FEED_MAX;
        feed = feed_show/100;
        sem_seg(feed_show);
        delay_ms(200);
        feed_eep = feed_show;
     }
     if(FEED_DOWN){
        feed_show -= FEED_STEP;
        if(feed_show<FEED_MIN)
            feed_show = FEED_MIN;
        feed = feed_show/100;
        sem_seg(feed_show);
        delay_ms(200);
        feed_eep = feed_show;
     }       
}
//----------------------------------------------------
//
//----------------------------------------------------
void sem_seg(int a)
{
    PORTC = digit[a%10];
    PORTB = digit[(a%100)/10];
    PORTA = digit[(a%1000)/100];
}
//----------------------------------------------------
//
//----------------------------------------------------
void move(long int task)
{
    if(task>0){
        REF_PLUS        
    }
    if(task<0){
        REF_MINUS
        task *= -1;
    }
    if(task>TASK_MAX)
        task = TASK_MAX;
    
    PORTF = task;
    task = (task>>8);
    PORTG = task;   
}
//----------------------------------------------------
//
//----------------------------------------------------
interrupt [EXT_INT6] void ext_int6_isr(void)
{
    if(enable){
        if(RIGHT){
            set_position += feed/2.5;
        }
        if(LEFT){
            set_position -= feed/2.5;
        }
    }
}
//----------------------------------------------------
//
//----------------------------------------------------
interrupt [EXT_INT4] void ext_int4_isr(void)
{
        if(!A){
            current_position++;
        }else {
            current_position--;
        }      
}
//----------------------------------------------------
//
//----------------------------------------------------
void init(void)
{    
    PORTA=0b00000000;
    DDRA=0x7F;
 
    PORTB=0x00000000;
    DDRB=0x7F;

    PORTC=0b00000000;
    DDRC=0x7F;
 
    PORTD=0b01111111;
    DDRD=0b10000000;
 
    PORTE=0xFF;
    DDRE=0x00;
 
    PORTF=0x00;
    DDRF=0xFF;
 
    PORTG=0x00;
    DDRG=0x03;

    // Timer/Counter 1 initialization
    // Clock source: System Clock
    // Clock value: 65,500 kHz
    // Mode: Normal top=0xFFFF
    // Input Capture on Falling Edge
    // Timer1 Overflow Interrupt: On
    TCCR1A=0x00;
    TCCR1B=0x00;//0x04
    TCNT1H=0x00;
    TCNT1L=0x00;
    ICR1H=0x00;
    ICR1L=0x00;
    OCR1AH=0x00;
    OCR1AL=0x00;
    OCR1BH=0x00;
    OCR1BL=0x00;
    OCR1CH=0x00;
    OCR1CL=0x00;

    // Timer/Counter 3 initialization
    // Clock source: T3 pin Rising Edge
    // Mode: CTC top=OCR3A
    // Input Capture on Falling Edge
    // Compare A Match Interrupt: On
    TCCR3A=0x00;
    TCCR3B=0x00;
    TCNT3H=0x00;
    TCNT3L=0x00;
    ICR3H=0x00;
    ICR3L=0x00;
    OCR3AH=0x00;
    OCR3AL=0x00;
    OCR3BH=0x00;
    OCR3BL=0x00;
    OCR3CH=0x00;
    OCR3CL=0x00;

    // External Interrupt(s) initialization 
    // INT0: Off 
    // INT1: Off 
    // INT2: Off 
    // INT3: Off 
    // INT4: On 
    // INT4 Mode: Rising Edge 
    // INT5: Off 
    // INT6: On 
    // INT6 Mode: Rising Edge 
    // INT7: Off 
    EICRA=0x00; 
    EICRB=0x33; 
    EIMSK=0x50; 
    EIFR=0x50;

    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK=0x00;

    ETIMSK=0x00;

    #asm("sei")            
}
//----------------------------------------------------
//
//----------------------------------------------------