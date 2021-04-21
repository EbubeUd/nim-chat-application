import json
type
    Message* = object
        username* : string
        message* : string


proc processMessage*(data: string) : Message =
    let dataJson = parseJson(data)
    result.username = dataJson["username"].getStr("Invalid Username")
    result.message = dataJson["message"].getStr("Invalid Message")
