# Compiler
FC = gfortran

# Compiler flags
FCFLAGS = -std=f2003 -Wall -Wextra -Wconversion -pedantic -fcheck=all -O2 -flto

# Source files
SRCS = example.f90 sandwich_solution.f90

# Object files
OBJS = example.o sandwich_solution.o

# Executable name
EXEC = example

# Default target
all: $(EXEC)

# Link the executable
$(EXEC): $(OBJS)
	$(FC) $(FCFLAGS) -o $(EXEC) $(OBJS)

# Compile the example program, with dependencies on the modules
example.o: example.f90 sandwich_solution.mod
	$(FC) $(FCFLAGS) -c example.f90

# Compile the sandwich_solution module
sandwich_solution.o: sandwich_solution.f90
	$(FC) $(FCFLAGS) -c sandwich_solution.f90

# Ensure the module files are created
sandwich_solution.mod: sandwich_solution.o

# Clean target to remove compiled files
clean:
	rm -f $(OBJS) $(EXEC) *.mod

# Phony targets
.PHONY: all clean
