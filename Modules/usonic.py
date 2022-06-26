# author Eiichiro Ito github.com/EiichiroIto
# License MIT License

import utime

triggerP = None
echoP = None

def init(trigger, echo):
  global triggerP, echoP
  triggerP = trigger
  echoP = echo

def _usec_getecho():
  c = 0
  triggerP.write_digital(1)
  triggerP.write_digital(0)
  while echoP.read_digital() == 0:
    utime.sleep_us(1)
    c += 1
    if c > 1000:
      return None
  t1 = utime.ticks_us()
  c = 0
  while echoP.read_digital() > 0:
    utime.sleep_us(1)
    c += 1
    if c > 1000:
      return None
  t2 = utime.ticks_us()
  return utime.ticks_diff(t2, t1)

def distance():
  t = _usec_getecho()
  if t is None:
    return 9999
  return int(340.0 * t / 20000)
