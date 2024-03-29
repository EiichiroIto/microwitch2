import time
from microbit import display,i2c

header = bytes([85,170,17])
algorithm = None
cacheData = []

def select_algorithm(a):
  global algorithm
  if not (0<=a<=8):
    return self
  algorithm = a
  b = header + bytes([2,45]) + bytes((a,0))
  c = checksum_of(b)
  b = b + (bytes((c,)))
  i2c.write(50,b)
  time.sleep_ms(100)
  return process_return_data()

def get_data():
  global cacheData
  if algorithm == 0:
    cacheData = blocks()
  elif algorithm == 1:
    cacheData = blocks()
  elif algorithm == 3:
    cacheData = arrows()
  else:
    cacheData = request_all()

def get_size():
  if cacheData is None:
    return 0
  return len(cacheData)

def get_property(p,i):
  if cacheData is None:
    return -1
  if not(0 <= i < len(cacheData)):
    return -1
  if not(0 <= p < len(cacheData[i])):
    return -1
  return cacheData[i][p]

def request_all():
  a = header + bytes([0,32,48])
  i2c.write(50,a)
  time.sleep_ms(10)
  return process_return_data()

def blocks():
  a = header + bytes([0,33,49])
  i2c.write(50,a)
  time.sleep_ms(10)
  return process_return_data()

def arrows():
  a = header + bytes([0,34,50])
  i2c.write(50,a)
  time.sleep_ms(10)
  return process_return_data()

def checksum_of(a):
  c = 0
  for b in a:
    c = c + b
  return c & 255

def convert_to_class_object_is_block(b,a):
  d = []
  for i in b:
    c = ("block",i[0],i[1],i[2],i[3],i[4]) if a else ("arrow",i[0],i[1],i[2],i[3],i[4])
    d.append(c)
  return d

def get_block_or_arrow_command():
  a = i2c.read(50,5)
  a = a + i2c.read(50,((a[3]) + 1))
  b = split_command_to_parts(a)
  c = b[3] == 42
  return (b[4],c)

def knock():
  i2c.write(50,(header + bytes([0,44,60])))
  time.sleep_ms(10)
  return process_return_data()

def process_return_data():
  g = i2c.read(50,5)
  h = i2c.read(50,((g[3]) + 1))
  a = split_command_to_parts(g + h)
  if (a[3]) == 46:
    return [("knockReceived",)]
  k = a[4]
  if len(k)<2:
    return []
  f = ((k[1]) * 256) + (k[0])
  d = True
  j = []
  for _ in range(0,f):
    k = get_block_or_arrow_command()
    d = k[1]
    j.append((k[0]))
  b = []
  for i in j:
    k = []
    for q in range(0,((len(i)) - 1)+1,2):
      e = i[q]
      c = i[q + 1]
      l = e
      if c > 0:
        l = e + 255 + c
      k.append(l)
    b.append(k)
  return convert_to_class_object_is_block(b, d)

def split_command_to_parts(a):
  g = ((a[0]) * 256) + (a[1])
  b = a[2]
  f = a[3]
  d = a[4]
  if f > 0:
    e = a[5:(5 + f) - 1+1]
  else:
    e = []
  c = a[5 + f]
  return (g,b,f,d,e,c)
