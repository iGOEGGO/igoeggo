let temp;

describe('bookmarking', function() {
  before(function() {
    cy.visit("/");
  });

  it('bookmark possible', function() {
    cy.get('a[id="\\.\\_bookmark\\_"]').find('i');
  });

  it('preset', function() {
    cy.get('a[href*="#shiny-tab-tab_plotting"]').click()
    cy.get('select[id="select_plotting_option"]').children().should('contain', 'Scatterplot');
    cy.get('button[id="button_plotting_show"]').click();
    cy.get('button[id="plotting_mod1-plot"]').click();
    cy.get('button[id="button_plotting_show"]').click();
    cy.get('button[id="plotting_mod2-plot"]').click();
    cy.get('select[id="plotting_mod1-scatter_x_var"]').children().should('contain', 'mpg');
    cy.get('select[id="plotting_mod2-scatter_x_var"]').children().should('contain', 'mpg');
  });

  describe('bookmarking without tag and description', function() {
    it('actual bookmarking', function() {
      //force = true is not working on buttons, which cause modals to appear
      cy.get('a[id="._bookmark_"]').click({force: true})
      cy.wait(100);
      cy.get('.modal-footer').find('button[id="saveBM"]').click()
      //  .pipe(click);
      //Fehlersuche
      //cy.get('label[id="bm_name-label"]',{ timeout: 10000 }).should('contain', 'Bookmark');
      // cy.wait(500);
    });
  
    it('check bookmarks', function() {
      //force = true is not working on buttons, which cause modals to appear
      //cy.reload()
      cy.get('a[id="getbm"]').click({force: true})
      //  .pipe(click);
      //Fehlersuche
      //cy.get('label[id="bm_name-label"]',{ timeout: 10000 }).should('contain', 'Bookmark');
      // cy.wait(500);
      cy.get('table[id="DataTables_Table_0"]').contains('td','2021', { timeout: 10000 });
      //cy.get('table[id="DataTables_Table_2"]').contains('td','testtest', { timeout: 10000 });
      cy.get('button[data-dismiss="modal"]').first().click({force: true})
    });
  });

  describe('bookmarking with tag and description', function() {
    it('actual bookmarking', function() {
      //force = true is not working on buttons, which cause modals to appear
      cy.get('a[id="._bookmark_"]').click({force: true});

      cy.get('input[id="bm_name"]').click().type("testtest",{force: true});
      cy.get('input[id="bm_name"]').should('have.value', 'testtest');
      //cy.get('input[id="bm_info"]').type("hallohallo");
      cy.wait(100);
      cy.get('.modal-footer').find('button[id="saveBM"]').click()
      //  .pipe(click);
      //Fehlersuche
      //cy.get('label[id="bm_name-label"]',{ timeout: 10000 }).should('contain', 'Bookmark');
      // cy.wait(500);
    });
  
    it('check bookmarks', function() {
      //force = true is not working on buttons, which cause modals to appear
      //cy.reload()
      cy.get('a[id="getbm"]').click({force: true})
      //  .pipe(click);
      //Fehlersuche
      //cy.get('label[id="bm_name-label"]',{ timeout: 10000 }).should('contain', 'Bookmark');
      // cy.wait(500);
      cy.get('table[id="DataTables_Table_1"]').contains('td','test', { timeout: 10000 });
      //cy.get('table[id="DataTables_Table_1"]').contains('td','hallo', { timeout: 10000 });
      //cy.get('table[id="DataTables_Table_2"]').contains('td','testtest', { timeout: 10000 });
      cy.get('button[data-dismiss="modal"]').first().click({force: true})
    });
  });

  describe('bookmarking compare pages', function() {
    it('actual bookmarking', function() {
      //force = true is not working on buttons, which cause modals to appear
      cy.get('a[id="._bookmark_"]').click({force: true})
      cy.wait(100);
      //  .pipe(click);
      //Fehlersuche
      //cy.get('label[id="bm_name-label"]',{ timeout: 10000 }).should('contain', 'Bookmark');
      // cy.wait(500);
    });
  
    it('compare pages', function() {
      cy.get('p[id="bm_url"]')
        .invoke('text')  // for input or textarea, .invoke('val')
        .then(text => {
          const someText = text;
          temp = someText;
          cy.log(someText);
          // alert(temp);
  
          cy.get('.modal-footer').find('button[id="saveBM"]').click()
  
          cy.get('a[href*="#shiny-tab-tab_modelle"]').click()
  
          //var el = document.createElement( 'html' );
          cy.visit(temp)
          cy.get('a[href*="#shiny-tab-tab_plotting"]').click()
          cy.get('select[id="plotting_mod1-scatter_x_var"]').children().should('contain', 'mpg', { timeout: 10000 });
          cy.get('select[id="plotting_mod2-scatter_x_var"]').children().should('contain', 'mpg', { timeout: 10000 });
          //el.innerHTML = cy.request(temp).body // you can get the request object from cy.request;
          //cy.log(el.innerHTML)
        });     
    });
  });
});

