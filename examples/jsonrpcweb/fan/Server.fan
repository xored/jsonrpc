using util
using wisp
using webmod
using jsonrpc

class Server : AbstractMain
{
  @Opt Int port := 8080
  override Int run()
  {
    runServices(
      [
        WispService
        {
          it.port = this.port
          it.root = RouteMod
          {
            routes = 
            [
              "file" : RpcMod(FileHandler()),
              "math" : RpcMod(MathHandler())
            ]
          }
        }
      ])
  }
}

const class MathHandler : ReflectHandler
{
  Int sum(Int[] args) { args.reduce(0) |Int r, Int v->Int| { r + v } }
}

const class FileHandler : ReflectHandler
{
  
  Str cat(Str path) 
  {
    file := file(path)
    if(file.isDir) throw RpcErr(1, "cat: $path Is a directory")
    return file.readAllStr 
  }
  
  private File file(Str path) 
  {
    uri := Uri.fromStr(path, false)
    if(uri == null) throw RpcErr(0, "Invalid path")
    return uri.toFile
  }
 
  Str[] ls(Str dir) 
  { 
    file := file(dir)
    if(!file.isDir) return [file.osPath]
    return file.list.map { it.name }
  }
}

