/*
 * @preserve Copyright (C) 2010, Nokia gate5 GmbH Berlin
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

var Ovi = Ovi || {};
Ovi.Maps = Ovi.Maps || {};
Ovi.Maps.Module = Ovi.Maps.Module || {};

/**
 * Class to initialize Places. Designed to load as a standalone from the CDN
 */
Ovi.Maps.Module.Places = function () {

    /**
     * @type    {Ovi.Maps.Module.Places}
     */
    var self = this;

    /**
     * @type    {Boolean}
     */
    this.layersRegistered = false;

    /**
     * @type    {Boolean}
     */
    this.initialized = false;

    /**
     * @type    {Boolean}
     */
    this.panelLoaded = false;

    /**
     * Name of the cookie for generic access
     * @param   {String}
     */
    this.CREATEPLACE_COOKIE = 'json_plcCP';
    /**
     * Name of the cookie for returning to the detail container
     * @param   {String}
     */
    this.DETAILCONTAINER_COOKIE = 'dcOpen';


    /**
     * Reference to static host for image loading
     */
    var _staticHost = Ovi.Maps.Constants.StaticHost;

    var registerLHPView = function () {
        Ovi.Maps.UI.LeftHandPanel.registerView('Places', {
            'title': {
                itemId: 'placesTitle'
            },
            'slots': [
                {
                    itemId: 'directionsWaypoints',
                    animationIn: 'slideInFromTop',
                    animationOut: 'slideOutToTop',
                    hidden: true
                },
                {
                    itemId: 'placesContent'
                }
            ],
            'options': {
                headerBgClass: 'bg_0'
            }
        });
    };

    var registerLHPItems = function (args) {
        Ovi.Maps.UI.LeftHandPanel.registerItem('placesTitle', {
            node: args.nodes.title
        });
        Ovi.Maps.UI.LeftHandPanel.registerItem('placesContent', {
            node: args.nodes.content
        });
    };

    /**
     * Rendering the left hand panel
     *
     * @param   {Object}        params              optional object providing onRender callback
     */
    var renderPanel = function (params) {
        var options = {
            url: '/modules/places/html/panel.html',
            callback: function (args) {

                self.setup(args);
                $('#ovimaps.maps .panel .loader').hide();

                // due to some framework panel switch inconsitency
                window.setTimeout(function () {
                    Ovi.Maps.Module.Places.SearchPanel.initialize({
                        titleNode: args.nodes.title
                    });
                    if (params && params.onRender) {
                        params.onRender();
                    }
                    self.panelLoaded = true;
                }, 1);

                registerLHPItems(args);

            },
            nodeNames: {
                title: "div.title > *",
                content: "div.content >*"
            }
        };
        registerLHPView();

        self.loadContent(options);
    };

    /**
     * Loading the panel
     * @params  {?Object}       params              optional object providing onRender
     */
    var loadPanel = function (params) {
        Ovi.Debug.Console.log('loading panel');
        Ovi.Debug.Console.log('currmod places: ' + (Ovi.Maps.Module.Manager.currModule === 'Places'));
        Ovi.Debug.Console.log('panel element exist: ' + (Ovi.Maps.Framework.Components.PANEL_ELEMENT));
        if (Ovi.Maps.Framework.Components.PANEL_ELEMENT) {
            renderPanel(params);
        }
    };

    /**
     * @constructor
     */
    var initialize = function () {

        // setting correct image paths
        ovi.player.places.settings.setCategoryIconPath(_staticHost + '/core/img/common/category-icons/png_43x36_blue/');
        ovi.player.places.settings.setPrimePlaceCategoryIconPath(_staticHost + '/core/img/common/category-icons/png_43x36_blue_ad/');

        //set aggregated css urls
        ovi.player.places.settings.setAggregatedCssUrl(_staticHost + '/3rd-party/placesplayer/css');

        // premium provider icons
        ovi.player.places.settings.setPremiumProviderIconPath(_staticHost + '/3rd-party/placesplayer/css/img/common/56x59');
        ovi.player.places.settings.setReviewProviderIconPath(_staticHost + '/3rd-party/placesplayer/css/img/common/16x16');

        // general settings
        ovi.player.places.settings.setServerUrl(Ovi.Maps.Constants.placesUri + '/v1/places');

        renderPanel();

        ts('Ovi.Maps.Module.Places :: initialized');
    };


    /**
     * Registration of the search layers used by places module
     */
    var registerPlacesLayers = function () {
        if (!self.layersRegistered) {
            // background layer (for dots)
            Ovi.Maps.Framework.LayerManager.createLayer(self.id, {
                name: Ovi.Maps.Map.SEARCH_LAYER_DOTS,
                visibility: Ovi.Maps.Framework.LayerManager.LAYER_VISIBILITY_PUBLIC
            });
            // foreground layer (for markers)
            Ovi.Maps.Framework.LayerManager.createLayer(self.id, {
                name: Ovi.Maps.Map.SEARCH_LAYER,
                visibility: Ovi.Maps.Framework.LayerManager.LAYER_VISIBILITY_PUBLIC
            });
            // layer for the create place marker pin
            Ovi.Maps.Framework.LayerManager.createLayer(self.id, {
                name: Ovi.Maps.Map.CREATE_PLACE_LAYER,
                visibility: Ovi.Maps.Framework.LayerManager.LAYER_VISIBILITY_PUBLIC
            });
            // layer for the pins on the suggestions while creating a place
            Ovi.Maps.Framework.LayerManager.createLayer(self.id, {
                name: Ovi.Maps.Map.CREATE_PLACE_SUGGESTIONS_LAYER,
                visibility: Ovi.Maps.Framework.LayerManager.LAYER_VISIBILITY_PUBLIC
            });
            self.layersRegistered = true;
        }
    };

    /**
     * Show poin stored in cookie, either after login, create place incident repo etc..
     *
     * @todo    change this for the module manager cookie stuff
     */
    var showCookieStoredPOI = function () {
        var cookieStorage = Ovi.Maps.Framework.CookieStorage;

        // show stored poi only if there is no route
        if (!cookieStorage.contains(cookieStorage.types.route)) {

            // there was no route in a cookie. check for stored place (POI or Place)
            var pois = cookieStorage.get(cookieStorage.types.poi);
            if (pois && pois.length > 0) {

                // got ya!
                // there is either place or POI found in a cookie. it's stored in 1-elements array, so lets extract it here.
                var poi = pois[0];
                if (poi.isPlace && poi.placesState === Ovi.Maps.Module.Places.Enum.TemporaryState.STATE_RATE) {
                    Ovi.Maps.Map.Location.place = poi;
                    Ovi.Maps.Map.Location.address = poi.address;

                    poi.showState = Ovi.Maps.Module.Places.Enum.TemporaryState.STATE_RATE;
                    poi.isOpenFromStorage = true;

                    Ovi.Maps.Module.Places.UI.Bubble.open(poi);

                    // this function is now called in the open-func above.
                    // Ovi.Maps.Module.Places.UI.Bubble.centerBubbleOnMap();

                } else {
                    if (poi.placesState === Ovi.Maps.Module.Places.Enum.TemporaryState.STATE_CREATE_PLACE) {
                        Ovi.Maps.Module.Places.CreationBubble.openCreatePlace(poi);
                    }
                }

                // remove temporary poi data
                cookieStorage.deleteCookie(cookieStorage.types.poi);
            }
        }
    };

    /**
     * Called upon mapplayer load and the map is available - in the current implementation
     * the place model is set as a required dependency for the welcome module onMapAttach is
     * not called anymore
     */
    this.onMapAttach = function () {

        Ovi.Debug.Console.warn('Places onMapAttach fired');

        registerPlacesLayers();
        showCookieStoredPOI();

        if (!self.panelLoaded) {
            loadPanel();
        }

        // address bubble and detailcontainer deeplinking via hash
        if (!Ovi.Maps.Module.Places.CreatePlace.Container.createPlaceMode) {
            var userPosition = Ovi.Maps.Map.getUserPosition(),
                placesDeeplinking = Ovi.Maps.Framework.RequestParameter.get('plcsDl'),
                placeAddressFromURL = Ovi.Maps.Framework.RequestParameter.get('plcsAdd', Ovi.Maps.Framework.RequestParameter.get('plsAdd')),
                placesStatusReport = Ovi.Maps.Framework.RequestParameter.get('status');
            if (placesStatusReport) {
                this.showStatusReport();
                return;
            }
            // deeplink the address bubble - only once via cookie check
            if (placesDeeplinking === 'loc' && userPosition !== null) {
                this.showDeeplinkAddressBubble(userPosition, placeAddressFromURL);
            } else if (placesDeeplinking === 'dc') {
                var placeId = Ovi.Maps.Framework.RequestParameter.get('plcId');
                if (placeId && window.location.href.indexOf(placeId) === -1) {
                    this.showDeeplinkDetailContainer(placeId);
                }
            }
        }

        var placeCreation = (function () {
            return Cookie.get(self.CREATEPLACE_COOKIE);
        }());
        if (placeCreation && Ovi.Maps.Framework.UserAccount.isLoggedIn) {
            var coords = {
                latitude: placeCreation.coordinates.latitude,
                longitude: placeCreation.coordinates.longitude
            };
            
            // use 'true' to force the return even if outside BBX
            var pos = Ovi.Maps.Map.geoToPixel(coords, true);
            Ovi.Maps.Map.Location.createLocation(coords, function(location){
                location.mapScale = placeCreation.mapScale;
                Ovi.Maps.UI.LeftHandPanel.close();
                // module switch is needed here, as the default module is Welcome
                Ovi.Maps.Module.Manager.switchModule({
                    moduleName: Ovi.Maps.Module.Places.id
                });
                
                location.pixelPosition = {
                    x: pos.x - 3,
                    y: pos.y + 100 + 3
                };
                Ovi.Maps.Module.Places.CreatePlace.showLayers();
                Ovi.Maps.Module.Places.CreatePlace.ActiveMarker.openAddressBoxWrapper(location);
                Ovi.Maps.Module.Places.CreatePlace.ActiveMarker.createMapMarker(location);
            // Ovi.Maps.Module.Places.CreatePlace.Container.open(location);
            });
            Ovi.Maps.Map.moveTo(coords);
            
            Cookie.remove(self.CREATEPLACE_COOKIE);
        }

        var openDC = (function () {
            return Cookie.get(self.DETAILCONTAINER_COOKIE);
        }());
        if (openDC) {
            self.showDeeplinkDetailContainer(openDC.placeID, true);
        }
    };

    /**
     * Super function called by Framework module
     * @param {Object} args
     */
    this.setup = function (args) {
        Ovi.Debug.Console.warn('Panel HTML passed to me.');
        self.displayContent(args);

        if (window.location.href.indexOf('/services/search/') !== -1) {
            $('#search input')[0].value = decodeURI(String(window.location.href).split('/services/search/')[1].replace(/[\-\+]/gi, " ")).split('?')[0].split('#')[0];
        }

        this.initialized = true;
    };

    /**
     * Get poi data from cookie storage
     * @todo    change this for the module manager cookie stuff
     */
    this.readPoiFromCookie = function () {
        var pois = Ovi.Maps.Framework.CookieStorage.get(Ovi.Maps.Framework.CookieStorage.types.poi),
            place = null;

        if (pois.length > 0) {
            place = pois[0];
        }

        return place;
    };

    /**
     * Called when the module is opened for the second time
     */
    this.onReturn = function () {
        Ovi.Debug.Console.log('current module: ' + Ovi.Maps.Module.Manager.currModule);

        // Ovi.Maps.Module.Places.CreationBubble.showHowToLink(); // Causing JS error
        if (Ovi.Maps.Module.Places.UI.Bubble && Ovi.Maps.Module.Places.UI.Bubble.isOpen) {
            Ovi.Maps.Module.Places.UI.Bubble.show();
            Ovi.Maps.Module.Places.UI.Bubble.updatePosition();
        }
        if (Ovi.Maps.Map.Bubble && Ovi.Maps.Map.Bubble.isOpen) {
            Ovi.Maps.Map.Bubble.show();
            Ovi.Maps.Map.Bubble.updatePosition();
        }
    };

    /**
     * Is called when the module is shut down - we store the current module status
     * in order to restore it properly
     */
    this.onClose = function () {

        // Ovi.Maps.Module.Places.CreationBubble.hideHowToLink(); // Causing JS error
        if (Ovi.Maps.Module.Places.UI.Bubble && Ovi.Maps.Module.Places.UI.Bubble.close) {
            Ovi.Maps.Module.Places.UI.Bubble.close();
        }
        if (Ovi.Maps.Map.Bubble && Ovi.Maps.Map.Bubble.close) {
            Ovi.Maps.Map.Bubble.close();
        }
        if (Ovi.Maps.Module.Places.DetailContainer && Ovi.Maps.Module.Places.DetailContainer.isOpened()) {
            Ovi.Maps.Module.Places.DetailContainer.hide();
        }
        if (Ovi.Maps.Module.Places.ReportPlace && Ovi.Maps.Module.Places.ReportPlace.isOpened()) {
            Ovi.Maps.Module.Places.ReportPlace.hide();
        }
        if (Ovi.Maps.UI.Flag.close) {
            Ovi.Maps.UI.Flag.close();
        }
        if (Ovi.Maps.Module.Places.CreatePlace && Ovi.Maps.Module.Places.CreatePlace.ActiveMarker) {
            Ovi.Maps.Module.Places.CreatePlace.ActiveMarker.destroy();
        }
    };

    /**
     * Function called by the module manager when modules get switched.
     * @todo    use this, not the
     */
    this.saveToCookie = function () {
        var ret = true;
        return ret;
    };

    /**
     * Load saved state from cookie on reload of module
     */
    this.loadFromCookie = function () {
        var storage = Ovi.Maps.Framework.CookieStorage;
        var ret = true;
        return ret;
    };

    /**
     * Function zooms in to poi or bounding box if poi has one
     * @param   {Object}    poi         the poi passed from search
     * @todo    If bbox coordinates are delivered the map only zooms in but
     *          doesn't move to the selected poi
     */
    this.zoomInToPOI = function (poi) {
        var moveTo = {};

        // if we get a bounding box - we use it's coordinates as a point
        if (poi.geoBbxLatitude1 && poi.geoBbxLongitude2 && poi.geoBbxLatitude1 !== 0 && poi.geoBbxLongitude2 !== 0) {
            var boundingPoints = [{
                longitude: parseFloat(poi.geoBbxLongitude1),
                latitude: parseFloat(poi.geoBbxLatitude1)
            }, {
                longitude: parseFloat(poi.geoBbxLongitude2),
                latitude: parseFloat(poi.geoBbxLatitude2)
            }];
            moveTo.points = boundingPoints;
        } else {
            moveTo = {
                animationMode: 'none',
                animation: 'none',
                longitude: parseFloat(poi.longitude),
                latitude: parseFloat(poi.latitude),
                scale: Ovi.Maps.Map.ZOOM_STREET_LEVEL
            };
        }

        Ovi.Maps.Map.moveTo(moveTo);
        Ovi.Maps.UI.Flag.close();
    };

    /**
     * Function updates rating value accross components
     * @param   {Object}        params
     */
    this.updateRatings = function (model, from) {

        var player,
            ratingCompo, i;

        /**
         * To avoid updating already updated rating component
         */
        var FromEnum = Ovi.Maps.Module.Places.Enum.RatingUpdateFrom,
            placeId = model.getId(),
            $P = ovi.player.places;

        if (from !== FromEnum.SEARCH) {

            var searchListPLayers = Ovi.Maps.Module.Places.SearchPanel.placeList.players;
            for (i = 0, l = searchListPLayers.length; i < l; i += 1) {
                player = searchListPLayers[i];
                if (placeId === player.placeData.getId()) {
                    ratingCompo = player.getComponent($P.core.enums.Components.RATING);
                    ratingCompo.handleData(model);
                    return;
                }
            }

        }

        if (from !== FromEnum.BUBBLE) {
            player = Ovi.Maps.Module.Places.UI.Bubble.player;
            if (player) {
                ratingCompo = player.getComponent($P.core.enums.Components.RATING);
                ratingCompo.handleData(model);
            }
        }

        if (from !== FromEnum.DETAIL_CONTAINER) {
            ratingCompo = Ovi.Maps.Module.Places.DetailContainer.getRatingComponent();
            if (ratingCompo) {
                ratingCompo.handleData(model);
            }
        }
    };

    /**
     * If addition information in the url are provided upon first visit of the application
     * a reversely geocoded address bubble should be fetched. As we're not getting a fully build
     * headline
     *
     * @param   {Object}    user positions object providing {latitude, longitude}
     * @param   String      placeAddresss pass address before shortening for URL
     * @todo    When generalizing models - adapt the access as well
     */
    this.showDeeplinkAddressBubble = function (position, placeAddress) {
        var placeAddressArray = placeAddress.split(';');

        Ovi.Maps.Map.reverseGeoCode({ latitude: position.latitude, longitude: position.longitude }, function (location) {
            if (location[0] && location[0].latitude && location[0].longitude) {

                var geoPlace = location[0];
                var place = {address:{}};

                place.address.street = placeAddressArray[1] || geoPlace.ADDR_STREET_NAME || "";
                place.addrStreetName = geoPlace.ADDR_STREET_NAME;
                place.address.streetNumber = placeAddressArray[0] || geoPlace.ADDR_HOUSE_NUMBER || "";
                place.addrStreetNumber = geoPlace.ADDR_HOUSE_NUMBER;
                place.addrHouseNumber = geoPlace.ADDR_HOUSE_NUMBER;
                place.addrCountryCode = geoPlace.ADDR_COUNTRY_CODE;
                place.addrCountryName = geoPlace.ADDR_COUNTRY_NAME;
                place.address.postCode = placeAddressArray[2] || geoPlace.ADDR_POSTAL_CODE || "";
                place.addrPostalCode = geoPlace.ADDR_POSTAL_CODE;
                place.latitude = position.latitude;
                place.longitude = position.longitude;

                place.title = [];

                if (place.address.street) {
                    place.title.push(place.address.street);
                }
                if (place.address.streetNumber) {
                    place.title.push(place.address.streetNumber);
                }
                if (place.address.postCode) {
                    place.title.push(place.address.postCode);
                }
                if (place.address.city && place.address.city !== '') {
                    place.title.push(place.address.city);
                }
                if (place.address.country && place.address.country !== '') {
                    place.title.push(place.address.country);
                }
                place.title = place.title.join(', ');

                // add map icons manually
                place.mapIcons = [
                    _staticHost + '/core/img/common/map-icons/png_30x33_grey/empty.png',
                    _staticHost + '/core/img/common/map-icons/png_30x33_blue/empty.png'
                ];
                place.pageIndex = 1;
                place.showFlag = false;

                // mapmarker and finally bubble
                var object = Ovi.Maps.Map.createMapObjects({
                    type: 'marker',
                    latitude: place.latitude,
                    longitude: place.longitude,
                    icon: place.mapIcons[0],
                    clickable: false,
                    hasOwnInfoBubble: false, // point.isPlace,
                    handler: function () {
                    },
                    bind: place,
                    anchorPointX: 12,
                    anchorPointY: 27
                });
                object[0].res = place;

                Ovi.Maps.Map.addToLayer(object[0], Ovi.Maps.Map.SEARCH_LAYER);
                Ovi.Maps.Module.Places.UI.Bubble.open(place);
            }
        });
    };

    /**
     * Opens the detailcontainer for the given placeId
     *
     * @param   {String}        placeId             placeId to open the detailcontainer for
     */
    this.showDeeplinkDetailContainer = function (placeId, photoUploadInfoOpen) {
        var params = {
            placeId: placeId,
            onComplete: function(data){
                Ovi.Maps.UI.Navigation.navigateTo(Ovi.Maps.Module.Places.id);

                // remove current welcome panelContent - if possible
                // why is a module taking care of this? surely this should be handled by the FW? BG
                $('#panelContent').remove();

                var place = new ovi.player.places.models.PlaceModel(data),
                    searchPlace = Ovi.Maps.Module.Places.Util.createSearchObject(place);

                Ovi.Maps.Module.Places.SearchPanel.placeSearchSuccess([searchPlace], 'deeplink-place', {});

                Ovi.Maps.Module.Places.DetailContainer.show(place);
            }
        };

        // open bubble
        ovi.player.places.placesManager.getPlaceData(params); // end pp com getPlace
    };

    this.showStatusReport = function () {
        Ovi.Maps.Module.Places.DetailContainer.show("status");
    };

    /**
     * Function checks for disabled country for create place
     * @param {Object} countryCode 3-letter country code from reverseGeoCoding
     */
    this.isCountryDisabled = function (countryCode) {
        var disabledCountries = {
            CHN: 1,
            SAU: 1,
            ARE: 1,
            KAZ: 1,
            TWN: 1,
            ZWE: 1,
            ARG: 1,
            GRC: 1,
            PHL: 1,
            BGD: 1,
            TUN: 1,
            HND: 1,
            KWT: 1,
            YEM: 1,
            ISR: 1,
            CHL: 1,
            QAT: 1,
            OMN: 1,
            PAK: 1,
            BHR: 1,
            IRN: 1,
            BLR: 1,
            COL: 1,
            DZA: 1,
            BGR: 1,
            LBY: 1,
            IRQ: 1,
            KHM: 1,
            BIH: 1,
            MKD: 1,
            KOR: 1,
            SYR: 1,
            PRK: 1,
            VNM: 1,
            UGA: 1,
            ALB: 1,
            PER: 1,
            BWA: 1,
            LSO: 1,
            NAM: 1,
            SWZ: 1,
            AGO: 1,
            BEN: 1,
            BFA: 1,
            BDI: 1,
            CMR: 1,
            CPV: 1,
            CAF: 1,
            TCD: 1,
            COM: 1,
            COD: 1,
            COG: 1,
            CIV: 1,
            DJI: 1,
            GNQ: 1,
            ERI: 1,
            ETH: 1,
            GAB: 1,
            GMB: 1,
            GHA: 1,
            GIN: 1,
            GNB: 1,
            LBR: 1,
            MWI: 1,
            MLI: 1,
            MRT: 1,
            NER: 1,
            RWA: 1,
            SEN: 1,
            SLE: 1,
            SOM: 1,
            SDN: 1,
            TZA: 1,
            TGO: 1,
            ESH: 1,
            ZMB: 1,
            BOL: 1,
            ECU: 1,
            SLV: 1,
            FLK: 1,
            AFG: 1,
            ARM: 1,
            AZE: 1,
            BTN: 1,
            BRN: 1,
            MMR: 1,
            JPN: 1,
            KGZ: 1,
            LAO: 1,
            MDV: 1,
            NPL: 1,
            LKA: 1,
            TJK: 1,
            TKM: 1,
            UZB: 1,
            CYP: 1,
            GEO: 1,
            SRB: 1
        };
        return disabledCountries[countryCode];
    };


    // constructor call
    initialize();

};

ts('Ovi.Maps.Module.Places :: loaded');

Ovi.Maps.Module.Places.prototype = new Ovi.Maps.Module({ id: 'Places' });
Ovi.Maps.Module.Places.constructor = Ovi.Maps.Module.Places;
Ovi.Maps.Module.Places = new Ovi.Maps.Module.Places();
