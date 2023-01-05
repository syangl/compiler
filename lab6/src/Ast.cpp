#include "Ast.h"
#include "SymbolTable.h"
#include "Unit.h"
#include "Instruction.h"
#include "IRBuilder.h"
#include <string>
#include "Type.h"

extern Unit unit;
extern MachineUnit mUnit;
extern FILE *yyout;
int Node::counter = 0;
IRBuilder* Node::builder = nullptr;

Node::Node()
{
    seq = counter++;
    bro = nullptr;
}

// Node* Node::getRightestBro(){
//     Node* node = this;
//     while(node->brother()){
//         node = node->brother();
//     }
//     return node;
// }
// 上面的实现错了
void Node::getRightestBro(Node* node) {
    Node* n = this;
    while (n->brother()) {
        n = n->brother();
    }
    if (n == this) {
        this->bro = node;
    } else {
        n->getRightestBro(node);
    }
}

int BinaryExpr::intValue() {
    int value = 0;
    switch (op) {
        case ADD:
            value = expr1->intValue() + expr2->intValue();
            break;
        case SUB:
            value = expr1->intValue() - expr2->intValue();
            break;
        case MUL:
            value = expr1->intValue() * expr2->intValue();
            break;
        case DIV:
            value = expr1->intValue() / expr2->intValue();
            break;
        case MOD:
            value = expr1->intValue() % expr2->intValue();
            break;
        case AND:
            value = expr1->intValue() && expr2->intValue();
            break;
        case OR:
            value = expr1->intValue() || expr2->intValue();
            break;
        case LESS:
            value = expr1->intValue() < expr2->intValue();
            break;
        case LEQU:
            value = expr1->intValue() <= expr2->intValue();
            break;
        case GREAT:
            value = expr1->intValue() > expr2->intValue();
            break;
        case GEQU:
            value = expr1->intValue() >= expr2->intValue();
            break;
        case EQUAL:
            value = expr1->intValue() == expr2->intValue();
            break;
        case NOTEQUAL:
            value = expr1->intValue() != expr2->intValue();
            break;
        default:
            value = 0;
    }
    return value;
}
int UnaryExpr::intValue() {
        int value = 0;
    switch (op) {
        case SUB:
            value = -(expr->intValue());
            break;
        case NOT:
            value = !(expr->intValue());
            break;
        default:
            value = 0;
    }
    return value;
}
int Constant::intValue() {
    return ((ConstantSymbolEntry*)symbolEntry)->getValue();
}
int Id::intValue() {
    return ((IdentifierSymbolEntry*)symbolEntry)->getValue();
}

void Ast::output()
{
    fprintf(yyout, "program\n");
    if(root != nullptr)
        root->output(4);
}

void Node::backPatch(std::vector<Instruction*> &list, BasicBlock*bb)
{
    for(auto &inst:list)
    {
        if(inst->isCond())
            dynamic_cast<CondBrInstruction*>(inst)->setTrueBranch(bb);
        else if(inst->isUncond())
            dynamic_cast<UncondBrInstruction*>(inst)->setBranch(bb);
    }
}

std::vector<Instruction*> Node::merge(std::vector<Instruction*> &list1, std::vector<Instruction*> &list2)
{
    std::vector<Instruction*> res(list1);
    res.insert(res.end(), list2.begin(), list2.end());
    return res;
}

void Ast::genCode(Unit *unit)
{
    IRBuilder *builder = new IRBuilder(unit);
    Node::setIRBuilder(builder);
    root->genCode();
}

