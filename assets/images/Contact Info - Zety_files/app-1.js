if (navigator && !navigator.cookieEnabled) {
    window.location = '/?forceRedirect=CookiesDisabled';
}
var RDL = window.RDL || {};
var platFormJsUrl = 'https://apis.google.com/js/platform.js';
var packageLoaded;
var createGuestUserTimer;
var generateClaimsTimer;
var isAccUserCalled = false;
var isCreateGuestInProgress = false;
var postGuestCreatedCalled = false;
var claimsPromise = undefined;
var configPromise = undefined;
var resourcePromise = undefined;
var featurePromise = undefined;
var triggerHIWStage = false;
var isRedirectDone = false;
var userUIdFrmExtrnlSite = '';
var postGuestUserTimer;
var configLoaded = false;
var resourceLoaded = false;
var reqAccountsGuestUserCreation = false;
var isHandlePostPageLoadCalled = false;
window.AuthCookieName = "Auth";
var environment = window.location.host.split('.')[0].replace('-builder', '').replace('-app', '');
var $html = document.documentElement;
var isLocal = window.location.host.indexOf('local') > -1;
var isPerf = window.location.host.indexOf('perf.') > -1;
var isProd = window.location.host.indexOf('www.') > -1;
var ttcEarlyExpJobTitleRect;
var slideTrustSnackIndex = 0;
RDL.logMessage = " Referrer : " + document.referrer + "\n- Location : " + window.location.href;
RDL.purgedDocHandled = false;
RDL.isPurgingDocument = false;
RDL.jobtitlewithspellcheck = false;
RDL.multiColSectionSkins = [];
RDL.useDefaultPageSizeA4 = false;
RDL.UserExperiments = {};
RDL.builderVersion = "rb wizard";
RDL.previousDocuments = [];
RDL.avoidLoggedinCss = false;
RDL.showHeader = true;
RDL.prevDocTabVisible = false;
RDL.Localization = "";
RDL.Definition_Tips = [];
RDL.strategyId = 14;
RDL.isMPR = false;
RDL.isLCA = false;
RDL.isMPCL = false;
RDL.isMPROrMPCL = false;
RDL.isZTY = false;
RDL.isHLM = false;
RDL.isJBH = false;
RDL.isWhiteLabel = false;
RDL.mapsClientKey = "gme-boldna";
RDL.isloggedIn = false;
RDL.gatriggeredFor = "";
RDL.EnterBuildertriggered = false;
RDL.pageLoaded = false;
RDL.applyCardCss = false;
RDL.UserConsent = true;
RDL.hideEditForMultiParaSections = true;
var PushnamiID = '5d7969905d28b600124cb99b';
RDL.ExpLayerID = "";
RDL.QA_IDENTIFIER = "qa";
RDL.Current_Session_Date = new Date();
RDL.SESSION_STALE_TIMEOUT_DAYS = 7;
RDL.handleMonogramURLS = function () {
    if (RDL.monogram) {
        RDL.monogram.monogramList.forEach(function (elem, i) {
            RDL.monogram.monogramList[i].id = elem.url
            RDL.monogram.monogramList[i].url = RDL.configServiceBlobUrl + "dynamicsvg/" + elem.url;
        });
    }
    else {
        RDL.monogram = { isMonogram: false, monogramList: [], monogramSkins: [], monogramSkinsName: [] }
    }
}
window.getSkinHtmlPath = function () {
    var skinPath = RDL.configServiceBlobUrl;
    return skinPath;
}
var configuration = (function () {
    var modifyCountryWiseLocalization = function (data, configObj) {
        var countryCode = getCountryCode();
        RDL.isCountrySA_AE_IN = countryCode && ("SA,AE,IN").indexOf(countryCode) > -1;
        if (countryCode && data[countryCode]) {
            Object.assign(RDL.Localization, data[countryCode]);
        }
        if (configObj && countryCode) {
            var countryConfigs;
            if (configObj.country && configObj.country[countryCode]) {
                countryConfigs = configObj.country[countryCode];
            } else if (RDL.isEUFlowCountry(configObj.EUCountryCodes)) {
                countryConfigs = configObj.country['EU'];
            }

            if (countryConfigs && countryConfigs.localizationToBeUsed && countryConfigs.localizationToBeUsed.length) {
                countryConfigs.localizationToBeUsed.forEach(function (el) {
                    Object.assign(RDL.Localization, data[el]);
                });
            }
        }
    }
    var modifyCountryWiseConfig = function (data) {
        var countryCode = getCountryCode();
        if (countryCode) {
            var countryConfigs;
            if (data.country && data.country[countryCode]) {
                countryConfigs = data.country[countryCode];
            } else if (RDL.isEUFlowCountry(data.EUCountryCodes)) {
                countryConfigs = data.country['EU'];
            }

            if (RDL.ArrayFeatureSet && countryConfigs && countryConfigs.featureToBeUpdated) {
                var featureToBeUpdated = Object.keys(countryConfigs.featureToBeUpdated);
                if (featureToBeUpdated.length) {
                    RDL.ArrayFeatureSet.forEach(function (featureSet) {
                        featureToBeUpdated.forEach(function (newFeature) {
                            if (newFeature == featureSet.featureCD) {
                                featureSet.isActive = countryConfigs.featureToBeUpdated[newFeature];
                            }
                        });
                    });
                }
            }
            if (countryConfigs && countryConfigs.flagsToBeUpdated) {
                Object.assign(RDL, countryConfigs.flagsToBeUpdated);
            }

            if (countryConfigs && countryConfigs.skinsToAddOrUpdate) {
                countryConfigs.skinsToAddOrUpdate.forEach(function (el) {
                    var skinIndex = -1;
                    if (RDL.useContentBlobForSVGs) {
                        el.imageURL = RDL.Paths.ResourcePath + el.blobURL;
                        el.blobURL = RDL.Paths.ResourcePath + el.blobURL;
                        el.htmlURL = getSkinHtmlPath() + el.skinCD + ".htm";
                    }
                    else {
                        el.imageURL = data.externalLinks.configSvcBlobUrl + "SkinImages/" + el.skinCD.toLowerCase() + ".svg";
                        el.blobURL = data.externalLinks.configSvcBlobUrl + "SkinImages/" + el.skinCD.toLowerCase() + ".svg";
                        el.htmlURL = getSkinHtmlPath() + el.skinCD + ".htm";
                    }
                    RDL.skins.forEach(function (skn, index) {
                        if (skn.id == el.id) {
                            skinIndex = index;
                        }
                    });
                    if (skinIndex > -1) {
                        RDL.skins[skinIndex] = el;
                    }
                    else if (el.insertIndex && el.insertIndex > -1) {
                        RDL.skins.splice(el.insertIndex, 0, el);
                    }
                    else {
                        RDL.skins.push(el);
                    }
                });
                if (!RDL.SkinFromPortal) {
                    setPortalSkin();
                }
            }
            if (countryConfigs && countryConfigs.skinsToRemove) {
                countryConfigs.skinsToRemove.forEach(function (el) {
                    var skinIndex = -1;
                    RDL.skins.forEach(function (skn, index) {
                        if (skn.id == el) {
                            skinIndex = index;
                        }
                    });
                    if (skinIndex > -1) {
                        RDL.skins.splice(skinIndex, 1)
                    }
                });
            }
        }
    }
    var getCountryCode = function () {
        var countryCode = "";
        if (RDL.countryDetails && RDL.countryDetails.countryCode) {
            countryCode = RDL.countryDetails.countryCode;
        }
        return countryCode;
    }
    return {
        "modifyCountryWiseLocalization": modifyCountryWiseLocalization,
        "modifyCountryWiseConfig": modifyCountryWiseConfig
    }
}());
RDL.accountsNameSpace = function () {
    var nameSpace = {};
    if (typeof LOGIN == "object")
        nameSpace = LOGIN;
    else
        nameSpace = BOLD;
    return nameSpace
}
RDL.getPortalInfo = function () {
    var portalCd = null;
    var portalUrl = null;
    var rewriteBlobContent = false;
    var rewriteBuilderApi = false;
    portalCd = RDL.portalCd;
    cookieDomain = "." + RDL.domain;
    switch (RDL.portalCd) {
        case "lca":
            basePath = "/build-resume";
            defaultSkin = "CBG1";
            portalId = "3";
            templateId = "-3";
            useAccountsJs = true;
            RDL.isLCA = true;
            RDL.cultureCD = "en-US";
            rewriteBuilderApi = true;
            rewriteBlobContent = true;
            break;
        case "mpr":
            basePath = "/build-resume";
            defaultSkin = "CBG1";
            portalId = "16";
            templateId = "-3";
            useAccountsJs = true;
            RDL.isMPR = true;
            RDL.isMPROrMPCL = true;
            RDL.cultureCD = "en-US";
            rewriteBlobContent = true;
            rewriteBuilderApi = true;
            break;
        case "muk":
            basePath = "/build-cv";
            defaultSkin = "CBA1";
            portalId = "29";
            templateId = "1662";
            useAccountsJs = true;
            RDL.cultureCD = "en-GB";
            RDL.isMPUK = true;
            RDL.enableResumeCheck = false;
            rewriteBlobContent = true;
            rewriteBuilderApi = true;
            break;
        case "mfr":
            basePath = "/creer-cv";
            defaultSkin = "CBA1";
            portalId = "32";
            templateId = "-5";
            useAccountsJs = true;
            RDL.cultureCD = "fr-FR";
            rewriteBlobContent = true;
            rewriteBuilderApi = true;
            break;
        case "mes":
            basePath = "/crear-cv";
            defaultSkin = "CBA1";
            portalId = "33";
            templateId = "1660";
            useAccountsJs = true;
            RDL.cultureCD = "es-ES";
            rewriteBlobContent = true;
            rewriteBuilderApi = true;
            break;
        case "mbr":
            basePath = "/criar-curriculo";
            defaultSkin = "CBA1";
            portalId = "62";
            templateId = "-6";
            useAccountsJs = true;
            RDL.cultureCD = "pt-BR";
            rewriteBlobContent = true;
            rewriteBuilderApi = true;
            break;
        case "mit":
            basePath = "/crea-curriculum";
            defaultSkin = "CBA1";
            portalId = "37";
            templateId = "-7";
            useAccountsJs = true;
            RDL.cultureCD = "it-IT";
            rewriteBlobContent = true;
            rewriteBuilderApi = true;
            break;
        case "mpc":
            basePath = "/build-resume";
            defaultSkin = "CBG1";
            portalId = "20";
            templateId = "-3";
            useAccountsJs = false;
            RDL.isMPCL = true;
            RDL.isMPROrMPCL = true;
            RDL.cultureCD = "en-US";
            rewriteBlobContent = true;
            rewriteBuilderApi = true;
            break;
        case "zty":
            basePath = "/resume";
            defaultSkin = "SRZ1";
            portalId = "84";
            templateId = "-3";
            useAccountsJs = true;
            RDL.isZTY = true;
            RDL.cultureCD = "en-US";
            rewriteBlobContent = true;
            rewriteBuilderApi = true;
            break;
        case "zfr":
            basePath = "/cv";
            defaultSkin = "SRZ1";
            portalId = "88";
            templateId = "1719";
            useAccountsJs = true;
            RDL.isZFR = true;
            RDL.cultureCD = "fr-FR";
            rewriteBlobContent = true;
            rewriteBuilderApi = true;
            break;
        case "hlm":
            basePath = "/build-resume";
            defaultSkin = "CBG1";
            portalId = "67";
            templateId = "-3";
            useAccountsJs = true;
            RDL.isHLM = true;
            RDL.cultureCD = "en-US";
            RDL.isWhiteLabel = false;
            rewriteBlobContent = true;
            rewriteBuilderApi = true;
            break;
        case "jbh":
            basePath = "/build-resume";
            defaultSkin = "CBG1";
            portalId = "78";
            templateId = "-3";
            useAccountsJs = true;
            RDL.isJBH = true;
            RDL.isWhiteLabel = false;
            rewriteBlobContent = true;
            RDL.resumeCheckDisabledForAll = true;
            rewriteBuilderApi = true;
            break;
        case "rsb":
            basePath = "/build-resume";
            defaultSkin = "SRZ1";
            portalId = "69";
            templateId = "-3";
            useAccountsJs = true;
            RDL.isRSB = true;
            RDL.isWhiteLabel = true;
            rewriteBlobContent = true;
            break;
    }
    return {
        portalCd: portalCd, url: RDL.domain, slug: basePath, defaultSkin: defaultSkin, portalId: portalId, templateId: templateId,
        useAccountsJs: useAccountsJs, cookieDomain: cookieDomain,
        rewriteBlobContent: rewriteBlobContent, rewriteBuilderApi: rewriteBuilderApi
    };
}
RDL.Portal = RDL.Portal || RDL.getPortalInfo();
var isUK = function () {
    RDL.isUK = false;
    if (RDL.Portal.portalCd == "muk") {
        RDL.isUK = true;
    }
    return RDL.isUK;
}
var isFR = function () {
    RDL.isFR = false;
    if (RDL.Portal.portalCd == "mfr") {
        RDL.isFR = true;
    }
    return RDL.isFR;
}
var isES = function () {
    RDL.isES = false;
    if (RDL.Portal.portalCd == "mes") {
        RDL.isES = true;
    }
    return RDL.isES;
}
var isIT = function () {
    RDL.isIT = false;
    if (RDL.Portal.portalCd == "mit") {
        RDL.isIT = true;
    }
    return RDL.isIT;
}
var isBR = function () {
    RDL.isBR = false;
    if (RDL.Portal.portalCd == "mbr") {
        RDL.isBR = true;
    }
    return RDL.isBR;
}
var isINTL = function () {
    var isINTL = isUK() || isFR() || isES() || isIT() || isBR();
    if (isINTL) {
        RDL.prefetchINTLECOMJS = true;
        RDL.useSupplementaryInfoField = true;
        RDL.useDefaultPageSizeA4 = true;
        RDL.enablePageSizeFeature = true;
        RDL.enablemultiParaImprovement = true; //Used for multipara improvement for hover and drag experience
        RDL.localizeDefinitionTips = true;
        RDL.useContentBlobForSVGs = true;
        RDL.showChatIcon = isFR() || isES() || isIT();
        RDL.showCSNumbersInHeader = isBR();
        RDL.usePPDTSection = isIT();
        RDL.useSignatureSection = isIT();
        RDL.useNormalSkinFormatting = true;
        RDL.showDeleteInDragDisableSections = true;
        RDL.enablePrintEmailOnFinalize = true;
        RDL.ecomPrefetchURL = 'https://' + window.location.host + '/payment/scripts/mpintlPrefetchScript.js';
        RDL.showZipPrefix = isES(); // Need this flag on choosetemplate, to prevent removal of zipprefix div in BOLD renderer
        RDL.showAdditionalPersonalInfo = isES();
        RDL.fireTemplateTaggingEvents = true;
        RDL.useCreateDocV1 = true;
        RDL.useEuropeanDateFormat = true;
        RDL.isDummyDocSectionReOrdering = isFR();
        RDL.photoUploadTagging = true;
        RDL.preventHeaderDisable= true;
    }
    return isINTL;
}
RDL.isINTL = isINTL();
RDL.CommonTrackProperties = function (islogin) {
    var propertiesToBeSent = {
        'builder type': 'Resume Wizard',
        'Platform': 'Web',
        'Feature Set': 'Resumes',
        'Login Status': islogin ? 'TRUE' : 'FALSE'
    };

    return propertiesToBeSent;
}
RDL.getApiUrl = function (versionNumber) {
    versionNumber = versionNumber || "v1";
    var configName = RDL.QA_IDENTIFIER;
    var baseUrl = "";
    var apiEnvironment = RDL.environmentURL || environment;
    baseUrl = apiEnvironment != "www" && apiEnvironment != "builder" && apiEnvironment != "app" ? "https://api-@@env-embedded-builder." + RDL.Portal.url + "/api/" + versionNumber + "/" : "https://api-embeddedbuilder." + RDL.Portal.url + "/api/" + versionNumber + "/";
    switch (apiEnvironment) {
        case "reg":
        case "pen":
        case "regression":
            configName = "reg";
            AuthCookieName = "Auth_Reg";
            break;
        case "stg":
            configName = "stg";
            break;
        case "perf":
            configName = "perf";
            break;
        case "local":
        case "local-app":
        case "qa":
            // showPrintPreviewLinkOnFinalize = true;
            AuthCookieName = "Auth_QA";
            break;
        case "www":
        case "builder":
        case "app":
            break;
    }
    var returnUrl = baseUrl.replace('@@env', configName);
    if (RDL.Portal.rewriteBuilderApi && !isLocal && !isPerf) {
        returnUrl = window.location.origin + "/eb/api/" + versionNumber + "/";
    }
    return returnUrl;
}
RDL.getJsgUrl = function (versionNumber) {
    versionNumber = !!versionNumber || "v1";
    var baseUrl = window.location.hostname;
    if (isLocal) {
        baseUrl = baseUrl.replace("local", RDL.QA_IDENTIFIER);
    }

    return "https://" + baseUrl + "/jsg/" + versionNumber + "/";
}
RDL.getFTUrl = function (versionNumber) {
    versionNumber = !!versionNumber || "v1";
    var baseUrl = window.location.hostname;
    if (isLocal) {
        baseUrl = baseUrl.replace("local", RDL.QA_IDENTIFIER);
    }
    var url = "https://" + baseUrl + "/ft/api/" + versionNumber + "/";
    return url;
}
window.isIPAD = function () {
    if (navigator.userAgent.match(/iPad/i))
        return true;
    else
        return false;
}
window.isInternetExplorer = function () {
    var ua = window.navigator.userAgent;
    var msie = ua.indexOf('MSIE ');
    var trident = ua.indexOf('Trident/');
    if (msie > 0 || trident > 0) {
        return true;
    }
    else {
        return false;
    }
}
window.hideHIWPage = function () {
    if (document.getElementById('howItWorks')) {
        document.getElementById('howItWorks').classList.add("d-none");
    }
}
window.startApp = function (event) {
    if (event != null)
        event.preventDefault();
    RDL.startPageLoader();
    clearInterval(packageLoaded);
    packageLoaded = setInterval(function () {
        var hiwComponent = window.hiwComponent;
        if (hiwComponent && !hiwComponent.preventPageNavigation && configLoaded && resourceLoaded) {
            clearInterval(packageLoaded);
            hideHIWPage();
            hiwComponent.moveToFunnel(event);
        }
    }, 10);
}
window.hasClass = function (elem, className) {
    return elem.className && (new RegExp(className, 'g')).test(elem.className);
}
window.toggleClass = function (elem, className) {
    if (hasClass(elem, className)) {
        elem.className = elem.className.replace((new RegExp(className, 'g')), "");
    } else {
        elem.className += " " + className;
    }
}
window.getResourceUrl = function () {
    var portalcd = RDL.Portal.portalCd;
    if (RDL.Portal.rewriteBlobContent && !isLocal) {
        return "/blobcontent/" + portalcd + "/";
    }
    else if (RDL.Portal.rewriteBlobContent && isLocal) {
        return "https://" + RDL.QA_IDENTIFIER + cookieDomain + "/blobcontent/" + portalcd + "/";
    } else {
        return (environment != "stg" && environment != "www" && environment != "builder" && environment != "app") ? "https://lccontentdev.blob.core.windows.net/" + portalcd + "/" : RDL.blobUrl + "/" + portalcd + "/";
    }
}
window.getRWZBlobURL = function () {
    if ((RDL.Portal.rewriteBlobContent && !isLocal)) {
        return "/blobcontent/rwz/";
    } else {
        return (environment != "stg" && environment != "www" && environment != "builder" && environment != "app") ? "https://lccontentdev.blob.core.windows.net/rwz/" : RDL.blobUrl + "/rwz/";
    }
}
window.mixpanelSyncForMX = function () {
    //mixpanel account handling for MX-ES cross domain case
    var anonymousIdMX = window.location.search.split("anonymousIdMX=")[1] || RDL.anonymousIdMX;
    if (anonymousIdMX && anonymousIdMX.length > 0) {
        anonymousIdMX = anonymousIdMX.indexOf("&") > -1
            ? anonymousIdMX.substring(0, anonymousIdMX.indexOf("&"))
            : anonymousIdMX;
        analytics && analytics.identify(anonymousIdMX);
        RDL.anonymousIdMX = anonymousIdMX;
    }
}
window.AsyncSegTrack = function (isLoggedin, visitId) {
    if (RDL.UserConsent) {
        if (typeof analytics != 'undefined') {
            AsyncPageSegTrack(isLoggedin, visitId);
        }
        else {
            var TrackEventsInterval = setInterval(function () {
                if (typeof analytics != 'undefined') {
                    AsyncPageSegTrack(isLoggedin, visitId);
                    clearInterval(TrackEventsInterval);
                }
            }, 100);
        }
    }
}
window.AsyncPageSegTrack = function (isLoggedin, visitId) {
    var userType,
        vsuid = RDL.readCookie("vstrType");
    userType = vsuid == null ? "New" : "Returning";
    if (!vsuid) {
        RDL.createCookie("vstrType", "1", 5 * 365, window.location.host.substr(window.location.host.indexOf('.')));
    }
    var objToSend = { 'Visitor Type': userType, 'Page Type': 'Product' };
    if (visitId) {
        objToSend.visitId = visitId;
    }
    RDL.TrackEvents("page", objToSend, null, isLoggedin);
}
window.GetMixpanelProperties = function () {
    var mixpanelProperties = '';
    try {
        if (typeof mixpanel != 'undefined' && typeof mixpanel.get_distinct_id != 'undefined') {
            if (isIPAD()) {
                mixpanel.register({ 'device type': 'tablet' });
            } else {
                mixpanel.register({ 'device type': 'desktop' });
            }

            if ((!RDL.isLCA && !RDL.isWhiteLabel && !RDL.isZTY) || RDL.createMixpanelPropsINTL) {
                var infoProperties = mixpanel._.info.properties();
                var persistProperties = mixpanel.persistence.properties();
                mixpanelProperties = JSON.stringify(Object.assign(infoProperties, persistProperties));
                RDL.createCookie("mixpanelprops", escape(mixpanelProperties), null, window.location.host.substr(window.location.host.indexOf('.')));
            }
        }
    }
    catch (e) {
        console.log('error in mixpanel properties fetching');
    }
}
window.UpdateMixPanelURL = function () {
    try {
        var mixpanelpropsVal = RDL.readCookie("mixpanelprops");
        var mixPanelValObj = JSON.parse(unescape(mixpanelpropsVal));
        if (mixPanelValObj["$current_url"] != window.location.href) {
            mixPanelValObj["$current_url"] = window.location.href;
            var mixpanelProperties = JSON.stringify(mixPanelValObj);
            RDL.createCookie("mixpanelprops", escape(mixpanelProperties));
        }
    }
    catch (ex) {
        console.log(ex);
    }
}
window.trackEvent = function (eventName, eventpropval, userid, islogin) {
    if (RDL.readCookie("mixpanelprops") == null) {
        GetMixpanelProperties();
    }
    else {
        UpdateMixPanelURL();
    }
    TrackEvents(eventName, eventpropval, userid, islogin);
}
window.getConfigUrl = function () {
    var configName = "dev";
    var baseUrl = RDL.Paths.ResourcePath + "config/";
    var _environment = RDL.environmentURL || environment;
    switch (_environment) {
        case "regression":
        case "reg":
            configName = "reg";
            break;
        case "pen":
            configName = "pen";
            break;
        case "reg-stg":
            configName = "reg-stg";
            break;
        case "stg":
            configName = "stg";
            break;
        case "perf":
            configName = "perf";
            break;
        case "www":
            configName = "prod";
            break;
        case "builder":
        case "app":
            configName = "prod";
            break;
    }
    var filename = configName + ".js";
    if (versionNumber != "1.0.0") {
        filename = filename + "?v=" + versionNumber;
    }
    return baseUrl + filename;
}
window.applyCssonCards = function (cards) {
    for (var i = 0; i < cards.length; i++) {
        cards[i].classList.add("thumb-" + cards[i].parentElement.attributes["data-skincd"].value.toLowerCase());
    }
}
window.applyImageCss = function () {
    var cards = document.getElementsByClassName('list-item-thumb');
    if (RDL.applyCardCss && cards && cards.length > 0) {
        applyCssonCards(cards);
    }
    else {
        setTimeout(function (cards) {
            applyImageCss();
        }, 50);
    }
}
window.polyfillNodelistForeach = function () {
    //polyfill to support foreach on NodeList
    if (window.NodeList && !NodeList.prototype.forEach) {
        NodeList.prototype.forEach = function (callback, thisArg) {
            thisArg = thisArg || window;
            for (var i = 0; i < this.length; i++) {
                callback.call(thisArg, this[i], i, this);
            }
        };
    }
    if (window.DOMTokenList && !DOMTokenList.prototype.forEach) {
        DOMTokenList.prototype.forEach = function (callback, thisArg) {
            thisArg = thisArg || window;
            for (var i = 0; i < this.length; i++) {
                callback.call(thisArg, this[i], i, this);
            }
        };
    }
}
window.loadGTM = function (w, d, s, l, i) {
    w[l] = w[l] || []; w[l].push({
        'gtm.start':
            new Date().getTime(), event: 'gtm.js'
    }); var f = d.getElementsByTagName(s)[0],
        j = d.createElement(s), dl = l != 'dataLayer' ? '&l=' + l : ''; j.async = true; j.src =
            'https://www.googletagmanager.com/gtm.js?id=' + i + dl + (RDL.Portal.googleMapappendGTMQueryStringsKey ? RDL.Portal.googleMapappendGTMQueryStringsKey : ''); f.parentNode.insertBefore(j, f);
}
//End Google Tag Manager

