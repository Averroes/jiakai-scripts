# $File: project.make
# $Date: Mon Jun 03 11:27:18 2013 +0800
# $Author: jiakai <jia.kai66@gmail.com>

BUILD_DIR = build
TARGET = <++>

CXX = g++

PKGCONFIG_LIBS = <++>
SRC_EXT = cc
CPPFLAGS = -Isrc
override OPTFLAG ?= -O2

override CXXFLAGS += \
	-Wall -Wextra -Wnon-virtual-dtor -Wno-unused-parameter -Winvalid-pch \
	-Wno-unused-local-typedefs \
	$(CPPFLAGS) $(OPTFLAG) \
	$(shell pkg-config --cflags $(PKGCONFIG_LIBS)) 
LDFLAGS = $(shell pkg-config --libs $(PKGCONFIG_LIBS))

CXXSOURCES = $(shell find src -name "*.$(SRC_EXT)")
OBJS = $(addprefix $(BUILD_DIR)/,$(CXXSOURCES:.$(SRC_EXT)=.o))
DEPFILES = $(OBJS:.o=.d)


all: $(TARGET)

$(BUILD_DIR)/%.o: %.$(SRC_EXT)
	@echo "[cxx] $< ..."
	@$(CXX) -c $< -o $@ $(CXXFLAGS)

$(BUILD_DIR)/%.d: %.$(SRC_EXT)
	@mkdir -pv $(dir $@)
	@echo "[dep] $< ..."
	@$(CXX) $(CPPFLAGS) -MM -MT "$@ $(@:.d=.o)" "$<"  > "$@"

sinclude $(DEPFILES)

$(TARGET): $(OBJS)
	@echo "Linking ..."
	@$(CXX) $(OBJS) -o $@ $(LDFLAGS)

clean:
	rm -rf $(BUILD_DIR) $(TARGET)

run: $(TARGET)
	./$(TARGET)

gdb: $(TARGET)
	gdb $(TARGET)

git:
	git add -A
	git commit -a

.PHONY: all clean run gdb git

# vim: ft=make
