void string_uart(char*);
int mod(int,int);
int divd(int,int);
int mult_(int,int);
int abs_func(int);
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
    


	for (int i=0; i<lenC; i++)
	{
		i1 = i;
		tmp = 0;
		for (int j=0; j<lenB; j++)
		{
			if(i1>=0 && i1<lenA)
				tmp = tmp + mult_(A[i1],B[j]);

			i1 = i1-1;
			C[i] = tmp;
		}
	}



    string_uart("\n\n|===============================================|\n");
    string_uart("\t   WELCOME TO RISC-V TERMINAL!");
    string_uart("\n|===============================================|\n\n\n");

    string_uart("  Vector 'A', Size = 4\n\t[ ");
    for (int i = 0; i< lenA; i++)
      {
        int_string (out_str_temp,A[i]);
        string_uart(out_str_temp);
        string_uart(" ");           
      }
    string_uart("]\n\n");

    string_uart("  Vector 'B', Size = 6\n\t[ ");
    for (int i = 0; i< lenB; i++)
      {
        int_string (out_str_temp,B[i]);
        string_uart(out_str_temp);
        string_uart(" ");
                
      }
    string_uart("]\n\n");

    string_uart("  RESULT OF CONVOLUTION - Vector 'C', Size = 9\n\t[ ");
    for (int i = 0; i< lenC; i++)
      {
        int_string (out_str_temp,C[i]);
        string_uart(out_str_temp);
        string_uart(" ");
                
      }
    string_uart("]");

    string_uart("\n\n\n");
    string_uart("|===============================================|\n");
    string_uart("\t   Thankyou for being here.\n");
    string_uart("|===============================================|\n\n");

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
int mult_(int a,int b){ // a * b
    int count = 0;
    for (int j=0; j<b ; j++)
          {
            count = count + a;
          }


    int ret_num;
    if( a<0 || b<0 )
      {
        ret_num = -(count);
      }
    else if ((a>=0 && b>=0 ) ||(a<0 && b<0))
      {
        ret_num = count;
        }


    return ret_num;


}




int mod(int num, int divisor)
{ //a%b

    int quotient = divd(num,divisor);
    int product = mult_(divisor,quotient);
    return (num - product);
}


int divd(int a,int b){ // a / b
    int count = 0;
    while (a>=b){
        a-=b;
        count++;
    }

    int ret_num;
    if( a<0 || b<0 )
      {
        ret_num = -(count);
      }
    else if ((a>=0 && b>=0 ) ||(a<0 && b<0))
      {
        ret_num = count;
        }


    return ret_num;
}




int abs_func(int num){
    
    int ret_num;
    if(num<0)
      {
        ret_num = -(num);
      }
    else 
      {
        ret_num = num;
        }
    
    return ret_num;
    
}

void int_string(char str[], int num1){
    int i, rem, len = 0, n;

    int num ;
    num = abs_func(num1);
    
    n = num;
    
    while (n != 0)
    {
        len++;
        num = divd(num,10);
    }
    for (i = 0; i < len; i++)
    {
        rem = mod(num,10);
        num = divd(num,10);
        str[len - (i + 1)] = rem + '0';
    }

    str[len] = '\0';
    
    if (num1<0){
        for(int j = 1; j <= len; j++){
            str[j] = str[j-1];
        }
        str[0] = '-';
    }
}