void FunctionDef::genCode()
{
    Unit *unit = builder->getUnit();
    Function *func = new Function(unit, se);
    BasicBlock *entry = func->getEntry();
    // set the insert point to the entry basicblock of this function.
    builder->setInsertBB(entry);
    if (decl != nullptr){
        decl->genCode();
    }
    if (stmt != nullptr){
        stmt->genCode();
    }

    /**
     * Construct control flow graph. You need do set successors and predecessors for each basic block.
     * Todo
    */
    for (auto block = func->begin(); block != func->end(); block++){
        Instruction *last = (*block)->rbegin();
        Instruction *q = (*block)->begin();
        // 102有个块中间多了一条分支？中间有些条件只要结果不要分支指令，所以要删除
        while (q != last){
            if (q->isCond() || q->isUncond()){
                (*block)->remove(q);
            }
            q = q->getNext();
        }
        
        if (last->isCond()) {
            BasicBlock *trueBranch;
            BasicBlock *falseBranch;
            trueBranch = (dynamic_cast<CondBrInstruction*>(last))->getTrueBranch();
            falseBranch = (dynamic_cast<CondBrInstruction*>(last))->getFalseBranch();
            if (trueBranch->empty() == true) {
                new RetInstruction(nullptr, trueBranch);
            } else if (falseBranch->empty() == true) {
                new RetInstruction(nullptr, falseBranch);
            }
            (*block)->addSucc(trueBranch);
            (*block)->addSucc(falseBranch);
            trueBranch->addPred(*block);
            falseBranch->addPred(*block);            
        }
        else if (last->isUncond()){
            BasicBlock *destination = (dynamic_cast<UncondBrInstruction *>(last))->getBranch();
            (*block)->addSucc(destination);
            destination->addPred(*block);
            if (destination->empty() == true){
                if (((FunctionType *)(se->getType()))->getRetType() == TypeSystem::intType){
                    new RetInstruction(new Operand(new ConstantSymbolEntry(TypeSystem::intType, 0)), destination);
                }
                else if (((FunctionType *)(se->getType()))->getRetType() == TypeSystem::voidType){
                    new RetInstruction(nullptr, destination);
                }
            }
        }
        else {
            if (last->isRet() == false){
                if (((FunctionType*)(se->getType()))->getRetType() == TypeSystem::voidType) {
                    new RetInstruction(nullptr, *block);
                }
            }
        }
    }
}

void BinaryExpr::genCode()
{
    BasicBlock *bb = builder->getInsertBB();
    Function *func = bb->getParent();
    if (op == AND)
    {
        BasicBlock *trueBB = new BasicBlock(func);  // if the result of lhs is true, jump to the trueBB.
        expr1->genCode();
        backPatch(expr1->trueList(), trueBB);
        builder->setInsertBB(trueBB);               // set the insert point to the trueBB so that intructions generated by expr2 will be inserted into it.
        expr2->genCode();
        true_list = expr2->trueList();
        false_list = merge(expr1->falseList(), expr2->falseList());
    }
    else if(op == OR)
    {
        // Todo
        BasicBlock* trueBB = new BasicBlock(func);
        expr1->genCode();
        backPatch(expr1->falseList(), trueBB);
        builder->setInsertBB(trueBB);
        expr2->genCode();
        true_list = merge(expr1->trueList(), expr2->trueList());
        false_list = expr2->falseList();
    }
    else if(op >= LESS && op <= NOTEQUAL)
    {
        // Todo
        expr1->genCode();
        expr2->genCode();
        Operand* src1 = expr1->getOperand();
        Operand* src2 = expr2->getOperand();
        // 零扩展
        if (src1->getType()->getSize() == 1) {
            Operand* dst = new Operand(new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel()));
            new ZeroExtensionInstruction(dst, src1, bb);
            src1 = dst;
        }
        if (src2->getType()->getSize() == 1) {
            Operand* dst = new Operand(new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel()));
            new ZeroExtensionInstruction(dst, src2, bb);
            src2 = dst;
        }
        
        int opcode;
        switch (op) {
            case LESS:
                opcode = CmpInstruction::L;
                break;
            case LEQU:
                opcode = CmpInstruction::LE;
                break;
            case GREAT:
                opcode = CmpInstruction::G;
                break;
            case GEQU:
                opcode = CmpInstruction::GE;
                break;
            case EQUAL:
                opcode = CmpInstruction::E;
                break;
            case NOTEQUAL:
                opcode = CmpInstruction::NE;
                break;
        }
        new CmpInstruction(opcode, dst, src1, src2, bb);

        BasicBlock *temp_bb = new BasicBlock(func);
        BasicBlock *true_bb = new BasicBlock(func);
        BasicBlock *false_bb = new BasicBlock(func);
        true_list.push_back(new CondBrInstruction(true_bb, temp_bb, dst, bb));
        false_list.push_back(new UncondBrInstruction(false_bb, temp_bb));
    }
    else if(op >= ADD && op <= MOD)
    {
        expr1->genCode();
        expr2->genCode();
        Operand *src1 = expr1->getOperand();
        Operand *src2 = expr2->getOperand();
        int opcode;
        switch (op)
        {
        case ADD:
            opcode = BinaryInstruction::ADD;
            break;
        case SUB:
            opcode = BinaryInstruction::SUB;
            break;
        case MUL:
            opcode = BinaryInstruction::MUL;
            break;
        case DIV:
            opcode = BinaryInstruction::DIV;
            break;
        case MOD:
            opcode = BinaryInstruction::MOD;
            break;
        }
        new BinaryInstruction(opcode, dst, src1, src2, bb);
    }
}

