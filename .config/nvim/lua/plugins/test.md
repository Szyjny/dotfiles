# std::is_pointer

| Defined in header`[<type_traits>](../header/type_traits)` |   |               |
| --------------------------------------------------------- | - | ------------- |
| ```cpptemplate< class T >struct is_pointer;```            |   | (since C++11) |

`std::is_pointer` is a [UnaryTypeTrait](../named_req/unarytypetrait).

Checks whether `T` is a [pointer to object or function](../language/pointer#Pointers) (including pointer to `void`, but excluding pointer to member) or a cv-qualified version thereof. Provides the member constant `value` which is equal to `true`, if `T` is an object/function pointer type. Otherwise, `value` is equal to `false`.

The behavior of a program that adds specializations for `std::is_pointer` or `std::is_pointer_v` is undefined.

### Template parameters

| T | - | a type to check |
| - | - | --------------- |

### Helper variable template

| ```cpptemplate< class T >inline constexpr bool is_pointer_v = is_pointer<T>::value;``` |   | (since C++17) |
| -------------------------------------------------------------------------------------- | - | ------------- |

## Inherited from [std::integral_constant](integral_constant) 

### Member constants

| value[static] | `true`if`T`is a pointer type,`false`otherwise(public static member constant) |
| ------------- | ---------------------------------------------------------------------------- |

### Member functions

| operator bool     | converts the object tobool, returns`value`(public member function) |
| ----------------- | ------------------------------------------------------------------ |
| operator()(C++14) | returns`value`(public member function)                             |

### Member types

| Type         | Definition                                                                                      |
| ------------ | ----------------------------------------------------------------------------------------------- |
| `value_type` | bool                                                                                            |
| `type`       | [std::integral_constant](http://en.cppreference.com/w/cpp/types/integral_constant)<bool, value> |

### Possible implementation

| ```cpptemplate<class T>struct is_pointer : std::false_type {}; template<class T>struct is_pointer<T*> : std::true_type {}; template<class T>struct is_pointer<T* const> : std::true_type {}; template<class T>struct is_pointer<T* volatile> : std::true_type {}; template<class T>struct is_pointer<T* const volatile> : std::true_type {};``` |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

### Example

```cpp
#include <type_traits>
 
int main()
{
    struct A
    {
        int m;
        void f() {}
    };
 
    int A::*mem_data_ptr = &A::m;     // a pointer to member data
    void (A::*mem_fun_ptr)() = &A::f; // a pointer to member function
 
    static_assert(
           ! std::is_pointer<A>::value
        && ! std::is_pointer_v<A>    // same thing as above, but in C++17!
        && ! std::is_pointer<A>()    // same as above, using inherited operator bool
        && ! std::is_pointer<A>{}    // ditto
        && ! std::is_pointer<A>()()  // same as above, using inherited operator()
        && ! std::is_pointer<A>{}()  // ditto
        &&   std::is_pointer_v<A*>
        &&   std::is_pointer_v<A const* volatile>
        && ! std::is_pointer_v<A&>
        && ! std::is_pointer_v<decltype(mem_data_ptr)>
        && ! std::is_pointer_v<decltype(mem_fun_ptr)>
        &&   std::is_pointer_v<void*>
        && ! std::is_pointer_v<int>
        &&   std::is_pointer_v<int*>
        &&   std::is_pointer_v<int**>
        && ! std::is_pointer_v<int[10]>
        && ! std::is_pointer_v<std::nullptr_t>
        &&   std::is_pointer_v<void (*)()>
    );
}
```

### See also

| [is_member_pointer](is_member_pointer)(C++11)                   | checks if a type is a pointer to a non-static member function or object(class template) |
| --------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| [is_member_object_pointer](is_member_object_pointer)(C++11)     | checks if a type is a pointer to a non-static member object(class template)             |
| [is_member_function_pointer](is_member_function_pointer)(C++11) | checks if a type is a pointer to a non-static member function(class template)           |
| [is_array](is_array)(C++11)                                     | checks if a type is an array type(class template)                                       |
| [is_scalar](is_scalar)(C++11)                                   | checks if a type is a scalar type(class template)                                       |

© cppreference.comLicensed under the Creative Commons Attribution-ShareAlike Unported License v3.0.

[https://en.cppreference.com/w/cpp/types/is_pointer](https://en.cppreference.com/w/cpp/types/is_pointer) 



