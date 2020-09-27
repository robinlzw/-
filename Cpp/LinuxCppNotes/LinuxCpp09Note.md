# 对象的构造

1.对象构造的意义
－构造就是初始化，在定义对象时初始化其数据成员

2.对象构造的技术手段：使用构造函数
－与类类型同名，没有返回值类型（包括void类型）
－构造函数允许重载
－构造函数可以带缺省参数，但是不建议
－至少公开一个构造函数
－只能由系统在创建对象时自动调用，程序其他部分不能直接调用



# 缺省构造函数

1.类没有明确的构造函数
－系统自动产生一个缺省构造函数，自动调用
－缺省构造函数无参数，且函数体中没有任何语句
－如果定义了任意一个构造函数，则不再生成缺省构造函数

2.缺省构造函数调用示例
－正确示例：Circle circle;
－错误示例：Circle circle();  
－在构造函数无参数时，不能使用函数形式构造对象。原因？



# 拷贝构造函数

1.拷贝构造函数用于构造已有对象的副本
2.拷贝构造函数单参数，为本类的常对象的引用
3.如未定义，系统自动产生一个缺省拷贝构造函数
4.缺省拷贝构造函数为位拷贝（浅拷贝），如需深拷贝（例如成员为指针），需自行定义



# 构造函数的初始化列表

1.初始化列表的目的与意义
－在构造对象时，同步构造内部对象
－部分成员（常量与引用）只能初始化，不能赋值
－部分成员（类的对象）如果赋值，将导致两次构造
·　在分配内存时，调用缺省构造函数构造，然后执行构造函数体内的赋值语句再次构造，效率不佳
·　若类没有缺省构造函数，则会导致问题

2.注意事项
－成员初始化按照成员定义顺序，而不是初始化列表顺序
－必须保持初始化列表和成员定义的顺序一致性，但允许跳过部分成员；否则后续成员可能不会正确初始化



# 内联函数

1.目的：程序优化，展开函数代码而不是调用

2.内联函数使用的注意事项
－在函数定义前添加inline关键字，仅在函数原型前使用此关
　键字无效
－编译器必须能看见内联函数的代码才能在编译期展开，因而
　内联函数必须实现在头文件中
－在类定义中给出函数体的成员函数自动成为内联函数
－函数体代码量较大，或包含循环，不要使用内联
－构造函数和析构函数有可能隐含附加操作，慎用内联
－内联函数仅是建议，编译器会自主选择是否内联



# 常数据成员

1.常数据成员：值在程序运行期间不可变
－定义格式：const  类型  数据成员名称;
－初始化：只能通过构造函数中的初始化列表进行

2.使用示例
   class A
   {
　public:
 　 A( int a );
　private:
　  const int num;
　};

　A::A( int a ) : num(a) { …… };



# 常成员函数

1.常成员函数：不能修改对象成员值的函数
－定义格式：类型  成员函数名称(参数列表) const;
－常成员函数不能调用类中非常成员函数
－静态成员函数不能定义为常成员函数
－如果对象为常量，则只能调用其常成员函数

2.使用示例
　class Circle{
　public:
 　 double GetArea() const;
　  ……
　};
　double Circle::GetArea() const{ …… }



# 静态数据成员

1.静态数据成员只有一份，由该类所有对象共享
－声明格式：static  类型  静态数据成员名称;
－仅声明，不在对象上分配空间
－定义格式：类型  类名称::静态数据成员名称 = 初始值;
－必须在外部初始化，初始化动作与访问控制无关

2.示例
　class A
　{
　private:
 　 static int count;
　};

　int A::count = 0;



# 静态成员函数

1.静态成员函数
－在类而不是对象上调用
－目的：访问类的静态数据成员，若要访问类的非静态数据成员，必须指定
　对象或者使用指向对象的指针

2.使用示例

class A
{
public:
	static int f();
	static int g( const A & a );
	private:
	static int count;
	int num;
};

int A::count = 0;
int A::f()
{
  return count;
}
int A::g( const A & a )
{
  return a.num;
}



# 单子模式

1.只存在某类的单一共享对象

2.存在某种全局访问策略，以在需要时访问该对象



# 单子模式：无析构

class Singleton
{
public:  // 静态成员函数，对象不存在时构造，否则返回之，保证唯一性
  static Singleton * Get() {  if (!_s)  _s = new Singleton;  return _s;  }
  int GetData() { return ++a; }
private:  // 私有构造和析构函数，禁止在外部构造和析构本类的对象
  Singleton() { a = 0; }
  Singleton( const Singleton & that );  // 只声明不实现，禁止拷贝和赋值构造
  Singleton & operator=( const Singleton & that );
  ~Singleton();  // 只声明不实现，禁止析构
private:
  static Singleton * _s;  // 静态数据成员，指向本类唯一对象的指针
  int a;  // 验证数据
};

