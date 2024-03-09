#include "Function.h"
#include "Unit.h"
#include "Type.h"
#include <list>

/**
 * Function 是函数模块。函数由多个基本块构成，每个函数都有一个entry 基本块，它是函数的入口结点
*/

extern FILE* yyout;

Function::Function(Unit *u, SymbolEntry *s)
{
    u->insertFunc(this);
    entry = new BasicBlock(this);
    sym_ptr = s;
    parent = u;
}

Function::~Function()
{
    auto delete_list = block_list;
    for (auto &i : delete_list)
        delete i;
    parent->removeFunc(this);
}

// remove the basicblock bb from its block_list.
void Function::remove(BasicBlock *bb)
{
    block_list.erase(std::find(block_list.begin(), block_list.end(), bb));
}

void Function::output() const
{
    FunctionType* funcType = dynamic_cast<FunctionType*>(sym_ptr->getType());
    Type *retType = funcType->getRetType();
    std::vector<SymbolEntry*> paramsSymbolEntry = funcType->getParamsSymbolEntry();
    if (!paramsSymbolEntry.size())
        fprintf(yyout, "define %s %s() {\n", retType->toStr().c_str(),
                sym_ptr->toStr().c_str());
    else {
        fprintf(yyout, "define %s %s(", retType->toStr().c_str(),
                sym_ptr->toStr().c_str());
        for (long unsigned int i = 0; i < paramsSymbolEntry.size(); i++) {
            if (i){
                fprintf(yyout, ", ");
            }
            fprintf(yyout, "%s %s", paramsSymbolEntry[i]->getType()->toStr().c_str(), paramsSymbolEntry[i]->toStr().c_str());
        }
        fprintf(yyout, ") {\n");
    }
    std::set<BasicBlock *> v;
    std::list<BasicBlock *> q;
    q.push_back(entry);
    v.insert(entry);
    while (!q.empty()) // 函数的后续基本块succ依次output
    {
        auto bb = q.front();
        q.pop_front();
        bb->output();
        for (auto succ = bb->succ_begin(); succ != bb->succ_end(); succ++)
        {
            if (v.find(*succ) == v.end())
            {
                v.insert(*succ);
                q.push_back(*succ);
            }
        }
    }
    fprintf(yyout, "}\n");
}

void Function::genMachineCode(AsmBuilder* builder) 
{
    auto cur_unit = builder->getUnit();
    auto cur_func = new MachineFunction(cur_unit, this->sym_ptr);
    builder->setFunction(cur_func);
    std::map<BasicBlock*, MachineBlock*> map; // 中间代码块和目标代码块的映射
    for(auto block : block_list)
    {
        block->genMachineCode(builder);
        map[block] = builder->getBlock();
    }
    // Add pred and succ for every block
    for(auto block : block_list)
    {
        auto mblock = map[block]; // map用于给每个manchineBlock建立双向链表
        for (auto pred = block->pred_begin(); pred != block->pred_end(); pred++)
            mblock->addPred(map[*pred]);
        for (auto succ = block->succ_begin(); succ != block->succ_end(); succ++)
            mblock->addSucc(map[*succ]);
    }
    cur_unit->InsertFunc(cur_func);

}