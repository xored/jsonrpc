using util
const class Request : RpcConsts
{
  new make(|This|? f := null) { f?.call(this) }
  
  **
  ** jsonrpc field
  ** 
  const Version version := defVersion
  
  const Str method

  **
  ** Either `sys::List` for oredered params or `sys::Map` 
  ** for named params
  ** 
  const Obj? params
  
  ** [Str]`sys::Str` or [Int]`sys::Int`, if null, then request
  ** is a notification and server should not send any response 
  const Obj? id

  Bool isNotification() { id == null }
  
  Str:Obj? toJson()
  {
    [Str:Obj?][
      versionField : version.toStr,
      methodField : method,
    ].with 
    { 
      if(id != null) it[idField] = id 
      if(params != null) it[paramsField] = params
    }
  }
  
  static Request fromJson(Obj json) 
  {
    if(json isnot Map) throw RpcErr.invalidRequest
    map := json as Map
    Obj? version:= map[versionField]
    Obj? id := map[idField]
    Obj? params := map[paramsField]
    Obj? method := map[methodField]

    verifyMethod(method)
    verifyVersion(version)
    verifyParams(params)
    verifyId(id)
    
    return Request {
      it.method = method
      it.params = params
      it.id = id
    }
  }
  
  private static Void verifyMethod(Obj? method) 
  {
    if(method isnot Str) throw RpcErr.invalidRequest
  }
  
  private static Void verifyVersion(Obj? version) 
  {
    if(version isnot Str || Version(version, false) != defVersion)
      throw RpcErr.invalidRequest
  }
  
  private static Void verifyParams(Obj? params)
  {
   if(params != null && params isnot Map && params isnot List) throw RpcErr.invalidRequest 
  }
  
  private static Void verifyId(Obj? id)
  {
    if(id != null && id isnot Str && id isnot Int) throw RpcErr.invalidRequest
  }
}
