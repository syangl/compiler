#ifndef __UNIT_H__
#define __UNIT_H__

#include <vector>
#include "Function.h"
#include "AsmBuilder.h"

/**
 * note：Unit 为编译单元，是中间代码的顶层模块，包含中间代码生成时创建的函数。
*/

class Unit
{
    typedef std::vector<Function *>::iterator iterator;
    typedef std::vector<Function *>::reverse_iterator reverse_iterator;

private:
    std::vector<SymbolEntry*> global_list;
    std::vector<SymbolEntry*> sysy_list;
    std::vector<Function *> func_list;
public:
    Unit() = default;
    ~Unit() ;
    void insertGlobal(SymbolEntry*);
    void removeGlobal(SymbolEntry*);
    void insertSysy(SymbolEntry*);
    void removeSysy(SymbolEntry*);
    void insertFunc(Function *);
    void removeFunc(Function *);
    void output() const;
    iterator begin() { return func_list.begin(); };
    iterator end() { return func_list.end(); };
    reverse_iterator rbegin() { return func_list.rbegin(); };
    reverse_iterator rend() { return func_list.rend(); };
    void genMachineCode(MachineUnit* munit);
};

#endif