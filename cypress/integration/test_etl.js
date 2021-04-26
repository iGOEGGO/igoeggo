describe('new Column-Name', function() {
  describe('new Column-Name - file', function() {
    before(function() {
      cy.visit("/");
      cy.get('select[id="cName"]').children().should('contain', 'mpg');
    });
    
    it('contains "iGÖGGO" in the title', function() {
      cy.title().should('contain', 'iGÖGGO');
    });

    it('preset', () => {
      cy.fixture('test.csv').then(fileContent => {
          cy.get('input[id="file1"]').attachFile({
              fileContent: fileContent.toString(),
              fileName: 'test.csv',
              mimeType: 'csv'
          });
      });
  
      cy.get('button[id="etlDataset"]', { timeout: 10000 }).click();
      cy.get('select[id="cName"]', { timeout: 10000 }).should('contain', 'PassengerId');
      //cy.get('a[id="changeLang"]').click({ force: true });
      cy.get('button[class="confirm"]').click();
      //Entsprechender Auswahl mittels Value setzen
      cy.get('select[id="cName"]').children().should('contain', 'PassengerId');
      cy.get('select[id="cName"]').children().should('contain', 'Pclass');
    });

    it('upload name csv', () => {
      cy.fixture('names.csv').then(fileContent => {
          cy.get('input[id="file2"]').attachFile({
              fileContent: fileContent.toString(),
              fileName: 'names.csv',
              mimeType: 'csv'
          });
      });
  
      /*cy.get('select[id="cName"]', { timeout: 10000 }).should('contain', 'PassengerId');
      //cy.get('a[id="changeLang"]').click({ force: true });
      cy.get('button[class="confirm"]').click();
      //Entsprechender Auswahl mittels Value setzen
      cy.get('select[id="cName"]').children().should('contain', 'PassengerId');
      cy.get('select[id="cName"]').children().should('contain', 'Pclass');*/
    });
  
    it('change Column-Name', function() {
      cy.get('button[id="changeColumnNames"]', { timeout: 10000 }).click({force: true});
    });
  
    it('check Column-Name', function() {
      cy.get('select[id="cName"]').children().should('contain', 'Test1');
    });
  });

  describe('new Column-Name - input', function() {
    before(function() {
      cy.visit("/");
      cy.get('select[id="cName"]').children().should('contain', 'mpg');
    });
    
    it('contains "iGÖGGO" in the title', function() {
      cy.title().should('contain', 'iGÖGGO');
    });
  
    it('change Column-Name', function() {
      cy.get('input[id="cNameNew"]').type('testNeu')
      cy.get('button[id="changeColumnName"]').click();
    });
  
    it('check Column-Name', function() {
      cy.get('select[id="cName"]').children().should('contain', 'testNeu');
    });
  });
});

describe('externer Datensatz', function() {
  before(function() {
    cy.visit("/");
    cy.get('select[id="cName"]').children().should('contain', 'mpg');
  });

  it('Testing dataset uploading', () => {
    cy.fixture('test.csv').then(fileContent => {
        cy.get('input[id="file1"]').attachFile({
            fileContent: fileContent.toString(),
            fileName: 'test.csv',
            mimeType: 'csv'
        });
    });

    cy.get('button[id="etlDataset"]', { timeout: 10000 }).click();
    cy.get('select[id="cName"]', { timeout: 10000 }).should('contain', 'PassengerId');
    //cy.get('a[id="changeLang"]').click({ force: true });
    cy.get('button[class="confirm"]').click();
    //Entsprechender Auswahl mittels Value setzen
    cy.get('select[id="cName"]').children().should('contain', 'PassengerId');
    cy.get('select[id="cName"]').children().should('contain', 'Pclass');
  });

  /*it('check Column-Name', function() {
    cy.get('select[id="cName"]').children().should('contain', 'mpg');
  });*/
});

describe('empty values', function() {
  before(function() {
    cy.visit("/");
    cy.get('select[id="cName"]').children().should('contain', 'mpg');
  });

  it('Testing dataset uploading', () => {
    cy.fixture('test3.csv').then(fileContent => {
        cy.get('input[id="file1"]').attachFile({
            fileContent: fileContent.toString(),
            fileName: 'test3.csv',
            mimeType: 'csv'
        });
    });

    cy.get('button[id="etlDataset"]', { timeout: 10000 }).click();
    cy.get('button[id="dateformatok"]', { timeout: 10000 }).click();
    cy.get('select[id="cName"]', { timeout: 10000 }).should('contain', 'test11');
    //cy.get('a[id="changeLang"]').click({ force: true });
    //cy.get('button[class="confirm"]').click();
  });

  it('empty columns', () => {
    cy.get('.sweet-alert').find('h2').should('contain','leere Spalten')
    cy.get('button[class="confirm"]').click();
  });

  /*it('check Column-Name', function() {
    cy.get('select[id="cName"]').children().should('contain', 'mpg');
  });*/
});

describe('new Datatype', function() {
  describe('character', function() {
    before(function() {
      cy.visit("/");
      cy.get('select[id="cName"]').children().should('contain', 'mpg');
    });
  
    it('change Datatype', function() {
      cy.get('select[id="cDatatype"]').select('character', { force: true })
      cy.get('button[id="changeDatatype"]').click();
    });
  
    it('check Datatype', function() {
      cy.get('select[id="cName"]').children().should('contain', 'mpg');
    });
  });

  describe('factors', function() {
    before(function() {
      cy.visit("/");
      cy.get('select[id="cName"]').children().should('contain', 'mpg');
    });
  
    it('Testing dataset uploading', () => {
      cy.fixture('test.csv').then(fileContent => {
          cy.get('input[id="file1"]').attachFile({
              fileContent: fileContent.toString(),
              fileName: 'test.csv',
              mimeType: 'csv'
          });
      });
  
      cy.get('button[id="etlDataset"]', { timeout: 10000 }).click();
      cy.get('select[id="cName"]', { timeout: 10000 }).should('contain', 'PassengerId');
      // cy.get('a[href="#shiny-tab-tab_transformation"]').click({ force: true });
      //cy.get('body').type('{esc}');
      cy.get('button[class="confirm"]').click();
      //cy.get('#shiny-modal').invoke('hide')
      //Entsprechender Auswahl mittels Value setzen
      cy.get('select[id="cName"]').children().should('contain', 'PassengerId');
      cy.get('select[id="cName"]').children().should('contain', 'Pclass');
    });

    it('change Datatype', function() {
      cy.get('select[id="cColumn"]').select('Pclass')
      cy.get('select[id="cDatatype"]').select('factor')
      cy.get('button[id="changeDatatype"]').click();
      //cy.get('input[id="factors"]').type('unten, mitte, oben').should('have.value', 'unten, mitte, oben')
      cy.get('input[id="factors"]').invoke('val', 'unten, mitte, oben').should('have.value', 'unten, mitte, oben');
      cy.get('button[id="ok"]').click();
      cy.wait(1000);
      cy.get('tfoot', { timeout: 10000 }).children().should('contain','factor')
    });
  });
});

 
