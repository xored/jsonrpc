using util

const class Server : RpcUtils
{
  private const Handler handler
  new make(Handler handler) { this.handler = handler }
  
  Str? handle(Str request)
  {
    Obj? json := null
    try json = fromJsonStr(request)
    catch(ParseErr e) return toErrStr(RpcErr.parseErr)
    

    if(json isnot List) return toJsonStr(getResponseJson(json))
    
    requests := json as Obj?[]
    if(requests.isEmpty) return toErrStr(RpcErr.invalidRequest)
    
    return toJsonStr(
      requests.map |rq| { getResponseJson(rq) }
      .exclude { it == null }
    )
  }
  
  private static Str toErrStr(RpcErr err, Obj? id := null) 
  { 
    toJsonStr(ErrResponse(err, id).toJson)
  }
  
  ** Parsed json -> Response json 
  private Obj? getResponseJson(Obj requestJson)
  {
    Request? request := null
    
    try request = Request.fromJson(requestJson)
    catch(RpcErr e) return toResponse(false, null, e).toJson
    
    return toResponse(request.isNotification, request.id, getResult(request))?.toJson
  }
  
  private Obj? getResult(Request request)
  {
    if(!handler.hasMethod(request.method)) return RpcErr.methodNotFound
    if(!handler.areParamsValid(request.method, request.params)) return RpcErr.invalidParams
    try return handler.execute(request.method, request.params)
    catch(Err e) return e
  }
  
  private Response? toResponse(Bool isNotification, Obj? id, Obj? result)
  {
    if(isNotification) return null
    if(result isnot Err) return ResultResponse(result, id)
    if(result isnot RpcErr) result = RpcErr.applicationError(result)
    return ErrResponse(result, id)
  }
  
  private static Str? toJsonStr(Obj? obj)
  {
    obj == null || ((obj as List)?.isEmpty ?: false) ? null : JsonOutStream.writeJsonToStr(obj)
  }
}
