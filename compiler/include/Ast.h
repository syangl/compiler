#ifndef __AST_H__
#define __AST_H__

#include <fstream>
#include "Operand.h"
#include "Type.h"

class SymbolEntry;
class Unit;
class Function;
class BasicBlock;
class Instruction;
class IRBuilder;

// Node
class Node
{
private:
    static int counter;
    int seq;
    Node *bro;
protected:
    std::vector<Instruction*> true_list;
    std::vector<Instruction*> false_list;
    static IRBuilder *builder;
    void backPatch(std::vector<Instruction*> &list, BasicBlock*bb);
    std::vector<Instruction*> merge(std::vector<Instruction*> &list1, std::vector<Instruction*> &list2);

public:
    Node();
    int getSeq() const {return seq;};
    static void setIRBuilder(IRBuilder*ib) {builder = ib;};
    virtual void output(int level) = 0;
    // Node *getRightestBro();
    void getRightestBro(Node* node);
    Node *brother(){return bro;};
    virtual bool typeCheck(Type* retType = nullptr) = 0;
    virtual void genCode() = 0;
    std::vector<Instruction*>& trueList() {return true_list;}
    std::vector<Instruction*>& falseList() {return false_list;}
};

// ExprNode
class ExprNode : public Node
{
private:
    int kind;
protected:
    enum { EXPR, IMPLICTCASTEXPR, UNARYEXPR};
    SymbolEntry *symbolEntry;
    Operand *dst;   // The result of the subtree is stored into dst.
    Type* type;
public:
    ExprNode(SymbolEntry *symbolEntry, int kind = EXPR) : kind(kind), symbolEntry(symbolEntry){};
    virtual int intValue(){return 0;};
    SymbolEntry *getSymbolEntry() const {return symbolEntry;};
    Operand* getOperand() {return dst;};
    SymbolEntry* getSymPtr() {return symbolEntry;};
    bool isUnaryExpr() const {return kind == UNARYEXPR;};
    virtual bool typeCheck(Type* retType = nullptr) { return false; };
    virtual Type* getType() {return type;};
    bool isImplictCastExpr() const {return kind == IMPLICTCASTEXPR;};
};

// BinaryNode
class BinaryExpr : public ExprNode
{
private:
    int op;
    ExprNode *expr1, *expr2;
public:
    enum {ADD, SUB, MUL, DIV, MOD, AND, OR, LESS, LEQU, GREAT,  GEQU, EQUAL, NOTEQUAL};
    BinaryExpr(SymbolEntry *se, int op, ExprNode*expr1, ExprNode*expr2);// : ExprNode(se), op(op), expr1(expr1), expr2(expr2){};
    void output(int level);
    int intValue();
    bool typeCheck(Type* retType = nullptr);
    void genCode();
};
// 隐式类型转换
class ImplictCastExpr : public ExprNode 
{
private:
    ExprNode* expr;
public:
    ImplictCastExpr(ExprNode* expr);
    void output(int level);
    bool typeCheck(Type* retType = nullptr) { return false; };
    void genCode();
    ExprNode* getExpr() const { return expr; };
};


// UnaryNode
class UnaryExpr : public ExprNode 
{
private:
    int op;
    ExprNode* expr;
public:
    enum { NOT, SUB };
    UnaryExpr(SymbolEntry* se, int op, ExprNode* expr);// : ExprNode(se), op(op), expr(expr);
    void output(int level);
    int intValue();
    bool typeCheck(Type* retType = nullptr);
    void genCode();
    int getOp() const {return op;};
    void setType(Type* type) {this->type = type;}
};

// FunctionCallExprNode
class FunctionCallExpr : public ExprNode 
{
private:
    ExprNode* param;
public:
    FunctionCallExpr(SymbolEntry* se, ExprNode* param = nullptr);// : ExprNode(se), param(param);
    void output(int level);
    bool typeCheck(Type* retType = nullptr);
    void genCode();
};

// ConstantNode
class Constant : public ExprNode
{
public:
    Constant(SymbolEntry *se) : ExprNode(se){dst = new Operand(se);type = TypeSystem::intType;};
    void output(int level);
    int intValue();
    bool typeCheck(Type* retType = nullptr);
    void genCode();
};

// IdNode
class Id : public ExprNode
{
public:
    Id(SymbolEntry *se) : ExprNode(se){
        if (se != nullptr){
            type = se->getType();
            SymbolEntry *temp = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
            dst = new Operand(temp);
        }
        // SymbolEntry *temp = new TemporarySymbolEntry(se->getType(), SymbolTable::getLabel()); 
        // dst = new Operand(temp);
    };
    void output(int level);
    int intValue();
    bool typeCheck(Type* retType = nullptr);
    void genCode();
};

// StmtNode
class StmtNode : public Node
{
public:
    virtual bool typeCheck(Type* retType = nullptr) = 0;
};
// CompoundStmtNode
class CompoundStmt : public StmtNode
{
private:
    StmtNode *stmt;
public:
    CompoundStmt(StmtNode *stmt = nullptr) : stmt(stmt) {};
    void output(int level);
    bool typeCheck(Type* retType = nullptr);
    void genCode();
};