void Constant::genCode()
{
    // we don't need to generate code.
}

void Id::genCode()
{
    BasicBlock *bb = builder->getInsertBB();
    Operand *addr = dynamic_cast<IdentifierSymbolEntry*>(symbolEntry)->getAddr();
    new LoadInstruction(dst, addr, bb);
}

void IfStmt::genCode()
{
    Function *func;
    BasicBlock *then_bb, *end_bb;

    func = builder->getInsertBB()->getParent();
    then_bb = new BasicBlock(func);
    end_bb = new BasicBlock(func);

    cond->genCode();
    backPatch(cond->trueList(), then_bb);
    backPatch(cond->falseList(), end_bb);

    builder->setInsertBB(then_bb);
    thenStmt->genCode();
    then_bb = builder->getInsertBB();
    new UncondBrInstruction(end_bb, then_bb);

    builder->setInsertBB(end_bb);
}

void IfElseStmt::genCode()
{
    // Todo
    Function* func;
    BasicBlock *then_bb, *else_bb, *end_bb;

    func = builder->getInsertBB()->getParent();
    then_bb = new BasicBlock(func);
    else_bb = new BasicBlock(func);
    end_bb = new BasicBlock(func);

    cond->genCode();
    backPatch(cond->trueList(), then_bb);
    backPatch(cond->falseList(), else_bb);

    builder->setInsertBB(then_bb);
    thenStmt->genCode();
    then_bb = builder->getInsertBB();
    new UncondBrInstruction(end_bb, then_bb);

    builder->setInsertBB(else_bb);
    elseStmt->genCode();
    else_bb = builder->getInsertBB();
    new UncondBrInstruction(end_bb, else_bb);

    builder->setInsertBB(end_bb);
}

void CompoundStmt::genCode()
{
    // Todo
    if (stmt){
        stmt->genCode();
    }
}

void SeqNode::genCode()
{
    // Todo
    stmt1->genCode();
    stmt2->genCode();
}

void DeclStmt::genCode()
{//???
    IdentifierSymbolEntry *se = dynamic_cast<IdentifierSymbolEntry *>(id->getSymPtr());
    if(se->isGlobal())
    {
        Operand *addr;
        SymbolEntry *addr_se;
        addr_se = new IdentifierSymbolEntry(*se);
        addr_se->setType(new PointerType(se->getType()));
        addr = new Operand(addr_se);
        se->setAddr(addr);
        unit.insertGlobal(se);
    }
    else if(se->isLocal() || se->isParam())
    {
        Function *func = builder->getInsertBB()->getParent();
        BasicBlock *entry = func->getEntry();
        Instruction *alloca;
        Operand *addr;
        SymbolEntry *addr_se;
        Type *type;
        type = new PointerType(se->getType());
        addr_se = new TemporarySymbolEntry(type, SymbolTable::getLabel());
        addr = new Operand(addr_se);
        alloca = new AllocaInstruction(addr, se);                   // allocate space for local id in function stack.
        entry->insertFront(alloca);                                 // allocate instructions should be inserted into the begin of the entry block.
        Operand* tmp;
        if (se->isParam() == true){
            tmp = se->getAddr();
        }
        se->setAddr(addr);                                          // set the addr operand in symbol entry so that we can use it in subsequent code generation.
        if (expr != nullptr){
            BasicBlock *bb = builder->getInsertBB();
            expr->genCode();
            Operand *src = expr->getOperand();
            new StoreInstruction(addr, src, bb);
        }
        if (se->isParam() == true){
            BasicBlock* bb = builder->getInsertBB();
            new StoreInstruction(addr, tmp, bb);
        }
    }
    if (this->brother()) {
        this->brother()->genCode();
    }
}

