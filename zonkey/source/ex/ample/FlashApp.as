package ex.ample {
	import mvc.core.View;

	import ex.ample.views.AlfaView;
	import ex.ample.views.BetaView;
	import ex.ample.views.DeltaView;
	import ex.ample.views.EpsilonView;
	import ex.ample.views.GammaView;

	import mvc.core.Application;
	import mvc.core.Model;
	import mvc.core.NavView;

	import nl.noiselibrary.utils.AlignUtil;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	[SWF(backgroundColor="#ff3333", frameRate="31", width="800", height="600")]
	/**	 * Zonkey	 * ex.ample.FlashApp	 */
	public class FlashApp extends Application {

		// ApplicationData
		private static const APP_WIDTH : Number = 800;
		private static const APP_HEIGHT : Number = 600;
		// put all views in the wrapper
		private var wrapper : Sprite;

		/**		 * Constructor		 */
		public function FlashApp() {
			trace("+ Zonkey + FlashApp.FlashApp() - args: " + []);
			/*			 * Application will start:			 * 			 * setupStage();			 * setupDomainAccess();			 * setupContextMenu();			 * setupConfig();			 * setupApplication();			 * init();			 */
		}

		/**		 * create layers		 */
		override protected function setupApplication() : void {
			// TODO: [mck] need to work but doesn't			model.setPrettyPrint('AlfaView', 'alfa');
			model.setPrettyPrint('BetaView', 'beta');			model.setPrettyPrint('GammaView', 'gamma');
			model.setPrettyPrint('DeltaView', 'delta');
			model.setPrettyPrint('EpsilonView', 'epsilon');

			// Setup layers for bg/main/views/popups
			wrapper = new Sprite();			// shortest way of setting views

			// first view initiated will be the default view (activated by Model.getInstance().showDefaultView())
			wrapper.addChild(new AlfaView(null, View.VIEW_ANIMATED));			wrapper.addChild(new BetaView());	// see class for more info (works the same as above, but now in the class)
			wrapper.addChild(new GammaView(null, View.VIEW_ANIMATED));			wrapper.addChild(new DeltaView());	// delta view has timeline 			wrapper.addChild(new EpsilonView(null, View.VIEW_ANIMATED));// wrapper.addChild(new PopupAlfaView());
				// place navigation on top, so add last			// if (!Application.IS_ONLINE) 
				wrapper.addChild(new NavView());
			
			
			
			// wrap it			addChild(wrapper);

			// create a quick ViewNames class			// Model.getInstance().outputViewNamePackage();			// get all in viewNameArray			// trace('Model.getInstance().viewNameArray: ' + (Model.getInstance().viewNameArray));			// show first/default view
			Model.getInstance().showDefaultView();

			// listen to browser resize			stage.addEventListener(Event.RESIZE, resizeHandler);

			// place everything 			resizeHandler(null);
		}

		/**		 * init data		 */
		override protected function init() : void {
			model.data = new XML();
		}

		// ////////////////////////////////////// resize-handler // //////////////////////////////////////
		private function resizeHandler(e : Event) : void {
			new AlignUtil(wrapper, AlignUtil.CENTER_TOP, new Rectangle(0, 0, APP_WIDTH, APP_HEIGHT), true);
		}
	}
}