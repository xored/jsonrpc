using web

const class RpcMod : WebMod
{
  private const Server server
  new make(Handler handler) { server = Server(handler) }
  
  override Void onPost()
  {
    buf := (server.handle(req.in.readAllStr) ?: "")?.toBuf
    res.headers["Content-Type"] = "application/json"
    res.headers["Content-Length"] = buf.size.toStr
    res.out.writeBuf(buf).flush.close 
  }
}
