#ifndef __TYPE_H__
#define __TYPE_H__
#include <vector>
#include <string>

class Type
{
private:
    int kind;
    int size;
protected:
    enum {INT, VOID, FUNC, ARRAY, FLOAT};
public:
    Type(int kind, int size = 0) : kind(kind), size(size) {};
    virtual ~Type() {};
    virtual std::string toStr() = 0;
    bool isInt() const {return kind == INT;};
    bool isVoid() const {return kind == VOID;};
    bool isFunc() const {return kind == FUNC;};
    bool isArray() const {return kind == ARRAY;};
    bool isFloat() const {return kind == FLOAT;};
    int getSize() const { return size; };
    void setSize(int s) {size = s;};
};

class IntType : public Type
{
private:
    bool constant;
public:
    IntType(int size, bool constant = false) : Type(Type::INT, size), constant(constant){};
    std::string toStr();
    bool isConstant() const{return constant;}
};

class VoidType : public Type
{
public:
    VoidType() : Type(Type::VOID){};
    std::string toStr();
};

class FloatType : public Type
{
private:
    bool constant;
public:
    FloatType(int size, bool constant = false) : Type(Type::FLOAT, size), constant(constant){};
    std::string toStr();
    bool isConstant() const{return constant;}
};

class FunctionType : public Type
{
private:
    Type *returnType;
    std::vector<Type*> paramsType;
public:
    FunctionType(Type* returnType, std::vector<Type*> paramsType) : 
    Type(Type::FUNC), returnType(returnType), paramsType(paramsType){};
    std::string toStr();
};

class ArrayType : public Type
{
private:
    Type *elemType;
    int length;
public:
    ArrayType(Type *elemType, int length) 
    : Type(Type::ARRAY), elemType(elemType), length(length)
    {setSize(elemType->getSize() * length);};
    std::string toStr();    
    Type* getElemType() {return elemType;};
    int getLength() const {return length;};
};

class TypeSystem
{
private:
    static IntType commonInt;
    static VoidType commonVoid;
    static FloatType commonFloat;
    static FloatType commonConstFloat;
    static IntType commonConstInt;
public:
    static Type *intType;
    static Type *voidType;
    static Type *floatType;
    static Type *constIntType;
    static Type *constFloatType;
};

#endif
