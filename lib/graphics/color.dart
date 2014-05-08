part of vapor;

class Color
{
  /**
   * Creates a new Color from the given integers.
   * @param {int} r Red. 0-255.
   * @param {int} g Green. 0-255.
   * @param {int} b Blue. 0-255.
   * @param {int} a Alpha. 0-255.
   * @returns {Vapor.Color} The new Color.
   */
  static Vector4 FromInts(int r, int g, int b, int a)
  {
    return new Vector4(r / 255.0, g / 255.0, b / 255.0, a / 255.0);
  }
  
  /**
   * Red (255, 0, 0, 255)
   */
  static Vector4 Red = new Vector4(1.0, 0.0, 0.0, 1.0);
  
  /**
   * Green (0, 255, 0, 255)
   */
  static Vector4 Green = new Vector4(0.0, 1.0, 0.0, 1.0);
  
  /**
   * Blue (0, 0, 255, 255)
   */
  static Vector4 Blue = new Vector4(0.0, 0.0, 1.0, 1.0);
  
  /**
   * Cornflower Blue (100, 149, 237, 255)
   */
  static Vector4 CornflowerBlue = FromInts(100, 149, 237, 255);

  /**
   * Unity Blue (49, 77, 121, 255)
   */
  static Vector4 UnityBlue = FromInts(49, 77, 121, 255);

  /**
   * Solid Black (0, 0, 0, 255)
   */
  static Vector4 SolidBlack = new Vector4(0.0, 0.0, 0.0, 1.0);

  /**
   * Solid White (255, 255, 255, 255)
   */
  static Vector4 SolidWhite = new Vector4(1.0, 1.0, 1.0, 1.0);

  /**
   * Transparent Black (0, 0, 0, 0)
   */
  static Vector4 TransparentBlack = new Vector4(0.0, 0.0, 0.0, 0.0);

  /**
   * Transparent White (255, 255, 255, 0)
   */
  static Vector4 TransparentWhite = new Vector4(1.0, 1.0, 1.0, 0.0);
}