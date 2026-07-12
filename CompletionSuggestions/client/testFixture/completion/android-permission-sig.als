module androidPermisison

/**
	* A model of the Android Permission Protocol
	*
	* Authors: Hamid Bagheri & Eunsuk Kang (hbagheri, eskang@mit.edu)
	*/

open util/relation as rel
open util/ordering[Time] as to

sig Time {}
abstract sig Name {}
sig AppName, PermName extends Name {}
sig URI {}	// content URI
sig AppSignature {}

abstract sig Permission {}
// URI permission for content providers
abstract sig URIPermission extends Permission {
	uri : URI
}
// component permission
abstract sig CompPermission extends Permission {
	name: PermName,
	protectionLevel: ProtectionLevel
}

abstract sig ProtectionLevel {}
one sig Normal, Dangerous, Signature extends ProtectionLevel {}

one sig Device {
	builtinPerms : set CompPermission,
	apps: Application -> Time,
	// permissions that are currently active on the device
	customPerms: CompPermission -> Time
}

fact Device_facts {
	all d : Device | all t : Time | d.customPerms.t in (d.apps.t).declaredPerms
}

sig Application {
	name : AppName,
	signature : AppSignature,
    // set of permissions that the app declares in the app manifest
	// (also called custom permissions)
	declaredPerms: set CompPermission,
    // set of permissions that the app uses. It is modeled after the
	// <uses-permission> tag in the app manifest
	// http://developer.android.com/guide/topics/manifest/uses-permission-element.html
	usesPerms: set PermName,
	// permissions that are granted to this app at each time
	grantedPerms: Permission -> Time,
	// permission that other apps need to have to interact with this app
	guard : lone PermName,
	components: set Component
}

fact Application_facts {
	all a : Application | {
		a.guard in (a.declaredPerms + Device.builtinPerms).name
		no p1, p2 : a.declaredPerms |
			p1.name = p2.name and
			p1.protectionLevel != p2.protectionLevel
	}
}

abstract sig Component {
	app: one Application,
	// a component may have any number of filters,
	// each one describing a different component's capability
	intentFilter: set IntentFilter,
	// permission that other apps need to have to access this component
	guard: lone PermName,
	// (c, t) is a tuple in causes if "this" has (directly or indirectly) caused a call to "c"
	// in the history leading up to "t"
	causes : Component -> Time
}

fact Component_facts {
	all c : Component | {
		c.guard in (c.app.declaredPerms + Device.builtinPerms).name
		c in c.app.components
	}
}

abstract sig Activity extends Component {}
abstract sig Service extends Component {}
// broadcast receiver
abstract sig BroadcastReceiver extends Component {}

// Path in a content provider
// Represents a table in the database of the provider
abstract sig ContentPath extends Component {
	provider : ContentProvider
}

fact ContentPath_facts {
	all cp : ContentPath | no cp.guard + cp.causes.Time + cp.intentFilter
}

// content provider
abstract sig ContentProvider extends Component {
	paths : URI -> lone ContentPath,
	protectedPaths : set URI,	// paths that are protected with URI permission
	privatePaths: set URI		// paths that are private and should not be shared with other apps
}

fact ContentProvider_facts {
	all pr : ContentProvider | {
		pr.protectedPaths + pr.privatePaths in pr.paths.ContentPath
		pr.paths[URI].@app = pr.app
		pr.paths[URI].provider = pr
	}
}

// To inform the system which implicit intents they can handle,
// components can have one or more intent filters.
sig IntentFilter {
	// A filter may list more than one action
	// The list cannot be empty
	actions: some Action,
	dataType: some DataType,
	dataScheme: some DataScheme,
	// For an intent to pass the category test, every category
	// in the Intent object must match a category in the filter.
	// The filter can list additional categories,
	//but it cannot omit any that are in the intent.
	categories: set Category
}

// Elements of an Intent:
// Three attributes of an Intent are checked  when tested against a filter:
// Action, Category, and Data
// Action is a Name that names the general action to be performed.
abstract sig Action {}

// Category is a Name containing additional information about the kind of
// component that should handle the intent
abstract sig Category {}

// The type of data supplied is generally dictated by the intent's action.
// For example, if the action is ACTION_EDIT, the data should contain
// the URI of the document to edit.
abstract sig DataType {}
abstract sig DataScheme {}

sig Intent {
	sender: one Component,
	component: lone Component,
	action: one Action,
	dataType: one DataType,
	dataScheme: one DataScheme,
	categories: set Category
}
