$ORIGINAL=$PSScriptRoot
$FILE_SRC="$ORIGINAL\..\..\openvinocvsharpextern"
$SRC="c:\temp\openvinoscsharpextern"
$INTEL_OPENVINO_DIR="c:\Program Files (x86)\IntelSWTools\openvino_2021"
# Remove-Item -rec $SRC
# mkdir $SRC
Push-Location $SRC

try {

    # Invoke-WebRequest -Uri https://github.com/shimat/opencvsharp/archive/master.zip -OutFile master.zip
    # Expand-Archive -Path master.zip -DestinationPath $SRC
    # Move-Item opencvsharp-master opencvsharp
    # Remove-Item master.zip

    # Set-Location opencvsharp\src\OpenCvSharpExtern
    # Copy-Item $FILE_SRC\include_opencv.h
    # Copy-Item $FILE_SRC\CMakeLists.txt
    # Remove-Item -rec build
    # mkdir build
    # Set-Location build


    # cmake `
    #     -D OpenCV_DIR=${INTEL_OPENVINO_DIR}\opencv\cmake `
    #     -D InferenceEngine_DIR=${INTEL_OPENVINO_DIR}\inference_engine\share `
    #     -D TBB_DIR=${INTEL_OPENVINO_DIR}\inference_engine\external\tbb\cmake `
    #     -D CMAKE_INSTALL_PREFIX=$SRC\install `
    #     $SRC\opencvsharp\src

    # cmake --build . --config Release
    # cmake --install .
    Copy-Item $SRC\install\bin\OpenCvSharpExtern.dll $ORIGINAL
}
finally {
    Pop-Location
}
