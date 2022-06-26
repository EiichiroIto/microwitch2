from microbit import i2c
import microbit as mb

address=None

def init():
  global address
  address = 64
  i2c.write(address,bytes([0,0]))
  oldmode = (i2c.read(address,1))[0]
  newmode = ((oldmode & 127) | 16)
  i2c.write(address,bytes([0,newmode]))
  i2c.write(address,bytes([254,121]))
  i2c.write(address,bytes([0,oldmode]))
  mb.sleep(5)
  i2c.write(address,bytes([0,(oldmode | 161)]))
        
def servo(ch, deg):
  if address is None:
    init()
  tmp = round(((((deg * 10) + 600) * 4095) / 20000))
  pxt = []
  pxt.append((6 + (4 * (16 - ch))))
  pxt.append(0)
  pxt.append(0)
  pxt.append((tmp & 255))
  pxt.append(((int(tmp) >> int(8)) & 255))
  i2c.write(address,bytes(pxt))

def motor(ch, speed):
  if address is None:
    init()
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
  i2c.write(address,bytes(pxt))
  pxt = []
  pxt.append((6 + (4 * ((4 - ch) * 2))))
  pxt.append(0)
  pxt.append(0)
  pxt.append((tmp2 & 255))
  pxt.append(((int(tmp2) >> int(8)) & 255))
  i2c.write(address,bytes(pxt))
