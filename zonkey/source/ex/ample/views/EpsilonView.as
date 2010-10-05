package ex.ample.views {
	import assets.view.Epsilon;

	import mvc.core.Controller;
	import mvc.core.View;

	/**
	 * @author Matthijs Kamstra aka [mck]
	 */
	public class EpsilonView extends View {

		public function EpsilonView( inController : Controller = null, inType : String = VIEW_DEFAULT) {
			super(inController, inType);
			addChild(new Epsilon());
		}
	}
}
