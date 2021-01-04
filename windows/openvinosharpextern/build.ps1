Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$PSDefaultParameterValues['*:ErrorAction']='Stop'
function ThrowOnNativeFailure {
    if (-not $?)
    {
        throw 'Native Failure'
    }
}
$ORIGINAL=$PSScriptRoot
$FILE_SRC="$ORIGINAL\..\..\openvinosharpextern"
$SRC="c:\temp\openvinosharpextern"
$INTEL_OPENVINO_DIR="c:\Program Files (x86)\IntelSWTools\openvino_2021"
Remove-Item -rec $SRC -ErrorAction Ignore
mkdir $SRC
Push-Location $SRC

try {

    Invoke-WebRequest -Uri https://github.com/shimat/opencvsharp/archive/4.5.1.20201229.zip -OutFile master.zip
    Expand-Archive -Path master.zip -DestinationPath $SRC
    Move-Item opencvsharp-* opencvsharp
    Remove-Item master.zip

    Set-Location opencvsharp\src\OpenCvSharpExtern
    Copy-Item $FILE_SRC\include_opencv.h
    Copy-Item $FILE_SRC\CMakeLists.txt
    Remove-Item -rec build -ErrorAction Ignore
    mkdir build
    Set-Location build


    cmake `
        -D OpenCV_DIR=${INTEL_OPENVINO_DIR}\opencv\cmake `
        -D InferenceEngine_DIR=${INTEL_OPENVINO_DIR}\inference_engine\share `
        -D TBB_DIR=${INTEL_OPENVINO_DIR}\inference_engine\external\tbb\cmake `
        -D CMAKE_INSTALL_PREFIX=$SRC\install `
        $SRC\opencvsharp\src
    ThrowOnNativeFailure

    cmake --build . --config Release
    ThrowOnNativeFailure
    cmake --install .
    ThrowOnNativeFailure
    Copy-Item $SRC\install\bin\OpenCvSharpExtern.dll $ORIGINAL
}
finally {
    Pop-Location
}
