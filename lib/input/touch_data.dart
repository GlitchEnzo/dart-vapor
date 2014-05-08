part of vapor;

/**
 * Contains the data for a certain touch.
 */
class TouchData 
{
    /**
     * The unique index for touch.
     */
    int fingerId = 0;
    
    /**
     * The position of the touch.
     */
    Vector3 position = new Vector3(0.0, 0.0, 0.0);
    
    /**
     * The position delta since last change.
     */
    Vector3 deltaPosition = new Vector3(0.0, 0.0, 0.0);
    
    /**
     * Amount of time passed since last change.
     */
    double deltaTime = 0.0;
    
    /**
     * Number of taps.
     */
    int tapCount = 0;
    
    /**
     * Describes the phase of the touch.
     */
    String phase = TouchPhase.Began;
}