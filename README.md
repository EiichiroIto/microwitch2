# microwitch2
[micro:witch](https://github.com/EiichiroIto/microwitch) implemented in Pharo Smalltalk 10.

![screenshot1](https://github.com/EiichiroIto/microwitch2/raw/main/misc/PharoScreenshot.png)

micro:witch2 is built on Pharo Smalltalk 10.0.

## Install on Windows
1. Go to [release page](https://github.com/EiichiroIto/microwitch2/releases), and download a latest release file.
2. Extract the zipped release file.
3. Start microwitch.exe application.

## Getting Started
1. Start micro:witch2. (see above)
2. Connect micro:bit to your PC.
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

