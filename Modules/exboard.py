import microbit as mb

class DFRobotExBoard():
    def __init__(self, addr=64):
        self.addr = addr
        mb.i2c.write(self.addr,bytes([0,0]))
        oldmode = (mb.i2c.read(self.addr,1))[0]
        newmode = ((oldmode & 127) | 16)
        mb.i2c.write(self.addr,bytes([0,newmode]))
        mb.i2c.write(self.addr,bytes([254,121]))
        mb.i2c.write(self.addr,bytes([0,oldmode]))
        mb.sleep(5)
        mb.i2c.write(self.addr,bytes([0,(oldmode | 161)]))
        
    def servo(self, ch, deg):
        tmp = round(((((deg * 10) + 600) * 4095) / 20000))
        pxt = []
        pxt.append((6 + (4 * (16 - ch))))
        pxt.append(0)
        pxt.append(0)
        pxt.append((tmp & 255))
        pxt.append(((int(tmp) >> int(8)) & 255))
        mb.i2c.write(self.addr,bytes(pxt))

    def motor(self, ch, speed):
        tmp = speed * 16
        tmp = min(tmp,4095)
        tmp = max(tmp,-4095)
        tmp2 = 0
        if (tmp < 0):
            tmp2 = -tmp
            tmp = 0
        pxt = []
        pxt.append((6 + (4 * (((4 - ch) * 2) + 1))))
        pxt.append(0)
        pxt.append(0)
        pxt.append((tmp & 255))
        pxt.append(((int(tmp) >> int(8)) & 255))
        mb.i2c.write(self.addr,bytes(pxt))
        pxt = []
        pxt.append((6 + (4 * ((4 - ch) * 2))))
        pxt.append(0)
        pxt.append(0)
        pxt.append((tmp2 & 255))
        pxt.append(((int(tmp2) >> int(8)) & 255))
        mb.i2c.write(self.addr,bytes(pxt))
