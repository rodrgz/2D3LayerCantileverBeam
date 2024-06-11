# Compiler
FC = gfortran

# Compiler flags
FCFLAGS = -ffree-line-length-none -Wall -Wextra -Wconversion -pedantic -fcheck=bounds -fcheck=all -O2

# Source files
SRCS = example.f90 sandwich_solution.f90 kind_parameter.f90

# Object files
OBJS = example.o sandwich_solution.o kind_parameter.o

# Executable name
EXEC = example

# Default target
all: $(EXEC)

# Link the executable
$(EXEC): $(OBJS)
	$(FC) $(FCFLAGS) -o $(EXEC) $(OBJS)

# Compile the example program, with dependencies on the modules
example.o: example.f90 sandwich_solution.mod kind_parameter.mod
	$(FC) $(FCFLAGS) -c example.f90

# Compile the sandwich_solution module, with dependency on the kind_parameter module
sandwich_solution.o: sandwich_solution.f90 kind_parameter.mod
	$(FC) $(FCFLAGS) -c sandwich_solution.f90

# Compile the kind_parameter module
kind_parameter.o: kind_parameter.f90
	$(FC) $(FCFLAGS) -c kind_parameter.f90

# Ensure the module files are created
sandwich_solution.mod: sandwich_solution.o
kind_parameter.mod: kind_parameter.o

# Clean target to remove compiled files
clean:
	rm -f $(OBJS) $(EXEC) *.mod

# Phony targets
.PHONY: all clean
