bison -d -y parser.y
echo '1'
g++ -w -c -o y.o y.tab.c #-g
echo '2'
flex scanner.l
echo '3' 
g++ -fpermissive -w -c -o l.o lex.yy.c #-g
echo '4'
g++  -o a.out y.o l.o -lfl -ly #-g
echo '5'
#gdb ./a.out
./a.out input.txt
