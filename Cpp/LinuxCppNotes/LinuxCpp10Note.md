# 四则运算符重载1

```
class Couple  // 数偶类
{
public:
  Couple( int a = 0, int b = 0 ) : _a(a), _b(b) { }
  Couple operator+( const Couple & c );
  Couple operator*( const Couple & c );
  Couple operator*( const int & k );  // 数乘

  int _a, _b;
};

Couple Couple::operator+( const Couple & c )
{
  Couple _t( this->_a + c._a, this->_b + c._b );
  return _t;
}
Couple Couple::operator*( const Couple & c )
{
  Couple _t( this->_a * c._a, this->_b * c._b );
  return _t;
}

Couple Couple::operator*( const int & k )
{
  Couple _t( this->_a * k, this->_b * k );
  return _t;
}

int main()
{
  int k = 3;
  Couple a( 1, 2 ), b( 3, 4 ), c, d;
  c = a + b;	 // 等价于 c = a.operator+(b)  ==> c( 4, 6 )
  d = a + b + c;	 // 等价于 d = a.operator+(b).operator+(c)  ==> d( 8, 12 )
  c = a * b;	 // 等价于 c = a.operator*(b)  ==> c( 3, 8 )
  c = c * k; 	 // 等价于 c = c.operator*(k)  ==> c( 9, 24 )
  d = d * 2; 	 // 等价于 d = d.operator*(2)  ==> d( 16, 24 )
  return 0;
}
```



### 问题1：参数必须是Couple类对象的常引用吗？

可以不使用引用，但会产生对象拷贝动作，降低效率
可以不是常引用，但无法限制函数内部对参数的修改
可以使用指针，但与常规数学公式使用方式不符



### 问题2：返回值必须是Couple类的对象吗？返回引用是否可行？

可以返回引用，但必须是全局对象或通过参数传递进去的Couple对象的引用，不能引用函数内部的局部变量
不建议使用引用类型的返回值
需要将右操作数累加到左操作数上并返回左操作数时，此时应该重载加赋等操作符，减赋、乘赋、除赋与余赋类似



# 四则运算符重载2

```
class Couple
{
public:
  Couple( int a = 0, int b = 0 ) : _a(a), _b(b) { }
  friend Couple operator+( const Couple & c1, const Couple & c2 );
  friend Couple operator*( const Couple & c1, const Couple & c2 );
  friend Couple operator*(const Couple & c, const int & k );
  friend Couple operator*( const int & k, const Couple & c );
private:
  int _a, _b;
};

Couple Couple::operator+( const Couple & c1, const Couple & c2 )
{
  Couple _t(c1._a + c2._a, c1._b + c2._b );
  return _t;
}
Couple Couple::operator*( const Couple & c1, const Couple & c2 )
{
  Couple _t( c1._a * c2._a, c1._b * c2._b );
  return _t;
}
Couple Couple::operator*( const Couple & c, const int & k )
{
  Couple _t( c._a * k, c._b * k );
  return _t;
}
Couple Couple::operator*( const int & k, const Couple & c )
{
  Couple _t( k * c._a, k * c._b );
  return _t;
}

int main()
{
  int k = 3;
  Couple a( 1, 2 ), b( 3, 4 ), c, d;
  c = a + b;	//  等价于 c = operator+(a, b)  ==> c( 4, 6 )
  d = a + b + c;	//  等价于 d = operator+(operator+(a, b), c)  ==> d( 8, 12 )
  c = a * b;	//  等价于 c = operator*(a, b)  ==> c( 3, 8 )
  c = k * c;	//  等价于 c = operator*(k, c)  ==> c( 9, 24 )
  d = 2 * d;	//  等价于 d = operator*(2, d)  ==> d( 16, 24 )
  return 0;
}
```





### 问题3：四则运算符必须重载为成员函数吗？

不。可以重载为类的友元函数或普通函数。注意：普通函数无法访问类的私有成员
建议重载为友元函数

### 重载为友元函数

