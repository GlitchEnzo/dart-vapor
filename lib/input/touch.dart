part of vapor;

class Touch 
{
  //static HashMap<int, bool> _previousFrame = new HashMap<int, bool>();
  //static HashMap<int, bool> _currentFrame = new HashMap<int, bool>();
  //static HashMap<int, bool> _nextFrame = new HashMap<int, bool>();
    
    static List<TouchData> _previousFrame = new List();
    static List<TouchData> _currentFrame = new List();
    static List<TouchData> _nextFrame = new List();

  Touch() 
  {
    document.onTouchStart.listen(_TouchStart);
    document.onTouchEnd.listen(_TouchEnd);
    document.onTouchMove.listen(_TouchMove);
  }
  
  // touches: a list of all fingers currently on the screen.
  // changedTouches: a list of fingers involved in the current event. For example, in a touchend event, this will be the finger that was removed.
  // radius coordinates and rotationAngle: describe the ellipse that approximates finger shape.
  
  static void _TouchStart(TouchEvent event)
  {
      // prevent the mobile defaults (pinch zoom, etc)
      event.preventDefault();
      
      TouchList changedTouches = event.changedTouches;
      
      for (int i = 0; i < changedTouches.length; i++)
      {
          // try to find an existing touch object with the same ID
          bool found = false;
          for (int j = 0; j < _nextFrame.length; j++)
          {
              if (changedTouches[i].identifier == _nextFrame[j].fingerId)
              {
                  found = true;
                  break;
              }
          }
          
          // if an existing touch object wasn't found, create a new one
          if (!found)
          {
              TouchData newTouch = new TouchData();
              newTouch.fingerId = changedTouches[i].identifier;
              newTouch.position = new Vector3(changedTouches[i].screen.x, changedTouches[i].screen.y, 0.0);
              //newTouch.deltaPosition = new Point(0.0, 0.0);
              //newTouch.deltaTime = 0.0;
              //newTouch.tapCount = 0;
              //newTouch.phase = TouchPhase.Began;
              
              //console.log("Added touch");
              _nextFrame.add(newTouch);
          }
      }
  }
  
  static void _TouchEnd(TouchEvent event)
  {
      //console.log("Touch End " + event.touches);
      
      TouchList changedTouches = event.changedTouches;
      
      for (int i = 0; i < changedTouches.length; i++)
      {
          var newTouch = changedTouches[i];
          for (int j = 0; j < _nextFrame.length; j++)
          {
              TouchData oldTouch = _nextFrame[j];
              if (newTouch.identifier == oldTouch.fingerId)
              {
                  oldTouch.deltaPosition = new Vector3(newTouch.screen.x - oldTouch.position.x, newTouch.screen.y - oldTouch.position.y, 0.0);
                  oldTouch.position = new Vector3(newTouch.screen.x, newTouch.screen.y, 0.0);
                  oldTouch.deltaTime = Time.deltaTime;
                  oldTouch.tapCount = 0;
                  oldTouch.phase = TouchPhase.Ended;
              }
          }
      }
  }
  
  static void _TouchMove(TouchEvent event)
  {
      //console.log("Touch Move " + event.touches);
      
      TouchList changedTouches = event.changedTouches;
      
      for (int i = 0; i < changedTouches.length; i++)
      {
          var newTouch = changedTouches[i];
          for (int j = 0; j < _nextFrame.length; j++)
          {
              TouchData oldTouch = _nextFrame[j];
              if (newTouch.identifier == oldTouch.fingerId)
              {
                  oldTouch.deltaPosition = new Vector3(newTouch.screen.x - oldTouch.position.x, newTouch.screen.y - oldTouch.position.y, 0.0);
                  oldTouch.position = new Vector3(newTouch.screen.x, newTouch.screen.y, 0.0); //use client instead?
                  oldTouch.deltaTime = Time.deltaTime;
                  oldTouch.tapCount = 0;
                  oldTouch.phase = TouchPhase.Moved;
              }
          }
      }
  }
  
  /**
   * @private
   * Internal method to update the mouse frame data (only used in Vapor.Game.Scene).
   */
  static void Update()
  {      
      _previousFrame = new List.from(_currentFrame);
      _currentFrame = new List.from(_nextFrame);
      
      // remove the touches that have ended from the next frame
      if (_nextFrame != null)
      {
          _nextFrame.removeWhere((touch) => touch.phase == TouchPhase.Ended);
//          for (var i = 0; i < _nextFrame.length; i++)
//          {
//              if (_nextFrame[i].phase == TouchPhase.Ended)
//              {
//                  _nextFrame.removeAt(i);
//              }
//          }
      }
  }
  
  /**
   * Gets the touch object stored at the given index.
   * @param {int} index The index of the touch to get.
   * @returns {Vapor.Input.Touch} The touch object at the given index
   */
  static TouchData GetTouch(int index)
  {
      return _currentFrame[index];
  }
  
  /**
   * Number of touches. Guaranteed not to change throughout the frame.
   */
  static int get touchCount => _currentFrame.length;

  /**
   * Gets the state for the given mouse button index.
   * Returns true for every frame that the button is down, like autofire.
   * @param {int} button The mouse button index to check. 0 = left, 1 = middle, 2 = right.
   * @returns {boolean} True if the button is currently down, otherwise false.
   */
//  static bool GetMouseButton(int button)
//  {
//      return _currentFrame.containsKey(button) && _currentFrame[button];
//  }

  /**
   * Returns true during the frame the user pressed the given mouse button.
   * @param {int} button The mouse button index to check. 0 = left, 1 = middle, 2 = right.
   * @returns {boolean} True if the button was pressed this frame, otherwise false.
   */
//  static bool GetMouseButtonDown(int button)
//  {
//      return _currentFrame.containsKey(button) && _currentFrame[button] && (!_previousFrame.containsKey(button) || !_previousFrame[button]);
//  }

  /**
   * Returns true during the frame the user releases the given mouse button.
   * @param {int} button The mouse button index to check. 0 = left, 1 = middle, 2 = right.
   * @returns {boolean} True if the button was released this frame, otherwise false.
   */
//  static bool GetMouseButtonUp(int button)
//  {
//      return _currentFrame.containsKey(button) && !_currentFrame[button] && _previousFrame[button];
//  }
}