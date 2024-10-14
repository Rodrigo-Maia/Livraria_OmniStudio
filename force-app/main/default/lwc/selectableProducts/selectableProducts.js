import { LightningElement } from 'lwc'
import { OmniscriptBaseMixin } from "omnistudio/omniscriptBaseMixin"
import saveAssets from '@salesforce/apex/SaveAssets.saveAssets'

const columns = [
    { label: 'Nome', fieldName: 'Name'},
    { label: 'Categoria', fieldName: 'Category'},
    { label: 'Quantidade',fieldName: 'Quantity', type: 'number', editable: true, cellAttributes: { alignment: 'center' } },
]

export default class SelectableProducts extends OmniscriptBaseMixin(LightningElement)  {
    data = []
    columns = columns
    saveDraftValues = []
    accountId

    connectedCallback() {
        this.accountId = this.omniJsonData.AccId // Account Id da Livraria
        const jsonData = JSON.parse(JSON.stringify(this.omniJsonData.Products)) // Dados de ENTRADA dos produtos
        this.data = jsonData
    }

    handleSave(event)
    {
        const updateAssets  = {}
        updateAssets['products'] = JSON.stringify(event.detail.draftValues)
        updateAssets['account_Id'] = JSON.stringify(this.accountId)

console.log('updateAssets: ' + JSON.stringify(updateAssets))

        saveAssets({args:updateAssets})
        .then( result => {

console.log('apex result: ' + result);

        })
        .catch(error => {

console.log('error: ' + JSON.stringify(error));

        })
    }
}