优势：显式具有双操作数，且格式一致；操作不局限于当前对象本身，且不要求左操作数必须为本类的对象
劣势：显式具有双操作数，不能省略左操作数

### 数偶倍乘运算重载的说明

1.应重载为类的友元函数
2.若非友元函数，当倍数为左操作数时，无法解析乘法运算，编译会出错
3.将左操作数k转换为Couple类的对象可以解决上述问题，但意义已不同
4.上述转换要求提供一个单参数的从整数到Couple类的构造函数，如果使用explicit修饰该构造函数，隐式类型转换会被禁止；虽然即使不禁止，很多编译器也不进行此转换
5.左右操作数不可互换，重载函数必须提供两个版本，它们的函数签名不同



# 下标操作符重载

1.下标操作符重载的场合与目的
如果对象具有数组成员，且该成员为主要成员，可以重载下标操作符
目的：以允许在对象上通过数组下标访问该数组成员的元素

2.下标操作符必须重载两个版本
常函数版本用于处理常量

3.数组下标越界错误
可以在重载函数中处理数组下标越界错误，或使用异常处理机制

```
class Couple
{
public:
  Couple( int a = 0, int b = 0 ) {  _a[0]=a,  _a[1]=b;  }
  int & operator[]( int index );
  const int & operator[]( int index ) const;
private:
  int _a[2];
};

int & Couple::operator[]( int index )
{
  if( index < 0 || index > 1 )
    throw std::out_of_range( "Index is out of range!" );
  return _a[index];
}
const int & Couple::operator[]( int index ) const
{
  if( index < 0 || index > 1 )
    throw std::out_of_range( "Index is out of range!" );
  return _a[index];
}
int main()
{
  Couple a( 1, 2 ), b( 3, 4 );
  cin >> a[0] >> a[1];
  cout << b[0] << " " << b[1] << endl;
  return 0;
}
```



# 赋值操作符重载

```
class Couple
{
public:
  Couple( int a = 0, int b = 0 ) : _a(a), _b(b){ }
  Couple( const Couple & c ) : _a(c._a), _b(c._b){ }
  Couple & operator=( const Couple & c );
private:
  int _a, _b;
};

Couple & Couple::operator=( const Couple & c )
{
  if( *this == c ) 
    return *this;
  _a = c._a,  _b = c._b;
  return *this;
}

int main()
{
  Couple a( 1, 2 ), b( 3, 4 );
  cout << a << endl;
  a = b; 
  cout << a << endl;
  return 0;
}
```



# 复合赋值操作符重载

```
class Couple
{
public:
  Couple( int a = 0, int b = 0 ) : _a(a), _b(b){ }
  Couple( const Couple & c ) : _a(c._a), _b(c._b){ }
  Couple & operator+=( const Couple & c );
  Couple & operator*=( const Couple & c );
  Couple & operator*=( const int & k );
private:
  int _a, _b;
};

Couple & Couple::operator+=( const Couple & c )
{
  _a += c._a,  _b += c._b;
  return *this;
}

Couple & Couple::operator*=( const Couple & c )
{
  _a *= c._a,  _b *= c._b;
  return *this;
}

Couple & Couple::operator*=( const int & k )
{
  _a *= k,  _b *= k;
  return *this;
}

```



# 递增递减操作符重载

```
class Couple
{
public:
  Couple( int a = 0, int b = 0 ) : _a(a), _b(b){ }
  Couple( const Couple & c ) : _a(c._a), _b(c._b){ }
  Couple & operator=( const Couple & c );
  Couple & operator++();	//  前缀递增
  Couple operator++( int );	//  后缀递增
private:
  int _a, _b;
};

Couple & Couple::operator++()
{
  ++_a,  ++_b;
  return *this;
}

Couple Couple::operator++( int _t )
{ // 该函数有一个 int 类型的虚拟形参，这个形参在函数的主体中是不会被使用的，
  // 这只是一个约定，它告诉编译器递增运算符正在后缀模式下被重载
  Couple _t( *this );
  _a++,  _b++;
  return _t;
}
```



# 赋值构造与拷贝构造

