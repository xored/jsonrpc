using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "jsonrpcweb"
    summary = ""
    srcDirs = [`fan/`]
    depends = ["sys 1.0", "jsonrpc 1.0", "util 1.0", "web 1.0", "webmod 1.0", "wisp 1.0"]
  }
}
