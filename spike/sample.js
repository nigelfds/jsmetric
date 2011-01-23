/*
 * Copyright (C) 2010, Nokia gate5 GmbH Berlin
 *
 * These coded instructions, statements, and computer programs contain
 * unpublished proprietary information of Nokia gate5 GmbH, and are
 * copy protected by law. They may not be disclosed to third parties
 * or copied or duplicated in any form, in whole or in part, without
 * the specific, prior written permission of Nokia gate5 GmbH.
 *
 * $Revision$
 * $Date$
 */

Ovi.Maps.Module.Places.UI = Ovi.Maps.Module.Places.UI || {};

Ovi.Maps.Module.Places.UI.SharePlace = function (options) {


    /**
     * @type    {Ovi.Maps.Module.Places.UI.Shareplace}
     */
    var c_self = this,
        shareFromObj = null,
        _widgetIsCreated = false,
        OviAPICaller = "1290529770",
		getPlaceName,
		generateShareUrl,
		getShortUrl,
		checkAndCreateScript;

    this.shareWidget = null;
    /**
     * Returns the proper name for the given place/geolocation
     *
     * @param   {ovi.player.places.Place}   place   place to be shared
     * @return  {String}                    name or formatted address
     */
    getPlaceName = function (place) {
        var name = place.getName(),
            address = place.getFullStreetName() + ' ' + place.getLocationInfo();
        return name + (address ? ', ' + address : '');
    };

    /**
     * Build share url for Location, Search, POI, Route or Favorites
     *
     * @private
     * @param   {String}        service             service to fit url for, Location, Search, POI, Route or Favorites
     * @param   {String}        placeId             place id string
     * @param   {Object}        placePosition       object of place position
     * @return  {String}        generated url
     */
    generateShareUrl = function (service, placeId, place) {
        var server = Ovi.Maps.Constants.serverName,
            mapState = getMapState(),
            url,
			placePosition,
			placeAddress;

        switch (service) {
            case 'Location':
                placePosition = place.getCoordinates();
                placeAddress = (place.getHouseNumber() || '') + ';' + (place.getStreetName() || '') + ';' + (place.getPostalCode() || '');
                url = 'http://' + server + '/services/#|' + placePosition.latitude + '|' + placePosition.longitude + '|' + mapState.zoomScale + '|0|0?plcsDl=loc&plsAdd=' + placeAddress;
            break;
            case 'Search':
                url = 'http://' + server;
            break;
            case 'POI':
                url = 'http://' + server + '/services/place/' + placeId;
            break;
            case 'Route':
                url = 'http://' + server;
            break;
            case 'Favorites':
                url = 'http://' + server;
            break;
        }

        return url;
    };


    /**
     * Asks the ovime service to generate a shortened url. Returns the original
     * in any error case
     *
     * @param   {String}        url                 url to be shortened
     * @param   {Function}      callback            executed in success / error
     * @return  {String}        shortened url - or given on in error case
     * @private
     */
    getShortUrl = function (url, callback) {
        $.ajax({
            type: 'POST',
            url: '/services/ovime',
            data: 'url=' + encodeURIComponent(url),
            dataType: 'json',
            timeout: 5000,
            success: function (json) {
                callback(json && json.url && json.url.shortUrl || url);
            },
            error: function (error) {
                callback(url);
            }
        });
    };

    /**
     * @param {Object} Places Player Place Object
     * @requires {Object}
     */
     this.loadShareWidget = function(place) {

		var shareObj;

        if(!place){
            place = c_self._place;
        }
        try {
            Ovi.Debug.Console.log("place in share widget = " + _place);
            shareObj = {
                url: 'http://google.com',
                desc: '5 Wayside Rd, Burlington, Town Of MA 01803, United States of America',
                uiContainer: 'body',
                type: 'place',
                shareDataObj: {
                    "title": "5 Wayside Rd, Burlington, Town Of MA 01803, United States of America",
                    "placesId": "",
                    "latitude": "42.48559660278261",
                    "longitude": "-71.19040000252426",
                    "streetName": "Wayside Rd",
                    "houseNumber": "5",
                    "cityName": "Burlington",
                    "stateOrProvince": "Massachusetts",
                    "postalCode": "01803",
                    "districtName": "",
                    "countryCode": "USA",
                    "countryName": "United States of America"
                }
            };
            c_self.shareWidget.createShareObject(shareObj);
        } catch (err) {
            Ovi.Debug.log("displayInitErr: " + err.message);
        }

        /*
                shareFromCallbackObj = shareFromCallbackObj ? shareFromCallbackObj : "";
                if (shareFromCallbackObj) {
                        action = shareFromCallbackObj.action;
                        data = shareFromCallbackObj.data;
                        msg = shareFromCallbackObj.msg;
                        code = shareFromCallbackObj.code;
                        result = data.json.result;
                        message = result.msg;
                        retCode = result.retCode;
                        status = result.status;
                    if (action == "conversationAdded"){
                        alert("Conversation was added");
                    } else if (action == "emailSent"){
                                alert("Email Sent");
                          } else {
                            alert("action: " + action + ", code: " + code + ", msg: " + msg);
                        alert("message: " + message + ", retCode: " + retCode + ", status: " + status);
                    }
                }
                return true;
          */
    };

    /*
     * this is not the callback from creating the widget
     * it is the callback for the
     */
    this.widgetCreated = function() {
        c_self._widgetCreated = true;
    };

    /* create a widget */
    this.createShareWidget = function(){
        shareFromObj = {
            objClassName : 'c_self.shareWidget',
            OviAPICaller: OviAPICaller,
            callback: c_self.widgetCreated
        };
        try {
            c_self.shareWidget = new nokiaShareFrom.widget(shareFromObj);
            c_self.shareWidget.init();
            c_self._widgetCreated = true;
        } catch(err) {
            Ovi.Debug.Console.log("homeInitErr: " +err.message);
        }
    };
    /**
     *
     * @param {Object} params
     * Load a Javascript if it doesn't currently exist in the DOM.
     * Checking is done on the path to the script. If this is not an option, you can send
     * an optional string to check for. Maybe you want to check the revision number? Or the domain? (dodgy)
     * @params.path         {String}    REQUIRED
     * @params.protocol     {String}    OPTIONAL. Only required if different from current
     * @params.domain       {String}    OPTIONAL. Only required if different from current
     * @params.checkFor     {String}    OPTIONAL. If specified
     * @params.callback     {Function reference as String}  OPTIONAL callback on load and execution of script
     */

    checkAndCreateScript = function( params ){
        var scriptNotThere = true,
            headEl = document.getElementsByTagName("HEAD")[0]  || document.documentElement,
            scriptsOnPage = document.getElementsByTagName("SCRIPT"),
			i,
			scriptsLen,
			script;

        if (!params.checkFor){
            params.checkFor = params.path;
        }
        for (i = 0, scriptsLen = scriptsOnPage.length; i < scriptsLen; i++){
            if (scriptsOnPage[i].src.indexOf(params.checkFor) !== -1){
                scriptNotThere = false;
                i = scriptsLen;
            }
        }
        if (scriptNotThere){
            script = document.createElement("SCRIPT");
            script.src = ( params.protocol || window.location.protocol ) +
                            "//" +
                            ( params.domain || window.location.hostname ) +
                            "/" + params.path;
            if (Ovi.Maps.Util.isIE()) {
                // seems to break on mac
                return jQuery.getScript(script.src, params.callback);
            }
            script.onload = function () {
                if ( params.callback ) {
                    params.callback();
                }
            };
            headEl.appendChild(script);
        }
        return;
    };


    this.open = function (place, places, mapOptions) {
        c_self._place = place;
        if(! _widgetIsCreated ){
            c_self.createShareWidget();
        } else {
            c_self.loadShareWidget(place);
        }
        // tracks the place
        Ovi.Maps.Framework.Tracker.track('sharePlace', place);
    };

    /**
     * Gets the template and initializes the modal dialog
     */
    var init = function () {
        var	scriptParams = {
                protocol: "http:",
                domain: "ushare.it.ovi.com",
                path: "sharefrom/v1.0/init?country=GB&lang=en%22%3e%3c",
                checkFor: "ushare.it.ovi.com"
            };
        checkAndCreateScript( scriptParams );
    };

    init();
};


// Inheritance
// Ovi.Maps.Module.Places.UI.SharePlace.prototype = new Ovi.Maps.UI.Modal();
// Ovi.Maps.Module.Places.UI.SharePlace.constructor = Ovi.Maps.Module.Places.UI.SharePlace.prototype;

ts('Ovi.Maps.Module.Places.UI.SharePlace :: loaded');
