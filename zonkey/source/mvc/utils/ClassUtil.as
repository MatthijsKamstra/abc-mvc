package mvc.utils {
	import flash.utils.getQualifiedClassName;

	public class ClassUtil {

		
		/**
		 * get the class name of a file
		 * 	
		 * @example			trace ("get ClassName: '" + ClassUtil.typeOf(this) + "'";
		 * @param		obj		class/target
		 * @return	 	the name of the class
		 */
		public static function typeOf(obj : Object) : String {
			var desc : String = flash.utils.getQualifiedClassName(obj);
			var a : Array = desc.split(/::/);
			return a[a.length - 1];
		}
	}
}