void ReturnStmt::genCode()
{
    // Todo
    BasicBlock* bb = builder->getInsertBB();
    Operand* src;
    if (retValue != nullptr) {
        retValue->genCode();
        src = retValue->getOperand();
    }else{
        src = nullptr;
    } 
    new RetInstruction(src, bb);
}

void AssignStmt::genCode()
{
    BasicBlock *bb = builder->getInsertBB();
    expr->genCode();
    Operand *addr = dynamic_cast<IdentifierSymbolEntry*>(lval->getSymPtr())->getAddr();
    Operand *src = expr->getOperand();
    /***
     * We haven't implemented array yet, the lval can only be ID. So we just store the result of the `expr` to the addr of the id.
     * If you want to implement array, you have to caculate the address first and then store the result into it.
     */
    new StoreInstruction(addr, src, bb);
}

void ExprStmt::genCode() {
    expr->genCode();
}

void UnaryExpr::genCode() {
    // Todo
    expr->genCode();
    if (op == SUB){
        BasicBlock *bb = builder->getInsertBB();
        Operand *src1 = new Operand(new ConstantSymbolEntry(TypeSystem::intType, 0));
        Operand *src2;
        if (expr->getType()->getSize() == 1){
            src2 = new Operand(new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel()));
            new ZeroExtensionInstruction(src2, expr->getOperand(), bb);
        }
        else{
            src2 = expr->getOperand();
        }
        new BinaryInstruction(BinaryInstruction::SUB, dst, src1, src2, bb);
    }
    else if (op == NOT){
        BasicBlock *bb = builder->getInsertBB();
        Operand* src = expr->getOperand();
        if (expr->getType()->getSize() == 32){
            Operand* cmp_res = new Operand(new TemporarySymbolEntry(TypeSystem::boolType, SymbolTable::getLabel()));
            new CmpInstruction(CmpInstruction::NE, cmp_res, src, new Operand(new ConstantSymbolEntry(TypeSystem::intType, 0)), bb);
            src = cmp_res;
        }
        new XorInstruction(dst, src, bb);
    }
}

void ContinueStmt::genCode() {
    // Todo
    Function* func = builder->getInsertBB()->getParent();
    BasicBlock* bb = builder->getInsertBB();
    new UncondBrInstruction(((WhileStmt*)whileStmt)->getCondBb(), bb);
    BasicBlock *next_bb = new BasicBlock(func);
    builder->setInsertBB(next_bb);
}

void BreakStmt::genCode() {
    // Todo
    Function* func = builder->getInsertBB()->getParent();
    BasicBlock* bb = builder->getInsertBB();
    new UncondBrInstruction(((WhileStmt*)whileStmt)->getEndBb(), bb);
    BasicBlock *next_bb = new BasicBlock(func);
    builder->setInsertBB(next_bb);
}

void WhileStmt::genCode() {
    // Todo
    Function* func = builder->getInsertBB()->getParent();
    BasicBlock *cond_bb, *whilebody_bb, *end_bb, *bb; 
    cond_bb = new BasicBlock(func);
    whilebody_bb = new BasicBlock(func);
    end_bb = new BasicBlock(func);
    bb = builder->getInsertBB();
    this->condBb = cond_bb;
    this->endBb = end_bb;
    
    new UncondBrInstruction(cond_bb, bb);
    builder->setInsertBB(cond_bb);
    cond->genCode();
    backPatch(cond->trueList(), whilebody_bb);
    backPatch(cond->falseList(), end_bb);

    builder->setInsertBB(whilebody_bb);
    stmt->genCode();
    whilebody_bb = builder->getInsertBB();
    new UncondBrInstruction(cond_bb, whilebody_bb);

    builder->setInsertBB(end_bb);
}

