
class ResponseTest : RpcBaseTest, RpcConsts
{
  Void testIntResponse()
  {
    verifyJson(ResultResponse(1, 2), Str<|{"jsonrpc":"2.0", "result":1, "id": 2}|>)
  }
  
  Void testStrResponse()
  {
    verifyJson(ResultResponse("1", "2"), Str<|{"jsonrpc":"2.0", "result":"1", "id":"2"}|>)
  }
  
  Void testNullResponse()
  {
    verifyJson(ResultResponse(null, "2"), Str<|{"jsonrpc":"2.0", "result":null, "id":"2"}|>)
  }
  
  Void testCompositeResponse()
  {
    verifyJson(ResultResponse(["int":1, "str":"a"], 0), Str<|{"jsonrpc":"2.0", "result":{"int":1,"str":"a"}, "id":0}|>)
  }
  
  Void testListResponse()
  {
    verifyJson(ResultResponse([1], 0), Str<|{"jsonrpc":"2.0", "result":[1], "id":0}|>)
  }
  
  Void testSimpleErr()
  {
    verifyJson(ErrResponse(RpcErr(0, "a"), 0), Str<|{"jsonrpc":"2.0", "id":0, "error":{"code":0, "message":"a"}}|>)
  }

  Void testDetailedErr()
  {
    verifyJson(ErrResponse(RpcErr(0, "a", [1,2,3]), 0), 
      Str<|{"jsonrpc":"2.0", "id":0, "error":{"code":0,"message":"a","data":[1,2,3]}}|>)
  }
  
  private static const Slot[] resultSlots := [Response#id, Response#version, ResultResponse#result]
  private static const Slot[] errSlots := [Response#id, Response#version, ErrResponse#err]
  
  private Void verifyJson(Response response, Str jsonStr) 
  {
    jsonFields := response is ErrResponse ? errResponseFields : resultResponseFields
    objSlots := response is ErrResponse ? errSlots : resultSlots 
    verifyFromToJson(response, json(jsonStr), jsonFields, objSlots)
  }
  
  override Void verifyEquiv(Obj? o1, Obj? o2)
  {
    if(o1 is RpcErr && o2 is RpcErr)
    {
      //Cannot just override RpcErr#hash and RpcErr#equals -- errs are not
      //'honest' FanObjs. TODO : report bug in fantom
      RpcErr e1 := o1
      RpcErr e2 := o2
      verifyEq(e1.msg, e2.msg)
      verifyEq(e1.code, e2.code)
      verifyEquiv(e1.data, e2.data)
    } else super.verifyEquiv(o1, o2)
  }
}