Singleton * Singleton::_s = NULL;  // 定义于源文件中

//  使用方法：以Singleton::Get()->GetData()方式直接访问
Singleton::Get()



# 单子模式：错误析构

class Singleton
{
public:  // 静态成员函数，对象不存在时构造，否则返回之，保证唯一性
  static Singleton * Get() {  if (!_s)  _s = new Singleton;  return _s;  }
  int GetData() { return ++a; }
private:  // 私有构造和析构函数，禁止在外部构造和析构本类的对象
  Singleton() { a = 0; }
  Singleton( const Singleton & that );  // 只声明不实现，禁止拷贝和赋值构造
  Singleton & operator=( const Singleton & that );
  //  错误析构函数，访问控制改为public也不行
  //  delete操作符本身需要调用析构函数
  //  且非静态函数不能释放静态指针成员，否则可能导致系统崩溃
  ***~Singleton() {  if(Singleton::s) {  delete Singleton::s, Singleton::s = NULL; }  }***
private:
  static Singleton * _s;  // 静态数据成员，指向本类唯一对象的指针
  int a;  // 验证数据
};



# 单子模式：正确析构1

class Singleton
{
public:  // 静态成员函数，对象不存在时构造，否则返回之，保证唯一性
  static Singleton * Get() {  if (!_s)  _s = new Singleton;  return _s;  }
  int GetData() { return ++a; }
private:  // 私有构造函数，禁止在外部构造本类的对象
  Singleton() { a = 0; }
  Singleton( const Singleton & that );  // 只声明不实现，禁止拷贝和赋值构造
  Singleton & operator=( const Singleton & that );
public:  // 在部分系统下使用private亦可，系统简单释放全部内存，并不调用它
  ~Singleton() { }  // 因此，如果函数非空（如需数据持久化），有可能导致问题
private:
  static Singleton * _s;  // 静态数据成员，指向本类唯一对象的指针
  // Destroyer类的唯一任务是删除单子
  class Destroyer{
  public:
    ***~Destroyer() {  if(Singleton::s) {  delete Singleton::s, Singleton::s = NULL;  }  }***
    };
  static Destroyer _d;  // 程序结束时，系统自动调用静态成员的析构函数
  int a;  // 验证数据
};



# 单子模式：正确析构2

class Singleton
{
public:  // 静态成员函数，对象不存在时构造，否则返回之，保证唯一性
  static Singleton * Get() {  if (!_s)  _s = new Singleton;  return _s;  }
  // 不调用析构函数，Release调用时机由程序员确定
  static void Release() {  if(_s)  {  free(_s),  _s = NULL;  }  }
  int GetData() { return ++a; }
private:  // 私有构造和析构函数，禁止在外部构造和析构本类的对象
  Singleton() { a = 0; }
  Singleton( const Singleton & that );  // 只声明不实现，禁止拷贝和赋值构造
  Singleton & operator=( const Singleton & that );
  ~Singleton();
private:
  static Singleton * _s;  // 静态数据成员，指向本类唯一对象的指针
  int a;  // 验证数据
};



# 单子模式：静态数据

class Singleton
{
public:  // 静态成员函数中的静态变量，保证唯一性
  static Singleton & Get() {  static Singleton _s;  return _s;  }
  int GetData() { return ++a; }
private:  // 私有构造和析构函数，禁止在外部构造和析构本类的对象
  Singleton() { a = 0; }
  Singleton( const Singleton & that );
  Singleton & operator=( const Singleton & that );
  ~Singleton() { }
private:
  int a;  // 验证数据
};

//  本实现没有动态内存分配，因而无需销毁单子对象
//  使用方法：定义引用或以Singleton::Get().GetData()方式直接访问
Singleton & sing = Singleton::Get();
int n = sing.GetData();



# 静态常数据成员

1.静态常数据成员：值在程序运行期间不可变，且只有唯一副本
－定义格式：static const  类型  数据成员名称;
－初始化：只能在类的外部初始化

2.使用示例
　class A
　{
　private:
　  static const int count;
　};

　const int A::count = 10;



# 友元函数与友元类

1.友元：**慎用**！破坏类数据封装与信息隐藏
－类的友元可以访问该类对象的私有与保护成员
－友元可以是函数、其他类成员函数，也可以是类
－定义格式：friend  函数或类声明;
－两个类的友元关系不可逆，除非互为友元

2.使用示例
　class Circle
　{
　  friend double Get_Radius();
　  friend class Globe;  // 将Globe类所有成员函数声明为友元
　private:
 　 double radius;
　};



# 单继承

1.单继承的基本语法格式
－class  派生类名称 :  派生类型保留字  基类名称 {  …  };

