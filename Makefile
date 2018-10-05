include Makefile.inc

BIN ?= bin

# If HL_TARGET isn't set, use host
HL_TARGET ?= host

all: test

clean:
	@rm -rf $(BIN)

# By default, %.generator is produced by building %_generator.cpp
$(BIN)/%.generator: %_generator.cpp $(GENERATOR_DEPS)
	@echo Building Generator $(filter %_generator.cpp,$^)
	@mkdir -p $(@D)
	@$(CXX) $(CXXFLAGS) -fno-rtti $(filter-out %.h,$^) $(LDFLAGS) $(HALIDE_SYSTEM_LDFLAGS) -o $@

# By default, %.a/.h are produced by executing %.generator
$(BIN)/%.a $(BIN)/%.h: $(BIN)/%.generator
	@echo Running Generator $<
	@mkdir -p $(@D)
	@$< -g $(notdir $*) -o $(BIN) target=$(HL_TARGET)-no_runtime

$(BIN)/runtime_$(HL_TARGET).a: $(BIN)/rdom_input.generator
	@echo Compiling Halide runtime for target $(HL_TARGET)
	@mkdir -p $(@D)
	@$< -r runtime_$(HL_TARGET) -o $(BIN) target=$(HL_TARGET)

HL_MODULES = \
	$(BIN)/rdom_input.a \
	$(BIN)/runtime_$(HL_TARGET).a

$(BIN)/rdom_input_aottest.a: rdom_input_aottest.cpp $(HL_MODULES)
	@$(CXX) $(CXXFLAGS) $(IMAGE_IO_CXX_FLAGS) -I$(BIN) -c $< -o $@

$(BIN)/rdom_input_aottest: $(BIN)/rdom_input_aottest.a
	@$(CXX) $(CXXFLAGS) $^ $(HL_MODULES) $(IMAGE_IO_LIBS) $(LDFLAGS) -o $@

test: $(BIN)/rdom_input_aottest
	@echo Testing rdom_input_aottest...

# Don't auto-delete the generators.
.SECONDARY: