#ifndef __AST_H__
#define __AST_H__

#include <fstream>

class SymbolEntry;

// Node
class Node
{
private:
    static int counter;
    int seq;  
    Node *bro;
public:
    Node();
    int getSeq() const {return seq;};
    virtual void output(int level) = 0;
    Node *getRightestBro();
    Node *brother(){return bro;};
};

// ExprNode
class ExprNode : public Node
{
protected:
    SymbolEntry *symbolEntry;
public:
    ExprNode(SymbolEntry *symbolEntry) : symbolEntry(symbolEntry){};
    virtual int intValue(){return 0;};
};

// BinaryNode
class BinaryExpr : public ExprNode
{
private:
    int op;
    ExprNode *expr1, *expr2;
public:
    enum {ADD, SUB, MUL, DIV, MOD, AND, OR, LESS, LEQU, EQUAL, NOTEQUAL, GREAT, GEQU};
    BinaryExpr(SymbolEntry *se, int op, ExprNode*expr1, ExprNode*expr2) : ExprNode(se), op(op), expr1(expr1), expr2(expr2){};
    void output(int level);
    int intValue();
};

// UnaryNode
class UnaryExpr : public ExprNode 
{
private:
    int op;
    ExprNode* expr;
public:
    enum { NOT, SUB };
    UnaryExpr(SymbolEntry* se, int op, ExprNode* expr) : ExprNode(se), op(op), expr(expr){};
    void output(int level);
    int intValue();
};

// FunctionCallExprNode
class FunctionCallExpr : public ExprNode 
{
private:
    ExprNode* param;
public:
    FunctionCallExpr(SymbolEntry* se, ExprNode* param = nullptr) : ExprNode(se), param(param){};
    void output(int level);
};

// ConstantNode
class Constant : public ExprNode
{
public:
    Constant(SymbolEntry *se) : ExprNode(se){};
    void output(int level);
    int intValue();
    // TODO: floatValue()
};

// IdNode
class Id : public ExprNode
{
public:
    Id(SymbolEntry *se) : ExprNode(se){};
    void output(int level);
    int intValue();
};
// IdArrayIndex
class IdArrayIndex : public ExprNode
{
private:
    ExprNode* Idx;
public:
    IdArrayIndex(SymbolEntry *se, ExprNode* Idx) : ExprNode(se), Idx(Idx){};
    void output(int level);
    int intValue();
};

// StmtNode
class StmtNode : public Node
{};
// CompoundStmtNode
class CompoundStmt : public StmtNode
{
private:
    StmtNode *stmt;
public:
    CompoundStmt(StmtNode *stmt) : stmt(stmt) {};
    void output(int level);
};

// SeqNode
class SeqNode : public StmtNode
{
private:
    StmtNode *stmt1, *stmt2;
public:
    SeqNode(StmtNode *stmt1, StmtNode *stmt2) : stmt1(stmt1), stmt2(stmt2){};
    void output(int level);
};

// DeclStmt
class DeclStmt : public StmtNode
{
private:
    Id *id;
    ExprNode* expr = nullptr;
public:
    DeclStmt(Id *id, ExprNode* expr = nullptr) : id(id), expr(expr){};
    void output(int level);
};

// IfStmtNode
class IfStmt : public StmtNode
{
private:
    ExprNode *cond;
    StmtNode *thenStmt;
public:
    IfStmt(ExprNode *cond, StmtNode *thenStmt) : cond(cond), thenStmt(thenStmt){};
    void output(int level);
};

// IfElseStmtNode
class IfElseStmt : public StmtNode
{
private:
    ExprNode *cond;
    StmtNode *thenStmt;
    StmtNode *elseStmt;
public:
    IfElseStmt(ExprNode *cond, StmtNode *thenStmt, StmtNode *elseStmt) : cond(cond), thenStmt(thenStmt), elseStmt(elseStmt) {};
    void output(int level);
};

//WhileStmtNode
class WhileStmt : public StmtNode
{
private:
    ExprNode *cond;
    StmtNode *stmt;
public:
    WhileStmt(ExprNode* cond, StmtNode* stmt) : cond(cond), stmt(stmt){};
    void output(int level);
};

// BreakStmtNode
class BreakStmt : public StmtNode
{
public:
    BreakStmt(){};
    void output(int level);
};

// ContinueStmtNode
class ContinueStmt : public StmtNode
{
public:
    ContinueStmt(){};
    void output(int level);
};

//ReturnStmtNode
class ReturnStmt : public StmtNode
{
private:
    ExprNode *retValue;
public:
    ReturnStmt(ExprNode*retValue) : retValue(retValue) {};
    void output(int level);
};

// AssignStmtNode
class AssignStmt : public StmtNode
{
private:
    ExprNode *lval;
    ExprNode *expr;
public:
    AssignStmt(ExprNode *lval, ExprNode *expr) : lval(lval), expr(expr) {};
    void output(int level);
};

// ExprStmt
class ExprStmt : public StmtNode
{
private:
    ExprNode *expr;
public:
    ExprStmt(ExprNode *expr) : expr(expr) {};
    void output(int level);
};

// FunctionDefNode
class FunctionDef : public StmtNode
{
private:
    SymbolEntry *se;
    StmtNode *stmt;
public:
    FunctionDef(SymbolEntry *se, StmtNode *stmt) : se(se), stmt(stmt){};
    void output(int level);
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
};

#endif
