#include "Ast.h"
#include "SymbolTable.h"
#include <string>
#include "Type.h"

extern FILE *yyout;
int Node::counter = 0;

Node::Node()
{
    seq = counter++;
    bro = nullptr;
}

Node* Node::getRightestBro(){
    Node* node = this;
    while(node->brother()){
        node = node->brother();
    }
    return node;
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
            op_str = "negative";
            break;
    }
    fprintf(yyout, "%*cUnaryExpr\top: %s\n", level, ' ', op_str.c_str());
    expr->output(level + 4);
}

// TODO: FunctionCall
void FunctionCallExpr::output(int level) {
    std::string name, type;
    int scope;
    name = symbolEntry->toStr();
    type = symbolEntry->getType()->toStr();
    scope = dynamic_cast<IdentifierSymbolEntry*>(symbolEntry)->getScope();
    fprintf(yyout, "%*cCallee\tfunction name: %s\ttype: %s\tscope:  %d\n",
            level, ' ', name.c_str(), type.c_str(), scope);
    Node* tmp = param;
    while (tmp) {
        tmp->output(level + 4);
        tmp = tmp->brother();
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

// void IdArrayIndex::output(int level)
// {
//     std::string name, type;
//     int scope;
//     name = symbolEntry->toStr();
//     type = symbolEntry->getType()->toStr();
//     scope = dynamic_cast<IdentifierSymbolEntry*>(symbolEntry)->getScope();
//     fprintf(yyout, "%*cId\tname: %s\tscope: %d\ttype: %s\n", level, ' ',
//             name.c_str(), scope, type.c_str());
//     // TODO:
// }

void CompoundStmt::output(int level)
{
    fprintf(yyout, "%*cCompoundStmt\n", level, ' ');
    stmt->output(level + 4);
}

void SeqNode::output(int level)
{
    fprintf(yyout, "%*cSequence\n", level, ' ');
    stmt1->output(level + 4);
    stmt2->output(level + 4);
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
    retValue->output(level + 4);
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
