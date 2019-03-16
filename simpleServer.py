import os
import socket
import subprocess

host = ''
port = 5561

storedValue = "Yo, what's up?"

image_dir  = "/home/pi/button_images"
#image_dir  = "/home/pi/bin"
image_type = ".png"

def setupServer():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    print("Socket created.")
    try:
        s.bind((host, port))
    except socket.error as msg:
        print(msg)
    print("Socket bind comlete.")
    return s

def setupConnection():
    s.listen(1) # Allows one connection at a time.
    conn, address = s.accept()
    print("Connection from: " + address[0] + ":" + str(address[1]))
    return conn

def pathBuilder(sysrom):
    # print("pathBuilder(" + sysrom + ")")
    args = sysrom.split(' ', 1)
    sys = args[0]
    rom = args[1]
    # Look for rom image first
    path = image_dir + "/" + sys + "/" + rom + image_type
    # Not found? Look for system-default image
    if not (os.path.isfile(path)):
       path = image_dir + "/" + sys + "/default" + image_type
    # Not found? Look for generic image
    if not (os.path.isfile(path)):
       path = image_dir + "/default" + image_type
    # Still not found? Try an image that should be on the raspbery pi
    if not (os.path.isfile(path)):
       path = "/usr/share/cmake-3.7/Templates/Windows/SplashScreen.png"
    # Still not found? We really tried! Send garbage
    if not (os.path.isfile(path)):
       path = "I give up"
    # print("Built: "+ path)
    return path

def openImage(path):
    print("openImage (" + path + ")")
    cmd = "sudo fbi -vt 1 -a --noverbose " + path
    print("cmd(" + cmd + ")")
    proc = os.system(cmd)
    return proc

def closeImage():
    print("closeImage()")
    cmd = "sudo pkill fbi"
    print("cmd(" + cmd + ")")
    proc = os.system(cmd)
    out = "Done"
    return out

def GET():
    #print("Command: GET")
    reply = storedValue
    return reply

def REPEAT(dataMessage):
    #print("Command : REPEAT " + dataMessage[1])
    reply = dataMessage[1]
    return reply

def dataTransfer(conn):
    # A big loop that sends/receives data until told not to
    while True:
        # Receive the data
        data = conn.recv(1024) # receive the data
        data = data.decode('utf-8')
        # Split the data such that you separate the command
        # from the rest of the data.
        dataMessage = data.split(' ', 1)
        command = dataMessage[0]
        if command == 'GET':
            print("Command: GET")
            reply = GET()
        elif command == 'PATH':
            print("Command: PATH" +  " / Data: " + dataMessage[1])
            reply = pathBuilder(dataMessage[1])
        elif command == 'OPEN':
            print("Command: OPEN" +  " / Data: " + dataMessage[1])
            path = pathBuilder(dataMessage[1])
            proc = openImage(path)
            reply = "Opened Image: " + path
        elif command == 'CLOSE':
            print("Command: CLOSE")
            closeImage()
            reply = "Closed Image"
        elif command == 'REPEAT':
            print("Command: REPEAT" +  " / Data: " + dataMessage[1])
            reply = REPEAT(dataMessage)
        elif command == 'EXIT':
            print("Command: EXIT")
            print("Our client has left us")
            break
        elif command == 'KILL':
            print("Command: KILL")
            print("Our server is shutting down.")
            s.close()
            break
        else:
            print("Unknown command: " + command)
            reply = 'Unknown command. Valid commands are GET, REPEAT <string>, EXIT, KILL'
        # Send the reply back to the client
        conn.sendall(str.encode(reply))
        print("Data has been sent!")
    conn.close()

s = setupServer()

while True:
    try:
        conn = setupConnection()
        dataTransfer(conn)
    except:
        break

