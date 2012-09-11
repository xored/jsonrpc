const class ConstSpecHandler : ReflectHandler
{
  Int subtract(Int a, Int b) { a - b }
}

class SpecTest : RpcBaseTest
{
  private const Server server := Server(ConstSpecHandler())
  
  Void test1()
  {
    verifyPair(
      Str<|{"jsonrpc": "2.0", "method": "subtract", "params": [42, 23], "id": 1}|>,
      Str<|{"jsonrpc": "2.0", "result": 19, "id": 1}|>)
  }

  Void test2()
  {
    verifyPair(
      Str<|{"jsonrpc": "2.0", "method": "subtract", "params": [23, 42], "id": 1}|>,
      Str<|{"jsonrpc": "2.0", "result": -19, "id": 1}|>)
  }

  Void verifyPair(Str request, Str response)
  {
    responseJson := json(server.handle(request))
    expectedJson := json(response)
    verifyEquiv(responseJson, expectedJson)
  }
}
