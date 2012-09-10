using util
class RequestTest : Test, RpcConsts, TestUtils
{
  Void testSimple()
  {
    request := Request.fromJson(json(Str<|{ "jsonrpc" : "2.0", "method": "foo" }|>))
    verifyNull(request.id)
    verify(request.isNotification)
    verifyEq(request.params, [,])
    verifyEq(request.method, "foo")
  }
  
  Void testIntId()
  {
    request := Request.fromJson(json(Str<|{ "id" : 2, "jsonrpc" : "2.0", "method": "foo" }|>))
    verifyEq(request.id, 2)
    verifyFalse(request.isNotification)
  }
  
  Void testStrId()
  {
    request := Request.fromJson(json(Str<|{ "id" : "2", "jsonrpc" : "2.0", "method": "foo" }|>))
    verifyEq(request.id, "2")
  }
  
  Void testParamsList()
  {
    request := Request.fromJson(json(
      Str<|{ "id" : "2",
             "params" : [1,2,3],
             "jsonrpc" : "2.0", "method": "foo" }|>))
    verifyList(request.params, [1,2,3])
  }
  
  Void testParamsMap()
  {
    request := Request.fromJson(json(
      Str<|{ "id" : "2",
             "params" : { "first" : 1,"second" : 2},
             "jsonrpc" : "2.0", "method": "foo" }|>))
    verifyMap(request.params, ["first":1, "second":2])
  }
  
  Void testStructuredParams()
  {
    request := Request.fromJson(json(
      Str<|{ "id" : "2",
             "params" : [{"name":"Ivan", "age": 28}],
             "jsonrpc" : "2.0", "method": "foo" }|>))
    verifyMap(request.params->first, ["name":"Ivan", "age":28])
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
  private Void verifyInvalidRequest(Str json)
  {
    verifyRpcErr(invalidRequestCode) |->| {
      Request.fromJson(json)
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
}
