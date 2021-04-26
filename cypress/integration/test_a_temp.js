const url = '127.0.0.1:3456'
//const url = 'http://igoeggo.herokuapp.com'

describe('testselect', function() {
    before(function() {
      cy.visit("/");
    });
  
    //selectize-Auswahl moeglich
    it('testselect', function() {
        cy.get('div[data-value="select"]').click({force: true})
        // cy.contains('.selectize-dropdown-content', 'mutate').click()
        cy.get('div[data-value="mutate"]').click({force: true})
    });
  });
