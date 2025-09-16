public class InwiB2C_EqualDynamicCondition implements InwiB2C_DynamicCondition {
    public Object evaluate(Object a, Object b) {
        return (String)a == (String)b;
    }
}