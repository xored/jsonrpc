
abstract const class Response : RpcUtils
{
  new make(Obj? id) { this.id = id }
  const Version version := defVersion
  const Obj? id
  
  virtual Str:Obj? toJson()
  {
    [versionField : version.toStr, idField : id]
  }
  
  static Response fromJson(Obj json)
  {
    if(json isnot Map) throw ArgErr("Unsupported response object")
    map := json as Map
    Obj? version := map[versionField] 
    Obj? id := map[idField]
    Obj? err := map[errField]
    hasId := map.containsKey(idField)
    hasResult := map.containsKey(resultField)
    Obj? result := map[resultField]
    
    verifyId(id, hasId)
    verifyVersion(version)
    
    if (
      (!hasResult && err == null) ||
      (hasResult && err != null)
        )
      throw ArgErr("Exaclty one of 'result' and 'error' fields must be set")
    
    if (hasResult) return ResultResponse(result, id)
    return ErrResponse(RpcErr.fromJson(err), id)
  }

  private static Void verifyId(Obj? id, Bool hasId) 
  {
    if(!hasId) throw ArgErr("response id field must be set")
    if(id != null && id isnot Str && id isnot Int) throw ArgErr("response id $id is neither string nor integer")
  }
  private static Void verifyVersion(Obj? version) 
  {
    if(version isnot Str || Version(version, false) != defVersion)
      throw ArgErr("Unsupported response version")
  }

}

const class ResultResponse : Response
{
  const Obj? result
  new make(Obj? result, Obj id) : super(id) { this.result = result }
  
  override Str:Obj? toJson() 
  {
    super.toJson[resultField] = result
  }
}

const class ErrResponse : Response
{
  const RpcErr err
  new make(RpcErr err, Obj? id := null) : super(id) { this.err = err }
  
  override Str:Obj toJson()
  {
    super.toJson[errField] = err.toJson
  }
}