void FunctionCallExpr::genCode(){
    // Todo
    std::vector<Operand*> operands;
    ExprNode* p = param;
    while (p != nullptr)
    {
        p->genCode();
        operands.push_back(p->getOperand());
        p = ((ExprNode*)p->brother());
    }

    BasicBlock *bb = builder->getInsertBB();
    new FuncCallInstruction(dst, symbolEntry, operands, bb);
}

void EmptyStmt::genCode(){
    // Todo
    // do nothing
}



bool Ast::typeCheck(Type* retType)
{
    if(root != nullptr){
        root->typeCheck();
    }
    return false;
}

bool ContinueStmt::typeCheck(Type* retType) {//参数可能用不到，但不写调用可能出错
    return false;
}

bool BreakStmt::typeCheck(Type* retType) {
    return false;
}

bool WhileStmt::typeCheck(Type* retType) {
    if (stmt != nullptr){
        bool res = stmt->typeCheck(retType);
        return res;
    }
    return false;
}

bool EmptyStmt::typeCheck(Type* retType) {
    return false;
}

bool FunctionCallExpr::typeCheck(Type* retType) {
    return false;
}
FunctionCallExpr::FunctionCallExpr(SymbolEntry* se, ExprNode* param): ExprNode(se), param(param){
    // 创建函数调用节点时参数有可能不匹配，应该在构造时就发现错误
    SymbolEntry *tmp_se = se;
    long unsigned int count = 0;
    ExprNode *countNode = param;
    while(countNode != nullptr){
        countNode = (ExprNode*)(countNode->brother());
        ++count;
    }
    // 没有函数重载
    Type *type = tmp_se->getType();
    FunctionType *ft = (FunctionType *)type;
    std::vector<Type *> params = ft->getParamsType();
    if (count == params.size()){
        this->symbolEntry = tmp_se;
    }

    if (symbolEntry != nullptr){
        Type* type = symbolEntry->getType();
        FunctionType * ft2 = (FunctionType*)type;
        this->type = ft2->getRetType();
        if (this->type != TypeSystem::voidType){
            SymbolEntry* se = new TemporarySymbolEntry(this->type, SymbolTable::getLabel());
            dst = new Operand(se);
        }
        std::vector<Type*> params = ft2->getParamsType();
        ExprNode* temp = param;
        for (auto i = params.begin(); i != params.end(); ++i) {
            if (temp == nullptr) {
                fprintf(stderr, "too few arguments to function %s %s\n", symbolEntry->toStr().c_str(), type->toStr().c_str());
                break;
            } else if ((*i)->getKind() != temp->getType()->getKind()){
                fprintf(stderr, "parameter's type %s can't convert to %s\n", temp->getType()->toStr().c_str(), (*i)->toStr().c_str());
            }
            temp = (ExprNode*)(temp->brother());
        }
        // too many
        if (temp != nullptr) {
            fprintf(stderr, "too many arguments to function %s %s\n", symbolEntry->toStr().c_str(), type->toStr().c_str());
        }
    }

    if (((IdentifierSymbolEntry*)se)->isSysy() == true){
        unit.insertSysy(se);
    }

}

bool UnaryExpr::typeCheck(Type* retType) {
    return false;
}

UnaryExpr::UnaryExpr(SymbolEntry* se, int op, ExprNode* expr) : ExprNode(se, UNARYEXPR), op(op), expr(expr){
    std::string op_str;
    if (op == UnaryExpr::NOT){
        op_str = "!";
    }else{
        op_str = "-";
    }
    if (expr->getType()->isVoid()) {
        fprintf(stderr, "invalid operand of type \'void\' to unary \'opeartor%s\'\n", op_str.c_str());
    }

    if (op == UnaryExpr::NOT){
        type = TypeSystem::intType;
        dst = new Operand(se);
        if (expr->isUnaryExpr()) {
            UnaryExpr* ue = (UnaryExpr*)expr;
            if (ue->getOp() == UnaryExpr::NOT) {
                if (ue->getType() == TypeSystem::intType){
                    ue->setType(TypeSystem::boolType);
                }
            }
        }   
    } 
    else if (op == UnaryExpr::SUB) {
        type = TypeSystem::intType;
        dst = new Operand(se);
        if (expr->isUnaryExpr()) {
            UnaryExpr* ue = (UnaryExpr*)expr;
            if (ue->getOp() == UnaryExpr::NOT){
                if (ue->getType() == TypeSystem::intType){
                    ue->setType(TypeSystem::boolType);
                }
            }
        }
    }

}

