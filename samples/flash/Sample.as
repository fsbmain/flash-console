﻿/*
*
* Copyright (c) 2008-2010 Lu Aye Oo
*
* @author 		Lu Aye Oo
*
* http://code.google.com/p/flash-console/
*
*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
* 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software
* in a product, an acknowledgment in the product documentation would be
* appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
*
*/
package
{
	import com.junkbyte.console.CLog;
	import com.junkbyte.console.Cc;
	import com.junkbyte.console.ConsoleChannel;
	import com.junkbyte.console.ConsoleVersion;
	import com.junkbyte.console.modules.graphing.custom.CustomGraphingGroup;
	import com.junkbyte.console.modules.graphing.custom.CustomGraphingLine;
	import com.junkbyte.console.modules.graphing.custom.CustomGraphingModule;
	import com.junkbyte.console.modules.graphing.fps.FPSGraphingModule;
	import com.junkbyte.console.modules.graphing.GraphingGroup;
	import com.junkbyte.console.modules.graphing.GraphingCentralModule;
	import com.junkbyte.console.modules.graphing.GraphingPanelsCentralModule;
	import com.junkbyte.console.modules.graphing.memory.MemoryGraphingModule;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;

	[SWF(width = '640', height = '480', backgroundColor = '0xDDDDDD', frameRate = '60')]
	public class Sample extends MovieClip
	{

		[Embed(source = "SampleAssets.swf", symbol = "SampleScreenClip", mimeType = "application/x-shockwave-flash")]
		public var ScreenClipClass:Class;

		public var screenClip:Sprite;

		private var _spamcount:int;

		public function Sample()
		{
			//
			// SET UP - only required once
			//
			//Cc.config.keystrokePassword = "`";

			Cc.startOnStage(this); // "`" - change for password. This will start hidden
			Cc.layer.visible = true; // Show console, because having password hides console.


			//Cc.config.remotingPassword = ""; // Just so that remote don't ask for password
			//Cc.remoting = true; // Start sending logs to remote (using LocalConnection)

			//Cc.modules.registerModule(new TraceModule());

			Cc.mainPanel.setPanelSize(640, 220);

			//StandardConsoleModules.registerToConsole();

			CLog.log(Cc.modules.getAllModules().join(", "));
			
			
			Cc.modules.registerModule(new GraphingCentralModule());
			
			Cc.modules.registerModule(new FPSGraphingModule());
			
			Cc.modules.registerModule(new MemoryGraphingModule());
			
			
			var group:CustomGraphingGroup = new CustomGraphingGroup();
			group.lines.push(new CustomGraphingLine(this, "mouseX", "x", 0xFF0000));
			group.lines.push(new CustomGraphingLine(this, "mouseY", "y", 0x3333FF));
			Cc.modules.registerModule(new CustomGraphingModule(group));
			
			Cc.modules.registerModule(new GraphingPanelsCentralModule());
			//
			// End of setup
			//

			// show the demo logging stuff there...
			demoBasics();

			setupUI();
		/*

		CLog.addEntry(new LogEntry(["test"], "ch", 10));
		CLog.addEntry(new LogEntry(["An info message.", "Optionally there", "can be", "multiple arguments."], "ch", 4));
		CLog.addEntry(new LogEntry(["Some numbers and booleans", 341, 123123123, false, 0.123123, "END"], "ch", 4));


		CLog.log(<test><hello attribute="1234"/></test>);

		CLog.addEntry(new LogEntry([Cc, Cc.config], "ch", 4));

		CLog.info("<html>Some random html <tags/></html>");

		CLog.addHTML("<html>Some <i>random</i> <b>html</b></html>");

		CLog.addHTML("<html>Some <i>random</i> <b>html<b/></html>");*/
		}

		private function demoBasics():void
		{
			CLog.log("Hello world.");
			CLog.info("An info message.", "Optionally there", "can be", "multiple arguments.");
			//CLog.debug("A debug level log.", "You can also pass an object and it'll become a link to inspect:", this);
			//CLog.warn("This is a warning log.", "Lets try the object linking again:", stage, " <- click it! (press 'exit' when done)");
			//CLog.error("This is an error log.", "This link might not work because it can get garbage collected:", new Sprite());
			//CLog.fatal("This is a fatal error log with high visibility.", "Also gets a stack trace on debug player...");
			//
			// Basic channel logging
			//
			CLog.infoch("myChannel", "Hello myChannel.");
			//CLog.debugch("myChannel", "A debug level log.", "There is also Cc.errorch() and Cc.fatalch(). Skipping that for demo.");
			//
			// Instanced channel
			//
			var ch:ConsoleChannel = new ConsoleChannel('myCh');
			ch.info("Hello!", "Works just like other logging methods but this way you keep the channel as an instance.");

			//
			// Stack tracing
			//
			//CLog.stack("Stack trace called from... (need debug player)");
		/* //If you have debug player, it'll show up in console as:
		   Stack trace called from... (need debug player)
			@ Sample/demoBasics()
			@ Sample()
		*/
			// Use Cc.stackch(...) to have channel name.

			// When 'no repeat' (3rd param) is set to true, it will not generate new lines for each log.
			// It will keep replacing the previous line with repeat turned on until a certain count is passed.
			// For example, if you are tracing download progress and you don't want to flood console with it.
			// If you want to specify the channel, use:
			// Use Cc.ch(channel:*, str:*, priority:int, isRepeating:Boolean)
		}

		//
		//
		//
		private function setupUI():void
		{
			screenClip = new ScreenClipClass();
			addChild(screenClip);
			getScreenChild("mcBunny").head.stop();
			TextField(getScreenChild("version")).text = "v" + ConsoleVersion.VERSION + ConsoleVersion.STAGE;
			TextField(getScreenChild("txtPriority")).restrict = "0-9";
			TextField(getScreenChild("txtPriority2")).restrict = "0-9";
			setUpButton("btnInterval", "Start interval");
			setUpButton("btnAdd1", "Add");
			setUpButton("btnAdd2", "Add");
			setUpButton("btnSpam", "Spam");
		}

		private function getScreenChild(n:String):Object
		{
			return screenClip.getChildByName(n);
		}

		private function setUpButton(btnname:String, t:String):void
		{
			var btn:MovieClip = getScreenChild(btnname) as MovieClip;
			btn.stop();
			btn.buttonMode = true;
			btn.mouseChildren = false;
			btn.txt.text = t;
			btn.addEventListener(MouseEvent.CLICK, onButtonClick);
			btn.addEventListener(MouseEvent.ROLL_OVER, onButtonEvent);
			btn.addEventListener(MouseEvent.ROLL_OUT, onButtonEvent);
		}

		private function onButtonEvent(e:MouseEvent):void
		{
			MovieClip(e.currentTarget).gotoAndStop(e.type == MouseEvent.ROLL_OVER ? "over" : "out");
		}

		private function onButtonClick(e:MouseEvent):void
		{
			switch (MovieClip(e.currentTarget).name)
			{
				case "btnAdd1":
					CLog.infoch(getScreenChild("txtLog").text, int(getScreenChild("txtPriority").text));
					break;
				case "btnAdd2":
					var ch:String = getScreenChild("txtChannel").text;
					var txt:String = getScreenChild("txtLog2").text;
					var lvl:int = int(getScreenChild("txtPriority2").text);
					CLog.infoch(ch, txt, lvl);
					break;
				case "btnInterval":
					if (_interval)
					{
						clearInterval(_interval);
						_interval = 0;
						getScreenChild("btnInterval").txt.text = "Start Interval";
					}
					else
					{
						_interval = setInterval(onIntervalEvent, 50);
						getScreenChild("btnInterval").txt.text = "Stop Interval";
					}
					break;
				case "btnSpam":
					spam();
					break;
			}
		}

		private function onIntervalEvent():void
		{
			CLog.infoch("test", "Repeative log _ " + getTimer(), 5, true);
		}

		private function spam():void
		{
			for (var i:int = 0; i < 100; i++)
			{
				var str:String = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.";
				var rand:int = Math.random() * 5;
				if (rand == 1)
				{
					str = "Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam,";
				}
				else if (rand == 2)
				{
					str = "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi";
				}
				else if (rand == 3)
				{
					str = "Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae.";
				}
				else if (rand == 4)
				{
					str = "Itaque earum rerum hic tenetur a sapiente delectus.";
				}
				else if (rand == 5)
				{
					str = "voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis";
				}
				_spamcount++;
				CLog.infoch("ch" + Math.round(Math.random() * 5), _spamcount + " " + str, Math.round(Math.random() * 4));
			}
		}

		private var _interval:uint;
	}
}
