# -----------------------------------------------------------------------------
# File Name
MAKEFILENAME = Makefile

# Configuration
!IF "$(CONFIG)" == "release"
BUILD_DIR = build\release
CFLAGS_EXTRA =
LINKFLAGS_EXTRA = /debug:none
!ELSE
BUILD_DIR = build\debug
CFLAGS_EXTRA = /Zi /D_DEBUG
LINKFLAGS_EXTRA = /DEBUG
!ENDIF

OBJ_DIR = $(BUILD_DIR)\obj
BIN_DIR = $(BUILD_DIR)\bin

# Machine Type
PRO_MACHINE_TYPE = x86e_win64

# Source directories
SRC_DIR = src
INC_DIR = includes

# Outputs
EXE = $(BIN_DIR)/ptk_startup.exe
EXE_DLL = $(BIN_DIR)/ptk_startup.dll

# Object files
OBJS = \
    $(OBJ_DIR)/toolkit.obj

# Pro/Toolkit Source & Machine Loadpoint
PROTOOL_SYS = $(PROTOOL_SRC)/$(PRO_MACHINE_TYPE)
ICU_PATH = $(PROTOOL_SYS)/obj

# Includes
INCS = -I$(INC_DIR) -I$(PROTOOL_SRC)/protk_appls/includes -I$(PROTOOL_SRC)/includes

# Compiler
CC = cl
MACH = -DPRO_MACHINE=36 -DPRO_OS=4
CCFLAGS = -c -GS -fp:precise -D_WSTDIO_DEFINED
CFLAGS = $(CCFLAGS) $(INCS) $(MACH) $(CFLAGS_EXTRA)

# Libraries
SMALIBS = ../smalib/build/bin/smalib.lib

PTCLIBS = $(PROTOOL_SYS)/obj/protoolkit_NU.lib \
          $(ICU_PATH)/ucore.lib \
          $(ICU_PATH)/udata.lib

PTCLIBS_DLL = $(PROTOOL_SYS)/obj/protk_dll_NU.lib \
              $(ICU_PATH)/ucore.lib \
              $(ICU_PATH)/udata.lib

LIBS = libcmt.lib kernel32.lib user32.lib wsock32.lib advapi32.lib mpr.lib winspool.lib netapi32.lib psapi.lib gdi32.lib shell32.lib comdlg32.lib ole32.lib ws2_32.lib

LINK = link

LINKFLAGS = /subsystem:console /machine:amd64 $(LINKFLAGS_EXTRA)

init:
    if not exist $(OBJ_DIR) mkdir $(OBJ_DIR)
    if not exist $(BIN_DIR) mkdir $(BIN_DIR)

dll: init $(EXE_DLL)

$(EXE_DLL): $(OBJS) $(PTCLIBS_DLL) $(SMALIBS)
    $(LINK) $(LINKFLAGS) -out:$(EXE_DLL) /dll @<<longline.list
$(OBJS) $(PTCLIBS_DLL) $(LIBS) $(SMALIBS)
<<

{$(SRC_DIR)}.c{$(OBJ_DIR)}.obj:
    $(CC) $(CFLAGS) /c $< /Fo$@

clean:
    if exist "build" rmdir /S /Q "build"
    if exist "build_debug" rmdir /S /Q "build_debug"
