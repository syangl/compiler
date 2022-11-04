#include "Type.h"
#include <sstream>

IntType TypeSystem::commonInt = IntType(4);
VoidType TypeSystem::commonVoid = VoidType();
FloatType TypeSystem::commonFloat = FloatType(4);
FloatType TypeSystem::commonConstFloat = FloatType(4, true);
IntType TypeSystem::commonConstInt = IntType(4, true);

Type* TypeSystem::intType = &commonInt;
Type* TypeSystem::voidType = &commonVoid;
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

std::string ArrayType::toStr()
{
    // TODO:先写一维数组 
    std::ostringstream buffer;
    buffer << "int";
    if (getLength() == 0){
        buffer << "[" << "]";
    }
    else{
        buffer << "[" << getLength() << "]";
    }
    return buffer.str();
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
