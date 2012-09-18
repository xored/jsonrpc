using util
using jsonrpc

class Server : AbstractMain
{
  @Opt Int port := 4750
  
  override Int run()
  {
    runServices([RpcService(MathHandler(), port)])
  }
}

const class MathHandler : ReflectHandler
{
  Int sum(Int[] args) { args.reduce(0) |Int r, Int v->Int| { r + v } }
}
