﻿/*	The MIT License	 	Copyright (c) 2012 Robert M. Hall, II, Inc. dba Feasible Impossibilities - http://www.impossibilities.com/	 	Permission is hereby granted, free of charge, to any person obtaining a copy	of this software and associated documentation files (the "Software"), to deal	in the Software without restriction, including without limitation the rights	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell	copies of the Software, and to permit persons to whom the Software is	furnished to do so, subject to the following conditions:	 	The above copyright notice and this permission notice shall be included in	all copies or substantial portions of the Software.	 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN	THE SOFTWARE.*/package com.impossibilities.leapmotion {	import flash.display.Sprite;	import flash.display.MovieClip;	import flash.events.*;	import flash.display.Stage;	import flash.display.StageAlign;	import flash.display.StageScaleMode;	import com.impossibilities.leapmotion.DelayedFunctionQueue;	import com.impossibilities.leapmotion.CustomSocket;	public class LeapCore extends Sprite	{		private var leapINIT:Boolean = false;				private var cmdQUEUE:CommandQueue = new CommandQueue();		private var socket:CustomSocket; 				private var cursorIcon1:cursor = new cursor();		private var cursorIcon2:cursor = new cursor();		private var cursorIcon3:cursor = new cursor();		private var cursorIcon4:cursor = new cursor();		private var cursorIcon5:cursor = new cursor();		public function LeapCore()		{			stage.align = StageAlign.TOP_LEFT; 			//stage.scaleMode = StageScaleMode.NO_SCALE;			initComm();			cursorIcon1.visible=false;			cursorIcon2.visible=false;			cursorIcon3.visible=false;			cursorIcon4.visible=false;			cursorIcon5.visible=false;			addChild(cursorIcon1);			addChild(cursorIcon2);			addChild(cursorIcon3);			addChild(cursorIcon4);			addChild(cursorIcon5);		}				private function initComm():void		{			if (! leapINIT)			{				var netWorkType:String = detectNetworkType();				if (netWorkType)				{					leapINIT = true;					socket = new CustomSocket(this,"127.0.0.1",8888);					//cmdQUEUE.add(socket.sendCommand, "!1MVLQSTN");				}			}		}				private function networkState(event:Event):void		{			trace(event);		}		private function detectNetworkType():String		{			return "ETHER";			/*			var returnVal:String;			if (NetworkInfo.isSupported)			{				var interfaces:Vector.<NetworkInterface >  = NetworkInfo.networkInfo.findInterfaces();				addEventListener(Event.NETWORK_CHANGE, networkState);				for (var i:uint = 0; i < interfaces.length; i++)				{					trace(interfaces[i].name);					if (interfaces[i].name.toLowerCase() == "wifi" && interfaces[i].active)					{						trace("WiFi connection enabled");						returnVal = "WIFI";						break;					}					else if (interfaces[i].name.toLowerCase() == "mobile" && interfaces[i].active)					{						trace("Mobile data connection enabled");						returnVal = "MOBILE";						break;					}					else if (interfaces[i].name.toLowerCase().substr(0,2) == "en" && interfaces[i].active)					{						// for desktop						trace("Local Ethernet data connection enabled");						returnVal = "ETHER";						break;					}				}			}			else			{				returnVal = "NOGO";			}			return returnVal;			*/		}						private var posZ:Number = 0;		private var posX:Number = 0;		private var posY:Number = 0;				private var fingerVector:Vector.<uint>;		private var palmVector:Vector.<uint>;// = Vector.<Type>(array);		private var fingerDataArray:Array = [];		private var fingerInfoArray:Array = [];		private var palmDataArray:Array = [];		private var fingerCount:uint = 0;		private var fingerInfo:String = ""		private var fingersArray:Array = [];				public function sendData(vals:String):void {			//trace("*** TELEMETRY DATA:\n"+telemetry);			//trace("FINGERS : "+telemetry[0]);			//trace("POS_X   : "+telemetry[1]);			//trace("POS_Y   : "+telemetry[2]);			//trace("POS_Z   : "+telemetry[3]);				fingerCount = 0;		fingerInfo = ""					//trace("VALS:"+vals);			if(vals != null && vals != "CONNECTED") {				fingerDataArray = vals.split("#");				fingerCount = Number(fingerDataArray[0]);				if(fingerCount>5){					fingerCount=5;				}								//5,-8.58510455561,206.245456241,-42.0984886374,11.4168945588,406.619402089,-82.524733822,-22.7160940731,612.136539461,-108.374452533,29.1363346974,794.570849182,-131.623435061,-35.701492041,942.702515568,-97.9161228576,^10.2695762213,162.832771033,52.7562896756^-38.2406126956,6.08570686646,-19.4675379572^78.2825409441-5.21462536948,203.858552916,-45.3809070298,18.8339571853,401.425844369,-88.7575146358,-13.028792534,604.504962745,-118.28075742,42.4034455011,783.29213245,-143.767339298,-19.8631047253,929.102048845,-113.68579203,^11.993962586,160.404741668,50.8087079131^-37.1891474334,6.57827520188,-18.8819361669^77.48304628021				//trace("TOTAL FINGERS: "+fingerCount);								if(fingerCount>=1) {					for(var i = 1; i<fingerCount+1; i++) {						// fingersArray contains all the x,y,z of fingertips						fingersArray[i-1] = fingerDataArray[i];						//trace("FINGER "+i+" : "+fingerDataArray[i]);					}					if(fingerDataArray[fingerCount+1] != undefined) {						palmDataArray = fingerDataArray[fingerCount+1].split("^");					}				} else {					if(fingerDataArray[1] != undefined) {						palmDataArray = fingerDataArray[1].split("^");					}				}								for( i = 0; i<5; i++) {						this["cursorIcon"+(i+1)].visible=false;				}								var tipArray:Array =[];				if(fingerCount>0) {					trace("fingercount: "+	fingerCount);					for( i = 0; i<fingerCount; i++) {						posX =0;						posY =0;						posZ =0;						this["cursorIcon"+(i+1)].visible=true;						tipArray = fingersArray[i].split(",");												posX = (parseInt(tipArray[0]));						posY = (parseInt(tipArray[1]));						posZ = (parseInt(tipArray[2])/20*1)+4;												if(posZ<.5) {							posZ=.5;						}												this["cursorIcon"+(i+1)].x=stage.stageWidth/2-(posX/stage.stageWidth)*-(stage.stageWidth*2);						this["cursorIcon"+(i+1)].y=470-(posY)*1.25; //470												//this["cursorIcon"+(i+1)].x=posX;						//this["cursorIcon"+(i+1)].y=posY; //470												this["cursorIcon"+(i+1)].scaleX=posZ;						this["cursorIcon"+(i+1)].scaleY=posZ;						//trace("FINGER "+i+": "+this["cursorIcon"+(i+1)].x,this["cursorIcon"+(i+1)].y);					}				}								/*				if(fingerCount<5 && fingerCount !=0) {					for( i = fingerCount; i<5; i++) {						this["cursorIcon"+(i+1)].visible=false;					}				}				*/								//fingerVector = Vector.<uint>(fingerDataArray);				//trace(fingerDataArray);							}											}		// -160 - 160	// 30-470	}}