# micro:witch2
[日本語](https://github.com/EiichiroIto/microwitch2/blob/main/README.ja.md)

micro:witch2 is a block-style programming environment for BBC micro:bit.

micro:witch2 is the successor to [micro:witch](https://github.com/EiichiroIto/microwitch) and is implemented in Pharo Smalltalk 10.

![screenshot1](https://github.com/EiichiroIto/microwitch2/raw/main/misc/PharoScreenshot.png)

## Install on Windows
1. Go to [release page](https://github.com/EiichiroIto/microwitch2/releases), and download a latest release file.
2. Extract the zipped release file.
3. Double-click microwitch.exe to start the application.

## Updating MicroPython firmware
1. Start micro:witch2 application. (see above)
2. Connect a micro:bit to your PC.
3. Wait for the PC to recognize the micro:bit.
4. Select "Initialize micro:bit" from the Tools menu.
5. Click YES to initialize the micro:bit.
6. Again, wait for the PC to recognize the micro:bit.

## Getting Started
1. Start micro:witch2 application. (see "Install on Windows")
2. Connect a micro:bit to your PC.
3. Click "display" at the top left of the screen.
4. Drag and drop "scroll Hello" block into the area on the right.
5. Double-click on the block to see hello on the micro:bit.

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

