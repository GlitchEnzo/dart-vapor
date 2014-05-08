part of LongJump;

class FollowObject extends Component
{
    GameObject target;
    
    void Update()
    {
        transform.position = new Vector3(target.transform.position.x, target.transform.position.y + 4.0, transform.position.z);
    }
}