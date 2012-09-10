using util
class RequestTest : RpcBaseTest, RpcConsts
{
  Void testSimple()
  {
    verifyJson(
      Request { method = "foo" }, 
      Str<|{ "jsonrpc" : "2.0", "method": "foo" }|>)
  }
  
  Void testIntId()
  {
    verifyJson(
      Request { method = "foo"; id = 2 },
      Str<|{ "id" : 2, "jsonrpc" : "2.0", "method": "foo" }|>)
  }
  
  Void testStrId()
  {
    verifyJson(
      Request { method = "foo"; id = "2" },
      Str<|{ "id" : "2", "jsonrpc" : "2.0", "method": "foo" }|>)
  }
  
  Void testParamsList()
  {
    verifyJson(
      Request { method = "foo"; params = [1,2,3]; id = "2" },
      Str<|{ 
             "id" : "2",
             "params" : [1,2,3],
             "jsonrpc" : "2.0", 
             "method": "foo" }|>)
  }
  
  Void testParamsMap()
  {
    verifyJson(
      Request { method = "foo"; params = ["first":1, "second":2]; id = "2" },
      Str<|{ 
             "id" : "2",
             "params" : {"first":1, "second":2},
             "jsonrpc" : "2.0", 
             "method": "foo" }|>)
  }
  
  Void testStructuredParams()
  {
    verifyJson(
      Request { method = "foo"; params = [["name":"Ivan", "age":28]]; id = "foo" },
      Str<|{ 
             "id" : "foo",
             "params" : [{"name":"Ivan", "age": 28}],
             "jsonrpc" : "2.0", "method": "foo" }|>)
  } 
  Void testNoVersion()
  {
    verifyInvalidRequest(Str<|{ "id" : "2", "method": "foo" }|>)
  }
  
  Void testUnparseableVersion()
  {
    verifyInvalidRequest(Str<| "id": 2, "method":"foo", "jsonrpc": "aaa" |>)
  }
  
  Void testUnmatchingVersion()
  {
    verifyInvalidRequest(Str<| "id": 2, "method":"foo", "jsonrpc": "1.0" |>)
  }
  
  Void testNoMethod()
  {
    verifyInvalidRequest(Str<|"id":2, "jsonrpc":"2.0"|>)
  }
  
  Void testMethodNotStr()
  {
    verifyInvalidRequest(Str<|"id":2, "jsonrpc" : "2.0", "method":32|>)
  }
  
  Void testParamsNotListOrMap()
  {
    verifyInvalidRequest(Str<|"id":2, "jsonrpc":"2.0","method":"a", "params":20|>)
  }
  
  private Void verifyInvalidRequest(Str jsonStr)
  {
    verifyRpcErr(invalidRequestCode) |->| {
      Request.fromJson(json(jsonStr))
    }
  }
  
  private Void verifyList(Obj?[] actual, Obj?[] expected)
  {
    verifyEq(expected.size, actual.size)
    expected.size.times { verifyEq(expected[it], actual[it]) }
  }
  
  private Void verifyMap(Obj:Obj? actual, Obj:Obj? expected)
  {
    verifyEq(expected.size, actual.size)
    expected.each |v,k| { verifyEq(v, actual[k]) }
  }
  
  private Void verifyRpcErr(Int code, |->| func)
  {
    try func()
    catch(RpcErr e)
    {
      verifyEq(e.code, code)
      return
    }
    verify(false, "Expected RcpErr")
  }
  
  private Void verifyJson(Request request, Str jsonStr) 
  {
    verifyFromToJson(request, json(jsonStr), requestFields, 
      [Request#id, Request#method, Request#params, Request#version, Request#isNotification])
  }
}
