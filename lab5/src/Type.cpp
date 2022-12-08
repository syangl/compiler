#include "Type.h"
#include <sstream>

IntType TypeSystem::commonInt = IntType(32);
IntType TypeSystem::commonBool = IntType(1);
VoidType TypeSystem::commonVoid = VoidType();
FloatType TypeSystem::commonFloat = FloatType(32);
FloatType TypeSystem::commonConstFloat = FloatType(32, true);
IntType TypeSystem::commonConstInt = IntType(32, true);

Type* TypeSystem::intType = &commonInt;
Type* TypeSystem::voidType = &commonVoid;
Type* TypeSystem::boolType = &commonBool;
Type* TypeSystem::floatType = &commonFloat;
Type* TypeSystem::constIntType = &commonConstInt;
Type* TypeSystem::constFloatType = &commonConstFloat;

std::string IntType::toStr()
{
    return constant ? "const int" : "int";
}

std::string VoidType::toStr()
{
    return "void";
}

std::string FloatType::toStr()
{
    return constant ? "const float" : "float";
}

std::string FunctionType::toStr()
{
    std::ostringstream buffer;
    buffer << returnType->toStr() << "(";
    for (auto p = paramsType.begin(); p != paramsType.end(); ++p) {
        buffer << (*p)->toStr();
        if (p + 1 != paramsType.end()){
            buffer << ", ";
        }
    }
    buffer << ")";
    return buffer.str();
}

std::string PointerType::toStr()
{
    std::ostringstream buffer;
    buffer << valueType->toStr() << "*";
    return buffer.str();
}
