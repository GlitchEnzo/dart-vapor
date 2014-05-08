part of vapor;

class Mouse 
{
  static HashMap<int, bool> _previousFrame = new HashMap<int, bool>();
  static HashMap<int, bool> _currentFrame = new HashMap<int, bool>();
  static HashMap<int, bool> _nextFrame = new HashMap<int, bool>();
  
  static Vector3 _nextMousePosition = new Vector3.zero();
  
  static Vector3 mousePosition = new Vector3.zero();
  static Vector3 deltaMousePosition = new Vector3.zero();

  Mouse() 
  {
    document.onMouseDown.listen(_MouseDown);
    document.onMouseUp.listen(_MouseUp);
    document.onMouseMove.listen(_MouseMove);
  }
  
  static void _MouseDown(MouseEvent event)
  {
      //window.console.log(event.button.toString() + " pressed");
      //window.console.log(event.client.toString());
      _nextFrame[event.button] = true;
  }
  
  static void _MouseUp(MouseEvent event)
  {
      //window.console.log(event.button.toString() + " released");
      _nextFrame[event.button] = false;
  }
  
  static void _MouseMove(MouseEvent event)
  {
      //window.console.log(event.client.toString());
      _nextMousePosition.x = event.client.x * 1.0;
      _nextMousePosition.y = event.client.y * 1.0;
      
      Vector3 screenSpace = new Vector3.copy(_nextMousePosition);
      screenSpace.x /= window.innerWidth;
      screenSpace.y /= window.innerHeight;
      
      screenSpace.x = screenSpace.x * 2 - 1;
      screenSpace.y = screenSpace.y * 2 - 1;
      
      screenSpace.y = -screenSpace.y;
      
      //window.console.log(screenSpace.toString());
  }
  
  /**
   * @private
   * Internal method to update the mouse frame data (only used in Vapor.Game.Scene).
   */
  static void Update()
  {
      deltaMousePosition.x = _nextMousePosition.x - mousePosition.x;
      deltaMousePosition.y = _nextMousePosition.y - mousePosition.y;
      
      mousePosition.x = _nextMousePosition.x;
      mousePosition.y = _nextMousePosition.y;
      
      _previousFrame = new HashMap<int, bool>.from(_currentFrame);
      _currentFrame = new HashMap<int, bool>.from(_nextFrame);
  }

  /**
   * Gets the state for the given mouse button index.
   * Returns true for every frame that the button is down, like autofire.
   * @param {int} button The mouse button index to check. 0 = left, 1 = middle, 2 = right.
   * @returns {boolean} True if the button is currently down, otherwise false.
   */
  static bool GetMouseButton(int button)
  {
      return _currentFrame.containsKey(button) && _currentFrame[button];
  }

  /**
   * Returns true during the frame the user pressed the given mouse button.
   * @param {int} button The mouse button index to check. 0 = left, 1 = middle, 2 = right.
   * @returns {boolean} True if the button was pressed this frame, otherwise false.
   */
  static bool GetMouseButtonDown(int button)
  {
      return _currentFrame.containsKey(button) && _currentFrame[button] && (!_previousFrame.containsKey(button) || !_previousFrame[button]);
  }

  /**
   * Returns true during the frame the user releases the given mouse button.
   * @param {int} button The mouse button index to check. 0 = left, 1 = middle, 2 = right.
   * @returns {boolean} True if the button was released this frame, otherwise false.
   */
  static bool GetMouseButtonUp(int button)
  {
      return _currentFrame.containsKey(button) && !_currentFrame[button] && _previousFrame[button];
  }
}