part of vapor;

/**
 * Represents audio data.
 */
class Audio
{
    /**
     * Static AudioContext that is used to play all audio.
     */
    static AudioContext context = new AudioContext();
    
    /**
     * The name of this Audio data.  Defaults to "Audio".
     */
    String name = "Audio";
    
    /**
     * True if the audio file is loaded.
     */
    bool loaded = false;

    Audio(String filePath)
    {
        FileDownloader.Download(filePath, _Loaded);
    }
    
    void _Loaded(ProgressEvent event)
    {
        window.console.log("Loaded " + event.loaded.toString());
        loaded = true;
    }
}