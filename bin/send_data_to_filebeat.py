import socket, json, sys


HOST = '0.0.0.0'
PORT = 9000

try:
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
except socket.error as msg:
    sys.stderr.write("[ERROR] {}\n".format(msg[1]))
    sys.exit(1)

try:
    sock.connect((HOST, PORT))
except socket.error as msg:
    sys.stderr.write("[ERROR] {}\n".format(msg[1]))
    sys.exit(2)
        
sock.send(b'my test string')
sock.close()
   
sock.close()
sys.exit(0)