1.赋值也是构造
2.拷贝、赋值与析构三位一体，一般同时出现
1).缺省赋值构造与拷贝构造为浅拷贝
2).如果对象没有指针成员，缺省行为即可满足要求，无需实现或重载这三个函数
3).如果对象有指针成员，一般需要重载这三个函数



## 浅拷贝

```
class A
{
public:
  A() : _n(0), _p(NULL) { }
  explicit A( int n ) : _n(n), _p(new int[n]) { }
  A( int n, int * p ) : _n(n), _p(p) { }
  A( const A & that ) : _n(that._n), _p(that._p) { }  // 拷贝构造
  A & operator=( const A & that ) { _n = that._n, _p = that._p; return *this; }  // 赋值构造
  virtual ~A() { if(_p){ delete[] _p, _p = NULL; } }
public:
  int & operator[]( int i );
  const int & operator[]( int i ) const;
private:
  int _n;
  int * _p;
};

int & A::operator[]( int i )
{
  if( i < 0 || i >= 4 )
    throw std::out_of_range( "Out of range when trying to access the object...");
  return _p[i];
}

const int & A::operator[]( int i ) const
{
  if( i < 0 || i >= 4 )
    throw std::out_of_range( "Out of range when trying to access the object...");
  return _p[i];
}

int main()
{
  A a(4), b;
  for( int i = 0; i < 4; i++ )
    a[i] = i + 1;
  std::cout << "Before object assignment:" << std::endl;
  for( int i = 0; i < 4; i++ )
    std::cout << a[i] << " ";
  std::cout << std::endl;
  b = a;
  std::cout << "After object assignment:" << std::endl;
  for( int i = 0; i < 4; i++ )
    std::cout << b[i] << " ";
  std::cout << std::endl;
  return 0;    //  程序结束时，系统崩溃
}
```



# 深拷贝

```
class A
{
public:
  A() : _n(0), _p(NULL) { }
  explicit A( int n ) : _n(n), _p(new int[n]) { }
  A( int n, int * p ) : _n(n), _p(p) { }
  A( const A & that );
  A & operator=( const A & that );
  virtual ~A() { if(_p){ delete[] _p, _p = NULL; } }
public:
  int & operator[]( int i );
  const int & operator[]( int i ) const;
private:
  int _n;
  int * _p;
};

A::A( const A & that )
{
  this->_n = that._n;
  _p = new int[_n];
  for( int i = 0; i < _n; i++ )
    _p[i] = that._p[i];
}

A & A::operator=( const A & that )
{
  this->_n = that._n;
  if( _p )
    delete[] _p;
  _p = new int[_n];
  for( int i = 0; i < _n; i++ )
    _p[i] = that._p[i];
  return *this;
}
```



# 移动语义

![](/home/lizw/Documents/LinuxCpp/resources/image/LinuxCpp10Image01.png)



### 1.左值与右值

1).C原始定义
左值：可以出现在赋值号左边或右边
右值：只能出现在赋值号右边



2).C++定义
左值：用于标识非临时对象或非成员函数的表达式
右值：用于标识临时对象的表达式或与任何对象无关的值（纯右值），或者用于标识即将失效的对象的表达式（失效值）



### 2.左值引用与右值引用

1).左值引用：&
2).右值引用：&&
a.深拷贝需要频繁分配和释放内存，效率较低
b.移动语义的目的：所有权移交，不需要重新构造和析构
c.为与构造函数兼容，移动语义必须为引用，而不能是指针或普通量
d.普通引用传递左值，以允许函数内部修改目标数据对象
e.为区分左值引用，实现移动语义时必须传递右值引用
f.为保证能够修改目标数据对象，在函数内部必须将右值引用作为左值引用对待



### 3.移动赋值与移动构造