window.loadJs = function (src, async, callback, crossorigin) {
    var s,
        r,
        t;
    r = false;
    s = document.createElement('script');
    s.type = 'text/javascript';
    s.src = src;
    if (crossorigin == true) {
        s.crossOrigin = 'anonymous';
    }
    s.async = (async != null && async != undefined) ? async : true;
    s.onload = s.onreadystatechange = function () {
        if (!r && (!this.readyState || this.readyState == 'complete' || this.readyState == 'loaded')) {
            r = true;
            callback && callback();
        }
    };
    t = document.getElementsByTagName('script')[0];
    t.parentNode.insertBefore(s, t);
}
window.loadJsWithKey = function (src, id, key) {
    var f = document.createElement('script');
    f.setAttribute("src", src);
    f.setAttribute("id", id);
    f.setAttribute("data-app-key", key);
    if (typeof f != "undefined")
        document.getElementsByTagName("head")[0].appendChild(f);
}
window.loadStyleSheet = function (src) {
    if (document.createStyleSheet) document.createStyleSheet(src);
    else {
        var stylesheet = document.createElement('link');
        stylesheet.href = src;
        stylesheet.rel = 'stylesheet';
        stylesheet.type = 'text/css';
        document.getElementsByTagName('head')[0].appendChild(stylesheet);
    }
}
window.loadgtms = function () {
    if (RDL.Portal.gtmKey1 && RDL.Portal.gtmKey1 != null && RDL.Portal.gtmKey1.length > 0) {
        loadGTM(window, document, 'script', 'dataLayer', RDL.Portal.gtmKey1);
    }

    if (RDL.Portal.gtmKey2 && RDL.Portal.gtmKey2 != null && RDL.Portal.gtmKey2.length > 0) {
        loadGTM(window, document, 'script', 'dataLayer', RDL.Portal.gtmKey2);
    }
}
window.loadJqueryDepJs = function () {
    if (RDL.UserConsent) {
        RDL.LoadThirdPartyJS();
    }
    if (typeof (RDL.externalJavascripts) && RDL.externalJavascripts) {
        RDL.externalJavascripts.forEach(function (element) {
            var script = document.createElement('script');
            script.type = "text/javascript";
            script.src = element;
            document.getElementById('afterLoadContent').appendChild(script);
        });
    }
}
window.downLoadAccountsJs = function () {
    if (RDL.Portal && RDL.Portal.useAccountsJs) {
        // create guest user
        var divLoginWidget = document.getElementById('divLoginWidget');
        if (divLoginWidget) {
            divLoginWidget.setAttribute("data-targetDomain", RDL.Paths.AccountsURL);
            divLoginWidget.setAttribute("data-productCode", RDL.PortalSettings.ConfigureProductCd);
            divLoginWidget.setAttribute("data-portalCode", RDL.PortalSettings.ConfigurePortalCd);
        }
        var accountsUrl = RDL.Paths.AccountsURL + "/scripts/app/accounts.min.js";
        if (RDL.useAccountsJsReverseProxy) {
            accountsUrl = RDL.Paths.AccountsURL;
        }
        (function (d, s, id) {
            var js, fjs = d.getElementsByTagName(s)[0];
            if (d.getElementById(id)) return;
            js = d.createElement(s); js.id = id;
            js.src = accountsUrl;
            fjs.parentNode.insertBefore(js, fjs);
        }(document, 'script', 'accounts-js'));
    }
}
window.setCountryDetails = function (resolve) {
    callAjax(true, RDL.Paths.BaseApiUrl + 'user/countryclaims', "GET", true, true, function (data) {
        var customCountry = RDL.GetQueryString('customcountry') || RDL.readCookie("customcountry");
        if (customCountry) {
            alert('Country selected is ' + customCountry);
            RDL.createCookie("customcountry", customCountry, 1);
        }
        if (data && !customCountry) {
            RDL.countryDetails = JSON.parse(data);
            if (RDL.countryDetails) {
                if (!RDL.countryDetails.continentCode) {
                    RDL.countryDetails.continentCode = ""
                }
                if (!RDL.countryDetails.city) {
                    RDL.countryDetails.city = ""
                }
                if (!RDL.countryDetails.state) {
                    RDL.countryDetails.state = ""
                }
                if (!RDL.countryDetails.zip) {
                    RDL.countryDetails.zip = ""
                }
            }
        }
        else {
            RDL.countryDetails = {
                "countryCode": customCountry || "US",
                "continentCode": "",
                "isEuropianContinent": false,
                "isEEACountry": false,
                "city": customCountry ? "CITY_" + customCountry : "",
                "state": customCountry ? "STATE_" + customCountry : "",
                "zip": customCountry ? "ZIP_" + customCountry : "",
                "ip": ""
            }
        }
        resolve && resolve();
    });
}
window.getLocalizationUrl = function () {
    var resourceName = "dev";
    var baseUrl = RDL.Paths.ResourcePath + "Resources/";
    var _environment = RDL.environmentURL || environment;
    switch (_environment) {
        case "regression":
        case "reg":
            resourceName = "reg";
            break;
        case "reg-stg":
            resourceName = "reg-stg";
            break;
        case "stg":
            resourceName = "stg";
            break;
        case "perf":
            resourceName = "perf";
            break;
        case "www":
            resourceName = "prod";
            break;
        case "builder":
        case "app":
            resourceName = "prod";
            break;
    }

    var filename = resourceName + ".json";
    if (versionNumber != "1.0.0") {
        filename = filename + "?v=" + versionNumber;
    }
    return baseUrl + filename;
}
RDL.isTemplateFlow = function () {
    var isValidTemplateFlow = false;
    var templateFlow = RDL.GetQueryString('templateflow');
    if (templateFlow && RDL.isBaseRoute && (templateFlow.toLowerCase() == 'selectresume' || templateFlow.toLowerCase() == 'contact' || templateFlow.toLowerCase() == 'choosetemplate')) {
        RDL.templateFlowValue = templateFlow.toLowerCase();
        if (isIPAD() && RDL.templateFlowValue == 'selectresume') {
            RDL.templateFlowValue = "contact";
        }
        isValidTemplateFlow = true;
    }

    return RDL.showHIWExperiment ? false : isValidTemplateFlow;
}

RDL.isHiwExperimentFlow = function () {

    if (RDL.showHIWExperiment || sessionStorage.getItem("showHIWExperiment") && sessionStorage.getItem("showHIWExperiment") == "true") {
        return true;

    }

    return false;
}

RDL.clearHiwExperiment = function () {
    RDL.showHIWExperiment = false;
    sessionStorage.removeItem("showHIWExperiment");
    sessionStorage.removeItem("hiwQueryString");

}

window.RemoveSelectedIndustryFromLocalStorage = function () {
    try {
        if (window.localStorage) {
            var storageItemName = "STORAGE_IndustrySelected";
            window.localStorage.removeItem(storageItemName);
        }
    }
    catch (e) {
        console.log('Issue in localStorage access.');
    }
}
window.clearAndRedirect = function (redirectPath) {
    if (!isRedirectDone) {
        RDL.logMessage += "\n login Claims Call cookiecollection - " + document.cookie + "\n";
        RDL.logMessage += "\n Cookie Enabled - " + navigator.cookieEnabled + "\n";
        var errorObj = {
            ErrorMessage: 'RWZV2 Logging-' + redirectPath + RDL.logMessage, LogAsInfo: true
        };
        RDL.LogError(errorObj.ErrorMessage, '', errorObj.LogAsInfo, function () {
            RemoveSelectedIndustryFromLocalStorage(); // clear local storage
            RDL.logMessage = "";
            isRedirectDone = true;
            if (window.LOGIN && window.LOGIN.Accounts) {
                var objInfo = {
                    referrer: document.referrer,
                    cookies: document.cookie
                }
                var errorMsg = "I#:clearAndRedirect-Logout " + JSON.stringify(objInfo);
                RDL.LogError(errorMsg, "", false);
                LOGIN.Accounts.logOut();
            }
            else if (RDL.Portal.cookieDomain) {
                RDL.delete_cookie(AuthCookieName, RDL.Portal.cookieDomain);
            }
            RDL.delete_cookie("userinfo", RDL.Portal.cookieDomain);
            RDL.delete_cookie("UserStatus", RDL.Portal.cookieDomain);
            RDL.delete_cookie("useruid", RDL.Portal.cookieDomain);
            if (window.indexedDB) {
                window.indexedDB.deleteDatabase("localforage");
            }
            window.location = redirectPath;
        });
    }
}
window.handlePostGuestCreated = function () {
    if (window.appEntry && postGuestCreatedCalled == false && RDL.UserClaims) {
        postGuestCreatedCalled = true;
        clearInterval(postGuestUserTimer);
        if (window.appEntry.isPostGuestUserCreationProcessingCalled == false) {
            window.appEntry.postGuestUserCreationProcessing();
        }
        if (isHandlePostPageLoadCalled == false) {
            handlePostPageLoad();
        }
    }
}
window.PostGuestCreated = function (userUID, claimCall) {
    if (!userUID && RDL.readCookie(AuthCookieName) == null && RDL.readCookie("userinfo") && RDL.readCookie("userinfo").length > 0) {
        // case: if Boldauth is missing & only old userinfo exists & userid comes null from accounts, so clear the userInfo cookie.
        RDL.delete_cookie("userinfo", RDL.Portal.cookieDomain);
    }

    if (claimCall == null) {
        RDL.Claims(handleClaims);
    }
    else {
        clearInterval(postGuestUserTimer);
        postGuestUserTimer = setInterval(function () {
            handlePostGuestCreated();
        }, 200);
    }
}
window.handleClaims = function (result, resolve) {
    RDL.UserClaims = JSON.parse(result);

    if (RDL.UserClaims.user_uid != null && RDL.UserClaims.user_uid != '' && navigator.cookieEnabled) {
        RDL.isloggedIn = (RDL.UserClaims.role != "User") ? false : true;
        if (RDL.isBaseRoute && !RDL.isTemplateFlow()) {
            if (RDL.UserClaims.role == "Guest" && isAccUserCalled) {
                PostGuestCreated(RDL.UserClaims.user_uid, 'claim');
            }
        }
        else if (!RDL.isBaseRoute && RDL.UserClaims.role == "Guest" && isAccUserCalled) {
            window.location = RDL.Paths.BasePath;
        }
        else {
            hideHIWPage();
        }
    }
    else if (RDL.Portal && RDL.Portal.useAccountsJs) {
        if (!RDL.UserClaims.user_uid || RDL.readCookie(AuthCookieName) == null) {
            if (isAccUserCalled && (RDL.Portal.useAccountsJs)) {
                clearAndRedirect("/?forceRedirect=claimNotFound")
            } else {
                RDL.CreateGuestUser();
            }
        }
        else {
            PostGuestCreated(RDL.UserClaims.user_uid, 'claim');
        }
    }
    if (resolve) {
        resolve("");
    }
}
window.callAjax = function (logError, url, method, async, withCredentials, callback, resolve, data) {
    var xmlhttp;
    xmlhttp = new XMLHttpRequest();
    xmlhttp.onload = function () {
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
            if (callback)
                if (resolve) {
                    callback(xmlhttp.responseText, resolve);
                }
                else {
                    callback(xmlhttp.responseText);
                }
        }
        else {
            if (callback) {
                if (resolve) {
                    callback(null, resolve);
    }
                else {
                    callback(null);
                }
            }
            if (logError) {
                RDL.logMessage = "An error occurred during the Ajax call";
                RDL.logMessage += "\n Referrer : " + document.referrer + "\n- Location : " + window.location.href;
                RDL.logMessage += "\n Status : " + xmlhttp.status + "\n- Request URL : " + xmlhttp.responseURL + "\n- Response Text : " + xmlhttp.responseText;
                var errorObj = {
                    ErrorMessage: 'Ajax call Error Logging-' + RDL.logMessage, LogAsInfo: true
                };
                RDL.LogError(errorObj.ErrorMessage, '', errorObj.LogAsInfo);
            }
        }
    }
    xmlhttp.open(method, url, async);
    if (withCredentials)
        xmlhttp.withCredentials = true;

    if (data) {
        xmlhttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        xmlhttp.send(data);
    }
    else {
        xmlhttp.send();
    }
}
window.appendQueryString = function (url) {
    return url && url.includes("?") ? url + location.search.replace("?", "&") : url + location.search;
}
RDL.LogError = function (errorMessage, componentStack, logAsInfo, callback) {
    var mixpanelpropsVal = window.RDL.readCookie("mixpanelprops");
    var mixPanelValObj = JSON.parse(unescape(mixpanelpropsVal));
    var browserName = '';
    var currentUrl = '';
    if (mixPanelValObj) {
        browserName = mixPanelValObj["$browser"];
    }
    currentUrl = window.location.href;
    var errorObj = {
        errorMessage: errorMessage,
        componentStack: componentStack,
        logAsInfo: logAsInfo,
        docId: RDL.readCookie('DocumentID'),
        userID: RDL.UserClaims ? RDL.UserClaims.user_uid : '',
        sourceAppCd: RDL.appCD,
        productCD: RDL.PortalSettings.ConfigureProductCd,
        portalCD: RDL.PortalSettings.ConfigurePortalCd,
        deviceType: 'desktop',
        browser: browserName,
        currentUrl: currentUrl
    }
    callAjax(false, RDL.Paths.BaseApiUrlV2 + 'errors/log', 'POST', true, true, function () {
        RDL.logMessage = "";
        if (callback) {
            callback();
        }
    }, null, JSON.stringify(errorObj));
}
window.callAjaxTestBed = function (url, method, async, withCredentials, callback, resolve, data) {
    var xmlhttp;
    xmlhttp = new XMLHttpRequest();
    xmlhttp.withCredentials = true;
    xmlhttp.onload = function () {
        if (xmlhttp.readyState == 4 && (xmlhttp.status == 200 || xmlhttp.status == 404)) {
            if (callback)
                if (resolve) {
                    callback(xmlhttp.responseText, resolve);
                }
                else {
                    callback(xmlhttp);
                }
        }
    }
    xmlhttp.open(method, url, async);
    if (withCredentials)
        xmlhttp.withCredentials = true;

    if (data) {
        xmlhttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        xmlhttp.send(data);
    }
    else {
        xmlhttp.send();
    }
}
window.getFeatureSet = function (resolve) {
    var featureUrl = RDL.Paths.BaseApiUrl + 'config/features/' + RDL.Portal.portalCd;
    callAjax(true, featureUrl, "GET", true, true, function (data) {
        if (data && data != "null") {
            RDL.ArrayFeatureSet = JSON.parse(data).filter(function (x) { return x.moduleName == 'Builder' });
            RDL.ArrayFeatureSet.map(function (feature) { document.documentElement.classList.add('f-' + feature.featureCD.toLowerCase()) });
        }
        if (resolve)
            resolve("");
    });
}
RDL.isFeaturePresent = function (featureCD) {
    var result = false;
    var feature = RDL.ArrayFeatureSet.filter(function (feature) { return feature.featureCD.toLowerCase() == featureCD.toLowerCase() });
    if (feature && feature.length && feature[0].isActive) {
        //document.documentElement.classList.add('f-' + featureCD.toLowerCase());
        result = true;
    }
    return result;
}
window.getTemplatesFromFeedbackSystem = function () {
    if (RDL.recommendedActions) {
        var studentFeedbakSkinsCode = RDL.recommendedActions.RecommendedFeedbackSkins && RDL.recommendedActions.RecommendedFeedbackSkins.student;
        if (studentFeedbakSkinsCode) {
            var recommendationUrl = RDL.Paths.BaseApiUrl + 'config/recommendedskins/' + RDL.Portal.portalCd + "/" + studentFeedbakSkinsCode;
            callAjax(true, recommendationUrl, "GET", true, true, function (data) {
                if (data) {
                    sessionStorage.setItem(studentFeedbakSkinsCode, data);
                }
            });
        }
    }
}
RDL.loadLocalizedDefinitionTips = function () {
    if (RDL.Localization && RDL.localizeDefinitionTips) {
        RDL.Definition_Tips.forEach(function (item) {
            item.tips = RDL.Localization[item.tips] ? RDL.Localization[item.tips] : item.tips;
            item.name = RDL.Localization[item.name] ? RDL.Localization[item.name] : item.name;
            item.defaultText = RDL.Localization[item.defaultText] ? RDL.Localization[item.defaultText] : item.defaultText;
            item.title = RDL.Localization[item.title] ? RDL.Localization[item.title] : item.title;
            item.definition = RDL.Localization[item.definition] ? RDL.Localization[item.definition] : item.definition;
            if (item.PageTitle)
                item.PageTitle = RDL.Localization[item.PageTitle] ? RDL.Localization[item.PageTitle] : item.PageTitle;
            if (item.BulbTipsDefinition)
                item.BulbTipsDefinition = RDL.Localization[item.BulbTipsDefinition] ? RDL.Localization[item.BulbTipsDefinition] : item.BulbTipsDefinition;
            if (item.BulbTips1)
                item.BulbTips1 = RDL.Localization[item.BulbTips1] ? RDL.Localization[item.BulbTips1] : item.BulbTips1;
            if (item.BulbTips2)
                item.BulbTips2 = RDL.Localization[item.BulbTips2] ? RDL.Localization[item.BulbTips2] : item.BulbTips2;
            if (item.BulbTips3)
                item.BulbTips3 = RDL.Localization[item.BulbTips3] ? RDL.Localization[item.BulbTips3] : item.BulbTips3;
            if (item.BulbTips4)
                item.BulbTips4 = RDL.Localization[item.BulbTips4] ? RDL.Localization[item.BulbTips4] : item.BulbTips4;

        });
    }
}

window.polyfillStringTrimLeft = function () {
    if (String.prototype.trimLeft) {
        return;
    }
    String.prototype.trimLeft = function () {
        return this.replace(/^\s+/, "");
    };
}

window.polyfillStringTrimRight = function () {
    if (String.prototype.trimRight) {
        return;
    }
    String.prototype.trimRight = function () {
        return this.replace(/\s+$/, "");
    };
}

