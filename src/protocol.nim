import json
type
    Message* = object
        username* : string
        message* : string


proc processMessage*(data: string) : Message =
    let dataJson = parseJson(data)
    result.username = dataJson["username"].getStr("Invalid Username")
    result.message = dataJson["message"].getStr("Invalid Message")


when isMainModule:
    block Test:
        let msg : string = """{"message":"Hello", "username":"Ebube"}"""
        let obj : Message = processMessage(msg)
        let cond = obj.username == "Ebube"
        let cond2 = obj.message == "Hello"
        doAssert(cond)
        doAssert(cond2)
        echo "Tests Passed!"
