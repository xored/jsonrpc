
const class RpcErr : Err, RpcConsts
{
  new make(Int code, Str msg, Obj? data := null, Err? cause := null)
    : super(msg, cause)
  {
    this.code = code
    this.data = data
  }
  
  const Int code
  const Obj? data
    
  
  Str:Obj toJson()
  {
    [:]
  }
  
  private static RpcErr predefined(Int code, Obj? data := null, Err? cause := null) 
  {
    RpcErr(code, defaultMessages[code], data, cause)
  }
  
  static RpcErr parseErr(Err? cause := null) 
  {
    predefined(parseErrCode, null, cause)
  }
  
  static RpcErr invalidRequest()
  {
    predefined(invalidRequestCode)
  }
}