window.polyfillArrayFrom = function () {
    if (Array.from) {
        return;
    }
    Array.from = (function () {
        var toStr = Object.prototype.toString;
        var isCallable = function (fn) {
            return typeof fn === 'function' || toStr.call(fn) === '[object Function]';
        };
        var toInteger = function (value) {
            var number = Number(value);
            if (isNaN(number)) { return 0; }
            if (number === 0 || !isFinite(number)) { return number; }
            return (number > 0 ? 1 : -1) * Math.floor(Math.abs(number));
        };
        var maxSafeInteger = Math.pow(2, 53) - 1;
        var toLength = function (value) {
            var len = toInteger(value);
            return Math.min(Math.max(len, 0), maxSafeInteger);
        };

        return function from(arrayLike/*, mapFn, thisArg */) {
            var C = this;

            var items = Object(arrayLike);

            if (arrayLike == null) {
                throw new TypeError('Array.from requires an array-like object - not null or undefined');
            }

            var mapFn = arguments.length > 1 ? arguments[1] : void undefined;
            var T;
            if (typeof mapFn !== 'undefined') {
                if (!isCallable(mapFn)) {
                    throw new TypeError('Array.from: when provided, the second argument must be a function');
                }

                if (arguments.length > 2) {
                    T = arguments[2];
                }
            }

            var len = toLength(items.length);

            var A = isCallable(C) ? Object(new C(len)) : new Array(len);

            var k = 0;
            var kValue;
            while (k < len) {
                kValue = items[k];
                if (mapFn) {
                    A[k] = typeof T === 'undefined' ? mapFn(kValue, k) : mapFn.call(T, kValue, k);
                } else {
                    A[k] = kValue;
                }
                k += 1;
            }
            A.length = len;
            return A;
        };
    }());
}
window.polyfillPromiseFinally = function () {
    Promise.prototype.finally = Promise.prototype.finally || {
        finally: function _finally(fn) {
            var onFinally = function onFinally(callback) {
                return Promise.resolve(fn()).then(callback);
            };

            return this.then(function (result) {
                return onFinally(function () {
                    return result;
                });
            }, function (reason) {
                return onFinally(function () {
                    return Promise.reject(reason);
                });
            });
        }
    }.finally;
}
window.handleAliasAndIdentify = function () {
    if (!RDL.isloggedIn) {
        var interval = setInterval(function () {
            if (typeof analytics != 'undefined') {
                clearInterval(interval);
                //call mixpanel sync only once for MX portal
                RDL.readCookie("lp") && RDL.readCookie("lp").indexOf("MX") > -1 && mixpanelSyncForMX();
                analytics.alias(RDL.UserClaims.user_uid);
                setTimeout(function () {
                    analytics.identify(RDL.UserClaims.user_uid, null);
                }, 100);
            }
        }, 50);
    }
}
window.getLongMonths = function (culture) {
    var monthsLong = [""];
    for (var i = 0; i < 12; i++) {
        var objDate = new Date(); objDate.setMonth(i);
        var locale = culture.toLowerCase();
        var month = objDate.toLocaleString(locale, { month: "long" });
        monthsLong.push(month.substr(0, 1).toUpperCase() + month.substr(1, month.length - 1));
    }
    return monthsLong;
}
RDL.addExperimentsLocalizedText = function () {
    if (RDL.Localization.RWZPersonalizedTipsV1) {
        Object.assign(RDL.ExperimentsLocalization[RDL.portalExperiments.mprRWZPersonalizedTipsV1.id], RDL.Localization.RWZPersonalizedTipsV1);
    }
    var expsList = Object.keys(RDL.portalExperiments);
    if (expsList.length > 0) {
        expsList.forEach(function (exp) {
            var experimentID = RDL.portalExperiments[exp].id;
            if (RDL.ExperimentsLocalization[experimentID]) {
                Object.assign(RDL.Localization, RDL.ExperimentsLocalization[experimentID]);
            }
        });
    }
    if (RDL.featurePhoto && !RDL.usePhotoLocalization) {
        var photoLocalization = {
            "uploaded_Text": "Uploaded",
            "dontAddPhoto_Text": "Make sure to check the application requirements before adding a photo. Some employers won’t consider resume with photos.",
            "wantAddPhoto_Text": "Want to add a photo?",
            "chooseRecentPhoto_Text": "Choose a recent color photo in a JPEG, PNG, or GIF format, that’s less than 10MB.",
            "editYourPhoto_Text": "Crop your photo so it only shows your head and shoulders.",
            "replaceAlreadyUploaded_Text": "If you already uploaded a photo, uploading another will replace it.",
            "resumePhoto_Text": "Save",
            "photoUpload_Label": "Photo upload",
            "choosePhoto_Text": "Change photo",
        }
        Object.assign(RDL.Localization, photoLocalization);
        RDL.localizationResumeRenderer["editPhoto_Text"] = "Edit";
    }

}
RDL.handleLocalizationText = function (result, resolve, configObj) {
    var data = JSON.parse(result);
    RDL.Localization = data.localizedtext;
    configuration.modifyCountryWiseLocalization(data, configObj);
    RDL.localizedDocumentText = data.localizedtext.resumeNameLocalizedText ? data.localizedtext.resumeNameLocalizedText : "Resume";
    if (!RDL.showProfessionField) {
        RDL.Localization.default_preview_documentTitle = "";
    }
    RDL.isCountryAUorNZ = RDL.countryDetails.countryCode == "AU" || RDL.countryDetails.countryCode == "NZ";

    RDL.localizationResumeRenderer = {
        "zip_Label": RDL.Localization.zip_Label || "",
        "firstNamDefaultText": RDL.Localization.default_preview_firstname,
        "lastNameDefaultText": RDL.Localization.default_preview_lastname,
        "fNameDefaultText": RDL.Localization.default_firstname,
        "lNameDefaultText": RDL.Localization.default_lastname,
        "professionDefaultText": RDL.Localization.default_preview_documentTitle,
        "streetAddressDefaultText": RDL.Localization.default_preview_street,
        "cityDefaultText": RDL.Localization.default_preview_city,
        "stateDefaultText": RDL.Localization.default_preview_state,
        "zipDefaultText": RDL.Localization.default_preview_zipcode,
        "neighbourhoodDefaultText": RDL.Localization.default_preview_neighbourhood,
        "emailDefaultText": RDL.Localization.default_preview_email,
        "phoneDefaultText": RDL.Localization.default_preview_phone,
        "cellPhoneDefaultText": RDL.Localization.cPhone || '',
        "hPhoneText": RDL.Localization.hPhoneText || '',
        "cPhoneText": RDL.Localization.cPhoneText || '',
        "resumeTitleDefaultText": RDL.Localization.rsTitlDef,
        "exRsmTitleDef": RDL.Localization.exRsTitlDef,
        "exRsmTitleDef2": RDL.Localization.exRsTitl2Def,
        "exRsmTitleDef3": RDL.Localization.exRsTitl3Def,
        "editSectionText": (RDL.Localization.editSection || ''),
        "dragText": RDL.Localization.move_Text,
        "deleteText": RDL.Localization.delete_Label,
        "editText": RDL.Localization.edit_Label,
        "addSubSectionText": "",
        "addNewSecDocText": RDL.Localization.addNewSecDoc,
        "finalRename": RDL.Localization.rename_Label,
        "finalRenameErr": RDL.Localization.enterValidDate_Text,
        "finalRenameCancel": RDL.Localization.cancel_Label,
        "suppInfoDefaultText": RDL.Localization.suppInfo,
        "editPhoto_Text": RDL.Localization.EditPhoto_Text,
        "currentText": RDL.Localization.current_Text,
        "oldCurrentText": RDL.Localization.oldCurrent_Text,
        "shortMonths": RDL.Localization.shortMonth,
        "longMonths": getLongMonths(RDL.cultureCD || "en-US"),

        "schoolnameDefaultText": RDL.Localization.default_preview_schoolname,
        "schoollocationDefaultText": RDL.Localization.default_preview_schoollocation,
        "schoolcityDefaultText": RDL.Localization.default_preview_schoolcity,
        "schoolstateDefaultText": RDL.Localization.default_preview_schoolstate,
        "degreeearnedDefaultText": RDL.Localization.default_preview_degreeearned,
        "graduationyearDefaultText": RDL.Localization.default_preview_graduationyear,
        "fieldofexpertiseDefaultText": RDL.Localization.default_preview_fieldofexpertise,

        "jobtitleDefaultText": RDL.Localization.default_preview_jobtitle1,
        "companyNameDefaultText": RDL.Localization.default_preview_company1,
        "jobcityDefaultText": RDL.Localization.default_preview_jobcity1,
        "jobstateDefaultText": RDL.Localization.default_preview_jobstate1,
        "jobcountryDefaultText": RDL.Localization.default_preview_job_country,
        "jobStarteDateDefaultText": RDL.Localization.default_preview_jobstartdate1,
        "jobEndDateDefaultText": RDL.Localization.default_preview_jobenddate1,
        "jobDescriptionDefaultText": RDL.Localization.default_preview_jobdescription1,

        "jobtitleDefaultText2": RDL.Localization.default_preview_jobtitle2,
        "companyNameDefaultText2": RDL.Localization.default_preview_company2,
        "jobcityDefaultText2": RDL.Localization.default_preview_jobcity2,
        "jobstateDefaultText2": RDL.Localization.default_preview_jobstate2,
        "jobcountryDefaultText2": RDL.Localization.default_preview_job_country2,
        "jobStarteDateDefaultText2": RDL.Localization.default_preview_jobstartdate2,
        "jobEndDateDefaultText2": RDL.Localization.default_preview_jobenddate2,
        "jobDescriptionDefaultText2": RDL.Localization.default_preview_jobdescription2,

        "jobtitleDefaultText3": RDL.Localization.default_preview_jobtitle3,
        "companyNameDefaultText3": RDL.Localization.default_preview_company3,
        "jobcityDefaultText3": RDL.Localization.default_preview_jobcity3,
        "jobstateDefaultText3": RDL.Localization.default_preview_jobstate3,
        "jobStarteDateDefaultText3": RDL.Localization.default_preview_jobstartdate3,
        "jobEndDateDefaultText3": RDL.Localization.default_preview_jobenddate3,
        "jobDescriptionDefaultText3": RDL.Localization.default_preview_jobdescription3,

        "summaryDefaultText": RDL.Localization.default_preview_summary,

        "skillDef": RDL.Localization.default_preview_skill1,
        "skillDef2": RDL.Localization.default_preview_skill2,
        "skillDef3": RDL.Localization.default_preview_skill3,
        "DOB_Text": RDL.Localization.DOB_finalize_Text,
        "nationality_Text": RDL.Localization.nationality_finalize_Text,
        "toDate_text": RDL.Localization.toDate_text || '',
        "address_Label": RDL.Localization.address_Label || '',
        "email_Label": RDL.Localization.email_Label || '',
        "phone_Label": RDL.Localization.phone_Label || '',
        "maritalStatus_Text": RDL.Localization.maritalStatus_finalize_Text,
        "contactSecText": RDL.Localization.cntcCntc_SecType_db || '',
        "skillSecText": RDL.Localization.skllSkll_SectTypeTitle_db || '',
        "exprSecText": RDL.Localization.wrkhWrkh_SectTypeTitle_db || '',
        "summSecText": RDL.Localization.profSumr_SecType_db || '',
        "educSecText": RDL.Localization.educEduc_SectTypeTitle_db || '',
        "skinLoc_Email_Label": RDL.Localization.skinLoc_Email_Label || '',
        "skinLoc_phoneDefaultText": RDL.Localization.skinLoc_phoneDefaultText || '',
        "jobStartDateShortMonth": RDL.Localization.skinLoc_jobStartDateShortMonth || '',
        "jobStartDateShortMonth2": RDL.Localization.skinLoc_jobStartDateShortMonth2 || '',
        "jobEndDateShortMonth2": RDL.Localization.skinLoc_jobEndDateShortMonth2 || '',
        "resume_Text": RDL.Localization.resumes_pageTitle || '',

        "nativeLanguageText": RDL.Localization.nativeLanguageText,
        "foreignLanguage1Level": RDL.Localization.foreignLanguage1Level,
        "foreignLanguage1LevelText": RDL.Localization.foreignLanguage1LevelText,
        "foreignLanguage2Level": RDL.Localization.foreignLanguage2Level,
        "foreignLanguage2LevelText": RDL.Localization.foreignLanguage2LevelText,
        "nativeLanguage": RDL.Localization.nativeLanguage,
        "foreignLanguage1": RDL.Localization.foreignLanguage1,
        "foreignLanguage2": RDL.Localization.foreignLanguage2
    }
    if (!RDL.localizeDefinitionTips) {
        RDL.Localization.flgEnabledSplit = false;
        RDL.Localization.degreeRWZ = [
            { name: "DGRE", value: "-2", label: "Enter a different degree" },
            { name: "DGRE", value: "Some College (No Degree)", label: "Some College (No Degree)" }

        ];

        RDL.Definition_Tips = [
            {
                "tips": "",
                "sectionTypeCd": "NAME",
                "name": RDL.Localization.nameName_SecType_db,
                "defaultText": "",
                "title": "",
                "definition": "",
                "doczonetypecd": "HEAD",
                "isDefaut": true
            }, {
                "tips": "",
                "sectionTypeCd": "CNTC",
                "name": RDL.Localization.cntcCntc_SecType_db,
                "defaultText": "",
                "title": "",
                "definition": "",
                "doczonetypecd": "HEAD",
                "isDefaut": true
            }, {
                "tips": "<li>" + RDL.Localization.needToknow_Text + "</li><li>" + RDL.Localization.summTips_ShowEmp_Text + "</li><li>" + RDL.Localization.summTips_Help_Text + "</li>",
                "sectionTypeCd": "SUMM",
                "name": RDL.Localization.professionalSummary_Text,
                "defaultText": RDL.Localization.placeholder_Summary,
                "title": "",
                "definition": "An overview of your career stating your most important strengths and abilities. This section provides a clear snapshot of who you are, what you can offer, and what you are looking to accomplish.",
                "doczonetypecd": "BODY",
                "isDefaut": true,
                "BulbTipsDefinition": RDL.Localization.shortCut_Text,
                "BulbTips1": RDL.Localization.careerOverView_Text,
                "BulbTips2": RDL.Localization.chooseExample_Text,
                "BulbTips3": RDL.Localization.summary_Text,
                "PageTitle": RDL.Localization.summary_Tips_lbl
            }, {
                "tips": "<li>" + RDL.Localization.needToknow_Text + "</li><li>" + RDL.Localization.skillTips_Scan_Text + "<li>" + RDL.Localization.skillTips_Help_Text + "</li>",
                "sectionTypeCd": "HILT",
                "name": RDL.Localization.skills_Label,
                "defaultText": RDL.Localization.placeholder_Skills_single,
                "title": "",
                "definition": "In this 2-column section, use bullets to highlight your top 4-8 skills. We recommend listing skills in short, 2-3 word phrases, without punctuation.",
                "doczonetypecd": "BODY",
                "isDefaut": true,
                "BulbTipsDefinition": RDL.Localization.managerInsightSkills_Text,
                "BulbTips1": RDL.Localization.relevantSkills_Text,
                "BulbTips2": RDL.Localization.dontHaveExperience_Text,
                "BulbTips3": RDL.Localization.bulletPhrases_Text,
                "BulbTips4": RDL.Localization.notSureAboutSkill_Text,
                "PageTitle": RDL.Localization.skill_Tips_lbl
            }, {
                "tips": "<li>" + RDL.Localization.needToknow_Text + "</li><li>" + RDL.Localization.skillTips_Scan_Text + "<li>" + RDL.Localization.skillTips_Help_Text + "</li>",
                "sectionTypeCd": "SKLI",
                "name": RDL.Localization.skills_Label,
                "defaultText": RDL.Localization.placeholder_Skills_single,
                "title": "",
                "definition": "In this 2-column section, use bullets to highlight your top 4-8 skills. We recommend listing skills in short, 2-3 word phrases, without punctuation.",
                "doczonetypecd": "BODY",
                "isDefaut": false,
                "BulbTipsDefinition": RDL.Localization.managerInsightSkills_Text,
                "BulbTips1": RDL.Localization.relevantSkills_Text,
                "BulbTips2": RDL.Localization.dontHaveExperience_Text,
                "BulbTips3": RDL.Localization.bulletPhrases_Text,
                "BulbTips4": RDL.Localization.notSureAboutSkill_Text,
                "PageTitle": RDL.Localization.skill_Tips_lbl
            }, {
                "tips": "<li>" + RDL.Localization.needToknow_Text + "</li><li>" + RDL.Localization.expTips_ScanRsm_Text + "</li><li>" + RDL.Localization.expTips_BulletPointsImp_Text + "</li>",
                "sectionTypeCd": "EXPR",
                "name": RDL.Localization.wrkhWrkh_SecType_db,
                "defaultText": RDL.Localization.placeholder_Experience_enlargePreview,
                "definition": "Outline up to 10 years of recent work experience, beginning with your current employer. Use bullets to list your major efforts, accomplishments and experience. If you have relevant work experience from more than 10 years ago, we recommend adding a separate section called Previous Work History.",
                "title": "",
                "doczonetypecd": "BODY",
                "isDefaut": true,
                "BulbTipsDefinition": RDL.Localization.hiringManagers_Text,
                "BulbTips1": RDL.Localization.enterInfo_Text,
                "BulbTips2": RDL.Localization.useFullTitle_Textz,
                "BulbTips3": RDL.Localization.includeDate_Text,
                "BulbTips4": RDL.Localization.canRemember_Text,
                "PageTitle": RDL.Localization.mbe_WorkHistoryTips_Tips_lbl
            },
            {
                "tips": "<li>" + RDL.Localization.needToknow_Text + "</li><li>" + RDL.Localization.expTips_ScanRsm_Text + "</li><li>" + RDL.Localization.expTips_BulletPointsImp_Text + "</li>",
                "sectionTypeCd": "EEXP",
                "name": RDL.Localization.wrkhWrkh_SecType_db,
                "defaultText": RDL.Localization.placeholder_Experience_enlargePreview,
                "definition": "Outline up to 10 years of recent work experience, beginning with your current employer. Use bullets to list your major efforts, accomplishments and experience. If you have relevant work experience from more than 10 years ago, we recommend adding a separate section called Previous Work History.",
                "title": "",
                "doczonetypecd": "BODY",
                "isDefaut": false,
                "BulbTipsDefinition": RDL.Localization.hiringManagers_Text,
                "BulbTips1": RDL.Localization.enterInfo_Text,
                "BulbTips2": RDL.Localization.useFullTitle_Textz,
                "BulbTips3": RDL.Localization.includeDate_Text,
                "BulbTips4": RDL.Localization.canRemember_Text,
                "PageTitle": RDL.Localization.mbe_WorkHistoryTips_Tips_lbl
            },
            {
                "tips": "<li>" + RDL.Localization.needToknow_Text + "</li><li>" + RDL.Localization.expTips_ScanRsm_Text + "</li><li>" + RDL.Localization.expTips_BulletPointsImp_Text + "</li>",
                "sectionTypeCd": "MILI",
                "name": RDL.Localization.wrkhWrkh_SecType_db,
                "defaultText": RDL.Localization.placeholder_Experience_enlargePreview,
                "definition": "Outline up to 10 years of recent work experience, beginning with your current employer. Use bullets to list your major efforts, accomplishments and experience. If you have relevant work experience from more than 10 years ago, we recommend adding a separate section called Previous Work History.",
                "title": "",
                "doczonetypecd": "BODY",
                "isDefaut": false,
                "BulbTipsDefinition": RDL.Localization.hiringManagers_Text,
                "BulbTips1": RDL.Localization.enterInfo_Text,
                "BulbTips2": RDL.Localization.useFullTitle_Textz,
                "BulbTips3": RDL.Localization.includeDate_Text,
                "BulbTips4": RDL.Localization.canRemember_Text,
                "PageTitle": RDL.Localization.mbe_WorkHistoryTips_Tips_lbl
            },
            {
                "tips": "<li>" + RDL.Localization.needToknow_Text + "</li><li>" + RDL.Localization.eduTips_Scan_Text + "</li><li>" + RDL.Localization.eduTips_FormatCare_Text + "</li>",
                "sectionTypeCd": "EDUC",
                "name": RDL.Localization.education_Label,
                "defaultText": "",
                "title": "",
                "definition": "Any degrees, coursework, professional development or training programs you have completed in preparation for your target job.",
                "doczonetypecd": "BODY",
                "isDefaut": true,
                "BulbTipsDefinition": RDL.Localization.ageism_Text,
                "BulbTips1": RDL.Localization.mbe_EducationTips_ListSchools_lbl,
                "BulbTips2": RDL.Localization.listSchool_Text,
                "BulbTips3": RDL.Localization.cources_Text,
                "BulbTips4": RDL.Localization.seperateSection_Text,
                "PageTitle": RDL.Localization.mbe_EducationTips_Tips_lbl
            }, {
                "tips": "",
                "title": "",
                "sectionTypeCd": "AFIL",
                "definition": "",
                "name": RDL.Localization.affil_Text,
                "defaultText": RDL.Localization.placeHolderText_affi,
                "doczonetypecd": "BODY",
                "isDefaut": false
            }, {
                "tips": "",
                "title": "",
                "sectionTypeCd": "ACCM",
                "definition": "",
                "name": RDL.Localization.accomplishments_Label,
                "defaultText": RDL.Localization.placeHolderText_accm,
                "doczonetypecd": "BODY",
                "isDefaut": false
            }, {
                "tips": "",
                "title": "",
                "sectionTypeCd": "ADDI",
                "definition": "",
                "name": RDL.Localization.addInfo_Text,
                "defaultText": RDL.Localization.placeHolderText_addi,
                "doczonetypecd": "BODY",
                "isDefaut": false
            }, {
                "tips": "",
                "title": "",
                "sectionTypeCd": "LANG",
                "definition": "",
                "name": RDL.Localization.lang_Text,
                "defaultText": RDL.Localization.placeHolderText_lang,
                "doczonetypecd": "BODY",
                "isDefaut": false
            }, {
                "tips": "",
                "title": "",
                "sectionTypeCd": "SFTR",
                "definition": "",
                "name": RDL.Localization.sftr_Text,
                "defaultText": RDL.Localization.placeHolderText_sftr,
                "doczonetypecd": "BODY",
                "isDefaut": false
            }, {
                "tips": "",
                "title": "",
                "sectionTypeCd": "INTR",
                "definition": "",
                "name": RDL.Localization.intr_Text,
                "defaultText": RDL.Localization.placeHolderText_intr,
                "doczonetypecd": "BODY",
                "isDefaut": false
            }, {
                "tips": "",
                "title": "",
                "sectionTypeCd": "CERT",
                "definition": "",
                "name": RDL.Localization.cert_Text,
                "defaultText": RDL.Localization.placeHolderText_cert,
                "doczonetypecd": "BODY",
                "isDefaut": false
            }, {
                "tips": "",
                "title": "",
                "sectionTypeCd": "ALNK",
                "definition": "",
                "name": RDL.Localization.websitePortfolios_Text,
                "defaultText": "",
                "doczonetypecd": "BODY",
                "isDefaut": false
            }, {
                "tips": "",
                "title": "",
                "sectionTypeCd": "CUST",
                "definition": "",
                "name": "",
                "defaultText": RDL.Localization.placeHolderText_addi,
                "doczonetypecd": "BODY",
                "isDefaut": false
            },
            {
                "tips": "",
                "title": "",
                "sectionTypeCd": "LNGG",
                "definition": "",
                "name": RDL.Localization.languagesTitle,
                "defaultText": "",
                "doczonetypecd": "BODY",
                "isDefaut": false,
                "BulbTipsDefinition": RDL.Localization.lang_bulb_tips_definition,
                "BulbTips1": RDL.Localization.lang_bulb_tips1,
                "BulbTips2": RDL.Localization.lang_bulb_tips2,
                "BulbTips3": RDL.Localization.lang_bulb_tips3,
                "BulbTips4": RDL.Localization.lang_bulb_tips4,
                "BulbTipsExtra": RDL.Localization.lang_bulb_tips_extra

            }
        ];
    }
    setPortalSkin();
    resourceLoaded = true;
    if (resolve)
        resolve(data);
}
window.setUpGoogleUploadDropBox = function () {
    loadJsWithKey("https://www.dropbox.com/static/api/2/dropins.js", "dropboxjs", RDL.dropBoxDriveKey);

    if (!RDL.googlePickerInfo) {
        // personal test key
        RDL.googlePickerInfo = {
            "developerKey": "AIzaSyBrCK5V3-4CF6jf0XxudVGJETxD5DNYfJo",
            "clientId": "865460071118-mp86e6c7dslk20qnqb504cjfoag79olg.apps.googleusercontent.com",
            "appId": "865460071118"
        };
    }
    loadJs("https://apis.google.com/js/api.js?onload=loadPicker");
}
window.isExcludedTraffic = function () {
    var afltTrafic = false;
    var templateFlow = RDL.GetQueryString('templateflow');
    var hiwBDFlow = RDL.GetQueryString('bdflow');
    if ((RDL.readCookie('BDLP') != null || hiwBDFlow != null) || RDL.readCookie('lp') == 'MPRUKZLP06' || templateFlow || RDL.executeBuilderStepFlow) {
        afltTrafic = true;
    }
    return afltTrafic;
}
window.checkDoNotTrackSetting = function () {
    if (window.doNotTrack == "1" || navigator.doNotTrack == "yes" || navigator.doNotTrack == "1" || navigator.msDoNotTrack == "1") {
        // Do Not Track is enabled!  
        return true;
    }
    else
        return false;
}
window.loadCSSIfNotAlreadyLoaded = function () {
    try {
        var cssLoadValue = getComputedStyle(document.documentElement).getPropertyValue('--is-css-loaded');
        if (parseInt(cssLoadValue) === 1) {
            return;
        } else {
            var isReloadedForCss = JSON.parse(sessionStorage.getItem("isReloadedForCss"));
            var isReloadedDone = JSON.parse(sessionStorage.getItem("isReloadedDone"));
            if (isReloadedForCss) {
                if (!isReloadedDone) {
                    sessionStorage.setItem("isReloadedDone", true);
                    RDL.LogError('RWZV2 Logging- CSS not found after page reload', '', true, function () { });
                }
                else {
                    RDL.LogError('RWZV2 Logging- CSS not found after manual page refresh', '', true, function () { });
                }
            } else {
                sessionStorage.setItem("isReloadedForCss", true);
                RDL.LogError('RWZV2 Logging- CSS not found page reloaded', '', true, function () {
                    window.location.reload(true);
                });
            }
        }
    }
    catch (err) {
        console.log(err + new Date());
    }
}
window.handlePostPageLoad = function () {
    var newui = RDL.GetQueryString('newui');
    if (newui) {
        RDL.modernization = true;
    }
    if (RDL.modernization) {
        document.documentElement.classList.add("e-modernization");
        if (isLocal) {
            loadStyleSheet('/build/rwzv2/stylesheets/mpr/exp-modernization.css');
        }
        else {
            loadStyleSheet('/build-resume/build/rwzv2/stylesheets/mpr/exp-modernization.css');
        }
    }
    isHandlePostPageLoadCalled = true;
    if (RDL.htmlSkinRendering) {
        if (RDL.isZtyCss) {
            loadStyleSheet(RDL.Paths.ResourcePath + 'styles/zty-skins-styles.css');
        }
        else {
            if (!isLocal) {//local css file included in index.html
                loadStyleSheet(RDL.Paths.RWZBlobUrl + 'core/css/lc-mpr-skins-styles.min.css');
            }
        }
    }
    //Load for freshchat portals only
    if (RDL.enableFreshChat == "true") {
        loadJs("https://wchat.freshchat.com/js/widget.js");
        loadJs("https://snippets.freshchat.com/js/fc-pre-chat-form-v2.js");
        loadJs(frehchatJsUrl);
    }
    if (RDL.loadSpaJs) {
        var portalCd = RDL.PortalSettings.ConfigurePortalCd.toLowerCase()
        if (isLocal) {
            loadJs(RDL.Paths.rootURL + "/ui-experimentation/" + portalCd + "/experiment-spa.js");
        }
        else {
            loadJs("/ui-experimentation/" + portalCd + "/experiment-spa.js");
        }
    }
    //Ecom Prefecth for INTL
    if (RDL.prefetchINTLECOMJS) {
        loadJs(RDL.ecomPrefetchURL);
    }

    if (RDL.enableImpactRadiusLogging) {
        //log browser DNT requests
        if (checkDoNotTrackSetting()) {
            RDL.LogError('Impact Radius Analysis Logging- do not track browser setting is enabled-desktop', '', true);
        }
        else if (RDL.GetQueryString('utm_source') && RDL.GetQueryString('utm_source').toLowerCase().indexOf('impact-radius') > -1) {
            RDL.LogError('Impact Radius Analysis Logging- impact radius utm-desktop', '', true);
        }
    }

    var isGuestUser = (RDL.UserClaims == null) ? true : (RDL.UserClaims != null && RDL.UserClaims.role == "Guest" ? true : false);
    if ((RDL.isBaseRoute && RDL.GetQueryString('mode') != 'new' && RDL.GetQueryString('welcomeback') != 1
        && RDL.GetQueryString('skin') == null && RDL.GetQueryString('docid') == null && isGuestUser) || RDL.chooseTemplateLP01Test) {
        triggerHIWStage = true;
    }
    else {
        RDL.startPageLoader();
    }
    if (RDL.isRefresh) {
        if (window.isNewOnboarding) {
            loadImageFiles();
        }
        RDL.isloggedIn = false;
        if (RDL.UserClaims) {
            if (RDL.UserClaims.role == "User") {
                RDL.isloggedIn = true;
            }
            handleAliasAndIdentify();
        }
        var visitId = RDL.readCookie("vsuid");
        AsyncSegTrack(RDL.isloggedIn, visitId);
        if (RDL.isBaseRoute) {
            RDL.TrackEvents('enter builder', {}, '', RDL.isloggedIn);
        }
        if (isGuestUser && RDL.isBaseRoute) {
            if (!isExcludedTraffic()) {
                RDL.BuilderUsageTrackEvents('viewed', 'create my resume', null, RDL.isloggedIn, null);
            }
        }
        if (RDL.GetQueryString("frmsocialsignup") == 1) {
            RDL.BuilderUsageTrackEvents('viewed', 'create my resume', null, RDL.isloggedIn, null);
        }
        if (!RDL.isLCA && !RDL.isWhiteLabel && !RDL.isZTY) {
            loadJs(platFormJsUrl, true);
        }
    }

    !RDL.chooseTemplateLP01Test && RDL.loadSvgs();
    !RDL.chooseTemplateLP01Test && RDL.loadFile();
    !RDL.loadSvgImages && RDL.loadSvgs();
    !RDL.loadHtmlFile && RDL.loadFile();
    var bodyDom = document.getElementsByTagName('body')[0];
    if (bodyDom.classList.contains('no-scroll')) {
        bodyDom.classList.remove('no-scroll')
    }
    var theme = RDL.GetQueryString('theme') ? unescape(RDL.GetQueryString('theme')) : null;
    if (theme) {
        RDL.SkinThemeFromPortal = theme.toLowerCase();
    }

    loadJs("https://www.google.com/recaptcha/api.js?render=explicit", true);
    loadJs("https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js", true, loadJqueryDepJs);
    //loadJs(RDL.Paths.ResourcePath + "scripts/es6/es6-shim.min.js", true, polyfillArrayFrom, true);
    loadJs(RDL.Paths.RWZBlobUrl + "common/js/es6-shim.min.js", true, function () { polyfillArrayFrom(); polyfillPromiseFinally(); polyfillStringTrimLeft(); polyfillStringTrimRight(); }, true);
    if (RDL.fa5Subset) {
        if (!isLocal) {//local css file included in index.html
            loadStyleSheet(RDL.Paths.RWZBlobUrl + 'core/css/desktop/fa5-subset/css/all.min.css');
        }
    }
    else {
        loadStyleSheet(RDL.Paths.ResourcePath + "styles/font-awesome-5/css/fontawesome5.min.css");
    }
    if (isIT()) {
        loadStyleSheet("https://fonts.googleapis.com/css?family=Allura|Dancing+Script|Dynalight|Mrs+Saint+Delafield&display=swap");
    } else if (RDL.isMPR) {
        loadStyleSheet("https://fonts.googleapis.com/css?family=Montserrat:400|Roboto:400,500|Roboto+Slab:300,400,700|Source+Sans+Pro:200,300,400,600,700,900&display=swap");
        if (RDL.modernization) {
            loadStyleSheet("https://fonts.googleapis.com/css?family=Roboto:900|Roboto+Slab:500&display=swap");//NEED TO USE MERGED URL DURING BASELINE
        }
    }
    applyImageCss();
    polyfillNodelistForeach();


    if (RDL.isFeaturePresent('DRPBOX')) {
        setUpGoogleUploadDropBox();
    }

    if (RDL.isloggedIn) {
        RDL.UpdatePushnami();
    }

    if (RDL.clientEventsUrl) {
        (function () {
            loadJs(RDL.clientEventsUrl + "/scripts/boldEventStream.min.js?v=2.0.0", true, function () {
                if (window.BoldEventStream) {
                    var configObj = BoldEventStream.ClassInitializers.getNewConfigurationObject();
                    configObj.AjaxDetails.eventsPostEndpointUrl = RDL.clientEventsUrl + '/' + configObj.AjaxDetails.eventsPostEndpointUrl;
                    BoldEventStream.initializeAsync(window, configObj)
                        .then(function () {
                            loadJs(RDL.clientEventsUrl + "/scripts/boldPagePerf.min.js?v=1.0.0", true, function () {
                                PerfUtil.initializeAsync(BoldEventStream);
                            });
                        })
                }
            });
        })();
    }
}
RDL.setExperimentLocalizationObject = function () {
    RDL.ExperimentsLocalization = {};
    if (RDL.portalExperiments.mprModernization) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.mprModernization.id] = {
            "loading_resume_preview": "Loading resume preview",
            "file_format_invalid_msg_html": '<div class="error-msg-title">Sorry, we don’t support that file type.</div>Choose another file, or <a class="error-msg-link" onclick="RDL.RunScratchFlow();">create a new resume</a>.',
            "unable_to_parse_resume_msg_html": '<div class="error-msg-title">Sorry, we’re unable to process this file.</div>Choose another file, or <a class="error-msg-link" onclick="RDL.RunScratchFlow();">create a new resume.</a>'
        }
    }
    if (RDL.portalExperiments.mprPagination) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.mprPagination.id] = {
            "page": "Page",
            "loading_resume_preview": "Loading resume preview",
        }
    }
    if (RDL.portalExperiments.mprTTCUI) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.mprTTCUI.id] = {
            experience_description_heading: "Nice! Now let's add the job description",
            boldAutosgst_search_btn: "SEARCH",
            boldAutosgst_search_placeholder: "Title, industry, keyword",
            boldAutosgst_search_clear_arialabel: "Clear input field",
            default_popular_jobtitle: ["Cashier", "Customer Service Representative", "Manager", "Server", "Retail Sales Associate", "Teacher", "Registered Nurse", "Receptionist", "Family Babysitter"]
        }
    }
    if (RDL.portalExperiments.mprWHImprovement) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.mprWHImprovement.id] = {
            "recent_entries": "Recent entries",
            "student_jobtitle_tip_heading": "Student is not usually used as a job title",
            "none_jobtitle_tip_heading": "{0} does not look like a job title",
            "student_jobtitle_tip_subheading": "Here are popular job titles for students:",
            "none_jobtitle_tip_subheading": "Try a popular job title instead:",
            "student_jobtitle_suggestions": "Volunteer, Nanny, Personal Assistant, Caregiver, Data Entry Clerk, Dishwasher, Family Babysitter, Line Cook, Waiter, Teacher’s Aide",
            "none_jobtitle_suggestions": "Volunteer, Intern, Cleaner, Family Babysitter, Caregiver,  Yard Worker, Cook, Stocker, Assistant, General Laborer",
            "ambiguous_jobtitle_tip_heading": "Do you want to use a more specific job title?",
            "ambiguous_jobtitle_tip_subheading": "Use a specific title to show employers what you do.",
            "experience_description_heading": "Let’s add your job description",
            "jobtitle_withslash_tip_heading": "Did you hold multiple roles at once?",
            "jobtitle_withslash_tip_subheading": "If so, it’s ok to put both here. But if you’re trying to show a promotion or changing roles, list them separately.",
            "gibberish_jobtitle_tip_heading": "We did not recognize {0} as a job title",
            "gibberish_jobtitle_tip_subheading": "Try a popular job title instead",
            "gibberish_jobtitle_suggestions": "Receptionist, Sales Associate, Cashier, Manager, Certified   Nursing Assistant, Assistant Manager, Customer Service Cashier, Supervisor",
            "no_matching_suggestion_found": "<span class='no-suggestion'>We did not recognize <b>{0}</b> as a job title</span>",
            "Experience_DescriptionHeading_witoutcompany": "What did you do ",
            "month_placeholder": "Month",
            "year_placeholder": "Year",
            "recent_locations_heading": "Recent locations:",
            "start_month_validation": "Please enter the month you started this job",
            "start_year_validation": "Please enter the year you started this job",
            "end_month_validation": "Please enter the month you left this job",
            "end_year_validation": "Please enter the year you left this job",
        }
    }
    if (RDL.portalExperiments.mprSkillInfo) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.mprSkillInfo.id] = {
            "level": "Level",
            "skill": "Skill",
            skill_place_holder: "Type your skill or choose from the left",
            skill_level_chk_label: "Show skill levels",
            skill_ddl: [{ label: "Expert", value: "5" }, { label: "Advanced", value: "4" }, { label: "Proficient", value: "3" }, { label: "Intermediate", value: "2" }, { label: "Novice", value: "1" }, { label: "Don't include level", value: "0" }],
            "infographics_heading": "Choose how your skills look",
            skill_arr: ["Novice", "Intermediate", "Proficient", "Advanced", "Expert"],
            skill_example_arr: [{ name: "Guest services", rating: "", ratingVal: 5, ratingWidth: "100%" }, { name: "Loss prevention", rating: "", ratingVal: 4, ratingWidth: "80%" }, { name: "Inventory control procedures", rating: "", ratingVal: 3, ratingWidth: "60%" }, { name: "Cash register operations", rating: "", ratingVal: 2, ratingWidth: "40%" }, { name: "Merchandising expertise", rating: "", ratingVal: 1, ratingWidth: "20%" }, { name: "Product promotions", rating: "", ratingWidth: "0%" }],
            add_custom_skill: "Add a custom skill",
            "infographics_sub_heading": "Showcase your skills with an eye-catching graphic or a bulleted list.",
            "list_style": "List Style",
            "list_style_text": "<li>Guest services</li><li>Inventory control procedures</li><li>Merchandising expertise</li>",
            "graphic_style": "Graphic Style",
            "graphic_style_text": "<li class='example-graph-item'><span>Guest services</span><span class='sliced-rect'> <span class='sliced-rect-tile ratvfill'></span> <span class='sliced-rect-tile ratvfill'></span> <span class='sliced-rect-tile ratvfill'></span> <span class='sliced-rect-tile ratvfill'></span> <span class='sliced-rect-tile ratvfill'></span> </span><span class='rating'>Expert</span></li><li class='example-graph-item'><span>Inventory control procedures</span><span class='sliced-rect'> <span class='sliced-rect-tile ratvfill'></span> <span class='sliced-rect-tile ratvfill'></span> <span class='sliced-rect-tile'></span> <span class='sliced-rect-tile'></span> <span class='sliced-rect-tile'></span> </span><span class='rating'>Intermediate</span></li>",
            "infographics_color_heading": "Color",
            "infographics_ctpreview_skill_heading": "Skills",
            "languagesTitle": "Languages",
            "language_txt_lbl": "Language",
            "lang_header": "Add your language skills",
            "lang_subheader": "Include your native language and additional languages you speak.",
            "add_new_section": "NEW !",
            "select_Label": "Select",
            "add_new_lang": "Add new language",
            "lang_level_chk_label": "Show language levels",
            "language_arr": ["Elementary", "Limited Working", "Professional Working", "Full Professional", "Native or Bilingual"],
            "language_ddl": [{ label: "Native or Bilingual", value: "5" }, { label: "Full Professional", value: "4" }, { label: "Professional Working", value: "3" }, { label: "Limited Working", value: "2" }, { label: "Elementary", value: "1" }, { label: "Don't include level", value: "0" }],
            "lang_bulb_tips1": "Elementary: Can have brief social exchanges on familiar and routine subjects that have been rehearsed.",
            "lang_bulb_tips2": "Limited Working: Can have slightly more complex conversations and speak in the past and present tenses.",
            "lang_bulb_tips3": "Professional Working: Can communicate confidently on many subjects in professional and academic settings.",
            "lang_bulb_tips4": "Full Professional: Has a strong command of language and communicates in most settings with ease.",
            "lang_bulb_tips_extra": "<li>Native or Bilingual: Comfortable with most subjects and communicates like a native speaker.</li>",
            "placeholder_language_single": "Add your languages here.",
            "skills_modal_title": "Choose how your skills look",
            "skills_modal_sub_title": "Showcase your skills with a bulleted list or an eye-catching graphic."
        }
    }
    if (RDL.portalExperiments.mpintlInfographicSkills) {        
        RDL.ExperimentsLocalization[RDL.portalExperiments.mpintlInfographicSkills.id] = {
            skill_ddl: [{ label: "6", value: "6" }, { label: "5", value: "5" }, { label: "4", value: "4" }, { label: "3", value: "3" }, { label: "2", value: "2" }, { label: "1", value: "1" }],
            skillpopuptext:[
                {"text":"Pack Office :","subText":"maîtrise"},
                {"text":"Esprit d'équipe","subText":""},
                {"text":"Excel :","subText":"utilisation professionnelle"}
            ],
            tooltiptext: "Découvrez plus de suggestions en entrant un poste ou un mot-clé différent.",
            lbl_FormatHeader: "COMPÉTENCES",
            skill:"Compétence - Niveau / informations supplémentaires (facultatif)",
            skillsHeading: "Mettez en avant vos compétences",
            skillsSubHeading: "Profitez de nos recommandations pour valoriser vos qualités personnelles, techniques et informatiques.",
            ttcSearchText: "Rechercher des compétences par poste ou par mot-clé",
            ttcSearchPlaceholder: "ex. Vendeuse",
            skill_place_holder: "Pack Office : utilisation professionnelle",
            skill_level_chk_label: "Convertir au format graphique ou texte",
            infographics_heading: "Aperçu entre format graphique et format texte.Choisissez l'option qui vous convient à l'aide du bouton vert.",
            add_custom_skill: "Ajouter une autre compétence",
            dragText: "Déplacer",
            deleteText: "Supprimer",
            resetText: "Réinitialiser",
            list_style: "FORMAT TEXTE",
            graphic_style: "FORMAT GRAPHIQUE",
            skill_example_arr: [{ name: "Accueil des clients", rating: "", ratingVal: 6}, { name: "Sens du relationnel", rating: "", ratingVal: 5}, { name: "Connaissance des terminaux de paiement électronique", rating: "", ratingVal: 3}, { name: "Service après-vente", rating: "", ratingVal: 2}, { name: "Rangement des rayons", rating: "", ratingVal: 1}, { name: "Stockage et réapprovisionnement", rating: "", ratingVal: 1},{ name: "Expertise en marchandisage", rating: "", ratingVal: 3},{ name: "Procédures d'ouverture et de fermeture du magasin", rating: "",ratingVal: 3}]
        }
    }
    if (RDL.portalExperiments.mprInfographics) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.mprInfographics.id] = {
            "level": "Level",
            "skill": "Skill",
            skill_place_holder: "Type your skill or choose from the left",
            skill_level_chk_label: "Show skill levels",
            skill_ddl: [{ label: "Expert", value: "5" }, { label: "Advanced", value: "4" }, { label: "Proficient", value: "3" }, { label: "Intermediate", value: "2" }, { label: "Novice", value: "1" }, { label: "Don't include level", value: "0" }],
            "infographics_heading": "Choose how your skills look",
            skill_arr: ["Novice", "Intermediate", "Proficient", "Advanced", "Expert"],
            skill_example_arr: [{ name: "Guest services", rating: "", ratingVal: 5, ratingWidth: "100%" }, { name: "Loss prevention", rating: "", ratingVal: 4, ratingWidth: "80%" }, { name: "Inventory control procedures", rating: "", ratingVal: 3, ratingWidth: "60%" }, { name: "Cash register operations", rating: "", ratingVal: 2, ratingWidth: "40%" }, { name: "Merchandising expertise", rating: "", ratingVal: 1, ratingWidth: "20%" }, { name: "Product promotions", rating: "", ratingWidth: "0%" }],
            add_custom_skill: "Add a custom skill",
            "infographics_sub_heading": "Showcase your skills with an eye-catching graphic or a bulleted list.",
            "list_style": "List Style",
            "list_style_text": "<li>Guest services</li><li>Inventory control procedures</li><li>Merchandising expertise</li>",
            "graphic_style": "Graphic Style",
            "graphic_style_text": "<li class='example-graph-item'><span>Guest services</span><span class='sliced-rect'> <span class='sliced-rect-tile ratvfill'></span> <span class='sliced-rect-tile ratvfill'></span> <span class='sliced-rect-tile ratvfill'></span> <span class='sliced-rect-tile ratvfill'></span> <span class='sliced-rect-tile ratvfill'></span> </span><span class='rating'>Expert</span></li><li class='example-graph-item'><span>Inventory control procedures</span><span class='sliced-rect'> <span class='sliced-rect-tile ratvfill'></span> <span class='sliced-rect-tile ratvfill'></span> <span class='sliced-rect-tile'></span> <span class='sliced-rect-tile'></span> <span class='sliced-rect-tile'></span> </span><span class='rating'>Intermediate</span></li>",
            "infographics_color_heading": "Color",
            "infographics_ctpreview_skill_heading": "Skills",
            "languagesTitle": "Languages",
            "language_txt_lbl": "Language",
            "lang_header": "Add your language skills",
            "lang_subheader": "Include your native language and additional languages you speak.",
            "add_new_section": "NEW !",
            "select_Label": "Select",
            "add_new_lang": "Add new language",
            "lang_level_chk_label": "Show language levels",
            "language_arr": ["Elementary", "Limited Working", "Professional Working", "Full Professional", "Native or Bilingual"],
            "language_ddl": [{ label: "Native or Bilingual", value: "5" }, { label: "Full Professional", value: "4" }, { label: "Professional Working", value: "3" }, { label: "Limited Working", value: "2" }, { label: "Elementary", value: "1" }, { label: "Don't include level", value: "0" }],
            "lang_bulb_tips1": "Elementary: Can have brief social exchanges on familiar and routine subjects that have been rehearsed.",
            "lang_bulb_tips2": "Limited Working: Can have slightly more complex conversations and speak in the past and present tenses.",
            "lang_bulb_tips3": "Professional Working: Can communicate confidently on many subjects in professional and academic settings.",
            "lang_bulb_tips4": "Full Professional: Has a strong command of language and communicates in most settings with ease.",
            "lang_bulb_tips_extra": "<li>Native or Bilingual: Comfortable with most subjects and communicates like a native speaker.</li>",
            "placeholder_language_single": "Add your languages here."
        }
    }
    if (RDL.portalExperiments.mprMonogram) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.mprMonogram.id] = {
            "default": "Initials",
            "select_monogram_industry": "Filter by industry",
            "monogram": "Monogram",
            "templateFiltering_monogram": "Monogram",
            "initial_icon": "Initials & Icons",
            "templateFilteringHeading_Simple": "Choose a template with initials or industry icons for a personalized look",
            "more_icons": "+ " + (RDL.monogram.monogramList.length - 4) + " More Icons",
            "show_more": "Show more",
            "show_less": "Show less",
            "all_industry": "All industries",
            "see_all_icon": "See icons for all industries",
            "choose_initials_icons": "Choose Initials & Icons (" + RDL.monogram.monogramList.length + ")"
        }
    }
    if (RDL.portalExperiments.mprJobAlerts) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.mprJobAlerts.id] = {
            "job_alert_success_message": "You created a job alert.",
            "job_alert_toggle_text": "Turn on job alert for {0} at {1}"
        }
    }

    if (RDL.portalExperiments.mprRWZTTCSortOrder) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.mprRWZTTCSortOrder.id] = {
            "mostPopular_Text": "Most Popular"
        }
    }

    if (RDL.portalExperiments.mprPayPerFeatureV2) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.mprPayPerFeatureV2.id] = {
            "popupPrintMsg": "We have sent your resume to <span class='user-email'>{@EMAIL_ID}</span> for your reference. You can continue with your print as well.",
            "popupEmailMsg": "We have sent your resume to <span class='user-email'>{@EMAIL_ID}</span>. You can send it to a different email id as well. ",
            "popupDownloadMsg": "Your resume has been downloaded. We have also sent you a copy to your email <span class='user-email'>{@EMAIL_ID}</span>.",
            "okay_lbl": "Okay"
        };
    }

    if (RDL.portalExperiments.mpintlPayPerFeature) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.mpintlPayPerFeature.id] = {
            "popupPrintMsg": "Pour information, nous avons envoyé votre CV à <span class='user-email'>{@EMAIL_ID}.</span> Vous pouvez également l'imprimer.",
            "popupEmailMsg": "Nous avons envoyé votre CV à <span class='user-email'>{@EMAIL_ID}.</span> Vous pouvez également l'envoyer à une adresse différente.",
            "popupDownloadMsg": "Votre CV à été téléchargé et enregistré dans le dossier Téléchargements. Nous vous avons également envoyé un exemplaire par e-mail à <span class='user-email'>{@EMAIL_ID}.</span>",
            "popupDownloadMsgV2": "Votre CV à été téléchargé et enregistré dans le dossier Téléchargements. Nous vous avons également envoyé un exemplaire par e-mail à <span class='user-email'>{@EMAIL_ID}.</span>",
            "okay_lbl": "OK"
        };
    }

    if (RDL.portalExperiments.mpukRegisterPageDataPrivacySection) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.mpukRegisterPageDataPrivacySection.id] = {
            "norton_privacy_title": "We’re serious about</br><b>protecting your privacy</b>",
            "norton_privacy_bullet1": "Your privacy is our #1 priority.",
            "norton_privacy_bullet2": "All your personal data is secure</br> and SSL encrypted.",
            "norton_privacy_bullet3": "We’ll never share your personal</br> data without your consent.",
            "norton_privacy_bullet4": "We’re constantly updating our </br>security to continue to keep </br> your data safe.",
            "norton_review_policy": "Review our privacy policy"
        };
    }
    if (RDL.portalExperiments.lcSkillRecommendation) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.lcSkillRecommendation.id] = {
            "Skill_Recommendation_Heading": "What job is this resume for?",
            "Skill_Recommendation_Sub_Heading": "We'll show you what skills the employer wants. Enter another job title to see the top skills for it.",
            "Skill_Recommendation_Sub_Heading_v2":"We'll show you what skills the employer wants.",
            "Skill_Recommendation_Top_4_Skills": "Here are the top 4 skills for a ",
            "Skill_Recommendation_Type_JobTitle": "Search for your desired job title to view results...",
            "Skill_Recommendation_Desired_JobTitle": "Desired Job Title",
            "Skill_Recommendation_Add_Selected_Skills": "Add Selected Skills",
        };
    }
    if (RDL.portalExperiments.SAM2) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.SAM2.id] = {
            "SAM2_choose_industry": "Choose an industry",
            "SAM2_search_industry": "Search Industry",
            "SAM2_choose_industry_subtitle": "Your industry helps us give you better advice. It won't be on your resume.",
            "SAM2_choose_responsibilities_select": "Choose responsibilities",
            "SAM2_relelated_titles": "Search related titles to see more pre-written examples",
            "SAM2_see_more": "See more",
            "SAM2_what_are_responsibility": "What kind of responsibilities did you have?",
            "SAM2_experience_industry_heading": "What industry was the ### position in?",
            "SAM2_experience_industry_sub_heading": "This helps us recommend content for your resume. The industry won’t be on your resume.",
            "SAM2_ttc_sub_heading": "Use the pre-written examples below to get started.",
            "SAM2_industry": "Industry",
            "SAM2_responsibilities": "Responsibilities",
            "SAM2_return_to": "Return to ",
            "SAM2_return_to_in": " in "
        };
    }
    if (RDL.portalExperiments.sam2_1) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.sam2_1.id] = {
            "student_jobtitle_tip_heading": "Student is not usually used as a job title",
            "none_jobtitle_tip_heading": "{0} does not look like a job title",
            "student_jobtitle_tip_subheading": "Here are popular job titles for students:",
            "none_jobtitle_tip_subheading": "Try a popular job title instead:",
            "student_jobtitle_suggestions": "Volunteer, Nanny, Personal Assistant, Caregiver, Data Entry Clerk, Dishwasher, Family Babysitter, Line Cook, Waiter, Teacher’s Aide",
            "none_jobtitle_suggestions": "Volunteer, Intern, Cleaner, Family Babysitter, Caregiver,  Yard Worker, Cook, Stocker, Assistant, General Laborer",
            "ambiguous_jobtitle_tip_heading": "Do you want to use a more specific job title?",
            "ambiguous_jobtitle_tip_subheading": "Use a specific title to show employers what you do.",
            "experience_description_heading": "Let’s add your job description",
            "jobtitle_withslash_tip_heading": "Did you hold multiple roles at once?",
            "jobtitle_withslash_tip_subheading": "If so, it’s ok to put both here. But if you’re trying to show a promotion or changing roles, list them separately.",
            "gibberish_jobtitle_tip_heading": "We did not recognize {0} as a job title",
            "gibberish_jobtitle_tip_subheading": "Try a popular job title instead",
            "gibberish_jobtitle_suggestions": "Receptionist, Sales Associate, Cashier, Manager, Certified   Nursing Assistant, Assistant Manager, Customer Service Cashier, Supervisor",
            "no_matching_suggestion_found": "<span class='no-suggestion'>We did not recognize <b>{0}</b> as a job title</span>",
            "no_industry": "No Selection",
            "jobtitle_industry_mapping": {
                "project manager": "computers and technology",
                "machine operator": "manufacturing and production",
                "shift manager": "retail",
                "licensed practical nurse": "healthcare",
                "truck driver": "transportation and distribution",
                "case manager": "social sciences",
                "photographer": "art, fashion and design",
                "marketing intern": "marketing, advertising and pr",
                "mechanic": "skilled trades",
                "paraprofessional": "education and training",
                "automotive technician": "skilled trades",
                "school bus driver": "transportation and distribution",
                "sales specialist": "personal services",
                "personal trainer": "fitness and recreation",
                "maintenance supervisor": "skilled trades",
                "designer": "computers and technology",
                "principal": "education and training",
                "regional sales manager": "retail",
                "application developer": "engineering",
                "support coordinator": "human resources",
                "technical assistant": "healthcare",
                "floater": "skilled trades",
                "senior designer": "beauty and spa",
                "hand": "skilled trades",
                "clinical research associate": "healthcare",
                "residential manager": "healthcare",
                "rf engineer": "engineering",
                "senior clerk": "government",
                "team assistant": "community and public service",
                "client coordinator": "customer service",
                "engagement specialist": "sales",
                "senior assistant": "administrative support",
            }
        }
    }
    if (RDL.portalExperiments.mpintlUpdatedTTCFlowTest) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.mpintlUpdatedTTCFlowTest.id] = {
            "updatedTTC_step1_Header": "Créez un CV facilement grâce à notre contenu pré-rédigé par nos experts.",
            "updatedTTC_step1_SubHeader": "Commençons par remplir la section Compétences.",
            "updatedTTC_step2_Header": "Indiquez un intitulé de poste",
            "updatedTTC_step2_JTPlaceholder_Text": "Vendeuse",
            "updatedTTC_step2_JTSearch_Label": "Recherchez des compétences par intitulé de poste",
            "updatedTTC_step2_ToolTip1": "Conseil : ajoutez votre intitulé de poste le plus récent et découvrez les compétences correspondantes",
            "updatedTTC_step2_ToolTip2": "Conseil : ajoutez votre dernier intitulé de poste ou essayez avec l'intitulé \"#{0}#\" pour voir nos recommendations.",
            "updatedTTC_step2_defaultJobtitle": "Vendeuse",
            "updatedTTC_step3_Header": "Choisissez les compétences que vous souhaitez ajouter à votre CV",
            "updatedTTC_step3_ToolTip": "Conseil : il est recommandé d'ajouter 6 à 8 compétences. Vous pourrez les personnaliser dès la prochaine page.",
            "updatedTTC_step4_Header": "Utilisez l'espace ci-dessous pour modifier ou ajouter vos propres compétences.",
            "updatedTTC_step4_ToolTip": "Conseil : cliquez ici pour modifier vos compétences. Vous pourrez effectuer des modifications à tout moment.",
            "updatedTTC_step5_Header": "Vous venez de terminer la section Compétences !",
            "updatedTTC_step5_SubHeader": "Utilisez désormais notre contenu pré-rédigé et nos conseils afin de compléter chaque section de votre CV.",
            "updatedTTC_CNTC_Header": "Remplissez vos coordonnées avant de continuer",
            "updatedTTC_CNTC_SubHeader": "Il est recommandé d'indiquer au moins une adresse e-mail et un numéro de téléphone."
        };
    }

    if (RDL.portalExperiments.mprTTCEarly) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.mprTTCEarly.id] = {
            "next_heading": "NEXT: HEADING",
            "skip_for_now": "SKIP FOR NOW",
            "skip_skill_heading": "Are you sure you don’t want to add skills? ",
            "skip_skill_content": "Including skills on your resume is a great way to quickly show employers you’re a match for the job.<br/> <br/> It can even help get you an interview!",
            "enter_jobtitle_heading": "Enter a job title so we can find the best skills for you",
            "jobtitle_sub_heading": "You can add your own skills on the next page too.",
            "job_title_examples": "Here are some example job titles",
            "skil_ttc_search_placeholder": "Cashier",
            "tool_tip_jobtitle": "<h1 class='tooltip-title'>Find the best skills</h1><h2 class='tooltip-description'>Just enter a job title to see what skills recruiters are looking for.</h2>",
            "tool_tip_ttc_jobtitle": "<h1 class='tooltip-title'>Search for more skills</h1><h2 class='tooltip-description'>You can enter another job title to see different skills</h2>",
            "tool_tip_ttc": "<h1 class='tooltip-title'> Add skills with a click</h1><h2 class='tooltip-description'>Choose skills that match your background.</h2>",
            "ttc_label": "Here are some popular skills to get you started",
            "msg_gibberish": "We did not recognize <b>[@USER_INPUT]</b> as a job title. <br />Check your spelling or try the popular pre-written examples below.",
            "msg_confidence_high": "Showing results for <b>[@JOB_TITLE]</b>.",
            "msg_confidence_medium": "Showing results for <b>[@JOB_TITLE]</b>. <br />No results for <b>[@USER_INPUT]</b>. Try the pre-written examples below. Or search for something else.",
            "msg_confidence_low": "Did you mean <b>[@JOB_TITLE]</b>? <br />We did not find results for <b>[@USER_INPUT]</b>. Use the pre-written examples below. Or check your spelling and try again.",
            "popularJobTitles": ["customer service representative", "sales associate", "cashier", "registered nurse", "administrative assistant", "server", "marketing coordinator", "receptionist", "teacher", "project manager", "waitress"],
            "skill_sub_heading": "We recommend including 4-8 skills altogether.",
        }
    }
    if (RDL.portalExperiments.fuzzyV3) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.fuzzyV3.id] = {
            "next_heading": "NEXT: HEADING",
            "skip_for_now": "SKIP FOR NOW",
            "skip_skill_heading": "Are you sure you don’t want to add skills? ",
            "skip_skill_content": "Including skills on your resume is a great way to quickly show employers you’re a match for the job.<br/> <br/> It can even help get you an interview!",
            "enter_jobtitle_heading": "Enter a job title so we can find the best skills for you",
            "jobtitle_sub_heading": "You can add your own skills on the next page too.",
            "job_title_examples": "Here are some example job titles",
            "skil_ttc_search_placeholder": "Cashier",
            "tool_tip_jobtitle": "<h1 class='tooltip-title'>Find the best skills</h1><h2 class='tooltip-description'>Just enter a job title to see what skills recruiters are looking for.</h2>",
            "tool_tip_ttc_jobtitle": "<h1 class='tooltip-title'>Search for more skills</h1><h2 class='tooltip-description'>You can enter another job title to see different skills</h2>",
            "tool_tip_ttc": "<h1 class='tooltip-title'> Add skills with a click</h1><h2 class='tooltip-description'>Choose skills that match your background.</h2>",
            "ttc_label": "Here are some popular skills to get you started",
            "lbl_gibberish": "Search for pre-written examples",
            "msg_gibberish": "<span class='search-check-suggestion ttc-search-suggestions'>Check your spelling or try the popular pre-written examples below.</span><span class='search-showing-results ttc-search-suggestions'>We did not recognize <b>[@USER_INPUT]</b> as a job title. </span>",
            "lbl_confidence_high": "Search for pre-written examples",
            "msg_confidence_high": "<span class='search-showing-results ttc-search-suggestions'>Showing results for <b>[@JOB_TITLE]</b><span>",
            "lbl_confidence_medium": "Search for pre-written examples",
            "msg_confidence_medium": "<span class='search-check-suggestion ttc-search-suggestions'>Try the pre-written examples below. Or search for something else.</span><span class='search-showing-results ttc-search-suggestions'>Showing results for <b>[@JOB_TITLE]</b></span>",
            "lbl_confidence_low": "Search for pre-written examples",
            "msg_confidence_low": "<span class='search-check-suggestion ttc-search-suggestions'>We did not find results for <b>[@USER_INPUT]</b>. Use the pre-written examples below. Or check your spelling and try again.</span><span class='search-showing-results ttc-search-suggestions'>Showing results for <b>[@JOB_TITLE]</b></span>",
            "popularJobTitles": ["customer service representative", "sales associate", "cashier", "registered nurse", "administrative assistant", "server", "marketing coordinator", "receptionist", "teacher", "project manager", "waitress"],
            "skill_sub_heading": "We recommend including 4-8 skills altogether.",
            "placeholder_confidence_low": "Ex: Cashier",
            "placeholder_confidence_medium": "Ex: Cashier",
            "placeholder_gibberish": "Ex: Cashier",
            "placeholder_confidence_high": "Ex: Cashier",


        }
    }
    if (RDL.portalExperiments.mpIntlTTCFuzzyLogic) {
        if (RDL.portalExperiments.mpIntlTTCFuzzyLogic.id == "54e5fe17-fcb7-4f63-9743-a05a126e3731") {
            RDL.ExperimentsLocalization[RDL.portalExperiments.mpIntlTTCFuzzyLogic.id] = {
                "lbl_gibberish": "Rechercher des descriptions par intitulé de poste",
                "msg_gibberish": "<span class='search-check-suggestion ttc-search-suggestions'><b>[@USER_INPUT]</b> n'a pas été reconnu dans notre liste d'intitulés de poste.</span><span class='search-showing-results ttc-search-suggestions'>Vérifiez l'orthographe ou choisissez parmi nos phrases prêtes à l'emploi ci-dessous.</span>",
                "lbl_confidence_high": "Rechercher des descriptions par intitulé de poste",
                "msg_confidence_high": "<span class='search-showing-results ttc-search-suggestions'>Résultats pour <b>[@JOB_TITLE]</b><span>",
                "lbl_confidence_medium": "Rechercher des descriptions par intitulé de poste",
                "msg_confidence_medium": "<span class='search-check-suggestion ttc-search-suggestions'>Aucun résultat pour <b>[@USER_INPUT]</b>. Essayez une de nos phrases prêtes à l'emploi ci-dessous ou essayez avec un mot différent.</span><span class='search-showing-results ttc-search-suggestions'>Résultats pour <b>[@JOB_TITLE]</b></span>",
                "lbl_confidence_low": "Rechercher des descriptions par intitulé de poste",
                "msg_confidence_low": "<span class='search-check-suggestion ttc-search-suggestions'>Nous n'avons pas trouvé de résultat pour <b>[@USER_INPUT]</b>. Vous pouvez utiliser une de nos phrases prêtes à l'emploi ci-dessous ou vérifier l'orthographe et essayer à nouveau.</span><span class='search-showing-results ttc-search-suggestions'>Résultats pour <b>[@JOB_TITLE]</b></span>",
                "placeholder_confidence_low": "Recherche par secteur ou mot-clé",
                "placeholder_confidence_medium": "Recherche par secteur ou mot-clé",
                "placeholder_gibberish": "Recherche par secteur ou mot-clé",
                "placeholder_confidence_high": "Recherche par secteur ou mot-clé"
            }
        }
    }
    if (RDL.portalExperiments.mprRWZInfographicLangUS) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.mprRWZInfographicLangUS.id] = {
            "add_new_lang": "Add new language",
            "lang_level_chk_label": "Show language levels",
            "lang_format_popup_header": "Choose how your languages look",
            "lang_graphic_lbl": "Graphic style",
            "lang_list_lbl": "List style",
            "lang_format_popup_sub_header": "Showcase your languages with a bulleted list or an eye-catching graphic.",
            "lang_infographic_option_header": "Language levels"
        }
    }
    if (RDL.portalExperiments.mprRWZInfographicLangROW) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.mprRWZInfographicLangROW.id] = {
            "add_new_lang": "Add new language",
            "lang_level_chk_label": "Show language levels",
            "lang_format_popup_header": "Choose how your languages look",
            "lang_graphic_lbl": "Graphic style",
            "lang_list_lbl": "List style",
            "lang_format_popup_sub_header": "Showcase your languages with a bulleted list or an eye-catching graphic.",
            "lang_infographic_option_header": "Language levels"
        }
    }
    if (RDL.portalExperiments.mpfrNewFieldsTest) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.mpfrNewFieldsTest.id] = {
            "typeOfContractLabel": "Type de contrat",
            "typeOfContractPtext": "ex. CDD",
            "monthPlaceholder": "Mois",
            "yearPlaceholder": "Année",
            "lbl_LangLevel": "Niveau",
            "infographicOptionHeader": "Affichage de vos compétences linguistiques",
            "infographicOptionSubheader": "Sélectionnez entre format graphique et format texte",
            "lbl_Language": "Langue",
            "lbl_adif": "Informations supplémentaires",
            "adif_placeholder": "ex. 6 mois d'échange universitaire à Londres, TOEIC...",
            "addAnotherLang": " Ajouter une autre langue",
            "langFormatPopupHeader": "Aperçu entre format graphique et format texte.<br/> Choisissez l'option qui vous convient à l'aide du bouton vert.",
            "formatGraphic": "FORMAT GRAPHIQUE",
            "formatText": "FORMAT TEXTE",
            "langRedesign_subheader": "Ajoutez les langues pertinentes pour le poste auquel vous postulez.",
            "lbl_FormatHeader": "Langues",
            "lbl_honours": "Mention",
            "placeholder_honours": "ex. Mention bien",
            "lbl_currentlyEnrolled": "Je travaille actuellement ici",
            "lbl_grad_currentlyEnrolled": "En cours",
            "grad_in_progress_text": "En cours",
            "start_year_required": "Saisissez une année de début.",
            "end_year_required": "Saisissez une année de fin.",
            "Graduation_Expected": "Prévu en ",
            "start_month_required": "Saisissez une mois de début.",
            "end_month_required": "Saisissez une mois de fin.",
            "dob_resume_label": "Âge",
            "web_resume_label": "Site Web",
            "available_resume_label": "Autre",
            "martial_status_resume_label": "Statut marital",
            "permit_resume_label": "Permis",
            "label_socialLinkLabel": "LinkedIn / Autre site",
            "DOB_Text": "Âge / Date de naissance",
            "IDNumber_Text": "Permis de conduire / Véhiculé",
            "IDNumberPlaceholder_Text": "ex. Permis B - Véhiculé",
            "nationality_Text": "Nationalité",
            "maritalStatus_Text": "Situation familiale",
            "additionalInfoTitle": "INFORMATIONS SUPPLÉMENTAIRES",
            "additionalInfoSubTitle": "Ajoutez uniquement les informations pertinentes pour votre CV",
            "dobFieldPlaceholder": "ex. 24 ans",
            "nationalityFieldPlaceHolder": "ex. Française",
            "martialStatusPlaceHolder": "ex. célibataire",
            "socialLinkPlaceholderText": "ex. www.linkedin.com/in/alexandra.dupont",
            "availabilityFieldLabel": "Disponibilité / Mobilité/ Autre",
            "availabilityFieldPlaceHolder": "ex. Disponible dès maintenant",
            "additionalInfoMoreTitle": "(Facultatif)",
        }
    }
    if (RDL.portalExperiments.featureGateTTC) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.featureGateTTC.id] = {
            "basic": "Basic",
            "basic_tip": "Gives you access to 4 <b>Basic</b> templates and limited support while building your resume.",
            "premium": "Premium",
            "premium_tip": "<b>Premium</b> gives you access to unlimited templates that will get you noticed by employers. Plus unlimited resume building support.",
            "premium_free_bullet_points_heading": "You’ve used all of your free pre-written bullet points.",
            "unlock_premium": "Unlock Premium",
            "upgrade_unlock_premium": "Unlock premium",
            "keep_premium": "Keep Premium",
            "use_basic_instead": "Use Basic Instead",
            "premium_benefit_question": "What do I get with Premium?",
            "create_bullet_points_description": "Create your own bullet points by typing directly into the box on the right. Or, upgrade to Premium today and unlock all of our pre-written bullet points, as well as more great premium features.",
            "unlock_bullet_points_heading": "You’ve used all of your free bullet points. Unlock all bullet points by upgrading to premium. ",
            "premium_access": "Premium Access",
            "premium_benefits": "Premium gives you access to unlimited resume building support that will get you noticed by employers.<br/><br/><b>It includes:</b>",
            "premium_benefits_bullet_points": "<li>Unlimited pre-written bullet points</li>\n <li>Unlimited templates</li>\n <li>Unlimited cover letters</li>"
        }
    }
    if (RDL.portalExperiments.mpintlSideTemplateFilterOptions) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.mpintlSideTemplateFilterOptions.id] = {
            "filterMainHeading": "Filtrar plantillas por:",
            "photo": "Foto",
            "resetFilters": "Reiniciar filtros",
            "CVsWithPhoto": "CV con foto",
            "CVswithoutPhoto": "CV sin foto",
            "Format": "Diseño",
            "singleCol": "1 columna",
            "multiCol": "2 columnas"
        }
    }
    if (RDL.portalExperiments.mprRWZPersonalizedTipsV1) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.mprRWZPersonalizedTipsV1.id] = {
            "educ_page_student_tip_heading": "Your coursework matters",
            "educ_page_student_tip_subheading": "You can include coursework below if it's relevant to your career goals.",
            "educ_page_early_tip_heading": "Do you have a college degree?",
            "educ_page_early_tip_subheading": "If you do, you don't need to include your high school diploma or GED.",
            "educ_page_mid_tip_heading": "Include your professional training",
            "educ_page_mid_tip_subheading": "If you have any professional training, add it to the section below.",
            "educ_page_late_tip_heading": "Leave out the dates",
            "educ_page_late_tip_subheading": "If you graduated 10+ years ago, you can leave out your graduation year.",
            "educ_field_TTC_tip_heading": "Consider your coursework",
            "educ_field_TTC_tip_subheading": "If you haven't finished a degree, you can enter relevant coursework below.",
            "WH_page_student_tip_heading": "All your experience counts",
            "WH_page_student_tip_subheading": "Early in your career, you can include internships, residencies, and volunteer work too.",
            "WH_page_early_tip_heading": "All your experience counts",
            "WH_page_early_tip_subheading": "Early in your career, you can include internships, residencies, and volunteer work too.",
            "WH_page_mid_tip_heading": "How did you make a difference?",
            "WH_page_mid_tip_subheading": "Show how you changed things, saved time or money, or sped up a process.",
            "WH_page_late_tip_heading": "Focus on recent job history",
            "WH_page_late_tip_subheading": "It's usually best to focus on your resume on the last 10-12 years of your experience.",
            "WH2_page_student_tip_heading": "Show how you grew",
            "WH2_page_student_tip_subheading": "Focus on how you developed new skills or made an impact.",
            "WH2_page_early_tip_heading": "Go beyond your daily tasks",
            "WH2_page_early_tip_subheading": "Focus on your accomplishments, qualifications, and knowledge.",
            "WH2_page_mid_tip_heading": "Get specific",
            "WH2_page_mid_tip_subheading": "Include specific details that show the successful results of what you worked on.",
            "WH2_page_late_tip_heading": "Use numbers to show your impact",
            "WH2_page_late_tip_subheading": "Did you work on a lot of projects, or save time or money? Add how many and how much.",
            "WH2_field_search_tip_heading": "Expand your search",
            "WH2_field_search_tip_subheading": "Try searching for a similar job title similar to see more examples.",
            "WH2_field_TTC_present_tip_heading": "Use the present tense",
            "WH2_field_TTC_present_tip_subheading": 'Write about your current jobs in the present tense. For example, "oversee," not "oversaw."',
            "WH2_field_TTC_past_tip_heading": "Use the past tense",
            "WH2_field_TTC_past_tip_subheading": 'Write about previous jobs in the past tense. For example, "managed," not "manage."',
            "cntc_field_email_tip_heading": "Make a great impression",
            "cntc_field_email_tip_subheading": "Use an email address that sounds professional, like your name or initials.",
            "skills_page_student_tip_heading": "Focus on hard skills",
            "skills_page_student_tip_subheading": "Hard skills can be learned, like, computer programming, and a language or writing.",
            "skills_page_early_tip_heading": "Add 4-8 skills",
            "skills_page_early_tip_subheading": "Based on your experience level, we suggest including 4-8 skills",
            "skills_page_mid_tip_heading": "Add up to 10 skills",
            "skills_page_mid_tip_subheading": "Based on your experience level, we suggest including up to 10 skills",
            "skills_page_late_tip_heading": "Add up to 12 skills",
            "skills_page_late_tip_subheading": "Based on your experience level, we suggest including up to 12 skills",
            "skills_field_search_tip_heading": "Match your skills to the job",
            "skills_field_search_tip_subheading": "If you have a specific job in mind, use that title to see in-demand skills for it.",
            "summary_page_student_tip_heading": "Sum it up",
            "summary_page_student_tip_subheading": "Get noticed with a short summary that brings your skills and qualifications together.",
            "summary_page_mid_tip_heading": "Bring it all together",
            "summary_page_mid_tip_subheading": "Use your summary to quickly show employers that you're right for the job.",
            "summary_page_late_tip_heading": "Show you're right for the job",
            "summary_page_late_tip_subheading": "Make sure your summary highlights experience that matches the type of job you want.",
            "summary_field_search_tip_heading": "Find the right words",
            "summary_field_search_tip_subheading": "Not sure what to write? Enter a job title to see pre-written summary examples.",
        }
    }
    if (RDL.portalExperiments.mpukEnterNameChooseTemplate) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.mpukEnterNameChooseTemplate.id] = {
            "ChoseTemplatePage_name_title": "What do you want your CV to look like?",
            "ChoseTemplatePage_name_subheading": "Enter your name and select a CV template that suits your style - try now"
        }
    }

    if (RDL.portalExperiments.mprEducationTips) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.mprEducationTips.id] = {
            "addDescEducationTips": "Add more information about your education",
            "EducTipsPlaceHolderText": "Start typing your description, or add pre-written options from the left",
            "addingGPA_heading": "Consider adding your GPA",
            "addingGPA_subHeading": "Include your GPA if it's high (at least above 3.0) as well as any honors and relevant coursework.",
            "removeHighSchool_heading": "Consider removing high school",
            "removeHighSchool_subHeading": "If you're enrolled in college or have your degree, you can remove high school from your resume.",
            "studentExperience_heading": "Move up your education section",
            "studentExperience_subHeading": "We suggest students highlight their education near the top of their resume. Use this tool to move this section higher on the page.",
            "enrolledInSchool_heading": "Move up your education section",
            "enrolledInSchool_subHeading": "We suggest students highlight their education near the top of their resume. Use this tool to move this section higher on the page.",
            "lastJobStudent_heading": "Move up your education section",
            "lastJobStudent_subHeading": "We suggest students highlight their education near the top of their resume. Use this tool to move this section higher on the page.",
            "lastJobIntern_heading": "Move up your education section",
            "lastJobIntern_subHeading": "We suggest recent interns highlight their education near the top of their resume. Use this tool to move this section higher on the page.",
            "onlyOneWorkExpr_heading": "Move up your education section",
            "onlyOneWorkExpr_suHeading": "We suggest candidates with limited work experience highlight their education near the top of their resume. Use this tool to move this section higher on the page.",
        }
    }

    if (RDL.portalExperiments.mprUserIntentExperimentForDesktop) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.mprUserIntentExperimentForDesktop.id] = {
            "userIntent_page_title": "Let's get started! How can we help you today?",
            "userIntent_page_sub_title": "Choose as many as apply to you. Don't worry though, we'll cover all your resume needs.",
            "userIntent_list_title": '"I need help making my resume…"',
            "userIntent_skip_question": "Skip question",
            "userIntent_modal_title": "I need help making my resume…",
            "userIntent_modal_add": "ADD",
            "userIntent_modal_placeholder": "Type your answer here",
            "userIntent_PageTitle": "User Intent - ",
            "userIntent_otherLabel": "Other",
            "userIntentHelpOptions": [
                "be visually appealing",
                "meet industry standards",
                "fit a specific job",
                "showcase my skills",
                "highlight my achievements",
                "have the right content",
                "be well-written"
            ]
        }
    }

    if (RDL.portalExperiments.mpukPersonalizationFilterTest) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.mpukPersonalizationFilterTest.id] = {
            "chooseBestTemplateExprLevel": "Choose from our best templates for <b>{0} experience</b>",
            "entryLevelSubHeading": "These are the best templates for your level because they demonstrate your marketable skills and abilities in a creative, concise document.",
            "midLevelSubHeading": "These are the best templates to showcase your expertise and skills in a creative, functional one-page document.",
            "seniorLevelSubHeading": "These are the best templates for your level because they highlight your long-standing accomplishments in a well-organised, concise document.",
            "recriter_Approved_templates": "Choose from our whole collection of recruiter-approved templates",
            "criteriaNoTemplates": "We don't have templates with the criteria you selected. Please try different filters.",
            "selectMostPopular": "Or select from our most popular templates below.",
            "photo": "Photo",
            "noPhoto": "No photo",
            "blackWhite": "Black and White",
            "singleColumn": "1-column",
            "multiColumn": "2-columns",
            "clearFilters": "Clear filters",
            "workExperLevel": "What is your work experience level?",
            "recommBestTemplate": "We’ll recommend the best templates for your level.",
            "entryLevel": "Entry level",
            "midLevel": "Mid level",
            "seniorLevel": "Senior level",
            "viewBy": "View By"
        }
    }
    if (RDL.portalExperiments.mprRwzDesktopUploadResumeVisualImprovements) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.mprRwzDesktopUploadResumeVisualImprovements.id] = {
            "file_format_invalid_msg": 'Sorry, we don’t support that file type. Choose another file, or <a class="error-msg-link" onclick="RDL.RunScratchFlow();">create a new resume.</a>',
            "unable_to_parse_resume_msg": 'Sorry, we’re unable to process this file. Choose another file, or <a class="error-msg-link" onclick="RDL.RunScratchFlow();"> create a new resume.</a>',
        };
    }
    if (RDL.portalExperiments.mpintlCountryRowSelectorTest) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.mpintlCountryRowSelectorTest.id] = {
            "country_label": "Country",
            "select_country_label": "Select a Country",
            "select_country_page_title": "Where are you focusing your job search?",
            "select_country_page_sub_title": "We'll recommend the right templates for your target  country.",
            "search_country_label": "Search Country",
            "see_templates_txt": "See templates",
            "select_country_pageTitle": "Select Country - ",
            "templateFiltering_Recommended": "Recommended",
            "heading_Recommended": "Choose from our <b>best templates</b> for {0}"
        }
    }
    if (RDL.portalExperiments.mprRWZPerfectParserMessagingTest2) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.mprRWZPerfectParserMessagingTest2.id] = {
            "perfectParser_PageTitle": "Resume Notifications - ",
            "perfectParser_tag": "RECOMMENDED FOR JOB SEEKERS!",
            "perfectParser_v1_heading": "Great choice. This resume template is optimized with Smart Apply<sup>TM</sup> technology to <span class='text-highlight'>get you more interviews.</span>",
            "perfectParser_v2_heading": "Great choice. Your resume template is optimized with technology to <span class='text-highlight'>get past resume screening software</span> used by employers.",
            "perfectParser_v3_heading": "Great choice. Your resume template is optimized with technology to <span class='text-highlight'>get past resume screening software</span> used by employers.",
            "perfectParser_v4_heading": "Next, make sure your resume can <span class='text-highlight'>get past the resume screening software</span> and be seen by employers",
            "perfectParser_v1_subHeading": "Employers use software to read, filter and rank resumes.  Smart Apply<sup>TM</sup> ‒ available only from MyPerfectResume ‒ gives your resume the best chance of getting in front of hiring managers with:",
            "perfectParser_v2_subHeading": "Our unique technology optimizes skills, keywords and other sections on your resume so that you rank more highly than other job seekers.",
            "perfectParser_v3_subHeading": "After completing your resume, you can set your preferences and get notified when your resume is processed by resume screening software.",
            "perfectParser_v4_subHeading": "Enhance your resume template with our new technology",
            "perfectParser_tellmemore_text": "Tell me more",
            "perfectParser_opt_in": "Yes, optimize my resume for resume screening software",
            "perfectParser_opt_out": "No thanks, I won't be applying to jobs online",
            "perfectParser_tellmemore_hover_text": "Employers use screening software to “read” resumes before they’re seen by human decision makers. Our exclusive technology ensures your resume can get past the machines and into the hands of a hiring manager and is designed to optimize your resume structure and content. We do our best to advantage you in creating the best resume, however we cannot guarantee your results. You make all final decisions as to your resume. In addition, some employers and others receiving your resume might not have access to our technology or have it implemented properly; therefore not all functionality described here may apply.",
            "perfectParser_lets_continue_v1": "Now, let’s continue building your optimized resume!",
            "perfectParser_lets_continue_v2": "Now, let’s continue building your resume!",
            "perfectParser_lets_continue_v3": "Now, let’s continue building your resume!",
            "perfectParser_v1_feature_list": "<li class=\"list-bullet-item\">Perfect resume readability</li><li class=\"list-bullet-item\">Better job matching</li><li class=\"list-bullet-item\">Higher resume rankings</li>"
        }
    }

    if (RDL.portalExperiments.mpukChooseTemplateCategoriesTest) {
        RDL.ExperimentsLocalization[RDL.portalExperiments.mpukChooseTemplateCategoriesTest.id] = {
            "ct_load_more"  :"Load More",
            "ct_back_to_top":"Back to top",
            "templateFiltering_Popular": "Popular",
            "templateFiltering_Traditional" : "Traditional"
        };
    }
}
window.handleJSCSS = function (data) {
    try {
        if (data.hotFixJS) {
            eval(data.hotFixJS);
        }
        if (data.hotFixCSS) {
            var css = document.createElement('style');
            css.type = 'text/css';
            css.innerHTML = data.hotFixCSS;
            document.getElementsByTagName("head")[0].appendChild(css);
        }
    }
    catch (ex) {
        console.log(ex);
    }
}
window.setPortalSkin = function () {
    var sknCD = RDL.GetQueryString('skin');
    if (sknCD) {
        var isValidSkin = false;
        if (RDL.skins && RDL.skins.length > 0) {
            isValidSkin = RDL.skins.some(function (element) { return element.skinCD == sknCD.toUpperCase() });
        }
        if (isValidSkin) {
            RDL.SkinFromPortal = sknCD.toUpperCase(); //necessary to keep it in upper case
            RDL.getTemplateFromSkin(RDL.SkinFromPortal); // load skin htm file
        }
    }
}
window.updateRDLWithConfiguration = function (data) {

    var gtmKey1 = data.gtmKey1,
        gtmKey2 = data.gtmKey2,
        googleMapappendGTMQueryStringsKey = data.googleMapappendGTMQueryStringsKey,
        gaKey = data.gaKey;
    Object.assign(RDL.Portal, { gtmKey1: gtmKey1, gtmKey2: gtmKey2, googleMapappendGTMQueryStringsKey: googleMapappendGTMQueryStringsKey, gaKey: gaKey });
    Object.assign(RDL.Paths, data.externalLinks,
        {
            BaseUrl: data.externalLinks.dashboardLink,
            privacyURL: data.externalLinks.privacyPolicyLink,
            SellPageUrl: data.externalLinks.paymentLink,
            AccountsURL: data.externalLinks.accountsURL,
            termsOfUseURL: data.externalLinks.termsOfUseLink,
            ResumeCheckUrl: data.externalLinks.resumeCheckUrl,
            contactUsURL: data.externalLinks.contactusLink,
            mysettingsURL: data.externalLinks.mysettingLink,
            payPerFeatureJSURL: data.externalLinks.payPerFeatureJSURL,
            notificationJSURL: data.externalLinks.notificationJSURL
        });
    Object.assign(RDL.PortalSettings, {
        defaultPortalType: "3",
        ConfigurePortal: data.portalID,
        ConfigurePortalCd: data.portalCD,
        ConfigureProductId: data.productID,
        ConfigureProductCd: data.productCD,
        ConfigurePortalName: data.portalName,
        ConfigureClientCd: data.clientCD,
        ShareResumeURL: data.externalLinks.shareUrl
    });
    Object.assign(RDL.VisitorApiSetting, {
        JSURL: data.externalLinks.visitorAPIUrl,
        PRODUCT_CODE: data.productCD
    });

    Object.assign(RDL, data,
        {
            oldUrl: data.externalLinks.oldEditorUrl && data.externalLinks.oldEditorUrl.trim() != "" ? data.externalLinks.oldEditorUrl : null,
            BestJobMatchDelayTime: data.bestJobMatchDelayTime,
            facebookClientID: data.facebookAppId,
            isTTCAddOrRemove: true,
            templateId: RDL.Portal.templateId ? RDL.Portal.templateId : "-3",
            steps: data.steps ? data.steps : undefined,
            styleSheetName: data.styleSheetName ? data.styleSheetName : "RbtoHtml2",
            configServiceBlobUrl: data.externalLinks.configSvcBlobUrl,
            CoverLetterUrl: data.externalLinks.coverLetterUrl,
            RenewSuspendedSubscription: data.externalLinks.paymentLink,
            ResumeReviewUrl: data.externalLinks.resumeReviewUrl,
            ResumeWritingUrl: data.externalLinks.resumeWritingUrl,
            IsLCSEOFlow: false,
            DebounceTime: data.googleMapsDebounceTime ? parseInt(data.googleMapsDebounceTime) : 0,
            cultureCD: data.languageCulture,
            isDegreeDataLocal: data.isDegreeDataLocal || false,
            showContactExtraDetails: data.enableAdditionalFields || false,
            clientEventsUrl: data.externalLinks.clientEventsUrl,
            date: (new Date(2017, 10, 23)),
            randomPhotoNumber: Math.random(),
            UserConsent: true,
            dropBoxDriveKey: data.dropBoxAPI && data.dropBoxAPI.key ? data.dropBoxAPI.key : 'qpw0ky3psxs3hsz', // personal test key :'qpw0ky3psxs3hsz'; 
            googlePickerInfo: data.googlePickerAPI,
            isNewV3: data.EnableV3Exp
        }
    );
    Object.assign(RDL, {
        chooseTemplateLP01Test: isFR() && RDL.templateCarouselLPFlow && !RDL.isCreateNew // LP experiment
    });

    if (RDL.localizeDefinitionTips)
        Object.assign(RDL, {
            Definition_Tips: data.definition_tips,
            intlPhotoSkins: "ATA1 MTA3 MCA2 MLU4 MLU6 MLU5 MLU7 MLF1 MLF2 MLF3 MLF4 MLF5 MLF6 MLI1 MLJ1 MLJ2 MLJ3 MLJ4 MLJ5 MLJ6 MLJ7 MLI6 MLK1 MLK3 MLK5 MLK6 MLK7 MLK8 MLM6 MLM7 MLM8 MLD2 MLD1 MLD6",
            roundPhotoSkins: "MLJ2 MLJ5 MLK7",
            PopularSkins: data.popularSkins || " ",
            NewSkins: data.newSkins || " ",
        });
    if (data.templateId)
        Object.assign(RDL, {
            templateId: data.templateId
        });
    if (!RDL.UserConsent)
        Object.assign(RDL, {
            UserConsent: document.cookie.search(/consent=1/) > -1
        });
}
window.getBuilderStep = function () {
    var builderStep = RDL.GetQueryString('builderstep');
    if (builderStep) {
        if (isIPAD() && builderStep == 'selectresume') {
            builderStep = "contact";
        }
        else if (builderStep == 'finalize') {
            builderStep = "addsection";
        }
        RDL.createCookie('builderstep', builderStep.toLowerCase(), null);
    }
    return builderStep;
}
window.getAdminUiExperiments = function () {
    var adminUIExperiments = [];
    for (var i in RDL.portalExperiments) {
        RDL.portalExperiments[i].isVisitor == true ? adminUIExperiments.push([i, RDL.portalExperiments[i]]) : "";
    }
    RDL.ExperimentInfo = RDL.ExperimentInfo || [];
    var exprData = localStorage.getItem("uiexp_conducted_experiments");
    if (exprData) {
        var exprVal = JSON.parse(exprData);
        if (exprVal) {
            adminUIExperiments.forEach(function getVariant(experiment) {
                var exprObjectName = experiment[0];
                var experiment = experiment[1];
                var experimentIndex = exprVal[experiment.id] ? exprVal[experiment.id].variant : -1;
                if (experimentIndex > -1) {
                    var exprVariantName = "Baseline";
                    if (experimentIndex == 2)
                        exprVariantName = "Variability Estimator";
                    else if (experimentIndex > 2)
                        exprVariantName = experiment.variants ? experiment.variants[experimentIndex] : "";
                    RDL.ExperimentInfo.push({
                        experimentId: experiment.id, experimentName: experiment.name, variant: experimentIndex, variantName: exprVariantName
                        , isGoverned: exprVal[experiment.id] ? exprVal[experiment.id].isGoverned : false
                    });
                }
            });
        }
    }
}
window.handleConfig = function (result, resolve) {
    var data = JSON.parse(result);
    RDL.showLinksInResumeHeading = !!RDL.isINTL; //Separating ALNK from Contact Section in Renderer
    RDL.portalExperiments = {};
    handleJSCSS(data);
    updateRDLWithConfiguration(data);
    RDL.setExperimentLocalizationObject();
    segmentKey = data.segmentKey;
    //MPINTL-1588 : returning user experiment
    RDL.returnUserExperimentVariant = RDL.readCookie("isReturningVariant") == "true";
    if (data.enableNewRelic) {
        addNewRelic(data.newRelicApplicationID, data.sampleDenominator);
    }
    // if (RDL.isES && data.enableFreshChat == true) {
    //     RDL.freshChatToken = data.freshChatToken;
    //     RDL.freshChatTag = data.freshChatTag;
    // }
    RDL.executeBuilderStepFlow = RDL.isBaseRoute && !!getBuilderStep() && data.enableDirectFlow;
    var templateFlow = RDL.GetQueryString('templateflow');
    var docID = RDL.GetQueryString('docid')
    if (templateFlow && templateFlow.toLowerCase() == 'contact' && docID) {
        RDL.executeBuilderStepFlow = false;
    }

    if (!RDL.useContentBlobForSVGs) {
        data.skins.forEach(function (s) {
            s.blobUrl = data.externalLinks.configSvcBlobUrl + "SkinImages/" + s.skinCD.toLowerCase() + (s.skinCD.startsWith("SRZ") || s.skinCD.startsWith("TRZ") ? ".png" : ".svg");
            s.imageURL = data.externalLinks.configSvcBlobUrl + "SkinImages/" + s.skinCD.toLowerCase() + (s.skinCD.startsWith("SRZ") || s.skinCD.startsWith("TRZ") ? ".png" : ".svg");
            s.htmlURL = data.externalLinks.configSvcBlobUrl + s.skinCD + ".htm";
        });
    } else {
        data.skins.forEach(function (s) {
            if (s.blobURL && s.blobURL.substring(0, 1) == "/") {
                s.blobURL = s.blobURL.substring(1, s.blobURL.length); //remove head slash
            }
            s.imageURL = RDL.Paths.ResourcePath + s.blobURL;
            s.blobURL = RDL.Paths.ResourcePath + s.blobURL;
            s.htmlURL = getSkinHtmlPath() + s.skinCD + ".htm";
        });
    }
    configLoaded = true;
    setSegmentProperties();
    if (!isMacMachine && RDL.loadSegmentEarly) {
        loadJs(segmentUrl + "?v=" + versionNumber);
    }
    downLoadAccountsJs();
    getAdminUiExperiments();
    if (resolve)
        resolve(data);
    setInterval(function () {
        var diffTime = Math.abs(new Date() - RDL.Current_Session_Date);
        var diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24));
        if (diffDays >= RDL.SESSION_STALE_TIMEOUT_DAYS) {
            window.location.reload();
        }
        else {
            RDL.IsUserExist();
        }
    }, 12 * 60 * 60 * 1000);
    // Added to handle personal website link logic for Zety against ZTY-316
    window.globalCompVars.personalWebsiteApiPath = RDL.personalWebsiteApiPath;
    RDL.handleMonogramURLS();
}
window.setSegmentProperties = function () {
    if (RDL.externalLinks.segmentUrl) {
        segmentUrl = RDL.externalLinks.segmentUrl;
    }
    window.segment = {
        Writekey: RDL.segmentKey,
        Integrations: (RDL.analyticsIntegration) ? RDL.analyticsIntegration : null,
        Domain: RDL.Portal.cookieDomain || "." + RDL.domain
    }
    window.segment.CommonProps = {
        'builder type': 'Resume Wizard',
        'Platform': 'Web',
        'Feature Set': 'Resumes'
    }
}
RDL.isLP27Flow = function () {
    var isLP27Flow = false;
    if (RDL.readCookie('BDLP') != null && RDL.isBaseRoute) {
        isLP27Flow = true;
    }
    return isLP27Flow;
}
RDL.handleSkins = function () {
    RDL.skins.filter(function (skin) {
        return skin.skinCD !== RDL.selectedSkin;
    }).forEach(function (skin) {
        var skinName = skin.skinCD + '.htm';
        RDL.getSkinHtml(skinName, true);
    });
}
window.termConditions = function (event) {
    //TODO
    event.preventDefault();
    RDL.Paths.termsOfUseURL ? window.open(RDL.Paths.termsOfUseURL) : window.open(event.target.href);
}
window.privacyPolicy = function (event) {
    //TODO
    event.preventDefault();
    RDL.Paths.privacyURL ? window.open(RDL.Paths.privacyURL) : window.open(event.target.href);
}
window.getGAClientId = function () {
    var clientId = "";
    window.ga && ga(function (tracker) {
        clientId = tracker.get('clientId');
    });
    return clientId;
}
window.generateClaims = function () {
    if (typeof setguestuserclaims == 'function') {
        setguestuserclaims(userUIdFrmExtrnlSite, 'RWZ', RDL.Paths.AccountsURL);
        clearInterval(generateClaimsTimer);
    }
}
window.isMac = function () {
    if (navigator.userAgent.match(/Mac OS/i))
        return true;
    else
        return false;
}
RDL.createCookie = function (name, value, days, domain) {
    var expires = "";
    var _domain = "";
    var secure = ";secure";
    if (days) {
        var date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
        expires = "; expires=" + date.toGMTString();
    } else
        expires = "";

    if (domain) {
        _domain = "; domain=" + domain;
    }
    else if (RDL.Portal.cookieDomain) {
        _domain = "; domain=" + RDL.Portal.cookieDomain;
    }
    document.cookie = name + "=" + value + secure + expires + _domain + "; path=/;";
}
RDL.readCookie = function (name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') c = c.substring(1, c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
    }
    return null;
}
RDL.Paths = {};
RDL.Paths.ResourcePath = getResourceUrl();
RDL.Paths.RWZBlobUrl = getRWZBlobURL();
window.globalCompVars = {};
window.globalCompVars.BaseApiUrl = RDL.Paths.BaseApiUrl = RDL.getApiUrl();
window.globalCompVars.BaseJsgUrl = RDL.Paths.BaseJsgUrl = RDL.getJsgUrl();
window.globalCompVars.BaseFTUrl = RDL.Paths.BaseFTUrl = RDL.getFTUrl();
window.globalCompVars.BaseApiUrlV2 = RDL.Paths.BaseApiUrlV2 = RDL.getApiUrl("v2");
window.globalCompVars.BaseApiUrlV3 = RDL.Paths.BaseApiUrlV3 = RDL.getApiUrl("v3");
RDL.Paths.BasePath = RDL.Portal.slug || RDL.Portal.basePath;
RDL.Paths.ImageBasePath = RDL.Paths.ResourcePath + "images/desktop/";
RDL.Paths.termsOfUseURL = '';
RDL.Paths.privacyURL = '';
RDL.Paths.signoutURL = '';
RDL.Paths.mysettingsURL = '';
RDL.Paths.contactUsURL = '';
RDL.executeDirectFunnelFlow = false;
RDL.VisitorApiSetting = {};
RDL.PortalSettings = {};
RDL.skins = {};
RDL.segmentKey = '';
RDL.guestUserID = null;
RDL.guestUserCreated = false;
RDL.isRefresh = true;
RDL.isBack = true;
RDL.isOverviewBack = false;
RDL.isEditingFinished = false;
RDL.loadedPageCalled = false;
RDL.googleLoginClientID = '';
RDL.facebookClientID = '';
RDL.scrollPos = 0;
RDL.maintainScroll = false;
RDL.Content = [];
RDL.files = [];
RDL.WindowH = window.innerHeight;
RDL.Paths.signInURL = '';
RDL.currentZoomValue = 1.5;
RDL.dragCurrentZoomValue = 1.5;
RDL.currentZoomIndex = 2;
RDL.OnBoarding_Popup = true;
RDL.isBlankName = false;
RDL.isdragMove = true;
RDL.isTablet = navigator.userAgent.match(/iPad/i) != null;
RDL.isJobHero = /jobhero/i.test(window.location.pathname);
RDL.countryDetails = { countryCode: "US", continentCode: "", isEuropianContinent: false, city: "", state: "", isEEACountry: false };
RDL.INVALID_ATTEMPT = 'fpcount';
RDL.isRWZFlow = true; //To be done conditionally
RDL.environmentURL = '';
RDL.maxloopCount = 3;
RDL.loopTimeGapInSec = 5;
RDL.createUserCallCounter = 0;
RDL.createUserTimer = undefined;
RDL.claimCallTimer = undefined;
RDL.isBDFlow = false;
RDL.builderStepValue = null;
RDL.templateFlowValue = null;
RDL.SkinFromPortal = null;
RDL.SkinThemeFromPortal = null;
RDL.claimCallCounter = 0;
RDL.ArrayFeatureSet = [];
RDL.JobTitleContentDetails = { experimentID: "", variation: "" }
RDL.EmployerContentDetails = { experimentID: "", variation: "" }
RDL.isBaseRoute = (location.pathname == RDL.Paths.BasePath || location.pathname == RDL.Paths.BasePath + '/');
RDL.isCountryAUorNZ = false;
if (RDL.isTablet) {
    $html.classList.add("ipad");
}
RDL.defaultSkin = RDL.Portal.defaultSkin;
RDL.selectedSkin = '';
RDL.ShowResumeCheck = false;
var createGuestUser = function () {
    RDL.logMessage += "\n createGuestUser called.";
    if (RDL.Portal.useAccountsJs) {
        if ((typeof BOLD == "object" || typeof LOGIN == "object") && configLoaded) {
            RDL.createUserCallCounter++;
            clearTimeout(RDL.createUserTimer);
            RDL.createUserTimer = setTimeout(function () {
                RDL.createUserCallCounter = 0;
            }, RDL.loopTimeGapInSec * 1000);
            RDL.logMessage += "\n createGuestUser createUserCallCounter" + RDL.createUserCallCounter;
            if (RDL.createUserCallCounter > RDL.maxloopCount) {
                clearAndRedirect("/?forceRedirect=StuckInUserCreation")
            }
            isAccUserCalled = true;
            isCreateGuestInProgress = true;
            RDL.accountsNameSpace().Accounts.createGuest(RDL.PortalSettings.ConfigureProductCd, null, location.href).then(function (data) {
                clearInterval(createGuestUserTimer);
                PostGuestCreated(data.GuestUserID);
                isCreateGuestInProgress = false;
            }, function (error) {
                RDL.logMessage += "\n error occured in createGuest" + JSON.stringify(error);
                isCreateGuestInProgress = false;
                //clearAndRedirect("/?forceRedirect=StuckInUserCreation");
                //clearInterval(createGuestUserTimer);
            });
            clearInterval(createGuestUserTimer);
        }
    }
    else {
        if (typeof CreateGuestUser == 'function' && configLoaded) {
            var refCookieId = "14";
            var refCookie = RDL.readCookie("ref");
            if (refCookie != null && refCookie != undefined) {
                refCookieId = refCookie
            }

            RDL.createUserCallCounter++;
            clearTimeout(RDL.createUserTimer);
            RDL.createUserTimer = setTimeout(function () {
                RDL.createUserCallCounter = 0;
            }, RDL.loopTimeGapInSec * 1000);
            RDL.logMessage += "\n createGuestUser createUserCallCounter" + RDL.createUserCallCounter;
            if (RDL.createUserCallCounter > RDL.maxloopCount) {
                clearAndRedirect("/?forceRedirect=StuckInUserCreation")
            }
            isAccUserCalled = true;
            CreateGuestUser(RDL.Portal.portalId, RDL.Paths.AccountsURL, refCookieId);
            clearInterval(createGuestUserTimer);
        }
    }
}
RDL.CreateGuestUser = function () {
    reqAccountsGuestUserCreation = true;
    RDL.logMessage += "\n RDL.CreateGuestUser called.";
    clearInterval(createGuestUserTimer);
    if (!isCreateGuestInProgress) {
        createGuestUserTimer = setInterval(createGuestUser, 200);
    }
}
RDL.GenerateClaims = function () {
    clearInterval(generateClaimsTimer);
    generateClaimsTimer = setInterval(generateClaims, 200);
}
RDL.isNullOrWhitespace = function (input) {
    if (input == null || input == undefined) return true;
    return input.replace(/\s/g, '').length < 1;
}
RDL.GetElementPosition = function (element) {
    var rect = element.getBoundingClientRect();

    return offset = {
        top: rect.top + (window.scrollY || window.pageYOffset),
        left: rect.left + (window.scrollX || window.pageXOffset),
    };
}
RDL.GetQueryString = function (field, url) {
    var href = url || window.location.href;
    var reg = new RegExp('[?&]' + field + '=([^&#]*)', 'i');
    var string = reg.exec(href);
    return string ? string[1] : null;
};
RDL.isCreateNew = RDL.GetQueryString("mode") == "new" || RDL.readCookie("CookieCreateNew") == "1"; // 2nd resume case
RDL.animateJS = function (elem, prop, valueToSet, time, isDirectProperty, valueUnit, callback, startValue) {
    try {
        var value = startValue ? startValue : (isDirectProperty ? elem[prop] : elem.style[prop])
        value = +value.toString().replace('px', '').replace('%', '');
        var shouldIncrease = true;
        if (value > valueToSet) {
            shouldIncrease = false;
        }
        function frame() {
            try {
                if (shouldIncrease) {
                    value++;
                }
                else {
                    value--;
                }

                if (isDirectProperty) {
                    elem[prop] = value + valueUnit // show frame
                }
                else {
                    elem.style[prop] = value + valueUnit // show frame
                }
                if (shouldIncrease && value >= valueToSet) {  // check finish condition
                    clearInterval(id);
                    callback && callback();
                }
                else if (!shouldIncrease && value <= valueToSet) {  // check finish condition
                    clearInterval(id);
                    callback && callback();
                }
            }
            catch (ex) {
                clearInterval(id);
                callback && callback();
            }
        }
        var id = setInterval(frame, time / (valueToSet > 0 ? valueToSet : time));
    }
    catch (ex) {
        console.log(ex)
    }
}
RDL.AnimateToPosition = function (topPosition, duration, callback) {
    if (duration == null || duration == undefined) { duration = 400; }
    RDL.animateJS(document.querySelector('body'), 'scrollTop', topPosition, duration, true, '', function () {
        if (callback) { callback(); }
    });
}
RDL.ScrollToPosition = function (element, scrollPos) {
    if (!element) { element = document.body; }
    if (!scrollPos) { scrollPos = 0; }

    element.scrollTop = scrollPos;
}
RDL.TrackEvents = function (eventName, eventpropval, userid, islogin, skipTraitsToIterable) {
    if (RDL.UserConsent) {
        if (typeof analytics != 'undefined' && typeof mixpanel != 'undefined' && typeof mixpanel.get_distinct_id != 'undefined' && RDL.UserClaims && RDL.UserClaims.user_uid) {
            eventpropval = eventpropval || {};
            eventpropval["userId"] = RDL.UserClaims.user_uid;
            trackEvent(eventName, eventpropval, userid, islogin, skipTraitsToIterable);
        }
        else {
            setTimeout(function () {
                RDL.TrackEvents(eventName, eventpropval, userid, islogin, skipTraitsToIterable);
            }, 100);
        }
    }
};
RDL.BuilderUsageTrackEvents = function (action, screenName, label, islogin, clickOption) {
    var eventpropval = {};
    if (clickOption) {
        eventpropval = { 'action': action, 'screen name': screenName, 'click option': clickOption }
    }
    else {
        eventpropval = { 'action': action, 'screen name': screenName }
    }
    RDL.TrackEvents('builder usage', eventpropval, null, islogin);
};
RDL.startPageLoader = function () {
    document.getElementById("page-loader") && document.getElementById("page-loader").classList.remove("hide");
}
RDL.closePageLoader = function () {
    document.getElementById("page-loader") && document.getElementById("page-loader").classList.add("hide");
}
RDL.getResourceValue = function (coreKey, INTLKey) {
    var value = "";
    value = RDL.isINTL ? RDL.Localization[INTLKey] : RDL.Localization[coreKey];

    if (!value) {
        console.log("Localization key " + (RDL.isINTL ? INTLKey : coreKey) + " not found.");
    }

    return value;
}
RDL.promiseAllResolveActivity = function () {
    var _jobTitle = RDL.GetQueryString("JobTitle");
    if (_jobTitle) {
        _jobTitle = _jobTitle.replace(/%20/g, " ").replace(/-/g, " ");
        _jobTitle = RDL.convertToTitleCase(_jobTitle);
        RDL.createCookie("LP_JobTitle", _jobTitle, null, RDL.Portal.cookieDomain);
    }
    RDL.addExperimentsLocalizedText();
}
RDL.convertToTitleCase = function (str) {
    var wordsFromStr = str.split(' ');
    var words = [];

    for (var i = 0; i < wordsFromStr.length; i++) {
        words.push(wordsFromStr[i].substring(0, 1).toUpperCase() + '' + wordsFromStr[i].substring(1).toLowerCase());
    }

    return words.join(' ');
}
/* Global site tag (gtag.js) - Google Analytics  
   loadGAScriptWithKey() - common method to add ga scripts 
   gtag() - to push arguments
   Add "gaKey" in config file with value e.g. "gaKey":"some value"  */
