using jsonrpc
using inet

class Client
{
  private RpcTcpClient client := RpcTcpClient(IpAddr.local, 4750)
  Void main()
  {
    while(true)
    {
      Env.cur.out.print("\$ ").flush
      cmd := Env.cur.in.readLine
      if(["quit", "exit"].contains(cmd.trim)) break
      ints := cmd.split.map { it->toInt }
      client.request("sum", [ints]) |res| { echo(res.call) }
    }
  }
}