bool ExprStmt::typeCheck(Type* retType) {
    return false;
}

bool FunctionDef::typeCheck(Type* retType)
{
    // Todo
    SymbolEntry* se = this->getSymbolEntry();
    StmtNode* stmt = this->stmt;
    FunctionType * ft = (FunctionType*)(se->getType());
    Type * funcRetType = ft->getRetType();
    if (!stmt){
        if (funcRetType != TypeSystem::voidType){
            fprintf(stderr, "non-void function does not return a value\n");
        }
        return false;
    }
    if (!stmt->typeCheck(funcRetType)) {// 返回值真假的作用是标识有没有遇到return语句
        fprintf(stderr, "function does not have a return statement\n");
        return false;
    }
    return false;
}

bool BinaryExpr::typeCheck(Type* retType)
{
    return false;
}
ImplictCastExpr::ImplictCastExpr(ExprNode* expr): ExprNode(nullptr, IMPLICTCASTEXPR), expr(expr) {
    type = TypeSystem::boolType;
    dst = new Operand(new TemporarySymbolEntry(type, SymbolTable::getLabel()));
}
BinaryExpr::BinaryExpr(SymbolEntry* se, int op, ExprNode* expr1, ExprNode* expr2): ExprNode(se), op(op), expr1(expr1), expr2(expr2) {
    dst = new Operand(se);
    std::string op_str;
        switch (op) {
        case ADD:
            op_str = "+";
            break;
        case SUB:
            op_str = "-";
            break;
        case MUL:
            op_str = "*";
            break;
        case DIV:
            op_str = "/";
            break;
        case MOD:
            op_str = "%";
            break;
        case AND:
            op_str = "&&";
            break;
        case OR:
            op_str = "||";
            break;
        case LESS:
            op_str = "<";
            break;
        case LEQU:
            op_str = "<=";
            break;
        case GREAT:
            op_str = ">";
            break;
        case GEQU:
            op_str = ">=";
            break;
        case EQUAL:
            op_str = "==";
            break;
        case NOTEQUAL:
            op_str = "!=";
            break;
    }
    if (expr1->getType()->isVoid() || expr2->getType()->isVoid()) {
        fprintf(stderr, "invalid operand of type \'void\' to binary \'opeartor%s\'\n", op_str.c_str());
    }
    if ((op >= BinaryExpr::AND) && (op <= BinaryExpr::NOTEQUAL)) {
        type = TypeSystem::boolType;
        if (op == BinaryExpr::AND || op == BinaryExpr::OR) {
            if ((expr1->getType()->isInt()) && (expr1->getType()->getSize() == 32)) {
                ImplictCastExpr* ice = new ImplictCastExpr(expr1);
                this->expr1 = ice;
            }
            if ((expr2->getType()->isInt()) && (expr2->getType()->getSize() == 32)) {
                ImplictCastExpr* ice = new ImplictCastExpr(expr2);
                this->expr2 = ice;
            }
        }
    } 
    else{
        type = TypeSystem::intType;
    }
}

bool Constant::typeCheck(Type* retType)
{
    return false;
}

bool Id::typeCheck(Type* retType)
{
    return false;
}

bool IfStmt::typeCheck(Type* retType)
{
    // Todo
    if (thenStmt != nullptr){
        bool res = thenStmt->typeCheck(retType);
        return res;
    }
    return false;
}

bool IfElseStmt::typeCheck(Type* retType)
{
    // Todo
    bool res_then = false, res_else = false;
    if (thenStmt != nullptr){
        res_then = thenStmt->typeCheck(retType);
    }
    if (elseStmt != nullptr){
        res_else = elseStmt->typeCheck(retType);
    }
    return res_then || res_else;
}

bool CompoundStmt::typeCheck(Type* retType)
{
    // Todo
    if (stmt != nullptr){
        bool res = stmt->typeCheck(retType);
        return res;
    }
    return false;
}

