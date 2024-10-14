@isTest
public class BuscarEnderecoTest {

    public class MockHttpResponseSuccess implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"cep": "01001-000", "logradouro": "Praça da Sé", "complemento": "", "bairro": "Sé", "localidade": "São Paulo", "uf": "SP", "ibge": "3550308", "gia": "1004", "ddd": "11", "siafi": "7107"}');
            res.setStatusCode(200);
            return res;
        }
    }

    public class MockHttpResponseError implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(400);
            res.setBody('Bad Request');
            return res;
        }
    }

    @isTest
    static void testBuscarCepSuccess() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseSuccess());
        Map<String, Object> args = new Map<String, Object>{'input' => new Map<String, Object>{ 'cep' => '01001000' }};

        BuscarEndereco buscarEndereco = new BuscarEndereco();
        
        Object result = buscarEndereco.call('buscarCep', args);
        Map<String, Object> resultMap = (Map<String, Object>) result;
        System.assertEquals('success', resultMap.get('status'));
        BuscarEndereco.CepResponse cepResponse = (BuscarEndereco.CepResponse) resultMap.get('cepResponse');
        System.assertEquals('01001-000', cepResponse.cep);
        System.assertEquals('Praça da Sé', cepResponse.logradouro);
        System.assertEquals('São Paulo', cepResponse.localidade);
        System.assertEquals('SP', cepResponse.uf);
    }

    @isTest
    static void testBuscarCepError() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseError());

        Map<String, Object> args = new Map<String, Object>{
            'input' => new Map<String, Object>{ 'cep' => '01001000' }
        };

        BuscarEndereco buscarEndereco = new BuscarEndereco();
        
        Object result = buscarEndereco.call('buscarCep', args);
        Map<String, Object> resultMap = (Map<String, Object>) result;

        System.assertEquals('error', resultMap.get('status'));
        System.assert(resultMap.get('message') != null, 'Mensagem de erro deve estar presente');
    }

    @isTest
    static void testInvalidAction() {
        Map<String, Object> args = new Map<String, Object>{
            'input' => new Map<String, Object>{ 'cep' => '01001000' }
        };

        BuscarEndereco buscarEndereco = new BuscarEndereco();

        try {
            buscarEndereco.call('acaoInvalida', args);
            System.assert(false, 'Esperava uma exceção para ação inválida');
        } catch (BuscarEndereco.ExtensionMalformedCallException e) {
            System.assertEquals('Method not implemented', e.getMessage());
        }
    }
}