```
class A
{
public:
  A() : _n(0), _p(nullptr)  {  }
  explicit A( int n ) : _n(n), _p(new int[n])  {  }
  A( int n, int * p ) : _n(n), _p(p)  {  }
  A( A && that );  // 移动构造
  A & operator=( A && that );  // 移动赋值
  virtual ~A() {  if(_p){  delete[] _p, _p = nullptr;  }  }
public:
  int & operator[]( int i );
  const int & operator[]( int i ) const;
private:
  int _n;
  int * _p;
};

A::A( A && that )
{
  //  nullptr：C++11预定义的空指针类型nullptr_t的常对象
  //  可隐式转换为任意指针类型和bool类型，但不能转换为整数类型，以取代NULL
  _n = that._n,  _p = that._p,  that._n = 0,  that._p = nullptr;
  //  *this = that;    //  此代码不会调用下面重载的赋值操作符函数
  //  具名右值引用that在函数内部被当作左值，不是右值
  //  匿名右值引用才会被当作右值；理论上如此……
  //  *this = static_cast<A &&>( that );    //  等价于 *this = std::move( that );
  //  上一行代码可以调用下面重载的移动赋值操作符，但是有可能导致程序崩溃
  //  因this指向的本对象可能刚刚分配内存，_p字段所指向的目标数据对象无定义
}
A & A::operator=( A && that )
{
   if( _p )    delete[] _p;    //  删除此行代码可能会导致内存泄露
  //  可以测试是否为同一对象，以避免自身复制操作，但意义不大
  _n = that._n,   _p = that._p,  that._n = 0,  that._p = nullptr;
  return *this;
}
```



### 4.移动语义重载

```
class A
{
public:
  A() : _n(0), _p(nullptr)  {  }
  explicit A( int n ) : _n(n), _p(new int[n])  {  }
  A( int n, int * p ) : _n(n), _p(p)  {  }
  //  可以同时提供拷贝语义与移动语义版本，前者使用常左值引用
  //  不能修改目标数据对象的值，后者则可以修改
  A( const A & that );
  A( A && that );
  A & operator=( const A & that );
  A & operator=( A && that );
  virtual ~A() { if( _p )  {  delete[] _p, _p = nullptr;  }  }
  ……
};

int main()
{
  A a( 4 );
  for( int i = 0; i < 4; i++ )
    a[i] = i + 1;

  A b( a );	//  调用拷贝构造版本
  b = a;		//  调用普通赋值版本

  //  把左值引用转换为右值引用，否则会调用左值版本
  A c( static_cast< A && >( a ) );		//  调用移动构造版本
  c = static_cast< A && >( a );		//  调用移动赋值版本

  return 0;
}
```





# 移动语义再认识

### 1.左值引用同样可以实现移动语义

```
class A
{
public:
  A() : _n(0), _p(nullptr)  {  }
  explicit A( int n ) : _n(n), _p(new int[n])  {  }
  A( int n, int * p ) : _n(n), _p(p)  {  }
  A( A & that );			//  重载非常量版本；移动构造语义
  A( const A & that ); 		//  重载常量版本；深拷贝构造语义
  A & operator=( A & that );	 	//  重载非常量版本；移动赋值语义
  A & operator=( const A & that ); 	//  重载常量版本；深拷贝赋值语义
  virtual ~A() {  if(_p){  delete[] _p, _p = nullptr;  }  }
public:
  int & operator[]( int i )  throw( std::out_of_range );
  const int & operator[]( int i ) const  throw( std::out_of_range );
private:
  int _n;
  int * _p;
};

A::A( A & that )
{
  _n = that._n,  _p = that._p,  that._n = 0,  that._p = nullptr;
}
A::A( const A & that )
{
  this->_n = that._n;
  _p = new int[_n];    for( int i = 0; i < _n; i++ )    _p[i] = that._p[i];
}
A & A::operator=( A & that )
{
  _n = that._n,   _p = that._p,  that._n = 0,  that._p = nullptr;
  return *this;
}
A & A::operator=( const A & that )
{
  this->_n = that._n;
  if( _p )    delete[] _p;
  _p = new int[_n];    for( int i = 0; i < _n; i++ )    _p[i] = that._p[i];
  return *this;
}

// “Main.cpp”
int main()
{
  A a1;			//  缺省构造
  const A a2;		//  缺省构造

  A a3( a1 ); 		//  调用A::A( A & )，移动构造
  A a4( a2 );		//  调用A::A( const A & )，深拷贝构造
  //  对于非常量，必须转型为常量才能进行深拷贝
  A a5( const_cast< const A & >( a1 ) );  //  调用A::A( const A & )

  A a6, a7, a8;		//  缺省构造
  a6 = a1;		//  调用A::operator=( A & )，移动赋值
  a7 = a2;		//  调用A::operator=( const A & )，深拷贝赋值
  a8 = const_cast< const A & >( a1 );  //  调用A::operator=( const A & )

  return 0;
}
```



