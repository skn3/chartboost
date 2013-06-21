Strict

Import mojo
Import wrapper

'these are demo identities
#If TARGET = "ios"
	Const APP_ID:= "4f21c409cd1cb2fb7000001b"
	Const APP_SIGNATURE:= "92e2de2fd7070327bdeb54c15a5295309c6fcd2d"
#Elseif TARGET = "android"
	Const APP_ID:= "4f7b433509b6025804000002"
	Const APP_SIGNATURE:= "dd2d41b69ac01b80f443f5b6cf06096d457f82bd"
#else
	Const APP_ID:= "FAKE_APP_ID"
	Const APP_SIGNATURE:= "FAKE_APP_SIGNATURE"
#end

'main program init
Function Main:Int()
	'we should start the chartboost session in main ALWAYS!
	'it is also fine to place this in your apps New constructor
	'(see below)
	New MyApp
	
	Return 0
End

'demo app
Class MyApp Extends App Implements ChartboostDelegate
	Field wrapper:= New ChartboostWrapper
	
	'constructor/destructor
	Method New()
		'setup chartboost through the wrapper
		wrapper.SetDelegate(Self)
		wrapper.StartSession(APP_ID, APP_SIGNATURE)
	End
	
	'app events
	Method OnCreate:Int()
		' --- setup app ---
		SetUpdateRate(60)
		
		wrapper.CacheAdvert()
		
		'return nothing
		Return 0
	End
	
	Method OnUpdate:Int()
		' --- update app ---
		'update chartboost (will be ignored on ios or android)
		'we look for return FALSE which means teh wrapper isnt active and our program can operate normall
		If wrapper.Update() = False
			'process normal app operation here
			'check for hitting various bits
			If TouchHit()
				If TouchY() < DeviceHeight() * 0.5
					wrapper.ShowAdvert()
				Else If TouchY() > DeviceHeight() * 0.5
					wrapper.ShowMoreApps()
				End
			EndIf
		EndIf
		
		'return nothing
		Return 0
	End
	
	Method OnRender:Int()
		' --- render app ---
		Cls()
		
		'render app
		SetColor(100, 200, 75)
		DrawRect(0, DeviceHeight() * 0.5 - 5, DeviceWidth(), 10)
		
		SetColor(255, 0, 0)
		DrawText("Touch TopPart of Screen to activate Fullscreen Ad", 120, DeviceHeight() * 0.25)
		DrawText("Touch BottomPart of Screen to activate More Screen", 120, DeviceHeight() * 0.75)
		
		'render chartboost (will be ignored on ios or android)
		wrapper.Render()
		
		'return nothing
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