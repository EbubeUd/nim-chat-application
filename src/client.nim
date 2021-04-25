import os, asyncdispatch, asyncnet, threadpool
import protocol
var username = ""


proc connect(socket: AsyncSocket, serverAddr: string) {.async.} =

    echo("Connecting to ", serverAddr)
    await socket.connect(serverAddr, 7687.Port)
    while true:
        let line = await socket.recvLine()
        let parsed : Message = parseMessage(line)
        echo("[",parsed.username, "] : ", parsed.message)

    echo("Chat application started")



if paramCount() == 0:
    quit("Please specify the server address, e.g. ./client localhost")

let serverAddr = paramStr(1)
var socket = newAsyncSocket()

asyncCheck connect(socket, serverAddr)

echo "Input a Username: "
var messageFlowVar = spawn stdin.readLine()


while true:
    if messageFlowVar.isReady():
        username = ^messageFlowVar
        break;

echo "username set as ", username

echo "# type in a message to send to the channel and hit enter to send"

try:
    while true:
        if messageFlowVar.isReady():
            let message = createMessage(username, ^messageFlowVar, MessageType.user)
            asyncCheck socket.send(message)
            messageFlowVar = spawn stdin.readLine()
        asyncdispatch.poll()
except:
    echo "There was an error connecting the server: ", getCurrentExceptionMsg()