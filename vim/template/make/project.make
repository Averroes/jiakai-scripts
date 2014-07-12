# $File: project.make
# $Date: Thu Jul 03 11:43:50 2014 -0700
# $Author: jiakai <jia.kai66@gmail.com>

BUILD_DIR = build
TARGET = <++>
ARGS = <++>

CXX = g++

PKGCONFIG_LIBS = <++>
SRC_EXT = cc
CPPFLAGS = -Isrc
override OPTFLAG ?= -O2

override CXXFLAGS += \
	-ggdb \
	-Wall -Wextra -Wnon-virtual-dtor -Wno-unused-parameter -Winvalid-pch \
	-Wno-unused-local-typedefs \
	$(CPPFLAGS) $(OPTFLAG) \
	$(shell pkg-config --cflags $(PKGCONFIG_LIBS)) 
override LDFLAGS += $(shell pkg-config --libs $(PKGCONFIG_LIBS))
override V ?= @

CXXSOURCES = $(shell find src -name "*.$(SRC_EXT)")
OBJS = $(addprefix $(BUILD_DIR)/,$(CXXSOURCES:.$(SRC_EXT)=.o))
DEPFILES = $(OBJS:.o=.d)


all: $(TARGET)

-include $(DEPFILES)

$(BUILD_DIR)/%.o: %.$(SRC_EXT)
	@echo "[cxx] $< ..."
	@mkdir -pv $(dir $@)
	@$(CXX) $(CPPFLAGS) -MM -MT "$@" "$<"  > "$(@:.o=.d)"
	$(V)$(CXX) -c $< -o $@ $(CXXFLAGS)


$(TARGET): $(OBJS)
	@echo "Linking ..."
	$(V)$(CXX) $(OBJS) -o $@ $(LDFLAGS)

clean:
	rm -rf $(BUILD_DIR) $(TARGET)

run: $(TARGET)
	./$(TARGET) $(ARGS)

gdb: 
	OPTFLAG=-O0 make -j4
	gdb --args $(TARGET) $(ARGS)

git:
	git add -A
	git commit -a

gprof:
	OPTFLAG='-O3 -pg' LDFLAGS=-pg make -j4

.PHONY: all clean run gdb git gprof

# vim: ft=make
