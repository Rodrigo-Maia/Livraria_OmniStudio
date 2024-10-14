global class GetAddress implements omnistudio.VlocityOpenInterface, Callable {

    global Boolean call(String action, Map<String, Object> args)
    {    
        if (action == 'getAddressByCep'){
            Map<String, Object> inputParams = (Map<String, Object>) args.get('input');
            getAddressByCep(inputParams, args);
        } else {
            throw new ExtensionMalformedCallException('Method not implemented');
        }
        return true;
    }

    public class ExtensionMalformedCallException extends Exception {}

    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) 
    {

System.debug(input);

        if (methodName.equals('getAddressByCep')) {
            getAddressByCep(input, outMap);
        }
        return true;
    }

    public void getAddressByCep(Map<String,Object> input, Map<String,Object> outMap) 
    {

System.debug(input);

        String cep = '35424300';
        String url = 'https://viacep.com.br/ws/' + cep + '/json/';

        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            
            Http http = new Http();
            HttpResponse res;
            res = http.send(req);
    
            if (res.getStatusCode() == 200) {
                outMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

System.debug(outMap);

            }
        } catch (Exception e) {

System.debug(e.getMessage());

            throw new CalloutException('Falha na chamada externa. Código de status: ' + e.getMessage());
        }
    }
}