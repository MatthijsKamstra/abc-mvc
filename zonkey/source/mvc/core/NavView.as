package mvc.core {	
	import mvc.utils.EasyButton;

					
					if (_offset >= (stage.stageWidth - p.x - 100) ) {
						eb.x = 0;
						eb.y = previous.height + 5;
						eb.x = _offset;
						eb.y = previous == null ? 0 : previous.y;