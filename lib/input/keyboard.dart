part of vapor;

class Keyboard 
{
  static HashMap<int, bool> _previousFrame = new HashMap<int, bool>();
  static HashMap<int, bool> _currentFrame = new HashMap<int, bool>();
  static HashMap<int, bool> _nextFrame = new HashMap<int, bool>();

  Keyboard() 
  {
    document.onKeyDown.listen(_KeyDown);
    document.onKeyUp.listen(_KeyUp);
  }
  
  static void _KeyDown(KeyboardEvent event)
  {
      //window.console.log(event.keyCode.toString() + " was pressed.");
      //if (!_keys.containsKey(e.keyCode))
      //  _keys[e.keyCode] = e.timeStamp;
      _nextFrame[event.keyCode] = true;
  }
  
  static void _KeyUp(KeyboardEvent event)
  {
      //window.console.log(event.keyCode.toString() + " was released.");
      //_keys.remove(e.keyCode);
      _nextFrame[event.keyCode] = false;
  }

  /**
   * Check if the given key code is pressed. You should use the [KeyCode] class.
   */
  //isPressed(int keyCode) => _keys.containsKey(keyCode);
  
  /**
   * @private
   * Internal method to update the keyboard frame data (only used in Vapor.Game.Scene).
   */
  static void Update()
  {
      _previousFrame = new HashMap<int, bool>.from(_currentFrame);
      _currentFrame = new HashMap<int, bool>.from(_nextFrame);
      
      //Vapor.Input.Keyboard.previousFrame = JSON.parse(JSON.stringify(Vapor.Input.Keyboard.currentFrame));
      //Vapor.Input.Keyboard.currentFrame = JSON.parse(JSON.stringify(Vapor.Input.Keyboard.events));
  }

  /**
   * Gets the state for the given key code.
   * Returns true for every frame that the key is down, like autofire.
   * @param {Vapor.Input.KeyCode} keyCode The key code to check.
   * @returns {boolean} True if the key is currently down, otherwise false.
   */
  static bool GetKey(int keyCode)
  {
      return _currentFrame.containsKey(keyCode) && _currentFrame[keyCode];
  }

  /**
   * Returns true during the frame the user pressed the given key.
   * @param {Vapor.Input.KeyCode} keyCode The key code to check.
   * @returns {boolean} True if the key was pressed this frame, otherwise false.
   */
  static bool GetKeyDown(int keyCode)
  {
      return _currentFrame.containsKey(keyCode) && _currentFrame[keyCode] && (!_previousFrame.containsKey(keyCode) || !_previousFrame[keyCode]);
  }

  /**
   * Returns true during the frame the user released the given key.
   * @param {Vapor.Input.KeyCode} keyCode The key code to check.
   * @returns {boolean} True if the key was released this frame, otherwise false.
   */
  static bool GetKeyUp(int keyCode)
  {
      return _currentFrame.containsKey(keyCode) && !_currentFrame[keyCode] && _previousFrame[keyCode];
  }
}