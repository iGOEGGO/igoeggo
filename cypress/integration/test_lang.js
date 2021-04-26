describe('languages', function() {
  before(function() {
    cy.visit("/");
  });

  it('language change possible', function() {
    cy.get('select[id="goeggo_lang"]').select('en', {force: true});
  });

  it('language changed actually', function() {
    cy.get('span[data-key="Datensatz herunterladen"]').should('contain','Download dataset');
  });

  it('change language back', function() {
    cy.get('select[id="goeggo_lang"]').select('de', {force: true});
  });

  it('language changed actually', function() {
    cy.get('span[data-key="Datensatz herunterladen"]').should('contain','Datensatz herunterladen');
  });
});

 
