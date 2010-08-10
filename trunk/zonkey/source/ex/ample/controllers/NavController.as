package ex.ample.controllers {	import ex.ample.views.NavView;	import mvc.core.Controller;	import mvc.core.Model;	import flash.events.MouseEvent;	/**	 * @author Matthijs Kamstra aka [mck]	 */	public class NavController extends Controller {		/**		 * The constructor.		 * 		 * @param model		the current model.		 * @param view		the current view.		 */		public function NavController( inModel : Model, inView : NavView = null ) {			super(inModel, inView);		}		/**		 * Event handler for the Navigation.		 * 		 * @param event		mouse event.		 */		public function clickHandler( event : MouseEvent ) : void {			var viewName : String = event.currentTarget[ 'name' ];			model.updateView(viewName);		}	}}