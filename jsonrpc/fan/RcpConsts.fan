
mixin RpcConsts
{
  static const Version defVersion := Version("2.0")
  static const Str idField := "id"
  static const Str paramsField := "params"
  static const Str methodField := "method"
  static const Str versionField := "jsonrpc"
  static const Str resultField := "result"
  static const Str errField := "error"
  static const Str[] requestFields := [idField, paramsField, 
    methodField, versionField]
  
  static const Int parseErrCode := -32700
  static const Int invalidRequestCode := -32600
  
  static const Int:Str defaultMessages := [
      parseErrCode : "Parse error",
      invalidRequestCode : "Invalid Request"
    ]

}
