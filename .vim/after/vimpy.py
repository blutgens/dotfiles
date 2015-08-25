import sys, vim
class Buffer:
    def __init__(self,buf):
        self.buf=buf
    def write(self,s):
        ll=s.split('\n')
        self.buf[-1]+=ll[0]
        for l in ll[1:]:
            self.buf.append(l)
    def clear(self):
        del self.buf[:]

def redirect(buf=None):
    buf = buf or vim.current.window.buffer
    try:
        sys._stdout
    except:
        sys._stdout=sys.stdout
    sys.stdout = Buffer(buf)
