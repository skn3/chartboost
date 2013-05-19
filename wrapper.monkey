Strict

Import mojo
Import monkey.map
Import chartboost

'private interface
Private
Interface ChartboostWrapperInterface
	Method Update:Bool()
	Method Render:Void()
	
	Method SetDelegate:Void(delegate:ChartboostDelegate)
	Method StartSession:Bool(appId:String, appSignature:String)
	Method CacheAdvert:Void()
	Method CacheAdvert:Void(location:String)
	Method ShowAdvert:Void()
	Method ShowAdvert:Void(location:String)
	Method HasCachedAdvert:Bool()
	Method HasCachedAdvert:Bool(location:String)
	Method CacheMoreApps:Void()
	Method HasCachedMoreApps:Bool()
	Method ShowMoreApps:Void()
End
Public

'public class
#if TARGET = "ios" or TARGET = "android"
' --- this is for supported targets ---
	Class ChartboostWrapper Implements ChartboostWrapperInterface
		'interface methods
		Method Update:Bool(width:Int = 0, height:Int = 0)
			' --- do nothing ---
			'return to not block
			Return False
		End
		
		Method Render:Void(width:Int = 0, height:Int = 0)
			' --- do nothing ---
		End
		
		Method SetDelegate:Void(delegate:ChartboostDelegate)
			' --- pass onto chartboost ---
			ChartboostSetDelegate(delegate)
		End
		
		Method StartSession:Bool(appId:String, appSignature:String)
			' --- pass onto chartboost ---
			Return ChartboostStartSession(appId, appSignature)
		End
		
		Method CacheAdvert:Void()
			' --- pass onto chartboost ---
			ChartboostCacheInterstitial()
		End
		
		Method CacheAdvert:Void(location:String)
			' --- pass onto chartboost ---
			ChartboostCacheInterstitial(location)
		End
		
		Method ShowAdvert:Void()
			' --- pass onto chartboost ---
			ChartboostShowInterstitial()
		End
		
		Method ShowAdvert:Void(location:String)
			' --- pass onto chartboost ---
			ChartboostShowInterstitial(location)
		End
		
		Method HasCachedAdvert:Bool()
			' --- pass onto chartboost ---
			Return ChartboostHasCachedInterstitial()
		End
		
		Method HasCachedAdvert:Bool(location:String)
			' --- pass onto chartboost ---
			Return ChartboostHasCachedInterstitial(location)
		End
		
		Method CacheMoreApps:Void()
			' --- pass onto chartboost ---
			ChartboostCacheMoreApps()
		End
		
		Method HasCachedMoreApps:Bool()
			' --- pass onto chartboost ---
			Return ChartboostHasCachedMoreApps()
		End
		
		Method ShowMoreApps:Void()
			' --- pass onto chartboost ---
			ChartboostShowMoreApps()
		End
	End
