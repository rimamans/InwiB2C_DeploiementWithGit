global without sharing class inwiB2C_RemoteSleep implements vlocity_cmt.VlocityOpenInterface{
    global Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> output, Map<String, Object> options){
        if (methodName == 'RemoteSleep'){
            output.put('result', inwiB2C_RemoteSleep());
        }
       return true;
            
}

    String inwiB2C_RemoteSleep(){
        Integer milliseconds=1000;
        Long timeDiff = 0;
        DateTime firstTime = System.now();
        do
        {
            timeDiff = System.now().getTime() - firstTime.getTime();
        }
        while(timeDiff <= milliseconds);      
        return String.valueOf(milliseconds);
    }
}