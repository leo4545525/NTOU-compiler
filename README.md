STEP1:  flex math.l  
STEP2:  bison -d math.y  
STEP3:  gcc math.tab.c lex.yy.c -lfl   
STEP4:  .\a.exe  

input.txt為測資
output.txt為編譯結果