window.gtag = function () {
    window.dataLayer.push(arguments);
}
window.loadGAScriptWithKey = function () {
    if (RDL.Portal.gaKey && RDL.Portal.gaKey != null && RDL.Portal.gaKey.length > 0) {
        window.dataLayer = window.dataLayer || [];
        gtag('js', new Date());
        gtag('config', RDL.Portal.gaKey);
        var script = document.createElement('script'),
            src = "https://www.googletagmanager.com/gtag/js?id=" + RDL.Portal.gaKey;
        script.setAttribute("src", src);
        script.async = true;
        script.defer = true;
        if (typeof script != "undefined") {
            document.getElementsByTagName("head")[0].appendChild(script);
        }
    }
}
RDL.LoadThirdPartyJS = function () {
    loadgtms();
    loadGAScriptWithKey();
    if (isMacMachine || !RDL.loadSegmentEarly) {
        loadJs(segmentUrl + "?v=" + versionNumber);
    }
}
RDL.SaveFirstTouchValuesFromQS = function () {
    var saveUTM_Campaign_First_Touch = RDL.GetQueryString("utm_campaign") == null ? "undefined" : RDL.GetQueryString("utm_campaign");
    var saveUTM_Content_First_Touch = RDL.GetQueryString("utm_content") == null ? "undefined" : RDL.GetQueryString("utm_content");
    var saveUTM_Medium_First_Touch = RDL.GetQueryString("utm_medium") == null ? "undefined" : RDL.GetQueryString("utm_medium");
    var saveUTM_Source_First_Touch = RDL.GetQueryString("utm_source") == null ? "undefined" : RDL.GetQueryString("utm_source");
    var saveUTM_Term_First_Touch = RDL.GetQueryString("utm_term") == null ? "undefined" : RDL.GetQueryString("utm_term");
    var utmFirstTouchCookieValue = "";
    if (saveUTM_Campaign_First_Touch)
        utmFirstTouchCookieValue = "saveUTM_Campaign_First_Touch-" + saveUTM_Campaign_First_Touch + "#";
    if (saveUTM_Content_First_Touch)
        utmFirstTouchCookieValue = utmFirstTouchCookieValue + "saveUTM_Content_First_Touch-" + saveUTM_Content_First_Touch + "#";
    if (saveUTM_Medium_First_Touch)
        utmFirstTouchCookieValue = utmFirstTouchCookieValue + "saveUTM_Medium_First_Touch-" + saveUTM_Medium_First_Touch + "#";
    if (saveUTM_Source_First_Touch)
        utmFirstTouchCookieValue = utmFirstTouchCookieValue + "saveUTM_Source_First_Touch-" + saveUTM_Source_First_Touch + "#";
    if (saveUTM_Term_First_Touch)
        utmFirstTouchCookieValue = utmFirstTouchCookieValue + "saveUTM_Term_First_Touch-" + saveUTM_Term_First_Touch + "#";

    if (utmFirstTouchCookieValue.length > 0)
        utmFirstTouchCookieValue = utmFirstTouchCookieValue.slice(0, -1); //remove the last #
    if (utmFirstTouchCookieValue.length > 0) {
        RDL.createCookie("UTMFirstTouchCookie", utmFirstTouchCookieValue.replace(/%22/g, '"'), null, window.location.host.substr(window.location.host.indexOf('.')));
    }
}
RDL.SaveLastTouchValuesFromQS = function () {
    var saveUTM_Campaign_Last_Touch = RDL.GetQueryString("utm_campaign") == null ? "undefined" : RDL.GetQueryString("utm_campaign");
    var saveUTM_Content_Last_Touch = RDL.GetQueryString("utm_content") == null ? "undefined" : RDL.GetQueryString("utm_content");
    var saveUTM_Medium_Last_Touch = RDL.GetQueryString("utm_medium") == null ? "undefined" : RDL.GetQueryString("utm_medium");
    var saveUTM_Source_Last_Touch = RDL.GetQueryString("utm_source") == null ? "undefined" : RDL.GetQueryString("utm_source");
    var saveUTM_Term_Last_Touch = RDL.GetQueryString("utm_term") == null ? "undefined" : RDL.GetQueryString("utm_term");
    var utmLastTouchCookieValue = "";
    if (saveUTM_Campaign_Last_Touch)
        utmLastTouchCookieValue = "saveUTM_Campaign_Last_Touch-" + saveUTM_Campaign_Last_Touch + "#";
    if (saveUTM_Content_Last_Touch)
        utmLastTouchCookieValue = utmLastTouchCookieValue + "saveUTM_Content_Last_Touch-" + saveUTM_Content_Last_Touch + "#";
    if (saveUTM_Medium_Last_Touch)
        utmLastTouchCookieValue = utmLastTouchCookieValue + "saveUTM_Medium_Last_Touch-" + saveUTM_Medium_Last_Touch + "#";
    if (saveUTM_Source_Last_Touch)
        utmLastTouchCookieValue = utmLastTouchCookieValue + "saveUTM_Source_Last_Touch-" + saveUTM_Source_Last_Touch + "#";
    if (saveUTM_Term_Last_Touch)
        utmLastTouchCookieValue = utmLastTouchCookieValue + "saveUTM_Term_Last_Touch-" + saveUTM_Term_Last_Touch + "#";

    if (utmLastTouchCookieValue.length > 0)
        utmLastTouchCookieValue = utmLastTouchCookieValue.slice(0, -1); //remove the last #
    if (utmLastTouchCookieValue.length > 0) {
        RDL.createCookie("UTMLastTouchCookie", utmLastTouchCookieValue.replace(/%22/g, '"'), null, window.location.host.substr(window.location.host.indexOf('.')));
    }
}
RDL.isAnyAuthCookieExists = function () {
    var anyAuthCookieExists = true;
    if (RDL.Portal.useAccountsJs) {
        if (RDL.readCookie("userinfo") == null && RDL.readCookie(AuthCookieName) == null) {
            anyAuthCookieExists = false;
        }
    }
    return anyAuthCookieExists;
}
RDL.delete_cookie = function (name, domain) {
    var _domain = "";
    var date = new Date();
    date.setTime(date.getTime() - 1);
    var expires = "; expires=" + date.toGMTString();
    if (domain) {
        _domain = "; domain=" + domain;
    }
    document.cookie = name + "=;" + expires + _domain + "; path=/;";
};
RDL.LoginUserByAccountJs = function (emailAddress, password, EmailOptin, docId, previousEmail) {
    var otherTraits = [{ "docId": docId }];
    var optin = 0;
    if (EmailOptin == true) { optin = 1; }
    RDL.accountsNameSpace().Accounts.loginUser(emailAddress, password, RDL.PortalSettings.ConfigureProductCd, "Resumes", optin, otherTraits, previousEmail, null, "", "", window.location.href).then(function (data) {
        window.login.handleLoginResponse(data.userid, data.status);
    }, function () {
        RDL.closePageLoader();
    });
}
RDL.RegisterGuestUserByAccountsJs = function (guestUserUID, emailAddress, password, firstName, lastName, phoneNumber, mobileNumber, EmailOptin, docId, keepMeLoggedIn, previousEmail) {
    // RegisterGuestUser(guestUserUID, emailAddress, password, RDL.PortalSettings.ConfigurePortalCd, RDL.PortalSettings.ConfigureProductCd, RDL.Paths.AccountsURL, firstName, lastName, phoneNumber, mobileNumber, 'Resumes', "", EmailOptin, docId, keepMeLoggedIn, previousEmail);
    var otherTraits = [{ "docId": docId }];
    //var otherProperties = [{ "docId": docId}];
    var optin = 0;
    if (EmailOptin == true) { optin = 1; }
    RDL.accountsNameSpace().Accounts.registerGuest(guestUserUID, emailAddress, password, firstName, lastName, RDL.PortalSettings.ConfigureProductCd, "Resumes", optin, previousEmail, otherTraits, null, "", "", window.location.href).then(function (data) {
        //console.log(data);
        window.login.handleResponseV2(data.userid, data.status);
    }, function () {
        RDL.closePageLoader();
        // alert("ërror in register user");
    })
}
RDL.ForgotPassword = function (emailAddress) {
    //DirectForgotPassword(emailAddress, RDL.PortalSettings.ConfigureProductCd, RDL.PortalSettings.ConfigurePortalName, 'flow', encodeURI(window.location.origin + RDL.Paths.BasePath + window.location.search), RDL.Paths.AccountsURL);    
    RDL.accountsNameSpace().Accounts.forgotPassword(emailAddress, RDL.PortalSettings.ConfigureProductCd, encodeURI(window.location.origin + RDL.Paths.BasePath + window.location.search), "Resumes").then(function (data) {
        window.login.handleForgotPasswordResponse(data.Status);
    }, function () {
        window.login.handleForgotPasswordResponse("Error");
    });
}
RDL.IsUserExist = function () {
    if (RDL.UserClaims && RDL.UserClaims.user_uid) {
        var url = RDL.Paths.BaseApiUrl + 'users/' + RDL.UserClaims.user_uid;
        var xmlhttp;
        xmlhttp = new XMLHttpRequest();
        xmlhttp.withCredentials = true;
        xmlhttp.onload = function () {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                var user = JSON.parse(xmlhttp.responseText);
                if (user == null || user == undefined) {
                    clearAndRedirect("/")
                }
            }
            else if (xmlhttp.readyState == 4 && xmlhttp.status == 400) {
                clearAndRedirect("/");
            }
        }
        xmlhttp.open("GET", url, true);
        xmlhttp.send();
    }
}
RDL.CreateOrGetUser = function (resolve) {
    if ((typeof BOLD == "object" || typeof LOGIN == "object") && configLoaded && !isCreateGuestInProgress) {
        RDL.createUserCallCounter++;
        if (RDL.createUserCallCounter > RDL.maxloopCount) {
            clearAndRedirect("/?forceRedirect=StuckInUserCreation")
        }
        isCreateGuestInProgress = true;
        RDL.accountsNameSpace().Accounts.createGuest(RDL.PortalSettings.ConfigureProductCd, null, location.href).then(function (data) {
            clearInterval(createGuestUserTimer);
            clearInterval(postGuestUserTimer);
            isCreateGuestInProgress = false;
            if (data && data.claims && data.claims.user_uid) {
                RDL.UserClaims = data.claims;
                RDL.isloggedIn = (RDL.UserClaims.role != "User") ? false : true;
                if (RDL.isBaseRoute && !RDL.isTemplateFlow()) {
                    if (RDL.UserClaims.role == "Guest") {
                        postGuestUserTimer = setInterval(function () {
                            handlePostGuestCreated();
                        }, 200);
                    }
                }
                else {
                    hideHIWPage();
                }
                resolve();
            }
            else {
                RDL.CreateOrGetUser(resolve);
            }
        }, function () {
            isCreateGuestInProgress = false;
            RDL.CreateOrGetUser(resolve);
        });
    }
    else {
        setTimeout(function () { RDL.CreateOrGetUser(resolve); }, 100);
    }
}
RDL.Claims = function (callback, isAsync, resolve, skipAuthCookieCheck) {
    RDL.logMessage += "\n Claims isAnyAuthCookieExists-" + RDL.isAnyAuthCookieExists();
    RDL.logMessage += "\n Claims userinfo cookie-" + RDL.readCookie("userinfo");
    RDL.logMessage += "\n Claims Auth Cookie-" + RDL.readCookie(AuthCookieName);
    RDL.logMessage += "\n Claims RDL.UserClaims-" + RDL.UserClaims;
    if (RDL.isAnyAuthCookieExists() == true || skipAuthCookieCheck) {

        var accountTimer = setInterval(function () {
            if (typeof RDL.accountsNameSpace() != 'undefined' && typeof RDL.accountsNameSpace().Accounts != 'undefined') {
                clearInterval(accountTimer);
                RDL.accountsNameSpace().Accounts.getClaims().then(function (data) {
                    if (data.claims.user_uid != undefined) {
                        resolve ? callback(JSON.stringify(data.claims), resolve) : callback(JSON.stringify(data.claims));
                    }
                    else {
                        var claims = "{\"user_uid\":null}";
                        resolve ? callback(claims, resolve) : callback(claims);
                    }
                });
            }
        }, 50);
        RDL.claimCallCounter++;
        clearTimeout(RDL.claimCallTimer);
        RDL.claimCallTimer = setTimeout(function () {
            RDL.claimCallCounter = 0;
        }, RDL.loopTimeGapInSec * 1000);

        if (RDL.claimCallCounter > RDL.maxloopCount) {
            // redirect to LP.
            clearAndRedirect("/?forceRedirect=StuckInClaimCall")
        }
    }
    else {
        RDL.logMessage += "\n Claims CreateGuestUser() called.";
        RDL.CreateGuestUser();
        if (resolve)
            resolve('');
    }
}
window.addEventListener("load", function () {
    if(!isIE){
        loadCSSIfNotAlreadyLoaded();
    }
    RDL.TriggerInitialPromises();
    RDL.pageLoaded = true;
});
if (window.location.href.toLowerCase().indexOf("utm_") > -1) {
    RDL.SaveFirstTouchValuesFromQS();
    RDL.SaveLastTouchValuesFromQS();
}
RDL.loadSvgs = function () {
    RDL.skins.forEach(function (element) {
        var img = document.createElement('img');
        if (RDL.useContentBlobForSVGs) {
            img.src = element.blobURL;
        } else if (!isIE) {
            img.src = RDL.configServiceBlobUrl + "SkinImages/" + element.skinCD.toLowerCase() + (element.skinCD.startsWith("SRZ") || element.skinCD.startsWith("TRZ") ? ".png" : ".svg");
        }
        document.getElementById('afterLoadContent').appendChild(img);
    });
}
RDL.loadFile = function () {
    if (RDL.skins.filter) {
        RDL.handleSkins();
    }
    else {
        var skinTimer = setInterval(function () {
            if (RDL.skins.filter) {
                clearInterval(skinTimer);
                RDL.handleSkins();
            }
        }, 100);
    }
}
RDL.getSkinHtml = function (skinName, isAsyncTrue) {
    try {
        var url = getSkinHtmlPath() + skinName;
        callAjax(true, url, 'GET', isAsyncTrue ? true : false, false, function (data) {
            var parser = new DOMParser();
            var htmlDoc = parser.parseFromString(data, "text/html");
            //EB-11749 :These multiple text comparisions are part of a temporary change.
            //Once the changes are done at skin level, this will be removed.
            //This replaces the word 'to' between from and to dates with its localized text
            (RDL.cultureCD && RDL.cultureCD.toLowerCase() != "en-us") && RDL.LocalizeFromEndDateToWordInSkin(htmlDoc);
            RDL.files[skinName] = htmlDoc;
        });
    }
    catch (ex) {
        console.log(ex);
    }
}
RDL.LocalizeFromEndDateToWordInSkin = function (htmlDoc) {
    try {
        if (RDL.localizationResumeRenderer.toDate_text) {
            htmlDoc.querySelectorAll("span[dependency='JSTD+EDDT']").forEach(function (spanNode) {
                if (spanNode && spanNode.innerText && spanNode.innerText.trim() &&
                    (spanNode.innerText.trim().toLowerCase() == "to" ||
                        spanNode.innerText.trim().toLowerCase() == "a" ||
                        spanNode.innerText.trim().toLowerCase() == "à")) {
                    spanNode.innerText = spanNode.innerText.replace(spanNode.innerText.trim(), RDL.localizationResumeRenderer.toDate_text);
                }
            });
        }
        if (RDL.localizationResumeRenderer.address_Label) {
            htmlDoc.querySelectorAll("span[class*='xslt_static_change'").forEach(function (spanNode) {
                if (spanNode && spanNode.innerText && spanNode.innerText.trim()) {
                    if (spanNode.innerText.trim().toLowerCase() == "address") {
                        spanNode.innerText = spanNode.innerText.replace(spanNode.innerText.trim(), RDL.localizationResumeRenderer.address_Label);
                    }
                    if (spanNode.innerText.trim().toLowerCase() == "phone") {
                        spanNode.innerText = spanNode.innerText.replace(spanNode.innerText.trim(), RDL.localizationResumeRenderer.phone_Label);
                    }
                    if (spanNode.innerText.trim().toLowerCase() == "email") {
                        spanNode.innerText = spanNode.innerText.replace(spanNode.innerText.trim(), RDL.localizationResumeRenderer.email_Label);
                    }
                    if (spanNode.innerText.trim().toLowerCase() == "expected in") {
                        spanNode.innerText = RDL.Localization.Graduation_Expected; //Grad year update feature localization MPINTL-880
                    }
                    if (RDL.localizationResumeRenderer.hPhoneText && spanNode.innerText.trim().toLowerCase() == "home") {
                        spanNode.innerText = spanNode.innerText.replace(spanNode.innerText.trim(), RDL.localizationResumeRenderer.hPhoneText);
                    } else if (RDL.Localization.hPhoneShortText && RDL.homePhone.indexOf(spanNode.innerText.trim()) > -1) {
                        spanNode.innerText = spanNode.innerText.replace(spanNode.innerText.trim(), RDL.Localization.hPhoneShortText);
                    }
                    if (RDL.localizationResumeRenderer.cPhoneText && spanNode.innerText.trim().toLowerCase() == "mobile") {
                        spanNode.innerText = spanNode.innerText.replace(spanNode.innerText.trim(), RDL.localizationResumeRenderer.cPhoneText);
                    } else if (RDL.Localization.cPhoneShortText && RDL.mobilePhone.indexOf(spanNode.innerText.trim()) > -1) {
                        spanNode.innerText = spanNode.innerText.replace(spanNode.innerText.trim(), RDL.Localization.cPhoneShortText);
                    }
                    if (RDL.localizationResumeRenderer.resume_Text && spanNode.innerText.trim().toLowerCase() == "resume") {
                        spanNode.innerText = spanNode.innerText.replace(spanNode.innerText.trim(), RDL.localizationResumeRenderer.resume_Text);
                    }
                    if (RDL.Localization.dob_resume_label && spanNode.innerText.trim().toLowerCase() == "date of birth") {
                        spanNode.innerText = spanNode.innerText.replace(spanNode.innerText.trim(), RDL.Localization.dob_resume_label);
                    }
                    if (RDL.Localization.nationality_Text && spanNode.innerText.trim().toLowerCase() == "nationality") {
                        spanNode.innerText = spanNode.innerText.replace(spanNode.innerText.trim(), RDL.Localization.nationality_Text);
                    }
                    if (RDL.Localization.permit_resume_label && spanNode.innerText.trim().toLowerCase() == "permit") {
                        spanNode.innerText = spanNode.innerText.replace(spanNode.innerText.trim(), RDL.Localization.permit_resume_label);
                    }
                    if (RDL.Localization.martial_status_resume_label && spanNode.innerText.trim().toLowerCase() == "marital status") {
                        spanNode.innerText = spanNode.innerText.replace(spanNode.innerText.trim(), RDL.Localization.martial_status_resume_label);
                    }
                    if (RDL.Localization.web_resume_label && spanNode.innerText.trim().toLowerCase() == "web") {
                        spanNode.innerText = spanNode.innerText.replace(spanNode.innerText.trim(), RDL.Localization.web_resume_label);
                    }
                    if (RDL.Localization.available_resume_label && spanNode.innerText.trim().toLowerCase() == "other") {
                        spanNode.innerText = spanNode.innerText.replace(spanNode.innerText.trim(), RDL.Localization.available_resume_label);
                    }
                }
            });
        }
    } catch (error) {
        console.log(error);
    }
}
RDL.RunScratchFlow = function () {
    window.selectResume.scratchFlow();
}
RDL.getTemplateFromSkin = function (skin) {
    var skinCD = skin || (RDL.selectedSkin || RDL.defaultSkin || RDL.SkinFromPortal || RDL.chooseTemplateLP01Test);
    var template = RDL.files[skinCD + '.htm'];
    if (!template) {
        RDL.getSkinHtml(skinCD + '.htm', false);
        template = RDL.files[skinCD + '.htm'];
        if (!template) {
            template = RDL.files[RDL.defaultSkin + '.htm'];
        }
    }
    return template;
}
RDL.isMultiColumnSkin = function (skinCD) {
    var isMultiColumn = false;
    var skinCD = skinCD || (RDL.selectedSkin || RDL.defaultSkin);
    var container = RDL.getTemplateFromSkin(skinCD).querySelectorAll("container");
    if (container != null && container.length > 0) {
        isMultiColumn = true;
    }
    return isMultiColumn;
}
RDL.visitedIndex = 0;
if (sessionStorage.getItem('visitedIndex')) {
    RDL.visitedIndex = sessionStorage.getItem('visitedIndex');
}
RDL.setVisitedIndex = function (visitedIndex) {
    if (RDL.visitedIndex < visitedIndex) {
        RDL.visitedIndex = visitedIndex;
        sessionStorage.setItem('visitedIndex', visitedIndex);
    }
}
RDL.UpdatePushnami = function () {
    var userUId = RDL.UserClaims ? RDL.UserClaims.user_uid : '';
    if (window.localStorage && window.localStorage.pushnamiSubscriptionStatus && window.localStorage.pushnamiSubscriptionStatus == 'SUBSCRIBED') {
        if (window.Pushnami) {
            Pushnami.update({ "convert": "true" }).prompt();
            Pushnami.update({ "useruid": userUId }).prompt();
        }
        else {
            var script = document.createElement("script");
            script.type = "text/javascript";
            script.src = "https://api.pushnami.com/scripts/v1/pushnami-adv/" + PushnamiID;
            script.onload = function () {
                Pushnami.update({ "convert": "true" }).prompt();
                Pushnami.update({ "useruid": userUId }).prompt();
            };
            document.getElementsByTagName("head")[0].appendChild(script);
        }
    }
}

