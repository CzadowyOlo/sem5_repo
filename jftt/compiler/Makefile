FLAGS = -std=c++17 -lfl
.PHONY = all clean cleanall

all: comp

comp: comp.y comp.l
	bison -d -o build/comp.tab.cpp comp.y
	g++ -c build/comp.tab.cpp -o build/comp.tab.o
	flex -o build/compl.cpp comp.l
	g++ $(FLAGS) -c build/compl.cpp -o build/compl.o
	g++ -c -std=c++17 arithmetics.cpp -o build/utils.o
	g++ -o comp build/compl.o build/comp.tab.o build/utils.o
	rm -f build/*.cpp build/*.hpp build/*.o
	
clean:
	rm -f build/*.cpp build/*.hpp build/*.o

cleanall: clean
	rm -f comp