bool SeqNode::typeCheck(Type* retType)
{
    // Todo
    bool res_stmt1 = false, res_stmt2 = false;
    if (stmt1 != nullptr){
        res_stmt1 = stmt1->typeCheck(retType);
    }
    if (stmt2 != nullptr){
        res_stmt2 = stmt2->typeCheck(retType);
    }
    return res_stmt1 || res_stmt2;
}

bool DeclStmt::typeCheck(Type* retType)
{
    return false;
}

bool ReturnStmt::typeCheck(Type* retType)
{
    // 如果在函数定义外
    if (retType == nullptr) {
        fprintf(stderr, "expected unqualified-id\n");
        return true;
    }
    if ((retValue == nullptr) && (retType->isVoid() == false)){
        fprintf(stderr, "return-statement with no value, in function returning \"%s\"\n",retType->toStr().c_str());
        return true;
    }
    if ((retValue != nullptr) && (retType->isVoid() == true)){
        fprintf(stderr, "return-statement with a value, in function returning \"%s\"\n",retType->toStr().c_str());
        return true;
    }
    if (retValue && retValue->getSymbolEntry()){
        Type *type = retValue->getType();
        if (type != retType){
            fprintf(stderr, "cannot initialize return object of type \"%s\" with an rvalue of type \"%s\"\n",
                    retType->toStr().c_str(), type->toStr().c_str());
            return true;
        }
    }
    return true;
}

bool AssignStmt::typeCheck(Type* retType)
{
    return false;
}
AssignStmt::AssignStmt(ExprNode* lval, ExprNode* expr): lval(lval), expr(expr) {
    Type* type = ((Id*)lval)->getType();
    SymbolEntry* se = lval->getSymbolEntry();

    if (type->isInt()){
        if (((IntType*)type)->isConstant()) {
            fprintf(stderr, "cannot assign to variable \'%s\' with const-qualified type \'%s\'\n", ((IdentifierSymbolEntry*)se)->toStr().c_str(), type->toStr().c_str());
        }
    }
    if ((expr->getType()->isInt()) == false){
        fprintf(stderr, "cannot initialize a variable of type \'int\' with an rvalue of type \'%s\'\n", expr->getType()->toStr().c_str());
    }

}

void ImplictCastExpr::output(int level) {
    fprintf(yyout, "%*cImplictCastExpr\ttype: %s to %s\n", level, ' ', expr->getType()->toStr().c_str(), type->toStr().c_str());
    this->expr->output(level + 4);
}

void ImplictCastExpr::genCode() {
    expr->genCode();
    BasicBlock* bb = builder->getInsertBB();
    Function* func = bb->getParent();
    BasicBlock* truebb = new BasicBlock(func);
    BasicBlock* tmpbb = new BasicBlock(func);
    BasicBlock* falsebb = new BasicBlock(func);
    new CmpInstruction(CmpInstruction::NE, this->dst, this->expr->getOperand(), new Operand(new ConstantSymbolEntry(TypeSystem::intType, 0)), bb);
    this->trueList().push_back(new CondBrInstruction(truebb, tmpbb, this->dst, bb));
    this->falseList().push_back(new UncondBrInstruction(falsebb, tmpbb));
}

void BinaryExpr::output(int level)
{
    std::string op_str;
    switch(op)
    {
        case ADD:
            op_str = "add";
            break;
        case SUB:
            op_str = "sub";
            break;
        case MUL:
            op_str = "mul";
            break;
        case DIV:
            op_str = "div";
            break;
        case MOD:
            op_str = "mod";
            break;
        case AND:
            op_str = "and";
            break;
        case OR:
            op_str = "or";
            break;
        case LESS:
            op_str = "less";
            break;
        case LEQU:
            op_str = "lequ";
            break;
        case EQUAL:
            op_str = "equal";
            break;
        case NOTEQUAL:
            op_str = "notequal";
            break;
        case GREAT:
            op_str = "great";
            break;
        case GEQU:
            op_str = "gequ";
            break;
    }
    fprintf(yyout, "%*cBinaryExpr\top: %s\n", level, ' ', op_str.c_str());
    expr1->output(level + 4);
    expr2->output(level + 4);
}

