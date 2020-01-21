#!/bin/sh

PATH=~/bin:$PATH
set -e

export SCL=`which scl`
if [ ! -z $SCL ]; then
    export HAS_DTS=`scl -l | grep devtoolset-2`
fi

if [ -n "$1" ]; then
    build32L=0
    build64L=0
    build32W=0
    build64W=0
    do_clear=0
    do_pack=0
    if [ "$1" = "32L" ]; then
        build32L=1
    fi
    if [ "$1" = "64L" ]; then
        build64L=1
    fi
    if [ "$1" = "32W" ]; then
        build32W=1
    fi
    if [ "$1" = "64W" ]; then
        build64W=1
    fi
    if [ "$1" = "clear" ]; then
        do_clear=1
    fi
    if [ "$1" = "pack" ]; then
        do_pack=1
    fi
else
    build32L=1
    build64L=1
    build32W=1
    build64W=1
    do_clear=1
    do_pack=1
fi

if [ $do_clear -eq 1 ]; then
    cmake -E remove_directory build32L
    cmake -E remove_directory build64L
    cmake -E remove_directory build32W
    cmake -E remove_directory build64W
fi

if [ $build32L -eq 1 ]; then
    cmake -E echo "Build Linux 32" 
    if [ ! -d build32L ]; then
        cmake -E make_directory build32L
        cd build32L
        if [ "${SCL}" != "" -a "${HAS_DTS}" != "" ]; then
            scl enable devtoolset-2 'cmake -D CMAKE_BUILD_TYPE:STRING=RelWithDebInfo -D TARGET_PLATFORM_32:BOOL=ON --build .. '
        else
            cmake -D CMAKE_BUILD_TYPE:STRING=RelWithDebInfo -D TARGET_PLATFORM_32:BOOL=ON --build ..
        fi
        cd .. 
    fi 
    cd build32L
    cmake --build .
    cd ..
fi    

if [ $build64L -eq 1 ]; then
    cmake -E echo "Build Linux 64"
    if [ ! -d build64L ]; then
        cmake -E make_directory build64L
        cd build64L
        if [ "${SCL}" != "" -a "${HAS_DTS}" != "" ]; then
            scl enable devtoolset-2 'cmake -D CMAKE_BUILD_TYPE:STRING=RelWithDebInfo -D TARGET_PLATFORM_32:BOOL=OFF --build .. '
        else
            cmake -D CMAKE_BUILD_TYPE:STRING=RelWithDebInfo -D TARGET_PLATFORM_32:BOOL=OFF --build ..
        fi
        cd ..
    fi ;
    cd build64L
    cmake --build .
    cd ..
fi    

if [ $build32W -eq 1 ]; then
    cmake -E echo "Build Windows 32" 
    if [ ! -d build32W ]; then
        cmake -E make_directory build32W
        cd build32W
        if [ "${SCL}" != "" -a "${HAS_DTS}" != "" ]; then
            scl enable devtoolset-2 'cmake \
                -D CMAKE_TOOLCHAIN_FILE=../cmake/toolchain-i686-w64-mingw32.cmake \
                -D CMAKE_BUILD_TYPE:STRING=RelWithDebInfo \
                -D TARGET_PLATFORM_32:BOOL=ON \
                -D WINDOWS:BOOL=ON \
                --build .. '
        else
            cmake \
                -D CMAKE_TOOLCHAIN_FILE=../cmake/toolchain-i686-w64-mingw32.cmake \
                -D CMAKE_BUILD_TYPE:STRING=RelWithDebInfo \
                -D TARGET_PLATFORM_32:BOOL=ON \
                -D WINDOWS:BOOL=ON \
                --build ..
        fi
        cd .. 
    fi 
    cd build32W
    cmake --build .
    cd ..
fi    

if [ $build64W -eq 1 ]; then
    cmake -E echo "Build Windows 64"
    if [ ! -d build64W ]; then
        cmake -E make_directory build64W
        cd build64W
        if [ "${SCL}" != "" -a "${HAS_DTS}" != "" ]; then
            scl enable devtoolset-2 'cmake \
                -D CMAKE_TOOLCHAIN_FILE=../cmake/toolchain-x86_64-w64-mingw32.cmake \
                -D CMAKE_BUILD_TYPE:STRING=RelWithDebInfo \
                -D TARGET_PLATFORM_32:BOOL=OFF \
                -D WINDOWS:BOOL=ON \
                --build .. '
        else
            cmake \
                -D CMAKE_TOOLCHAIN_FILE=../cmake/toolchain-x86_64-w64-mingw32.cmake \
                -D CMAKE_BUILD_TYPE:STRING=RelWithDebInfo \
                -D TARGET_PLATFORM_32:BOOL=OFF \
                -D WINDOWS:BOOL=ON \
                --build ..
        fi
        cd ..
    fi ;
    cd build64W
    cmake --build .
    cd ..
fi    

if [ -z $1 ]; then
    cmake -E remove_directory build32L
    cmake -E remove_directory build64L
    cmake -E remove_directory build32W
    cmake -E remove_directory build64W
    strip -s bin/lib1cWinCtrl*.*
    rm -f *.{debug,a}
fi

if [ $do_pack -eq 1 ]; then
    oscript ./MakePack.os
    cp ./AddIn.zip ./Example/Templates/SetWindow/Ext/Template.bin
    oscript ./tools/Compile.os ./
fi
