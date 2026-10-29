cmake_minimum_required(VERSION 3.20)

###### Cross compiling stuff ######
set(CMAKE_ASM_NASM_OBJECT_FORMAT "elf32")
set(CMAKE_OSX_ARCHITECTURES "" CACHE INTERNAL "" FORCE) # Sets the os to the default
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)       # Tells cmake do not try and compile

set(CMAKE_SYSTEM_NAME Generic)                          # Tells cmake this is a Generic system
set(CMAKE_SYSTEM_PROCESSOR i386)                        # Tells cmake this is an i386(x86) cpu

project(MyrOS C ASM_NASM)


# 1. Flag setup
set(CMAKE_ASM_NASM_FLAGS "${CMAKE_ASM_NASM_FLAGS} -f elf32")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m32 -ffreestanding -std=c99")

# 2. Kernel executable target

add_executable(kernel.elf
    loader.asm
    kmain.c
)


# 3. Linker options
target_link_options(kernel.elf PRIVATE
    -T ${CMAKE_CURRENT_SOURCE_DIR}/link.ld
    "LINKER:-melf_i386"
    -nostdlib
)

# 4. Custom 'run' target to launch QEMU
add_custom_target(run
    ALL
    COMMAND qemu-system-i386 -kernel ${CMAKE_CURRENT_BINARY_DIR}/kernel.elf -monitor stdio 
    DEPENDS kernel.elf
    USES_TERMINAL
    COMMENT "Launching kernel.elf in QEMU..."
)