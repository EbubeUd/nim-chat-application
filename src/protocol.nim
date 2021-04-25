import json, strutils
type
    MessageType* = enum
        system
        user

    Message* = object
        username* : string
        message* : string
        messageType* : MessageType




proc parseMessage*(data: string) : Message =
    let dataJson = parseJson(data)
    result.username = dataJson["username"].getStr("Invalid Username")
    result.message = dataJson["message"].getStr("Invalid Message")
    result.messageType = parseEnum[MessageType] dataJson["messageType"].getStr("user")

proc createMessage*(username, message : string, messageType: MessageType = user) : string =
    result = $(%{
        "username": %username,
        "message": %message,
        "messageType": %messageType
    }) & "\c\l"


when isMainModule:
    block TestParseMessage:
        let msg : string = """{"message":"Hello", "username":"Ebube", "messageType": "system"}"""
        let obj : Message = parseMessage(msg)
        let cond = obj.username == "Ebube"
        let cond2 = obj.message == "Hello"
        let cond3 = obj.messageType == system
        doAssert(cond)
        doAssert(cond2)
        doAssert(cond3)
        
    block TestCreateMessage:
        let expectedResult : string  = """{"username":"Ebube","message":"Hello","messageType":"user"}""" & "\c\l"
        
        let result : string = createMessage("Ebube", "Hello", user)
        echo result
        echo expectedResult
        doAssert(expectedResult == result)

    echo "Tests Passed!"