describe('get bookmarks', function() {
  before(function() {
    cy.visit("/");
  });

  it('open bookmarks', function() {
    //force = true is not working on buttons, which cause modals to appear
    cy.get('a[id="getbm"]').click({force: true}, { timeout: 10000 })
    //  .pipe(click);
    //Fehlersuche
    //cy.get('label[id="bm_name-label"]',{ timeout: 10000 }).should('contain', 'Bookmark');
    // cy.wait(500);
    cy.get('button[id="button_ 1"]').click({force: true}, { timeout: 10000 })
  });

  it('check bookmarks', function() {
    //cy.reload()
    //force = true is not working on buttons, which cause modals to appear
    cy.get('a[id="getbm"]').click({force: true})
    //  .pipe(click);
    //Fehlersuche
    //cy.get('label[id="bm_name-label"]',{ timeout: 10000 }).should('contain', 'Bookmark');
    // cy.wait(500);
    cy.get('table[id="DataTables_Table_2"]').contains('td','2021', { timeout: 10000 });
    //cy.get('table[id="DataTables_Table_2"]').contains('td','testtest', { timeout: 10000 });
  });
});

// TODO bessere Überprüfung von Spaltennamen
describe('bookmark with wrong stateid', function() {
  before(function() {
    cy.visit("/?_state_id_=HelloWorld");
  });
  
  it('restore failed', function() {
    cy.get('div[class="shiny-notification-content-text"]').should('contain', 'Error in RestoreContext');
  });
});

describe('bookmark change dataset', function() {
  before(function() {
    cy.visit("/");
  });
  
  it('change dataset to iris', function() {
    cy.get('[id="std"]').select('iris');
	cy.get('div[class="dataTables_info"').should('contain','of 150 entries');
  });
  
  it('create Bookmark', function() {
    cy.get('a[id="._bookmark_"]').click({force: true})
  });
  
  it('open Bookmark', function() {
    cy.get('p[id="bm_url"]')
      .invoke('text')  // for input or textarea, .invoke('val')
      .then(text => {
        const someText = text;
        temp = someText;
        cy.log(someText);
		
        cy.get('.modal-footer').find('button[id="saveBM"]').click()

        cy.visit(temp)
		
		cy.get('div[class="dataTables_info"').should('contain','of 150 entries');
	  });
  });
});