### 2.右值引用的意义

1.右值引用可以使用文字作为函数实际参数

```
//  不接受文字作为实际参数，因无法获取文字的左值
int f( int & x )  {  return ++x;  }

//  接受文字作为实际参数，传递右值引用
//  具名右值引用作为左值，匿名右值引用作为右值
//  在函数内部理论如此，但实际上……
int f( int && x )  {  return ++x;  }

int main()
{
  //  错误代码，++操作符的操作数必须为左值
  //  std::cout << ++10 << std::endl;
  //  可能有问题，传递右值引用，但部分编译器可能将其作为左值
  std::cout << f(10) << std::endl;    //  11?
  return 0;
}
```



2.避免编写过多的构造与赋值函数
1).不管是左值引用还是右值引用，若同时提供拷贝语义与移动语义，需要2对（4个）构造和赋值函数
2).若通过单独提供成员值的方式构造对象，单成员至少需要2对（4个）构造和赋值函数，双成员至少需要4对（8个）构造和赋值函数
3).使用右值引用，通过函数模板可以缩减代码编写量

3.实现完美转发



# 流操作符重载

### 1.流操作符重载的一般形式

```
class Couple
{
public:
  Couple( int a = 0, int b = 0 ) : _a(a), _b(b)  {  }
  //  必须使用此格式，以与流的连续书写特性保持一致
  friend ostream & operator<<( ostream & os, const Couple & c );
  friend istream & operator>>( istream & is, Couple & c );
private:
  int _a, _b;
};

//  注意：此处实现的流输入输出格式不统一
ostream & operator<<( ostream & os, const Couple & c )
{
  os << "( " << c._a << ", " << c._b << " )" << endl;
  return os;
}
istream & operator>>( istream & is, Couple & c )
{
  is >> c._a >> c._b;
  return is;
}

int main()
{
  Couple a( 1, 2 ), b;
  cin >> b;
  cout << a << endl;
  return 0;
}
```



# 操作符重载总结

### 1.哪些操作符可以重载？

不可重载操作符：“::”、“?:”、“.”、“.*”、“sizeof”、“#”、“##”、“typeid”
其他操作符都可重载



### 2.操作符重载原则

1).只能使用已有的操作符，不能创建新的操作符
2).操作符也是函数，重载遵循函数重载原则
3).重载的操作符不能改变优先级与结合性，也不能改变操作数个数及语法结构
4).重载的操作符不能改变其用于内部类型对象的含义，它只能和用户自定义类型的对象一起使用，或者用于用户自定义类型的对象和内部类型的对象混合使用
5).重载的操作符在功能上应与原有功能一致，即保持一致的语义



### 3.操作符重载的类型：成员函数或友元函数

1).重载为类的成员函数：少一个参数（隐含this，表示二元表达式的左参数或一元表达式的参数）
2).重载为类的友元函数：没有隐含this参数



### 4.成员函数与友元函数

1).一般全局常用操作符（关系操作符、逻辑操作符、流操作符）重载为友元函数，涉及对象特殊运算的操作符重载为成员函数
2).一般单目操作符重载为成员函数，双目操作符重载为友元函数
3).部分双目操作符不能重载为友元函数：“=”、“()”、“[]”、“->”
4).类型转换操作符只能重载为成员函数



### 5.重载的操作符参数：一般采用引用形式，主要与数学运算协调

