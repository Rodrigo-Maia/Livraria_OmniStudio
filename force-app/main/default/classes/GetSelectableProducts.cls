global with sharing class GetSelectableProducts implements Callable {

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
        List<Map<String, Object>> categoriesListMap = new List<Map<String, Object>>();
        String query = 'SELECT Categoria__c FROM Product2 WHERE Categoria__c <> null GROUP BY Categoria__c';
        List<AggregateResult> categoryList = Database.query(query);

System.debug(categoryList);

        for (AggregateResult p : categoryList) {
            Map<String, Object> option = new Map<String, Object>();
            option.put('value', p.get('Categoria__c'));
            option.put('name', p.get('Categoria__c'));
            categoriesListMap.add(option);
        }
        outMap.put('options', categoriesListMap);

System.debug(outMap);

        return categoriesListMap;
    }
}