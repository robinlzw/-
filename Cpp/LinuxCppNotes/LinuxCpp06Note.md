# 数组整体作为函数形式参数

1.数组整体作为函数形式参数
2.基本格式：返回值类型  函数名称( 元素类型  数组名称[],  元素个数类型  元素个数 )
示例：void GenerateIntegers( int a[], unsigned int n );
特别说明：作为函数形式参数时，数组名称后的中括号内不需列写元素个数，必须使用单独的参数传递元素个数信息



# 数组作为函数参数

1.直接书写变量：错误！

/* 元素元素个数不允许为量 */
void GenerateIntegers( int a[n], int lower, int upper )
{
  ……
}



2.调用格式
1).使用单独数组名称作为函数实际参数，传递数组基地址而不是数组元素值
2).形式参数与实际参数使用相同存储区，对数组形式参数值的改变会自动反应到实际参数中
#define  NUMBER_OF_ELEMENTS  8
const int lower_bound = 10;
count int upper_bound = 99;
int a[NUMBER_OF_ELEMENTS];
GenerateIntegers( a, NUMBER_OF_ELEMENTS, lower_bound, upper_bound);