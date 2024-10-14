global with sharing class GetRecordType implements Callable{

    global Object call(String action, Map<String, Object> args)
    {

System.debug(args);

        switch on action {
            when 'selectOptions' {
            return selectOptions((Map<String, Object>)args.get('input'), (Map<String, Object>)args.get('output'));
            }
        }
        return null;
    }

    private List<Map<String, Object>> selectOptions(Map<String, Object> inputMap, Map<String, Object> outMap)
    {
        List<Map<String, Object>> outList = new List<Map<String, Object>>();

        for (SObject rt : [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Product2']) {

System.debug(rt);
System.debug(rt.get('Id'));

            Map<String, Object> option = new Map<String, Object>();
            option.put('value', rt.get('DeveloperName'));
            option.put('name', rt.get('Id'));
            outList.add(option);
        }
        outMap.put('options', outList);

System.debug(outMap);

        return outList;
    }
}