#else
' --- this is for unsupported targets ---
	Class ChartboostWrapper Implements ChartboostWrapperInterface
		Private
		Const NONE:= 0
		Const INTERSTITIAL:= 1
		Const MOREAPPS:= 2
		
		Field delegate:ChartboostDelegate
		
		Field showing:Int = NONE
		Field showingLocation:String
		Field showingButtonHit:Bool = False
		
		Field cachedInterstitial:= New StringMap<IntObject>
		Field cachedMoreApps:Bool = False
		Public
		
		'internal
		Method RenderCloseButton:Void()
			' --- render a close button ---
			Local closeSize:Int = 75
			Local closeOffset:Int = 15
			Local closeX:Int = DeviceWidth() - closeSize - closeOffset
			Local closeY:Int = 0 + closeOffset
			
			'set basic state
			If showingButtonHit = False
				SetColor(255, 0, 0)
			Else
				SetColor(255, 255, 255)
			EndIf
				
			'render background
			DrawRect(closeX, closeY, closeSize, closeSize)
			
			'render decal
			SetColor(0,0,0)
			DrawLine(closeX, closeY, closeX + closeSize, closeY + closeSize)
			DrawLine(closeX + closeSize, closeY, closeX, closeY + closeSize)	
		End
		
		'interface methods
		Method Update:Bool()
			' --- do the update ---
			'update the close button
			showingButtonHit = False
			
			If showing <> NONE
				Local closeSize:Int = 75
				Local closeOffset:Int = 15
				Local closeX:Int = DeviceWidth() - closeSize - closeOffset
				Local closeY:Int = 0 + closeOffset
				
				If TouchX() > closeX And TouchX() < closeX + closeSize and TouchY() > closeY And TouchY() < closeY + closeSize and TouchHit()
					' a button hit!
					'inform delegate
					If delegate
						Select showing
							Case INTERSTITIAL
								delegate.didDismissInterstitial(showingLocation)
								delegate.didCloseInterstitial(showingLocation)
								
							Case MOREAPPS
								delegate.didDismissMoreApps()
								delegate.didCloseMoreApps()
						End Select
					EndIf
					
					'disable all showing
					showing = NONE
					
					'set touched color
					showingButtonHit = True
				EndIf
				
				'return that we should block
				Return True
			EndIf
			
			'return NOT block
			Return False
		End
		
		Method Render:Void()
			' --- do the render ---
			'render different modes
			Select showing
				Case INTERSTITIAL
					'rendering an advert
					Local padding:Int = 20
					
					'background
					SetColor(200, 200, 200)
					DrawRect(padding, padding, DeviceWidth() - padding * 2, DeviceHeight() - padding * 2)
					
					'advert
					padding = 30
					SetColor(0, 0, 0)
					DrawRect(padding, padding, DeviceWidth() - padding * 2, DeviceHeight() - padding * 2)
					SetColor(255, 255, 255)
					DrawText("Ad will show in this space!", 120, DeviceHeight() * 0.5)
					
					'render close button
					RenderCloseButton()
					
				Case MOREAPPS
					'rendering more apps
					Local padding:Int = 20
					Local rows:Int = 8
					Local rowHeight:Int = (DeviceHeight()) / rows
					Local startY:Int = 0
					
					'background
					SetColor(200, 200, 200)
					DrawRect(padding, padding, DeviceWidth() - padding * 2, DeviceHeight() - padding * 2)
					padding = 30
					SetColor(40, 40, 40)
					DrawRect(padding, padding, DeviceWidth() - padding * 2, DeviceHeight() - padding * 2)
					
					'apps
					For Local i:Int = 0 Until rows - 1
						SetColor(50, 50, 150)
						padding = 30
						DrawRect(padding, startY + padding + i * rowHeight, DeviceWidth() - padding * 2, DeviceHeight() - padding * 2)
						padding = 35
						SetColor(0, 0, 0)
						DrawRect(padding, startY + padding + i * rowHeight, DeviceWidth() - padding * 2, DeviceHeight() - padding * 2)
						SetColor(255, 255, 255)
						DrawText(i + ". Game will be listed here!", 120, startY + padding + 30 + i * rowHeight)
					Next
					
					'render close button
					RenderCloseButton()
			End Select
		End
		
		Method SetDelegate:Void(delegate:ChartboostDelegate)
			' --- save internal pointer to delegate ---
			Self.delegate = delegate
		End
		
		Method StartSession:Bool(appId:String, appSignature:String)
			' --- do nothing ---
			Return True
		End
		
		Method CacheAdvert:Void()
			' --- fake delegate messages ---
			'check with delegate first
			If delegate
				'make sure delegate allows this
				If delegate.shouldRequestInterstitial("") = False Return
				
				'ok it worked
				delegate.didCacheInterstitial("")
			EndIf
			
			'default action
			cachedInterstitial.Insert("", IntObject(1))
		End
		
		Method CacheAdvert:Void(location:String)
			' --- fake delegate messages ---
			'check with delegate first
			If delegate
				'make sure delegate allows this
				If delegate.shouldRequestInterstitial(location) = False Return
				
				'ok it worked
				delegate.didCacheInterstitial(location)
			EndIf
			
			'default action
			cachedInterstitial.Insert(location, IntObject(1))
		End
		
		Method ShowAdvert:Void()
			' --- show it ---
			'check we can show
			If showing <> NONE Return
			
			'check with delegate first
			If delegate and delegate.shouldDisplayInterstitial("") = False Return
			
			'check with delegate if we should request, if there is no cache
			If HasCachedAdvert() = False and delegate.shouldRequestInterstitial("") = False Return
			
			'default action
			'turn off cache
			cachedInterstitial.Insert("", IntObject(0))
			
			'set view mode
			showing = INTERSTITIAL
			showingLocation = ""
			
			'infrom delegate
			If delegate delegate.didShowInterstitial("")
		End
		
		Method ShowAdvert:Void(location:String)
			' --- show it ---
			'check we can show
			If showing <> NONE Return
			
			'check with delegate first
			If delegate and delegate.shouldDisplayInterstitial(location) = False Return
			
			'check with delegate if we should request, if there is no cache
			If HasCachedAdvert(location) = False and delegate.shouldRequestInterstitial(location) = False Return
			
			'default action
			'turn off cache
			cachedInterstitial.Insert(location, IntObject(0))
			
			'set view mode
			showing = INTERSTITIAL
			showingLocation = location
			
			'infrom delegate
			If delegate delegate.didShowInterstitial(location)
		End
		
		Method HasCachedAdvert:Bool()
			' --- use stored flag ---
			Local flag:= cachedInterstitial.ValueForKey("")
			Return flag And flag.value
		End
		
		Method HasCachedAdvert:Bool(location:String)
			' --- use stored flag ---
			Local flag:= cachedInterstitial.ValueForKey(location)
			Return flag And flag.value
		End
		
		Method CacheMoreApps:Void()
			' --- fake delegate messages ---
			'check with delegate first
			If delegate
				'make sure delegate allows this
				If delegate.shouldRequestMoreApps() = False return
				
				'ok it worked
				delegate.didCacheMoreApps()
			EndIf
			
			'default action
			cachedMoreApps = True
		End
		
		Method ShowMoreApps:Void()
			' --- show it ---
			'check we can show
			If showing <> NONE Return
			
			'check with delegate first
			If delegate and delegate.shouldDisplayMoreApps() = False Return
			
			'check with delegate if we should request, if there is no cache
			If cachedMoreApps = False and delegate.shouldRequestMoreApps() = False Return
			
			'default action
			'turn off cache
			cachedMoreApps = False
			
			'set view mode
			showing = MOREAPPS
			showingLocation = ""
			
			'infrom delegate
			If delegate delegate.didShowMoreApps()
		End
		
		Method HasCachedMoreApps:Bool()
			' --- use stored flag ---
			Return cachedMoreApps
		End
	End
#end