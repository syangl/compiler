; ;目标信息仿照之前prework.ll的信息写即可
; source_filename = "llvm-characters.c"
; target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
; target triple = "x86_64-pc-linux-gnu"

;int global_var = 100
@global_var = dso_local global i32 100, align 4
;printf
@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

;int function(int a, int b, int c, float f)
define dso_local i32 @function(i32 %0, i32 %1, i32 %2, float %3) #0 {
  %5 = alloca i32, align 4  ;a
  %6 = alloca i32, align 4  ;b
  %7 = alloca i32, align 4  ;c
  %8 = alloca float, align 4  ;f
  %9 = alloca i32, align 4  ;temp
  %10 = alloca i32, align 4 ;turn
  ;a
  store i32 %0, i32* %5, align 4
  ;b
  store i32 %1, i32* %6, align 4
  ;c
  store i32 %2, i32* %7, align 4
  ;f
  store float %3, float* %8, align 4
  ;int temp = a
  %11 = load i32, i32* %5, align 4
  store i32 %11, i32* %9, align 4
  ;a = b
  %12 = load i32, i32* %6, align 4
  store i32 %12, i32* %5, align 4
  ;b = temp
  %13 = load i32, i32* %9, align 4
  store i32 %13, i32* %6, align 4
  ;c = a + b + c
  %14 = load i32, i32* %5, align 4
  %15 = load i32, i32* %6, align 4
  %16 = add nsw i32 %14, %15 
  %17 = load i32, i32* %7, align 4
  %18 = add nsw i32 %16, %17
  store i32 %18, i32* %7, align 4
  ;int turn = f
  %19 = load float, float* %8, align 4
  %20 = fptosi float %19 to i32  ;隐式类型转换
  store i32 %20, i32* %10, align 4
  ; return turn
  %21 = load i32, i32* %10, align 4
  ret i32 %21
}

define dso_local i32 @main() #0 {
  %1 = call i32 @function(i32 1, i32 2, i32 3, float 0x400921CAC0000000)
  ;printf
  %2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 %1)
  ret i32 0
}
;printf
declare dso_local i32 @printf(i8*, ...) #1


;属性信息仿照之前prework.ll的信息写即可
attributes #0 = {nounwind}
;printf
attributes #1 = {nounwind}

; !llvm.module.flags = !{!0}
; !llvm.ident = !{!1}

; !0 = !{i32 1, !"wchar_size", i32 4}
; !1 = !{!"clang version 10.0.0-4ubuntu1 "}
