# microwitch2
microwitch2 is a [micro:witch](https://github.com/EiichiroIto/microwitch) implemented in Pharo Smalltalk 10.

![screenshot1](https://github.com/EiichiroIto/microwitch2/raw/main/misc/PharoScreenshot.png)

micro:witch2 is built on Pharo Smalltalk 10.0.

## Install on Windows
1. Go to [release page](https://github.com/EiichiroIto/microwitch2/releases), and download a latest release file.
2. Extract the zipped release file.
3. Double-click microwitch.exe to start the application.

## Updating MicroPython firmware
1. Start micro:witch2 application. (see above)
2. Connect a micro:bit to your PC.
3. Wait for the PC to recognize the micro:bit.
4. Select "Upload Firmware" from the Tools menu.
5. Click YES to update firmware.
6. Again, wait for the PC to recognize the micro:bit.

## Getting Started
1. Start micro:witch2 application. (see "Install on Windows")
2. Connect a micro:bit to your PC.
3. Click "display" at the top left of the screen.
4. Drag and drop "scroll Hello" block into the area on the right.
5. Double-click on the block to see hello on the micro: bit.

## Install repository on Pharo
micro:witch2 sources available on github (https://github.com/EiichiroIto/microwitch2/).

```
Metacello new
    baseline: 'Microwitch';
    repository: 'github://EiichiroIto/microwitch2/src';
    load.
```

## Limitations
- It has no micro:bit simulators.
- micro:bit v1 is not recommended due to memory capacity.

