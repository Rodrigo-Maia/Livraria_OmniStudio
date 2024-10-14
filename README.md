# Salesforce OmniStudio Project

A Org utilizada para o desenvolvimento é uma Developer Edition OmniStudio.

A Livraria consiste em um componente que CRIA uma Account, do tipo customizado 'Livraria', e define os produtos comercializados por ela.
O fluxo é guiado e criado em OmniStudio com campos autoprrenchidos, dependendo dos inputs de entrada, validações, carregamentoe e salvamento feitos com as ferrrarmntas DataRaptor, Integration Procedure, FlexiCards e outros.
Para cada Livraria criada é criada uma Oportunidade via FLOW TRIGGER.
No fluxo o usuário define o tipo de Produto, a Unidade de interesse e sua Quantidade.
O processo foi automatizado no preenchimento do endereço, via API externa ViaCEP, com uma chamada Externa tipo GET.
O preenchimento dos campos para os tipos de produtos disponíveis (RecordTypes) é feito no carregaento da página por uma TRIGGER e tem os campos PickList preenchidos por uma classe Apex customizada.

A atuação para o desenvolvimento envolveu:
- Criação de Aplicativo
- Criação de Perfil Vendedor
- Criação de permission set
- Criação de campos
- Criação de recordtype
- Criação de omniscript
- Criação de integration procedure
- Criação de data raptors (Extract,Post, transform)
- Criação de flexcard
- Criação de flow
- Criação de Classe para chamada de serviço
- Criação de Classe de teste
