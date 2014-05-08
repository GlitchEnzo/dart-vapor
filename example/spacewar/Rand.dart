part of Spacewar;

class Rand
{ 
    static Math.Random _random = new Math.Random();
    
    static double NextDouble()
    {
        return _random.nextDouble();
    }
    
    static int NextInt(int max)
    {
        return _random.nextInt(max);
    }
    
    /**
     * Returns a double in the given range.  Min, inclusive.  Max, exclusive.
     * 
     * http://stackoverflow.com/questions/929103/convert-a-number-range-to-another-range-maintaining-ratio
     */
    static double NextDoubleRange(double min, double max)
    {
        double oldRange = 1.0;
        double newRange = max - min;
        double oldValue = _random.nextDouble();
        double newValue = oldValue * newRange + min; //newValue = (((oldValue - oldMin) * newRange) / oldRange) + newMin;
        return newValue;
    }
    
    static int NextIntRange(int min, int max)
    {
        int newRange = max - min;
        int oldValue = _random.nextInt(newRange);
        int newValue = oldValue + min;
        return newValue;
    }
}