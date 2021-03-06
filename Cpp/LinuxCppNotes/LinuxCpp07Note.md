# 指针的定义与使用

### 1.指针的定义格式

格式：目标数据对象类型 * 指针变量名称;
例一：定义 p 为指向整数的指针：int * p;
例二：定义 p 为指向结构体类型的指针：struct POINT{ int x, y; };  POINT * p;



### 2.多个指针变量的定义

例三：int * p, * q;
例四：typedef int * PINT;  PINT p, q;



### 3.指针变量的存储布局

1.指针数据对象（变量）与目标数据对象（变量）

![](/home/lizw/Documents/LinuxCpp/resources/image/LinuxCpp07Image01.png)





# 常量指针与指针常量

### 1.常量指针：指向常量的指针

性质：不能通过指针修改目标数据对象的值，但可以改变指针值，使其指向其他地方
示例一：int n = 10;  const int * p = &n;
典型使用场合：作为函数参数，表示函数内部不能修改指针所指向的目标数据对象值
示例二：void PrintObject( const int * p );



### 2.指针常量：指针指向的位置不可变化

性质：不可将指针指向其他地方，但可改变指针所指向的目标数据对象值
示例三：int n = 10;  int * const p = &n;
指针常量和其他常量一样，必须在定义时初始化



### 3.常量指针常量：指向常量的指针常量（指针的双重只读属性）

性质：指针值不可改变，指向的目标数据对象值也不可改变
示例四：const int n = 10;  const int * const p = &n;
典型使用场合：主要作为函数参数使用



# 指针与函数返回值

### 1.指针类型可以作为函数返回值

1).函数内部返回某个数据对象的地址
2).调用函数后将返回值赋值给某个指针
特别说明：不能返回函数内部定义的局部变量地址



### 2.程序示例

int global = 0;
int * ReturnPointer()
{
  return &global;
}



# 数据对象地址的计算

1.数组定义
int a[8] = {1, 2, 3, 4, 5, 6, 7, 8};

2.数组基地址：&a 或 a

3.数组元素地址
数组首元素地址：&a[0]
数组第 i 元素地址：&a[0] + i * sizeof( int )
数组基地址与首元素地址数值相同，故数组第 i 元素地址：a + i * sizeof( int )



# 指针运算

1.希望表达 p、q 之间的联系
它们都指向同一数组中的元素

2.指针与整数加减运算
设 p 为指向整数数组中某元素的指针，i 为整数，则 p + i 表示指针向后滑动 i 个整数， p - i 表示指针向前滑动 i 个整数
例一：p 指向 a[0]，则 p + 2 指向 a[2]
例二：p 指向 a[3]，则 p - 2 指向 a[1]
指针与整数加减运算的结果仍为指针类型量，故可赋值
例三：p 指向 a[0]，则 q = p + 2 使得 q 指向 a[2]

3.指针与整数加减运算规律
以指针指向的目标数据对象类型为单位，而不是以字节为单位

4.指针的递增递减运算
例四：p 指向 a[0]，则 p++ 指向 a[1]
例五：p 指向 a[1]，则 --p 指向 a[0]

5.指针减法运算
两个指针的减法运算结果为其间元素个数
例六： p 指向 a[0]， q 指向 a[2]，q - p 结果为 2

6.指针关系运算
可以测试两个指针是否相等
例一：设 p、q 为指针，则 p == q 测试两个指针是否指向同一个目标数据对象

7.空指针：NULL
指针值 0：表示指针不指向任何地方，表示为 NULL
例二：设 p 为指针，则  p = NULL 表示 p 不指向任何目标数据对象
例三（测试指针 p 是否有意义）：if( p != NULL )  等价于 if( p )
使用指针前一定要测试其是否有意义！



# 作为函数参数的指针

1.指针作为函数参数：函数定义
void GenerateIntegers( int* p, unsigned int n )
{
  unsigned int i;
  Randomize();
  for( i = 0; i < n; i++ )
    *p++ = GenerateRandomNumber(lower_bound, upper_bound);
}

2.指针作为函数参数：函数调用
必须传递已分配空间的数组基地址
#define NUM_OF_ELEMENTS 8
int a[NUM_OF_ELEMENTS];
GenerateIntegers( a, NUM_OF_ELEMENTS );



# 字符数组与字符指针的差异

![](/home/lizw/Documents/LinuxCpp/resources/image/LinuxCpp07Image02.png)

1.按指针格式定义字符串，可以直接赋值
示例：char * s;   s = "CPP-Prog";    //  正确
字符串文字首先分配空间，然后将其基地址赋给 s，使 s 指向该字符串基地址

2.按字符数组格式定义字符串，不能直接赋值
示例：char s[9];   s = "CPP-Prog";    //  错误
不能对数组进行整体赋值操作
原因：数组空间已分配，字符串文字空间已分配，且它们位于不同位置，不能直接整体复制



# 内存分配与释放

1.静态内存分配方式
　适用对象：全局变量与静态局部变量
　分配与释放时机：在程序运行前分配，程序结束时释放

2.自动内存分配方式
　适用对象：普通局部变量
　分配与释放时机：在程序进入该函数或该块时自动进行，退出时自动释放

3.动态内存分配方式
　适用对象：匿名数据对象（指针指向的目标数据对象）
　分配与释放时机：在执行特定代码段时按照该代码段的要求动态分配和释放



# 动态内存分配的性质

### 1.动态内存分配的目的

1).静态与自动内存分配方式必须事先了解数据对象的格式和存储空间大小
2).部分场合无法确定数据对象的大小
示例：声明一个包含 n 个元素的整数数组，n 值由用户在程序执行时输入。编译时程序未执行，不知道 n 值！



### 2.动态内存分配的位置

