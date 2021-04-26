describe('check title', function() {
  before(function() {
    cy.visit("/");
    cy.get('select[id="cName"]').children().should('contain', 'mpg');
  });
  
  it('contains "iGÖGGO" in the title', function() {
    cy.title().should('contain', 'iGÖGGO');
  });
});

describe('tabs', function() {
  describe('change tab with click', function() {
    before(function() {
      cy.visit("/");
      cy.get('select[id="cName"]').children().should('contain', 'mpg');
    });
  
    it('change tab', function() {
      cy.get('a[href*="#shiny-tab-tab_exploration"]').click()
    });
  
    it('check tab', function() {
      cy.get('h2').should('contain', 'Exploration');
    });
  });

  describe('change tab without click', function() {
    before(function() {
      cy.visit("/");
      cy.get('select[id="cName"]').children().should('contain', 'mpg');
    });
  
    it('change tab', function() {
      cy.visit('#shiny-tab-tab_exploration');
    });
  
    it('check tab', function() {
      cy.get('h2').should('contain', 'Exploration');
    });
  });
});