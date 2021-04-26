describe('check title', function() {
  before(function() {
    cy.visit("/");
    cy.get('select[id="cName"]').children().should('contain', 'mpg');
  });
  
  it('contains "iGÖGGO" in the title', function() {
    cy.title().should('contain', 'iGÖGGO');
  });
});

describe('export', function() {
  before(function() {
    cy.visit("/");
    cy.get('a[href*="#shiny-tab-tab_plotting"]').click()
    cy.get('select[id="select_plotting_option"]').children().should('contain', 'Scatterplot');
  });

  it('create scatterplot', function() {
    cy.get('button[id="button_plotting_show"]').click();
    cy.get('button[id="plotting_mod1-plot"]').click();
  });

  it('export scatterplot', function() {
    cy.get('button[id="plotting_mod1-export_plot"]').click();
    cy.get('a[id="plotting_mod1-export_save_plot"]').click();
    cy.get('button[data-dismiss="modal"]').click();
  });
});


describe('plotly', function() {
  before(function() {
    cy.visit("/");
    cy.get('a[href*="#shiny-tab-tab_plotting"]').click()
    cy.get('select[id="select_plotting_option"]').children().should('contain', 'Scatterplot');
  });

  it('create lineplot', function() {
    cy.get('div[data-value="scatter"]').click({force: true})
    cy.get('div[data-value="lineplot"]').click({force: true})
    cy.get('button[id="button_plotting_show"]').click({force: true}, { timeout: 10000 });
    cy.get('button[id="plotting_mod1-plot"]').click();
    //cy.readFile('cypress/downloads/download.html')
  });

  it('export lineplot', function() {
    //cy.get('button[id="plotting_mod1-plot"]').click({ timeout: 10000 }, {force: true});
    cy.get('a[data-title="Download plot as a png"]').click({ timeout: 10000 }, {force: true});
    cy.readFile('cypress/downloads/newplot.png')
  });
});