part of vapor;

class FileDownloader
{
//    String url;
//    HttpRequest request;
//    
//    FileDownloader(String url)
//    {
//        this.url = url;
//        this.request = null;
//    }
    
    /**
     * Download the file at the given URL.  
     * It defaults to download sychronously.
     * You can optionally provide a callback function which forces it to download asychronously.
     * The callback is in the form: void Callback(ProgressEvent event)
     */
    static HttpRequest Download(String url, [void callback(ProgressEvent event)])
    {
        HttpRequest request = new HttpRequest();
        
        if (callback == null)
        {
            //window.console.log("Sending synchronous request");
            
            try
            {
                request.open('GET', url, async : false);
                request.send();
            }
            catch (e)
            {
                // swallow exception?
                window.console.log("Exception caught in FileDownloader.Download()");
            }
            
            if (request.status == 200) 
            {
                //window.console.log("Successful response");
                //window.console.log(this.request.responseText);
            }
            else
            {
                window.console.log("FileDownloader Error! " + request.status.toString() + " " + request.statusText);
            }
        }
        else // asynchronous request
        {
            window.console.log("Sending asynchronous request");
            
            // the callback is defined so send an asynchronous request
            request.open('GET', url, async : true);
            request.onReadyStateChange.listen(callback);
            //window.console.error("Callback not hooked up.  Will not work.");
            request.send();
        }
        
        return request;
    }

    /*
    Vapor.Utilities.FileDownloader.prototype.CheckExists = function(callback)
    {
        this.request = new XMLHttpRequest();
        
        if (callback === undefined)
        {
            //console.log("Sending synchronous request");
            
            try
            {
                this.request.open('HEAD', this.url, false);
                this.request.send();
            }
            catch (e)
            {
                // swallow exception?
                console.log("Exception caught in FileDownloader.Download()");
            }
            
            if (this.request.status === 200) 
            {
                //console.log(this.request.responseText);
                //console.log("Successful response " + this.request.responseText);
                return true;
            }
            else
            {
                console.log("FileDownloader Error! " + this.request.status + " " + this.request.statusText);
                return false;
            }
        }
        else
        {
            console.log("Sending asynchronous request");
        
            // the callback is defined so send an asynchronous request
            this.request.open('GET', url, true);
            this.request.onreadystatechange = callback;
            this.request.send();
        }
    }
    */
}



/*
Vapor.Utilities.Web = {};

// Static variable representing the sent XMLHttpRequest
Vapor.Utilities.Web.request = null;

function handler(evtXHR)
{
    if (Vapor.Utilities.Web.request.readyState == 4)
    {
        if (Vapor.Utilities.Web.request.status == 200)
        {
            console.log("Received: " + Vapor.Utilities.Web.request.responseText);
        }
        else
        {
            alert("XMLHttpRequest Error! " + Vapor.Utilities.Web.request.status);
        }
    }
}

Vapor.Utilities.Web.DownloadFile = function(url)
{
    //var url = 'http://www.phobos7.co.uk/research/xss/simple.php'; 
    
    Vapor.Utilities.Web.request = new XMLHttpRequest();
    Vapor.Utilities.Web.request.open('GET', url, true);
    Vapor.Utilities.Web.request.onreadystatechange = handler;
    Vapor.Utilities.Web.request.send();
} 
*/

