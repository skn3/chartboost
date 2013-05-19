Strict

Import mojo
Import chartboost

'main program init
Function Main:Int()
	'create the app and set chartboost delegate
	New Demo
	Return 0
End

'demo app
Class Demo Extends App Implements ChartboostDelegate
	Field image:Image
	Field imageX:Float
	Field imageY:float
	Field imageAngle:Float
	Field imageScale:Float
	
	Field buttons := New List<Button>
	Field overButton:Button
	Field heldButton:Button
	
	'app events
	Method New()
		'Set Chartboost delegate to self
		ChartboostSetDelegate(Self)
		
		'start the session
		'this is demo session taken from the official chartboost example file
		#If TARGET = "ios"
		ChartboostStartSession("4f21c409cd1cb2fb7000001b","92e2de2fd7070327bdeb54c15a5295309c6fcd2d")
		#Elseif TARGET = "android"
		ChartboostStartSession("4f7b433509b6025804000002","dd2d41b69ac01b80f443f5b6cf06096d457f82bd")
		#end
	End
	
	Method OnCreate:Int()
		' --- setup the mojo app ---		
		'do some chartboost caching
		ChartboostCacheInterstitial("interstitial1")
		ChartboostCacheInterstitial("interstitial2")
		ChartboostCacheInterstitial("interstitial3")
		ChartboostCacheMoreApps()
		
		'set the apps update rate
		SetUpdateRate(60)
		
		'setup background image
		image = LoadImage("monkey.png",1,Image.MidHandle)
		imageX = DeviceWidth()/2
		imageY = DeviceHeight()/2
		imageScale = Float(DeviceHeight())/Float(image.Height())*1.25
		
		'setup buttons
		Local buttonSpacing := 10
		Local buttonY := buttonSpacing
		Local buttonHeight := 60
		Local buttonWidth := 240
		
		buttons.AddLast(New Button("show_interstitial1","Show Interstitial 1",buttonSpacing,buttonY,buttonWidth,buttonHeight))
		buttonY += buttonHeight + buttonSpacing
		
		buttons.AddLast(New Button("show_interstitial2","Show Interstitial 2",buttonSpacing,buttonY,buttonWidth,buttonHeight))
		buttonY += buttonHeight + buttonSpacing
		
		buttons.AddLast(New Button("show_interstitial3","Show Interstitial 3",buttonSpacing,buttonY,buttonWidth,buttonHeight))
		buttonY += buttonHeight + buttonSpacing
		
		buttons.AddLast(New Button("show_moreapps","Show More Apps",buttonSpacing,buttonY,buttonWidth,buttonHeight))
		buttonY += buttonHeight + buttonSpacing
		 
		'return something because of strict mode
		Return 0
	End
	
	Method OnUpdate:Int()
		' --- the app is updating ---
		'turn the image so we have form of movement on screen
		imageAngle += 0.3
		
		If KeyHit(KEY_ESCAPE)
			
		Endif
		
		'update the buttons
		Local pointerX:Float = TouchX(0)
		Local pointerY:Float = TouchY(0)
		
		'update which button we are hovering over
		overButton = Null
		For Local button := Eachin buttons
			If pointerX >= button.x And pointerY >= button.y And pointerX <= button.x + button.width And pointerY <= button.y + button.height
				overButton = button
			Endif
		Next

		If heldButton = Null
			'check for holding button
			If overButton And TouchHit(0)
				heldButton = overButton
			Endif
		Else
			'NOW check for release
			If TouchDown(0) = False
				'check for action
				If overButton = heldButton
					Select heldButton.id
						Case "show_interstitial1"
							ChartboostShowInterstitial("interstitial1")
						Case "show_interstitial2"
							ChartboostShowInterstitial("interstitial2")
						Case "show_interstitial3"
							ChartboostShowInterstitial("interstitial3")
						Case "show_moreapps"
							ChartboostShowMoreApps()
					End
				Endif
				
				'reset button states
				heldButton = Null
				overButton = Null
			Endif
		Endif
		

		'return something because of strict mode
		Return 0
	End
	
	Method OnRender:Int()
		' --- the app is rendering ---
		Cls(0,0,0)
		
		'draw the background
		DrawImage(image,imageX,imageY,imageAngle,imageScale,imageScale)
		
		'render teh buttons
		For Local button := Eachin buttons
			'border
			SetColor(255,255,255)
			DrawRect(button.x,button.y,button.width,button.height)
			
			'background
			If button = heldButton 
				If button = overButton
					SetColor(0,255,0)
				Else
					SetColor(0,0,0)
				Endif
			Else
				If heldButton = Null And button = overButton
					SetColor(64,64,64)
				Else
					SetColor(0,0,0)
				Endif
			Endif
			DrawRect(button.x+1,button.y+1,button.width-2,button.height-2)
			
			'text
			SetColor(255,255,255)
			DrawText(button.title,Int(button.x+(button.width/2)-(TextWidth(button.title)/2)),Int(button.y+(button.height/2)-(FontHeight()/2)))
		Next
		
		'return something because of strict mode
		Return 0
	End
	
	'chartboost delegate events
	Method shouldRequestInterstitial:Bool(location:String)
		Print "shouldRequestInterstitial:"+location
		Return true
	End
	
	Method shouldDisplayInterstitial:Bool(location:String)
		Print "shouldDisplayInterstitial:"+location
		Return true
	End
	
	Method didCacheInterstitial:Void(location:String)
		Print "didCacheInterstitial:"+location
	End
	
	Method didFailToLoadInterstitial:Void(location:String)
		Print "didFailToLoadInterstitial:"+location
	End
	
	Method didDismissInterstitial:Void(location:String)
		Print "didDismissInterstitial:"+location
		ChartboostCacheInterstitial(location)
	End
	
	Method didCloseInterstitial:Void(location:String)
		Print "didCloseInterstitial:"+location
	End
	
	Method didClickInterstitial:Void(location:String)
		Print "didClickInterstitial:"+location
	End
	
	Method didShowInterstitial:Void(location:String)
		Print "didShowInterstitial:"+location
	End

	Method shouldDisplayLoadingViewForMoreApps:Bool()
		Print "shouldDisplayLoadingViewForMoreApps"
		Return true
	End		

	Method shouldRequestMoreApps:Bool()
		Print "shouldRequestMoreApps"
		Return True
	End
		
	Method shouldDisplayMoreApps:Bool()
		Print "shouldDisplayMoreApps"
		Return True
	End
	
	Method didCacheMoreApps:Void()
		Print "didCacheMoreApps"
	End
		
	Method didFailToLoadMoreApps:Void()
		Print "didFailToLoadMoreApps"
	End
				
	Method didDismissMoreApps:Void()
		Print "didDismissMoreApps"
		ChartboostCacheMoreApps()
	End
	
	Method didCloseMoreApps:Void()
		Print "didCloseMoreApps"
	End
	
	Method didClickMoreApps:Void()
		Print "didClickMoreApps"
	End
	
	Method didShowMoreApps:Void()
		Print "didShowMoreApps"
	End
		
	Method shouldRequestInterstitialsInFirstSession:Bool()
		Print "shouldRequestInterstitialsInFirstSession"
		Return true
	End
End

Class Button
	Field id:String
	Field title:String
	Field x:Float
	Field y:Float
	Field width:Float
	Field height:Float
	
	Method New(id:String,title:String,x:Float,y:Float,width:Float,height:Float)
		Self.id = id
		Self.title = title
		Self.x = x
		Self.y = y
		Self.width = width
		Self.height = height
	End
End

