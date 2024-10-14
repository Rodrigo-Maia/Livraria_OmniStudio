public with sharing class SaveAssets {

    @AuraEnabled(cacheable = false)
    public static void saveAssets(Object args)
    {
        try {
            Map<Object, Object> assets = (Map<Object,Object>)args;
            String tempId  = (String)assets.get('account_Id');

            if (tempId.startsWith('"') && tempId.endsWith('"')) {
                tempId = tempId.substring(1, tempId.length() - 1);
            }

            Id accountId  = (Id)tempId;
            String products  = (String)assets.get('products');
            
            List<Object> productsList = (List<Object>) JSON.deserializeUntyped(products);

            List<Asset> assetsCreation = new List<Asset>();
            List<Asset> assetsUpdation = new List<Asset>();
            List<String> productsId = new List<String>();
            List<Map<String, Object>> quantityList = new List<Map<String, Object>>();

            for (Object productObj : productsList) {
                Map<String,Object> productMap = (Map<String,Object>) productObj;
                String quantityStr = (String)productMap.get('Quantity');

                if (!String.isBlank(quantityStr)) {
                    String productId = (String)productMap.get('ProductId');
                    productsId.add(productId);

                    Map<String, Object> quantityMap = new Map<String, Object>();
                    quantityMap.put('quantityStr', quantityStr);
                    quantityMap.put('productId', productId);
                    quantityList.add(quantityMap);
                }
            }

            List<Product2> supportPrds = [SELECT Id, Name, ProductCode, Categoria__c, RecordTypeId FROM Product2 WHERE Id IN :productsId];
            String recordType = supportPrds[0].RecordTypeId == '012Hu000001NUcyIAG' ? 'Livro' : 'Revista';

            for (Product2 prd : supportPrds) {
                List<Asset> existentAssetList = [SELECT Id, Quantity FROM Asset WHERE Product2Id = :prd.Id AND AccountId = :accountId LIMIT 1];
                Integer quantityFinded = 0;
                Asset existentAsset;
    
                if (!existentAssetList.isEmpty()) {
                    existentAsset = existentAssetList[0];
                    quantityFinded = Integer.valueOf(existentAsset.Quantity);
                }

                for (Map<String, Object> qntt : quantityList) {
                    String rt = (String)qntt.get('productId');

                    if (prd.Id == rt) {
                        Integer quantity = Integer.valueOf(qntt.get('quantityStr'));

                         if (quantityFinded == 0) {
                            Asset asst = new Asset();
                            asst.Name = prd.Name;
                            asst.AccountId = accountId;
                            asst.Product2Id = prd.Id;
                            asst.Categoria__c = prd.Categoria__c;
                            asst.Quantity = quantity;
                            assetsCreation.add(asst);
                        } else {
                            existentAsset.Quantity = quantity + quantityFinded;
                            assetsUpdation.add(existentAsset);
                        }
                    }
                }
    
            }

            if (assetsUpdation.size() > 0) {
               update assetsUpdation; 
            }

            if (assetsCreation.size() > 0) {
                insert assetsCreation;
            }

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

    }
}