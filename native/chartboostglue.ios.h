#import "Chartboost.h"

//delegate glue
@interface ChartboostDelegateGlue : NSObject <ChartboostDelegate> {
}

-(BOOL) shouldRequestInterstitial:(NSString *)location;
-(BOOL) shouldDisplayInterstitial:(NSString *)location;
-(void) didCacheInterstitial:(NSString *)location;
-(void) didFailToLoadInterstitial:(NSString *)location;
-(void) didDismissInterstitial:(NSString *)location;
-(void) didCloseInterstitial:(NSString *)location;
-(void) didClickInterstitial:(NSString *)location;
-(void) didShowInterstitial:(NSString *)location;
-(BOOL) shouldDisplayLoadingViewForMoreApps;
-(BOOL) shouldRequestMoreApps;
-(BOOL) shouldDisplayMoreApps;
-(void) didCacheMoreApps;
-(void) didFailToLoadMoreApps;
-(void) didDismissMoreApps;
-(void) didCloseMoreApps;
-(void) didClickMoreApps;
-(void) didShowMoreApps;
-(BOOL) shouldRequestInterstitialsInFirstSession;
@end

//glue
class ChartboostGlue : public Object {
public:
	static ChartboostGlue *instance;
	
	//monkey work arounds
	bool _hasCachedMoreApps;
	
	//monkey callbacks
	virtual bool shouldRequestInterstitial(String location);
	virtual bool shouldDisplayInterstitial(String location);
	virtual void didCacheInterstitial(String location);
	virtual void didFailToLoadInterstitial(String location);
	virtual void didDismissInterstitial(String location);
	virtual void didCloseInterstitial(String location);
	virtual void didClickInterstitial(String location);
	virtual void didShowInterstitial(String location);
	virtual bool shouldDisplayLoadingViewForMoreApps();
	virtual bool shouldRequestMoreApps();
	virtual bool shouldDisplayMoreApps();
	virtual void didCacheMoreApps();
	virtual void didFailToLoadMoreApps();
	virtual void didDismissMoreApps();
	virtual void didCloseMoreApps();
	virtual void didClickMoreApps();
	virtual void didShowMoreApps();
	virtual bool shouldRequestInterstitialsInFirstSession();

	//api
	void StartSession(String appId,String appSignature);
	void CacheInterstitial();
	void CacheInterstitial(String location);
	void ShowInterstitial();
	void ShowInterstitial(String location);
	bool HasCachedInterstitial();
	bool HasCachedInterstitial(String location);
	void CacheMoreApps();
	bool HasCachedMoreApps();
	void ShowMoreApps();
};