示例：Couple a(1,2), b(3,4), c;   c = a + b;
若有定义：Couple Couple::operator+(Couple*, Couple*) { …… }
则需调用：Couple a(1,2), b(3,4), c;   c = &a + &b;



### 6.操作符重载的函数原型列表（推荐）

1).普通四则运算

```
friend  A  operator + ( const A & lhs, const A & rhs );
friend  A  operator - ( const A & lhs, const A & rhs );
friend  A  operator * ( const A & lhs, const A & rhs );
friend  A  operator / ( const A & lhs, const A & rhs );
friend  A  operator % ( const A & lhs, const A & rhs );
friend  A  operator * ( const A & lhs, const int & rhs );    //  标量运算，如果存在
friend  A  operator * ( const int & lhs, const A & rhs );    //  标量运算，如果存在
```

2).关系操作符

```
friend  bool  operator == ( const A & lhs, const A & rhs ); 
friend  bool  operator != ( const A & lhs, const A & rhs );
friend  bool  operator < ( const A & lhs, const A & rhs );
friend  bool  operator <= ( const A & lhs, const A & rhs );
friend  bool  operator > ( const A & lhs, const A & rhs );
friend  bool  operator >= ( const A & lhs, const A & rhs );
```

3).逻辑操作符

```
friend  bool  operator || ( const A & lhs, const A & rhs );
friend  bool  operator && ( const A & lhs, const A & rhs );
bool  A::operator ! ( );
```

4).正负操作符

```
A  A::operator + ();    //  取正
A  A::operator - ( );    //  取负
```

5).递增递减操作符

```
A &  A::operator ++ ();	//  前缀递增
A  A::operator ++ ( int );	//  后缀递增
A &  A::operator --();	//  前缀递减
A  A::operator -- ( int );	//  后缀递减
```

6).位操作符

```
riend  A  operator | ( const A & lhs, const A & rhs );	    //  位与
friend  A  operator & ( const A & lhs, const A & rhs );    //  位或
friend  A  operator ^ ( const A & lhs, const A & rhs );	    //  位异或
A  A::operator << ( int n );    //  左移
A  A::operator >> ( int n );    //  右移
A  A::operator ~ ();  // 位反
```

7).动态存储管理操作符：全局或成员函数均可

```
void *  operator new( std::size_t size )  throw( bad_alloc );
void *  operator new( std::size_t size, const std::nothrow_t & )  throw( );
void *  operator new( std::size_t size, void * base )  throw( ); 
void *  operator new[]( std::size_t size )  throw( bad_alloc );
void  operator delete( void * p );
void  operator delete []( void * p );
```

8).赋值操作符

```
A &  operator = ( A & rhs );
A &  operator = ( const A & rhs );
A &  operator = ( A && rhs );
A &  operator += ( const A & rhs );
A &  operator -= ( const A & rhs ); 
A &  operator *= ( const A & rhs );
A &  operator /= ( const A & rhs );
A &  operator %= ( const A & rhs );
A &  operator &= ( const A & rhs );
A &  operator |= ( const A & rhs );
A &  operator ^= ( const A & rhs );
A &  operator <<= ( int n );
A &  operator >>= ( int n );
```

9).下标操作符

```
T &  A::operator [] ( int i );
const T &  A::operator [] ( int i )  const;
```

10).函数调用操作符

```
T  A::operator () ( … );    //  参数可选
```

11).类型转换操作符

```
A::operator char * ()  const;
A::operator int ()  const;
A::operator double ()  const;
```

12).逗号操作符

```
T2  operator , ( T1 t1, T2 t2 );    //  不建议重载
```

13).指针与选员操作符

```
A *  A::operator & ( );    //  取址操作符
A &  A::operator * ( );    //  引领操作符
const A &  A::operator * ( )  const;    //  引领操作符
C *  A::operator -> ( );    //  选员操作符
const C *  A::operator -> ( )  const;    //  选员操作符
C &  A::operator ->* ( … );    //  选员操作符，指向类成员的指针
```

14).流操作符

```
friend  ostream &  operator << ( ostream & os, const A & a );
friend  istream &  operator >> ( istream & is, A & a );
```

