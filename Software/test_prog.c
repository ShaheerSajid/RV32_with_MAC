int mac_asm(int, int);
void string_uart(char*);
int mod(int,int);
int divd(int,int);
int mult_(int,int);
void int_string(char str[], int num);

void _start()
{
  	volatile int A[4]={1,2,3,4};
    volatile int B[6]={5,6,7,8,9,10};
    
    volatile int lenA=4;
    volatile int lenB=6;
    volatile int lenC=lenA + lenB -1;
    volatile int i1;

    volatile int C[9]={0};
    volatile int tmp=0;


    char out_str_temp[5];
    


    int a = 2, b = 3,c=2;
    a =  mac_asm(a, b);
    int_string (out_str_temp,a);
    string_uart("\nMac Result: \n");  
//    c = mult_(c,b); // a * b
//    c = mult_(c,b); // a * b
//    c = mult_(c,b); // a * b
//    c = mult_(c,b); // a * b
    string_uart(out_str_temp);
    string_uart(" "); 
    string_uart("I"); 
    string_uart(" "); 
    string_uart("A"); 
    string_uart("M"); 
    string_uart(" "); 
    string_uart("D"); 
    string_uart("O"); 
    string_uart("N"); 
    string_uart("E"); 
    

//    a =  mac_asm(a, b);
//  int_string (out_str_temp,a);
//   string_uart("\n");   
//    string_uart("\nMac Result: \n");   
//    string_uart(out_str_temp);


//    a =  mac_asm(a, b);
//   int_string (out_str_temp,a);
//   string_uart("\nMac Result: \n");   
//    string_uart(out_str_temp);



    //End of transmission
    volatile int *ptr  = (volatile int*)0x108; 
    int EOT = 04;
    *ptr =  EOT;

     while(1);
}

//__attribute__((noinline))
int mac_asm(int a, int b) {
    asm __volatile__ (".word 0x80B50533\n");    // mac a0,a0,a1
   // asm __volatile__ (".word 0x00b50533\n");  // add a0,a0,a1
    //asm __volatile__ (".word 0x00050533 \n");   // add a0,a0,x0
    asm __volatile__ ("sw	a0,-20(s0)\n");
    
    //asm __volatile__ ("add a0, a0, a1\n");
    //a = a+b;
    //a = a + mult_(a,b);
    return a;
}

void string_uart(char* str){
volatile char* tx = (volatile char*) 0x108;
  while (*str) {
  	*tx = *str;
  	str++;
  }
}

int mult_(int a,int b){ // a * b
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
