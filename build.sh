#!/bin/bash

set -e

BL=$PWD/treble_risingos
BD=$HOME/builds
BV=$1

initRepos() {
    echo "--> Initializing workspace"
    repo init --no-repo-verify -u https://github.com/RisingTechOSS/android -b thirteen --git-lfs -g default,-mips,-darwin,-notdefault
    echo

    echo "--> Preparing local manifest"
    mkdir -p .repo/local_manifests
    git clone https://github.com/MisterZtr/treble_manifest.git .repo/local_manifests  -b 13
    echo
}

syncRepos() {
    echo "--> Syncing repos"
    repo sync --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j$(nproc --all)
    echo
}

applyPatches() {
    echo "--> Applying TrebleDroid patches"
    bash patches/apply-patches.sh .
    echo
}

addRosMakefile() {
    echo "--> Copying RisingOS.mk to device/phh/treble"
    cp RisingOS.mk device/phh/treble
    echo
}

GenSomething() {
    echo "--> Generating Something important i dont know what it is"
    cd device/phh/treble
    bash generate.sh RisingOS #For vanilla
    #bash generate.sh RisingOS+GApps #For gapps
    echo
}

buildVariant() {
    echo "--> Running envsetup..."
    cd ../
    cd ../
    cd ../
    export USE_CCACHE=1
    export CCACHE_COMPRESS=1
    export CCACHE_MAXSIZE=50G # 50 GB
    . build/envsetup.sh
    ccache -M 50G -F 0
    echo "--> Building The Generic System Image"
    lunch treble_a64_bvN-userdebug #treble_a64_bvN-userdebug is just an example, you can build for any arch u want to
    make systemimage -j$(nproc --all)
    echo
    }
    

