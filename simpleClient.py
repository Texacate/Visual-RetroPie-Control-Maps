import socket
import sys

host = '192.168.1.186'
port = 5561

def setupSocket():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((host, port))
    return s

def sendReceive(s, message):
    s.send(str.encode(message))
    reply = s.recv(1024)
    print("We have received a reply")
    print("Send closing message.")
    s.send(str.encode("EXIT"))
    s.close()
    reply = reply.decode('utf-8')
    return reply

def transmit(message):
    s = setupSocket()
    response = sendReceive(s, message)
    return response

print("This is the name of the script: " + sys.argv[0])
print("Number of arguments: " + str(len(sys.argv)))
print("The arguments are: " + str(sys.argv))
command = str(sys.argv[1])
print("Sending command to server: " + command)
try:
    response = transmit(command)
except KeyboardInterrupt:
    print("Ctrl C")
print("Response: " + response )
