import os, threadpool


echo getAppFileName(), " Chat Application Started"

if paramCount() == 0:
    quit("Please specify the server address eg: ./client/localhost")

#Connect to the server
let serverAddress = paramStr(1)
let port = paramStr(2)
echo "Connecting to ", serverAddress,":",port, "..."

echo "Connected!"

while true:
    let message = spawn stdin.readLine()
    echo "Sending \"", ^message, "\""