RDL.isEUFlowCountry = function (EUCountryCodes) {
    var isEUFlowCountry = false;
    if (RDL.countryDetails && !RDL.isNullOrWhitespace(RDL.countryDetails.countryCode) && EUCountryCodes) {
        isEUFlowCountry = Object.values(EUCountryCodes).indexOf(RDL.countryDetails.countryCode) > -1;
    }
    return isEUFlowCountry;
}

RDL.HideNanoRep = function (event) {
    var $aHelpHIW = document.getElementById('aHelpHIW'),
        $aHelp = document.getElementById('aHelp');
    if (event.target.id != "aHelp" && event.target.id != "aHelpHIW") {
        toggleClass(document.getElementById('helpBody'), 'd-none');
        if ($aHelpHIW) $aHelpHIW.classList.remove('hover');
        if ($aHelp) $aHelp.classList.remove('hover');
    }
    // First we check if device support touch, otherwise it's click:
    var touchEvent = 'ontouchstart' in window ? 'touchstart' : 'click';
    document.body.removeEventListener(touchEvent, RDL.HideNanoRep, true);
}
RDL.toggleNanoRep = function (event) {
    var $aHelpHIW = document.getElementById('aHelpHIW'),
        $aHelp = document.getElementById('aHelp'),
        // First we check if device support touch, otherwise it's click:
        touchEvent = 'ontouchstart' in window ? 'touchstart' : 'click';

    if (event.currentTarget.id == "aHelp" || event.currentTarget.id == "aHelpHIW") {
        toggleClass(document.getElementById('helpBody'), 'd-none');
        if (hasClass(document.getElementById('helpBody'), 'd-none')) {
            if ($aHelpHIW) $aHelpHIW.classList.remove('hover');
            if ($aHelp) $aHelp.classList.remove('hover');
            document.body.removeEventListener(touchEvent, RDL.HideNanoRep, true);
        }
        else {
            if ($aHelpHIW) $aHelpHIW.classList.add('hover');
            if ($aHelp) $aHelp.classList.add('hover');
            document.body.addEventListener(touchEvent, RDL.HideNanoRep, true);
        }
    }
}
RDL.TriggerInitialPromises = function () {
    if (!(window.RDL && RDL.LowerVersionBroswer)) {
        if (RDL.UserClaims && RDL.UserClaims.user_uid) {
            claimsPromise = Promise.resolve();
            if (!(RDL.isTemplateFlow() || RDL.isLP27Flow() || RDL.readCookie("ShowTnCLink"))) {
                RDL.createCookie('ShowTnCLink', "1", null);
            }
            handleClaims(JSON.stringify(RDL.UserClaims));
            if(!(isTemplateFlow() || isLP27Flow()) && !RDL.readCookie("ShowTnCLink"))
                if (!RDL.readCookie("ShowTnCLink")) {
                    RDL.createCookie('ShowTnCLink', "1", null);
                }
            }
        else {
            claimsPromise = new Promise(function (resolve) {
                //When coming from LP27, we get BDLP cookie but when we come via
                //brightfire/balance affilaites we dont get this cookie 
                //Here we did not included 'bdflow' querystring in this condition 
                //because this qs comes for specific affiliates and for those affilates we show HIW with short funnel
                //So we dont need to to inclue that condition here
                if (RDL.isTemplateFlow() || RDL.isLP27Flow() || (RDL.UserClaims && RDL.UserClaims.user_uid)) {
                    resolve();
                }
                else {
                    if (!RDL.readCookie("ShowTnCLink")) {
                        RDL.createCookie('ShowTnCLink', "1", null);
                    }
                    if (RDL.isMPR) {
                        RDL.CreateOrGetUser(resolve);
                    }
                    else {
                        RDL.Claims(handleClaims, true, resolve);
                    }
                }
            });
        }


        configPromise = new Promise(function (resolve) {
            callAjax(true, getConfigUrl(), 'GET', true, false, handleConfig, resolve);
        });

        resourcePromise = new Promise(function (resolve) {
            callAjax(true, getLocalizationUrl(), 'GET', true, false, RDL.handleLocalizationText, resolve);
        });

        featurePromise = new Promise(function (resolve) {
            getFeatureSet(resolve);
        });

        countryDetailsPromise = new Promise(function (resolve, reject) {
            setCountryDetails(resolve, reject);
        });

        Promise.all([claimsPromise, configPromise, resourcePromise, featurePromise, countryDetailsPromise]).then(function (data) {
            if (data[2]) {
                if (data[1]) {
                    RDL.handleLocalizationText(JSON.stringify(data[2]), null, data[1]);
                }
                else {
                    RDL.handleLocalizationText(JSON.stringify(data[2]));
                }
                getTemplatesFromFeedbackSystem();

            }
            if (data[1]) {
                configuration.modifyCountryWiseConfig(data[1]);
            }
            RDL.claimsLoaded = true;
            if (RDL.pageLoaded) {
                loadJs(packageUrl, true); // load react main bundle asyn
                if (reqAccountsGuestUserCreation == false && isHandlePostPageLoadCalled == false) {
                    handlePostPageLoad();
                }
            }
            else {
                var pageLoadTimer = setInterval(function () {
                    if (RDL.pageLoaded) {
                        clearInterval(pageLoadTimer);
                        loadJs(packageUrl, true); // load react main bundle asyn
                        if (reqAccountsGuestUserCreation == false && isHandlePostPageLoadCalled == false) {
                            handlePostPageLoad();
                        }
                    }
                }, 100);
            }
            //As of now it's being used for INTL only.

            RDL.loadLocalizedDefinitionTips();
            RDL.promiseAllResolveActivity();
        });
    }
    else {
        loadStyleSheet(RDL.Paths.ResourcePath + "styles/font-awesome-5/css/fontawesome5.min.css");
        RDL.closePageLoader();
    }
}
// Add Browser/Device specific classes
//var $html = document.documentElement;
window.userAgent = navigator.userAgent.toLowerCase(),
    window.isIE = /*@cc_on!@*/false || !!document.documentMode,
    window.isEdge = !isIE && !!window.StyleMedia,
    window.isNewEdge = /Edg\//.test(navigator.userAgent),
    window.isOldEdge = isEdge && !isNewEdge,
    window.isChrome = /Chrome/.test(navigator.userAgent) && /Google Inc/.test(navigator.vendor),
    window.isSafari = /safari/.test(userAgent) && !/chrome/.test(userAgent),
    window.safariVersionArray = userAgent.match(/version\/(\d+)/i),
    window.safariVersion = (safariVersionArray !== null) ? safariVersionArray[1] : "",
    window.isSafari9 = isSafari && (safariVersion === "9"),
    window.isMacMachine = /(Mac|iPhone|iPod|iPad)/i.test(navigator.platform);
