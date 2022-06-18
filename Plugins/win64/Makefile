CXX = x86_64-w64-mingw32-gcc
CXXFLAGS ?= -g
#CXXFLAGS += -DWindowsDLL
CXXFLAGS += -fPIC -static-libgcc
#CXXFLAGS += -I$(HOME)/working/m5stack/ArduinoJson/ -w
SRC = ../src

all: microwitch.dll

clean:
	rm -f microwitch.dll *.o *.dll core Dlltest.def libtest.a

%.o: $(SRC)/%.cpp
	$(CXX) $(CXXFLAGS) -c $<

winSerialPort2Ops.o: $(SRC)/winSerialPort2Ops.cpp
winMicrowitch.o: $(SRC)/winMicrowitch.cpp

microwitch.dll: winSerialPort2Ops.o winMicrowitch.o
	$(CXX) -shared $(CXXFLAGS) -o $@ winSerialPort2Ops.o winMicrowitch.o -static -lstdc++ -lgcc -lwinpthread -lsetupapi -Wl,-k,--output-def,Dlltest.def,--out-implib,libtest.a
