define [], ->

    class ImageLoaderStatus

        # The image was not requested yet
        @PENDING = 1

        # The image is loading
        @LOADING = 2

        # The image loading is complete
        @COMPLETE = 3

        # An error has occurred while loading the image
        @ERROR = -1

        # The loading was aborted
        @ABORTED = -2


    class ImageLoaderConstants

        # Define the number of images to load in the background
        @BACKGROUND_DOWNLOADS = 2

        # Define the delay between background requests
        @DELAY = 100



    # @class Define the class to smart load an list of images.
    class ImageLoaderInstance

        # @constructor
        constructor: ->
            # The list of all images
            @_images = {}

            # The list of lists of images to load
            @_lists = {}

            # This list of images to be loaded in the background
            @_optionalLoadList = []


        # Set the list of images that can be requested.
        #
        # @param list An object containing key/value pair of imageName/ImageURL
        setList: (list) ->
            @_processList list


        # Process the list of images to load.
        #
        # @param list The list of images
        _processList: (list) ->
            for imageListName, imageList of list
                listImages = {}

                for imageName, imageURL of imageList
                    imageInfo =
                        url: imageURL
                        status: ImageLoaderStatus.PENDING
                        callbackList: []
                        name: imageName

                    @_images[imageName] = listImages[imageName] = imageInfo

                @_lists[imageListName] = listImages


        # Start loading the images.
        #
        # @param required The lists that are required to be loaded before calling the complete function
        # @param optional The lists to be loading on background
        startLoading: (required, background) ->
            # Get the list of images required to be loaded before we call the complete callback
            requiredImages = @_getLists required.list

            # Get the list of images to be loaded in background after we complete the required images loading
            optionalImages = @_getLists background.list

            internalCompleteCallback = =>
                # Load the optional list in the background
                @_loadOptionalList optionalImages, background.progressCallback, background.completeCallback

                required.completeCallback?.apply @, arguments

            # Load the required list
            @_loadList requiredImages, required.progressCallback, internalCompleteCallback


        # Get the list of images to load given the lists
        #
        # @param listNames The list of list names to add to the list of images to load.
        #
        # @return The list of images to load
        _getLists: (listNames) ->
            list = {}

            for listName in listNames
                for key, value of @_lists[listName]
                    list[key] = value

            list


        # Attach a callback to an image to be called when it has been loaded.
        #
        # @param imageInfo The image info to attach the callback
        # @param callback The callback
        _attachCallback: (imageInfo, callback) ->
            if callback?
                imageInfo.callbackList.push =>
                    callback.apply @, arguments


        # Call all the callbacks attached to a image info.
        #
        # @param imageInfo The image info to call the callbacks
        _callCallbacks: (imageInfo) ->
            if imageInfo? and imageInfo.callbackList.length > 0
                for callback in imageInfo.callbackList
                    do (callback) =>
                        @_defer ->
                            callback imageInfo.image, imageInfo

                imageInfo.callbackList = []


        # Load the list of images.
        #
        # @param list The list of images to load
        # @param progressCallback Function to call whenever a progress is made in the image loading
        # @param completeCallback Function to call after we have finished
        _loadList: (list, progressCallback, completeCallback) ->
            numComplete = numSuccesses = numImages = 0

            callProgress = (total, complete, success) =>
                @_defer progressCallback, total, complete, success

            callComplete = =>
                @_defer completeCallback

            # Called when we load an image.
            #
            # @param status the load status
            complete = (imageInfo, status) =>
                if imageInfo?
                    imageInfo.status = status
                    numComplete++

                if status > 0
                    numSuccesses++

                if progressCallback?
                    callProgress numImages, numComplete, numSuccesses

                if numComplete is numImages and completeCallback?
                    callComplete()

                @_callCallbacks imageInfo


            for imageName, imageInfo of list
                do (imageName, imageInfo) =>
                    numImages++

                    if imageInfo.status isnt ImageLoaderStatus.COMPLETE and
                       imageInfo.status isnt ImageLoaderStatus.LOADING

                        image = new Image()
                        image.onload = ->
                            complete imageInfo, ImageLoaderStatus.COMPLETE

                        image.onabort = ->
                            complete imageInfo, ImageLoaderStatus.ABORTED

                        image.onerror = ->
                            complete imageInfo, ImageLoaderStatus.ERROR

                        imageInfo.image = image
                        imageInfo.status = ImageLoaderStatus.LOADING

                        image.src = imageInfo.url

                    else if imageInfo.status is ImageLoaderStatus.COMPLETE
                        @_defer ->
                            complete imageInfo, ImageLoaderStatus.COMPLETE

                    else if imageInfo.status is ImageLoaderStatus.LOADING
                        @_attachCallback imageInfo, (image, imageInfo) ->
                            complete imageInfo, imageInfo.status

            imageNames = (imageName for imageName of list)
            if imageNames.length == 0
                if progressCallback?
                    callProgress numImages, numComplete, numSuccesses

                if completeCallback?
                    callComplete()


        # Load the optional list of images
        #
        # @param optionalLists The list of images to be downloaded in the background
        # @param completeCallback The complete callback
        # @param progressCallback The progress callback
        _loadOptionalList: (optionalLists, progressCallback, completeCallback) ->
            # Stop any background loading
            @_stopBackgroundLoad()

            # Add the images to the list of images to load in the background
            @_addImagesToBackgroundLoadList optionalLists

            # Start the background loading
            @_startBackgroundLoad progressCallback, completeCallback


        # Add the list of images to the array of images to be loaded in the background.
        #
        # @param list The list of images to load in the background
        _addImagesToBackgroundLoadList: (list) ->
            internalList = []
            for imageName, imageInfo of list
                if imageInfo.status isnt ImageLoaderStatus.COMPLETE and
                   imageInfo.status isnt ImageLoaderStatus.LOADING

                    internalList.push imageInfo

            # Reverse the order of the element in the array
            internalList.reverse()

            # Add it to the optional load list
            @_optionalLoadList = internalList.concat @_optionalLoadList

            # Remove any image that was already loaded or in being loaded
            @_optionalLoadList = @_filterCompleteOrInProgress @_optionalLoadList

            # Store the initial length
            @_initialOptionalLoadListLength = @_optionalLoadList.length

            # The number of background images loaded
            @_optionalLoadCompleteNumber = 0
            @_optionalLoadSuccessNumber = 0


        # Filter the complete and in progress image info from the list
        #
        # @param list The list to filer
        #
        # @return The new list filtered
        _filterCompleteOrInProgress: (list) ->
            (imageInfo for imageInfo in list when imageInfo.status isnt ImageLoaderStatus.COMPLETE and
                                                  imageInfo.status isnt ImageLoaderStatus.LOADING)


        # Start the background image load.
        _startBackgroundLoad: (progressCallback, completeCallback) ->
            @_backgroundLoadingStarted = true

            @_delay =>
                @_processBackgroundLoad progressCallback, completeCallback
            , ImageLoaderConstants.DELAY


        # Process the background image load.
        _processBackgroundLoad: (progressCallback, completeCallback) ->
            if @_backgroundLoadingStarted
                partialrequiredList = []

                # Get the images to be loaded in the background
                for [1..ImageLoaderConstants.BACKGROUND_DOWNLOADS]
                    if @_optionalLoadList.length > 0
                        partialrequiredList.push @_optionalLoadList.pop()

                if partialrequiredList.length > 0
                    previousSuccess = 0

                    # Callback function called when each partial load list item is complete.
                    partialProgressCallback = (total, complete, success) =>
                        @_optionalLoadCompleteNumber++
                        @_optionalLoadSuccessNumber++ if previousSuccess < success
                        previousSuccess = success

                        progressCallback? @_initialOptionalLoadListLength, @_optionalLoadCompleteNumber, @_optionalLoadSuccessNumber

                    # Callback function called on each time we complete the partial load list.
                    partialCompleteCallback = =>
                        if @_optionalLoadList.length is 0
                            completeCallback?()
                        else
                            @_delay =>
                                @_processBackgroundLoad progressCallback, completeCallback
                            , ImageLoaderConstants.DELAY

                    # Set to load the partial list
                    @_loadList partialrequiredList, partialProgressCallback, partialCompleteCallback

                else
                    @_stopBackgroundLoad()


        # Stop the background image load.
        _stopBackgroundLoad: ->
            @_backgroundLoadingStarted = false


        # Get the image.
        # If the image is available, it will be returned immediately and the callback will also be called asynchronously.
        # Otherwise, the image will be asynchronously loaded and the callback will be called.
        #
        # @param imageName The name of the image to get
        # @param callback The function to call
        #
        # @return The image, if it is available or null otherwise
        getImage: (imageName, callback) ->
            imageInfo = @_getImageInfo imageName

            image = null

            if imageInfo.status is ImageLoaderStatus.COMPLETE
                image = imageInfo.image;

                if callback?
                    @_defer ->
                        callback imageInfo.image

            else if imageInfo.status is ImageLoaderStatus.LOADING
                @_attachCallback imageInfo, callback

            else
                @_attachCallback imageInfo, callback
                @_loadList [imageInfo]

            image


        # Get the image info.
        #
        # @param imageName The image name
        #
        # @return The image info
        _getImageInfo: (imageName) ->
            @_images[imageName]


        # Defers a function, scheduling it to run after the current call stack has
        # cleared.
        #
        # @param deferredFunction Function to be deferred
        _defer: (deferredFunction) ->
            args = [].slice.call arguments, 1
            func = ->
                deferredFunction.apply null, args

            @_delay func, 1

        # Delays a function for the given number of milliseconds, and then calls
        # it with the arguments supplied.
        #
        # @param delayedFunction
        # @param delay
        _delay: (delayedFunction, delay) ->
            args = [].slice.call arguments, 2
            func = ->
                delayedFunction.apply null, args

            setTimeout func, delay



    class ImageLoader

        @_instance = new ImageLoaderInstance unless @_instance?

        # Get the image by its name.
        #
        # @param imageName The image name
        # @param callback The function to call
        #
        # @return The image it is available, or null otherwise
        @getImage: (imageName, callback) ->
            @_instance.getImage imageName, callback


        # Add to the list of images that can be requested.
        #
        # @param List an object containing key/value pair of imageName/ImageURL
        @addToList: (list) ->
            @_instance.setList list


        # Load the images.
        #
        # @param completeCallback Callback to call when we finished loading the required list
        #
        # @param required An object in the following form:
        #                 @param list The list of required images lists
        #                 @param completeCallback Callback to call when we finished loading the required list
        #                 @param progressCallback Callback to call while we are loading the required list of images
        # @param background the list of optional images lists
        #                 @param list The list of images to be loaded in the background
        #                 @param completeCallback Callback to call when we finished loading the required list
        #                 @param progressCallback Callback to call while we are loading the required list of images
        @loadImages: (required, background) ->
            if not required?
                required =
                    list: []
                    progressCallback: null
                    completeCallback: null

            if not background?
                background =
                    list: []
                    progressCallback: null
                    completeCallback: null

            @_instance.startLoading required, background


        # Load lists of images.
        #
        # @param lists The lists to be loaded
        # @param onStart The start callback function
        # @param onProgress The progress callback function
        # @param onFinish The finish callback function
        @loadLists: (lists, onStart, onProgress, onFinish) ->

            # Callback function to be called at the start of the image loading process.
            startCallback = ->
                onStart?()

            # Callback function to be called after each loaded image.
            #
            # @param total The number of total images
            # @param complete The number of complete images
            # @param success The number of success images
            progressCallback = (total, complete, success) ->
                percentage = parseInt (complete / total) * 100, 10
                onProgress? percentage

            # Callback function to be called after all images have been loaded.
            completeCallback = ->
                onFinish?()

            required =
                list: lists.required || []
                progressCallback: progressCallback
                completeCallback: completeCallback

            background =
                list: lists.background || []
                progressCallback: null
                completeCallback: null

            startCallback()
            @loadImages required, background
