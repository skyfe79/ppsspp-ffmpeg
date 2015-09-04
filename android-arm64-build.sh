#!/bin/bash
#Change NDK to your Android NDK location
NDK=/home/burt/Android/android-ndk-r10d
PLATFORM=$NDK/platforms/android-21/arch-arm64/
PREBUILT=$NDK/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64

GENERAL="\
   --enable-cross-compile \
   --extra-libs="-lgcc" \
   --cc=$PREBUILT/bin/aarch64-linux-android-gcc \
   --cross-prefix=$PREBUILT/bin/aarch64-linux-android- \
   --nm=$PREBUILT/bin/aarch64-linux-android-nm"

MODULES="\
   --disable-avdevice \
   --enable-filters \
   --disable-programs \
   --disable-network \
   --enable-avfilter \
   --disable-postproc \
   --disable-encoders \
   --disable-protocols \
   --disable-hwaccels \
   --disable-doc"

VIDEO_DECODERS="\
   --enable-decoder=libstagefright_h264 \
   --enable-decoder=h264 \
   --enable-decoder=mpeg4 \
   --enable-decoder=mpeg2video \
   --enable-decoder=mjpeg \
   --enable-decoder=mjpegb"

AUDIO_DECODERS="\
    --enable-decoder=aac \
    --enable-decoder=aac_latm \
    --enable-decoder=atrac3 \
    --enable-decoder=atrac3p \
    --enable-decoder=mp3 \
    --enable-decoder=pcm_s16le \
    --enable-decoder=pcm_s8"
  
DEMUXERS="\
    --enable-demuxer=h264 \
    --enable-demuxer=m4v \
    --enable-demuxer=mpegvideo \
    --enable-demuxer=mpegps \
    --enable-demuxer=mp3 \
    --enable-demuxer=avi \
    --enable-demuxer=aac \
    --enable-demuxer=pmp \
    --enable-demuxer=oma \
    --enable-demuxer=pcm_s16le \
    --enable-demuxer=pcm_s8 \
    --enable-demuxer=wav"

VIDEO_ENCODERS="\
	  --enable-encoder=huffyuv
	  --enable-encoder=ffv1"

AUDIO_ENCODERS="\
	  --enable-encoder=pcm_s16le"

MUXERS="\
  	--enable-muxer=mp4"

PARSERS="\
    --enable-parser=h264 \
    --enable-parser=mpeg4video \
    --enable-parser=mpegaudio \
    --enable-parser=mpegvideo \
    --enable-parser=aac \
    --enable-parser=aac_latm"

PROTOCOLS="\
    --enable-protocol=concat \
    --enable-protocol=file"
    
ETC="\
  	--enable-memalign-hack"
function build_arm64
{
./configure --logfile=conflog.txt --target-os=linux \
    --prefix=./android/arm64 \
    --arch=aarch64 \
    ${GENERAL} \
    --sysroot=$PLATFORM \
    --extra-cflags=" -O3 -DANDROID -Dipv6mr_interface=ipv6mr_ifindex -fasm -Wno-psabi -fno-short-enums -fno-strict-aliasing" \
    --enable-shared \
    --disable-static \
    --extra-ldflags="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -llog" \
    --enable-zlib \
    --disable-everything \
    ${MODULES} \
    ${VIDEO_DECODERS} \
    ${AUDIO_DECODERS} \
    ${VIDEO_ENCODERS} \
    ${AUDIO_ENCODERS} \
    ${DEMUXERS} \
		${MUXERS} \
    ${PARSERS} \
    ${PROTOCOLS} \
    ${ETC}

make clean
make install
}

build_arm64
