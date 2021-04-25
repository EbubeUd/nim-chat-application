import json
type
    Message* = object
        username* : string
        message* : string


proc parseMessage*(data: string) : Message =
    let dataJson = parseJson(data)
    result.username = dataJson["username"].getStr("Invalid Username")
    result.message = dataJson["message"].getStr("Invalid Message")

proc createMessage*(username, message : string) : string =
    result = $(%{
        "username": %username,
        "message": %message
    }) & "\c\l"


when isMainModule:
    block TestParseMessage:
        let msg : string = """{"message":"Hello", "username":"Ebube"}"""
        let obj : Message = parseMessage(msg)
        let cond = obj.username == "Ebube"
        let cond2 = obj.message == "Hello"
        doAssert(cond)
        doAssert(cond2)
        
    block TestCreateMessage:
        let expectedResult : string  = """{"username":"Ebube","message":"Hello"}""" & "\c\l"
        let result : string = createMessage("Ebube", "Hello")
        doAssert(expectedResult == result)

    echo "Tests Passed!"

