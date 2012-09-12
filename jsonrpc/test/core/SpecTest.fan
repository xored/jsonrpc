const class ConstSpecHandler : ReflectHandler
{
  Int subtract(Int minuend, Int subtrahend) { minuend - subtrahend }
  
  Int sum(Int a, Int b, Int c) { a + b + c }
  
  Obj?[] get_data() { ["hello", 5] }
}

class SpecTest : RpcBaseTest, RpcUtils
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

  Void test3()
  {
    verifyPair(
      Str<|{"jsonrpc": "2.0", "method": "subtract", 
            "params": {"subtrahend": 23, "minuend": 42}, "id" : 3}|>,
      Str<|{"jsonrpc": "2.0", "result": 19, "id": 3}|>)
  }
  
  Void test4()
  {
    verifyPair(
      Str<|{"jsonrpc": "2.0", "method": "subtract", 
            "params": {"minuend": 42, "subtrahend": 23}, "id" : 4}|>,
      Str<|{"jsonrpc": "2.0", "result": 19, "id": 4}|>)
  }
  
  Void test5()
  {
    verifyNotification(Str<|{"jsonrpc": "2.0", "method": "update", "params": [1,2,3,4,5]}|>)
  }
  
  Void test6()
  {
    verifyNotification(Str<|{"jsonrpc": "2.0", "method": "foobar"}|>)
  }
  
  Void test7()
  {
    verifyPair(
      Str<|{"jsonrpc": "2.0", "method": "foobar", "id": "1"}|>,
      Str<|{"jsonrpc": "2.0", "error": {"code": -32601, "message": "Method not found."}, "id": "1"}|>)
  }
  
  Void test8()
  {
    
    verifyPair(
      Str<|{"jsonrpc": "2.0", "method": "foobar, "params": "bar", "baz]|>, //}
      Str<|{"jsonrpc": "2.0", "error": 
            {"code": -32700, "message": "Parse error."}, "id": null}|>)
  }
  
  Void test9()
  {
    verifyPair(Str<|{"jsonrpc": "2.0", "method": 1, "params": "bar"}|>,
      Str<|{"jsonrpc": "2.0", "error": {"code": -32600, 
            "message": "Invalid Request."}, "id": null}|>)
  }
  
  Void test10()
  {
    verifyPair(Str<|{"jsonrpc": "2.0", "method": "sum", "params": [1,2,4], "id": "1"},
                      {"jsonrpc": "2.0", "method"|>, //}
               Str<|{"jsonrpc": "2.0", 
                      "error": {"code": -32700, "message": "Parse error."}, "id": null}|>)
  }
  
  Void test11()
  {
    verifyPair(Str<|[]|>,
      Str<|{"jsonrpc": "2.0", "error": {"code": -32600, 
            "message": "Invalid Request."}, "id": null}|>)
  }
  
  Void test12()
  {
    verifyPair(Str<|[1]|>,
      Str<|[{"jsonrpc": "2.0", "error": {"code": -32600, "message": 
              "Invalid Request."}, "id": null}]|>)
  }
  
  Void test13()
  {
    verifyPair(Str<|[1,2,3]|>,
    Str<|[
           {"jsonrpc": "2.0", "error": {"code": -32600, "message": "Invalid Request."}, "id": null},
           {"jsonrpc": "2.0", "error": {"code": -32600, "message": "Invalid Request."}, "id": null},
           {"jsonrpc": "2.0", "error": {"code": -32600, "message": "Invalid Request."}, "id": null}
         ]|>)
  }
  
  Void test14()
  {
    verifyPair(
      Str<|[
            {"jsonrpc": "2.0", "method": "sum", "params": [1,2,4], "id": "1"},
            {"jsonrpc": "2.0", "method": "notify_hello", "params": [7]},
            {"jsonrpc": "2.0", "method": "subtract", "params": [42,23], "id": "2"},
            {"foo": "boo"},
            {"jsonrpc": "2.0", "method": "foo.get", "params": {"name": "myself"}, "id": "5"},
            {"jsonrpc": "2.0", "method": "get_data", "id": "9"} 
           ]|>,
      Str<|[
            {"jsonrpc": "2.0", "result": 7, "id": "1"},
            {"jsonrpc": "2.0", "result": 19, "id": "2"},
            {"jsonrpc": "2.0", "error": {"code": -32600, "message": "Invalid Request."}, "id": null},
            {"jsonrpc": "2.0", "error": {"code": -32601, "message": "Method not found."}, "id": "5"},
            {"jsonrpc": "2.0", "result": ["hello", 5], "id": "9"}
           ]|>)
  }
  
  Void test14a()
  {
    verifyNotification(Str<|[{"jsonrpc": "2.0", "method": "notify_hello", "params": [7]}]|>)
  }
  
  Void test15()
  {
    verifyNotification(
      Str<|[
            {"jsonrpc": "2.0", "method": "notify_sum", "params": [1,2,4]},
            {"jsonrpc": "2.0", "method": "notify_hello", "params": [7]}
           ]|>)
  }
  Void verifyNotification(Str request)
  {
    verifyNull(server.handle(request))
  }
      
  Void verifyPair(Str request, Str response)
  {
    responseJson := fromJsonStr(server.handle(request))
    expectedJson := fromJsonStr(response)
    verifyEquiv(responseJson, expectedJson)
  }
}
