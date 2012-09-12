using web

const class RpcMod : WebMod
{
  private const Server server
  new make(Handler handler) { server = Server(handler) }
}
