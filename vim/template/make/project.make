# $File: project.make
# $Date: Thu Jun 07 23:44:08 2012 +0800

BUILD_DIR = build
TARGET = <++>

PKGCONFIG_LIBS = <++>
FILE_EXT = cc
DEFINES = 
INCLUDE_DIR = -Isrc/include -Isrc
override OPTFLAG ?= -O2

CXXFLAGS = -Wall -Wextra -Wnon-virtual-dtor -Wno-unused-parameter -Winvalid-pch \
		   $(INCLUDE_DIR) $(DEFINES) $(OPTFLAG) \
		   $(shell pkg-config --cflags $(PKGCONFIG_LIBS)) 
LDFLAGS = $(shell pkg-config --libs $(PKGCONFIG_LIBS))

CXX = g++
CXXSOURCES = $(shell find src -name "*.$(FILE_EXT)")
OBJS = $(addprefix $(BUILD_DIR)/,$(CXXSOURCES:.$(FILE_EXT)=.o))
DEPFILES = $(OBJS:.o=.d)


all: $(TARGET)

$(BUILD_DIR)/%.o: %.$(FILE_EXT)
	@echo "[cxx] $< ..."
	@$(CXX) -c $< -o $@ $(CXXFLAGS)

$(BUILD_DIR)/%.d: %.$(FILE_EXT)
	@mkdir -pv $(dir $@)
	@echo "[dep] $< ..."
	@$(CXX) $(INCLUDE_DIR) $(DEFINES) -MM -MT "$@ $(@:.d=.o)" "$<"  > "$@"

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
