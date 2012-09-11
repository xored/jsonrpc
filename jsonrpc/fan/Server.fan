using util

const class Server
{
  private const Handler handler
  new make(Handler handler) { this.handler = handler }
  
  Str? handle(Str request)
  {
    json := fromJson(request)
    if(json isnot List) return toJson(handleRequest(Request.fromJson(json)))
    
    requests := json as Obj?[]
    if(requests.isEmpty) throw RpcErr.invalidRequest
    
    return toJson(
      requests
      .map |rq| 
      {
        try return handleRequest(Request.fromJson(json))
        catch(RpcErr e) return ErrResponse(e, null)
      }
      .exclude { it == null }
      .map |Response r -> Obj| { r.toJson }
    )
  }
  
  Response? handleRequest(Request request)
  {
    Obj? result := null 
    if(!handler.hasMethod(request.method)) 
      return buildResponse(request.id, RpcErr.methodNotFound)
    if(!handler.areParamsValid(request.method, request.params)) 
      return buildResponse(request.id, RpcErr.invalidParams)
    
    try  
      return buildResponse(request.id, 
        handler.execute(request.method, request.params))
    catch(Err e)
      return buildResponse(request.id, e)
  }
  
  private Response? buildResponse(Obj? id, Obj result)
  {
    if(id == null) return null
    if(result isnot Err) return ResultResponse(result, id)
    if(result isnot RpcErr) result = RpcErr.applicationError(result)
    return ErrResponse(result, id)
  }
  
  static Str? toJson(Obj? obj)
  {
    obj == null ? null : JsonOutStream.writeJsonToStr(obj)
  }
  
  static Obj fromJson(Str str)
  {
    try 
      return JsonInStream(str.in).readJson
    catch(ParseErr e)
      throw RpcErr.parseErr(e)
  }
}