/* function isIE11() {
    if ((userAgent.indexOf('trident') > -1) && (userAgent.match(/11.0/i))) return true;
    else return false;
}
if (isIE11()) {
    $html.classList.add('ie11');
} */
if (/MSIE/.test(userAgent) || /Trident/.test(userAgent)) {
    if (/rv:11\.0/.test(userAgent)) $html.classList.add('ie11');
}
if (/firefox/.test(userAgent)) {
    $html.classList.add('firefox');
}
if (isSafari) {
    $html.classList.add('safari');
}
if (/iPad/.test(userAgent)) {
    $html.classList.add('ipad');
}
if (isEdge) {
    $html.classList.add('edge');
    if (/edge\/18\./.test(userAgent)) {
        $html.classList.add('edge18');
    }
}
if (isChrome) {
    $html.classList.add('chrome');
}
RDL.getExperimentVariant = function (experiment) {
    var variant = 0;
    if (RDL.UserExperiments && experiment && experiment.id && RDL.UserExperiments[experiment.id]) {
        variant = RDL.UserExperiments[experiment.id].variant;
    }
    // if (RDL.portalExperiments.mprModernization && RDL.UserExperiments && experiment && experiment.id == RDL.portalExperiments.mprModernization.id) {
    //     variant = 3;
    // }
    // if (RDL.portalExperiments.mprRWZInfographicLangUS && RDL.UserExperiments && experiment &&
    //     experiment.id == RDL.portalExperiments.mprRWZInfographicLangUS.id) {
    //     variant = 3;
    // }
    // if (RDL.portalExperiments.mprSkillInfo && RDL.UserExperiments && experiment && experiment.id == RDL.portalExperiments.mprSkillInfo.id) {
    //     variant = 3;
    // }
    return variant;
}
RDL.activateGOneTap = function (container, callback, docId) {
    var gTapJs = 'https://accounts.google.com/gsi/client';
    loadJs(gTapJs);
    window.handleCredentialResponse = function (response) {
        RDL.startPageLoader();
        var otherTraits = docId ? [{ "docId": docId }] : null;
        RDL.accountsNameSpace().Accounts.loginGoogleToken(response.credential, window.location.href, "RWZ", "Resumes", null, otherTraits, null, null).then(function (res) {
            if (res) {
                if (res.status == "USER_SWAP") {
                    callback && callback(res);
                    window.location = RDL.Paths.BasePath + "?welcomeback=1";
                }
                else {
                    handleClaims(JSON.stringify(res.claims));
                    callback && callback(res);
                    setTimeout(function () {
                        RDL.closePageLoader();
                    }, 50);
                }
            }
        });
    }
    var googleOneTapDiv = document.createElement('div');
    googleOneTapDiv.innerHTML = '<div id="g_id_onload"' + 'data-client_id="' + RDL.googleLoginClientID + '"' + 'data-callback="handleCredentialResponse" data-context="signup">' + '</div>';
    document.querySelector(container) && document.querySelector(container).prepend(googleOneTapDiv);
}
window.forceRedirect = function (redirectPath) {
    if (!isRedirectDone) {
        RDL.logMessage += "\n login Claims Call cookiecollection - " + document.cookie + "\n";
        RDL.logMessage += "\n Cookie Enabled - " + navigator.cookieEnabled + "\n";
        var errorObj = {
            ErrorMessage: 'RWZV2 Logging-' + redirectPath + RDL.logMessage, LogAsInfo: true
        };
        RDL.LogError(errorObj.ErrorMessage, '', errorObj.LogAsInfo, function () {
            RDL.logMessage = "";
            isRedirectDone = true;
            window.location = redirectPath;
        });
    }
}
window.onerror = function (error) {
    if (isChrome && error && error.indexOf("ERR_CACHE_READ_FAILURE") > -1) {
        forceRedirect("/?forceRedirect=CACHE_READ_FAILURE");
    }
}

    //Polyfill for IE children support
    // Overwrites native 'children' prototype.
    // Adds Document & DocumentFragment support for IE9 & Safari.
    // Returns array instead of HTMLCollection.
    ; (function (constructor) {
        if (constructor &&
            constructor.prototype &&
            constructor.prototype.children == null) {
            Object.defineProperty(constructor.prototype, 'children', {
                get: function () {
                    var i = 0, node, nodes = this.childNodes, children = [];
                    while (node = nodes[i++]) {
                        if (node.nodeType === 1) {
                            children.push(node);
                        }
                    }
                    return children;
                }
            });
        }
    })(window.Node || window.Element);
