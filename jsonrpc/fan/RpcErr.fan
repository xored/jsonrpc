
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
    [codeField : code,
      messageField : msg].with 
    {
      if(data != null) it[dataField] = data
    }
  }
  
  static RpcErr fromJson(Obj? input)
  {
    json := input as Str:Obj?
    if(json == null) throw ArgErr("Can't read RpcErr from json")
    code := json[codeField] as Int
    msg := json[messageField] as Str
    data := json[dataField]
    if(msg == null || code == null) 
      throw ArgErr("Can't read RpcErr from json")
    return RpcErr(code, msg, data)
  }
  
  private static RpcErr predefined(Int code, Obj? data := null) 
  {
    RpcErr(code, defaultMessages[code], data)
  }
  
  static RpcErr parseErr(Err? cause := null) 
  {
    predefined(parseErrCode, cause.traceToStr)
  }
  
  static RpcErr invalidRequest()
  {
    predefined(invalidRequestCode)
  }
  
  static RpcErr methodNotFound()
  {
    predefined(methodNotFoundCode)
  }
  
  static RpcErr invalidParams() 
  {
    predefined(invalidParamsCode)
  }
  
  static RpcErr internalError()
  {
    predefined(internalErrorCode)
  }
  
  static RpcErr applicationError(Err e)
  {
    predefined(applicationErrorCode, e.traceToStr)
  }
}
