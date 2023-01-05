#include "Unit.h"
#include "Ast.h"
#include "SymbolTable.h"
#include "Type.h"
extern FILE* yyout;

void Unit::insertFunc(Function *f)
{
    func_list.push_back(f);
}

void Unit::removeFunc(Function *func)
{
    func_list.erase(std::find(func_list.begin(), func_list.end(), func));
}

void Unit::insertGlobal(SymbolEntry* se){
    global_list.push_back(se);
}

void Unit::removeGlobal(SymbolEntry* se){
    global_list.erase(std::find(global_list.begin(), global_list.end(), se));
}

void Unit::insertSysy(SymbolEntry* se){
    auto item = std::find(sysy_list.begin(), sysy_list.end(), se);
    if (item == sysy_list.end()){
        sysy_list.push_back(se);
    }
}

void Unit::removeSysy(SymbolEntry* se){
    auto item = std::find(sysy_list.begin(), sysy_list.end(), se);
    if (item != sysy_list.end()){
        sysy_list.erase(item);
    }
}


void Unit::output() const
{
    for (auto se : global_list){
        fprintf(yyout, "%s = global %s %d, align 4\n", se->toStr().c_str(), se->getType()->toStr().c_str(), ((IdentifierSymbolEntry *)se)->getValue());
    }
    for (auto &func : func_list){
        func->output();
    }
    for (auto se : sysy_list)
    {
        FunctionType *type = (FunctionType *)(se->getType());
        std::string str = type->toStr();
        std::string name = str.substr(0, str.find('('));
        std::string param = str.substr(str.find('('));
        fprintf(yyout, "declare %s %s%s\n", type->getRetType()->toStr().c_str(),
                se->toStr().c_str(), param.c_str());
    }
}

void Unit::genMachineCode(MachineUnit* munit) 
{
    AsmBuilder* builder = new AsmBuilder();
    builder->setUnit(munit);
    for (auto &func : func_list){
        func->genMachineCode(builder);
    }
}

Unit::~Unit()
{
    // for (auto& se : global_list)
    //     delete se;
}