var debounceTimer;
RDL.debounce = function (func, delay) {
    return function () {
        var context = this
        var args = arguments
        clearTimeout(debounceTimer)
        debounceTimer = setTimeout(function () {
            func.apply(context, args)
        }, delay)
    }
}
    (function () {
        if (typeof Object.assign != 'function') {
            // Must be writable: true, enumerable: false, configurable: true
            Object.defineProperty(Object, "assign", {
                value: function assign(target, varArgs) { // .length of function is 2
                    'use strict';
                    if (target == null) { // TypeError if undefined or null
                        throw new TypeError('Cannot convert undefined or null to object');
                    }

                    var to = Object(target);

                    for (var index = 1; index < arguments.length; index++) {
                        var nextSource = arguments[index];

                        if (nextSource != null) { // Skip over if undefined or null
                            for (var nextKey in nextSource) {
                                // Avoid bugs when hasOwnProperty is shadowed
                                if (Object.prototype.hasOwnProperty.call(nextSource, nextKey)) {
                                    to[nextKey] = nextSource[nextKey];
                                }
                            }
                        }
                    }
                    return to;
                },
                writable: true,
                configurable: true
            });
        }
        String.prototype.insert = function (index, string) {
            if (index > 0)
                return this.substring(0, index) + string + this.substring(index, this.length);
            else
                return string + this;
        };

        if (!Element.prototype.matches) {
            Element.prototype.matches = Element.prototype.msMatchesSelector ||
                Element.prototype.webkitMatchesSelector;
        }

        if (!Element.prototype.closest) {
            Element.prototype.closest = function (s) {
                var el = this;
                if (!document.documentElement.contains(el)) return null;
                do {
                    if (el.matches(s)) return el;
                    el = el.parentElement || el.parentNode;
                } while (el !== null && el.nodeType === 1);
                return null;
            };
        }

    })();