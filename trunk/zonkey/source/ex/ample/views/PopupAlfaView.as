package ex.ample.views {
	import assets.view.PopupAlfa;

	import mvc.core.View;

	/**
	 * @author Matthijs Kamstra aka [mck]
	 */
	public class PopupAlfaView extends View {
		/**
		 * constructor
		 */
		public function PopupAlfaView() {
			addChild(new PopupAlfa());
		}
	}
}
