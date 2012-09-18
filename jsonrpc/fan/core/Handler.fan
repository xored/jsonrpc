
const mixin Handler
{
  abstract Obj? execute(Str  method, Obj? params)
  
  abstract Bool hasMethod(Str method)
  
  abstract Bool areParamsValid(Str method, Obj? params)
}

**
** Uses reflection to handle requests
const mixin ReflectHandler : Handler
{
  override Bool hasMethod(Str method) { typeof.slot(method, false) != null }
  
  override Bool areParamsValid(Str method, Obj? params)
  {
    slot := typeof.slot(method)
    paramDefs := slotParams(slot)
    if(tooManyParams(params, paramDefs)) return false
    
    paramVals := paramMap(params, paramDefs)
    
    return noUnknownParams(paramVals, paramDefs)
      && noUnmatchedParams(paramVals, paramDefs)
   
    return true
  }  
  
  override Obj? execute(Str method, Obj? params)
  {
    slot := typeof.slot(method)
    args := paramList(params, slotParams(slot))
    return exec(slot, args)
  }
  
  private Obj? exec(Slot slot, Obj?[] args)
  {
    if(slot is Field)
    {
      Field field := slot
      return field.isStatic ? field.get : field.get(this)
    }
    Method method := slot
    return method.isStatic ? method.callList(args) : method.callOn(this, args)
  }
  
  private static Bool noUnmatchedParams(Str:Obj? paramVals, Param[] paramDefs)
  {
    inDefaults := false
    for(i := 0; i < paramDefs.size; i++)
    {
      def := paramDefs[i]
      hasValue := paramVals.containsKey(def.name)
      if(!hasValue) inDefaults = true
      
      if(inDefaults && hasValue) return false //Once we are in defaults, no params can be given
      if(!hasValue && !def.hasDefault) return false //Default val is not set and no value given
      if(hasValue && !valueMatches(def, paramVals[def.name])) return false //Param is unassignable
    }
    return true
  }
  
  private static Bool valueMatches(Param param, Obj? val)
  {
    if (val == null) return param.type.isNullable
    if (val is List && param.type.fits(List#)) return true //don't match
    if (val is Map && param.type.fits(Map#)) return true   //  generic args
    return val.typeof.fits(param.type)
  }
 
  private static Bool isSimple(Type type)
  {
    serializable := type.facets.find { it is Serializable } as Serializable
    return serializable?.simple ?: false
  }
  
  private static Bool tooManyParams(Obj? params, Param[] paramDefs)
  {
    ((params is Map || params is List) ? params->size : 0) > paramDefs.size
  }

  private static Bool noUnknownParams(Str:Obj? paramVals, Param[] paramDefs)
  {
    paramVals.keys.all |k| { paramDefs.any |d| { d.name == k } }
  }
  
  ** List of pairs 
  private Param[] slotParams(Slot slot) 
  {
    return slot is Field ? [,] : (slot as Method).params
  }
  
  private static Obj?[] paramList(Obj? params, Param[] slotParams)
  {
    if(params == null) return [,]
    if(params is Obj?[]) return params
    Str:Obj? paramsMap := params
    result := [,]
    for(i := 0; i < slotParams.size; i++)
    {
      paramName := slotParams[i].name
      if(!paramsMap.containsKey(paramName)) break
      result.add(paramsMap[paramName])
    }
    return result
  }
  
  private static Str:Obj? paramMap(Obj? params, Param[] slotParams)
  {
    if(params == null) return [:]
    return params is Map ? params : 
      [:].addList((Obj?[])params) |p, i| { slotParams[i].name }
  }
}