void UnaryExpr::output(int level) 
{
    std::string op_str;
    switch (op) {
        case NOT:
            op_str = "not";
            break;
        case SUB:
            op_str = "negative";//...
            break;
    }
    fprintf(yyout, "%*cUnaryExpr\top: %s\n", level, ' ', op_str.c_str());
    expr->output(level + 4);
}

// TODO: FunctionCall
void FunctionCallExpr::output(int level) {
    std::string name, type;
    int scope;
    if (symbolEntry){
        name = symbolEntry->toStr();
        type = symbolEntry->getType()->toStr();
        scope = dynamic_cast<IdentifierSymbolEntry *>(symbolEntry)->getScope();
        fprintf(yyout, "%*cCallee\tfunction name: %s\ttype: %s\tscope:  %d\n",
                    level, ' ', name.c_str(), type.c_str(), scope);
        Node *tmp = param;
        while (tmp){
            tmp->output(level + 4);
            tmp = tmp->brother();
        }
    }
}

void Constant::output(int level)
{
    std::string type, value;
    type = symbolEntry->getType()->toStr();
    value = symbolEntry->toStr();
    fprintf(yyout, "%*cIntegerLiteral\tvalue: %s\ttype: %s\n", level, ' ',
            value.c_str(), type.c_str());
}

void Id::output(int level)
{
    std::string name, type;
    int scope;
    name = symbolEntry->toStr();
    type = symbolEntry->getType()->toStr();
    scope = dynamic_cast<IdentifierSymbolEntry*>(symbolEntry)->getScope();
    fprintf(yyout, "%*cId\tname: %s\tscope: %d\ttype: %s\n", level, ' ',
            name.c_str(), scope, type.c_str());
}

void CompoundStmt::output(int level)
{
    fprintf(yyout, "%*cCompoundStmt\n", level, ' ');
    stmt->output(level + 4);
}

void SeqNode::output(int level)
{
    stmt1->output(level);
    stmt2->output(level);
}

void DeclStmt::output(int level)
{
    fprintf(yyout, "%*cDeclStmt\n", level, ' ');
    id->output(level + 4);
    if (expr) expr->output(level + 4);
    if (this->brother()) this->brother()->output(level);
}

void IfStmt::output(int level)
{
    fprintf(yyout, "%*cIfStmt\n", level, ' ');
    cond->output(level + 4);
    thenStmt->output(level + 4);
}

void IfElseStmt::output(int level)
{
    fprintf(yyout, "%*cIfElseStmt\n", level, ' ');
    cond->output(level + 4);
    thenStmt->output(level + 4);
    elseStmt->output(level + 4);
}

WhileStmt::WhileStmt(ExprNode *cond, StmtNode *stmt): cond(cond), stmt(stmt)
{
    if (cond->getType()->isInt() && cond->getType()->getSize() == 32){
        ImplictCastExpr *tmp = new ImplictCastExpr(cond);
        this->cond = tmp;
    }
}

void WhileStmt::output(int level)
{
    fprintf(yyout, "%*cWhileStmt\n", level, ' ');
    cond->output(level + 4);
    stmt->output(level + 4);
}

void BreakStmt::output(int level)
 {
    fprintf(yyout, "%*cBreakStmt\n", level, ' ');
}

void ContinueStmt::output(int level) 
{
    fprintf(yyout, "%*cContinueStmt\n", level, ' ');
}

void ReturnStmt::output(int level)
{
    fprintf(yyout, "%*cReturnStmt\n", level, ' ');
    if (retValue != nullptr){
        retValue->output(level + 4);
    }
}

void AssignStmt::output(int level)
{
    fprintf(yyout, "%*cAssignStmt\n", level, ' ');
    lval->output(level + 4);
    expr->output(level + 4);
}

void ExprStmt::output(int level)
{
    fprintf(yyout, "%*cAssignStmt\n", level, ' ');
    expr->output(level + 4);
}

void EmptyStmt::output(int level)
{
    fprintf(yyout, "%*cEmptyStmt\n", level, ' ');
}


void FunctionDef::output(int level)
{
    std::string name, type;
    name = se->toStr();
    type = se->getType()->toStr();
    fprintf(yyout, "%*cFunctionDefine function name: %s, type: %s\n", level, ' ', 
            name.c_str(), type.c_str());
    stmt->output(level + 4);
}
