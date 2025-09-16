@isTest
public class InwiB2C_EqualDynamicConditionTest {
    static testMethod void equallyTest(){
        Integer a = 12;
        Integer b=17;
        InwiB2C_EqualDynamicCondition InwiB2C_EqualDynamicCondition = new InwiB2C_EqualDynamicCondition();
        InwiB2C_EqualDynamicCondition.evaluate(a.format(),b.format());
    }

}