// SeqNode
class SeqNode : public StmtNode
{
private:
    StmtNode *stmt1, *stmt2;
public:
    SeqNode(StmtNode *stmt1, StmtNode *stmt2) : stmt1(stmt1), stmt2(stmt2){};
    void output(int level);
    bool typeCheck(Type* retType = nullptr);
    void genCode();
};

// DeclStmt
class DeclStmt : public StmtNode
{
private:
    Id *id;
    ExprNode* expr;
public:
    DeclStmt(Id *id, ExprNode* expr = nullptr) : id(id){
        if (expr) {
            this->expr = expr;
        }
    };
    void output(int level);
    Id *getId() const {return id;};
    bool typeCheck(Type* retType = nullptr);
    void genCode();
};

// EmptyStmtNode
class EmptyStmt : public StmtNode
{
public:
    EmptyStmt(){};
    void output(int level);
    bool typeCheck(Type* retType = nullptr);
    void genCode();
};

// IfStmtNode
class IfStmt : public StmtNode
{
private:
    ExprNode *cond;
    StmtNode *thenStmt;
public:
    IfStmt(ExprNode *cond, StmtNode *thenStmt) : cond(cond), thenStmt(thenStmt){
        if (cond->getType()->isInt() && cond->getType()->getSize() == 32){
            ImplictCastExpr *temp = new ImplictCastExpr(cond);
            this->cond = temp;
        }
    };
    void output(int level);
    bool typeCheck(Type* retType = nullptr);
    void genCode();
};

// IfElseStmtNode
class IfElseStmt : public StmtNode
{
private:
    ExprNode *cond;
    StmtNode *thenStmt;
    StmtNode *elseStmt;
public:
    IfElseStmt(ExprNode *cond, StmtNode *thenStmt, StmtNode *elseStmt) : cond(cond), thenStmt(thenStmt), elseStmt(elseStmt) {
        if (cond->getType()->isInt() && cond->getType()->getSize() == 32){
            ImplictCastExpr *temp = new ImplictCastExpr(cond);
            this->cond = temp;
        }
    };
    void output(int level);
    bool typeCheck(Type* retType = nullptr);
    void genCode();
};

//WhileStmtNode
class WhileStmt : public StmtNode
{
private:
    ExprNode *cond;
    StmtNode *stmt;
    BasicBlock* condBb;
    BasicBlock* endBb;
public:
    WhileStmt(ExprNode* cond, StmtNode* stmt = nullptr);
    void setStmt(StmtNode* stmt){this->stmt = stmt;};
    void output(int level);
    bool typeCheck(Type* retType = nullptr);
    void genCode();
    BasicBlock* getCondBb() {return this->condBb;};
    BasicBlock* getEndBb() {return this->endBb;};
};

// BreakStmtNode
class BreakStmt : public StmtNode
{
private:
    StmtNode * whileStmt;
public:
    BreakStmt(StmtNode * whileStmt){this->whileStmt = whileStmt;};
    void output(int level);
    bool typeCheck(Type* retType = nullptr);
    void genCode();
};

// ContinueStmtNode
class ContinueStmt : public StmtNode
{
private:
    StmtNode * whileStmt;
public:
    ContinueStmt(StmtNode * whileStmt){this->whileStmt = whileStmt;};
    void output(int level);
    bool typeCheck(Type* retType = nullptr);
    void genCode();
};

//ReturnStmtNode
class ReturnStmt : public StmtNode
{
private:
    ExprNode *retValue;
public:
    ReturnStmt(ExprNode*retValue = nullptr) : retValue(retValue) {};
    void output(int level);
    bool typeCheck(Type* retType = nullptr);
    void genCode();
};

// AssignStmtNode
class AssignStmt : public StmtNode
{
private:
    ExprNode *lval;
    ExprNode *expr;
public:
    AssignStmt(ExprNode *lval, ExprNode *expr);// : lval(lval), expr(expr) {};
    void output(int level);
    bool typeCheck(Type* retType = nullptr);
    void genCode();
};

// ExprStmt
class ExprStmt : public StmtNode
{
private:
    ExprNode *expr;
public:
    ExprStmt(ExprNode *expr) : expr(expr) {};
    void output(int level);
    bool typeCheck(Type* retType = nullptr);
    void genCode();
};

// FunctionDefNode
class FunctionDef : public StmtNode
{
private:
    SymbolEntry *se;
    StmtNode *stmt;
    DeclStmt *decl;
public:
    FunctionDef(SymbolEntry *se,  StmtNode *stmt, DeclStmt *decl = nullptr) : se(se), stmt(stmt), decl(decl){};
    SymbolEntry* getSymbolEntry() {return se;};
    void output(int level);
    bool typeCheck(Type* retType = nullptr);
    void genCode();
};

// Ast
class Ast
{
private:
    Node* root;
public:
    Ast() {root = nullptr;}
    void setRoot(Node*n) {root = n;}
    void output();
    bool typeCheck(Type* retType = nullptr);
    void genCode(Unit *unit);
};

#endif
