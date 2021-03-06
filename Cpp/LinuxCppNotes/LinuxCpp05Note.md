# 全局数据对象

1.定义于函数或复合语句块之外的数据对象
2.全局数据对象具有文件（全局）作用域，有效性从定义处开始直到本文件结束，其后函数都可直接使用
3.若包含全局数据对象定义的文件被其他文件包含，则其作用域扩展到宿主文件中，这可能会导致问题，**为什么**？
4.不要在头文件中定义全局数据对象



# 函数原型作用域

1.定义在函数原型中的参数具有函数原型作用域，其有效性仅延续到此函数原型结束
2.函数原型中参数名称可以与函数实现中的不同，也可以省略



# 生存期：量在程序中存在的时间范围

1.C/C++ 使用存储类表示生存期
2.作用域表达量的空间特性，存储类表达量的时间特性



# 静态（全局）生存期

1.全局数据对象具有静态（全局）生存期
2.生死仅与程序是否执行有关



# 自动（局部）生存期

1.局部数据对象具有自动（局部）生存期
2.生死仅与程序流程是否位于该块中有关
3.程序每次进入该块时就为该对象分配内存，退出该块时释放内存；
4.两次进入该块时使用的不是同一个数据对象



# static 关键字

### 1.修饰局部变量：静态局部变量

1).使局部变量具有静态生存期
2).程序退出该块时局部变量仍存在，并且下次进入该块时使用上一次的数据值
3).静态局部变量必须进行初始化
4).不改变量的作用域，仍具有块作用域，即只能在该块中访问，其他代码段不可见



### 2.修饰全局变量

1).使其作用域仅限定于本文件内部，其他文件不可见



# 函数的作用域与生存期

### 1.所有函数具有文件作用域与静态生存期

1).在程序每次执行时都存在，并且可以在函数原型或函数定义之后的任意位置调用



### 2.内部函数与外部函数

1).外部函数：可以被其他文件中的函数所调用
2).内部函数：不可以被其他文件中的函数所调用
3).函数缺省时均为外部函数
4).内部函数定义：使用 static 关键字
5).内部函数示例：static int Transform( int x );
6).内部函数示例：static int Transform( int x ){ … }



# 声明与定义

### 1.声明不是定义

1).定义在程序产生一个新实体

2).声明仅仅在程序中引入一个实体

### 2.函数的声明与定义

1).声明是给出函数原型，定义是给出函数实现代码

### 3.类型的声明与定义

1).产生新类型就是定义
2).类型定义示例：typedef enum BOOL { FALSE, TRUE }  BOOL;
3).不产生新类型就不是定义，而仅仅是声明
4).类型声明示例： enum __BOOL;



# 全局变量的作用域扩展

1.全局变量的定义不能出现在头文件中，只有其声明才可以出现在头文件中
2.声明格式：使用 extern 关键字

/* 库的头文件 */
/* 此处仅引入变量 a，其定义位于对应源文件中 */
extern int a;  /* 变量 a 可导出，其他文件可用 */

/* 库的源文件 */
/* 定义变量 a */
int a;