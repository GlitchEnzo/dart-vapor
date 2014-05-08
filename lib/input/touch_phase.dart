part of vapor;

/**
 * Enumeration of the possible touch phases.
 */
class TouchPhase
{
    /**
     * A finger touched the screen.
     */
    static String Began = "TouchPhase.Began";
    
    /**
     * A finger moved on the screen.
     */
    static String Moved = "TouchPhase.Moved";
    
    /**
     * A finger is touching the screen but hasn't moved.
     */
    static String Stationary = "TouchPhase.Stationary";
    
    /**
     * A finger was lifted from the screen. This is the final phase of a touch.
     */
    static String Ended = "TouchPhase.Ended";
    
    /**
     * The system cancelled tracking for the touch. This is the final phase of a touch.
     */
    static String Canceled = "TouchPhase.Canceled";
}