part of vapor;

/**
 * A static class offering access to time related fields.
 * @class Represents a Mesh
 */
class Time
{
    /**
     * The amount of time that has passed since the last frame, in seconds.
     */
    static double deltaTime = 0.0;
    
    static Stopwatch _stopwatch = new Stopwatch();
    
    static void Start()
    {
        _stopwatch.start();
    }
    
    /**
     * @private
     */
    static void Update()
    {
        if (!_stopwatch.isRunning)
        {
            _stopwatch.start();
        }
        
        deltaTime = _stopwatch.elapsedMilliseconds / 1000.0;
        _stopwatch.reset();
        
        //window.console.log(deltaTime);
    }
}


