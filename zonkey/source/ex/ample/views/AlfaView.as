package ex.ample.views {	import assets.view.Alfa;	import mvc.core.View;
	import mvc.core.Controller;	/**	 * @author Matthijs Kamstra aka [mck]	 */	public class AlfaView extends View {		/**		 * Constructor		 */		public function AlfaView(inController : Controller = null, inType : String = VIEW_DEFAULT) {
			super(inController, inType);
			addChildAt(new Alfa(),0);						//trace("+ AlfaView.AlfaView() - args: " + [inController, inType]);		}	}}