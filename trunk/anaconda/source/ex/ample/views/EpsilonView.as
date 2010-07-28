package ex.ample.views {
	import assets.view.Epsilon;

	import mvc.core.View;

	/**
	 * @author Matthijs Kamstra aka [mck]
	 */
	public class EpsilonView extends View {

		public function EpsilonView( ) {
			addChild(new Epsilon());
		}
	}
}
