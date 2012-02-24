# $File: project.make
# $Date: Mon Jun 13 09:44:13 2011 +0800

OBJ_DIR = obj
TARGET = <++>

PKGCONFIG_LIBS = <++>
INCLUDE_DIR = -Isrc/include -Isrc
DEFINES = 
CXXFLAGS = -Wall -Wextra  <++> \
		   $(shell pkg-config --cflags $(PKGCONFIG_LIBS)) $(INCLUDE_DIR) $(DEFINES) -O2
LDFLAGS = <++> \
		  $(shell pkg-config --libs $(PKGCONFIG_LIBS))

CXX = g++
CXXSOURCES = $(shell find src -name "*.cpp")
OBJS = $(addprefix $(OBJ_DIR)/,$(CXXSOURCES:.cpp=.o))
DEPFILES = $(OBJS:.o=.d)


.PHONY: all clean run hg

all: $(TARGET)

$(OBJ_DIR)/%.o: %.cpp
	@echo "[cxx] $< ..."
	@$(CXX) -c $< -o $@ $(CXXFLAGS)

$(OBJ_DIR)/%.d: %.cpp
	@mkdir -pv $(dir $@)
	@echo "[dep] $< ..."
	@$(CXX) $(INCLUDE_DIR) $(DEFINES) -MM -MT "$(OBJ_DIR)/$(<:.cpp=.o) $(OBJ_DIR)/$(<:.cpp=.d)" "$<"  > "$@"

sinclude $(DEPFILES)

$(TARGET): $(OBJS)
	@echo "Linking ..."
	@$(CXX) $(OBJS) -o $@ $(LDFLAGS)


clean:
	rm -rf $(OBJ_DIR) $(TARGET)

run: $(TARGET)
	./$(TARGET) bell.wav 100

hg:
	hg addremove
	hg commit -u jiakai
	hg push

# vim: ft=make
