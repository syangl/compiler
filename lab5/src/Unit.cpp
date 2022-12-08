#include "Unit.h"

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
    for (auto &func : func_list)
        func->output();
}

Unit::~Unit()
{
    for(auto &func:func_list)
        delete func;
}
