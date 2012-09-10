using util

const mixin Server
{
  ** 
  ** Returns 'null' when request is notification,
  ** thus transport should not send anything
  ** 
  ** Throws `#RcpErr` if request cannot be handled
  ** 
  Str? handle(Str request) 
  {
    json := readJson(request)
    return null
  }
  
  private Obj readJson(Str request) 
  {
    try {
      return JsonInStream(request.in).readJson
    } catch(ParseErr e) {
      throw RpcErr.parseErr(e)
    }
  }
}
