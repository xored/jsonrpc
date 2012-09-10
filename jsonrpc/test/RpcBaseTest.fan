using util

**
** Helper methods -- cannot use mixin
** since need an access to Test slots 
** 
class RpcBaseTest : Test
{
  static Obj json(Str str)
  {
    JsonInStream(str.in).readJson
  }
  
  ** Deep comparison of maps and lists
  ** disregarding generic params
  virtual Void verifyEquiv(Obj? o1, Obj? o2)
  {
    if(o1 is Map && o2 is Map)
      verifyMaps(o1, o2)
    else if(o1 is List && o2 is List)
      verifyLists(o1, o2)
    else
      verifyEq(o1, o2)
  }
  
  Void verifyMaps(Map m1, Map m2)
  {
    verifyEq(m1.size, m2.size)
    verifyEq(m1.keys.intersection(m2.keys).size, m1.keys.union(m2.keys).size)
    m1.each |v,k| { verifyEquiv(v, m2[k]) }
  }
  
  Void verifyLists(List l1, List l2)
  {
    verifyEq(l1.size, l2.size)
    l1.size.times { verifyEquiv(l1[it], l2[it]) }
  }
  
  Void verifyFromToJson(Obj obj, Str:Obj? json, Str[] jsonFields, Slot[] objectFields)
  {
    Str:Obj json2 := obj->toJson
    jsonFields.each { verifyEquiv(json[it], json2[it]) }
    Obj obj2 := obj.typeof.method("fromJson").call(json)
    objectFields.each { verifyEquiv(call(it, obj), call(it, obj2)) }
  }
  
  private static Obj? call(Slot slot, Obj instance)
  {
    slot is Field ? (slot as Field).get(instance) : (slot as Method).call(instance)
  }

}
