libntfslinks
===========

A C++ library for working with NTFS junctions and symbolic links.

#How to Build

The solution files for this project were created for Visual Studio 2012. Any
version after 2012 should work but has not been tested.

1. Open libntfslinks.sln in Visual Studio.

2. Select the desired platform and configuration (e.g. Release|x64)

3. Build the solution (Build->Build Solution)

Once successfully built a .lib file will be generated in the lib folder in the
root of the solution. Copy or link this file to your project and copy or link
to the header files in the libntfslinks\include folder.

#How to Use

There are two header files of importance when using this library, Junction.h
and Symlink.h.

Use the Junction.h header when you want to work with NTFS junctions and use
Symlink.h when you want to work with NTFS symbolic links. Per Microsoft's
documentation symbolic links are generally preferred over junctions however
when using them your application must be run with elevated privileges.

The following is an example of working with junctions. The example
creates a new junction, checks that it is in fact a junction, retrieves
the target and finally deletes it.
```cpp
#include <Junction.h>
#include <Windows.h>

using namespace libntfslinks;

// Create the junction
CreateJunction(TEXT("JunctionName"), TEXT("TargetDir"));

// Check that it is exists
if (IsJunction(TEXT("JunctionName"))
{
	printf("The junction exists!");
}

// Get the target
TCHAR Target[MAX_PATH];
GetJunctionTarget(TEXT("JunctionName"), Target, MAX_PATH);

// Delete the junction
DeleteJunction(TEXT("JunctionName"));
```
Working with symbolic links is just as easy.
```cpp
#include <Symlink.h>
#include <Windows.h>

using namespace libntfslinks;

// Create the symlink to a file
CreateSymlink(TEXT("FileLinkName"), TEXT("TargetFile"));

// Create a symlink to a directory
CreateSymlink(TEXT("DirLinkName"), TEXT("TargetDir"));

// Get the target of the file
TCHAR FileTarget[MAX_PATH];
GetSymlinkTarget(TEXT("FileLinkName"), FileTarget, MAX_PATH);

// Get the target of the dir
TCHAR DirTarget[MAX_PATH];
GetSymlinkTarget(TEXT("DirLinkName"), DirTarget, MAX_PATH);

// Delete both symlinks
DeleteSymlink(TEXT("FileLinkName"));
DeleteSymlink(TEXT("DirLinkName"));
```

#GoLang

#Build c++

```Makefile
buildLib : junction junction32 char char32

junction : ../libntfslinks/libntfslinks/source/junction.cpp	
	cd ../libntfslinks/libntfslinks/ && x86_64-w64-mingw32-gcc -D"LIBNTFS_EXPORTS" -D"UNICODE" -I"include" -c "source/junction.cpp" -o "../junction.o"	

junction32 : ../libntfslinks/libntfslinks/source/junction.cpp	
	cd ../libntfslinks/libntfslinks/ && x86_64-w64-mingw32-gcc -m32 -D"LIBNTFS_EXPORTS" -D"_UNICODE" -D"UNICODE" -I"include" -c "source/junction.cpp" -o "../junction-win32.o"	
	
char : ../libntfslinks/libntfslinks/source/charutils.cpp	
	cd ../libntfslinks/libntfslinks/ && x86_64-w64-mingw32-gcc -D"LIBNTFS_EXPORTS" -D"UNICODE" -I"include" -c "source/charutils.cpp" -o "../char-utils.o"	

char32 : ../libntfslinks/libntfslinks/source/charutils.cpp	
	cd ../libntfslinks/libntfslinks/ && x86_64-w64-mingw32-gcc -m32 -D"LIBNTFS_EXPORTS" -D"UNICODE" -I"include" -c "source/charutils.cpp" -o "../char-utils-win32.o"
```

#Use

```Go
//#cgo amd64 LDFLAGS: ${SRCDIR}/libntfslinks/junction.o
//#cgo amd64 LDFLAGS: ${SRCDIR}/libntfslinks/char-utils.o
//#cgo 386 LDFLAGS: ${SRCDIR}/libntfslinks/junction-win32.o
//#cgo 386 LDFLAGS: ${SRCDIR}/libntfslinks/char-utils-win32.o
//#cgo LDFLAGS: -lmingwex -lmingw32 -lgcc_s -luuid -lstdc++ -luser32 -lkernel32 -lusp10 -lgdi32 -lcomctl32 -luxtheme -lmsimg32 -lcomdlg32 -ld2d1 -ldwrite -lole32 -loleaut32 -loleacc -static -static-libgcc -static-libstdc++
//#cgo CPPFLAGS: -Ilibntfslinks
//#include "libntfsforgo.h"
import (
	"C"
)

// CreateJunction : create a junction of target
func CreateJunction(linkPath string, targetPath string) _Ctype_uint {

	junctionLink := C.CString(linkPath)
	junctionLinkPath := C.ConvertCharArrayToLPCWSTR(junctionLink)

	junctionTarget := C.CString(targetPath)
	junctionTargetPath := C.ConvertCharArrayToLPCWSTR(junctionTarget)

	createdJunction := C.CreateJunction(junctionLinkPath, junctionTargetPath)
	//fmt.Printf("Created Junction %s \n", createdJunction)

	return createdJunction
}

// RemoveJunction : remove a junction
func RemoveJunction(linkPath string) _Ctype_uint {

	junctionLink := C.CString(linkPath)
	junctionLinkPath := C.ConvertCharArrayToLPCWSTR(junctionLink)

	removedJunction := C.DeleteJunction(junctionLinkPath)
	//fmt.Printf("Removed Junction %s \n", removedJunction)

	return removedJunction
}

// IsJunction : check if path is a junction
func IsJunction(linkPath string) _Ctype__Bool {

	junctionLink := C.CString(linkPath)
	junctionLinkPath := C.ConvertCharArrayToLPCWSTR(junctionLink)

	isJunction := C.IsJunction(junctionLinkPath)
	//fmt.Printf("Is Junction %t \n", isJunction)

	return isJunction
}

```

#Build Go

```Makefile
buildGo : windows32 windows64

windows32 :
	GOOS=windows GOARCH=386 CGO_ENABLED=1 CC='i686-w64-mingw32-gcc' go build -o junction-w32.exe	

windows64 :
	go build -o junction-w64.exe
```

