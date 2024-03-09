#ifndef __TYPE_H__
#define __TYPE_H__
#include <vector>
#include <string>
#include "SymbolTable.h"

class Type
{
private:
    int kind;
protected:
    enum {INT, VOID, FUNC, PTR, ARRAY, FLOAT};
    int size;
public:
    Type(int kind, int size = 0) : kind(kind), size(size) {};
    virtual ~Type() {};
    virtual std::string toStr() = 0;
    bool isInt() const {return kind == INT;};
    bool isVoid() const {return kind == VOID;};
    bool isFunc() const {return kind == FUNC;};
    bool isArray() const {return kind == ARRAY;};
    bool isFloat() const {return kind == FLOAT;};
    bool isPtr() const {return kind == PTR;};
    int getSize() const { return size; };
    void setSize(int s) {size = s;};
    int getKind() const {return kind;};
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
    std::vector<SymbolEntry*> paramsSymbolEntry;
public:
    FunctionType(Type* returnType, std::vector<Type*> paramsType, std::vector<SymbolEntry*> paramsSymbolEntry) : 
    Type(Type::FUNC), returnType(returnType), paramsType(paramsType), paramsSymbolEntry(paramsSymbolEntry){};
    void setParamsType(std::vector<Type*> paramsType) {this->paramsType = paramsType;};
    std::vector<Type*> getParamsType() { return paramsType; };
    std::vector<SymbolEntry*> getParamsSymbolEntry() { return paramsSymbolEntry; };
    Type* getRetType() {return returnType;};
    std::string toStr();
};

class PointerType : public Type
{
private:
    Type *valueType;
public:
    PointerType(Type* valueType) : Type(Type::PTR) {this->valueType = valueType;};
    std::string toStr();
};

class TypeSystem
{
private:
    static IntType commonInt;
    static IntType commonBool;
    static VoidType commonVoid;
    static FloatType commonFloat;
    static FloatType commonConstFloat;
    static IntType commonConstInt;
public:
    static Type *intType;
    static Type *voidType;
    static Type *boolType;
    static Type *floatType;
    static Type *constIntType;
    static Type *constFloatType;
};

#endif
