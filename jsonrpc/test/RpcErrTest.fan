
class RpcErrTest : RpcBaseTest, RpcConsts
{
  Void testSimpleJson()
  {
    verifyJson(RpcErr(0, "foo"), Str<|{"code":0, "message":"foo"}|>)
  }
  
  Void testPrimitiveData()
  {
    verifyJson(
      RpcErr(0, "foo", 42), 
      Str<|{"code":0, "message":"foo", "data":42}|>
    )
  }
  
  Void testCompositeDataToJson()
  {
    verifyJson(
      RpcErr(0, "foo", ["foo":"bar", "list":[1,2,3]]),
      Str<|{ "code":0, "message":"foo", "data": { "foo":"bar", "list":[1,2,3]}}|>
    )
  }
    
  Void testInvalidJson()
  {
    verifyErr(ArgErr#) { RpcErr.fromJson(1)  }
    verifyErr(ArgErr#) { RpcErr.fromJson([:]) }
    verifyErr(ArgErr#) { RpcErr.fromJson([codeField : 0])  }
    verifyErr(ArgErr#) { RpcErr.fromJson([messageField : "foo"])  }
    verifyErr(ArgErr#) { RpcErr.fromJson([codeField : "0", messageField : "foo"]) }
    verifyErr(ArgErr#) { RpcErr.fromJson([codeField : 0, messageField : 1]) }
  }
  
  Void verifyJson(RpcErr err, Str jsonStr)
  {
    verifyFromToJson(err, json(jsonStr), errFields, [RpcErr#code, RpcErr#msg, RpcErr#data])
  }
}