describe('bookmark import multiple datasets', function() {
  before(function() {
    cy.visit("/");
  });
  
  it('dataset uploading', () => {
    cy.fixture('test.csv').then(fileContent => {
        cy.get('input[id="file1"]').attachFile({
            fileContent: fileContent.toString(),
            fileName: 'test.csv',
            mimeType: 'csv'
        });
    });
    cy.get('button[id="etlDataset"]', { timeout: 10000 }).click();
	cy.get('select[id="cName"]', { timeout: 10000 }).should('contain', 'PassengerId');
    cy.get('button[class="confirm"]').click();
	
	cy.get('[id="std"]').select('iris');
	
	cy.fixture('test2.csv').then(fileContent => {
        cy.get('input[id="file1"]').attachFile({
            fileContent: fileContent.toString(),
            fileName: 'test2.csv',
            mimeType: 'csv'
        });
    });
    cy.get('button[id="etlDataset"]', { timeout: 10000 }).click();
	cy.get('select[id="cName"]', { timeout: 10000 }).should('contain', 'PassengerId');
    cy.get('button[class="confirm"]').click();
  });
  
  it('create Bookmark', function() {
    cy.get('a[id="._bookmark_"]').click({force: true})
  });
  
  it('open Bookmark', function() {
    cy.get('p[id="bm_url"]')
      .invoke('text')  // for input or textarea, .invoke('val')
      .then(text => {
        const someText = text;
        temp = someText;
        cy.log(someText);
		
        cy.get('.modal-footer').find('button[id="saveBM"]').click()

        cy.visit(temp)
	  });
  });
  
  it('check dataset dropdown', function() {
    cy.get('select[id="cName"]').should('contain', 'PassengerId', { timeout: 10000 });
	cy.get('[id="std"]').children('option').then(options => {
      const actual = [...options].map(o => o.value)
      expect(actual).to.deep.eq(['iris', 'mtcars', 'test', 'test2'])
    }) 
  });
});

describe('bookmark with transformed dataset', function() {
  before(function() {
    cy.visit("/");
  });
  
  it('transform dataset', () => {
	cy.get('div[data-value="select"]').click({force: true})
	cy.get('div[data-value="filter"]').click({force: true})
	cy.get('[id="user_input"]').type('mpg>21',{force: true}).should('have.value', 'mpg>21');
  cy.get('[id="apply_operation"]').click();
	cy.get('div[class="dataTables_info"', { timeout: 10000 }).should('contain','of 12 entries', { timeout: 10000 });
  });
  
  it('create Bookmark', function() {
    cy.get('a[id="._bookmark_"]').click({force: true})
  });
  
  it('open Bookmark', function() {
    cy.get('p[id="bm_url"]')
      .invoke('text')  // for input or textarea, .invoke('val')
      .then(text => {
        const someText = text;
        temp = someText;
        cy.log(someText);
		
        cy.get('.modal-footer').find('button[id="saveBM"]').click()

        cy.visit(temp)
      });
  });
  
  it('check transformed dataset', function() {
    cy.get('div[class="dataTables_info"').should('contain','of 12 entries');
  });
  
  it('delete all changes', function() {
    cy.get('[id="revert_to_root"').click();
	cy.get('div[class="dataTables_info"').should('contain','of 32 entries');
  });
});

// Test: Bookmark erstellen mit mehreren transformierten Datensätzen

// Test: Plots von allen Typen bookmarken

// Test: Plots von min zwei versch Datensätzen

describe('bookmark change dataset', function() {
  before(function() {
    cy.visit("/");
  });

  it('preset', function() {
    cy.get('a[href*="#shiny-tab-tab_plotting"]').click()

    cy.get('button[id="button_plotting_show"]').click();
    cy.get('button[id="plotting_mod1-plot"]').click();

    cy.get('a[href*="#shiny-tab-tab_transformation"]').click()
    
    cy.get('select[id="std"]').select('iris')

    cy.get('a[href*="#shiny-tab-tab_plotting"]').click()
    cy.get('button[id="button_plotting_show"]').click();
    cy.get('button[id="plotting_mod2-plot"]').click();
    cy.get('div[id="plotting_mod2-scatter_plot"]').click();
  });
  
  it('create Bookmark', function() {
    cy.get('a[id="._bookmark_"]').click({force: true})
  });
  
  it('open Bookmark', function() {
    cy.get('p[id="bm_url"]')
      .invoke('text')  // for input or textarea, .invoke('val')
      .then(text => {
        const someText = text;
        temp = someText;
        cy.log(someText);
		
        cy.get('.modal-footer').find('button[id="saveBM"]').click()

        cy.visit(temp)
		
    cy.get('div[class="dataTables_info"').should('contain','of 150 entries');
    
    cy.get('a[href*="#shiny-tab-tab_plotting"]').click()
    
    cy.get('select[id="plotting_mod1-scatter_x_var"]').children().should('contain', 'mpg');
    cy.get('select[id="plotting_mod2-scatter_x_var"]').children().should('contain', 'Sepal.Length');
	  });
  });
});