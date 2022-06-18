CXX ?= c++
CXXFLAGS ?= -g
CXXFLAGS += -fPIC
CXXFLAGS += -DNDEBUG
SRC = ../src

all: microwitch.so

clean:
	rm -f microwitch *.o *.so core

%.o: $(SRC)/%.cpp
	$(CXX) $(CXXFLAGS) -c $<

unixSerialPort20ps.o: $(SRC)/unixSerialPort20ps.cpp
unixMicrowitch.o: $(SRC)/unixMicrowitch.cpp

microwitch: unixSerialPort20ps.o unixMicrowitch.o
	$(CXX) $(CXXFLAGS) -o $@ unixSerialPort20ps.o unixMicrowitch.o

microwitch.so: unixSerialPort20ps.o unixMicrowitch.o
	$(CXX) -shared $(CXXFLAGS) -o $@ unixSerialPort20ps.o unixMicrowitch.o

