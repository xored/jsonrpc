
abstract const class Response : RpcConsts
{
  new make(Obj id) { this.id = id }
  const Version version := defVersion
  const Obj id
  
  virtual Str:Obj toJson()
  {
    [versionField : version, idField : id]
  }
}

const class ResultResponse : Response
{
  const Obj? result
  new make(Obj? result, Obj id) : super(id) { this.result = result }
  
  override Str:Obj toJson() 
  {
    super.toJson[resultField] = result
  }
}

const class ErrResponse : Response
{
  const RpcErr err
  new make(RpcErr err, Obj id) : super(id) { this.err = err }
  
  override Str:Obj toJson()
  {
    super.toJson[errField] = err.toJson
  }
}