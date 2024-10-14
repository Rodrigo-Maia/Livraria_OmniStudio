global class BuscarEndereco implements Callable { 

    public Map<String, Object> call(String action, Map<String, Object> args) 
    {

System.debug(args);

        Map<String, Object> input = (Map<String, Object>)args.get('input');
        Map<String, Object> output = (Map<String, Object>)args.get('output');
        output.put('response', getAddress(String.valueOf(input.get('zipCode'))));

        return output;
    }

    private Map<String, Object> getAddress(String zipcode)
    {
        String url = 'https://viacep.com.br/ws/' + zipcode + '/json/';
        Map<String, Object> outMap = new Map<String, Object>();

        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');

            Http http = new Http();
            HttpResponse res;
            res = http.send(req);

            if (res?.getStatusCode() == 200) {
                outMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            }
            
        } catch (Exception e) {
            outMap = new Map<String, Object>{'Erro:' => 'Falha na chamada externa', 'log' => e.getMessage()};
            throw new CalloutException('Falha na chamada externa. Código de status: ' + e.getMessage());
        }
        return outMap;
    }
}