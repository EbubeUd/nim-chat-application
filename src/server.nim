import asyncdispatch, asyncnet, asyncfile

type
    Client = ref object
        socket: AsyncSocket
        netAddr: string
        id: int
        connected: bool

    Server = ref object
        socket : AsyncSocket
        clients : seq[Client]
        
proc newServer : Server = 
    Server(socket: newAsyncSocket(), clients: @[])


var server = newServer()

proc `$`(client: Client) : string =
    $client.id & " (" & $client.netAddr & ")"


proc notifyPublic(server: Server, fromClient : Client, message : string) {.async.} =
    for c in server.clients:
        if c.id != fromClient.id and c.connected:
            await c.socket.send(message & "\c\l")

proc processMessages(server: Server, client: Client) {.async.} =
    while true:
        let message = await client.socket.recvLine()
        if message.len == 0:
            echo client, " disconnected"
            client.connected = false
            client.socket.close()

            #Alert other clients that this client just left the server
            let msg : string = "Client #" & $client.id  & " just left the chat"
            await notifyPublic(server, client, msg)

            return
        await notifyPublic(server, client, message)


proc loop(server: Server, port : int = 7687) {.async.} =
    #Bind the Server's Socket to the port
    server.socket.bindAddr(Port(port)) #or port.Port

    #Listen for new connections
    server.socket.listen

    while true: 
        let (netAddr, clientSocket) = await server.socket.acceptAddr()
        echo "Accepted Connection from ", netAddr
        let client = Client(
            socket: clientSocket,
            netAddr: netAddr,
            id :  server.clients.len,
            connected: true
        )
        server.clients.add(client)      

        #Start listening for messages from this client
        asyncCheck processMessages(server, client)

        #Alert other clients that this client just joined the chat
        let msg : string = "Client #" & $client.id & " just joined the chat"
        await notifyPublic(server, client, msg)  

      
waitFor loop(server)