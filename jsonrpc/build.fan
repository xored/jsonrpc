using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "jsonrpc"
    version = Version("2.0")
    summary = ""
    srcDirs = [`test/`, `test/web/`, `test/core/`, `fan/`, `fan/web/`, `fan/inet/`, `fan/core/`]
    depends = ["sys 1.0", "util 1.0", "web 1.0", "inet 1.0", "concurrent 1.0"]
  }
}
