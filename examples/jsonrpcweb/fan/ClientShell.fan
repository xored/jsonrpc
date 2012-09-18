using jsonrpc

class ClientShell
{
  private OutStream out := Env.cur.out
  private InStream in := Env.cur.in
  private Uri pwd := `/`
  private Void prompt() { out.print("$pwd\$ ").flush }
  Void main()
  {
    while(true)
    {
      prompt()
      cmd := in.readLine.split
      try { switch(cmd.first)
      {
        case "cd":
          arg := cmd.last
          if(!arg.endsWith("/")) arg = "$arg/"
          if(!arg.startsWith("/")) arg = "$pwd$arg"
          pwd = Uri(arg)
        case "ls":
          (client.request("ls", cmd.size == 1 ? pwd : cmd.last) as List).each { out.printLine(it).flush }
        case "cat":
          out.printLine(client.request("cat", cmd.last.startsWith("/") ? cmd.last : "$pwd$cmd.last"))
          
      } } catch(RpcErr e) { out.printLine(e.msg).flush }
    }
  }
  
  private RpcWebClient client := RpcWebClient(`http://localhost:8080/file`)
}
