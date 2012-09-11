const class TestHandler : ReflectHandler
{
  Void voidVoid() {}
  static Void voidVoidStatic() {}
  
  Int voidInt() { 1 }
  static Int voidIntStatic() { 1 }
  
  Void intVoid(Int i) {}
  static Void intVoidStatic(Int i) {}
  
  Str intStr(Int i) { i.toStr }
  static Str intStrStatic(Int i) { i.toStr }
  
  Str intStrStr(Int i, Str s := "default") { "$s($i)" } 
  Str intStrStrStatic(Int i, Str s := "default") { "$s($i)" }
  
  const Str strField := "s"
  static const Str strFieldStatic := "s" 
}
class ReflectHandlerTest : Test
{
  private static const Str voidVoid := TestHandler#voidVoid.name
  private static const Str voidVoidStatic := TestHandler#voidVoidStatic.name
  private static const Str voidInt := TestHandler#voidInt.name
  private static const Str voidIntStatic := TestHandler#voidIntStatic.name
  private static const Str intVoid := TestHandler#intVoid.name
  private static const Str intVoidStatic := TestHandler#intVoidStatic.name
  private static const Str intStr:= TestHandler#intStr.name
  private static const Str intStrStatic := TestHandler#intStrStatic.name
  private static const Str intStrStr := TestHandler#intStrStr.name
  private static const Str intStrStrStatic := TestHandler#intStrStrStatic.name
  private static const Str strField := TestHandler#strField.name
  private static const Str strFieldStatic := TestHandler#strFieldStatic.name

  static const TestHandler handler := TestHandler()
  
  Void testVoidVoid()
  {
    methods := [voidVoid, voidVoidStatic]
    verifyPositive(methods, [null, [,], [Str:Obj?][:]])
    verifyInvalidArgs(methods, [[1], ["i":1], ["foo":"bar"]])
  }
  
  Void testVoidInt()
  {
    paramSets := [null, [,], [:]]
    verifyPositive([voidInt, voidIntStatic], paramSets, 1)
  }
  
  Void testIntStr()
  {    
    paramSets := [[1], ["i":1]]
    verifyPositive([intStr, intStrStatic], paramSets, "1")
  }
  
  Void testIntVoid()
  {
    verifyPositive([intVoid, intVoidStatic], [[1], ["i":1]])
  }
  
  Void testIntStrStr()
  {
    verifyPositive(
      [intStrStr, intStrStrStatic], 
      [[1, "2"], ["i":1, "s":"2"]], 
      "2(1)")
  }
  
  Void testIntStrStrDefault()
  {
    methods := [intStrStr, intStrStrStatic]
    verifyPositive(methods, [[3], ["i":3]], "default(3)")
    verifyInvalidArgs(methods, [["a"], [null, "a"], ["s":"a"]])
  }
  
  Void testStrField()
  {
    verifyPositive([strField, strFieldStatic], [null, [,], [:]], "s")
  }
  
  Void testInvalidMethod()
  {
    verifyFalse(handler.hasMethod("foo"))
  }
  
  Void verifyInvalidArgs(Str[] methods, Obj?[] paramSets)
  {
    methods.each |method|
    {
      paramSets.each |params|
      {
        verifyFalse(handler.areParamsValid(method, params), "method: $method, args: $params")
      }
    }
  }
  Void verifyPositive(Str[] methods, Obj?[] paramSets, Obj? retVal := null)
  {
    methods.each |method| 
    {
      verify(handler.hasMethod(method))
      paramSets.each 
      { 
        verify(handler.areParamsValid(method, it), "method: $method, args: $it")
        verifyEq(retVal, handler.execute(method, it))
      }
    }
  }
}
