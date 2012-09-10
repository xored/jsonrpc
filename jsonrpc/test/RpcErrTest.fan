
class RpcErrTest : Test, RpcConsts, TestUtils
{
  Void testSimpleJson()
  {
    verifyFromToJson(RpcErr(0, "foo"), [codeField : 0, messageField : "foo"])
  }
  
  Void testPrimitiveData()
  {
    verifyFromToJson(RpcErr(0, "foo", 42), [codeField:0, messageField:"foo", dataField: 42])
  }
  
  Void testCompositeDataToJson()
  {
    verifyFromToJson(
      RpcErr(0, "foo", ["foo":"bar", "list":[1,2,3]]), 
      [codeField:0, messageField:"foo", dataField: ["foo":"bar", "list":[1,2,3]]]
    )
  }
    
  Void testInvalidJson()
  {
    verifyErr(ArgErr#) { RpcErr.fromJson(1)  }
    verifyErr(ArgErr#) { RpcErr.fromJson([:]) }
    verifyErr(ArgErr#) { RpcErr.fromJson([codeField : 0])  }
    verifyErr(ArgErr#) { RpcErr.fromJson([messageField : "foo"])  }
    verifyErr(ArgErr#) { RpcErr.fromJson([codeField : "0", messageField : "foo"]) }
    verifyErr(ArgErr#) { RpcErr.fromJson([codeField : 0, messageField : 1 ]) }
  }
  
  Void verifyFromToJson(RpcErr err, Str:Obj json)
  {
    json2 := err.toJson
    errFields.each { verifyEq(json2[it], json[it]) }
    err2 := RpcErr.fromJson(json)
    verifyEq(err.msg, err2.msg)
    verifyEq(err.code, err2.code)
    verifyEq(err.data, err2.data)
  }
}