2.派生类型保留字
－public：基类的public、protected成员在派生类中保持，private
　成员在派生类中不可见（属于基类隐私）
－protected：基类的private成员在派生类中不可见，public、
　protected成员在派生类中变为protected成员
－private：基类的private成员在派生类中不可见，public、
　protected成员在派生类中变为private成员
－设计类时若需要使用继承机制，建议将派生类需要频繁使用的基类数
　据成员设为protected的



# 函数覆盖与二义性1

1.派生类成员函数名称与基类相同
　class Point {  void Print();  };
　class Point3D: public Point { void Print();  };
　Point pt( 1, 2 );
　Point3D pt3d( 1, 2, 3 );

2.调用示例
－pt.Print()：调用Point类的Print成员函数
－pt3d.Print()：调用Point3D类的Print成员函数
－Point类的Print成员函数在Point3D类中仍存在，但被新类中的同名
　函数覆盖
－访问规则（解析）：pt3d.Point::Print()



# 多继承

1.多继承的基本语法格式
　class 派生类名称: 派生类型保留字 基类名称1, 派生类型保留字 基类
　名称2, … {  …  };

2.多继承示例
　class A { … };  class B { … };
　class C: public A, protected B { … };

3.多继承可能导致的问题：派生类中可能包含多个基类副本，**慎用**！
　class A { … };  class B: public A { … };
　class C: public A, protected B { … };



# 函数覆盖与二义性2

1.派生类成员函数名称与基类相同
　class A {  public: void f();  };
　class B {  public: void f();  };
　class C: public A, public B {  public: void f();  };
　C c;

2.调用示例
－c.f()：调用C类的成员函数
－c.A::f()：调用C类继承自A类的函数
－c.B::f()：调用C类继承自B类的函数



# 函数覆盖与二义性3

1.派生类成员函数名称与基类相同
　class A {  public: void f();  };
　class B: public A {  public: void f();  };
　class C: public A {  public: void f();  };
　class D: public B, public C {  public: void f();  };
　d d;

2.调用示例
－d.f()：调用D类的成员函数
－d.B::f()：调用D类继承自B类的函数
－d.C::f()：调用D类继承自B类的函数
－d.B::A::f()：调用D类通过B类分支继承自A类的函数



# 虚基类

1.虚拟继承的目的
－取消多继承时派生类中公共基类的多个副本，只保留一份
－格式：派生时使用关键字virtual

2.使用示例：D中只有A的一份副本
　class A {  public: void f();  };
　class B: virtual public A {  public: void f();  };
　class C: virtual public A {  public: void f();  };
　class D: public B, public C {  public: void f();  };



# 派生类的构造函数与析构函数

1.构造函数的执行顺序
－调用基类的构造函数，调用顺序与基类在派生类中的继承顺序相同
－调用派生类新增对象成员的构造函数，调用顺序与其在派生类中的
　定义顺序相同
－调用派生类的构造函数

2.析构函数的执行顺序
－调用派生类的析构函数
－调用派生类新增对象成员的析构函数，调用顺序与其在派生类中的
　定义顺序相反
－调用基类的析构函数，调用顺序与基类在派生类中的继承顺序相反



# 类的赋值兼容性

1.公有派生时，任何基类对象可以出现的位置都可以使用派生类对象代替
－将派生类对象赋值给基类对象，仅赋值基类部分
－用派生类对象初始化基类对象引用，仅操作基类部分
－使指向基类的指针指向派生类对象，仅引领基类部分

2.保护派生与私有派生不可以直接赋值
－尽量不要使用保护派生与私有派生

#include <iostream>  
#include <string>  
using namespace std;  
class Base  
{  
public:  
  Base(string s) : str_a(s) { }  
  Base(const Base & that) { str_a = that.str_a; }  
  void Print() const { cout << "In base: " << str_a << endl; }  
protected:  
    string str_a;  
}; 
class Derived : public Base
{  
public:  
    Derived(string s1,string s2) : Base(s1), str_b(s2) { }  // 调用基类构造函数初始化
    void Print() const { cout << "In derived: " << str_a + " " + str_b << endl; }  
protected:  
    string str_b;  
}; 


int main()  
{  
  Derived d1( "Hello", "World" );  

  Base b1( d1 );   // 拷贝构造，派生类至基类，仅复制基类部分
  d1.Print();  // Hello World
  b1.Print();  // Hello

  Base & b2 = d1;  // 引用，不调用拷贝构造函数，仅访问基类部分
  d1.Print();  
  b2.Print();  

  Base * b3 = &d1;  // 指针，不调用拷贝构造函数，仅引领基类部分
  d1.Print();
  b3->Print();  
  return 1;  
}



# 多态性

1.纯虚函数
－充当占位函数，没有任何实现
－派生类负责实现其具体功能
－声明格式：virtual void f( int x ) = 0;

2.抽象类
－带有纯虚函数的类
－作为类继承层次的上层

3.虚析构函数
－保持多态性需要虚析构函数，以保证能够正确释放对象

