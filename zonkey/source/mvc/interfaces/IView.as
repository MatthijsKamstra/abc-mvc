package mvc.interfaces {
	import mvc.core.Controller;
	import mvc.core.Model;

	import flash.events.Event;

	/**
	 * @author Matthijs Kamstra aka [mck]
	 */
	public interface IView {

		
		/**
		 * automaticly the view is added to the model.
		 * If that is not wise (for example with navigation)
		 * you should use this function to remove it from the model-list
		 */
		function removeFromModel() : void ;

		function registerEvents() : void;

		
		
		/**
		 * show this view
		 * default: visibility = true
		 */
		function show( event : Event ) : void ;

		/**
		 * hide this view
		 * default: visibility = false
		 */
		function hide( event : Event ) : void ;

		
		
		function destroy() : void ;

		
		
		
		//////////////////////////////////////// getter/setter ////////////////////////////////////////	

		
		function set model( inModel : Model ) : void ;

		function get model() : Model ;

		function set controller( inController : Controller ) : void ;

		function get controller() : Controller ;

		// change debug mode
		function get isDebugMode() : Boolean ;

		function set isDebugMode(isDebugMode : Boolean) : void ;

		// change autoRemove mode
		function get isAutoRemove() : Boolean ;

		function set isAutoRemove(value : Boolean) : void ;

		// auto hide (WERKT NIET)
		function get isAutoHide() : Boolean ;

		function set isAutoHide(value : Boolean) : void ;

		// auto block
		function get isAutoBlock() : Boolean ;

		function set isAutoBlock(value : Boolean) : void ;

		
		////////////////////////////////////////  ////////////////////////////////////////

		
		function toString() : String ;
	}
}