1).计算机维护的一个专门存储区：堆
2).所有动态分配的内存都位于堆中



### 3.动态内存分配的关键技术

1).使用指针指向动态分配的内存区
2).使用引领操作符操作目标数据对象



# void * 类型

1.特殊的指针类型，指向的目标数据对象类型未知
2.不能在其上使用引领操作符访问目标数据对象
3.可以转换为任意指针类型，不过转换后类型是否有意义要看程序逻辑
4.可以在转换后的类型上使用引领操作符
主要目的：作为一种通用指针类型，首先构造指针对象与目标数据对象的一般性关联，然后由程序员在未来明确该关联的性质



# free 函数

1.free 函数释放的是 p 指向的目标数据对象的空间，而不是 p 本身的存储空间
2.调用 free 函数后，p 指向的空间不再有效，但 p 仍指向它
3.为保证在释放目标数据对象空间后，不会再次使用 p 访问，建议按照下述格式书写代码：free( p );   p = NULL;



# new/new[ ] 操作符

1.动态创建单个目标数据对象
分配目标对象：int * p;  p = new int;  *p = 10;
分配目标对象：int * p;  p = new( int );  *p = 10;
分配目标对象并初始化：int * p;  p = new int(10);  // 将 *p 初始化为 10
分配目标对象并初始化：int * p;  p = new(int)(10);

2.动态创建多个目标数据对象
分配数组目标对象：int * p;  p = new int[8]; // 分配 8 个元素的整数数组



# delete/delete[ ] 操作符

1.释放单个目标数据对象
　释放目标对象：int * p;  p = new int;  *p = 10;  delete p;

2.释放多个目标数据对象
　释放数组目标对象：int * p;  p = new int[8];  delete[] p;
　不是delete p[ ]



# 所有权与空悬指针

### 1.目标数据对象的所有权

1).指向该目标数据对象的指针对象拥有所有权
2).在程序中要时刻明确动态分配内存的目标数据对象的所有权归属于哪个指针数据对象



### 2.指针使用的一般原则

1).主动释放原则：如果某函数动态分配了内存，在函数退出时该目标数据对象不再需要，应主动释放它，此时 malloc 与 free 在函数中成对出现

2).所有权转移原则：如果某函数动态分配了内存，在函数退出后该目标数据对象仍然需要，此时应将其所有权转交给本函数之外的同型指针对象，函数内部代码只有 malloc，没有 free



### 3.空悬指针问题

1).所有权的重叠：指针赋值操作导致两个指针数据对象指向同样的目标数据对象，即两个指针都声称“自己拥有目标数据对象的所有权”
示例：int *p, *q;    q = ( int* )malloc( sizeof(int) );    p = q;

2).产生原因：如果在程序中通过某个指针释放了目标数据对象，另一指针并不了解这种情况，它仍指向不再有效的目标数据对象，导致空悬指针
示例：free( p );   p = NULL;  //  q 为空悬指针，仍指向原处



### 4.解决方案

1).确保程序中只有惟一一个指针拥有目标数据对象，即只有它负责目标数据对象的存储管理，其它指针只可访问，不可管理；若目标数据对象仍有存在价值，但该指针不再有效，此时应进行所有权移交

2).在一个函数中，确保最多只有一个指针拥有目标数据对象，其它指针即使存在，也仅能访问，不可管理

3).如果可能，在分配目标数据对象动态内存的函数中释放内存，如 main 函数分配的内存在 main 函数中释放

4).退一步，如果上述条件不满足，在分配目标数据对象动态内存的函数的主调函数中释放内存，即将所有权移交给上级函数级级上报，层层审批



# 内存泄露与垃圾回收

1.产生原因：若某个函数通过局部指针变量动态分配了一个目标数据对象内存，在函数调用结束后没有释放该内存，并且所有权没有上交
示例：void f(){  int * p = new int;  *p = 10;  }
函数 f 结束后，p 不再存在，*p 所在的存储空间仍在，10 仍在，但没有任何指针对象拥有它，故不可访问

2.问题的实质：动态分配的内存必须动态释放，函数本身并不负责管理它

3.垃圾回收机制：系统负责管理，程序员不需要主动释放动态分配的内存，Java 有此功能，C 语言无

4.垃圾回收机制在需要时效率很差，而不需要时效率很好



# 引用类型

1.引用的定义
1).定义格式：数据类型& 变量名称 = 被引用变量名称；
　示例：int a;  int & ref = a;

2.引用的性质
1).引用类型的变量不占用单独的存储空间
2).为另一数据对象起个别名，与该对象同享存储空间

3.特殊说明
1).引用类型的变量必须在定义时初始化
2).此关联关系在引用类型变量的整个存续期都保持不变
3).对引用类型变量的操作就是对被引用变量的操作



# 引用作为函数参数

1.引用的最大意义：作为函数参数
1).参数传递机制：引用传递，直接修改实际参数值
2).使用格式：返回值类型 函数名称( 类型 & 参数名称)；
3).函数原型示例：void Swap( int & x, int & y );
4).函数实现示例：
	void Swap( int & x, int & y ){
	int t;  t = x;  x = y;  y = t;  return;
	}
5).函数调用示例：
	int main(){
	int a = 10, b = 20;  Swap( a, b );  return 0;
	}



# 引用作为函数返回值

1.常量引用：仅能引用常量，不能通过引用改变目标对象值；引用本身也不能改变引用对象

2.引用作为函数返回值时不生成副本
1).函数原型示例：int & Inc( int & dest, const int & alpha );
2).函数实现示例：
	int & Inc( int & dest, const int & alpha ){
	dest += alpha;  return dest;
	}
3).函数调用示例：引用类型返回值可以递增
	int main(){
	int a = 10, b = 20, c;  Inc( a, b );  c = Inc(a, b)++;  return 0;
	}

