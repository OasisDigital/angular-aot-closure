/** @externs */
// Workaround for #11119
// TODO(alexeagle): these externs ought to be distributed with Angular.
/**
 * @externs
 * @suppress {duplicate}
 */
// NOTE: generated by tsickle, do not edit.

/** @record @struct */
function BrowserNodeGlobal() {}
 /** @type {?} */
BrowserNodeGlobal.prototype.getAngularTestability;
 /** @type {?} */
BrowserNodeGlobal.prototype.getAllAngularTestabilities;
 /** @type {?} */
BrowserNodeGlobal.prototype.getAllAngularRootElements;
 /** @type {?} */
BrowserNodeGlobal.prototype.frameworkStabilizers;

/**
 * @param {?} condition
 * @return {?}
 */
BrowserNodeGlobal.prototype.assert = function(condition) {};

/** @record @struct */
function PublicTestability() {}

/**
 * @return {?}
 */
PublicTestability.prototype.isStable = function() {};

/**
 * @param {?} callback
 * @return {?}
 */
PublicTestability.prototype.whenStable = function(callback) {};

/**
 * @param {?} using
 * @param {?} provider
 * @param {?} exactMatch
 * @return {?}
 */
PublicTestability.prototype.findProviders = function(using, provider, exactMatch) {};
