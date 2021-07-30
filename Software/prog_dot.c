void string_uart(char*);
int mod(int,int);
int divd(int,int);
int mult_(int,int);
void int_string(char str[], int num);

void _start()
{
	volatile int y[5]={3,4,6,7,8};
    volatile int x[5]={8,9,10,11,12};
    volatile int z[5]={0};
    volatile int h=0;
    char str_h[5];

    

     for(int i=0;i<5;i++){          
        
      z[i] = mult_(x[i],y[i]);
        
      h = h + (z[i]);
        
    }

    int_string(str_h,h);

    string_uart("\n\n|===========================================|\n");
    string_uart("\tWELCOME TO RISC-V TERMINAL!");
    string_uart("\n|===========================================|\n\n\n");
    string_uart("\tResult of dot product is ");
    string_uart(str_h);
    string_uart("\n\n\n");
    string_uart("|===========================================|\n");
    string_uart("\tThankyou for being here.\n");
    string_uart("|===========================================|\n\n");

    //End of transmission
    volatile int *ptr  = (volatile int*)0x108; 
    int EOT = 04;
    *ptr =  EOT;

     while(1);
}


void string_uart(char* str){
volatile char* tx = (volatile char*) 0x108;
  while (*str) {
  	*tx = *str;
  	str++;
  }
}
int mult_(int a,int b){ // a / b
    int count = 0;
    for (int j=0; j<b ; j++)
          {
            count = count + a;
          }
    return count;
}


int mod(int a,int b){ // a % b
    while (a>=b){
        a-=b;
    }
    return a;
}
int divd(int a,int b){ // a / b
    int count = 0;
    while (a>=b){
        a-=b;
        count++;
    }
    return count;
}

void int_string(char str[], int num){
    int i, rem, len = 0, n;
    n = num;
    while (n != 0)
    {
        len++;
        n = divd(n,10);
    }
    for (i = 0; i < len; i++)
    {
        rem = mod(num,10);
        num = divd(num,10);
        str[len - (i + 1)] = rem + '0';
    }
    str[len] = '\0';
}