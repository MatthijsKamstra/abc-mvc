package ex.ample.views {	import assets.view.Delta;	import mvc.core.View;	/**	 * @author Matthijs Kamstra aka [mck]	 */	public class DeltaView extends View {		/**		 * Constructor		 */		public function DeltaView(  ) {			trace ( "+ DeltaView.DeltaView() - args: " + [  ] );						// View.isDebugMode = true; // check debugmode						addChild(new Delta());		}	}}