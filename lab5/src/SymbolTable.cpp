#include "SymbolTable.h"
#include <iostream>
#include <sstream>
#include "Type.h"

SymbolEntry::SymbolEntry(Type *type, int kind) 
{
    this->type = type;
    this->kind = kind;
}

ConstantSymbolEntry::ConstantSymbolEntry(Type *type, int value) : SymbolEntry(type, SymbolEntry::CONSTANT)
{
    this->value = value;
}

ConstantSymbolEntry::ConstantSymbolEntry(Type *type, float value) : SymbolEntry(type, SymbolEntry::CONSTANT)
{
    this->floatValue = value;
}

std::string ConstantSymbolEntry::toStr()
{
    std::ostringstream buffer;
    if (type->isInt())
        buffer << value;
    else if (type->isFloat())
        buffer << floatValue;
    return buffer.str();
}

IdentifierSymbolEntry::IdentifierSymbolEntry(Type *type, std::string name, int scope, bool sysy) : SymbolEntry(type, SymbolEntry::VARIABLE), name(name)
{
    this->scope = scope;
    addr = nullptr;
}

void IdentifierSymbolEntry::setValue(int value) {
    this->value = value;
}

void IdentifierSymbolEntry::setFloatValue(float value) {
    this->floatValue = value;
}

// void IdentifierSymbolEntry::setIntArray(int *arrayValue) {
//     this->intArrayValue = arrayValue;
// }

// void IdentifierSymbolEntry::setFloatArray(float *arrayValue) {
//     this->floatArrayValue = arrayValue;
// }

std::string IdentifierSymbolEntry::toStr()
{
    std::ostringstream buffer;
    if (label < 0)
        buffer << '@' << name;
    else
        buffer << "%t" << label;
    return buffer.str();
}

TemporarySymbolEntry::TemporarySymbolEntry(Type *type, int label) : SymbolEntry(type, SymbolEntry::TEMPORARY)
{
    this->label = label;
}

std::string TemporarySymbolEntry::toStr()
{
    std::ostringstream buffer;
    buffer << "%t" << label;
    return buffer.str();
}

SymbolTable::SymbolTable()
{
    prev = nullptr;
    level = 0;
}

SymbolTable::SymbolTable(SymbolTable *prev)
{
    this->prev = prev;
    this->level = prev->level + 1;
}

/*
    Description: lookup the symbol entry of an identifier in the symbol table
    Parameters: 
        name: identifier name
    Return: pointer to the symbol entry of the identifier

    hint:
    1. The symbol table is a stack. The top of the stack contains symbol entries in the current scope.
    2. Search the entry in the current symbol table at first.
    3. If it's not in the current table, search it in previous ones(along the 'prev' link).
    4. If you find the entry, return it.
    5. If you can't find it in all symbol tables, return nullptr.
*/
SymbolEntry* SymbolTable::lookup(std::string name)
{
    // Todo
    SymbolTable* cur = this;
    while(cur != nullptr)
    {
        if(cur->symbolTable.find(name) != cur->symbolTable.end())
            return cur->symbolTable[name];
        else
            cur = cur->prev;
    }
    return nullptr;
}

// install the entry into current symbol table.
bool SymbolTable::install(std::string name, SymbolEntry* entry)
{
    SymbolTable* cur = this;
    if (cur->symbolTable.find(name) != cur->symbolTable.end()){
        return false;
    }else{
        symbolTable[name] = entry;
        return true;
    }
}

int SymbolTable::counter = 0;
static SymbolTable t;
SymbolTable *identifiers = &t;
SymbolTable *globals = &t;
