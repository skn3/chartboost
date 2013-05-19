import com.chartboost.sdk.Chartboost;
import com.chartboost.sdk.ChartboostDelegate;
import com.chartboost.sdk.Analytics.CBAnalytics;

//glue
class ChartboostGlue {
	public static String appId;
	public static String appSignature;
	public static ChartboostGlue instance;
	public Chartboost cb;
	
	//monkey callbacks
	public boolean shouldRequestInterstitial(String location) { return true; }
	public boolean shouldDisplayInterstitial(String location) { return true; }
	public void didCacheInterstitial(String location) {}
	public void didFailToLoadInterstitial(String location) {}
	public void didDismissInterstitial(String location) {}
	public void didCloseInterstitial(String location) {}
	public void didClickInterstitial(String location) {}
	public void didShowInterstitial(String location) {}
	public boolean shouldDisplayLoadingViewForMoreApps() { return true; }
	public boolean shouldRequestMoreApps() { return true; }
	public boolean shouldDisplayMoreApps() { return true; }
	public void didCacheMoreApps() {}
	public void didFailToLoadMoreApps() {}
	public void didDismissMoreApps() {}
	public void didCloseMoreApps() {}
	public void didClickMoreApps() {}
	public void didShowMoreApps() {}
	public boolean shouldRequestInterstitialsInFirstSession() { return true; }

	//delegate glue
	private ChartboostDelegate chartboostDelegateGlue = new ChartboostDelegate() {
		@Override
		public boolean shouldRequestInterstitial(String location) { return ChartboostGlue.instance.shouldRequestInterstitial(location); }
		
		@Override
		public boolean shouldDisplayInterstitial(String location) { return ChartboostGlue.instance.shouldDisplayInterstitial(location); }
		
		@Override
		public void didCacheInterstitial(String location) { ChartboostGlue.instance.didCacheInterstitial(location); }
		
		@Override
		public void didFailToLoadInterstitial(String location) { ChartboostGlue.instance.didFailToLoadInterstitial(location); }
		
		@Override
		public void didDismissInterstitial(String location) { ChartboostGlue.instance.didDismissInterstitial(location); }
		
		@Override
		public void didCloseInterstitial(String location) { ChartboostGlue.instance.didCloseInterstitial(location); }
		
		@Override
		public void didClickInterstitial(String location) { ChartboostGlue.instance.didClickInterstitial(location); }
		
		@Override
		public void didShowInterstitial(String location) { ChartboostGlue.instance.didShowInterstitial(location); }
		
		@Override
		public boolean shouldDisplayLoadingViewForMoreApps() { return ChartboostGlue.instance.shouldDisplayLoadingViewForMoreApps(); }

		@Override
		public boolean shouldRequestMoreApps() { return ChartboostGlue.instance.shouldRequestMoreApps(); }
		
		@Override
		public boolean shouldDisplayMoreApps() { return ChartboostGlue.instance.shouldDisplayMoreApps(); }
		
		@Override
		public void didCacheMoreApps() { ChartboostGlue.instance.didCacheMoreApps(); }
				
		@Override
		public void didFailToLoadMoreApps() { ChartboostGlue.instance.didFailToLoadMoreApps(); }
		
		@Override
		public void didDismissMoreApps() { ChartboostGlue.instance.didDismissMoreApps(); }
		
		@Override
		public void didCloseMoreApps() { ChartboostGlue.instance.didCloseMoreApps(); }
		
		@Override
		public void didClickMoreApps() { ChartboostGlue.instance.didClickMoreApps(); }
		
		@Override
		public void didShowMoreApps() { ChartboostGlue.instance.didShowMoreApps(); }
		
		@Override
		public boolean shouldRequestInterstitialsInFirstSession() { return ChartboostGlue.instance.shouldRequestInterstitialsInFirstSession(); }
	};
	
	//api
	public void StartSession(String appId,String appSignature) {
		// --- start a session with chartboost ---
		//store global pointer to glue instance
		this.instance = this;
	
		//get shared chartboost object
		this.cb = Chartboost.sharedChartboost();
		
		//setup chartboost
		ChartboostGlue.instance.appId = appId;
		ChartboostGlue.instance.appSignature = appSignature;
		
		//finalise setup
		this.cb.onCreate(BBAndroidGame.AndroidGame().GetActivity(),ChartboostGlue.instance.appId,ChartboostGlue.instance.appSignature,ChartboostGlue.instance.chartboostDelegateGlue);
		this.cb.startSession();
	}

	public void CacheInterstitial() {
		// --- cache interstitial at defaul location ---
		//cache it
		this.cb.cacheInterstitial();
	}

	public void CacheInterstitial(String location) {
		// --- cache interstitial at locationd location ---
		//cache it
		this.cb.cacheInterstitial(location);
	}

	public void ShowInterstitial() {
		// --- show a interstitial ---
		//show it!
		this.cb.showInterstitial();
	}

	public void ShowInterstitial(String location) {
		// --- show a locationd interstitial ---
		//show it!
		this.cb.showInterstitial(location);
	}

	public boolean HasCachedInterstitial() {
		// --- check if has default cache ---
		//return it!
		return this.cb.hasCachedInterstitial();
	}

	public boolean HasCachedInterstitial(String location) {
		// --- check if has locationd cache ---
		//return it!
		return this.cb.hasCachedInterstitial(location);
	}

	public void CacheMoreApps() {
		// --- cache more apps page ---
		//cache it
		this.cb.cacheMoreApps();
	}

	public boolean HasCachedMoreApps() {
		// --- check if has apps cache ---
		//return it!
		return this.cb.hasCachedMoreApps();
	}
	
	public void ShowMoreApps() {
		// --- show more apps page ---
		//show it
		this.cb.showMoreApps();
	}
};