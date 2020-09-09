#!/bin/bash
cd $HOME/.buildozer/android/platform/
for ndk in $( ls *.zip )
do
  unzip -qq -o $ndk
done
cd /minimalapp
